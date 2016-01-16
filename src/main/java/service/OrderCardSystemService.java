package service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import entity.MenuItem;
import entity.OCSObject;
import entity.OrderCard;
import entity.OrderCardDetail;

@Service(value="OrderCardSystemService")
@Transactional
@EnableTransactionManagement
public class OrderCardSystemService {
    
    @Resource
    private DataSource dataSource;
    
    //其實引入hibernate以後就不需要JDBC Template了
    @Resource
    private JdbcTemplate jdbcTemplate;
    
    @Resource
    private SessionFactory sessionFactory;
    
    @SuppressWarnings("unchecked")
    public List<OrderCard> query(OCSObject ocsObject){
        String searchDate = ocsObject.getParamMap().get("searchDate").toString();
        List<OrderCard> orderCardList = new ArrayList<OrderCard>();
        try{
            Session session = sessionFactory.getCurrentSession();
            orderCardList = session.createQuery("from OrderCard  WHERE ORDER_TIME = to_date('"+searchDate+"','YYYYMMDD') order by createTime, guid ").list();
        }catch(Exception e){
            e.printStackTrace();
        }
        return orderCardList;
    }
    
    @SuppressWarnings("unchecked")
    public OCSObject menuItemQuery(OCSObject ocsObject){
        List<Map<String,Object>> gridDataList = new ArrayList<Map<String,Object>>();
        
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT MENU_ITEM.*, false isCheck FROM MENU_ITEM ");
        if("Y".equals(ocsObject.getParamMap().get("system"))){
            sql.append("  where IS_SOLDOUT = false ");
        }
        sql.append(" Order by ITEM_TYPE ");

        gridDataList = jdbcTemplate.queryForList(sql.toString());

        ocsObject.setGridData(gridDataList);
        return ocsObject;
    }
    
    public Map<String, Object> getOrderCard(String cardGuid){
        Map<String, Object> orderCard = null;
        try{
            orderCard = jdbcTemplate.queryForList(" SELECT * FROM ORDER_CARD where guid = '"+cardGuid+"' ").get(0);
        }catch(IndexOutOfBoundsException e){
            //e.printStackTrace();
        }
        
        return orderCard;
    }
    
    public List<Map<String,Object>> query_detail(String cardGuid){
        List<Map<String,Object>> gridData = new ArrayList<Map<String,Object>>();
        gridData = jdbcTemplate.queryForList(" SELECT * FROM ORDER_CARD_DETAIL where card_guid = '"+cardGuid+"' ");
        
        return gridData;
    }
    
    public Boolean orderCardSave(Map<String,Object> orderCard, List<Map<String,Object>> gridData){
        Boolean isSuccess = true;
        try {
            Session session = sessionFactory.getCurrentSession();
            OrderCard orderCardE = new OrderCard();
            if(StringUtils.isBlank((String)orderCard.get("GUID"))){
                //Insert
                orderCard.put("GUID",UUID.randomUUID().toString());
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                orderCardE.setCreateTime(sdf.parse(MapUtils.getString(orderCard, "ORDER_TIME")));
                orderCardE.setOrderTime(new Date());
            } else {
                orderCardE = (OrderCard)session.get(OrderCard.class, (String)orderCard.get("GUID"));
            }
            
            orderCardE.setGuid((String)orderCard.get("GUID"));
            orderCardE.setTableNum(MapUtils.getInteger(orderCard, "TABLE_NUM"));
            orderCardE.setSumPrice(MapUtils.getInteger(orderCard, "SUM_PRICE", 0));
            orderCardE.setCardStatus(MapUtils.getBoolean(orderCard, "CARD_STATUS", false));
            orderCardE.setModifyTime(new Date());
            orderCardE.setOrderCardDetails(new ArrayList<OrderCardDetail>());
            //session.saveOrUpdate(orderCardE);
            
            String existDetailGuid = "";
            for(Map<String,Object> detailData : gridData){
                OrderCardDetail orderCardDetail = new OrderCardDetail();
                
                String detailGuid = MapUtils.getString(detailData, "GUID", "");
                if(StringUtils.isBlank(detailGuid)){
                    //Insert
                    detailData.put("GUID",UUID.randomUUID().toString());
                    orderCardDetail.setCreateTime(new Date());
                } else {
                    orderCardDetail = (OrderCardDetail)session.get(OrderCardDetail.class, (String)detailData.get("GUID"));
                }
                
                orderCardDetail.setGuid((String)detailData.get("GUID"));
                orderCardDetail.setCardGuid((String)orderCard.get("GUID"));
                orderCardDetail.setItemGuid((String)detailData.get("ITEM_GUID"));
                orderCardDetail.setDetailName(MapUtils.getString(detailData, "DETAIL_NAME", ""));
                orderCardDetail.setDetailPrice(MapUtils.getInteger(detailData, "DETAIL_PRICE", 0));
                orderCardDetail.setDetailNum(MapUtils.getInteger(detailData, "DETAIL_NUM", 0));
                orderCardDetail.setDetailMemo(MapUtils.getString(detailData, "DETAIL_MEMO", ""));
                orderCardDetail.setIsOut(MapUtils.getBoolean(detailData, "IS_OUT", false));
                
                orderCardE.getOrderCardDetails().add(orderCardDetail);
                session.saveOrUpdate(orderCardDetail);
                //existDetailGuid += MapUtils.getString(detailData, "GUID", "") +"', '";
            }
            session.saveOrUpdate(orderCardE);
            //session.createSQLQuery(" delete from ORDER_CARD_DETAIL where guid not in ('"+existDetailGuid+"') AND CARD_GUID =  '"+orderCard.get("GUID")+"' ").executeUpdate();

        } catch(Exception e){
            e.printStackTrace();
            isSuccess = false;
        }
        return isSuccess;
    }

    public Boolean orderCardDelete(String guid){
        Session session = sessionFactory.getCurrentSession();
        session.delete(new OrderCard(guid));

        return true;
    }
    
    @SuppressWarnings("unchecked")
    public void orderCardPayed(String guid){
        jdbcTemplate.execute(" update ORDER_CARD set CARD_STATUS = (case when CARD_STATUS then false else true end), MODIFY_TIME = sysdate where guid = '"+guid+"' ");
    }
    
    @SuppressWarnings("unchecked")
    public void cardDetailOut(String guid){
        jdbcTemplate.execute(" update ORDER_CARD_DETAIL set IS_OUT = (case when IS_OUT then false else true end) where guid = '"+guid+"' ");
    }

    public Boolean menuEditSave(Map<String,Object> menuItem){
        Boolean isSuccess = true;
        
        Session session = sessionFactory.getCurrentSession();
        MenuItem menuItemE = new MenuItem();
        

        try {
            if(StringUtils.isBlank((String)menuItem.get("GUID"))){
                //Insert
                menuItem.put("GUID",UUID.randomUUID().toString());
            }

            menuItemE.setGuid((String)menuItem.get("GUID"));
            menuItemE.setItemName(MapUtils.getString(menuItem, "ITEM_NAME", ""));
            menuItemE.setItemType(MapUtils.getInteger(menuItem, "ITEM_TYPE"));
            menuItemE.setItemPrice(MapUtils.getInteger(menuItem, "ITEM_PRICE",0));
            menuItemE.setItemCost(MapUtils.getInteger(menuItem, "ITEM_COST",0));
            menuItemE.setItemDescription(MapUtils.getString(menuItem, "ITEM_DESCRIPTION",""));
            menuItemE.setItemMemo(MapUtils.getString(menuItem, "ITEM_MEMO",""));
            menuItemE.setIsSoldout(MapUtils.getBoolean(menuItem, "IS_SOLDOUT",false));
            menuItemE.setCreateTime(new Date());
            
            session.saveOrUpdate(menuItemE);
            
        } catch(Exception e){
            e.printStackTrace();
            isSuccess = false;
        }
        return isSuccess;
    }

    public Boolean menuEditDelete(String guid){
        Boolean isSuccess = true;
        try {
            Session session = sessionFactory.getCurrentSession();
            MenuItem menuItem = new MenuItem(guid);
            session.delete(menuItem);
        } catch(Exception e){
            e.printStackTrace();
            isSuccess = false;
        }
        return isSuccess;
    }
    
    public Boolean menuEditSoldout(String guid){
        Boolean isSuccess = true;
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" update MENU_ITEM set IS_SOLDOUT = (case when IS_SOLDOUT then false else true end) where guid = '"+guid+"'");
            jdbcTemplate.execute(sql.toString());
        } catch(Exception e){
            e.printStackTrace();
            isSuccess = false;
        }
        return isSuccess;
    }

    @SuppressWarnings("unchecked")
    public List<Map<String,Object>>  historyPieQuery(OCSObject ocsObject){
        List<Map<String,Object>> resultList = jdbcTemplate.queryForList(generateHSQL(ocsObject));

        List<Map<String,Object>> gridList = new ArrayList<Map<String,Object>>();
        for(Map<String,Object> result : resultList){
            Map<String,Object> grid = new HashMap<String,Object>();
            for(String key : result.keySet()){
                grid.put(StringUtils.lowerCase(key), result.get(key));
            };
            gridList.add(grid);
        }
        return gridList;
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String,Object>>  historyGridQuery(OCSObject ocsObject){
        List<Map<String,Object>> resultList = jdbcTemplate.queryForList(generateHSQL(ocsObject));
        
        List<Map<String,Object>> gridList = new ArrayList<Map<String,Object>>();
        for(Map<String,Object> result : resultList){
            Map<String,Object> grid = new HashMap<String,Object>();
            for(String key : result.keySet()){
                grid.put(StringUtils.lowerCase(key), result.get(key));
            };
            gridList.add(grid);
        }
        return gridList;
    }
    
    private String generateHSQL(OCSObject ocsObject){
        Object searchType = ocsObject.getParamMap().get("searchType");
        
        StringBuffer sql = new StringBuffer();
        
        if("0".equals(searchType)){
            sql.append(" SELECT ITEM_TYPE label, ");
            sql.append("        SUM(DETAIL_PRICE) data,  ");
            sql.append("        SUM(DETAIL_NUM) num  ");
            sql.append("   FROM ORDER_CARD O  ");
            sql.append("   LEFT JOIN ORDER_CARD_DETAIL D ON O.GUID = D.CARD_GUID ");
            sql.append("   LEFT JOIN MENU_ITEM M ON M.GUID = D.ITEM_GUID ");
            
            String searchSDate = ocsObject.getParamMap().get("searchSDate").toString();
            sql.append(" WHERE ORDER_TIME >= to_date('"+searchSDate+"','YYYYMMDD')");
            
            String searchEDate = ocsObject.getParamMap().get("searchEDate").toString();
            sql.append("   AND ORDER_TIME <= to_date('"+searchEDate+"','YYYYMMDD')");
            sql.append("  GROUP BY ITEM_TYPE  ");
            
        } else if("1".equals(searchType)){
            sql.append(" SELECT to_char(ORDER_TIME,'YY/MM/DD') label, ");
            sql.append("        SUM(DETAIL_PRICE) data,  ");
            sql.append("        SUM(DETAIL_NUM) num  ");
            sql.append("   FROM ORDER_CARD O  ");
            sql.append("   LEFT JOIN ORDER_CARD_DETAIL D ON O.GUID = D.CARD_GUID ");
            sql.append("   LEFT JOIN MENU_ITEM M ON M.GUID = D.ITEM_GUID ");
            
            String searchSDate = ocsObject.getParamMap().get("searchSDate").toString();
            sql.append(" WHERE ORDER_TIME >= to_date('"+searchSDate+"','YYYYMMDD')");
            
            String searchEDate = ocsObject.getParamMap().get("searchEDate").toString();
            sql.append("   AND ORDER_TIME <= to_date('"+searchEDate+"','YYYYMMDD')");
            sql.append("  GROUP BY ORDER_TIME  ");
            
        } else if("2".equals(searchType)){
            sql.append(" SELECT TABLE_NUM label, ");
            sql.append("        SUM(DETAIL_PRICE) data,  ");
            sql.append("        SUM(DETAIL_NUM) num  ");
            sql.append("   FROM ORDER_CARD O  ");
            sql.append("   LEFT JOIN ORDER_CARD_DETAIL D ON O.GUID = D.CARD_GUID ");
            sql.append("   LEFT JOIN MENU_ITEM M ON M.GUID = D.ITEM_GUID ");
            
            String searchSDate = ocsObject.getParamMap().get("searchSDate").toString();
            sql.append(" WHERE ORDER_TIME >= to_date('"+searchSDate+"','YYYYMMDD')");
            
            String searchEDate = ocsObject.getParamMap().get("searchEDate").toString();
            sql.append("   AND ORDER_TIME <= to_date('"+searchEDate+"','YYYYMMDD')");
            sql.append("  GROUP BY TABLE_NUM ");
        } else {
            sql.append(" SELECT O.GUID, ");
            sql.append("        O.TABLE_NUM, ");
            sql.append("        O.SUM_PRICE, ");
            sql.append("        O.ORDER_TIME, ");
            sql.append("        O.CREATE_TIME, ");
            sql.append("        D.GUID DETAIL_GUID, ");
            sql.append("        D.DETAIL_NAME, ");
            sql.append("        D.DETAIL_NUM, ");
            sql.append("        D.DETAIL_PRICE, ");
            sql.append("        D.DETAIL_MEMO ");
            sql.append("   FROM ORDER_CARD O  ");
            sql.append("   LEFT JOIN ORDER_CARD_DETAIL D ON O.GUID = D.CARD_GUID ");
            
            String searchSDate = ocsObject.getParamMap().get("searchSDate").toString();
            sql.append(" WHERE ORDER_TIME >= to_date('"+searchSDate+"','YYYYMMDD')");
            
            String searchEDate = ocsObject.getParamMap().get("searchEDate").toString();
            sql.append("   AND ORDER_TIME <= to_date('"+searchEDate+"','YYYYMMDD')");
            sql.append("  order by ORDER_TIME, TABLE_NUM, GUID  ");
        }
        System.out.print(sql.toString());
        return sql.toString();
    }

}

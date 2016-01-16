package action;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.json.JSONUtil;
import org.springframework.stereotype.Controller;

import service.OrderCardSystemService;

import com.opensymphony.xwork2.ActionSupport;

import entity.OCSObject;

@Controller(value="OrderCardSystemAction")
@Result(type="stream")
public class OrderCardSystemAction extends ActionSupport{

    private static final long serialVersionUID = 1L;
    
    private String cardGuid;
    public String getCardGuid() {
        return cardGuid;
    }
    public void setCardGuid(String cardGuid) {
        this.cardGuid = cardGuid;
    }


    private OCSObject oscObject = new OCSObject();
    public OCSObject getOscObject() {
        return oscObject;
    }
    public void setOscObject(OCSObject oscObject) {
        this.oscObject = oscObject;
    }

    @Resource(name="OrderCardSystemService")
    private OrderCardSystemService service;
    
    //取得系統設定參數
    @Action(value="getSystemSetting")
    public String getSystemSetting() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        Map<String,Object> results = new HashMap<String,Object>();
        
        oscObject.getParamMap().put("system","Y");
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        //results.put("typeItemList", arg1);
        //results.put("memoItemList", arg1);
        results.put("menuItemList", service.menuItemQuery(oscObject).getGridData());
        out.println(JSONUtil.serialize(results));
        out.flush();
        return null;
    }
    
    //點餐 - 進入點餐列表
    @Action(value="load" ,results={@Result(location="/jsp/OrderCardSystem/OrderCardQuery.jsp")} )
    public String load(){
        return SUCCESS;
    }

    //點餐 - 載入點餐列表
    @Action(value="query")
    public String query() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        String searchDate = ServletActionContext.getRequest().getParameter("searchDate");
        oscObject.getParamMap().put("searchDate", searchDate);
        out.println(JSONUtil.serialize(service.query(oscObject)));
        out.flush();
        return null;
    }

    //點餐 - 載入點餐卡片明細
    @Action(value="query_detail")
    public String query_detail() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        
        Map<String,Object> results = new HashMap<String,Object>();
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        results.put("orderCard",service.getOrderCard(cardGuid));
        results.put("gridData", service.query_detail(cardGuid));
        out.println(JSONUtil.serialize(results));
        out.flush();
        return null;
    }
    
    //點餐 - 儲存點餐卡片
    @SuppressWarnings("unchecked")
    @Action(value="orderCardSave")
    public String orderCardSave() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        Map<String,Object> results = new HashMap<String,Object>();
        try{
            Map<String,Object> orderCard = (Map<String, Object>) JSONUtil.deserialize(ServletActionContext.getRequest().getParameter("orderCard"));
            String searchDate = ServletActionContext.getRequest().getParameter("searchDate");
            orderCard.put("ORDER_TIME", searchDate);
            String detailGridDataString = ServletActionContext.getRequest().getParameter("detailGridData");
            List<Map<String,Object>> detailGridData = (List<Map<String, Object>>) JSONUtil.deserialize(detailGridDataString);
            service.orderCardSave(orderCard,detailGridData);
        } catch(Exception e){
            e.printStackTrace();
        }
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        out.println(JSONUtil.serialize(results));
        out.flush();
        
        return null;
    }

    //點餐 - 刪除點餐卡片
    @Action(value="orderCardDelete")
    public String orderCardDelete() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        Map<String,Object> results = new HashMap<String,Object>();
        try{
            String guid = ServletActionContext.getRequest().getParameter("guid");
            service.orderCardDelete(guid);
        } catch(Exception e){
            e.printStackTrace();
        }
        
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        out.println(JSONUtil.serialize(results));
        out.flush();
        return null;
    }
    
    //點餐 - 是否付款
    @Action(value="orderCardPayed")
    public String orderCardPayed() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");

        String guid = ServletActionContext.getRequest().getParameter("guid");
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        service.orderCardPayed(guid);
        out.flush();
        return null;
    }
    
    //點餐 - 已出餐
    @Action(value="cardDetailOut")
    public String cardDetailOut() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        
        String guid = ServletActionContext.getRequest().getParameter("guid");
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        service.cardDetailOut(guid);
        out.flush();
        return null;
    }
    
    //編輯菜單 - 進入菜單列表
    @Action(value="menuLoad" ,results={@Result(location="/jsp/OrderCardSystem/MenuItemQuery.jsp")} )
    public String menuLoad(){
        return SUCCESS;
    }
    
    //編輯菜單 - 載入菜單列表
    @Action(value="menuQuery")
    public String menuQuery() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        oscObject = service.menuItemQuery(oscObject);
        out.println(JSONUtil.serialize(oscObject.getGridData()));
        out.flush();
        return null;
    }
    
    //編輯菜單 - 儲存菜單
    @Action(value="menuEditSave")
    public String menuEditSave() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        Map<String,Object> results = new HashMap<String,Object>();
        try{
            Map<String,Object> menuItem = (Map<String, Object>) JSONUtil.deserialize(ServletActionContext.getRequest().getParameter("menuItem"));
            service.menuEditSave(menuItem);
        } catch(Exception e){
            e.printStackTrace();
        }
        
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        out.println(JSONUtil.serialize(results));
        out.flush();
        return null;
    }
    
    //編輯菜單 - 刪除菜單
    @Action(value="menuEditDelete")
    public String menuEditDelete() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        Map<String,Object> results = new HashMap<String,Object>();
        try{
            String guid = ServletActionContext.getRequest().getParameter("guid");
            service.menuEditDelete(guid);
        } catch(Exception e){
            e.printStackTrace();
        }
        
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        out.println(JSONUtil.serialize(results));
        out.flush();
        return null;
    }
    
    //編輯菜單 - 是否停售
    @Action(value="menuEditSoldout")
    public String menuEditSoldout() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        Map<String,Object> results = new HashMap<String,Object>();
        try{
            String guid = ServletActionContext.getRequest().getParameter("guid");
            service.menuEditSoldout(guid);
        } catch(Exception e){
            e.printStackTrace();
        }
        
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        out.println(JSONUtil.serialize(results));
        out.flush();
        return null;
    }

    //營收 - 進入營收頁面
    @Action(value="historyLoad" ,results={@Result(location="/jsp/OrderCardSystem/HistoryQuery.jsp")} )
    public String historyLoad(){
        return SUCCESS;
    }

    //營收 - 查詢營收資料
    @Action(value="historyQuery")
    public String historyQuery() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        String searchSDate = ServletActionContext.getRequest().getParameter("searchSDate");
        oscObject.getParamMap().put("searchSDate", searchSDate);
        String searchEDate = ServletActionContext.getRequest().getParameter("searchEDate");
        oscObject.getParamMap().put("searchEDate", searchEDate);
        
        String searchType = ServletActionContext.getRequest().getParameter("searchType");
        oscObject.getParamMap().put("searchType", searchType);
        
        List<Map<String, Object>> pieChartData = service.historyPieQuery(oscObject);
        
        oscObject.getParamMap().put("searchType","");
        List<Map<String, Object>> gridData = service.historyPieQuery(oscObject);
        
        Map<String, Object> results = new HashMap<String, Object>();
        PrintWriter out = ServletActionContext.getResponse().getWriter();
        results.put("pieChartData", pieChartData);
        results.put("gridData", gridData);
        out.println(JSONUtil.serialize(results));
        out.flush();
        return null;
    }
    
    //營收 - Excel 
    @Action(value="exportExcel", 
            results={@Result(name="success",type="stream",params={
                    "contentType","application/octet-stream",
                    "inputName","downloadFile",
                    "contentDisposition","attachment;filename='${downloadFileName}'",
                    "bufferSize","4096"
                    })
            })
    public String exportExcel(){
        return SUCCESS;
    }
    
    //Excel File Name
    String downloadFileName;
    public void setDownloadFileName(String downloadFileName) {
        this.downloadFileName = downloadFileName;
    }
    public String getDownloadFileName() throws UnsupportedEncodingException {
        String userAgent = ServletActionContext.getRequest().getHeader("User-Agent");
        //瀏覽器判斷
        if (userAgent.indexOf("MSIE") != -1 ||userAgent.indexOf("Trident") != -1) {
            //IE
            return java.net.URLEncoder.encode(downloadFileName,"UTF-8");
        } else {
            return new String(downloadFileName.getBytes("UTF-8"),"ISO-8859-1");
        }
    }
    
    public InputStream getDownloadFile() throws Exception{
        ServletActionContext.getResponse().setContentType("text/html;charset=UTF-8");
        
        String searchSDate = ServletActionContext.getRequest().getParameter("searchSDate");
        oscObject.getParamMap().put("searchSDate", searchSDate);
        String searchEDate = ServletActionContext.getRequest().getParameter("searchEDate");
        oscObject.getParamMap().put("searchEDate", searchEDate);
        List<Map<String, Object>> resultList = service.historyPieQuery(oscObject);
        
        
        //Excel檔案名稱
        setDownloadFileName(searchSDate + "-" + searchEDate+"-"+getText("title.excel")+".xls");
        
        //Excel模板路径
        ByteArrayOutputStream os = new ByteArrayOutputStream();  
        try{
            HSSFWorkbook wb = new HSSFWorkbook();
            Sheet sheet = wb.createSheet();
            Row titleRow = sheet.createRow(0);
            titleRow.createCell(0).setCellValue(getText("grid.TABLE_NUM"));
            titleRow.createCell(1).setCellValue(getText("grid.SUM_PRICE"));
            titleRow.createCell(2).setCellValue(getText("grid.ORDER_TIME"));
            titleRow.createCell(3).setCellValue(getText("grid.CREATE_TIME"));
            titleRow.createCell(4).setCellValue(getText("grid.DETAIL_NAME"));
            titleRow.createCell(5).setCellValue(getText("grid.DETAIL_NUM"));
            titleRow.createCell(6).setCellValue(getText("grid.DETAIL_MEMO"));
  
            for(int i=0;i<resultList.size();i++){
                Map<String,Object> result = resultList.get(i); 
                Row row = sheet.createRow(i+1);
                row.createCell(0).setCellValue(MapUtils.getInteger(result, "table_num"));
                row.createCell(1).setCellValue(MapUtils.getInteger(result, "sum_price"));
                row.createCell(2).setCellValue(MapUtils.getString(result, "order_time"));
                row.createCell(3).setCellValue(MapUtils.getString(result, "create_time"));
                row.createCell(4).setCellValue(MapUtils.getString(result, "detail_name"));
                row.createCell(5).setCellValue(MapUtils.getInteger(result, "detail_num"));
                row.createCell(6).setCellValue(MapUtils.getString(result, "detail_memo"));
                

            };
            //設定自動調整長度
            for(int colNum = 0; colNum<titleRow.getLastCellNum();colNum++){ 
                wb.getSheetAt(0).autoSizeColumn(colNum);
            }
            
            wb.write(os);
        }catch(Exception e){
            e.printStackTrace();
        };
        
        os.close();
        InputStream is = new ByteArrayInputStream(os.toByteArray());  
        return is;
    }
    
    //設定 - 進入設定頁面
    @Action(value="sysSettingLoad" ,results={@Result(location="/jsp/OrderCardSystem/SysSetting.jsp")} )
    public String sysSettingload(){
        return SUCCESS;
    }
}

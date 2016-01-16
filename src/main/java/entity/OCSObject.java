package entity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OCSObject {

    Map<String,String> paramMap = new HashMap<String,String>();
    public Map<String, String> getParamMap() {
        return paramMap;
    }
    public void setParamMap(Map<String, String> paramMap) {
        this.paramMap = paramMap;
    }
    
    List<Map<String, Object>> gridData;
    public List<Map<String, Object>> getGridData() {
        return gridData;
    }
    public void setGridData(List<Map<String, Object>> gridData) {
        this.gridData = gridData;
    }
    
}

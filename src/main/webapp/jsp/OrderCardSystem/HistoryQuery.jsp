<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- JQuery -->
    <script src='<s:url value="/js/jquery-1.11.3.min.js"/>'></script>
    
    <!-- flot -->
    <script src='<s:url value="/js/flot/jquery.flot.min.js"/>'></script>
    <script src='<s:url value="/js/flot/jquery.flot.pie.js"/>'></script>
    <!--<link rel="stylesheet" href="<s:url value='/style/flot/flot.css'/>"/>-->
    
    <!-- Angular JS -->
    <script src='<s:url value="/js/angularjs/angular.js"/>'></script>
    <script src='<s:url value="/js/angularjs/angular-animate.min.js"/>'></script>
    <script src='<s:url value="/js/angularjs/angular-aria.min.js"/>'></script>
    
    <!-- Material Design Lite -->
    <link rel="stylesheet" href="https://storage.googleapis.com/code.getmdl.io/1.0.6/material.blue-orange.min.css"/>
    <script src="https://storage.googleapis.com/code.getmdl.io/1.0.6/material.min.js"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"/>
    
    <link rel="stylesheet" href="<s:url value='/style/mdl/datepicker.css'/>"/>
    <link rel="stylesheet" href="<s:url value='/style/mdl/material.dialog.css'/>"/>
    <script src='<s:url value="/js/moment.min.js"/>'></script>
    
    <style type="text/css">
        .mdl-data-table td:first-of-type, .mdl-data-table th:first-of-type{
            padding-left : 10px;
        }
        .mdl-data-table td {
            text-align: left;
            padding : 10px 5px 5px 10px;
            vertical-align: middle;
        }
        h6{
            font-size : 16px;
            color : white;
            padding: 5px;
            margin: 0px;
        }
        *{
            font-size :16px;
        }
    </style>
    <script>
        var queryPath = '<s:url action="historyQuery"/>';
        var exportExcelPath = '<s:url action="exportExcel"/>';
    </script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Order Card System</title>
</head>
<body>
  <div ng-app="orderSystem" ng-controller="historyQuery" ng-cloak >
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header mdl-layout--fixed-tabs"  id="historyQueryPane">
      <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <span class="mdl-layout-title">營收查詢</span>
            <div class="mdl-layout-spacer"></div>
            <nav class="mdl-navigation">
                <button class="mdl-button mdl-js-button mdl-button--icon" ng-click="changeDetail();">
                    <i class="material-icons" ng-show="detail_type == 'listChart'">insert_chart</i>
                    <i class="material-icons" ng-show="detail_type == 'pieChart'">format_list_bulleted</i>
                </button>
            </nav>
        </div>
        <div style="position:relative;height:40px;background-color:#80bfff;color:white;line-height: 40px;padding-left: 12px;">
          <span ng-click="datePicker.showDatePicker(searchSDate,{'end':searchEDate});">
          <div class="mdl-button mdl-js-button mdl-button--icon"><i class="material-icons">event</i></div>
          {{searchSDate | date: 'yyyy/MM/dd'}}
          </span>~
          <span ng-click="datePicker.showDatePicker(searchEDate,{'start':searchSDate});">
          <div class="mdl-button mdl-js-button mdl-button--icon"><i class="material-icons">event</i></div>
          {{searchEDate | date: 'yyyy/MM/dd'}}
          </span>
          <label style="position: absolute;right:15px">
            <button class="mdl-button mdl-js-button mdl-button--icon" ng-click="query();">
              <i class="material-icons">search</i>
            </button>
            <button class="mdl-button mdl-js-button mdl-button--icon" ng-click="exportExcel();">
              <i class="material-icons">file_download</i>
            </button>
          </label>
        </div>
      </header>
      <s:include value="/jsp/OrderCardSystem/MenuDrawer.jsp"></s:include>
      <main class="mdl-layout__content">
	    <div class="page-content">
	      <div ng-show="detail_type == 'pieChart'">
	          <div style="padding-top:15px;" >
		          <div id="flot_pane" style="width:95%;"></div>
		      </div>
	      </div>
          <div ng-show="detail_type == 'listChart'">
	          <table class="mdl-data-table mdl-js-data-table mdl-shadow--2dp"  style="width:100%">
	              <tr>
	                  <td>桌號</td>
	                  <td>日期</td>
	                  <td>名稱</td>
	                  <td>數量</td>
	                  <td>金額</td>
	              </tr>
	              <tr ng-repeat="data in datalist" >
	                  <td>{{data.table_num}}</td>
	                  <td>{{data.order_time | date : 'yy/MM/dd'}}</td>
	                  <td style="white-space: normal;">{{data.detail_name}}</td>
	                  <td>{{'x'+data.detail_num}}</td>
	                  <td>{{'$'+data.detail_price}}</td>
	              </tr>
	          </table>
	      </div>
      </main>
      <footer style="background:#424242;position:relative;height:40px;text-align:center;">
            <div style="position:relative;height:40px;width:100%;text-align: center;color:white;line-height:40px;">
                <div style="position:absolute;top:0px; left:20px;line-height:40px;">區間營收 : {{'$'+SUM_PRICE}}</div>
                <div style="position:absolute;top:0px; right:20px;line-height:40px;">
                    <label>群組 : </label>
                    <button class="mdl-button mdl-js-button mdl-button--icon" 
                        style="/*position: absolute;left:5px;top:5px;*/" ng-click="changeType(-1);">
                      <i class="material-icons">keyboard_arrow_left</i>
                    </button>
                    <label>{{GROUP_TYPE_LABEL[GROUP_TYPE]}}</label>
                    <button class="mdl-button mdl-js-button mdl-button--icon" 
                        style="/*position: absolute;right:5px;top:5px;*/" ng-click="changeType(1);">
                      <i class="material-icons">keyboard_arrow_right</i>
                    </button>
                </div>
            </div>
      </footer>
      <s:form id="excelForm" action="exportExcel">
        <div>
            <input type="hidden" name="searchSDate" ng-value="searchSDate | date:'yyyyMMdd'"></input>
            <input type="hidden" name="searchEDate" ng-value="searchEDate | date:'yyyyMMdd'"></input>
        </div>
      </s:form>
         <div class="mdl-dialog__container">
            <div class="mdl-dialog" >
              <div style="padding:10px;width:250px;text-align: center;">
                  <div class="mdl-datepicker-title">
                    <div style="color:rgba(255,255,255,0.7);margin-bottom: 5px;">{{datePicker.pickDate | date : 'yyyy'}}</div>
                    <div style="font-size: 24px;">{{datePicker.pickDate | date : 'EEE, MMM d'}}</div>
                  </div>
                  <div style="position: relative;margin-bottom: 10px;">
                      <button class="mdl-button mdl-js-button mdl-button--icon" 
                          style="position: absolute;left:-5px;top:-5px;"
                          ng-click="datePicker.date.setMonth(datePicker.date.getMonth()-1);datePicker.monthDays();">
                        <i class="material-icons">keyboard_arrow_left</i>
                      </button>
                      <span>{{datePicker.date | date: 'MMMM yyyy'}}</span>
                      <button class="mdl-button mdl-js-button mdl-button--icon" 
                          style="position: absolute; right:-5px;top:-5px;"
                          ng-click="datePicker.date.setMonth(datePicker.date.getMonth()+1);datePicker.monthDays();">
                        <i class="material-icons">keyboard_arrow_right</i>
                      </button>
                  </div>
                  <div style="text-align: left;">
                  <div ng-repeat="week in datePicker.weekdays" class="mdl-datepicker-week">
                      {{week}}
                  </div><br/>
                  <div ng-repeat-start="day in datePicker.dayArray track by $index" 
                      class = "mdl-datepicker-date"
                      ng-class="[{'is-checked': datePicker.isEqual(day.value)},{'mdl-datepicker-date__today' : day.isTody},{'is-disabled':day.isDisabled}]"
                      ng-click="datePicker.pick(day)">
                      {{day.value}}
                  </div><br ng-if="($index+1)%7==0" ng-repeat-end/>
                  </div>
              </div>
              <div class="mdl-dialog-control">
                 <div class="mdl-button mdl-js-button mdl-datepicker-button" ng-click="datePickerConfirm();">確定</div>
                 <div class="mdl-button mdl-js-button mdl-dialog-control__cancel mdl-datepicker-button">取消</div>
              </div>
            </div>
        </div>
        <div class="mdl-dialog__obfuscator"></div>
    </div>
    <script src='<s:url value="/js/OrderCardSystem/HistoryQuery.js"/>'></script>
  </div>
</body>
</html>
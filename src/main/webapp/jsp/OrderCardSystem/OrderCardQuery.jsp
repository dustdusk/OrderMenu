<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- JQuery -->
    <script src='<s:url value="/js/jquery-1.11.3.min.js"/>'></script>
    
    <!-- Angular JS -->
    <script src='<s:url value="/js/angularjs/angular.js"/>'></script>
    <script src='<s:url value="/js/angularjs/angular-animate.min.js"/>'></script>
    <script src='<s:url value="/js/angularjs/angular-aria.min.js"/>'></script>
    
	<link rel="stylesheet" href="https://storage.googleapis.com/code.getmdl.io/1.0.6/material.blue-orange.min.css">
	<script src="https://storage.googleapis.com/code.getmdl.io/1.0.6/material.min.js"></script>
	<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
	
	<link rel="stylesheet" href="<s:url value='/style/mdl/datepicker.css'/>">
	<link rel="stylesheet" href="<s:url value='/style/mdl/material.dialog.css'/>">
	<link rel="stylesheet" href="<s:url value='/style/mdl/material.grid.css'/>">
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
        *{
            font-size : 16px;
        }
        h6{
            font-size : 16px;
            color : white;
            padding: 5px;
            margin: 0px;
        }
        .mdl-grid-tag {
            margin: 3px;
            font-size:16px;
            padding : 0 5px;
            width:230px;
            /*width:auto;*/
            text-align: left;
            position: relative;
        }
    </style>
    <script>
        var queryPath = '<s:url action="query"/>';
        var query_detailPath = '<s:url action="query_detail"/>';
        var getSystemSettingPath = '<s:url action="getSystemSetting"/>';
        
        var orderCardSavePath = '<s:url action="orderCardSave"/>';
        var orderCardDeletePath = '<s:url action="orderCardDelete"/>';
        var orderCardPayedPath = '<s:url action="orderCardPayed"/>';
        
        var cardDetailOutPath = '<s:url action="cardDetailOut"/>'
        var searchDate = new Date();
    </script>
    
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Order Card System</title>
</head>
<body ng-app="orderSystem">
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header"  ng-controller="orderCardQueryPane" ng-cloak id="orderCardQueryPane">
	  <header class="mdl-layout__header">
	    <div class="mdl-layout__header-row">
            <span class="mdl-layout-title">點餐</span>
            <div class="mdl-layout-spacer"></div>
	        <nav class="mdl-navigation">
	            <!-- 
		        <div class="mdl-button mdl-js-button mdl-button--icon" ng-click="query();">
                <i class="material-icons">search</i>
                </div>
                 -->
	            <div class="mdl-button mdl-js-button mdl-button--icon" ng-click="addCard();">
	            <i class="material-icons">add</i>
	            </div>
		    </nav>
	    </div>
        <div style="position:relative;height:40px;background-color:#80bfff;color:white;line-height: 40px;padding-left: 12px;">
          <span ng-click="showDatePicker();">
          <div class="mdl-button mdl-js-button mdl-button--icon"><i class="material-icons">event</i></div>
          {{searchDate | date: 'yyyy/MM/dd EEE'}}</span>
          <span style="position:absolute;right:27px;">總額 : {{SUM_PRICE}}</span>
        </div>
	  </header>
	  <s:include value="/jsp/OrderCardSystem/MenuDrawer.jsp"></s:include>
	  <main class="mdl-layout__content"  style="background-color: rgb(230,230,230);">
	    <div class="page-content">
		<div class="mdl-div-grid" style="width:100%;">
		    <div ng-repeat="data in datalist track by $index " ng-click="addCard(data.guid);" class="mdl-div-grid-tr">
				<div class="mdl-div-grid-td" style="width:32px;padding:5px 0;float: left;">
				    <button ng-class="['mdl-button', 'mdl-js-button', 'mdl-button--icon']" ng-click="orderCardPayed(data.guid);$event.stopPropagation();">
                      <i class="material-icons" ng-style="data.cardStatus?{color:'#ffab40'}:{color : 'gray'}">check</i>
                    </button>
                </div>
                <div class="mdl-div-grid-td mdl-div-grid-rap" style="padding:10px 0 0 0;float: left;">
				    <span>{{data.tableNum!=0?(data.tableNum+'桌'):'外帶'}}</span>
				    <span>{{'$'+data.sumPrice}}</span>
				</div>
				<div class="mdl-div-grid-td"  style="padding:7px 0;float: left;width: auto;">
                    <div ng-repeat-start="detailData in data.orderCardDetails" class="mdl-button mdl-grid-tag "
                        ng-click="cardDetailOut(detailData.guid);$event.stopPropagation();" 
                        ng-style="detailData.isOut?{'background-color': '#e6e6e6'}:{'background-color':'#ffab40'}"
                        ng-class="{'mdl-shadow--2dp' : !detailData.isOut}" >
                        <span style="display:inline-block;width:140px;overflow: hidden;">
                        {{detailData.detailName}}
                        </span>
                        <span style="display:inline-block;vertical-align:top;" ng-repeat="memoItem in detailData.detailMemo.split(';') track by $index">{{memoLabel[memoItem]}}</span>
                        <span style="position: fixed; right:5px;top:2px;" >x{{detailData.detailNum}}</span>
                    </div>
                    <br ng-repeat-end>
				</div>
		    </div>
	    </div>
		</div>
	  </main>
	  <footer>
      </footer>
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
	                      ng-click="datePicker.date.setMonth(datePicker.date.getMonth()-1)">
						<i class="material-icons">keyboard_arrow_left</i>
				      </button>
				      <span>{{datePicker.date | date: 'MMMM yyyy'}}</span>
	                  <button class="mdl-button mdl-js-button mdl-button--icon" 
	                      style="position: absolute; right:-5px;top:-5px;"
	                      ng-click="datePicker.date.setMonth(datePicker.date.getMonth()+1)">
						<i class="material-icons">keyboard_arrow_right</i>
				      </button>
		          </div>
		          <div style="text-align: left;">
		          <div ng-repeat="week in datePicker.weekdays" class="mdl-datepicker-week">
		              {{week}}
		          </div><br/>
		          <div ng-repeat-start="day in datePicker.monthDays() track by $index" 
		              class = "mdl-datepicker-date"
		              ng-class="[{'is-checked': datePicker.isEqual(day)},{'mdl-datepicker-date__today' : datePicker.isToday(day)}]"
			          ng-click="datePicker.pick(day)">
		              {{day}}
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
    <script src='<s:url value="/js/OrderCardSystem/OrderCardQuery.js"/>'></script>
    <s:include value="/jsp/OrderCardSystem/OrderCardEdit.jsp"></s:include>
</body>
</html>
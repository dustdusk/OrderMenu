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
            /*color : white;*/
            padding: 5px;
            margin: 0px;
        }
    </style>
    <script>
        var queryPath = '<s:url action="historyQuery"/>';
    </script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Order Card System</title>
</head>
<body>
  <div ng-app="orderSystem" ng-controller="sysSetting" ng-cloak >
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header" id="sysSettingPane">
      <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <span class="mdl-layout-title">系統設定</span>
            <div class="mdl-layout-spacer"></div>
            <nav class="mdl-navigation">
                <div class="mdl-button mdl-js-button mdl-button--icon" ng-click="save();" 
                    ng-disabled="(settingItem.tableCount == 0 || settingItem.tableCount == undefined)">
                    <i class="material-icons">save</i>
                </div>
            </nav>
        </div>
      </header>
      <s:include value="/jsp/OrderCardSystem/MenuDrawer.jsp"></s:include>
      <main class="mdl-layout__content">
        <div class="page-content">
          <div style="padding: 10px 0 0 10px;">
            <span style="font-size : 24px;">桌子數量 :</span>
            <span style="vertical-align: text-bottom;">
	            <button class="mdl-button mdl-js-button mdl-button--icon">
	                <i class="material-icons" style="vertical-align:top;" ng-click="settingItem.tableCount = settingItem.tableCount + 1">add</i>
	            </button>
	            <span style="font-size:24px;text-align:center;vertical-align:middle;" ng-bind="settingItem.tableCount"></span>
	            <button class="mdl-button mdl-js-button mdl-button--icon">
	                <i class="material-icons" style="vertical-align:top;" ng-click="settingItem.tableCount = settingItem.tableCount - (settingItem.tableCount>1?1:0)">remove</i>
	            </button>
            </span>
          </div>
        </div>
      </main>
    </div>
    <script src='<s:url value="/js/OrderCardSystem/SysSetting.js"/>'></script>
  </div>
</body>
</html>
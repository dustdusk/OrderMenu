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
    
    <link rel="stylesheet" href="<s:url value='/style/mdl/material.grid.css'/>">
    
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
    </style>
    <script>
        var queryPath = '<s:url action="menuQuery"/>';
        var savePath = '<s:url action="menuEditSave"/>';
        var deletePath = '<s:url action="menuEditDelete"/>';
        var soldoutPath = '<s:url action="menuEditSoldout"/>';
    </script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Order Card System</title>
</head>
<body>
  <div ng-app="orderSystem" ng-controller="menuQueryEdit" ng-cloak >
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header" id="menuQuery">
      <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <span class="mdl-layout-title">編輯菜單</span>
            <div class="mdl-layout-spacer"></div>
            <nav class="mdl-navigation">
                <div class="mdl-button mdl-js-button mdl-button--icon" ng-click="showEidt();">
                <i class="material-icons">add</i>
                </div>
                <div class="mdl-button mdl-js-button mdl-button--icon" ng-click="isSearch = !isSearch;searchCodition=''">
                <i class="material-icons">search</i>
                </div>
            </nav>
        </div>
        <div>
          <div class="mdl-textfield mdl-js-textfield"  style="padding: 5px 10px;background-color:#80bfff;width:100%" ng-show="isSearch">
            <input class="mdl-textfield__input" type="text" id="searchCodition" ng-model="searchCodition"/>
          </div>
        </div>
      </header>
      <s:include value="/jsp/OrderCardSystem/MenuDrawer.jsp"></s:include>
      <main class="mdl-layout__content"  style="background-color: rgb(230,230,230);">
        <div class="page-content">
        <div class="mdl-div-grid"  style="width:100%;font-size : 16px">
            <div ng-repeat="data in datalist | filter : searchCodition " ng-click="showEidt($index);" class="mdl-div-grid-tr" style="position: relative;min-height:35px;">
                <div class="mdl-div-grid-td" style="margin-right:120px;white-space: normal;">
                    {{data.ITEM_NAME}}
                </div>
                <div class="mdl-div-grid-td"  style="position: absolute;right:0;top:0;">
                    {{'$'+data.ITEM_PRICE}}
                    <button ng-class="['mdl-button', 'mdl-js-button', 'mdl-button--icon']" ng-click="soldout(data.GUID);$event.stopPropagation();">
                      <i class="material-icons" ng-style="data.IS_SOLDOUT?{color:'red'}:{color : 'gray'}">shopping_cart</i>
                    </button>
                    <button class="mdl-button mdl-js-button mdl-button--icon" ng-click="deleteItem(data.GUID);$event.stopPropagation();">
                      <i class="material-icons" style="color : gray;">delete</i>
                    </button>
                </div>
            </div>
        </div>
        </div>
      </main>
    </div>
    <s:include value="/jsp/OrderCardSystem/MenuItemEdit.jsp"></s:include>
    <script src='<s:url value="/js/OrderCardSystem/MenuQueryEdit.js"/>'></script>
  </div>
</body>
</html>
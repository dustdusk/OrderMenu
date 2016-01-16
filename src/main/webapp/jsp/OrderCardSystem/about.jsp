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
        *{
            font-size:16px
        }
    </style>
    <script>
        var queryPath = '<s:url action="historyQuery"/>';
    </script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Order Card System</title>
</head>
<body>
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header" id="historyQuery">
      <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <span class="mdl-layout-title">關於</span>
        </div>
      </header>
      <s:include value="/jsp/OrderCardSystem/MenuDrawer.jsp"></s:include>
      <main class="mdl-layout__content">
        <div class="page-content">
            <div style="padding: 10px 20px;">
            <div>名稱 : 網頁點餐系統</div>
            <div>版本 : 1.0</div>
            <div>作者 : Dustdusk</div>
            <div>EMail : dustdusk@gmail.com</div>
            <div>前台 : JSP, Angular JS, Material Design Lite, Moment.js, flot</div>
            <div>後台 : Struts 2, Spring 4, HSQL</div>
            </div>
        </div>
      </main>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<div class="mdl-layout__drawer">
  <span class="mdl-layout-title">Menu</span>
  <nav class="mdl-navigation">
    <a class="mdl-navigation__link" href="<s:url action='load'/>">點餐</a>
    <a class="mdl-navigation__link" href="<s:url action='menuLoad'/>">編輯菜單</a>
    <a class="mdl-navigation__link" href="<s:url action='historyLoad'/>">營收查詢</a>
    <a class="mdl-navigation__link" href="<s:url action='sysSettingLoad'/>">系統設定</a>
    <a class="mdl-navigation__link" href="<s:url value='/jsp/OrderCardSystem/about.jsp'/>">關於...</a>
  </nav>
</div>
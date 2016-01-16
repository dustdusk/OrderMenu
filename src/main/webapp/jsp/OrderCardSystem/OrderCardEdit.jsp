<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
    <div ng-controller="orderCardEditPane" ng-cloak >
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header" id="eidtOrderCard"  style="display:none;" >
      <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <div ng-click="backQuery();" class="mdl-layout__drawer-button">
            <i class="material-icons">keyboard_arrow_left</i>
            </div>
            <span class="mdl-layout-title">
                {{orderCard.CARD_STATUS?'已繳款':'未繳款'}}
            </span>
            <div class="mdl-layout-spacer"></div>
            <nav class="mdl-navigation">
                <span ng-click="orderCardSave();" class="mdl-button mdl-js-button mdl-button--icon" ng-disabled="datalist.length == 0">
                <i class="material-icons">save</i>
                </span>
                <!-- Right aligned menu below button -->
                <button id="demo-menu-lower-right"
                        class="mdl-button mdl-js-button mdl-button--icon" ng-disabled="datalist.length == 0">
                  <i class="material-icons">more_vert</i>
                </button>
                
                <ul class="mdl-menu mdl-menu--bottom-right mdl-js-menu mdl-js-ripple-effect"
                    for="demo-menu-lower-right">
                  <li class="mdl-menu__item" ng-click="orderCardPayed();">已繳錢</li>
                  <li class="mdl-menu__item" ng-click="orderCardDelete();">刪除</li>
                </ul>
            </nav>
        </div>
      </header>
      <main class="mdl-layout__content">
        <div class="page-content">
            <div style="background-color: #80bfff;height:40px;" class="mdl-shadow--2dp">
                <h6>桌次</h6>
            </div>
            <div  id="table_container" style="margin: 2px">
                <button class="mdl-button mdl-js-button mdl-js-ripple-effect" style="width:24%;font-size:16px;background-color:#f2f2f2;margin:0.3%" id="{{'table'+tableItem}}" 
                    ng-click="clickItem(tableItem,'table');"
                    ng-repeat="tableItem in [1,2,3,4,5,6,7,8,0]">
                {{tableItem!='0'?(tableItem+'桌'):'外帶'}}
                </button>
            </div>
            <div style="height: 80px;background-color: #80bfff;position: relative;">
                <span style="position: absolute; left : 0px;" >
                <h6>
                {{'總價: $'+orderCard.SUM_PRICE}}<br>餐點明細
                </h6>
                </span>
                <div style="padding-right:10px;position: absolute; top: 10px;right : 0px;">
                    <button  ng-click="addDetail();" class="mdl-button mdl-js-button mdl-button--fab mdl-button--colored" >
                    <i class="material-icons">add</i>
                    </button>
                </div>              
            </div>
        <table class="mdl-data-table mdl-js-data-table mdl-shadow--2dp"  style="width:100%">
            <tr ng-repeat="data in datalist" >
                <td style="white-space: normal;">{{data.DETAIL_NAME}}</td>
                <td>{{'x'+data.DETAIL_NUM}}</td>
                <td>{{'$'+data.DETAIL_PRICE}}</td>
                <td><span ng-repeat="memoItem in data.DETAIL_MEMO.split(';') track by $index">{{memoLabel[memoItem]}}</span>
                </td>
                <td style="padding-right:22px;text-align: right;">
                    <div ng-click="detailOut($index);" class="mdl-button mdl-js-button mdl-button--icon" >
                    <i class="material-icons" ng-style="data.IS_OUT?{color:'#ffab40'}:{color : 'gray'}">check</i>
                    </div>
                    <div ng-click="deleteRow($index);" class="mdl-button mdl-js-button mdl-button--icon" >
                    <i class="material-icons" style="color:gray;">delete</i>
                    </div>
                </td>
            </tr>
        </table>
        </div>
      </main>
    </div>
    <s:include value="/jsp/OrderCardSystem/CardDetailEdit.htm"></s:include>
    </div>
    <script src='<s:url value="/js/OrderCardSystem/OrderCardEdit.js"/>'></script>
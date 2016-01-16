<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header" id="menuEdit" style="display:none">
      <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <div class="mdl-layout__drawer-button" ng-click="backQuery();">
            <i class="material-icons">keyboard_arrow_left</i>
            </div>
            <span class="mdl-layout-title">{{menuItem.IS_SOLDOUT?'已停售':''}}</span>
            <div class="mdl-layout-spacer"></div>
            <nav class="mdl-navigation">
                <div class="mdl-button mdl-js-button mdl-button--icon" ng-click="saveItem();" 
                ng-disabled="!(menuItem.ITEM_NAME != '' && menuItem.ITEM_PRICE > 0 && menuItem.ITEM_PRICE != undefined)">
                <i class="material-icons">save</i>
                </div>
                <!-- Right aligned menu below button -->
                <button id="demo-menu-lower-right"
                        class="mdl-button mdl-js-button mdl-button--icon" ng-disabled="menuItem.GUID == ''">
                  <i class="material-icons">more_vert</i>
                </button>
                
                <ul class="mdl-menu mdl-menu--bottom-right mdl-js-menu mdl-js-ripple-effect"
                    for="demo-menu-lower-right">
                  <li class="mdl-menu__item" ng-click="soldout();">停售</li>
                  <li class="mdl-menu__item" ng-click="deleteItem();">刪除</li>
                </ul>
            </nav>
        </div>
      </header>
      <main class="mdl-layout__content">
        <div class="page-content">
          <div id="type_containger">
              <button class="mdl-button mdl-js-button mdl-js-ripple-effect" ng-class="{'mdl-button--raised mdl-button--accent' : typeItem.isCheck}" style="width:33%;" id="{{typeItem.value}}" ng-click="clickItem(typeItem);"
                  ng-repeat="typeItem in typeItemList">
                  {{typeItem.name}}
              </button>
          </div>
          <div style="padding-left: 10px;">
          <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" 
              ng-class="{'is-upgraded is-dirty':menuItem.ITEM_NAME!=''}">
            <input class="mdl-textfield__input" type="text" id="ITEM_NAME" ng-model="menuItem.ITEM_NAME"/>
            <label class="mdl-textfield__label" for="ITEM_NAME">名稱...</label>
          </div><br/>
          <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 147px;" 
              ng-class="{'is-upgraded is-dirty':menuItem.ITEM_PRICE!=''}">
            <input class="mdl-textfield__input" type="text" pattern="[0-9]*(\.[0-9]+)?" id="ITEM_PRICE" ng-model="menuItem.ITEM_PRICE"/>
            <label class="mdl-textfield__label" for="ITEM_PRICE">價錢...</label>
            <span class="mdl-textfield__error">請輸入數字!</span>
          </div>
          <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 147px;" 
              ng-class="{'is-upgraded is-dirty':menuItem.ITEM_COST!=null}">
            <input class="mdl-textfield__input" type="text" pattern="[0-9]*(\.[0-9]+)?" id="ITEM_COST" ng-model="menuItem.ITEM_COST"/>
            <label class="mdl-textfield__label" for="ITEM_COST">成本...</label>
            <span class="mdl-textfield__error">請輸入數字!</span>
          </div><br/>
          <div id="MEMO_CHECK_ITEM" ng-show="menuItem.ITEM_TYPE=='0'">
          <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="MEMO_HOT" style="width: 45%;" ng-class="{'is-checked':MEMO_HOT}">
              <input type="checkbox" id="MEMO_HOT" class="mdl-checkbox__input" ng-model="MEMO_HOT" />
              <span class="mdl-checkbox__label">熱飲</span>
          </label>
          <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="MEMO_COLD"  style="width: 45%;" ng-class="{'is-checked':MEMO_COLD}">
              <input type="checkbox" id="MEMO_COLD" class="mdl-checkbox__input" ng-model="MEMO_COLD"/>
              <span class="mdl-checkbox__label">冷飲</span>
          </label>
          <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="MEMO_SUGAR"  ng-class="{'is-checked':MEMO_SUGAR}">
              <input type="checkbox" id="MEMO_SUGAR" class="mdl-checkbox__input" ng-model="MEMO_SUGAR"/>
              <span class="mdl-checkbox__label">甜度調整</span>
          </label>
          </div>
          <div class="mdl-textfield mdl-js-textfield" 
             ng-class="{'is-upgraded is-dirty':menuItem.ITEM_DESCRIPTION!=''}">
            <textarea class="mdl-textfield__input" type="text" rows= "3" id="ITEM_DESCRIPTION" ng-model="menuItem.ITEM_DESCRIPTION"></textarea>
            <label class="mdl-textfield__label" for="ITEM_DESCRIPTION">商品簡介...</label>
          </div>
          </div>
        </div>
      </main>
    </div>
app.controller('orderCardEditPane', function($scope, $http, $filter){
	$scope.datalist = [];
	$scope.DETAIL_NUM = 1;
	$scope.memoLabel = {
    	'h':'熱',
    	'w':'溫',
    	'i':'冰',
    	'li':'少冰',
    	'ni':'去冰',
    	'ms':'加糖',
    	'ns':'正常',
    	'hs':'半糖',
    	'ls':'少糖',
    	'lis':'微糖',
    	'nos':'無糖',
    	'o':''
    };
    var delaultOrderCard = {
        TABLE_NUM : 0,
        CARD_STATUS : false,
        SUM_PRICE : 0
    };
	$scope.orderCard = $.extend({}, delaultOrderCard);
	$scope.$root.$on("loadOCard", function(event, args){
		$('#table_container button').removeClass('mdl-shadow--2dp').css('background','#f2f2f2');     //全數清除
		
		if(args.guid != undefined){
			$scope.orderCardQuery(args.guid, function(){
				$('#orderCardQueryPane').hide();
				$('#eidtOrderCard').show();
			});
		} else {
			$scope.datalist = [];
			$scope.orderCard = $.extend({}, delaultOrderCard);
			$('#table_container #table1').addClass('mdl-shadow--2dp').css('background','#ffab40');     //反白
			$('#orderCardQueryPane').hide();
			$('#eidtOrderCard').show();
		}
	});
	
	$scope.orderCardQuery = function(guid,feedback){
		$http.post(
		    query_detailPath,
			'cardGuid='+guid,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.datalist = data.gridData;
			if(data.orderCard != null){
				$scope.orderCard = data.orderCard;
				clearCheckItem($scope.menuItemList);
				$('#table_container #table'+$scope.orderCard.TABLE_NUM).addClass('mdl-shadow--2dp').css('background','#ffab40');     //反白

				feedback();
			}
			$scope.getSumPrice();
		});
	}
	
	$scope.orderCardSave = function(){
		if($scope.datalist.length != 0){
		    $http.post(
				orderCardSavePath,
				'detailGridData='+JSON.stringify($scope.datalist)+'&'+
				'orderCard='+JSON.stringify($scope.orderCard)+'&'+
				'searchDate='+$filter('date')(searchDate,'yyyyMMdd'),
				{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
			).success(function(data, status, headers, config) {
				$scope.backQuery();
			});
		}
	}
	
	$scope.orderCardDelete = function(){
		$http.post(
		    orderCardDeletePath,
			'guid='+$scope.orderCard.GUID
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.backQuery();
		});
	};
	$scope.$root.$on("orderCardDelete", function(event, args){
		$scope.orderCard.GUID = args.orderCardGuid;
		$scope.orderCardDelete();
	});
	
	$scope.orderCardPayed = function(){
		$http.post(
			orderCardPayedPath,
			'guid='+$scope.orderCard.GUID
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.backQuery();
		});
	};
	$scope.$root.$on("orderCardPayed", function(event, args){
		$scope.orderCard.GUID = args.orderCardGuid;
		$scope.orderCardPayed();
	});
	
	$scope.deleteRow = function(rowNum){
		$scope.datalist.splice(rowNum,1);
		$scope.getSumPrice();
	};
	
	$scope.detailOut = function(index){
		$scope.datalist[index].IS_OUT = !$scope.datalist[index].IS_OUT;
	}
	
	$scope.backQuery = function(){
		$scope.$root.$emit("query", {feedback : function(){
			$('#orderCardQueryPane').show();
			$('#eidtOrderCard').hide();
		}});

	}
	
	$scope.getSumPrice = function(){
		$scope.orderCard.SUM_PRICE = 0;
		for(var i =0 ; i< $scope.datalist.length;i++){
			$scope.orderCard.SUM_PRICE += $scope.datalist[i].DETAIL_PRICE;
		}
		
	}
	$scope.menuItemList = [];
	$scope.getSystemSetting = function(){
		$http.post(getSystemSettingPath).success(function(data, status, headers, config) {
			$scope.menuItemList = data.menuItemList;
		});
	}
	$scope.getSystemSetting();

	$scope.typeItemList = {
		    '0' : {name : '飲料', value : 0, isCheck : true},
		    '1' : {name : '蛋糕', value : 1, isCheck : false},
		    '2' : {name : '輕食', value : 2, isCheck : false}
		};
	
	$scope.memoItemList = [
	    {name : 'ice', value : 'ice'},
	    {name : 'hot', value : 'hot'},
	    {name : 'half sugar', value : 'hSugar'},
	    {name : 'no sugar', value : 'nSugar'}
	];
	
	
//--Order Card Detail
	var defaultDetailCard = {
			GUID : '',
			ITEM_GUID : '',
			DETAIL_NAME : '',
			DETAIL_PRICE : 0,
			DETAIL_NUM : 0,
			DETAIL_MEMO : ''
	};
	$scope.detailCard = $.extend({}, defaultDetailCard);

	$scope.addDetail = function(){
		//回復預設值
		clearCheckItem($scope.menuItemList);
		$scope.DETAIL_NUM = 1;
		$scope.detailCard = $.extend({}, defaultDetailCard);
		$('#tab_container a').removeClass('is-active');		
		$('#tab_container a:first').addClass('is-active');
		$('#tab1').addClass('is-active');	
		$('#tab2').removeClass('is-active');	
		$('#tab3').removeClass('is-active');	
		$scope.optionT = '';
		$scope.optionS = '';
		
		$('#eidtOrderCard').hide();
		$('#eidtDetail').show();
	}
	
	$scope.editDetailSave = function(){
		if($scope.detailCard.ITEM_GUID !=''){
			$scope.detailCard.DETAIL_NUM = $scope.DETAIL_NUM;
			$scope.detailCard.DETAIL_PRICE = $scope.detailCard.DETAIL_PRICE * $scope.DETAIL_NUM;
			$scope.detailCard.DETAIL_MEMO = ''+$scope.optionT+';'+$scope.optionS+';';
		
			$scope.datalist.push($scope.detailCard);
			$scope.getSumPrice();
			$scope.backOrderCard();
		}
	}
	
	$scope.backOrderCard = function(){
		$('#eidtOrderCard').show();
		$('#eidtDetail').hide();
	}
	
	$scope.clickItem = function(target, type){
		if(type == 'table'){
			$('#'+type+'_container button').removeClass('mdl-shadow--2dp').css('background','#f2f2f2');     //全數清除
			$('#'+type+'_container #table'+target).addClass('mdl-shadow--2dp').css('background','#ffab40');     //反白
			$scope.orderCard.TABLE_NUM = target;
			
		} else if(type == 'tab'){
			clearCheckItem($scope.menuItemList);
			target.isCheck = true;
			
			$scope.detailCard.ITEM_GUID = target.GUID;
			$scope.detailCard.DETAIL_NAME = target.ITEM_NAME;
			$scope.detailCard.DETAIL_PRICE = target.ITEM_PRICE;
			$scope.detailCard.DETAIL_MEMO = target.ITEM_MEMO;
			
			$('#memoItemPane label').removeClass('is-checked');
			$('#memoItemPane input[type=radio]').prop('checked',false);
		}
	}
	
	function clearCheckItem(itemList){
		for(var index in itemList){
			itemList[index].isCheck = false;
		}
	}

});
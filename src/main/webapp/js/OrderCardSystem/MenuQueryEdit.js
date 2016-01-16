angular.module('orderSystem', []).controller('menuQueryEdit', function($scope, $http){
	$scope.datalist = [];
	$scope.isSearch = false;
	var defaultMenuItem = {
	    GUID : '',
		ITEM_NAME : '',
		ITEM_S_NAME : '',
		ITEM_TYPE : 0,
		ITEM_PRICE : '',
		ITEM_COST : null,
		ITEM_DESCRIPTION : '',
		ITEM_MEMO : '',
		IS_SOLDOUT : false
	}
	$scope.menuItem = $.extend({}, defaultMenuItem);

	$scope.typeItemList = {
	    '0' : {name : '飲料', value : 0, isCheck : true},
	    '1' : {name : '蛋糕', value : 1, isCheck : false},
	    '2' : {name : '輕食', value : 2, isCheck : false}
	};
	
	$scope.query = function(feedback){
		$http.post(queryPath).success(function(data, status, headers, config) {
			$scope.datalist = data;
			if(feedback != undefined){
				feedback();
			}
		});
	};
	$scope.query();

	$scope.clickItem = function(item){
		clearCheckItem($scope.typeItemList);
		item.isCheck = true;
		$scope.menuItem.ITEM_TYPE = item.value;
	}
	
	$scope.saveItem = function(){
		if($scope.menuItem.ITEM_NAME != '' && $scope.menuItem.ITEM_PRICE > 0 && $scope.menuItem.ITEM_PRICE != undefined){
			$scope.menuItem.ITEM_MEMO = '';
			$scope.menuItem.ITEM_MEMO += ($scope.MEMO_HOT?'H':'')+';';
			$scope.menuItem.ITEM_MEMO += ($scope.MEMO_COLD?'C':'')+';';
			$scope.menuItem.ITEM_MEMO += ($scope.MEMO_SUGAR?'S':'')+';';
			
			$http.post(
		    	savePath,
		    	'menuItem='+JSON.stringify($scope.menuItem)
		    	,
		    	{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		    ).success(function(data, status, headers, config) {
		    	$scope.backQuery();
		    });
		}
	}
	
	$scope.deleteItem = function(guid){
		if(guid == undefined){
			guid = $scope.menuItem.GUID;
		}
		$http.post(
			deletePath,
			'guid='+guid
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.backQuery();
		});
	};
	$scope.soldout = function(guid){
		if(guid == undefined){
			guid = $scope.menuItem.GUID;
		}
		$http.post(
		    soldoutPath,
			'guid='+guid
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.backQuery();
		});
	}
	
	$scope.showEidt = function(index){
		if(index != undefined){
			$scope.menuItem = $scope.datalist[index];
			clearCheckItem($scope.typeItemList);
			$scope.typeItemList[$scope.menuItem.ITEM_TYPE].isCheck = true;
			if($scope.menuItem.ITEM_MEMO.indexOf('H')!=-1){
				$scope.MEMO_HOT = true;
			}
			if($scope.menuItem.ITEM_MEMO.indexOf('C')!=-1){
				$scope.MEMO_COLD = true;
			}
			if($scope.menuItem.ITEM_MEMO.indexOf('S')!=-1){
				$scope.MEMO_SUGAR = true;
			}
		}
		$('#menuQuery').hide();
		$('#menuEdit').show();
	}
	
	$scope.backQuery = function(){
		$scope.menuItem = $.extend({}, defaultMenuItem);
		clearCheckItem($scope.typeItemList);
		$scope.typeItemList[0].isCheck = true;
		$('#MEMO_CHECK_ITEM label').removeClass('is-checked');
		$scope.MEMO_HOT = false;
		$scope.MEMO_COLD = false;
		$scope.MEMO_SUGAR = false;
		
		$scope.query(function(){
			$('#menuEdit').hide();
			$scope.isSearch = false;
			$scope.searchCodition = '';
			$('#menuQuery').show();
		});
	}
	
	function clearCheckItem(itemList){
		for(var index in itemList){
			itemList[index].isCheck = false;
		}
	}
});
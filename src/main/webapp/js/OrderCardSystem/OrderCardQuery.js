var app = angular.module('orderSystem', []);
app.controller('orderCardQueryPane', function($scope, $http, $filter){
	$scope.datalist = [];
	$scope.SUM_PRICE = 0;
	$scope.searchDate = searchDate;
	$scope.dateError = false;

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
	//Date Picker
	$scope.datePicker = {};
	$scope.datePicker.pickDate = new Date();
	$scope.datePicker.today = new Date();
	$scope.datePicker.date = new Date();
	$scope.datePicker.weekdays = moment.weekdaysMin();
	$scope.datePicker.monthDays = function(){
		var date = moment($scope.datePicker.date);
		var dayArray = [];
		for (var i=0;i<date.startOf('month').day();i++){
			dayArray.push('');
		}
		for (var i=1;i<=date.endOf('month').date();i++) {
			dayArray.push(i);
		}
		return dayArray;
	}
	$scope.datePicker.isToday = function(day){
		var today = moment($scope.datePicker.today);
		return today.isSame($scope.datePicker.date,'month') && (today.date() == day);
	}
	$scope.datePicker.isEqual = function(day){
		var pickDate = moment($scope.datePicker.pickDate);
	    return pickDate.isSame($scope.datePicker.date,'month') && (pickDate.date() == day);
	}
	$scope.datePicker.pick = function(day){
		$scope.datePicker.pickDate = moment($scope.datePicker.date).clone().date(day).toDate();
	}
	
	
	$scope.$root.$on("query", function(event, args){
		$http.post(
			queryPath,
			'searchDate='+$filter('date')($scope.searchDate,'yyyyMMdd')
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.datalist = data;
			$scope.getSumPrice();
			if(args.feedback != undefined){
				args.feedback();
			}
		});
	});
	$scope.$root.$emit("query", {});
	
	$scope.deleteRow = function(rowNum){
		$scope.datalist.splice(rowNum,1);
	};
	
	
	$scope.addCard = function(guid){
		if(guid != undefined){
			$scope.$root.$emit("loadOCard", {'guid' : guid});
		} else {
			$scope.$root.$emit("loadOCard", {});
		}

	}
	
	$scope.editCard = function(cardGuid){
		$('eidtOrderCard').show();
	}
	
	$scope.getSumPrice = function(){
		$scope.SUM_PRICE = 0;
		for(var i =0 ; i< $scope.datalist.length;i++){
			$scope.SUM_PRICE += $scope.datalist[i].sumPrice;
		}
		
	}
	
	$scope.orderCardPayed = function(){
		$http.post(
			orderCardPayedPath,
			'guid='+$scope.orderCard.GUID
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.$root.$emit("query", {});
		});
	};
	
	$scope.cardDetailOut = function(guid){
		$http.post(
			cardDetailOutPath,
			'guid='+guid
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.$root.$emit("query", {});
		});
	}
	
	$scope.orderCardDelete = function(guid){
		$scope.$root.$emit("orderCardDelete", {'orderCardGuid' : guid});
	};
	
	$scope.orderCardPayed = function(guid){
		$scope.$root.$emit("orderCardPayed", {'orderCardGuid' : guid});
	};
	
	$scope.showDatePicker = function(){
		showDialog();
	}
	
	$scope.datePickerConfirm = function(){
		$scope.searchDate = moment($scope.datePicker.pickDate).clone().toDate();
		searchDate = $scope.searchDate;
		$scope.$root.$emit("query", {feedback: hideDialog});
	}
});

$(function(){
	$('.mdl-dialog__obfuscator').click(function(){
		hideDialog();
	})
	$('.mdl-dialog-control__cancel').click(function(){
		hideDialog();
	});
});
function showDialog(){
	$('.mdl-dialog__container').css('margin-left',-$('.mdl-dialog__container').width()/2).addClass('is-visible');
	$('.mdl-dialog__obfuscator').addClass('is-visible');
}
function hideDialog(){
	$('.mdl-dialog__container').removeClass('is-visible');
	$('.mdl-dialog__obfuscator').removeClass('is-visible');
}
var app = angular.module('orderSystem', []);
app.controller('historyQuery', function($scope, $http, $filter){
	$scope.datalist = [];
	$scope.searchSDate = moment(new Date()).startOf('week').toDate();
	$scope.searchEDate = moment(new Date()).endOf('week').toDate();
	$scope.SUM_PRICE = 0;
	$scope.detail_type = 'pieChart';

	var TYPE_LABEL = {
			0 : '飲料',
			1 : '甜點',
			2 : '輕食'
		};
	$scope.GROUP_TYPE_LABEL = [
			'類型',
			'時間',
			'桌次'
	];
	$scope.GROUP_TYPE = 0;
	$scope.getSumPrice = function(){
		$scope.SUM_PRICE = 0;
		for(var i =0 ; i< $scope.datalist.length;i++){
			$scope.SUM_PRICE += $scope.datalist[i].detail_price;
		}
	};
	
	$scope.query = function(){
		$http.post(
			queryPath,
			'searchSDate='+$filter('date')($scope.searchSDate,'yyyyMMdd')+'&'+
			'searchEDate='+$filter('date')($scope.searchEDate,'yyyyMMdd')+'&'+
			'searchType='+$scope.GROUP_TYPE
			,
			{headers: {'Content-Type': 'application/x-www-form-urlencoded'}}
		).success(function(data, status, headers, config) {
			$scope.datalist = data.gridData;
			$scope.getSumPrice();
			if(data!=null && $(data.pieChartData).size()!=0){				
				showFlotPie(data.pieChartData);
			}
			$('#flot_info').html('');
		});
	}
	$scope.query();
	$scope.exportExcel = function(){
		document.getElementById("excelForm").submit();
	}
	$scope.changeType = function(change){
		$scope.GROUP_TYPE = $scope.GROUP_TYPE + change;
		if($scope.GROUP_TYPE<0){
			$scope.GROUP_TYPE = $scope.GROUP_TYPE_LABEL.length -1;
		} else if ($scope.GROUP_TYPE == $scope.GROUP_TYPE_LABEL.length){
			$scope.GROUP_TYPE = 0;
		}
		$scope.query();
	}
	$scope.changeDetail =function(){
		if($scope.detail_type == 'pieChart'){
			$scope.detail_type = 'listChart';
		} else if($scope.detail_type == 'listChart'){
			$scope.detail_type = 'pieChart';
		}
		$('#flot_info').html('');
	}
	/**
	 * Date Picker
	 */
	$scope.datePicker = {};
	//$scope.datePicker.pickType = '';
	$scope.datePicker.pickDate = new Date();	//選擇的日子
	$scope.datePicker.today = new Date();		//紀錄今天
	$scope.datePicker.date = new Date();		//目前頁面
	
	//20151208 [add] limit funciton
	$scope.datePicker.startDate = undefined;
	$scope.datePicker.endDate = undefined;
	
	$scope.datePicker.weekdays = moment.weekdaysMin();
	$scope.datePicker.dayArray = [];
	//20151208 [modify] create day array
	$scope.datePicker.monthDays = function(){
		var date = moment($scope.datePicker.date);
		$scope.datePicker.dayArray = [];
		for (var i=0;i<date.startOf('month').day();i++){
			$scope.datePicker.dayArray.push({
				value : ''
			});
		}
		var today = moment($scope.datePicker.today);
		var pickDate = moment($scope.datePicker.pickDate);
		for (var i=1;i<=date.endOf('month').date();i++) {
			var isDsiabled = true;
			if($scope.datePicker.startDate != undefined){
				isDsiabled = isDsiabled && (date.date(i).isAfter($scope.datePicker.startDate) || date.date(i).isSame($scope.datePicker.startDate));
			}
			if($scope.datePicker.endDate != undefined){
				isDsiabled = isDsiabled && (date.date(i).isBefore($scope.datePicker.endDate) || date.date(i).isSame($scope.datePicker.endDate));
			}
			$scope.datePicker.dayArray.push({
				value : i,
				isTody : today.isSame($scope.datePicker.date,'month') && (today.date() == i),
				isDisabled : !isDsiabled
			});
		}
	}

	$scope.datePicker.isEqual = function(day){
		var pickDate = moment($scope.datePicker.pickDate);
	    return pickDate.isSame($scope.datePicker.date,'month') && (pickDate.date() == day);
	}
	
	$scope.datePicker.pick = function(day){
		if(!day.isDisabled){
			var tempDate = moment($scope.datePicker.date).clone().date(day.value);
			$scope.datePicker.pickDate = tempDate.toDate();
		}
	}
	
	$scope.datePicker.showDatePicker = function(pickDate,limitDate){
		$scope.datePicker.pickDate = pickDate;
		$scope.datePicker.date = moment(pickDate).clone().toDate();
		$scope.datePicker.startDate = limitDate.start;
		$scope.datePicker.endDate = limitDate.end;
		$scope.datePicker.monthDays();
		showDialog();
	}
	
	
	$scope.datePickerConfirm = function(){
		if($scope.datePicker.startDate != undefined){
			$scope.searchEDate = $scope.datePicker.pickDate;
		}
		if($scope.datePicker.endDate != undefined){
			$scope.searchSDate = $scope.datePicker.pickDate;
		}
		
		hideDialog();
	}
	
	function showFlotPie(dataSet){
		var options = {
			series : {
				pie : {
					radius : 1,  
					innerRadius : 0.5,
					show : true,
					label:{
						
						radius: 1,
						formatter: function (label, series) {
							var labelHtml = '';
							labelHtml += '<div style="border:1px solid gray;font-size:8pt;text-align:center;padding:5px;color:white;">';
							labelHtml += $scope.GROUP_TYPE==0?TYPE_LABEL[label]:label;
							//labelHtml += '-'+Math.round(series.percent) + '%';
							labelHtml += '</div>';
                            return labelHtml;
                       },
						background: {
                            opacity: 0.5,
                            color: '#000'
                        },
						/*show : false*/
					}
				}
			},
			legend: {
                show: false
            },
			grid : {
				hoverable:true,
				clickable:true
			}
		}
		var mainWidth = Number($('main').css('width').replace('px',''));
		var mainHeight = Number($('main').css('height').replace('px',''));
		var size = (mainWidth > mainHeight)?mainHeight:mainWidth;
		$.plot($('#flot_pane').css('height',size+'px').css('width',size+'px'),dataSet, options);
		//alert($('#flot_pane').css('height') + ' x ' +$('#flot_pane').css('width'));
		$('#flot_pane').bind('plotclick',function(event, pos, obj){
			if (!obj){return;}
			/*var percent = Math.round(obj.series.percent);
			var colorLabel = '<div style="display:inline-block;vertical-align: text-top;width:25px;height:20px;background-color:'+obj.series.color+';"></div>';
			var label = $scope.GROUP_TYPE==0?TYPE_LABEL[obj.series.label]:obj.series.label;
			$('#flot_info').html(colorLabel +" "+ label +" $"+obj.series.data[0][1] + " ("+ percent+ "%)"+" 數量 : "+obj.series.num);
			*/
		});
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


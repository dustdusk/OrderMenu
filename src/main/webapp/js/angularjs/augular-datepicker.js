(function(window, angular, undefined) {'use strict';

	var ngDatepickerModule = angular.module('ngDatepicker', []).provider('$datepicker', $DatePickerProvider);
	function $DatePickerProvider(){
		this.pickDate = new Date();
		this.today = new Date();
		this.date = new Date();
		
		var weekdays = moment.weekdaysMin();
		function monthDays(){
			var date = moment(date);
			var dayArray = [];
			for (var i=0;i<date.startOf('month').day();i++){
				dayArray.push('');
			}
			for (var i=1;i<=date.endOf('month').date();i++) {
				dayArray.push(i);
			}
			return dayArray;
		}
		function isToday(day){
			var today = moment(today);
			return today.isSame(date,'month') && (today.date() == day);
		}
		function isEauql(day){
			var pickDate = moment(pickDate);
		    return pickDate.isSame(date,'month') && (pickDate.date() == day);
		}
		function pick(day){
			pickDate = moment(date).clone().date(day).toDate();
		}
		
		this.$get = [];
	}

})(window, window.angular);
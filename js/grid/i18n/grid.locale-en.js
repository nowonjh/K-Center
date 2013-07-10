;(function($){
/**
 * jqGrid English Translation
 * Tony Tomov tony@trirand.com
 * http://trirand.com/blog/ 
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
**/
$.jgrid = {
	defaults : {
		recordtext: "{0} - {1}",
		emptyrecords: "데이터가 없습니다.",
		loadtext: "Loading...",
		pgtext : "페이지 {0}  총페이지 {1}"
	},
	search : {
		caption: "검색",
		Find: "검색",
		Reset: "초기화",
		odata : ['동일', 'not equal', '<', '<=','>','>=', '시작','does not begin with','is in','is not in','끝','does not end with','포함','does not contain'],
		groupOps: [	{ op: "AND", text: "all" },	{ op: "OR",  text: "any" }	],
		matchText: " match",
		rulesText: " rules"
	},
	edit : {
		addCaption: "저장",
		editCaption: "Edit Record",
		bSubmit: "저장",
		bCancel: "취소",
		bClose: "닫기",
		saveData: "Data has been changed! Save changes?",
		bYes : "예",
		bNo : "아니오",
		bExit : "Cancel",
		msg: {
			required:"필수 입력",
			number:"숫자만 입력가능 합니다.",
			minValue:"보다 작거나 같습니다.",
			maxValue:"보다 크거나 같습니다.",
			email: "is not a valid e-mail",
			integer: "Please, enter valid integer value",
			date: "Please, enter valid date value",
			url: "URL 형식 오류. ('http://' or 'https://')",
			ip:"IP 형식 오류.",
			nodefined : " is not defined!",
			novalue : " return value is required!",
			customarray : "Custom function should return array!",
			customfcheck : "Custom function should be present in case of custom checking!"
		}
	},
	view : {
		caption: "View Record",
		bClose: "Close"
	},
	del : {
		caption: "삭제",
		msg: "선택된 항목을 삭제하시겠습니까?",
		bSubmit: "삭제",
		bCancel: "취소"
	},
	nav : {
		edittext: "",
		edittitle: "Edit selected row",
		addtext:"추가",
		addtitle: "추가",
		deltext: "삭제",
		deltitle: "삭제",
		searchtext: "검색",
		searchtitle: "검색",
		refreshtext: "새로고침",
		refreshtitle: "새로고침",
		alertcap: "오류",
		alerttext: "선택된 항목이 없습니다.",
		viewtext: "",
		viewtitle: "View selected row"
	},
	col : {
		caption: "Select columns",
		bSubmit: "Ok",
		bCancel: "Cancel"
	},
	errors : {
		errcap : "Error",
		nourl : "No url is set",
		norecords: "No records to process",
		model : "Length of colNames <> colModel!"
	},
	formatter : {
		integer : {thousandsSeparator: " ", defaultValue: '0'},
		number : {decimalSeparator:".", thousandsSeparator: " ", decimalPlaces: 2, defaultValue: '0.00'},
		currency : {decimalSeparator:".", thousandsSeparator: " ", decimalPlaces: 2, prefix: "", suffix:"", defaultValue: '0.00'},
		date : {
			dayNames:   [
				"Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat",
				"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
			],
			monthNames: [
				"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
			],
			AmPm : ["am","pm","AM","PM"],
			S: function (j) {return j < 11 || j > 13 ? ['st', 'nd', 'rd', 'th'][Math.min((j - 1) % 10, 3)] : 'th'},
			srcformat: 'Y-m-d',
			newformat: 'd/m/Y',
			masks : {
				ISO8601Long:"Y-m-d H:i:s",
				ISO8601Short:"Y-m-d",
				ShortDate: "n/j/Y",
				LongDate: "l, F d, Y",
				FullDateTime: "l, F d, Y g:i:s A",
				MonthDay: "F d",
				ShortTime: "g:i A",
				LongTime: "g:i:s A",
				SortableDateTime: "Y-m-d\\TH:i:s",
				UniversalSortableDateTime: "Y-m-d H:i:sO",
				YearMonth: "F, Y"
			},
			reformatAfterEdit : false
		},
		baseLinkUrl: '',
		showAction: '',
		target: '',
		checkbox : {disabled:true},
		idName : 'id'
	}
};
})(jQuery);

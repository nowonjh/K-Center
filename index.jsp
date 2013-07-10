<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	if(session.getAttribute("isLogin") != "true"){
		response.sendRedirect("login.jsp");
	}


 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Knowledge Center</title>

<link rel="icon" href="images/igloo.ico" type="image/x-icon" />
<link rel="shortcut icon" href="images/igloo.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="css/common.css" />
<link rel="stylesheet" type="text/css" href="css/custom-theme/jquery-ui-1.8.17.custom.css" />
<link rel="stylesheet" type="text/css" media="screen" href="css/ui.jqgrid.css" />
<style type="text/css">

h3 {
	margin-top:0px
}

.ellipsis {
	white-space:nowrap;overflow:hidden;text-overflow:ellipsis
}

.category_list {
	width:180px;
	height:510px;
	padding:0px;
	color:#333;
	border:1px solid #cccccc; 
	margin:0px 10px 0px 0px;
	overflow-y:auto;
}

.category_list #category_list {
	list-style-type: none;
	margin: 0;
	padding: 0;
}

.category_list .ui-selecting { 
	background: #b2e1ff;
}

.category_list .ui-selected { 
	background: #7fceff;
}

.category_list #category_list li {
	text-align: left;
	margin: 3px;
	padding: 0.4em;
	height: 18px;
	overflow:hidden;
	white-space:nowrap;
	text-overflow:ellipsis;
	cursor: pointer;
}
.category_list #category_list li:hover {
	background: #b2e1ff;
}

.category_list #category_list .ui-selected:hover {
	background: #7fceff;
}

</style>
<script type="text/javascript" src="js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.17.custom.min.js"></script>
<script type='text/javascript' src='js/grid/i18n/grid.locale-en.js'></script>
<script type='text/javascript' src='js/grid/jquery.jqGrid.src.js'></script>
<script type="text/javascript" src="js/ajaxfileupload.js"></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type='text/javascript' src='js/common.js'></script>

<script type="text/javascript">
var grid_list = [];

var ip = {
		"category" : "ip",
		"title" : "유해 IP",
		"get_url" : "getblacklist.jsp",
		"edit_url" : "editblacklist.jsp",
		"columns":["유해 IP", "내용", "구분", "국가", "등록일"],
		"columns_model" :[
			{name:'title',index:'title', width:132, editable:true, editoptions:{size:20}, editrules: { required: true, ip:true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true} },
			{name:'description',index:'description', width:300, editable:true, searchoptions:{sopt:['cn','eq', 'bw', 'ew']}, edittype: "textarea", editoptions:{rows:"10",cols:"50"}, editrules: { required: true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'ext1',index:'ext1', width:130, align:"center", editable:true, edittype: "select", stype:"select", searchoptions:{sopt:['eq'], value:'피싱 사이트:피싱 사이트;C&C IP:C&C IP;악성코드 유포지:악성코드 유포지' }, editoptions:{value:"피싱 사이트:피싱 사이트;C&C IP:C&C IP;악성코드 유포지:악성코드 유포지"}},
			{name:'ext2',index:'ext2', width:120, align:"center", searchoptions:{sopt:['cn','eq', 'bw', 'ew']}},
			{name:'idate',index:'idate', width:130, search:false, align:"center"}
		],
		"editOpt": {width:400, height:290,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"addOpt": {width:400, height:290,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"delOpt": {reloadAfterSubmit:true, afterSubmit:afterSubmit}
}

var url = {
		"category" : "url",
		"title" : "유해 URL",
		"get_url" : "getblacklist.jsp",
		"edit_url" : "editblacklist.jsp",
		"columns":["유해 URL", "내용", "구분", "등록일"],
		"columns_model" :[
			{name:'title',index:'title', width:200, editable:true, edittype: "textarea", editoptions:{rows:"3",cols:"50"}, editrules: { required: true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true} },
			{name:'description',index:'description', width:350, editable:true, edittype: "textarea", editoptions:{rows:"10",cols:"50"}, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'ext1',index:'ext1', width:130, align:"center", editable:true, edittype: "select", editoptions:{value:"피싱 사이트:피싱 사이트;C&C IP:C&C IP;악성코드 유포지:악성코드 유포지"}, stype:"select", searchoptions:{sopt:['eq'], value:'피싱 사이트:피싱 사이트;C&C IP:C&C IP;악성코드 유포지:악성코드 유포지' }},
			{name:'idate',index:'idate', width:130, search:false, align:"center"}
		],
		"editOpt": {width:400, height:320,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"addOpt": {width:400, height:320,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"delOpt": {reloadAfterSubmit:true, afterSubmit:afterSubmit}
}

var port = {
		"category" : "port",
		"title" : "취약 포트",
		"get_url" : "getblacklist.jsp",
		"edit_url" : "editblacklist.jsp",
		"columns":["취약 포트", "내용", "Protocol", "등록일"],
		"columns_model" :[
			{name:'title',index:'title', width:200, editable:true, editoptions:{size:20}, editrules: { required: true, number:true, minValue:1, maxValue:65535 }, searchoptions:{ sopt:['cn','eq', 'le', 'lt', 'ge', 'gt', 'bw', 'ew'] }, searchrules:{required:true} },
			{name:'description',index:'description', width:350, editable:true, edittype: "textarea", editoptions:{rows:"10",cols:"50"}, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'ext1',index:'ext1', width:120, align:"center", editable:true, edittype: "select", editoptions:{value:"TCP:TCP;UDP:UDP;ICMP:ICMP"}, stype:"select", searchoptions:{sopt:['eq'], value:"TCP:TCP;UDP:UDP;ICMP:ICMP" }},
			{name:'idate',index:'idate', width:130, search:false, align:"center"}
		],
		"editOpt": {width:400, height:290,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"addOpt": {width:400, height:290,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"delOpt": {reloadAfterSubmit:true, afterSubmit:afterSubmit}
}

var issue = {
		"category" : "issue",
		"title" : "이슈",
		"get_url" : "getnewslist.jsp",
		"edit_url" : "editnews.jsp",
		"columns":["제목", "내용", "등록일"],
		"columns_model" :[
			{name:'title',index:'title', width:350, editable:true, editoptions:{size:99}, editrules: { required: true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'url',index:'url', width:350, editable:true, edittype: "textarea", editoptions:{rows:"20",cols:"100"}, searchoptions:{ sopt:['cn', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'idate',index:'idate', width:130, search:false, align:"center"}
		],
		"editOpt": {width:680, height:410,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"addOpt": {width:680, height:410,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"delOpt": {reloadAfterSubmit:true, afterSubmit:afterSubmit}
}

var news = {
		"category" : "news",
		"title" : "뉴스",
		"get_url" : "getnewslist.jsp",
		"edit_url" : "editnews.jsp",
		"columns":["제목", "URL", "등록일"],
		"columns_model" :[
			{name:'title',index:'title', width:350, editable:true, editoptions:{size:49}, editrules: { required: true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'url',index:'url', width:350, editable:true, edittype: "textarea", editoptions:{rows:"10",cols:"50"}, editrules: { required: true, url:true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'idate',index:'idate', width:130, search:false, align:"center"}
		],
		"editOpt": {width:380, height:270,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"addOpt": {width:380, height:270,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"delOpt": {reloadAfterSubmit:true, afterSubmit:afterSubmit}
}

var report = {
		"category" : "report",
		"title" : "분석 보고서",
		"get_url" : "getnewslist.jsp",
		"edit_url" : "editnews.jsp",
		"columns":["제목", "URL", "등록일"],
		"columns_model" :[
			{name:'title',index:'title', width:350, editable:true, editoptions:{size:49}, editrules: { required: true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'url',index:'url', width:350, editable:true, edittype: "textarea", editoptions:{rows:"10",cols:"50"}, editrules: { required: true, url:true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'idate',index:'idate', width:130, search:false, align:"center"}
		],
		"editOpt": {width:380, height:270,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"addOpt": {width:380, height:270,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"delOpt": {reloadAfterSubmit:true, afterSubmit:afterSubmit}
}

var hacking = {
		"category" : "hacking",
		"title" : "해킹정보",
		"get_url" : "getnewslist.jsp",
		"edit_url" : "editnews.jsp",
		"columns":["제목", "URL", "등록일"],
		"columns_model" :[
			{name:'title',index:'title', width:350, editable:true, editoptions:{size:49}, editrules: { required: true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'url',index:'url', width:350, editable:true, edittype: "textarea", editoptions:{rows:"10",cols:"50"}, editrules: { required: true, url:true }, searchoptions:{ sopt:['cn','eq', 'bw', 'ew'] }, searchrules:{required:true}, cellattr: function (rowId, tv, rawObject, cm, rdata) { return 'style="text-overflow:ellipsis;white-space:nowrap"' }},
			{name:'idate',index:'idate', width:130, search:false, align:"center"}
		],
		"editOpt": {width:380, height:270,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"addOpt": {width:380, height:270,reloadAfterSubmit:true, afterSubmit:afterSubmit},
		"delOpt": {reloadAfterSubmit:true, afterSubmit:afterSubmit}
}

$(document).ready(function(){
	$.jgrid.formatter.integer = {thousandsSeparator: ","};
	$("[id$=Button]").button();
	
	$("#fileAddDialog #fileAddForm #download_button").click(function(e){
		//location.href = "download.jsp?filename=form_" + $("#fileAddDialog #fileAddForm #category").val() + ".xlsx";
		window.open("download.jsp?filename=form_" + $("#fileAddDialog #fileAddForm #category").val() + ".xlsx", "download", "width=500, height=200");
	});

	
	/* BlackList Dialog Init */
	$("#fileAddDialog").dialog({
		title:"Excel 파일로 등록",
		autoOpen: false,
		height: "auto",
		width: "400px",
		modal: true,
		resizable: false,
		buttons: {
			"등록": function() {
				var category = $("#fileAddForm #category").val();
				$.ajaxFileUpload({
					url:"/addexcelfile.jsp?category=" + category,
					secureuri:true,
					fileElementId:"file",
					success: function (response){
						trace(1, $("body").height() * 0.3);
						$("#alertMessageText").html($(response).find("body").html());
						$("#alertMessage").dialog({
						    autoOpen: true,
						    resizable: false,
							modal: true,
							width : 400,
							height : "auto",
							top: 10,
							buttons: {
								"닫기": function() {
								    $(this).dialog("destroy");
								}
							}
						});
						
						getList(eval(category));
					},
					error: function(response, status, err) {
					}
				});
			},
			"닫기": function() {
				$(this).dialog("close");
			}
		},
		close : function(){
			
		}
	});
	
	/* category list selectable*/
	$("#category_list").selectable({
	}).bind("selectableselected", function(event, ui) {
		var category = "";
		var category_text = "";

		if (event != undefined && ui != undefined) {
			category = ui.selected.id;
			category_text = ui.selected.innerHTML;
		}
        else {
        	category = $("#category_list").find(".ui-selected").attr("id");
        	category_text = $("#category_list").find(".ui-selected").html();
        }
		$("#fileAddForm").find("#category").val(category);
		$("#fileAddForm").find("#fileAddCategory").html(category_text);
		$("#fileAddForm").find("#download_form").html(category_text + " 양식 다운로드");
		getList(eval(category));
	});
	$("#category_list").find("li:eq(0)").addClass("ui-selected");
	$("#category_list").trigger("selectableselected");
});

/* 입력, 수정, 삭제 결과*/
function afterSubmit(response, data){
	var result_stat = true;
	var result_text = "";
	
	var res = response.responseText.trim().split("#");
	if(res[1] == "success"){
		$.growlUI(res[2],'',3000); 
	}
	else if(res[1] == "fail"){
		result_stat = false;
		result_text = res[2];
	}
	
	return [result_stat, result_text];
}

/* 해당 카테고리의 데이터를 뿌려준다.*/
function getList(init){
	$("#content").find("#title").html(init.title);
	$("#content #category").val(init.category);
	$("#content").find("#list, #list_page").empty();
	
	$.each(grid_list, function(index, value){
		$(value).jqGrid("GridUnload");
	});
	
	var grid = $("#list").jqGrid({
		url: "/" + init.get_url + "?category=" + init.category,
		datatype: "json",
		height: 460,
		rowNum: 20,
		width:880,
		rowList: [20,50,100],
		//forceFit:true,
		colNames:init.columns,
		colModel:init.columns_model,
		multiselect : "true",
		pager: "#list_page",
		viewrecords: true,
		editurl:"/" + init.edit_url + "?category=" + init.category
	});
	

 	$("#list").jqGrid('navGrid','#list_page',
		{edit:false, add:true, del:true, search:true, excel:false}, 
		{},
		init.addOpt, 
		init.delOpt, 
		{multipleSearch:true}
	);
	grid_list.push(grid);
	
	$("#list_page_right #export_excel").append("<div class='ui-pg-div'><img src='images/export_excel.png' style='vertical-align:top' width='16px'>엑셀등록</div>");
	$("#list_page_right #export_pdf").append("<div class='ui-pg-div'><img src='images/export_pdf.png' style='vertical-align:top' width='16px'>PDF 등록</div>");
	$("#list_page_right #export_excel")
		.attr({"title":"엑셀등록" || "",id: "export_excel"})
		.click(function(){
			$("#fileAddDialog").dialog("open");
			return false;
		}).hover(function () {
			if (!$(this).hasClass('ui-state-disabled')) {
				$(this).addClass("ui-state-hover");
			}
		},
		function () {$(this).removeClass("ui-state-hover");}
	);
	
	$("#list_page_right #export_pdf")
		.attr({"title":"PDF등록" || "",id: "export_pdf"})
		.click(function(){
			pdfDialog();
			return false;
		}).hover(function () {
			if (!$(this).hasClass('ui-state-disabled')) {
				$(this).addClass("ui-state-hover");
			}
		},
		function () {$(this).removeClass("ui-state-hover");}
	);
}
function pdfDialog(){
	
	$("#pdfDialog").dialog({
		title:"PDF 파일로 등록",
		autoOpen: true,
		height: "auto",
		width: "400px",
		modal: true,
		resizable: false,
		buttons: {
			"등록": function() {
				$.ajaxFileUpload({
					url:"upload_service",
					type : "POST",
					dataType : "json",
					data : {"service" : "PDFExport", "method": "test", 
							"param" : "" },
					secureuri:true,
					fileElementId:"pdffile",
					success: function (response){
						trace(1, response);
						if(response.fail != undefined){
							alertMsg("", response.fail);
						}
						else{
							
							$("#pdfConfirmDialog").dialog({
								title:"PDF 파일로 등록",
								autoOpen: true,
								height: "auto",
								width: "750px",
								modal: true,
								resizable: false,
								buttons: {
									"닫기": function() {
										$(this).dialog("close");
									}
								},
								close : function(){
									$(this).dialog("destroy");
								}
							});
							
							var exception_list = "";
							if(response.exception_list.length > 0){
								$.each(response.exception_list, function(index, value){
									exception_list += "[<font color=\"#f00\">" + value + "</font>] ";
								});
							}
							
							
							$("#pdfConfirmDialog").find("#metadata").empty().append("<b>총 <font color=\"#f00\">" + response.metadata.tot_cnt + "</font> 건의 항목 중 " + 
									"IP(<font color=\"#f00\">" + response.metadata.ip_cnt + "</font> 건), URL(<font color=\"#f00\">" + response.metadata.url_cnt + "</font> 건) 이 확인되었으며,\n" +
									"<font color=\"#f00\">" + response.exception_list.length + "</font> 건 의 Exception 발생.</b>" + 
									"<font color=\"#f00\">" + ((response.metadata.ip_cnt + response.metadata.url_cnt) - (response.metadata.tot_cnt - response.exception_list.length)) + "</font> 건 의 중복항목이 존재함.</b>" +
									(exception_list.length > 0 ? "\n\n<br> <b>Exception List(num) :</b> " + exception_list : ""));
									
							$.each(response, function(key, item){
								var node = $("#pdfConfirmDialog").find("#content").find("#" + key).find("tbody");
								node.empty();
								$.each(item, function(index, value){
									node.append(
										"<tr><td><input type=\"button\" id=\"button" + index + "\" value=\"등록\"></td>" +
										"<td align=\"center\">" + value.num + "</td>" + 
										"<td><input type=\"text\" id=\"title" + index + "\" value=\"" + value.title + "\" size=\"16\"></td>" + 
										"<td><input type=\"text\" id=\"content" + index + "\" value=\"" + value.content + "\" size=\"55\"></td>" + 
										"<td><input type=\"text\" id=\"category" + index + "\" value=\"" + value.category + "\" size=\"12\"></td></tr>"
									);
								});
								$("#pdfConfirmDialog").find("#content").find("#" + key).find("[type=button]").button().click(function(e){
									addPdfOne(e);
								})
							});
							
						}
						
					},						
					error: function(response, status, err) {
					}
				});
			},
			"닫기": function() {
				$(this).dialog("close");
			}
		},
		close : function(){
			$(this).dialog("destroy");
		}
	});
}
function addPdfOne(e){
	var category = $(e.target).parents("table").attr("id").split("_")[0];
	var oper = "add";
	var ext1 = $(e.target).parents("tr").find("[id^=category]").val();
	var title = $(e.target).parents("tr").find("[id^=title]").val();
	var description = $(e.target).parents("tr").find("[id^=content]").val();
	
	var param = "oper=" + oper +
				"&title=" + title +
				"&category=" + category+
				"&ext1=" + ext1 +
				"&description=" + description;
	$.ajax({
        url: "editblacklist.jsp",
        type: "POST",
        data: param ,
        success: function (response) {
        	var res = response.trim().split("#");
        	if(res[1] == "success"){
        		$.growlUI(res[2],'',3000);
        		$(e.target).parents("tr").addClass("ui-state-disabled").find("input").attr("disabled", true);
        	}
        	else if(res[1] == "fail"){
        		$(e.target).parents("tr").css("background", "#fe5c5c")
        		alertMsg("", res[2]);
        	}
        },
        error: function (response, status, err) {
           
            alertMsg("", "네트워크 오류가 발생했습니다.<br>다시 시도해주세요.");
        }
    });
	
}

function addItem(){
	var url_list = [];
	var ip_list = [];
	$.each($("#pdfConfirmDialog").find("#content").find("#url_list").find("[id^=check]:checked").parents("tr"), function(index, value){
		var item = {}
		item["title"] = $(value).find("[id^=title]").val();
		item["content"] = $(value).find("[id^=content]").val();
		item["category"] = $(value).find("[id^=category]").val();
		url_list.push(item);
	});
	$.each($("#pdfConfirmDialog").find("#content").find("#ip_list").find("[id^=check]:checked").parents("tr"), function(index, value){
		var item = {}
		item["title"] = $(value).find("[id^=title]").val();
		item["content"] = $(value).find("[id^=content]").val();
		item["category"] = $(value).find("[id^=category]").val();
		ip_list.push(item);
	});
	var list = {"ip_list" : ip_list,
		"url_list" :url_list}
	trace(1, list);
}


</script>

</head>

<body topmargin="0" leftmargin="0">

<table style="margin-top:30px"width="1000" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
	<td align="center" colspan="2"><h1> Knowledge Center</h1></td>
</tr>
<tr>
	<td colspan="2">
		<div style="padding: 0px 0px 5px 3px;"></div>
		<hr style="width:100%">
	</td>
</tr>
<tr>
	<td colspan="2" align="right">
		<a href="logout_proc.jsp">로그아웃</a>
	</td>
</tr>
<tr>
	<td style="vertical-align:top;padding-top:45px">
	<div class="category_list">
		<ol id="category_list">
			<li title="유해 IP" id="ip"> 유해IP </li>
			<li title="유해 URL" id="url"> 유해 URL </li>
			<li title="취약 포트" id="port"> 취약 포트 </li>
			<hr/>
			<li title="이슈" id="issue"> 이슈 </li>
			<li title="뉴스" id="news"> 뉴스 </li>
			<li title="해킹정보" id="hacking"> 해킹정보 </li>
			<li title="분석 보고서" id="report"> 분석 보고서 </li>
			
		</ol>
	</div>
	</td>
	<td>
		<table width="880" border="0" cellspacing="0" cellpadding="3"> 
			<tr>
				<td>
					<div id="content" style="width:880px;height:600px">
					
						<h3 id="title" style="font-color:#fe8e43"></h3>
						<table width="880" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 10px">
			               <tbody><tr>
			                <td height="3" width="200" bgcolor="#666666"></td>
			                <td width="680" bgcolor="#cbcaca"></td>
			              </tr>
			            	</tbody>
			            </table>
			           
			            <table id="list"></table>
						<div id="list_page"></div>
						
					</div>
					
					
				</td>
 			</tr> 
		</table>
	</td>
</tr>
</table>

<div id="fileAddDialog" style="align:center">
	<form id="fileAddForm" method="POST" enctype="multipart/form-data" action="/center/upload_service">
		<input type="hidden" name="category" id="category" value="">
		<table border="0" cellspacing="1" cellpadding="0">
			<tr align="left">
				<td class="grid_bgcolor">분류</label></td>
				<td class="padding_left"><label id="fileAddCategory"></label></td>
			</tr>
			<tr align="left">
				<td class="grid_bgcolor">파일</label></td>
				<td class="padding_left"><input type="file" name="file" id="file"></td>
			</tr>
			<tr align="left">
				<td class="grid_bgcolor">양식 다운로드</label></td>
				<td class="padding_left" style="cursor:pointer" id="download_button"><img src="images/export_excel.png" width="25" style="vertical-align:bottom"><span id="download_form"></span></td>
			</tr>
		</table>
	</form>
</div>

<div id="pdfDialog" style="align:center;display:none">
	<form id="pdfForm" method="POST" enctype="multipart/form-data" action="/center/upload_service">
		<table border="0" cellspacing="1" cellpadding="0">
			<tr align="left">
				<td class="grid_bgcolor">파일</label></td>
				<td class="padding_left"><input type="file" name="pdffile" id="pdffile"></td>
			</tr>
		</table>
	</form>
</div>
<div id="pdfConfirmDialog" style="align:center;display:none">
	
	<div id="content" style="max-height:500px">
		<div id="metadata"></div>
		<h3 style="margin:10px">유해IP</h3>
		<table id="ip_list">
			<thead>
				<tr>
					<th></th>
					<th width="40">번호</th>
					<th width="100">IP</th>
					<th width="380">내용</th>
					<th width="80">구분</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<h3 style="margin:10px">유해URL</h3>
		<table id="url_list">
			<thead>
				<tr>
					<th></th>
					<th width="40">번호</th>
					<th width="100">URL</th>
					<th width="380">내용</th>
					<th width="80">구분</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		
	</div>
	
</div>
<div id="alertMessage" style="display:none;" title="<span class='ui-icon ui-icon-alert' style='float:left;'></span>&nbsp;메세지">
<p id="alertMessageText" style="overflow-y:auto;height:auto;max-height:400px"></p>
</div>
</body>
</html>
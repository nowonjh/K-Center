<%@page import="com.igloosec.kc.CommonUtil"%>
<%@page import="com.igloosec.kc.DBHandler"%>
<%@page import="com.igloosec.kc.CacheManager"%>
<%@page import="com.igloosec.kc.LogManager"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Logger logger = LogManager.getInstance().getLogger("kc.log");
	
	String oper = CommonUtil.reqFilter(request.getParameter("oper"));
	String id = CommonUtil.reqFilter(request.getParameter("id"));
	String category = CommonUtil.reqFilter(request.getParameter("category"));
	String title = CommonUtil.reqFilter(request.getParameter("title"));
	String url = CommonUtil.reqFilter(request.getParameter("url"));

	String query = "";
	if("add".equals(oper)){
		
		if(url.getBytes().length > 4000){
			out.print(oper + "#fail#4000Byte 제한 오류!");
			return;
		}
		query = "insert into kc_reportlist (id, category, title, url, idate) values (seq_kc_reportlist.nextval,'" + category + "','" + title + "','" + url + "', sysdate)";
	}
	else if("del".equals(oper)){
		query = "delete from kc_reportlist where id in (" + id + ")";
		
	}
	
	int flag = new DBHandler().excuteUpdate("kc", query);
	if("add".equals(oper)){
		if (flag == 1) {
			out.print(oper + "#success#저장되었습니다.");
		} 
		else if (flag == 2) {
			out.print(oper + "#fail#중복된 값이 있습니다.");
		}
		else if (flag == 3) {
			out.print(oper + "#fail#예외 상황 발생.");
		}
		else if (flag == 0){
			out.print(oper + "#fail#저장 실패!");
		}
	}
	else if("del".equals(oper)){
		if (flag == 1) {
			query = "insert into kc_delete_hist()";
			new DBHandler().excuteUpdate("kc", query);
			
			out.print(oper + "#success#삭제되었습니다.");
		}
		else if (flag == 3) {
			out.print(oper + "#fail#예외 상황 발생.");
		}
		else if (flag == 0){
			out.print(oper + "#fail#삭제 실패!");
		}

	}
%>
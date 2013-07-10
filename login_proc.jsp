<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.igloosec.extrim.AuthBean" %> --%>

<%
	String filePath = System.getProperty("catalina.home") + "/conf/kc/account.properties";
	Properties accountProp = new Properties();
	File accountFile = new File(filePath);
	accountProp.load(new FileInputStream(accountFile));
	
	String id = request.getParameter("id");
	String passwd = request.getParameter("passwd");

	if(id.equals(accountProp.get("ID")) && passwd.equals(accountProp.get("PASSWD"))){
		session.setAttribute("isLogin", "true");
		response.sendRedirect("/");
	}
	else{
		response.sendRedirect("error/error.jsp?code=" + HttpServletResponse.SC_UNAUTHORIZED);
		return;
	}
%>
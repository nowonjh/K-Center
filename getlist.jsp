<%@page import="java.sql.SQLException"%>
<%@page import="java.util.Date"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.igloosec.kc.LogManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.igloosec.kc.DBHandler" %>
<%@ page import="com.igloosec.kc.CommonUtil" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<% 
	Logger logger = LogManager.getInstance().getLogger("kc.sync");

	JSONObject result = new JSONObject();
	String category = CommonUtil.reqFilter(request.getParameter("category"));
	String last_sync = CommonUtil.reqFilter(request.getParameter("last_sync"));
	String limit = CommonUtil.reqFilter(request.getParameter("limit"));
	
	String id = CommonUtil.reqFilter(request.getParameter("id"));
	String pwd = CommonUtil.reqFilter(request.getParameter("pwd"));
	
	String where = "category = '" + category + "'";
	if(last_sync != null && !"".equals(last_sync)){
		where += " and to_char(idate, 'yyyymmddhh24miss') >= '" + last_sync + "'";
	}
	String time = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
	result.put("time", time);
	/*
		인증 부분 및 라이센스 확인( 추가 예정)
	*/
	
	
	String add_query = null;
	String del_query = null;
	String[][] add_data = null;
	String[][] del_data = null;
	int columncnt = 0;
	long startTime = System.currentTimeMillis();
	
	/* 추가 항목 확인 */
	if("ip".equals(category) || "url".equals(category) || "port".equals(category)){
		columncnt = 6;
		add_query = "SELECT category, title, description, to_char(idate, 'yyyymmddhh24miss') idate, ext1, ext2 FROM kc_blacklist where " + where + " ORDER BY idate desc";
	}
	else if("hacking".equals(category) || "report".equals(category) || "news".equals(category) || "issue".equals(category)){
		columncnt = 4;
		add_query = "SELECT category, title, url, to_char(idate, 'yyyymmddhh24miss') idate FROM kc_reportlist WHERE " + where + " ORDER BY idate desc";
	}
	else{
		result.put("error", "002");
		out.println(result.toString().replaceAll("\\\\/", "/"));
		out.close();
		return;
	}
	/* 삭제 항목 확인 */
	del_query = "SELECT id, category, title, to_char(idate, 'yyyymmddhh24miss') idate FROM kc_delete_hist where " + where;
	
	try{
		add_data = new DBHandler().getNColumnData("kc", add_query);
		del_data = new DBHandler().getNColumnData("kc", del_query);
	}
	catch(SQLException e){
		result.put("error", "005");
		out.println(result.toString().replaceAll("\\\\/", "/"));
		out.close();
		return;
	}
	
	/* 추가항목 리스트 */
	List<Object> add_rows = new LinkedList<Object>();
	for(String[] row : add_data){
		Map<String, String> rowMap = new LinkedHashMap<String, String>();
		rowMap.put("category", row[0]);
		rowMap.put("title", row[1]);
		if(columncnt == 6){
			rowMap.put("ext1", row[4]);
			rowMap.put("ext2", row[5]);
			rowMap.put("description", row[2]);
		}else{
			rowMap.put("url", row[2]);
		}
		rowMap.put("idate", row[3]);
		add_rows.add(rowMap);
	}
	
	/* 삭제항목 리스트 */
	List<Object> del_rows = new LinkedList<Object>();
	for(String[] row : del_data){
		Map<String, String> rowMap = new LinkedHashMap<String, String>();
		rowMap.put("category", row[1]);
		rowMap.put("title", row[2]);
		rowMap.put("idate", row[3]);
		del_rows.add(rowMap);
	}
	
	long endTime = System.currentTimeMillis();
	
	result.put("add", add_rows);
	result.put("del", del_rows);
	logger.debug("request : " + category + " list\t\ttime required : " + ( (endTime - startTime) / 1000.0 ) + " sec.\tclient : " + request.getRemoteHost() + ":" + request.getRemotePort());
	out.print(result.toString().replaceAll("\\\\/", "/").trim());

%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.igloosec.kc.CommonUtil"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.igloosec.kc.DBHandler"%>
<%@page import="com.igloosec.kc.LogManager"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.log4j.Logger" %>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONValue"%>

<%
	Logger logger = LogManager.getInstance().getLogger("kc.log");
	JSONObject result = new JSONObject();
	
	/* jqGrid 에서 기본으로 제공되는 Parameter */
	String sort = CommonUtil.reqFilter(request.getParameter("sord"));
	String pg = CommonUtil.reqFilter(request.getParameter("page"));
	String total = CommonUtil.reqFilter(request.getParameter("nd"));
	String sidx = CommonUtil.reqFilter(request.getParameter("sidx"));
	String search = CommonUtil.reqFilter(request.getParameter("_search"));
	int row_cnt = Integer.parseInt(CommonUtil.reqFilter(request.getParameter("rows")));
	
	String category = CommonUtil.reqFilter(request.getParameter("category"));
	
	String where = "";
	String orderby = " idate desc";
	/* 검색 일때 조건 */
	if("true".equals(search)){
		where = " and (";
		String filters = CommonUtil.reqFilter(request.getParameter("filters"));
		JSONObject search_json = (JSONObject) JSONValue.parse(filters);
		
		logger.debug(search_json.get("groupOp"));
		
		List<Map<String, String>> list = (List<Map<String, String>>) search_json.get("rules");
		
		int index = 0;
		for(Map<String, String> rowMap : list){
			if("eq".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " = '" + rowMap.get("data") + "'"; 
			}
			else if("cn".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " like '%" + rowMap.get("data") + "%'"; 
			}
			else if("le".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " < " + rowMap.get("data") ; 
			}
			else if("lt".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " <= " + rowMap.get("data") ; 
			}
			else if("ge".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " > " + rowMap.get("data") ; 
			}
			else if("gt".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " >= " + rowMap.get("data") ; 
			}
			else if("bw".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " like '" + rowMap.get("data") + "%'"; 
			}
			else if("ew".equals(rowMap.get("op"))){
				where += rowMap.get("field") + " like '%" + rowMap.get("data") + "'"; 
			}
			
			if(index != list.size() - 1){
				where += " " + search_json.get("groupOp") + " ";
			}
			index++;
		}
		where += ")";
 	}
	/* sort 값이 있을때 */
	if(!"".equals(sidx)){
		orderby = sidx + " " + sort;
	}
	
	/* ip, port 일때 예외처리 */
	boolean ip_flag = false;
	boolean port_flag = false;
	if("ip".equals(category)){
		ip_flag = true;
	}
	else if("port".equals(category)){
		port_flag = true;
	}
	
	int num = Integer.parseInt(pg);
	int start = (num * row_cnt) - (row_cnt - 1);
	int end = num * row_cnt;
	
	String query = "select count(*) from kc_blacklist where category = '" + category + "' " + where; 
	String[] totcount = new DBHandler().getOneColumnData("kc", query);
	int totpage = (Integer.parseInt(totcount[0]) + (row_cnt - 1)) / row_cnt;
	
	query = "select a.* from (select rownum rn, a.* from (select id, category, " + (port_flag ? "to_number(title) title" : "title") + ", description, ext1, to_char(idate, 'yyyymmddhh24miss') datetime" +
			 (ip_flag ? ", ext2 " : "") + " from kc_blacklist where category = '" + category + "' " + where +" order by " + orderby + ")a)a  WHERE a.rn >= " + start + " and a.rn <= " + end;

	String[][] data = new DBHandler().getNColumnData("kc", query);
	List<Object> rows = new LinkedList<Object>();

	for (String[] row : data) {
		Map<String, Object> rowMap = new LinkedHashMap<String, Object>();
		rowMap.put("id", row[1]);
		List<Object> rowList = new LinkedList<Object>();
		rowList.add(row[3]);
		rowList.add(row[4]);
		rowList.add(row[5]);
		if(ip_flag){
			rowList.add(row[7]);
		}
		Calendar cal = Calendar.getInstance();
		try {
			cal.setTime(new java.text.SimpleDateFormat("yyyyMMddHHmmss").parse(row[6]));
		} catch (ParseException e) {
			logger.error(e.getMessage());
		}
		
		rowList.add(new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm").format(cal.getTime()));
		rowMap.put("cell", rowList);
		rows.add(rowMap);
	}
	
	result.put("page", pg);
	result.put("total", totpage);
	result.put("records", row_cnt);
	
	result.put("rows", rows);
	out.print(result);
%>

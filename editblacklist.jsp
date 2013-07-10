<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.igloosec.kc.CommonUtil"%>
<%@page import="com.igloosec.kc.DBHandler"%>
<%@page import="com.igloosec.kc.CacheManager"%>
<%@page import="com.igloosec.kc.LogManager"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Logger logger = LogManager.getInstance().getLogger("kc.log");
	
	String oper = CommonUtil.reqFilter(request.getParameter("oper"));
	String id = CommonUtil.reqFilter(request.getParameter("id"));
	String category = CommonUtil.reqFilter(request.getParameter("category"));
	String title = CommonUtil.reqFilter(request.getParameter("title"));
	String description = CommonUtil.reqFilter(request.getParameter("description"));
	String ext1 = CommonUtil.reqFilter(request.getParameter("ext1"));

	String query = "";
	String[][] delete_data = null;
	if("add".equals(oper)){
		/* 글자 제한 */
		if(description.getBytes().length > 4000){
			out.print(oper + "#fail#4000Byte 제한 오류!");
			return;
		}
		
		/* ip 입력시 IP 유효성 체크 */
		if("ip".equals(category)){
			String REGEX_IP = "^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))$";
			String REGEX_IPRANGE = "(^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))$)|(^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))\\/(2[0-5]{2}|1[0-9]{2}|[1-9][0-9]|[1-9])$)|(^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))~(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))$)";
			if(title.matches(REGEX_IP) == false) {
				if(title.matches(REGEX_IPRANGE) == false) {
					out.print(oper + "#fail#아이피 형식 오류!");
					return;
				}
			}
			String[] country = CacheManager.getInstance().ip2Location(title);
			query = "insert into kc_blacklist (id, category, title, description, ext1, ext2, idate) " +
					"values (seq_kc_blacklist.nextval,'" + category + "','" + title + "','" + description + "','" + ext1 + "', '" + country[1]+ "', sysdate)";
		}
		/* Port 일때 유효성 체크 */
		else if("port".equals(category)){
			String REGEX_PORT = "^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,3})$";
			if(title.matches(REGEX_PORT) == false) {
				out.print(oper + "#fail#Port 형식 오류! ex) 1 ~ 65535");
				return;
			}
			query = "insert into kc_blacklist (id, category, title, description, ext1, idate) " +
					"values (seq_kc_blacklist.nextval,'" + category + "','" + title + "','" + description + "','" + ext1 + "', sysdate)";
		}
		else if("url".equals(category)){
			query = "insert into kc_blacklist (id, category, title, description, ext1, idate) " +
					"values (seq_kc_blacklist.nextval,'" + category + "','" + title + "','" + description + "','" + ext1 + "', sysdate)";
		}
	}
	else if("del".equals(oper)){
		String[] id_array = id.split(",");
		query = "select title from kc_blacklist where id in( " + id + " )";
		delete_data = new DBHandler().getNColumnData("kc", query);
		query = "delete from kc_blacklist where category = '" + category + "' and id in (" + id + ")";
	}
	
	int flag = new DBHandler().excuteUpdate("kc", query);
	
	/* 결과 리턴 */
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
			/* 삭제후 history table에 insert */
			if(delete_data.length > 0){
				List<String> query_list = new LinkedList<String>();
				for(String[] delete_title : delete_data){
					query_list.add("insert into kc_delete_hist(id, category, title, idate) values (seq_kc_delete_hist.nextval, '" + category + "', '" + delete_title[0] + "', sysdate)");
				}
				String[] query_array = (String[]) query_list.toArray(new String[0]);
				new DBHandler().excuteBatch("kc", query_array);
			}
			
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
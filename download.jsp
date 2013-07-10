<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileNotFoundException"%>
<%@ page import="java.net.URLEncoder"%>


<%
	String filename = null;
	BufferedInputStream bis = null;
	BufferedOutputStream bos = null;
	filename = (String)request.getParameter("filename");
	byte buffer[] = new byte[1024];
	int length = 0;
	try {
		
		File downloadFile = new File(System.getProperty("catalina.home") + "/webapps/ROOT/xlsx/" + filename);
		if(!downloadFile.exists()){
			%>
			<script>
				//alert("파일이 존재하지 않습니다.");
				//window.close();
			</script>
			<%
			out.print("파일이 존재하지 않습니다.");
			return;
		}
		else{
			filename = URLEncoder.encode(filename, "utf-8");
			filename = filename.replace("+", " ");
	
			response.reset();
	
			out.clear();
			out = pageContext.pushBody();
	
			String clientStr = request.getHeader("User-Agent");
	
			if (clientStr.indexOf("MSIE 5.5") != -1) {
				response.setHeader("Content-Disposition", "filename="
						+ filename + ";");
			} else {
				response.setHeader("Content-Disposition",
						"attachment; filename=" + filename + ";");
				response.setHeader("Content-Type",
						"application/octet-stream; charset=utf-8");
			}
	
			response.setHeader("Content-Length", "" + downloadFile.length()
					+ ";");
			response.setHeader("Content-Transfer-Encoding", "binary;");
			response.setHeader("pragma", "no-cache;");
			response.setHeader("Expires", "-1");
	
			bis = new BufferedInputStream(new FileInputStream(downloadFile));
			bos = new BufferedOutputStream(response.getOutputStream());
	
			while ((length = bis.read(buffer)) > 0) {
				bos.write(buffer, 0, length);
				bos.flush();
			}
	
			bis.close();
			bos.close();
		}
	} catch (FileNotFoundException e) {
%>
<script>
	window.close();
</script>
<%
	}
%>
<script>
	window.close();
</script>
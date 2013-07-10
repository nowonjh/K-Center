<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.igloosec.kc.CacheManager"%>
<%@page import="com.igloosec.kc.DBHandler"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="com.igloosec.kc.LogManager"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="javax.naming.SizeLimitExceededException"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Logger logger = LogManager.getInstance().getLogger("kc.log");
	File tmpDir = new File(System.getProperty("java.io.tmpdir"));
	if(!tmpDir.exists()){
		tmpDir.mkdir();  
	}
	DiskFileItemFactory factory = new DiskFileItemFactory();
	factory.setSizeThreshold(1 * 1024 * 1024); // 1 MB
	factory.setRepository(tmpDir);
	ServletFileUpload upload = new ServletFileUpload(factory);
	upload.setSizeMax(5 * 1024 * 1024);
	String fileName = "";
	String contentType = "";
	long filesize = 0L;

	try {
		
		List items = upload.parseRequest(request);
		Iterator itr = items.iterator();
		while (itr.hasNext()) {
			FileItem item = (FileItem) itr.next();
			
			String separator = System.getProperty("file.separator");
			fileName = item.getName();
			filesize = item.getSize();
			if(fileName.lastIndexOf(separator) > -1){
				fileName = fileName.substring(fileName.lastIndexOf(separator) + 1, fileName.length());
			}
			item.write(new File(tmpDir, fileName));
			contentType = item.getContentType();
			logger.debug(contentType);
			
		}
	} catch(SizeLimitExceededException e){
		out.print("용량제한(5Mb)");
		logger.warn(e.getMessage());
		
	} catch (FileUploadException e) {
		logger.error(e.getMessage());
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	

	
	File file = new File(tmpDir + "/" + fileName);
	
	boolean newsTable = false;
	
	logger.debug("파일이름 = " + fileName);
	logger.debug("파일타입 = " + contentType);
	logger.debug("파일 = " + file.getPath());
	
	
	if("".equals(fileName)){
		out.print("파일을 선택해주세요.");
		return;
	}
	else if(filesize == 0){
		file.delete(); 
		out.print("파일용량이 0byte 입니다.");
		return;
	}
	else if(contentType.indexOf("application/pdf") > -1){
		
	}
	else{
		file.delete(); 
		out.print("PDF파일이 아닙니다.");
		return;
	}
	
	file.delete();

%>
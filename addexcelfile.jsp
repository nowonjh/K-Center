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
	String category = request.getParameter("category");
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
	
	logger.debug("category = " + category);
	boolean newsTable = false;
	if("hacking".equals(category) || "report".equals(category) || 
		"news".equals(category) || "issue".equals(category)){
		newsTable = true;
	}
	logger.debug("파일이름 = " + fileName);
	logger.debug("파일타입 = " + contentType);
	logger.debug("파일 = " + file.getPath());
	
	
	String[][] excelData = null;
	if("".equals(fileName)){
		out.print("파일을 선택해주세요.");
		return;
	}
	else if(filesize == 0){
		file.delete(); 
		out.print("파일용량이 0byte 입니다.");
		return;
	}
	else if(contentType.indexOf("vnd.ms-excel") > -1){
		POIFSFileSystem filein = new POIFSFileSystem(new FileInputStream(file));
		HSSFWorkbook wb = new HSSFWorkbook(filein);
		HSSFSheet ws = wb.getSheetAt(0);
		
		int rows = ws.getLastRowNum();
		int columns = ws.getRow(1).getLastCellNum();
		excelData = new String[rows - 1][columns];
		for (int i = 1; i < rows; i++) {
			Row row = ws.getRow(i);
			for (int j = 0; j < columns; j++) {
				excelData[i - 1][j] = row.getCell(j).getStringCellValue();
			}
		}
	}
	else if(contentType.indexOf("vnd.openxmlformats-officedocument.spreadsheetml.sheet") > -1){
		XSSFWorkbook work = new XSSFWorkbook(new FileInputStream(file));
		XSSFSheet sheet = work.getSheetAt(0);
		
		int rows = sheet.getPhysicalNumberOfRows();
		int columns = sheet.getRow(0).getLastCellNum();
		excelData = new String[rows - 1][columns];
		for (int i = 1; i < rows; i++) {
			XSSFRow row = sheet.getRow(i);
			for (int j = 0; j < columns; j++) {
				if(row.getCell(j) != null){
					excelData[i - 1][j] = row.getCell(j) + "";
				}
			}
		}
	}
	else{
		file.delete(); 
		out.print("Excel파일이 아닙니다.");
		return;
	}
	
	if(excelData.length == 0){
		out.print("데이터가 존재하지 않습니다.");
		return;
	}
	
	
	String insert_result = "";
	
	String REGEX_IP = "^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))$";
	String REGEX_IPRANGE = "(^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))$)|(^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))\\/(2[0-5]{2}|1[0-9]{2}|[1-9][0-9]|[1-9])$)|(^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))~(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))$)";
	String REGEX_PORT = "^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,3})$";
	List<String> query_list = new LinkedList<String>();
	
	int index = 0;
	for(String[] row : excelData) {
		boolean null_check = false;
		/* null 값 확인 유효성 검사*/
		for(int i = 0; i < row.length; i++){
			
			if(row[i] == null || row[i].length() == 0){
				insert_result += (index + 2) + " 번째 줄 입력 실패 (Null 값이 존재함) <br/>";
				null_check = true;
				break;
			}
			else if(row[i].getBytes().length > 4000){
				insert_result += (index + 2) + " 번째 줄 입력 실패 (4000Byte 제한) <br/>";
				null_check = true;
				break;
			}
		}
		if(null_check){
			index++;
			continue;
		}
		
		if(!newsTable){
			if("ip".equals(category)){
				/* IP 정규식 검사 */
				if(row[0].matches(REGEX_IP) == false) {
					if(row[0].matches(REGEX_IPRANGE) == false) {
						insert_result += (index + 2) + " 번째 줄 입력 실패 (IP 형식 오류 : <b>" + row[0] + "</b>) <br/>";
						index++;
						continue;
					}
				}
				String[] country = CacheManager.getInstance().ip2Location(row[0]);
				query_list.add("insert into kc_blacklist (id, category, title, description, ext1, ext2, idate) values (seq_kc_blacklist.nextval,'" + category + "','" + row[0] + "','" + row[1] + "','" + row[2] + "','" + country[1] + "', sysdate)");
			}
			else{
				
				if("port".equals(category)){
					/* PORT 정규식 검사*/
					if(row[0].matches(REGEX_PORT) == false) {
						insert_result += (index + 2) + " 번째 줄 입력 실패 (PORT 형식 오류 : <b>" + row[0] + "</b>) <br/>";
						index++;
						continue;
					}
				}
				query_list.add("insert into kc_blacklist (id, category, title, description, ext1, idate) values (seq_kc_blacklist.nextval,'" + category + "','" + row[0] + "','" + row[1] + "', '" + row[2] + "', sysdate)");
			}
		}
		else{
			query_list.add("insert into kc_reportlist (id, category, title, url, idate) values (seq_kc_reportlist.nextval,'" + category + "','" + row[0] + "','" + row[1] + "', sysdate)");
		}
		index++;
	}
	String[] query = (String[]) query_list.toArray(new String[0]);
	
	
	Map<String, Object> result = new DBHandler().excuteBatch("kc", query);
	boolean flag = (Boolean)result.get("flag");
	List<String> fail_list = (List<String>)result.get("fail_list");
	for(String data : fail_list){
		insert_result += data;
	}
	insert_result = "<b>" + excelData.length + "건 중<font color='red'>" + (query.length - fail_list.size()) + "</font>건의 데이터가 입력되었습니다.</b><br><br>" + insert_result;
	logger.debug("[excelDataInsert] - " + category + "\t count : " + query.length);
	if(flag) {
		out.print(insert_result);
	}
	else {
		out.print(insert_result);
	}
	file.delete();

%>
package com.igloosec.kc.service;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import com.igloosec.kc.CommonUtil;
import com.igloosec.kc.LogManager;

/**
 * 단일 파일 업로드를 위한 Selvlet
 * @author JH
 *
 */
public class UploadServlet extends HttpServlet {
	Logger logger = LogManager.getInstance().getLogger("kc.log");
	private static final long serialVersionUID = 1L;
	
	public UploadServlet() {
		super();
	}


	/* (non-Javadoc)  단일 파일 업로드 servlet
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		File tmpDir = new File(System.getProperty("java.io.tmpdir"));
		if(!tmpDir.exists()){
			tmpDir.mkdir();  
		}
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(1 * 1024 * 1024); // 1 MB
		factory.setRepository(tmpDir);
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setSizeMax(5 * 1024 * 1024);
		String service = "";
		String method = "";
		String param = "";
		String fileName = "";
		String contentType = "";
		JSONObject result = null;
		try {
			
			List<?> items = upload.parseRequest(request);
			Iterator<?> itr = items.iterator();
			while (itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				if (item.isFormField()) {
					if("service".equals(item.getFieldName())){
						service = CommonUtil.reqFilter(item.getString());
					}
					else if("method".equals(item.getFieldName())){
						method = CommonUtil.reqFilter(item.getString());
					}
					else if("param".equals(item.getFieldName())){
						param = CommonUtil.reqFilter(item.getString());
					}
				} else {
					String separator = System.getProperty("file.separator");
					fileName = item.getName();
					if(fileName.lastIndexOf(separator) > -1){
						fileName = fileName.substring(fileName.lastIndexOf(separator) + 1, fileName.length());
					}
					item.write(new File(tmpDir, fileName));
					contentType = item.getContentType();
				}
			}
		} catch(SizeLimitExceededException e){
			if(result == null) {
				result = new JSONObject();
			}
			result.put("result", "fail");
			result.put("message", "serviceTitle#용량제한(5Mb).");
			logger.warn(e.getMessage());
			
		} catch (FileUploadException e) {
			logger.error(e.getMessage());
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		Map<String, String> req = parseParam(param);
		req.put("fileName", fileName);
		req.put("contentType", contentType);
		
		try {
			Class<?> clazz = Class.forName("com.igloosec.kc." + service);
			Object obj = clazz.newInstance();
			Method m = clazz.getMethod(method, Map.class);
			result = (JSONObject) m.invoke(obj, req);
			
		} catch (ClassNotFoundException e) {
			logger.error(e.getMessage());
		} catch (InstantiationException e) {
			logger.error(e.getMessage());
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (SecurityException e) {
			logger.error(e.getMessage());
		} catch (NoSuchMethodException e) {
			logger.error(e.getMessage());
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			StackTraceElement[] array = e.getCause().getStackTrace();
			for(StackTraceElement element : array){
				if(element.getClassName().contains("com.igloosec")){
					logger.error(element.toString() + " : " + e.getCause());
				}	
			}
		}
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.println(result);
		out.flush();
		out.close();
	
	}
	
	public Map<String, String> parseParam(String param) {
		Map<String, String> map = new HashMap<String, String>();
		if(param.length() == 0) {
			return map;
		}
		
		String[] params = param.split("&");
		for(String ss : params) {
			String[] s = ss.split("=");
			if(s.length == 2) {
				map.put(s[0], s[1]);
			}
			else if(s.length == 1) {
				map.put(s[0], "");
			}
		}
		
		return map;
	}
}

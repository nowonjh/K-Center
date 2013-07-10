package com.igloosec.kc;


import java.io.File;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.parser.PdfTextExtractor;



public class PDFExport {
	final String REGEX_IP2 = "(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))";
	final String REGEX_IP = ".*(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])).*";
	final String REGEX_URL = ".*(http(s)?:\\/\\/)?\\w.+(-|_)?(\\.\\w+(-|_)?)+.*";
	final String REGEX_URL2 = "(http(s)?:\\/\\/)?\\w.+(-|_)?(\\.\\w+(-|_)?)+";
	
	public JSONObject test(Map<String, String> req) throws IOException{
		Logger logger = LogManager.getInstance().getLogger("kc.log");
		String contentType = req.get("contentType");
		String fileName = req.get("fileName");
		JSONObject result = new JSONObject();
		
		if("".equals(fileName)){
			result.put("fail", "파일을 선택해주세요.");
			return result;
		}
		else if(contentType.indexOf("application/pdf") > -1){
			
		}
		else{
			result.put("fail", "PDF 파일이 아닙니다.");
			return result;
		}
		
		File tmpDir = new File(System.getProperty("java.io.tmpdir"));
		File pdffile = new File(tmpDir + "/" + fileName);
		PdfReader reader = new PdfReader(tmpDir + "/" + fileName);
		int pages = reader.getNumberOfPages();

		List<Map<String, String>> ip_list = new LinkedList<Map<String,String>>();
		List<Map<String, String>> url_list = new LinkedList<Map<String,String>>();
		List<String> exception_list = new LinkedList<String>();
		int index = 0;
		for(int i = 1;i <= pages; i++){
			String[] line = PdfTextExtractor.getTextFromPage(reader, i).split("\n");
			if(line[2].replaceAll(" ", "").indexOf("유해IP/도메인차단권고") > -1){
				for(String str : line){
					if(str.matches("^([1-9]{1}|[1-9][0-9]{1,})\\s{1,}.*\\s([A-Z]{2}|-)\\s{1,}.*")){
						String[] col = str.split("\\s{1,}");
						try{
							if(col.length != 4){
								col = new String[4];
								String[] col1 = str.split("\\s([A-Z]{2}|-)\\s");
								col[0] = col1[0].replaceAll("\\s.*", "").trim();
								col[1] = col1[0].replaceAll("^([1-9]{1}|[1-9][0-9]{1,})\\s", "").trim();
								col[3] = col1[1].trim();
								
								Pattern pattern = Pattern.compile("\\s([A-Z]{2}|-)\\s");
								Matcher match_regxp = pattern.matcher(str);
								while(match_regxp.find()) {
									col[2] =  match_regxp.group().replaceAll("\\s", "");
									break;
								}
							}
							String country_code = col[2];
							String category = getCategory(col[3]);
							String[] title = new String[2];

							title = getHost(col[1].trim());
							
							/*유해 IP 필터링 */
							if(title[0] != null){
								if(title[1] != null){
									Map<String, String> rowMap = new LinkedHashMap<String, String>();
									rowMap.put("num", col[0]);
									rowMap.put("title", title[0]);
									rowMap.put("content", getIPContent(title, country_code, category));
									rowMap.put("category", category);
									ip_list.add(rowMap);
								}
								else {
									Map<String, String> rowMap = new LinkedHashMap<String, String>();
									rowMap.put("num", col[0]);
									rowMap.put("title", title[0]);
									rowMap.put("content", getIPContent(title, country_code, category));
									rowMap.put("category", category);
									ip_list.add(rowMap);
								}
							}
							/*유해 URL 필터링 */
							if(title[1] != null){
								if(title[0] != null){
									Map<String, String> rowMap = new LinkedHashMap<String, String>();
									rowMap.put("num", col[0]);
									rowMap.put("title", title[1]);
									rowMap.put("content", getURLContent(title, country_code, category));
									rowMap.put("category", category);
									url_list.add(rowMap);
								}
								else {
									Map<String, String> rowMap = new LinkedHashMap<String, String>();
									rowMap.put("num", col[0]);
									rowMap.put("title", title[1]);
									rowMap.put("content", getURLContent(title, country_code, category));
									rowMap.put("category", category);
									url_list.add(rowMap);
								}							
							}
							index++;
						} catch (Exception e){
							exception_list.add(col[0]);
							logger.warn(e.getMessage());
							index++;
						}
						
					}
				}
			}
		}
		result.put("url_list", url_list);
		result.put("ip_list", ip_list);
		result.put("exception_list", exception_list);
		Map<String, Integer> metadata = new LinkedHashMap<String, Integer>();
		
		metadata.put("tot_cnt", index);
		metadata.put("ip_cnt", url_list.size());
		metadata.put("url_cnt", ip_list.size());
		
		result.put("metadata", metadata);
		reader.close();
		if(pdffile.exists()){
			pdffile.delete();
		}
		return result;
	}
	
	private String getURLContent(String[] title, String country_code, String category) {
		String head = "";
		String country = "";
		String cate = "";
		if(title[0] == null){
			head = "";
		}
		else {
			head = "ip : " + title[0];
		}
		country = "-".equals(country_code) ? "" : "국가 : " + country_code;
		cate = title[2] == null ? category : category + " : " + title[2];
		return head + ("".equals(head) ? "" : " / ") + country + ("".equals(country) ? "" : " / ") + cate;
	}
	
	private String getIPContent(String[] title, String country_code, String category) {
		String head = "";
		String country = "";
		String cate = "";
		if(title[1] == null){
			head = "";
		}
		else {
			head = "url : " + title[1];
		}
		country = "-".equals(country_code) ? "" : "국가 : " + country_code;
		cate = title[2] == null ? category : category + " : " + title[2];
		return head + ("".equals(head) ? "" : " / ") + country + ("".equals(country) ? "" : " / ") + cate;
	}
	

	private String getCategory(String string) {
		if("악성코드".equals(string)){
			string = "악성코드 유포지";
		}
		else if("피싱사이트".equals(string)){
			string = "피싱 사이트";
		}
		return string;
	}

	public String[] getHost(String column){
		String[] title = new String[3];
		if(column.indexOf("/") > -1){
			title[0] = column.split("/")[0].trim();
			title[2] = column.split("/")[1].trim(); 
		}
		else {
			title[0] = column;
		}
		String tmp_host = title[0];
		Pattern pattern = Pattern.compile(REGEX_IP2);
		Matcher match_regxp = pattern.matcher(title[0]);
		while(match_regxp.find()) {
			title[0] = match_regxp.group().replaceAll("\\s", "");
			break;
		}
		if(match_regxp.find(0) == false){
			title[0] = null;
		}
		tmp_host = tmp_host.replaceAll(REGEX_IP2, "");
		pattern = Pattern.compile(REGEX_URL2);
		match_regxp = pattern.matcher(tmp_host);
		
		while(match_regxp.find()) {
			title[1] = match_regxp.group().replaceAll("\\s", "");
			break;
		}
		return title;
	}
	
}

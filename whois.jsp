<%@page import="java.io.IOException"%>
<%@page import="com.igloosec.kc.LogManager"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.net.SocketTimeoutException"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.Socket"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Logger logger = LogManager.getInstance().getLogger("kc.log");

	String ip = request.getParameter("ip");
	int port = 43;
	StringBuffer data = null;
	String host = "whois.arin.net";
	String history = "";
	
	while(true){
		history += "[Querying " + host + "]\n";
		Socket socket = null;
		BufferedReader br = null;
		BufferedWriter bw = null;
		String ref = null; 
		data = new StringBuffer();
		String regExp = "(rwhois|whois|www|cgi|pknic|saudinic)[.][a-zA-Z0-9-.]{1,50}:[0-9]{1,5}|(rwhois|whois|www|cgi|pknic|saudinic)[.][a-zA-Z0-9-.]{1,50}";
		String[] url = {"rwhois", "whois", "cgi", "pknic", "saudinic"};
	
		try {		
			socket = new Socket(host, port);
			br = new BufferedReader(new InputStreamReader(socket.getInputStream(), "UTF-8"));
			bw = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
			bw.write(ip + "\n");
			bw.flush();
			String line = "";
			while((line = br.readLine()) != null) {
				data.append(line).append("\n");
				if(line.startsWith("ReferralServer")) {
					Matcher m = Pattern.compile(regExp).matcher(line.substring(line.indexOf(":") + 1).trim());
					while(m.find()){
						ref = m.group();
					}
					break;
				}
				else if(line.startsWith("remarks") && line.indexOf("jp") < 1 ) {
					for(String arr : url){
						if(line.indexOf(arr + ".") > -1){
							Matcher m = Pattern.compile(regExp).matcher(line.substring(line.indexOf(arr+".")).trim());
							while(m.find()){
								ref = m.group();
							}
							break;
						}
					}
				}
			}
		} catch (SocketTimeoutException e) {
			data.append("Unable to connect to remote host");
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		} finally {
			try {
				if(bw != null)
					bw.close();
				if(br != null)
					br.close();
				if(socket != null)
					socket.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
		if(ref != null){
			String[] redirect = ref.split(":");
			if(redirect.length > 1){
				port = Integer.parseInt(redirect[1]);
			}
			host = redirect[0];
			history += "[Redirected to " + host + "]\n";
		}
		else{
			break;
		}
	}
	logger.debug("[" + request.getRemoteHost() + "] whois?ip=" + ip);
	history += "[" + host + "]\n\n";
	data.insert(0, history);
	out.print(data);
%>
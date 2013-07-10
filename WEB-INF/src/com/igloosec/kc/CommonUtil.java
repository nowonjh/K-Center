package com.igloosec.kc;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.NumberFormat;
import java.util.UUID;

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

public class CommonUtil {
	
	public static String reqFilter(String str) {
		str = ascToUtf(str);
		
		str = str.replaceAll("'", "''");
		//str = str.replaceAll("--", "");

        return str;
    }
	
	public static String nvl(String source, String defaultValue) {
        if (source == null)
            return defaultValue;
		return source;
    }
    
    public static String changeToSHA512(String passwd) {
    	if(passwd == null)
    		return "";
    	
        byte[] arrDigest = null;
        
        try {
        	MessageDigest md = MessageDigest.getInstance("SHA-512");
        	md.update(passwd.getBytes());
            arrDigest = md.digest();
        } catch (NoSuchAlgorithmException e) {
            arrDigest = "".getBytes();
        }
                
        return Base64.encode(arrDigest);
    }
	
	public static String subString(String str, int len) {
        int strLength = str.length();

        if (strLength <= len)
            return str;
		return str.substring(0, len) + "...";
    }

    public static String subStringSpan(String str, int len) {
        String returnStr = "";
        char[] c = str.toCharArray();
        int tot = 0;
        for (int i = 0; i < c.length; i++) {
            if (c[i] < 256) {
                tot++;
            } else {
                tot += 2;
            }
        }

        if (tot <= len)
            returnStr = str;
        else {
            int n = 0;
            int _len = len;
            for (int i = 0; i < c.length; i++) {
                if (c[i] < 256) {
                    n++;
                } else {
                    n += 2;
                    _len--;
                }

                if (n >= len)
                    break;
            }

            returnStr = "<span title=\"" + htmlFilter(str) + "\">" + htmlFilter(str.substring(0, _len)) + "...</span>";
        }

        return returnStr;
    }
    
    public static String htmlFilter(String str) {
    	if (str == null)
            return "";
    	
		str = str.replaceAll("&", "&amp;");
		str = str.replaceAll("<", "&lt;");
		str = str.replaceAll(">", "&gt;");
		str = str.replaceAll("/", "&#47;");
		str = str.replaceAll("%", "&#37;");
		str = str.replaceAll("\'", "&#39;");
		str = str.replaceAll("\"", "&quot;");
		str = str.replaceAll("\n", "<br/>");

		return str ;
	}
    
    public static String commandFilter(String str) {
		if(str == null)
			return "";
		
		str = str.replaceAll("&", "");
		str = str.replaceAll("|", "");
		str = str.replaceAll("\\.\\.", "");  // ..을 사용하면 문자열이 없어짐 (.. 대신 \.\. 사용)
		
		return str;
	}
	
	public static String headerFilter(String str) {
		if(str == null)
			return "";
		
		str = str.replaceAll("\n", "");
		str = str.replaceAll("\r", "");
		
		return str;
	}
	
	public static String replace(String source, String oldStr, String newStr) {
        if (source.indexOf(oldStr) == -1) {
            return source;
        }

        int i = 0;
        StringBuffer sb = new StringBuffer("");
        int jump = oldStr.length();
        int j = 0;
        while ((j = source.indexOf(oldStr, i)) != -1) {
            String pre = source.substring(i, j);
            sb.append(pre);
            sb.append(newStr);
            i = j + jump;
        }
        return sb.toString() + source.substring(i);
    }
	
	public static String createUUID() {
		String uuid = UUID.randomUUID().toString();
		
		return uuid;
	}
	
	public static String ascToUtf(String str) {
        String returnStr = "";
        if(str == null)
            return returnStr;
        
        try {
            returnStr = new String(str.getBytes("8859_1"), "UTF-8");
        } catch (UnsupportedEncodingException ue) { ; }

        return returnStr;
    }
	
	public static boolean checkPassword(String id, String pw) {
    	boolean flag = true;
    	
    	if(pw.length() == 0) {
    		flag = false;
    	}
    	if(id.equals(pw)) { // 아이디와 동일
    		flag = false;
    	}
    	if(!pw.matches("^\\S{9,16}")) { // 자리수
    		flag = false;
    	}
    	if(pw.matches("^[0-9]+$")) { // 숫자로만 구성
    		flag = false;
    	}
    	if(pw.matches("^[a-zA-Z]+$")) { // 문자로만 구성
    		flag = false;
    	}
    	if(pw.matches("^[\\W]+$")) { // 특수문자로만 구성
    		flag = false;
    	}
    	if(pw.matches("^[a-zA-Z_0-9]+$")) { // 숫자와 문자로만 구성 (특수문자 사용 안함)
    		flag = false;
    	}
    	if(pw.matches("^[a-zA-Z_\\W]+$")) { // 문자와 특수문자로만 구성 (숫자 사용안함)
    		flag = false;
    	}
    	if(pw.matches("^[0-9_\\W]+$")) { // 숫자와 특수문자로만 구성 (문자 사용 안함)
    		flag = false;
    	}
    	
    	char[] c = pw.toCharArray();
    	int m = 2;
    	int n = 0;
    	int nn = 0;
    	int nnn = 0;
    	for(int i = 1; i < c.length; i++) {
    		if(((char)(c[i - 1] + 1)) == c[i]) // 오름차순 숫자, 문자
    			n++;
    		else
    			if(n < m) n = 0;
    		
    		if(((char)(c[i - 1] - 1)) == c[i]) // 내림차순 숫자, 문자
    			nn++;
    		else
    			if(nn < m) nn = 0;
    		
    		if(c[i - 1] == c[i])  // 동일한 숫자, 문자
    			nnn++;
    		else
    			if(nnn < m) nnn = 0;
    	}
    	
    	if(n >= m || nn >= m || nnn >= m) {
    		flag = false;
    	}   	
    	
    	return flag;
    }

	public static String numberFormat(String str) {
		long num = 0L;
		String result = "";
		try{
			num = Long.parseLong(str);
			NumberFormat number = NumberFormat.getNumberInstance(); 
			result = number.format(num);
		} catch(NumberFormatException e){
			return "-";
		}
		return result;
	}

}

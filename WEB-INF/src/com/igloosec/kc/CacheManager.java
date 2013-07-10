package com.igloosec.kc;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * 유해IP, 취약포트 등의 정보에 대해 빠른 비교 검색을 위해 해당 정보를 DB에서 쿼리하여 메모리에 보관한다.
 * 
 * @author wizver
 *
 */
public class CacheManager {
	static Logger logger = LogManager.getInstance().getLogger("kc.log");
	
	private static CacheManager instance;
	private List<String[][]> ip2Location;
	static {
		if(instance == null)
			instance = new CacheManager();
	}
	
	/**
	 * 기본 생성자
	 */
	private CacheManager() {
		
		ip2Location = null;
		
		initCache();
	}
	
	/**
	 * DB 데이터를 쿼리하여 메모리에 보관한다.
	 */
    @SuppressWarnings("null")
    private void initCache() {
		DBHandler db = new DBHandler();
		
		String sql = "select ip_from, ip_to, country_code, country_name from ip2location order by ip_from";
		String data[][] = null;
		try {
			data = db.getNColumnData("kc", sql);
		} catch (SQLException e) {
			logger.error(e.getMessage());
		}
		String[][] row = null;
		int index = 0;
		int listsize = 0;
		String tmpRowNum = "";
		ip2Location = new ArrayList<String[][]>();
		
		for(String rows[] : data){
			if(index % 1000 == 0){
				
				if(( data.length - ( listsize * 1000 )) / 1000 < 1 ){
					row = new String[data.length - ( listsize * 1000 )][5];
				}
				else{
					row = new String[1000][5];
				}
				ip2Location.add(row);
				index = 0;
				listsize++;
			}
			if(index == 0){
				tmpRowNum = rows[0];
			}
			row[index][0] = tmpRowNum;
			row[index][1] = rows[0];
			row[index][2] = rows[1];
			row[index][3] = rows[2];
			row[index][4] = rows[3];
			index++;
		}
	}
	
	/**
	 * CacheManager 객체를 구한다.
	 * @return CacheManager 객체
	 */
	public static CacheManager getInstance() {
		return instance;
	}
	
	
	
	/**
	 * IP 를 입력받아 해당IP의 국가정보와 국기img 파일명을 구한다
	 * @param ip 국가정보를 얻을 ip주소
	 * @return  String 배열 0번째는 국가명의 약자, 1번째는 국가명   
	 */
	public String[] ip2Location(String ip) {
		String[] result = {"-", "-"};
		String regExp_ip = "^(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))$";
		if(!ip.matches(regExp_ip)){
			return result;
		}
		try {
			long realIP = getRealIP(ip);
			int index = 0;	
			for(int i = 1; i < ip2Location.size(); i++){
				long num1 = Long.parseLong(ip2Location.get(i - 1)[0][0]);
				long num2 = Long.parseLong(ip2Location.get(i)[0][0]);
				if(realIP >= num1  && realIP < num2){
					index = i - 1;
					break;
				}
				index = ip2Location.size() - 1;
			}
			for(String[] data : ip2Location.get(index)){
				if(realIP >= Long.parseLong(data[1]) && realIP <= Long.parseLong(data[2])) {
					result[0] = data[3];
					result[1] = data[4];
					break;
				}
			}
		}catch(NumberFormatException e){
			logger.error(e.getMessage());
			return result;
		}  
		catch(UnknownHostException e) {
			logger.error(e.getMessage());
			return result;
		} 
		return result;
	}
	public long getRealIP(String ip)throws UnknownHostException {
        
		long realIP = InetAddress.getByName(ip.trim()).hashCode();
        
		if (realIP < 0) {
            return realIP ^ 0xFFFFFFFF00000000L;
        }
		return realIP;
    }
	
}

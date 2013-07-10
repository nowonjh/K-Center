/**
 * IGLOO Security Inc.
 * Created on 2006. 10. 10
 * by wizver 
 */
package com.igloosec.kc;

import java.sql.*;
import java.util.*;

import org.apache.log4j.Logger;


/**
 * @author wizver
 */
public class DBHandler {
	
	Logger logger = LogManager.getInstance().getLogger("kc.db");        
    
    public String[][] getNColumnData(String name, String query) throws SQLException{
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
		Vector<Vector<String>> rowSet = new Vector<Vector<String>>();
		Vector<String> row = null;
		int colCnt = 0;
        try {
            con = DBConnectionManager.getInstance().getConnection(name);
            stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			colCnt = rs.getMetaData().getColumnCount();

			while (rs.next()) {
			    row = null;
				row = new Vector<String>();
				for (int i = 0; i < colCnt; i++) {
					row.addElement(rs.getString(i + 1));
				}
				rowSet.addElement(row);
			}
			
            close(con, stmt, rs);
            
            logger.debug(query);
        } catch(SQLException e) {
            close(con, stmt, rs);
            logger.error(e.getMessage() + " : error query => " + query); 
            throw new SQLException();
        }
        
        String[][] data = new String[rowSet.size()][colCnt];
        for(int i = 0; i < data.length; i++) {
            row = null;
            row = rowSet.elementAt(i);
            for(int j = 0; j < colCnt; j++) {
                if((row.elementAt(j)) == null) {
                    data[i][j] = "-";
                }
                else {
                    data[i][j] = row.elementAt(j).trim();
                }
            }
        }
        
        return data;
    }    
    
    public String[] getOneColumnData(String name, String query) { 
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
		Vector<String> row = new Vector<String>();
        try {
            con = DBConnectionManager.getInstance().getConnection(name);
            stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				row.addElement(rs.getString(1));
			}
			
            close(con, stmt, rs);
            
            logger.debug(query);
        } catch(SQLException e) {
            close(con, stmt, rs);
            logger.error(e.getMessage() + " : error query => " + query);
        }
        
        String[] data = new String[row.size()];
        for(int i = 0; i < data.length; i++) {
            if(row.elementAt(i) == null) {
                data[i] = "-";
            }
            else {
                data[i] = row.elementAt(i).trim();
            }
        }
        
        return data;
    }    
   
    public int excuteUpdate(String name, String query) {
        int flag = 0;
        Connection con = null;
        Statement stmt = null;
        try {
            con = DBConnectionManager.getInstance().getConnection(name);
            stmt = con.createStatement();
			stmt.executeUpdate(query);
            close(con, stmt, null);
            flag = 1;
            logger.debug(query);
        } catch(SQLException e) {
            close(con, stmt, null);
            if(e.getMessage().indexOf("unique") > -1){
            	flag = 2;
            }
            else{
            	 flag = 3;
            }
            logger.error(e.getMessage() + " : query is " + query);
        }
        
        return flag;
    }
    
    public Map<String, Object> excuteBatch(String name, String[] query) {
    	
    	Map<String, Object> result = new LinkedHashMap<String, Object>();
    	List<String> fail_list = new LinkedList<String>();
        
        boolean flag = false;
        Connection con = null;
        Statement stmt = null;
        try {
            con = DBConnectionManager.getInstance().getConnection(name);
            stmt = con.createStatement();
            for(int i = 0; i < query.length; i++) {
            	
            	try{
            		 stmt.executeUpdate(query[i]);
            	}
            	catch(SQLException e){
            		if(e.getMessage().indexOf("unique") > -1){
            			fail_list.add((i + 2) + " 번째 줄 입력 실패 (중복값 존재) <br/>");
            			logger.warn(e.getMessage());
            			continue;
            		}
					fail_list.add((i + 2) + " 번째 줄 입력 실패 (DB 접근 실패) <br/>");
					logger.warn(e.getMessage());
					continue;
            	}
            }
           
            close(con, stmt, null);
            flag = true;
        } catch(SQLException e) {
            close(con, stmt, null);
            logger.error(e.getMessage());
            
        }
        result.put("flag", flag);
        result.put("fail_list", fail_list);
        
        return result;
    }
    
    
    private void close(Connection con, Statement stmt, ResultSet rs) {        
        try {
            if(rs != null) {
                rs.close();
                rs = null;
            }
            if(stmt != null) {
                stmt.close();
                stmt = null;
            }
        } catch (Exception e) {
			logger.error(e.getMessage());
        }
        
        DBConnectionManager.getInstance().freeConnection(con);
    }

}
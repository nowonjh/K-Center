/**
 * IGLOO Security Inc.
 * Created on 2006. 10. 10
 * by wizver 
 */
package com.igloosec.kc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.ibatis.datasource.pooled.PooledDataSource;
import org.apache.log4j.Logger;

/**
 * @author wizver
 */
public class DBConnectionManager {
	
	Logger logger = LogManager.getInstance().getLogger("kc.db");
    
	private static DBConnectionManager instance;
	
    public static final String DB_1 = "kc"; 
     
    private Properties db1Props;
    private PooledDataSource db1DataSource;    
    
    static {
        if (instance == null)
            instance = new DBConnectionManager();
    }
    
    
    @SuppressWarnings("resource")
    private DBConnectionManager() {
        try {
        	java.io.File home = new java.io.File(System.getProperty("catalina.home"), "conf/kc");
        	db1Props = new Properties(); 
            db1Props.load(new java.io.FileInputStream(new java.io.File(home, "db_kc.properties")));
            
            String driverName = db1Props.getProperty("JDBC.Driver");
     	   	String dbURL = db1Props.getProperty("JDBC.ConnectionURL");
     	   	String userid = db1Props.getProperty("JDBC.Username");
     	   	String passwd = db1Props.getProperty("JDBC.Password");
     	   	int maxActive = Integer.parseInt(db1Props.getProperty("Pool.MaximumActiveConnections", "10"));
     	   	int maxIdle = Integer.parseInt(db1Props.getProperty("Pool.MaximumIdleConnections", "5"));
            
            db1DataSource = new PooledDataSource(driverName, dbURL, userid, passwd);
            db1DataSource.setPoolMaximumActiveConnections(maxActive);
            db1DataSource.setPoolMaximumIdleConnections(maxIdle);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }
    
    
    public static DBConnectionManager getInstance() {		
        return instance;
    }
    
    
    public void freeConnection(Connection con) {
        try {
            if(con != null) {
                con.commit();
                con.close();
            }
        } catch (Exception e) {
            if(con != null) {
                try { con.commit(); con.close(); } catch (SQLException e1) { ; }
            }  
            logger.error(e.getMessage());
        }
    }
     
    
    public Connection getConnection() {
        return getConnection(DB_1);
    } 
    
    
    public Connection getConnection(String name) {
        Connection con = null;

        try {
            if(DB_1.equals(name))
                con = db1DataSource.getConnection();
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

        return con;
    }   
    
   
    public Connection getNormalConnection(String name) {
        Connection con = null;

       if(DB_1.equals(name)) {
    	   String driverName = db1Props.getProperty("JDBC.Driver");
    	   String dbURL = db1Props.getProperty("JDBC.ConnectionURL");
    	   String userid = db1Props.getProperty("JDBC.Username");
    	   String passwd = db1Props.getProperty("JDBC.Password");
    	   try {
    		   Class.forName(driverName);
    		   con = DriverManager.getConnection(dbURL, userid, passwd);
    	   } catch (Exception e) {
               logger.error(e.getMessage());
           }
       }

        return con;
    }  
}
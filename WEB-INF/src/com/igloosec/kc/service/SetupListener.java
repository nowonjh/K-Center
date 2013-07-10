package com.igloosec.kc.service;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.apache.log4j.Logger;
import com.igloosec.kc.CacheManager;
import com.igloosec.kc.LogManager;


/**
 * Application Lifecycle Listener implementation class TestListener
 *
 */
@WebListener
public class SetupListener implements ServletContextListener {
	
	Logger logger = LogManager.getInstance().getLogger("kc.log");

    /**
     * Default constructor. 
     */
    public SetupListener() {
        
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    @Override
	public void contextInitialized(ServletContextEvent arg0) {
    	logger.info("Knowledge-Center Start!");
        
    	// 유해IP, 취약포트 caching
    	CacheManager.getInstance();
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    @Override
	public void contextDestroyed(ServletContextEvent arg0) {
    	Enumeration<Driver> drivers = DriverManager.getDrivers(); 
        while (drivers.hasMoreElements()) { 
            Driver driver = drivers.nextElement(); 
            try { 
                DriverManager.deregisterDriver(driver); 
                logger.info(String.format("[ContextDestroyed] deregistering jdbc driver: %s", driver)); 
            } catch (SQLException e) { 
                logger.error(String.format("[ContextDestroyed] Error deregistering driver %s", driver), e); 
            }
        }
        
        logger.info("Knowledge-Center Stop!");
    }
	
}

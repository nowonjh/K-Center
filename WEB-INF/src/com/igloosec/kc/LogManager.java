/**
 * IGLOO Security Inc.
 * Created on 2006. 10. 10
 * by wizver 
 */
package com.igloosec.kc;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 *
 * @author wizver
 */
public class LogManager{

    private static LogManager mgr;

    static{
        if(mgr == null)
            mgr = new LogManager();
    }

    private LogManager() {
        String catalinaHome = System.getProperty("catalina.home");
        PropertyConfigurator.configure(catalinaHome + "/conf/kc/log4j.properties");
    }

    public static LogManager getInstance() {
        return mgr;
    }

    public Logger getLogger(String name) {
        return Logger.getLogger(name);
    }
}

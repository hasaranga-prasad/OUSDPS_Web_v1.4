/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.PropertyResourceBundle;
//import org.apache.commons.pool.ObjectPool;
//import org.apache.commons.pool.impl.GenericObjectPool;
//import org.apache.commons.dbcp.ConnectionFactory;
//import org.apache.commons.dbcp.PoolableConnectionFactory;
//import org.apache.commons.dbcp.DriverManagerConnectionFactory;
//import org.apache.commons.dbcp.PoolingDriver;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class DBUtil
{

    private static DBUtil util;
    private static String strDBURL;
    private static String strUser;
    private static String strPassword;
//    private static ObjectPool connectionPool;

    private static String strDBURL_Archival;
    private static String strUserArchival;
    private static String strPasswordArchival;
//    private static ObjectPool connectionPoolArchival;

    private DBUtil()
    {
    }

    public static DBUtil getInstance()
    {
        if (util == null)
        {
            util = new DBUtil();
        }
        return util;
    }

//    public Connection getConnection() throws SQLException,
//            ClassNotFoundException
//    {
//
//        Connection con = null;
//
//        if (strDBURL == null || strUser == null || strPassword == null)
//        {
//            FileInputStream fis = null;
//
//            try
//            {
//                //System.out.println(LCPL_Constants.path_dbProperty);
//                fis = new FileInputStream(new File(LCPL_Constants.path_dbProperty));
//
//                PropertyResourceBundle bundle = new PropertyResourceBundle(fis);
//                //ResourceBundle bundle = ResourceBundle.getBundle("db_properties");
//                strDBURL = bundle.getString("DB_URL");
//                strUser = bundle.getString("USER");
//                strPassword = bundle.getString("PWD");
//            }
//            catch (Exception e)
//            {
//                System.out.println("Error loading MYsql Connection - " + e.getMessage());
//            }
//            finally
//            {
//                try
//                {
//                    fis.close();
//                }
//                catch (IOException e)
//                {
//                    System.out.println(e.getMessage());
//                }
//            }
//        }
//
//        try
//        {
//            Class.forName("com.mysql.jdbc.Driver");
//        }
//        catch (ClassNotFoundException e)
//        {
//            System.out.println(e.getMessage());
//        }
//
//        if (connectionPool == null)
//        {
//            connectionPool = new GenericObjectPool(null, 50, GenericObjectPool.WHEN_EXHAUSTED_GROW, 1000, 10, false, false, 30000, 5, 10000, false);
//            ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(strDBURL, strUser, strPassword);
//
//            PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(connectionFactory, connectionPool, null, null, false, true);
//
//            Class.forName("org.apache.commons.dbcp.PoolingDriver");
//        }
//
//        PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
//
//        driver.registerPool("slips_bcm_db_con", connectionPool);
//
//        con = DriverManager.getConnection("jdbc:apache:commons:dbcp:slips_bcm_db_con");
//
//        return con;
//
//    }
    public Connection getConnection() throws SQLException, ClassNotFoundException
    {
        Connection con = null;

        if (strDBURL == null || strUser == null || strPassword == null)
        {
            FileInputStream fis = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_dbProperty));

                PropertyResourceBundle bundle = new PropertyResourceBundle(fis);
                strDBURL = bundle.getString("DB_URL");
                strUser = bundle.getString("USER");
                strPassword = bundle.getString("PWD");
            }
            catch (IOException e)
            {
                System.out.println("GetConnection() : Error loading MySql Connection properties ===> " + e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        try
        {         
            System.out.println("strDBURL --->" + strDBURL);
            System.out.println("strUser --->" + strUser);
            System.out.println("strPassword --->" + strPassword);
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            con = DriverManager.getConnection(strDBURL, strUser, strPassword);
        }
        catch (ClassNotFoundException | IllegalAccessException | InstantiationException | SQLException e)
        {
            System.out.println("GetConnection() : Error while Obtain Connection  =====> " + e.getMessage());
            e.printStackTrace();
        }

        return con;
    }

//    public Connection getConnection_Archival() throws SQLException,
//            ClassNotFoundException
//    {
//
//        Connection con = null;
//
//        if (strDBURL_Archival == null || strUserArchival == null || strPasswordArchival == null)
//        {
//            FileInputStream fis = null;
//
//            try
//            {
//                //System.out.println(LCPL_Constants.path_dbProperty);
//                fis = new FileInputStream(new File(LCPL_Constants.path_dbProperty));
//
//                PropertyResourceBundle bundle = new PropertyResourceBundle(fis);
//                //ResourceBundle bundle = ResourceBundle.getBundle("db_properties");
//                strDBURL_Archival = bundle.getString("DB_URL_ARCHIVAL");
//                strUserArchival = bundle.getString("USER_ARCHIVAL");
//                strPasswordArchival = bundle.getString("PWD_ARCHIVAL");
//
//                System.out.println("strDBURL_Archival ---> " + strDBURL_Archival);
//                System.out.println("strUserArchival ---> " + strUserArchival);
//                System.out.println("strPasswordArchival ---> " + strPasswordArchival);
//            }
//            catch (Exception e)
//            {
//                System.out.println("Error loading MYsql Connection - " + e.getMessage());
//            }
//            finally
//            {
//                try
//                {
//                    fis.close();
//                }
//                catch (IOException e)
//                {
//                    System.out.println(e.getMessage());
//                }
//            }
//        }
//
//        try
//        {
//            Class.forName("com.mysql.jdbc.Driver");
//        }
//        catch (ClassNotFoundException e)
//        {
//            System.out.println(e.getMessage());
//        }
//
//        if (connectionPoolArchival == null)
//        {
//            connectionPoolArchival = new GenericObjectPool(null, 30, GenericObjectPool.WHEN_EXHAUSTED_GROW, 1000, 10, false, false, 30000, 5, 10000, false);
//            ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(strDBURL_Archival, strUserArchival, strPasswordArchival);
//
//            PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(connectionFactory, connectionPoolArchival, null, null, false, true);
//
//            Class.forName("org.apache.commons.dbcp.PoolingDriver");
//        }
//
//        PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
//
//        driver.registerPool("slips_bcm_db_con_archival", connectionPoolArchival);
//
//        con = DriverManager.getConnection("jdbc:apache:commons:dbcp:slips_bcm_db_con_archival");
//
//        return con;
//    }
    public Connection getConnection_Archival() throws SQLException, ClassNotFoundException
    {
        Connection con = null;

        if (strDBURL_Archival == null || strUserArchival == null || strPasswordArchival == null)
        {
            FileInputStream fis = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_dbProperty));

                PropertyResourceBundle bundle = new PropertyResourceBundle(fis);
                strDBURL_Archival = bundle.getString("DB_URL_ARCHIVAL");
                strUserArchival = bundle.getString("USER_ARCHIVAL");
                strPasswordArchival = bundle.getString("PWD_ARCHIVAL");

                System.out.println("strDBURL_Archival ---> " + strDBURL_Archival);
                System.out.println("strUserArchival ---> " + strUserArchival);
                System.out.println("strPasswordArchival ---> " + strPasswordArchival);
            }
            catch (IOException e)
            {
                System.out.println("GetConnection_Archival: Error loading MySql Connection properties ===> " + e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        try
        {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            con = DriverManager.getConnection(strDBURL_Archival, strUserArchival, strPasswordArchival);
        }
        catch (ClassNotFoundException | IllegalAccessException | InstantiationException | SQLException e)
        {
            System.out.println("GetConnection_Archival : Error while Obtain Connection  =====> " + e.getMessage());
        }

        return con;
    }

    public void closeConnection(final Connection conn)
    {
        try
        {
            if (conn != null && !conn.isClosed())
            {
                conn.close();
            }
        }
        catch (SQLException e)
        {
            //icpsFileProcessorLog.log(Level.SEVERE, e.getMessage());
            System.out.println(e.getMessage());
        }
    }

    public void closeResultSet(final ResultSet rs)
    {
        try
        {
            if (rs != null)
            {
                rs.close();
            }
        }
        catch (SQLException e)
        {
            //icpsFileProcessorLog.log(Level.SEVERE, e.getMessage());
            System.out.println(e.getMessage());
        }

    }

    public void closeStatement(final Statement stmt)
    {
        try
        {
            if (stmt != null)
            {
                stmt.close();
            }
        }
        catch (SQLException e)
        {
            System.out.println(e.getMessage());
        }
    }

}

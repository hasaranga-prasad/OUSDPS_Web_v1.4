/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.window;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

public class WindowUtil
{

    public static Window makeWindowObject(ResultSet rs)
            throws Exception
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Window window = null;

        if (rs.isBeforeFirst())
        {

            rs.next();
            window = new Window();

            window.setBankcode(rs.getString("BankCode"));
            window.setBankShortName(rs.getString("ShortName"));
            window.setBankFullName(rs.getString("FullName"));
            window.setSession(rs.getString("currentsession"));
            window.setCutontime(rs.getString("cutontime"));


            //System.out.println("window.setBankcode(" + window.getBankcode());

            if (rs.getString("cutontime") != null)
            {
                window.setCutontimeHour(Integer.parseInt(rs.getString("cutontime").substring(0, 2)));
                window.setCutontimeMinutes(Integer.parseInt(rs.getString("cutontime").substring(2)));
            }

            window.setCutofftime(rs.getString("cutofftime"));

            if (rs.getString("cutofftime") != null)
            {
                window.setCutofftimeHour(Integer.parseInt(rs.getString("cutofftime").substring(0, 2)));
                window.setCutofftimeMinutes(Integer.parseInt(rs.getString("cutofftime").substring(2)));
            }

            //System.out.println("window.getCutofftimeHour() --> " + window.getCutofftimeHour());
            //System.out.println("window.getCutofftimeMinutes() --> " + window.getCutofftimeMinutes());

            window.setDefaultcutontime(rs.getString("defaultcutontime"));

            if (rs.getString("defaultcutontime") != null)
            {
                window.setDefaultcutontimeHour(Integer.parseInt(rs.getString("defaultcutontime").substring(0, 2)));
                window.setDefaultcutontimeMinutes(Integer.parseInt(rs.getString("defaultcutontime").substring(2)));
            }

            //System.out.println("window.getDefaultcutontimeHour --> " + window.getDefaultcutofftimeHour());
            //System.out.println("window.getDefaultcutontimeMinutes --> " + window.getDefaultcutontimeMinutes());

            window.setDefaultcutofftime(rs.getString("defaultcutofftime"));

            if (rs.getString("defaultcutofftime") != null)
            {
                window.setDefaultcutofftimeHour(Integer.parseInt(rs.getString("defaultcutofftime").substring(0, 2)));
                window.setDefaultcutofftimeMinutes(Integer.parseInt(rs.getString("defaultcutofftime").substring(2)));
            }

            window.setModifiedby(rs.getString("modifiedby"));

            if (rs.getString("modifieddate") != null)
            {
                window.setModifieddate(DateFormatter.doFormat(rs.getTimestamp("modifieddate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
        }

        return window;
    }

    public static Collection<Window> makeWindowObjectCollection(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {

            Window window = new Window();

            window.setBankcode(rs.getString("BankCode"));
            window.setBankShortName(rs.getString("ShortName"));
            window.setBankFullName(rs.getString("FullName"));
            window.setSession(rs.getString("currentsession"));
            window.setCutontime(rs.getString("cutontime"));

            if (rs.getString("cutontime") != null)
            {
                window.setCutontimeHour(Integer.parseInt(rs.getString("cutontime").substring(0, 2)));
                //System.out.println("window.setCutontimeHour --> " + rs.getString("cutontime").substring(0, 2));
                window.setCutontimeMinutes(Integer.parseInt(rs.getString("cutontime").substring(2)));
                //System.out.println("window.setCutontimeMinutes --> " + rs.getString("cutontime").substring(2));
            }

            window.setCutofftime(rs.getString("cutofftime"));

            if (rs.getString("cutofftime") != null)
            {
                window.setCutofftimeHour(Integer.parseInt(rs.getString("cutofftime").substring(0, 2)));
                window.setCutontimeMinutes(Integer.parseInt(rs.getString("cutofftime").substring(2)));
            }

            window.setDefaultcutontime(rs.getString("defaultcutontime"));

            if (rs.getString("defaultcutontime") != null)
            {
                window.setDefaultcutontimeHour(Integer.parseInt(rs.getString("defaultcutontime").substring(0, 2)));
                window.setDefaultcutontimeMinutes(Integer.parseInt(rs.getString("defaultcutontime").substring(2)));
            }

            window.setDefaultcutofftime(rs.getString("defaultcutofftime"));

            if (rs.getString("defaultcutofftime") != null)
            {
                window.setDefaultcutofftimeHour(Integer.parseInt(rs.getString("defaultcutofftime").substring(0, 2)));
                window.setDefaultcutofftimeMinutes(Integer.parseInt(rs.getString("defaultcutofftime").substring(2)));
            }

            if (rs.getString("modifiedby") != null)
            {
                window.setModifiedby(rs.getString("modifiedby"));
            }
            if (rs.getString("modifieddate") != null)
            {
                window.setModifieddate(DateFormatter.doFormat(rs.getTimestamp("modifieddate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(window);
        }
        return result;
    }
}

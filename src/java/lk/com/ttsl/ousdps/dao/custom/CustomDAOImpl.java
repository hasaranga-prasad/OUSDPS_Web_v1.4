/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class CustomDAOImpl implements CustomDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public long getServerTime()
    {
        long serverTime = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select now() as ServerTime from dual");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            if(rs != null && rs.isBeforeFirst())
            {
                rs.next();
                serverTime = rs.getTimestamp("ServerTime").getTime();
            }
            else
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch(Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return serverTime;
    }

    public String getCurrentDate()
    {
        String currentDate = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select now() as ServerTime from dual");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            if(rs != null && rs.isBeforeFirst())
            {
                rs.next();
                currentDate = DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), "yyyy-MM-dd");
            }
            else
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch(Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return currentDate;
    }

    public CustomDate getServerTimeDetails()
    {
        CustomDate customdate = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select now() as ServerTime from dual");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            if(rs != null && rs.isBeforeFirst())
            {
                rs.next();
                customdate = new CustomDate();
                customdate.setYear(Integer.parseInt(DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), LCPL_Constants.simple_date_format_yyyy)));
                customdate.setMonth(Integer.parseInt(DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), LCPL_Constants.simple_date_format_MM)) - 1);
                customdate.setDay(Integer.parseInt(DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), LCPL_Constants.simple_date_format_dd)));
                customdate.setHour(Integer.parseInt(DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), LCPL_Constants.simple_date_format_HH)));
                customdate.setMinitue(Integer.parseInt(DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), LCPL_Constants.simple_date_format_mm)));
                customdate.setSecond(Integer.parseInt(DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), LCPL_Constants.simple_date_format_ss)));
                customdate.setMilisecond(Integer.parseInt(DateFormatter.doFormat(rs.getTimestamp("ServerTime").getTime(), LCPL_Constants.simple_date_format_SSS)));
               

            }
            else
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch(Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return customdate;
    }

}

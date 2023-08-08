/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.window;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

public class WindowDAOImpl implements WindowDAO
{

    static String msg;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public boolean isWindowActive(String bankCode, String session)
    {
        boolean isWindowActive = false;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return isWindowActive;
        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return isWindowActive;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(*) as Hits  from ");
            sbQuery.append("`" + LCPL_Constants.tbl_window + "` ");
            sbQuery.append("where bankcode = ? ");
            sbQuery.append("and currentsession = ? ");
            sbQuery.append("and STR_TO_DATE(cutontime, '%H%i') < CURTIME() ");
            sbQuery.append("and CURTIME() < STR_TO_DATE(cutofftime, '%H%i') ");

            System.out.println("isWindowActive:sbQuery --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bankCode);
            psmt.setString(2, session);

            rs = psmt.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();

                isWindowActive = rs.getInt("Hits") > 0;
            }
            else
            {
                isWindowActive = false;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return isWindowActive;

    }

    /**
     *
     * @param bankcode
     * @return
     */
    @Override
    public Collection<Window> getBankWindow(String bankcode)
    {
        Collection<Window> col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select bankcode,transactiontype,concat(substring(cutontime,1,2),':',substring(cutontime,3,4)) as cutontime,concat(substring(cutofftime,1,2),':',substring(cutofftime,3,4)) as cutofftime from ");
            sbQuery.append("`" + LCPL_Constants.tbl_window + "` ");
            sbQuery.append("where bankcode like ?");
            
            System.out.println("getBankWindow:sbQuery --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            if (bankcode.equals("9991"))
            {
                psmt.setString(1, "%");
            }
            else
            {
                psmt.setString(1, bankcode);
            }

            rs = psmt.executeQuery();

            col = WindowUtil.makeWindowObjectCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    /**
     *
     * @param bankCode
     * @param session
     * @return
     */
    @Override
    public Collection<Window> getWindowDetails(String bankCode, String session)
    {

        Collection<Window> col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_session = 2;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select b.BankCode, b.ShortName, b.FullName, w.currentsession, w.cutontime, w.cutofftime, w.defaultcutontime, w.defaultcutofftime, w.modifiedby, w.modifieddate  from ");
            sbQuery.append("`" + LCPL_Constants.tbl_window + "` w, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " b ");

            sbQuery.append("where w.bankcode = b.BankCode ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and w.bankcode = ? ");
                vt.add(val_bankCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and w.currentsession = ? ");
                vt.add(val_session);
            }

            System.out.println("getWindowDetails:sbQuery --> " + sbQuery.toString());
            
            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setString(i, bankCode);
                    i++;
                }

                if (val_item == 2)
                {
                    psmt.setString(i, session);
                    i++;
                }
            }

            rs = psmt.executeQuery();

            col = WindowUtil.makeWindowObjectCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    /**
     * @param bankCode
     * @param session
     * @return Window
     */
    @Override
    public Window getWindow(String bankCode, String session)
    {

        Window window = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return window;
        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return window;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select b.BankCode, b.ShortName, b.FullName, w.currentsession, w.cutontime, w.cutofftime, w.defaultcutontime, w.defaultcutofftime, w.modifiedby, w.modifieddate  from ");
            sbQuery.append("`" + LCPL_Constants.tbl_window + "` w, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " b ");

            sbQuery.append("where w.bankcode = b.BankCode ");
            sbQuery.append("and w.bankcode = ? ");
            sbQuery.append("and w.currentsession = ? ");

            System.out.println("getWindow:sbQuery --> " + sbQuery.toString());
            System.out.println("bankCode --> " + bankCode);
            System.out.println("session --> " + session);

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bankCode);
            psmt.setString(2, session);

            rs = psmt.executeQuery();

            window = WindowUtil.makeWindowObject(rs);

            if (window == null)
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return window;
    }

    /**
     *
     * @param win
     * @return
     */
    @Override
    public boolean addWindow(Window win)
    {
        boolean status = false;
        int ctr = 0;
        Connection con = null;
        PreparedStatement pstm = null;

        if (win.getBankcode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return status;
        }

        if (win.getSession() == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return status;
        }

        if (win.getCutontime() == null)
        {
            System.out.println("WARNING : Null cutontime parameter.");
            return status;
        }

        if (win.getCutofftime() == null)
        {
            System.out.println("WARNING : Null cutofftime parameter.");
            return status;
        }

        if (win.getDefaultcutontime() == null)
        {
            System.out.println("WARNING : Null defaultcutontime parameter.");
            return status;
        }

        if (win.getDefaultcutofftime() == null)
        {
            System.out.println("WARNING : Null defaultcutofftime parameter.");
            return status;
        }

        if (win.getModifiedby() == null)
        {
            System.out.println("WARNING : Null modifiedby parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("INSERT INTO ");
            sbQuery.append("`" + LCPL_Constants.tbl_window + "` " );
            sbQuery.append("(bankcode,currentsession,cutontime,cutofftime,defaultcutontime,defaultcutofftime,modifiedby,modifieddate)");
            sbQuery.append("VALUES(?, ?, ?, ?,?,?,?,(select NOW()))");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, win.getBankcode());
            pstm.setString(2, win.getSession());
            pstm.setString(3, win.getCutontime());
            pstm.setString(4, win.getCutofftime());
            pstm.setString(5, win.getDefaultcutontime());
            pstm.setString(6, win.getDefaultcutofftime());
            pstm.setString(7, win.getModifiedby());

            ctr = pstm.executeUpdate();

            if (ctr > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = LCPL_Constants.msg_error_while_processing;
                con.rollback();
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;

    }

    /**
     *
     * @param win
     * @return
     */
    @Override
    public boolean updateWindow(Window win)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement pstm = null;
        int count = 0;

        if (win.getBankcode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return status;
        }

        if (win.getSession() == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return status;
        }

        if (win.getCutontime() == null)
        {
            System.out.println("WARNING : Null cutontime parameter.");
            return status;
        }

        if (win.getCutofftime() == null)
        {
            System.out.println("WARNING : Null cutofftime parameter.");
            return status;
        }

        if (win.getDefaultcutontime() == null)
        {
            System.out.println("WARNING : Null defaultcutontime parameter.");
            return status;
        }

        if (win.getDefaultcutofftime() == null)
        {
            System.out.println("WARNING : Null defaultcutofftime parameter.");
            return status;
        }

        if (win.getModifiedby() == null)
        {
            System.out.println("WARNING : Null modifiedby parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append("`" + LCPL_Constants.tbl_window + "` ");
            sbQuery.append("set cutontime = ?, cutofftime = ?, defaultcutontime = ?, defaultcutofftime = ?,  modifiedby = ?, modifieddate=(select NOW()) ");
            sbQuery.append("where bankcode = ? ");
            sbQuery.append("and  currentsession = ?");

            System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, win.getCutontime());
            pstm.setString(2, win.getCutofftime());
            pstm.setString(3, win.getDefaultcutontime());
            pstm.setString(4, win.getDefaultcutofftime());
            pstm.setString(5, win.getModifiedby());
            pstm.setString(6, win.getBankcode());
            pstm.setString(7, win.getSession());

            count = pstm.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = LCPL_Constants.msg_error_while_processing;
                con.rollback();
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    /**
     *
     * @param win
     * @return
     */
    @Override
    public boolean updateWindow_CutOffTime(Window win)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement pstm = null;
        int count = 0;

        if (win.getBankcode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return status;
        }

        if (win.getSession() == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return status;
        }

        if (win.getCutofftime() == null)
        {
            System.out.println("WARNING : Null cutofftime parameter.");
            return status;
        }

        if (win.getModifiedby() == null)
        {
            System.out.println("WARNING : Null modifiedby parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append("`" + LCPL_Constants.tbl_window + "` ");
            sbQuery.append("set cutofftime = ?, modifiedby = ?, modifieddate=(select NOW()) ");
            sbQuery.append("where bankcode = ? ");
            sbQuery.append("and  currentsession = ?");

            //System.out.println(sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, win.getCutofftime());
            pstm.setString(2, win.getModifiedby());
            pstm.setString(3, win.getBankcode());
            pstm.setString(4, win.getSession());

            count = pstm.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = LCPL_Constants.msg_error_while_processing;
                con.rollback();
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    /**
     *
     * @return
     */
    @Override
    public String getCurrentTime_HHmm()
    {
        String currentTime_HHmm = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select DATE_FORMAT(now(), '%H%i') as currentTime from dual");

            //System.out.println("sbQuery.toString() --> " + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            rs = psmt.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                currentTime_HHmm = rs.getString("currentTime");
            }
            else
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return currentTime_HHmm;
    }

}

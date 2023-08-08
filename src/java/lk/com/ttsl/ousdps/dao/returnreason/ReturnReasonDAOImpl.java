/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.returnreason;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class ReturnReasonDAOImpl implements ReturnReasonDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<ReturnReason> getReTurnTypes()
    {
        Collection<ReturnReason> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select RtnCode, RtnReason, PrintAS, status, ModifiedBy, ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_returnreason);
            sbQuery.append(" order by RtnCode ");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = ReturnReasonUtil.makeReturnReasonObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (Exception e)
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

        return col;
    }

    public ReturnReason getReTurnTypeDetails(String returnCode)
    {
        ReturnReason returnReason = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (returnCode == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
            return returnReason;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select RtnCode, RtnReason, PrintAS, status, ModifiedBy, ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_returnreason + " ");
            sbQuery.append("where RtnCode = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, returnCode);

            rs = pstm.executeQuery();

            returnReason = ReturnReasonUtil.makeReturnReasonObject(rs);

            if (returnReason == null)
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (Exception e)
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

        return returnReason;
    }

    public boolean addReTurnTypes(ReturnReason returnReason)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        if (returnReason.getReturnCode() == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
            return false;
        }

        if (returnReason.getReturnReason() == null)
        {
            System.out.println("WARNING : Null returnReason parameter.");
            return false;
        }

        if (returnReason.getPrintAS() == null)
        {
            System.out.println("WARNING : Null printAS parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_returnreason + " ");
            sbQuery.append("(RtnCode, RtnReason, PrintAS, status, ModifiedBy, ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,now())");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, returnReason.getReturnCode());
            psmt.setString(2, returnReason.getReturnReason());
            psmt.setString(3, returnReason.getPrintAS());
            psmt.setString(4, returnReason.getStatus());
            psmt.setString(5, returnReason.getModifiedBy());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
                msg = LCPL_Constants.msg_duplicate_records;
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean modifyReturnTypes(ReturnReason returnReason)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (returnReason.getReturnCode() == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
            return false;
        }

        if (returnReason.getReturnReason() == null)
        {
            System.out.println("WARNING : Null returnReason parameter.");
            return false;
        }

        if (returnReason.getPrintAS() == null)
        {
            System.out.println("WARNING : Null printAS parameter.");
            return false;
        }

        if (returnReason.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_returnreason + " ");
            sbQuery.append("set ");
            sbQuery.append("RtnReason = ?, ");
            sbQuery.append("PrintAS = ?, ");
            sbQuery.append("status = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()) ");
            sbQuery.append("where RtnCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, returnReason.getReturnReason());
            psmt.setString(2, returnReason.getPrintAS());
            psmt.setString(3, returnReason.getStatus());
            psmt.setString(4, returnReason.getModifiedBy());
            psmt.setString(5, returnReason.getReturnCode());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                con.rollback();
            }

        }
        catch (Exception ex)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }
}

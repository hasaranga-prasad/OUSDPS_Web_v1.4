/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.rejectreason;

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
public class RejectReasonDAOImpl implements RejectReasonDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<RejectReason> getRejectReasons()
    {
        Collection<RejectReason> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;


        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select RJCode, RJReason, Description, HtmlDescription from ");
            sbQuery.append(LCPL_Constants.tbl_rejectreason + " ");
            sbQuery.append("order by RJCode ");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = RejectReasonUtil.makeRejectReasonObjectsCollection(rs);

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

    public RejectReason getRejectReasonDetails(String rejectCode)
    {
        RejectReason rejectReason = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (rejectCode == null)
        {
            System.out.println("WARNING : Null rejectCode parameter.");
            return rejectReason;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select RJCode, RJReason, Description, HtmlDescription from ");
            sbQuery.append(LCPL_Constants.tbl_rejectreason + " ");
            sbQuery.append("where RJCode = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, rejectCode);

            rs = pstm.executeQuery();

            rejectReason = RejectReasonUtil.makeRejectReasonObject(rs);

            if (rejectReason == null)
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

        return rejectReason;
    }

    
}

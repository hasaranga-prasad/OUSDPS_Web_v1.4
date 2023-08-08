/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.reportType;

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
public class ReportTypeDAOImpl implements ReportTypeDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public ReportType getReprtType(String type)
    {
        ReportType rt = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return rt;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ReprotType, ReprotTypeDesc from ");
            sbQuery.append(LCPL_Constants.tbl_report_type + " ");
            sbQuery.append("where ReprotType = ? ");

            pstm = con.prepareStatement(sbQuery.toString());
            pstm.setString(1, type);

            rs = pstm.executeQuery();

            rt = ReportTypeUtil.makeReportTypeObject(rs);

            if (rt == null)
            {
                msg = LCPL_Constants.msg_no_records;
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return rt;
    }

    public Collection<ReportType> getReportTypes()
    {
        Collection<ReportType> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ReprotType, ReprotTypeDesc from ");
            sbQuery.append(LCPL_Constants.tbl_report_type + " ");
            sbQuery.append("order by ReprotType");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = ReportTypeUtil.makeReportTypeObjectsCollection(rs);

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

}

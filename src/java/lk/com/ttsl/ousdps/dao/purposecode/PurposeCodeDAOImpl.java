/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.purposecode;

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
public class PurposeCodeDAOImpl implements PurposeCodeDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public PurposeCode getPurposeCode(String purCode)
    {
        PurposeCode purPoseCode = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select purcd, description, status, modifiedby, modifieddate from ");
            sbQuery.append(LCPL_Constants.tbl_purposecode + " ");
            sbQuery.append("where purcd = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, purCode);

            rs = pstm.executeQuery();

            purPoseCode = PurposeCodeUtil.makePurposeCodeObject(rs);

            if (purPoseCode == null)
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

        return purPoseCode;
    }

    public Collection<PurposeCode> getPurposeCodesDetails(String status)
    {
        Collection<PurposeCode> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select purcd, description, status, modifiedby, modifieddate from ");
            sbQuery.append(LCPL_Constants.tbl_purposecode + " ");

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("where status = ?  ");
            }

            sbQuery.append("order by purcd ");
            
            //System.out.println("sbQuery >>> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            if (!status.equals(LCPL_Constants.status_all))
            {
                pstm.setString(1, status);
            }

            rs = pstm.executeQuery();

            col = PurposeCodeUtil.makePurposeCodesObjectsCollection(rs);

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

    public boolean addPurposeCode(PurposeCode purCode)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (purCode.getPurposeCode() == null)
        {
            System.out.println("WARNING : Null purposeCode parameter.");
            return false;
        }

        if (purCode.getDesc() == null)
        {
            System.out.println("WARNING : Null desc parameter.");
            return false;
        }

        if (purCode.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (purCode.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_purposecode + " ");
            sbQuery.append("(purcd, description, status, modifiedby, modifieddate) ");
            sbQuery.append("values (?,?,?,?,(select now()))");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, purCode.getPurposeCode());
            pstm.setString(2, purCode.getDesc());
            pstm.setString(3, purCode.getStatus());
            pstm.setString(4, purCode.getModifiedBy());

            count = pstm.executeUpdate();

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
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean modifyPurposeCode(PurposeCode purCode)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (purCode.getPurposeCode() == null)
        {
            System.out.println("WARNING : Null purposeCode parameter.");
            return false;
        }

        if (purCode.getDesc() == null)
        {
            System.out.println("WARNING : Null desc parameter.");
            return false;
        }

        if (purCode.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (purCode.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_purposecode + " ");
            sbQuery.append("set ");
            sbQuery.append("description = ?, ");
            sbQuery.append("status = ?, ");
            sbQuery.append("modifiedby = ?, ");
            sbQuery.append("modifieddate = now() ");
            sbQuery.append("where purcd = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());
            
            pstm.setString(1, purCode.getDesc());
            pstm.setString(2, purCode.getStatus());
            pstm.setString(3, purCode.getModifiedBy());
            pstm.setString(4, purCode.getPurposeCode());

            count = pstm.executeUpdate();

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
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

}

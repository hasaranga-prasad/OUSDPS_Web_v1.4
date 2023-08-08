/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.subpurposecode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import java.util.Vector;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class SubPurposeCodeDAOImpl implements SubPurposeCodeDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public SubPurposeCode getPurposeCode(String subPurCode)
    {
        SubPurposeCode purPoseCode = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select sp.purcd, p.description as mdesc, sp.subpurcd, sp.description as sdesc, sp.status, sp.modifiedby, sp.modifieddate from ");
            sbQuery.append(LCPL_Constants.tbl_purposecode + " p, ");
            sbQuery.append(LCPL_Constants.tbl_subpurposecd + " sp ");
            sbQuery.append("where sp.purcd = p.purcd  ");
            sbQuery.append("and sp.subpurcd = ? ");
            
            //System.out.println("sbQuery1>>>" + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, subPurCode);

            rs = pstm.executeQuery();

            purPoseCode = SubPurposeCodeUtil.makeSubPurposeCodeObject(rs);

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

    public Collection<SubPurposeCode> getSubPurposeCodesDetails(String purCode, String status)
    {
        Collection<SubPurposeCode> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        if (purCode == null)
        {
            System.out.println("WARNING : Null purCode parameter.");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        Vector<Integer> vt = new Vector();

        int val_purCode = 1;
        int val_status = 2;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select sp.purcd, p.description as mdesc, sp.subpurcd, sp.description as sdesc, sp.status, sp.modifiedby, sp.modifieddate from ");
            sbQuery.append(LCPL_Constants.tbl_purposecode + " p, ");
            sbQuery.append(LCPL_Constants.tbl_subpurposecd + " sp ");
            sbQuery.append("where sp.purcd = p.purcd  ");

            if (!purCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sp.purcd = ?  ");
                vt.add(val_purCode);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sp.status = ?  ");
                vt.add(val_status);
            }

            sbQuery.append("order by purcd, subpurcd ");
            
            System.out.println("sbQuery2>>>" + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_purCode)
                {
                    pstm.setString(i, purCode);
                    i++;
                }
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = SubPurposeCodeUtil.makeSubPurposeCodesObjectsCollection(rs);

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

    public boolean addSubPurposeCode(SubPurposeCode spc)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (spc.getPurposeCode() == null)
        {
            System.out.println("WARNING : Null purposeCode parameter.");
            return false;
        }

        if (spc.getSubPurposeCode() == null)
        {
            System.out.println("WARNING : Null purposeCode parameter.");
            return false;
        }

        if (spc.getDesc() == null)
        {
            System.out.println("WARNING : Null desc parameter.");
            return false;
        }

        if (spc.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (spc.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_subpurposecd + " ");
            sbQuery.append("(purcd, subpurcd, description, status, modifiedby, modifieddate) ");
            sbQuery.append("values (?,?,?,?,?,(select now()))");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, spc.getPurposeCode());
            pstm.setString(2, spc.getPurposeCode() + spc.getSubPurposeCode());
            pstm.setString(3, spc.getDesc());
            pstm.setString(4, spc.getStatus());
            pstm.setString(5, spc.getModifiedBy());

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

    public boolean modifySubPurposeCode(SubPurposeCode spc)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (spc.getPurposeCode() == null)
        {
            System.out.println("WARNING : Null purposeCode parameter.");
            return false;
        }

        if (spc.getSubPurposeCode() == null)
        {
            System.out.println("WARNING : Null subPurposeCode parameter.");
            return false;
        }

        if (spc.getDesc() == null)
        {
            System.out.println("WARNING : Null desc parameter.");
            return false;
        }

        if (spc.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (spc.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_subpurposecd + " ");
            sbQuery.append("set ");
            sbQuery.append("description = ?, ");
            sbQuery.append("status = ?, ");
            sbQuery.append("modifiedby = ?, ");
            sbQuery.append("modifieddate = now() ");
            sbQuery.append("where purcd = ? ");
            sbQuery.append("and subpurcd = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, spc.getDesc());
            pstm.setString(2, spc.getStatus());
            pstm.setString(3, spc.getModifiedBy());
            pstm.setString(4, spc.getPurposeCode());
            pstm.setString(5, spc.getSubPurposeCode());

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

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.accounttype;

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
public class AccountTypeDAOImpl implements AccountTypeDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public AccountType getAccountType(String accountCode)
    {
        AccountType purPoseCode = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select accd, actype, status, modifiedby, modifieddate from ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ");
            sbQuery.append("where accd = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, accountCode);

            rs = pstm.executeQuery();

            purPoseCode = AccountTypeUtil.makeAccountTypeObject(rs);

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

    public Collection<AccountType> getAccountTypeDetails(String status)
    {
        Collection<AccountType> col = null;
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

            sbQuery.append("select accd, actype, status, modifiedby, modifieddate from ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ");

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("where status = ?  ");
            }

            sbQuery.append("order by accd ");

            //System.out.println("sbQuery >>> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            if (!status.equals(LCPL_Constants.status_all))
            {
                pstm.setString(1, status);
            }

            rs = pstm.executeQuery();

            col = AccountTypeUtil.makeAccountTypeObjectsCollection(rs);

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

    public boolean addAccountType(AccountType act)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (act.getAccountCode() == null)
        {
            System.out.println("WARNING : Null accountCode parameter.");
            return false;
        }

        if (act.getAccountType() == null)
        {
            System.out.println("WARNING : Null accountType parameter.");
            return false;
        }

        if (act.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (act.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ");
            sbQuery.append("(accd,actype,status,modifiedby,modifieddate) ");
            sbQuery.append("values (?,?,?,?,(select now()))");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, act.getAccountCode());
            pstm.setString(2, act.getAccountType());
            pstm.setString(3, act.getStatus());
            pstm.setString(4, act.getModifiedBy());

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

    public boolean modifyAccountType(AccountType act)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (act.getAccountCode() == null)
        {
            System.out.println("WARNING : Null accountCode parameter.");
            return false;
        }

        if (act.getAccountType() == null)
        {
            System.out.println("WARNING : Null accountType parameter.");
            return false;
        }

        if (act.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (act.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ");
            sbQuery.append("set ");
            sbQuery.append("actype = ?, ");
            sbQuery.append("status = ?, ");
            sbQuery.append("modifiedby = ?, ");
            sbQuery.append("modifieddate = now() ");
            sbQuery.append("where accd = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, act.getAccountType());
            pstm.setString(2, act.getStatus());
            pstm.setString(3, act.getModifiedBy());
            pstm.setString(4, act.getAccountCode());

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

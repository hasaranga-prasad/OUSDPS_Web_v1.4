/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.branch;

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
public class BranchDAOImpl implements BranchDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Branch getBranchDetails(String bankCode, String branchCode)
    {

        Branch branch = null;
        Connection con = null;
        ResultSet rs = null;
        PreparedStatement psmt = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return branch;
        }

        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return branch;
        }

        try
        {
            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_branchCode = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchStatus, br.ModifiedBy, br.ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append(" and br.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!branchCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append(" and br.BranchCode = ? ");
                vt.add(val_branchCode);
            }

            sbQuery.append("ORDER BY BankCode, BranchCode");

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
                    psmt.setString(i, branchCode);
                    i++;
                }
            }

            rs = psmt.executeQuery();
            // col_branch = BranchUtil.makeBranchObjectsCollection(rs);
            branch = BranchUtil.makeBranchObject(rs);
        }
        catch (Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return branch;

    }

    public Collection<Branch> getBranch(String bankCode)
    {

        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchStatus, br.ModifiedBy, br.ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");
            sbQuery.append("and br.BankCode = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bankCode);

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

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

    public Collection<Branch> getBranch(String bankCode, String status)
    {

        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_status = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchStatus, br.ModifiedBy, br.ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append(" and br.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append(" and br.BranchStatus = ? ");
                vt.add(val_status);
            }

            sbQuery.append("ORDER BY BankCode, BranchCode");

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

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

    public Collection<Branch> getBranchNotInStatus(String bankCode, String status)
    {

        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_status = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchStatus, br.ModifiedBy, br.ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append(" and br.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append(" and br.BranchStatus NOT IN (?) ");
                vt.add(val_status);
            }

            sbQuery.append("ORDER BY BankCode, BranchCode");

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

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

    public Collection<Branch> getAuthPendingBranches(String bankCode, String createdUser)
    {
        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (createdUser == null)
        {
            System.out.println("WARNING : Null createdUser parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchStatus, br.ModifiedBy, br.ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");
            sbQuery.append("AND br.BankCode = ? ");
            sbQuery.append("AND br.ModifiedBy != ? ");
            sbQuery.append("AND br.BranchStatus = ? ");
            sbQuery.append("ORDER BY BankCode, BranchCode");

            //System.out.println("sbQuery --> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bankCode);
            pstm.setString(2, createdUser);
            pstm.setString(3, LCPL_Constants.status_pending);

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

            if (col == null || col.isEmpty())
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

    public boolean addBranch(Branch branch)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getBranchName() == null)
        {
            System.out.println("WARNING : Null branchName parameter.");
            return false;
        }

        if (branch.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (branch.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_branch + " ");
            sbQuery.append("(BankCode,BranchCode,BranchName,BranchStatus,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,now())");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, branch.getBankCode());
            psmt.setString(2, branch.getBranchCode());
            psmt.setString(3, branch.getBranchName());
            psmt.setString(4, branch.getStatus());
            psmt.setString(5, branch.getModifiedBy());

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

    public boolean modifyBranch(Branch branch)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getBranchName() == null)
        {
            System.out.println("WARNING : Null branchName parameter.");
            return false;
        }

        if (branch.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (branch.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_branch + " ");
            sbQuery.append("set ");
            sbQuery.append("BranchName = ?, ");
            sbQuery.append("BranchStatus = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()) ");
            sbQuery.append("where BankCode = ? ");
            sbQuery.append("and BranchCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, branch.getBranchName());
            psmt.setString(2, branch.getStatus());
            psmt.setString(3, branch.getModifiedBy());
            psmt.setString(4, branch.getBankCode());
            psmt.setString(5, branch.getBranchCode());

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

    public boolean doAuthorizedBranch(Branch branch)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getAuthorizedBy() == null)
        {
            System.out.println("WARNING : Null authorizedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_branch + " ");
            sbQuery.append("set ");
            sbQuery.append("BranchStatus = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("AuthorizedDate =(select NOW()) ");
            sbQuery.append("where BankCode = ? ");
            sbQuery.append("and BranchCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, LCPL_Constants.status_active);
            psmt.setString(2, branch.getAuthorizedBy());
            psmt.setString(3, branch.getBankCode());
            psmt.setString(4, branch.getBranchCode());

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

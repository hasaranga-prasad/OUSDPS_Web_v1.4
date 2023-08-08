/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.bank;

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
public class BankDAOImpl implements BankDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Bank getBankDetails(String bankCode)
    {
        Bank bank = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return bank;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode,ShortName,FullName,BankAC,BankStatus,ModifiedBy,ModifiedDate,AuthorizedBy,AuthorizedDate FROM ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ");
            sbQuery.append("WHERE BankCode = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bankCode);

            rs = pstm.executeQuery();

            bank = BankUtil.makeBankObject(rs);

            if (bank == null)
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

        return bank;
    }

    public Collection<Bank> getBank()
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode,ShortName,FullName,BankAC,BankStatus,ModifiedBy,ModifiedDate,AuthorizedBy,AuthorizedDate FROM ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ");
            sbQuery.append("ORDER BY BankCode ");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

            if (col.isEmpty())
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
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    public Collection<Bank> getBank(String status)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode,ShortName,FullName,BankAC,BankStatus,ModifiedBy,ModifiedDate,AuthorizedBy,AuthorizedDate FROM ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ");

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("WHERE BankStatus = ?  ");
            }

            sbQuery.append("ORDER BY BankCode");

            // System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            if (!status.equals(LCPL_Constants.status_all))
            {
                pstm.setString(1, status);
            }

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

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

    public Collection<Bank> getBankNotInStatus(String status)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode,ShortName,FullName,BankAC,BankStatus,ModifiedBy,ModifiedDate,AuthorizedBy,AuthorizedDate FROM ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ");
            sbQuery.append("WHERE BankStatus NOT IN (?) ");
            sbQuery.append("ORDER BY BankCode");

            // System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, status);

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

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

    public Collection<Bank> getAuthPendingBank(String createdUser)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode,ShortName,FullName,BankAC,BankStatus,ModifiedBy,ModifiedDate,AuthorizedBy,AuthorizedDate FROM ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ");
            sbQuery.append("WHERE BankStatus = ? ");
            sbQuery.append("AND ModifiedBy != ? ");
            sbQuery.append("ORDER BY BankCode");

            // System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, LCPL_Constants.status_pending);
            pstm.setString(2, createdUser);

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

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

    public boolean addBank(Bank bank)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        if (bank.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (bank.getShortName() == null)
        {
            System.out.println("WARNING : Null shortName parameter.");
            return false;
        }

        if (bank.getBankFullName() == null)
        {
            System.out.println("WARNING : Null bankFullName parameter.");
            return false;
        }

        if (bank.getAccNo() == null)
        {
            System.out.println("WARNING : Null accNo parameter.");
            return false;
        }

        if (bank.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (bank.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ");
            sbQuery.append("(BankCode,ShortName,FullName,BankAC,BankStatus,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,?,now())");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bank.getBankCode().trim());
            psmt.setString(2, bank.getShortName().trim());
            psmt.setString(3, bank.getBankFullName());
            psmt.setString(4, bank.getAccNo());
            psmt.setString(5, bank.getStatus());
            psmt.setString(6, bank.getModifiedBy());

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

    public boolean modifyBank(Bank bank)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (bank.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (bank.getShortName() == null)
        {
            System.out.println("WARNING : Null shortName parameter.");
            return false;
        }

        if (bank.getBankFullName() == null)
        {
            System.out.println("WARNING : Null bankFullName parameter.");
            return false;
        }

        if (bank.getAccNo() == null)
        {
            System.out.println("WARNING : Null accNo parameter.");
            return false;
        }

        if (bank.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (bank.getModifiedBy() == null)
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
            sbQuery.append(LCPL_Constants.tbl_bank + " ");
            sbQuery.append("set ");
            sbQuery.append("ShortName = ?, ");
            sbQuery.append("FullName = ?, ");
            sbQuery.append("BankAC = ?, ");
            sbQuery.append("BankStatus = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()) ");
            sbQuery.append("where BankCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bank.getShortName());
            psmt.setString(2, bank.getBankFullName());
            psmt.setString(3, bank.getAccNo());
            psmt.setString(4, bank.getStatus());
            psmt.setString(5, bank.getModifiedBy());
            psmt.setString(6, bank.getBankCode());

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

    public boolean doAuthorizedBank(Bank bank)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (bank.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (bank.getAuthorizedBy() == null)
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
            sbQuery.append(LCPL_Constants.tbl_bank + " ");
            sbQuery.append("set ");
            sbQuery.append("BankStatus = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("AuthorizedDate = now() ");
            sbQuery.append("where BankCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, LCPL_Constants.status_active);
            psmt.setString(2, bank.getAuthorizedBy());
            psmt.setString(3, bank.getBankCode());

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

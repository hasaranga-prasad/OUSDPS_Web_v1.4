/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.transactiontype;

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
public class TransactionTypeDAOImpl implements TransactionTypeDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<TransactionType> getTransTypeDetails()
    {
        Collection<TransactionType> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select TC, Description, `C/D`, MaxAmount, MinAmount, MaxValueDate, MinValueDate, Mandatory_1, Mandatory_2, Mandatory_3, MinRtnDate, MaxRtnDate, DesChargeAmount, OrgChargeAmount, ModifiedBy, ModifiedDate, status  from ");
            sbQuery.append(LCPL_Constants.tbl_transactiontype + " ");
            sbQuery.append("order by TC, `C/D`, Description ");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = TransactionTypeUtil.makeTransactionTypeObjectsCollection(rs);

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

    public TransactionType getTransType(String tc)
    {
        TransactionType transType = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (tc == null)
        {
            System.out.println("WARNING : Null tc parameter.");
            return transType;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select TC, Description, `C/D`, MaxAmount, MinAmount, MaxValueDate, MinValueDate, Mandatory_1, Mandatory_2, Mandatory_3, MinRtnDate, MaxRtnDate, DesChargeAmount, OrgChargeAmount, ModifiedBy, ModifiedDate, status from ");
            sbQuery.append(LCPL_Constants.tbl_transactiontype + " ");
            sbQuery.append("where TC = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, tc);

            rs = pstm.executeQuery();

            transType = TransactionTypeUtil.makeTransactionTypeObject(rs);

            if (transType == null)
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

        return transType;
    }

    public boolean addTransType(TransactionType tType)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (tType.getTc() == null)
        {
            System.out.println("WARNING : Null tc parameter.");
            return false;
        }

        if (tType.getDesc() == null)
        {
            System.out.println("WARNING : Null desc parameter.");
            return false;
        }

        if (tType.getType() == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return false;
        }

        if (tType.getMaxAmount() == null)
        {
            System.out.println("WARNING : Null maxAmount parameter.");
            return false;
        }

        if (tType.getMinAmount() == null)
        {
            System.out.println("WARNING : Null minAmount parameter.");
            return false;
        }

        if (tType.getMaxValueDate() == null)
        {
            System.out.println("WARNING : Null maxValueDate parameter.");
            return false;
        }

        if (tType.getMinValueDate() == null)
        {
            System.out.println("WARNING : Null minValueDate parameter.");
            return false;
        }

        if (tType.getMinReturnDate() == null)
        {
            System.out.println("WARNING : Null minReturnDate parameter.");
            return false;
        }
        if (tType.getMaxReturnDate() == null)
        {
            System.out.println("WARNING : Null maxReturnDate parameter.");
            return false;
        }

        if (tType.getMan1() == null)
        {
            System.out.println("WARNING : Null man1 parameter.");
            return false;
        }

        if (tType.getMan2() == null)
        {
            System.out.println("WARNING : Null man2 parameter.");
            return false;
        }

        if (tType.getMan3() == null)
        {
            System.out.println("WARNING : Null man3 parameter.");
            return false;
        }

        if (tType.getDesChargeAmount() == null)
        {
            System.out.println("WARNING : Null desChargeAmount parameter.");
            return false;
        }

        if (tType.getOrgChargeAmount() == null)
        {
            System.out.println("WARNING : Null OrgChargeAmount parameter.");
            return false;
        }

        if (tType.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter. - " + this.getClass().getSimpleName() + ":addTransType(TransactionType tType)");
            return false;
        }

        if (tType.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_transactiontype + " ");
            sbQuery.append("(TC, Description, `C/D`, MaxAmount, MinAmount, MaxValueDate, MinValueDate, Mandatory_1, Mandatory_2, Mandatory_3, MinRtnDate, MaxRtnDate, DesChargeAmount, OrgChargeAmount, status, ModifiedBy, ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,(select now()))");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, tType.getTc());
            pstm.setString(2, tType.getDesc());
            pstm.setString(3, tType.getType());

            double dMaxAmount = 0;
            double dMinAmount = 0;

            if (tType.getMaxAmount().contains("."))
            {
                dMaxAmount = Double.parseDouble(tType.getMaxAmount()) * 100;
            }
            else
            {
                dMaxAmount = Double.parseDouble(tType.getMaxAmount() + "00");
            }

            if (tType.getMinAmount().contains("."))
            {
                dMinAmount = Double.parseDouble(tType.getMinAmount()) * 100;
            }
            else
            {
                dMinAmount = Double.parseDouble(tType.getMinAmount() + "00");
            }

            pstm.setDouble(4, dMaxAmount);
            pstm.setDouble(5, dMinAmount);
            pstm.setInt(6, Integer.parseInt(tType.getMaxValueDate()));
            pstm.setInt(7, Integer.parseInt(tType.getMinValueDate()));
            pstm.setString(8, tType.getMan1());
            pstm.setString(9, tType.getMan2());
            pstm.setString(10, tType.getMan3());
            pstm.setString(11, tType.getMinReturnDate());
            pstm.setString(12, tType.getMaxReturnDate());

            double dDesAmount = 0;
            double dOrgAmount = 0;

            if (tType.getDesChargeAmount().contains("."))
            {
                dDesAmount = Double.parseDouble(tType.getDesChargeAmount()) * 100;
            }
            else
            {
                dDesAmount = Double.parseDouble(tType.getDesChargeAmount() + "00");
            }

            if (tType.getOrgChargeAmount().contains("."))
            {
                dOrgAmount = Double.parseDouble(tType.getOrgChargeAmount()) * 100;
            }
            else
            {
                dOrgAmount = Double.parseDouble(tType.getOrgChargeAmount() + "00");
            }

            pstm.setLong(13, (long) dDesAmount);
            pstm.setLong(14, (long) dOrgAmount);
            
            pstm.setString(15, tType.getStatus());
            pstm.setString(16, tType.getModifiedBy());

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

    public boolean modifyTransType(TransactionType tType)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement pstm = null;
        int count = 0;

        if (tType.getTc() == null)
        {
            System.out.println("WARNING : Null tc parameter.");
            return false;
        }

        if (tType.getDesc() == null)
        {
            System.out.println("WARNING : Null desc parameter.");
            return false;
        }

        if (tType.getType() == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return false;
        }

        if (tType.getMaxAmount() == null)
        {
            System.out.println("WARNING : Null maxAmount parameter.");
            return false;
        }

        if (tType.getMinAmount() == null)
        {
            System.out.println("WARNING : Null minAmount parameter.");
            return false;
        }

        if (tType.getMaxValueDate() == null)
        {
            System.out.println("WARNING : Null maxValueDate parameter.");
            return false;
        }

        if (tType.getMinValueDate() == null)
        {
            System.out.println("WARNING : Null minValueDate parameter.");
            return false;
        }

        if (tType.getMan1() == null)
        {
            System.out.println("WARNING : Null man1 parameter.");
            return false;
        }

        if (tType.getMan2() == null)
        {
            System.out.println("WARNING : Null man2 parameter.");
            return false;
        }

        if (tType.getMan3() == null)
        {
            System.out.println("WARNING : Null man3 parameter.");
            return false;
        }

        if (tType.getMinReturnDate() == null)
        {
            System.out.println("WARNING : Null minReturnDate parameter.");
            return false;
        }

        if (tType.getMaxReturnDate() == null)
        {
            System.out.println("WARNING : Null maxReturnDate parameter.");
            return false;
        }

        if (tType.getDesChargeAmount() == null)
        {
            System.out.println("WARNING : Null desChargeAmount parameter.");
            return false;
        }

        if (tType.getOrgChargeAmount() == null)
        {
            System.out.println("WARNING : Null OrgChargeAmount parameter.");
            return false;
        }

        if (tType.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter. - " + this.getClass().getSimpleName() + ":modifyTransType(TransactionType tType)");
            return false;
        }

        if (tType.getModifiedBy() == null)
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
            sbQuery.append(LCPL_Constants.tbl_transactiontype + " ");
            sbQuery.append("set ");
            sbQuery.append("Description = ?, ");
            sbQuery.append("`C/D` = ?, ");
            sbQuery.append("MaxAmount = ?, ");
            sbQuery.append("MinAmount = ?, ");
            sbQuery.append("MaxValueDate = ?, ");
            sbQuery.append("MinValueDate = ?, ");
            sbQuery.append("Mandatory_1 = ?, ");
            sbQuery.append("Mandatory_2 = ?, ");
            sbQuery.append("Mandatory_3 = ?, ");
            sbQuery.append("MinRtnDate = ?, ");
            sbQuery.append("MaxRtnDate = ?, ");

            sbQuery.append("DesChargeAmount = ?, ");
            sbQuery.append("OrgChargeAmount = ?, ");
            sbQuery.append("status = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate = (select now()) ");
            sbQuery.append("where TC = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, tType.getDesc());
            pstm.setString(2, tType.getType());

            double dMaxAmount = 0;
            double dMinAmount = 0;

            if (tType.getMaxAmount().contains("."))
            {
                dMaxAmount = Double.parseDouble(tType.getMaxAmount()) * 100;
            }
            else
            {
                dMaxAmount = Double.parseDouble(tType.getMaxAmount() + "00");
            }

            if (tType.getMinAmount().contains("."))
            {
                dMinAmount = Double.parseDouble(tType.getMinAmount()) * 100;
            }
            else
            {
                dMinAmount = Double.parseDouble(tType.getMinAmount() + "00");
            }

            pstm.setDouble(3, dMaxAmount);
            pstm.setDouble(4, dMinAmount);
            pstm.setInt(5, Integer.parseInt(tType.getMaxValueDate()));
            pstm.setInt(6, Integer.parseInt(tType.getMinValueDate()));
            pstm.setString(7, tType.getMan1());
            pstm.setString(8, tType.getMan2());
            pstm.setString(9, tType.getMan3());
            pstm.setString(10, tType.getMinReturnDate());
            pstm.setString(11, tType.getMaxReturnDate());

            double dDesAmount = 0;
            double dOrgAmount = 0;

            if (tType.getDesChargeAmount().contains("."))
            {
                dDesAmount = Double.parseDouble(tType.getDesChargeAmount()) * 100;
            }
            else
            {
                dDesAmount = Double.parseDouble(tType.getDesChargeAmount() + "00");
            }

            if (tType.getOrgChargeAmount().contains("."))
            {
                dOrgAmount = Double.parseDouble(tType.getOrgChargeAmount()) * 100;
            }
            else
            {
                dOrgAmount = Double.parseDouble(tType.getOrgChargeAmount() + "00");
            }

            pstm.setLong(12, (long) dDesAmount);
            pstm.setLong(13, (long) dOrgAmount);
            
            pstm.setString(14, tType.getStatus());
            pstm.setString(15, tType.getModifiedBy());
            pstm.setString(16, tType.getTc());

            count = pstm.executeUpdate();

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
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }
}

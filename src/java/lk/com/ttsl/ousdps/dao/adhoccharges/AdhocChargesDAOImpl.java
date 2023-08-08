/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.adhoccharges;

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
public class AdhocChargesDAOImpl implements AdhocChargesDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public AdhocCharges getAdhocChargesType(String adhocChargeCode)
    {
        AdhocCharges ac = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select AdhocCode, Description, Amount, Status, CreatedDate, CreatedBy, ModifiedBy, ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_adhocchargestype + " ");
            sbQuery.append("where AdhocCode = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, adhocChargeCode);

            rs = pstm.executeQuery();

            ac = AdhocChargesUtil.makeAdhocChargesTypeObject(rs);

            if (ac == null)
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

        return ac;
    }

    public Collection<AdhocCharges> getAdhocChargesTypeDetails(String status)
    {
        Collection<AdhocCharges> col = null;
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

            sbQuery.append("select AdhocCode, Description, Amount, Status, CreatedDate, CreatedBy, ModifiedBy, ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_adhocchargestype + " ");

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("where Status = ?  ");
            }

            sbQuery.append("order by AdhocCode ");

            //System.out.println("sbQuery >>> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            if (!status.equals(LCPL_Constants.status_all))
            {
                pstm.setString(1, status);
            }

            rs = pstm.executeQuery();

            col = AdhocChargesUtil.makeAdhocChargesTypeObjectsCollection(rs);

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

    public boolean addAdhocChargesType(AdhocCharges ac)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (ac.getAdhocChargeCode() == null)
        {
            System.out.println("WARNING : Null adhocChargeCode parameter.");
            return false;
        }

        if (ac.getAdhocChargeDesc() == null)
        {
            System.out.println("WARNING : Null adhocChargeDesc parameter.");
            return false;
        }

        if (ac.getAmount() == null)
        {
            System.out.println("WARNING : Null amount parameter.");
            return false;
        }

        if (ac.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (ac.getCreatedBy() == null)
        {
            System.out.println("WARNING : Null createdBy parameter.");
            return false;
        }

        if (ac.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_adhocchargestype + " ");
            sbQuery.append("(AdhocCode, Description, Amount, Status, CreatedDate, CreatedBy, ModifiedBy, ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,now(),?,?,now())");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, ac.getAdhocChargeCode());
            pstm.setString(2, ac.getAdhocChargeDesc());

            double dAmount = 0;

            if (ac.getAmount().contains("."))
            {
                dAmount = Double.parseDouble(ac.getAmount()) * 100;
            }
            else
            {
                dAmount = Double.parseDouble(ac.getAmount() + "00");
            }

            pstm.setDouble(3, dAmount);
            pstm.setString(4, ac.getStatus());
            pstm.setString(5, ac.getCreatedBy());
            pstm.setString(6, ac.getModifiedBy());

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

    public boolean modifyAdhocChargesType(AdhocCharges ac)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (ac.getAdhocChargeCode() == null)
        {
            System.out.println("WARNING : Null adhocChargeCode parameter.");
            return false;
        }

        if (ac.getAdhocChargeDesc() == null)
        {
            System.out.println("WARNING : Null adhocChargeDesc parameter.");
            return false;
        }

        if (ac.getAmount() == null)
        {
            System.out.println("WARNING : Null amount parameter.");
            return false;
        }

        if (ac.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (ac.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_adhocchargestype + " ");
            sbQuery.append("set ");
            sbQuery.append("Description = ?, ");
            sbQuery.append("Amount = ?, ");
            sbQuery.append("Status = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate = now() ");
            sbQuery.append("where AdhocCode = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, ac.getAdhocChargeDesc());

            double dAmount = 0;

            if (ac.getAmount().contains("."))
            {
                dAmount = Double.parseDouble(ac.getAmount()) * 100;
            }
            else
            {
                dAmount = Double.parseDouble(ac.getAmount() + "00");
            }

            pstm.setDouble(2, dAmount);
            pstm.setString(3, ac.getStatus());
            pstm.setString(4, ac.getModifiedBy());
            pstm.setString(5, ac.getAdhocChargeCode());

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

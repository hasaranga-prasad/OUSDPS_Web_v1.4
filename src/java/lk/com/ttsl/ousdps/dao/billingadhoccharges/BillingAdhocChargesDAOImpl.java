/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.billingadhoccharges;

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
public class BillingAdhocChargesDAOImpl implements BillingAdhocChargesDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public BillingAdhocCharges getBillingAdhocChargeDetail(String billingId)
    {
        BillingAdhocCharges bac = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (billingId == null)
        {
            System.out.println("WARNING : Null billingId parameter. (Class:" + this.getClass().getSimpleName() + "|Method:getBillingAdhocChargeDetails)");
            return bac;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select bacd.BillingId, bacd.BillingDate, bacd.BankCode, bnk.ShortName, bnk.FullName, bacd.BranchCode, br.BranchName, bacd.AdhocCode, ac.Description, bacd.Quantity, bacd.Total, bacd.Status, bacd.Remarks, bacd.ReasonForCancel, bacd.CreatedDate, bacd.CreatedBy, bacd.ModifiedBy, bacd.ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_billingadhocstat + " bacd, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " bnk, ");
            sbQuery.append(LCPL_Constants.tbl_branch + " br, ");
            sbQuery.append(LCPL_Constants.tbl_adhocchargestype + " ac ");
            sbQuery.append("where bacd.BankCode = bnk.BankCode ");
            sbQuery.append("and bacd.BankCode = br.BankCode ");
            sbQuery.append("and bacd.BranchCode = br.BranchCode ");
            sbQuery.append("and bacd.AdhocCode = ac.AdhocCode ");

            sbQuery.append("and bacd.BillingId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, Integer.parseInt(billingId));

            rs = pstm.executeQuery();

            bac = BillingAdhocChargesUtil.makeBillingAdhocChargeObject(rs);

            if (bac == null)
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing + e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return bac;
    }

    public Collection<BillingAdhocCharges> getBillingAdhocChargeDetails(String bankCode, String branchCode, String adhocChargeType, String status, String fromBillingDate, String toBillingDate)
    {
        Collection<BillingAdhocCharges> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter. (Class:" + this.getClass().getSimpleName() + "|Method:getBillingAdhocChargeDetails)");
            return col;
        }

        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter. (Class:" + this.getClass().getSimpleName() + "|Method:getBillingAdhocChargeDetails)");
            return col;
        }

        if (adhocChargeType == null)
        {
            System.out.println("WARNING : Null adhocChargeType parameter. (Class:" + this.getClass().getSimpleName() + "|Method:getBillingAdhocChargeDetails)");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter. (Class:" + this.getClass().getSimpleName() + "|Method:getBillingAdhocChargeDetails)");
            return col;
        }

        if (fromBillingDate == null)
        {
            System.out.println("WARNING : Null fromBillingDate parameter. (Class:" + this.getClass().getSimpleName() + "|Method:getBillingAdhocChargeDetails)");
            return col;
        }
        if (toBillingDate == null)
        {
            System.out.println("WARNING : Null toBillingDate parameter. (Class:" + this.getClass().getSimpleName() + "|Method:getBillingAdhocChargeDetails)");
            return col;
        }

        try
        {
            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_branchCode = 2;
            int val_adhocChargeType = 3;
            int val_status = 4;
            int val_fromBillingDate = 5;
            int val_toBillingDate = 6;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select bacd.BillingId, bacd.BillingDate, bacd.BankCode, bnk.ShortName, bnk.FullName, bacd.BranchCode, br.BranchName, bacd.AdhocCode, ac.Description, bacd.Quantity, bacd.Total, bacd.Status, bacd.Remarks, bacd.ReasonForCancel, bacd.CreatedDate, bacd.CreatedBy, bacd.ModifiedBy, bacd.ModifiedDate from ");
            sbQuery.append(LCPL_Constants.tbl_billingadhocstat + " bacd, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " bnk, ");
            sbQuery.append(LCPL_Constants.tbl_branch + " br, ");
            sbQuery.append(LCPL_Constants.tbl_adhocchargestype + " ac ");
            sbQuery.append("where bacd.BankCode = bnk.BankCode ");
            sbQuery.append("and bacd.BankCode = br.BankCode ");
            sbQuery.append("and bacd.BranchCode = br.BranchCode ");
            sbQuery.append("and bacd.AdhocCode = ac.AdhocCode ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and bacd.BankCode = ?  ");
                vt.add(val_bankCode);
            }

            if (!branchCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and bacd.BranchCode = ?  ");
                vt.add(val_branchCode);
            }

            if (!adhocChargeType.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and bacd.AdhocCode = ?  ");
                vt.add(val_adhocChargeType);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and bacd.Status = ?  ");
                vt.add(val_status);
            }

            if (!fromBillingDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and bacd.BillingDate >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromBillingDate);
            }
            if (!toBillingDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and bacd.BillingDate <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toBillingDate);
            }

            sbQuery.append("order by BillingDate, BankCode, BranchCode, BillingId ");

            System.out.println("sbQuery >>> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_bankCode)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == val_branchCode)
                {
                    pstm.setString(i, branchCode);
                    i++;
                }
                if (val_item == val_adhocChargeType)
                {
                    pstm.setString(i, adhocChargeType);
                    i++;
                }
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == val_fromBillingDate)
                {
                    pstm.setString(i, fromBillingDate);
                    i++;
                }
                if (val_item == val_toBillingDate)
                {
                    pstm.setString(i, toBillingDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = BillingAdhocChargesUtil.makeBillingAdhocChargeObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing + e.getMessage();
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

    public boolean addBillingAdhocCharge(BillingAdhocCharges bac)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (bac.getBillingDate() == null)
        {
            System.out.println("WARNING : Null businessDate parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getAdhocChargeCode() == null)
        {
            System.out.println("WARNING : Null adhocChargeType parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getQuantity() == null)
        {
            System.out.println("WARNING : Null Quantity parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getTotal() == null)
        {
            System.out.println("WARNING : Null total parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getCreatedBy() == null)
        {
            System.out.println("WARNING : Null createdBy parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        if (bac.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter. (Class:" + this.getClass().getSimpleName() + "|Method:addBillingAdhocCharge)");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_billingadhocstat + " ");
            sbQuery.append("(BillingDate, BankCode, BranchCode, AdhocCode, Quantity, Total, Status, ");

            if (bac.getRemarks() != null)
            {
                sbQuery.append("Remarks, ");
            }
            sbQuery.append("CreatedDate, CreatedBy, ModifiedBy, ModifiedDate) ");

            sbQuery.append("values (str_to_date(replace(?,'-',''),'%Y%m%d'),?,?,?,?,?,?,");

            if (bac.getRemarks() != null)
            {
                sbQuery.append("?,");
            }

            sbQuery.append("now(),?,?,now())");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bac.getBillingDate());
            pstm.setString(2, bac.getBankCode());
            pstm.setString(3, bac.getBranchCode());
            pstm.setString(4, bac.getAdhocChargeCode());
            pstm.setLong(5, Long.parseLong(bac.getQuantity()));

            double dTotal = 0;

            if (bac.getTotal().contains("."))
            {
                dTotal = Double.parseDouble(bac.getTotal()) * 100;
            }
            else
            {
                dTotal = Double.parseDouble(bac.getTotal() + "00");
            }

            pstm.setDouble(6, dTotal);
            pstm.setString(7, bac.getStatus());

            if (bac.getRemarks() != null)
            {
                pstm.setString(8, bac.getRemarks());
                pstm.setString(9, bac.getCreatedBy());
                pstm.setString(10, bac.getModifiedBy());
            }
            else
            {
                pstm.setString(8, bac.getCreatedBy());
                pstm.setString(9, bac.getModifiedBy());
            }

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

    public boolean cancelBillingAdhocCharge(BillingAdhocCharges bac)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        if (bac.getBillingId() < 0)
        {
            System.out.println("WARNING : Invalid billingId parameter. (Class:" + this.getClass().getSimpleName() + "|Method:modifyBillingAdhocCharge)");
            return false;
        }

        if (bac.getReasonForCancel() == null)
        {
            System.out.println("WARNING : Null reasonForCancel parameter. (Class:" + this.getClass().getSimpleName() + "|Method:modifyBillingAdhocCharge)");
            return false;
        }

        if (bac.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter. (Class:" + this.getClass().getSimpleName() + "|Method:modifyBillingAdhocCharge)");
            return false;
        }

        if (bac.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter. (Class:" + this.getClass().getSimpleName() + "|Method:modifyBillingAdhocCharge)");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_billingadhocstat + " ");
            sbQuery.append("set ");
            sbQuery.append("Status = ?, ");
            sbQuery.append("ReasonForCancel = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate = now() ");
            sbQuery.append("where BillingId = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bac.getStatus());
            pstm.setString(2, bac.getReasonForCancel());
            pstm.setString(3, bac.getModifiedBy());
            pstm.setLong(4, bac.getBillingId());

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

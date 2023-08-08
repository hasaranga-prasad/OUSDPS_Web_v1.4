/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.billingadhoccharges;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class BillingAdhocChargesUtil
{

    static BillingAdhocCharges makeBillingAdhocChargeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        BillingAdhocCharges bac = null;

        if (rs.isBeforeFirst())
        {
            bac = new BillingAdhocCharges();

            rs.next();

            bac.setBillingId(rs.getLong("BillingId"));

            if (rs.getTimestamp("BillingDate") != null)
            {
                bac.setBillingDate(DateFormatter.doFormat(rs.getTimestamp("BillingDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }

            bac.setBankCode(rs.getString("BankCode"));
            bac.setBankShortName(rs.getString("ShortName"));
            bac.setBankFullName(rs.getString("FullName"));
            bac.setBranchCode(rs.getString("BranchCode"));
            bac.setBranchName(rs.getString("BranchName"));

            bac.setAdhocChargeCode(rs.getString("AdhocCode"));
            bac.setAdhocChargeDesc(rs.getString("Description"));

            bac.setlQuantity(rs.getLong("Quantity"));
            bac.setlTotal(rs.getLong("Total"));

            bac.setlAmountPerItem(rs.getLong("Total") / rs.getLong("Quantity"));

            bac.setStatus(rs.getString("Status"));
            bac.setRemarks(rs.getString("Remarks"));            
            bac.setReasonForCancel(rs.getString("ReasonForCancel"));
            
            bac.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                bac.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bac.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                bac.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
        }

        return bac;
    }

    static Collection<BillingAdhocCharges> makeBillingAdhocChargeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<BillingAdhocCharges> result = new java.util.ArrayList();

        while (rs.next())
        {
            BillingAdhocCharges bac = new BillingAdhocCharges();

            bac.setBillingId(rs.getLong("BillingId"));

            if (rs.getTimestamp("BillingDate") != null)
            {
                bac.setBillingDate(DateFormatter.doFormat(rs.getTimestamp("BillingDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }

            bac.setBankCode(rs.getString("BankCode"));
            bac.setBankShortName(rs.getString("ShortName"));
            bac.setBankFullName(rs.getString("FullName"));
            bac.setBranchCode(rs.getString("BranchCode"));
            bac.setBranchName(rs.getString("BranchName"));

            bac.setAdhocChargeCode(rs.getString("AdhocCode"));
            bac.setAdhocChargeDesc(rs.getString("Description"));

            bac.setlQuantity(rs.getLong("Quantity"));
            bac.setlTotal(rs.getLong("Total"));

            bac.setlAmountPerItem(rs.getLong("Total") / rs.getLong("Quantity"));

            bac.setStatus(rs.getString("Status"));
            bac.setRemarks(rs.getString("Remarks"));
            bac.setReasonForCancel(rs.getString("ReasonForCancel"));
            
            bac.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                bac.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bac.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                bac.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(bac);
        }

        return result;
    }
}

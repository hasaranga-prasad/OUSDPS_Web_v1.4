/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.billingadhoccharges;

/**
 *
 * @author Dinesh
 */
public class BillingAdhocCharges
{

    private long billingId;
    private String billingDate;
    private String bankCode;
    private String bankShortName;
    private String bankFullName;
    private String branchCode;
    private String branchName;
    private String adhocChargeCode;
    private String adhocChargeDesc;
    private String amountPerItem;
    private long lAmountPerItem;
    private String quantity;
    private long lQuantity;
    private String total;
    private long lTotal;
    private String status;
    private String remarks;
    private String reasonForCancel;
    private String createdBy;
    private String createdDate;
    private String modifiedBy;
    private String modifiedDate;

    public BillingAdhocCharges()
    {
    }

    public BillingAdhocCharges(long billingId, String status, String remarks, String reasonForCancel, String modifiedBy)
    {
        this.billingId = billingId;
        this.status = status;
        this.remarks = remarks;
        this.reasonForCancel = reasonForCancel;
        this.modifiedBy = modifiedBy;
    }

    public BillingAdhocCharges(String billingDate, String bankCode, String branchCode, String adhocChargeCode, String quantity, String total, String status, String createdBy, String modifiedBy)
    {
        this.billingDate = billingDate;
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.adhocChargeCode = adhocChargeCode;
        this.quantity = quantity;
        this.total = total;
        this.status = status;
        this.createdBy = createdBy;
        this.modifiedBy = modifiedBy;
    }

    public BillingAdhocCharges(String billingDate, String bankCode, String branchCode, String adhocChargeCode, String quantity, String total, String status, String remarks, String createdBy, String modifiedBy)
    {
        this.billingDate = billingDate;
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.adhocChargeCode = adhocChargeCode;
        this.quantity = quantity;
        this.total = total;
        this.status = status;
        this.remarks = remarks;
        this.createdBy = createdBy;
        this.modifiedBy = modifiedBy;
    }

    public long getBillingId()
    {
        return billingId;
    }

    public void setBillingId(long billingId)
    {
        this.billingId = billingId;
    }

    public String getBillingDate()
    {
        return billingDate;
    }

    public void setBillingDate(String billingDate)
    {
        this.billingDate = billingDate;
    }

    public String getBankCode()
    {
        return bankCode;
    }

    public void setBankCode(String bankCode)
    {
        this.bankCode = bankCode;
    }

    public String getBankShortName()
    {
        return bankShortName;
    }

    public void setBankShortName(String bankShortName)
    {
        this.bankShortName = bankShortName;
    }

    public String getBankFullName()
    {
        return bankFullName;
    }

    public void setBankFullName(String bankFullName)
    {
        this.bankFullName = bankFullName;
    }

    public String getBranchCode()
    {
        return branchCode;
    }

    public void setBranchCode(String branchCode)
    {
        this.branchCode = branchCode;
    }

    public String getBranchName()
    {
        return branchName;
    }

    public void setBranchName(String branchName)
    {
        this.branchName = branchName;
    }

    public String getAdhocChargeCode()
    {
        return adhocChargeCode;
    }

    public void setAdhocChargeCode(String adhocChargeCode)
    {
        this.adhocChargeCode = adhocChargeCode;
    }

    public String getAdhocChargeDesc()
    {
        return adhocChargeDesc;
    }

    public void setAdhocChargeDesc(String adhocChargeDesc)
    {
        this.adhocChargeDesc = adhocChargeDesc;
    }

    public String getAmountPerItem()
    {
        return amountPerItem;
    }

    public void setAmountPerItem(String amountPerItem)
    {
        this.amountPerItem = amountPerItem;
    }

    public long getlAmountPerItem()
    {
        return lAmountPerItem;
    }

    public void setlAmountPerItem(long lAmountPerItem)
    {
        this.lAmountPerItem = lAmountPerItem;
    }

    public String getQuantity()
    {
        return quantity;
    }

    public void setQuantity(String quantity)
    {
        this.quantity = quantity;
    }

    public long getlQuantity()
    {
        return lQuantity;
    }

    public void setlQuantity(long lQuantity)
    {
        this.lQuantity = lQuantity;
    }

    public String getTotal()
    {
        return total;
    }

    public void setTotal(String total)
    {
        this.total = total;
    }

    public long getlTotal()
    {
        return lTotal;
    }

    public void setlTotal(long lTotal)
    {
        this.lTotal = lTotal;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getRemarks()
    {
        return remarks;
    }

    public void setRemarks(String remarks)
    {
        this.remarks = remarks;
    }

    public String getReasonForCancel()
    {
        return reasonForCancel;
    }

    public void setReasonForCancel(String reasonForCancel)
    {
        this.reasonForCancel = reasonForCancel;
    }

    public String getCreatedBy()
    {
        return createdBy;
    }

    public void setCreatedBy(String createdBy)
    {
        this.createdBy = createdBy;
    }

    public String getCreatedDate()
    {
        return createdDate;
    }

    public void setCreatedDate(String createdDate)
    {
        this.createdDate = createdDate;
    }

    public String getModifiedBy()
    {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy)
    {
        this.modifiedBy = modifiedBy;
    }

    public String getModifiedDate()
    {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate)
    {
        this.modifiedDate = modifiedDate;
    }

}

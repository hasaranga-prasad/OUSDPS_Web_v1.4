/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.adhoccharges;

/**
 *
 * @author Dinesh
 */
public class AdhocCharges
{

    private String adhocChargeCode;
    private String adhocChargeDesc;
    private String status;
    private String amount;
    private long lAmount;
    private String createdBy;
    private String createdDate;
    private String modifiedBy;
    private String modifiedDate;

    public AdhocCharges()
    {
    }

    public AdhocCharges(String adhocChargeCode, String adhocChargeDesc, String status, String amount, String createdBy, String modifiedBy)
    {
        this.adhocChargeCode = adhocChargeCode;
        this.adhocChargeDesc = adhocChargeDesc;
        this.status = status;
        this.amount = amount;
        this.createdBy = createdBy;
        this.modifiedBy = modifiedBy;
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

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getAmount()
    {
        return amount;
    }

    public void setAmount(String amount)
    {
        this.amount = amount;
    }

    public long getlAmount()
    {
        return lAmount;
    }

    public void setlAmount(long lAmount)
    {
        this.lAmount = lAmount;
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

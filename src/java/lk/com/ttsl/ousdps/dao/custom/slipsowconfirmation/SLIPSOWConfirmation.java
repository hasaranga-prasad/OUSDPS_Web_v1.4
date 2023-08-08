/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.slipsowconfirmation;

/**
 *
 * @author Dinesh
 */
public class SLIPSOWConfirmation
{

    private String businessDate;
    private String session;
    private String owBank;
    private String owBankShortName;
    private String owBankFullName;
    private String statusId;
    private String statusDesc;
    private String remarks;
    private String confirmedBy;
    private String confirmedTime;

    public SLIPSOWConfirmation()
    {
    }

    public SLIPSOWConfirmation(String businessDate, String session, String owBank)
    {
        this.businessDate = businessDate;
        this.session = session;
        this.owBank = owBank;
    }

    public SLIPSOWConfirmation(String businessDate, String session, String owBank, String statusId, String confirmedBy)
    {
        this.businessDate = businessDate;
        this.session = session;
        this.owBank = owBank;
        this.statusId = statusId;
        this.confirmedBy = confirmedBy;
    }

    public SLIPSOWConfirmation(String businessDate, String session, String owBank, String statusId, String remarks, String confirmedBy)
    {
        this.businessDate = businessDate;
        this.session = session;
        this.owBank = owBank;
        this.statusId = statusId;
        this.remarks = remarks;
        this.confirmedBy = confirmedBy;
    }
    
    

    public String getBusinessDate()
    {
        return businessDate;
    }

    public void setBusinessDate(String businessDate)
    {
        this.businessDate = businessDate;
    }

    public String getConfirmedBy()
    {
        return confirmedBy;
    }

    public void setConfirmedBy(String confirmedBy)
    {
        this.confirmedBy = confirmedBy;
    }

    public String getConfirmedTime()
    {
        return confirmedTime;
    }

    public void setConfirmedTime(String confirmedTime)
    {
        this.confirmedTime = confirmedTime;
    }

    public String getOwBank()
    {
        return owBank;
    }

    public void setOwBank(String owBank)
    {
        this.owBank = owBank;
    }

    public String getOwBankFullName()
    {
        return owBankFullName;
    }

    public void setOwBankFullName(String owBankFullName)
    {
        this.owBankFullName = owBankFullName;
    }

    public String getOwBankShortName()
    {
        return owBankShortName;
    }

    public void setOwBankShortName(String owBankShortName)
    {
        this.owBankShortName = owBankShortName;
    }

    public String getRemarks()
    {
        return remarks;
    }

    public void setRemarks(String remarks)
    {
        this.remarks = remarks;
    }

    public String getSession()
    {
        return session;
    }

    public void setSession(String session)
    {
        this.session = session;
    }

    public String getStatusDesc()
    {
        return statusDesc;
    }

    public void setStatusDesc(String statusDesc)
    {
        this.statusDesc = statusDesc;
    }

    public String getStatusId()
    {
        return statusId;
    }

    public void setStatusId(String statusId)
    {
        this.statusId = statusId;
    }
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.bank;

/**
 *
 * @author Dinesh
 */
public class Bank
{

    private String bankCode;
    private String shortName;
    private String bankFullName;
    private String accNo;
    private String status;
    private String modifiedBy;
    private String modifiedDate;
    private String authorizedBy;
    private String authorizedDate;

    public Bank()
    {
    }

    public Bank(String bankCode, String authorizedBy)
    {
        this.bankCode = bankCode;
        this.authorizedBy = authorizedBy;
    }

    public Bank(String bankCode, String shortName, String bankFullName, String accNo, String status, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.shortName = shortName;
        this.bankFullName = bankFullName;
        this.accNo = accNo;
        this.status = status;        
        this.modifiedBy = modifiedBy;
    }

    public String getBankCode()
    {
        return bankCode;
    }

    public void setBankCode(String bankCode)
    {
        this.bankCode = bankCode;
    }

    public String getBankFullName()
    {
        return bankFullName;
    }

    public void setBankFullName(String bankFullName)
    {
        this.bankFullName = bankFullName;
    }

    public String getAccNo()
    {
        return accNo;
    }

    public void setAccNo(String accNo)
    {
        this.accNo = accNo;
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

    public String getShortName()
    {
        return shortName;
    }

    public void setShortName(String shortName)
    {
        this.shortName = shortName;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getAuthorizedBy()
    {
        return authorizedBy;
    }

    public void setAuthorizedBy(String authorizedBy)
    {
        this.authorizedBy = authorizedBy;
    }

    public String getAuthorizedDate()
    {
        return authorizedDate;
    }

    public void setAuthorizedDate(String authorizedDate)
    {
        this.authorizedDate = authorizedDate;
    }

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.accounttype;

/**
 *
 * @author Dinesh
 */
public class AccountType
{

    private String accountCode;
    private String accountType;
    private String status;
    private String modifiedBy;
    private String modifiedDate;

    public AccountType()
    {
    }

    public AccountType(String accountCode, String accountType, String status, String modifiedBy)
    {
        this.accountCode = accountCode;
        this.accountType = accountType;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public String getAccountCode()
    {
        return accountCode;
    }

    public void setAccountCode(String accountCode)
    {
        this.accountCode = accountCode;
    }

    public String getAccountType()
    {
        return accountType;
    }

    public void setAccountType(String accountType)
    {
        this.accountType = accountType;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
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

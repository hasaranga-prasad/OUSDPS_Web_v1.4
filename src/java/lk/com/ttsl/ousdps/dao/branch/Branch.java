/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.branch;

/**
 *
 * @author Dinesh
 */
public class Branch
{

    private String branchCode;
    private String branchName;
    private String bankCode;
    private String bankShortName;
    private String bankFullName;
    private String status;
    private String modifiedBy;
    private String modifiedDate;
    private String authorizedBy;
    private String authorizedDate;

    public Branch()
    {
    }

    public Branch(String bankCode, String branchCode, String authorizedBy)
    {
        this.branchCode = branchCode;
        this.bankCode = bankCode;
        this.authorizedBy = authorizedBy;
    }

    public Branch(String bankCode, String branchCode, String branchName, String status, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.branchName = branchName;
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

    public String getBankShortName()
    {
        return bankShortName;
    }

    public void setBankShortName(String bankShortName)
    {
        this.bankShortName = bankShortName;
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

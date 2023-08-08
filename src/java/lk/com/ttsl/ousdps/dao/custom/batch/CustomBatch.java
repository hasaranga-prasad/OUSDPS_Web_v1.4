/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.batch;

/**
 *
 * @author Dinesh
 */
public class CustomBatch
{

    public long getAmountCredit()
    {
        return amountCredit;
    }

    public void setAmountCredit(long amountCredit)
    {
        this.amountCredit = amountCredit;
    }

    public String getBusinessDate()
    {
        return businessDate;
    }

    public void setBusinessDate(String businessDate)
    {
        this.businessDate = businessDate;
    }

    public String getFileId()
    {
        return fileId;
    }

    public void setFileId(String fileId)
    {
        this.fileId = fileId;
    }

    public String getFormattedAmountCredit()
    {
        return formattedAmountCredit;
    }

    public void setFormattedAmountCredit(String formattedAmountCredit)
    {
        this.formattedAmountCredit = formattedAmountCredit;
    }

    public int getItemCountCredit()
    {
        return itemCountCredit;
    }

    public void setItemCountCredit(int itemCountCredit)
    {
        this.itemCountCredit = itemCountCredit;
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

    public String getOwBranch()
    {
        return owBranch;
    }

    public void setOwBranch(String owBranch)
    {
        this.owBranch = owBranch;
    }

    public String getOwBranchName()
    {
        return owBranchName;
    }

    public void setOwBranchName(String owBranchName)
    {
        this.owBranchName = owBranchName;
    }

    public String getSession()
    {
        return session;
    }

    public void setSession(String session)
    {
        this.session = session;
    }

    private String fileId;
    private String owBank;
    private String owBankShortName;
    private String owBankFullName;
    private String owBranch;
    private String owBranchName;
    private String businessDate;
    private String session;
    private String formattedAmountCredit;
    private int itemCountCredit;
    private long amountCredit;

}

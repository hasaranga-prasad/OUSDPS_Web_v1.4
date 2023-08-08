/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.file;

/**
 *
 * @author Dinesh
 */
public class FileInfo
{

    private String fileId;
    private String owBank;
    private String owBankShortName;
    private String owBankFullName;
    private String owBranch;
    private String owBranchName;
    private String businessDate;
    private String session;
    private String StatusCode;
    private String StatusDesc;
    private String transactionTime;
    private int orgNoOfTransaction;
    private long orgTotalAmount;
    private int rejNoOfTransaction;
    private long rejTotalAmount;

    public String getFileId()
    {
        return fileId;
    }

    public void setFileId(String fileId)
    {
        this.fileId = fileId;
    }

    public String getOwBank()
    {
        return owBank;
    }

    public void setOwBank(String owBank)
    {
        this.owBank = owBank;
    }

    public String getOwBankShortName()
    {
        return owBankShortName;
    }

    public void setOwBankShortName(String owBankShortName)
    {
        this.owBankShortName = owBankShortName;
    }

    public String getOwBankFullName()
    {
        return owBankFullName;
    }

    public void setOwBankFullName(String owBankFullName)
    {
        this.owBankFullName = owBankFullName;
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

    public String getBusinessDate()
    {
        return businessDate;
    }

    public void setBusinessDate(String businessDate)
    {
        this.businessDate = businessDate;
    }

    public String getSession()
    {
        return session;
    }

    public void setSession(String session)
    {
        this.session = session;
    }

    public String getStatusCode()
    {
        return StatusCode;
    }

    public void setStatusCode(String StatusCode)
    {
        this.StatusCode = StatusCode;
    }

    public String getStatusDesc()
    {
        return StatusDesc;
    }

    public void setStatusDesc(String StatusDesc)
    {
        this.StatusDesc = StatusDesc;
    }

    public String getTransactionTime()
    {
        return transactionTime;
    }

    public void setTransactionTime(String transactionTime)
    {
        this.transactionTime = transactionTime;
    }

    public int getOrgNoOfTransaction()
    {
        return orgNoOfTransaction;
    }

    public void setOrgNoOfTransaction(int orgNoOfTransaction)
    {
        this.orgNoOfTransaction = orgNoOfTransaction;
    }

    public long getOrgTotalAmount()
    {
        return orgTotalAmount;
    }

    public void setOrgTotalAmount(long orgTotalAmount)
    {
        this.orgTotalAmount = orgTotalAmount;
    }

    public int getRejNoOfTransaction()
    {
        return rejNoOfTransaction;
    }

    public void setRejNoOfTransaction(int rejNoOfTransaction)
    {
        this.rejNoOfTransaction = rejNoOfTransaction;
    }

    public long getRejTotalAmount()
    {
        return rejTotalAmount;
    }

    public void setRejTotalAmount(long rejTotalAmount)
    {
        this.rejTotalAmount = rejTotalAmount;
    }

}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.report;

/**
 *
 * @author Dinesh
 */
public class Report
{

    private String businessDate;
    private String session;
    private String bank;
    private String bankShortName;
    private String bankFullName;
    private String subBank;
    private String subBankShortName;
    private String subBankFullName;
    private String branch;
    private String branchName;
    private String reportName;
    private String reportPath;
    private String reportType;
    private String reportTypeDesc;
    private String isDownloadable;
    private String createdTime;
    private String isAlreadyDownloaded;
    private String downloadedBy;
    private String downloadedTime;

    public String getBank()
    {
        return bank;
    }

    public void setBank(String bank)
    {
        this.bank = bank;
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

    public String getBranch()
    {
        return branch;
    }

    public void setBranch(String branch)
    {
        this.branch = branch;
    }

    public String getBranchName()
    {
        return branchName;
    }

    public void setBranchName(String branchName)
    {
        this.branchName = branchName;
    }

    public String getBusinessDate()
    {
        return businessDate;
    }

    public void setBusinessDate(String businessDate)
    {
        this.businessDate = businessDate;
    }

    public String getCreatedTime()
    {
        return createdTime;
    }

    public void setCreatedTime(String createdTime)
    {
        this.createdTime = createdTime;
    }

    public String getDownloadedBy()
    {
        return downloadedBy;
    }

    public void setDownloadedBy(String downloadedBy)
    {
        this.downloadedBy = downloadedBy;
    }

    public String getDownloadedTime()
    {
        return downloadedTime;
    }

    public void setDownloadedTime(String downloadedTime)
    {
        this.downloadedTime = downloadedTime;
    }

    public String getIsAlreadyDownloaded()
    {
        return isAlreadyDownloaded;
    }

    public void setIsAlreadyDownloaded(String isAlreadyDownloaded)
    {
        this.isAlreadyDownloaded = isAlreadyDownloaded;
    }

    public String getIsDownloadable()
    {
        return isDownloadable;
    }

    public void setIsDownloadable(String isDownloadable)
    {
        this.isDownloadable = isDownloadable;
    }

    public String getReportName()
    {
        return reportName;
    }

    public void setReportName(String reportName)
    {
        this.reportName = reportName;
    }

    public String getReportPath()
    {
        return reportPath;
    }

    public void setReportPath(String reportPath)
    {
        this.reportPath = reportPath;
    }

    public String getReportType()
    {
        return reportType;
    }

    public String getReportTypeDesc()
    {
        return reportTypeDesc;
    }

    public void setReportTypeDesc(String reportTypeDesc)
    {
        this.reportTypeDesc = reportTypeDesc;
    }

    public void setReportType(String reportType)
    {
        this.reportType = reportType;
    }

    public String getSession()
    {
        return session;
    }

    public void setSession(String session)
    {
        this.session = session;
    }

    public String getSubBank()
    {
        return subBank;
    }

    public void setSubBank(String subBank)
    {
        this.subBank = subBank;
    }

    public String getSubBankFullName()
    {
        return subBankFullName;
    }

    public void setSubBankFullName(String subBankFullName)
    {
        this.subBankFullName = subBankFullName;
    }

    public String getSubBankShortName()
    {
        return subBankShortName;
    }

    public void setSubBankShortName(String subBankShortName)
    {
        this.subBankShortName = subBankShortName;
    }

}

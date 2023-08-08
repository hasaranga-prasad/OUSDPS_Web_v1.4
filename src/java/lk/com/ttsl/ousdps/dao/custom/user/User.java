/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.user;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class User
{

    private String userId;
    private String userLevelId;
    private String userLevelDesc;
    private String password;
    private String bankCode;
    private String bankShortName;
    private String bankFullName;
    private String branchCode;
    private String branchName;
    private String status;
    private String name;
    private String designation;
    private String email;
    private String contactNo;
    private String createdDate;
    private String createdBy;
    private String modifiedDate;
    private String modifiedBy;
    private String lastPasswordResetDate;
    private String remarks;
    private String isInitialPassword;
    private String needDownloadToBIM;
    private String lastLoggingAttempt;
    private int unSccessfulLoggingAttempts;
    private long timeDiff;
    private String authorizedBy;
    private String authorizedDate;

    public User()
    {
    }

    public User(String userId)
    {
        this.userId = userId;
    }

    public User(String userId, String password)
    {
        this.userId = userId;
        this.password = password;
    }

    public User(int unSccessfulLoggingAttempts, long timeDiff)
    {
        this.unSccessfulLoggingAttempts = unSccessfulLoggingAttempts;
        this.timeDiff = timeDiff;
    }

    public User(String userId, String password, String status)
    {
        this.userId = userId;
        this.password = password;
        this.status = status;
    }

    public User(String userLevelId, String bankCode, String branchCode, String status)
    {
        this.userLevelId = userLevelId;
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.status = status;
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

    public String getContactNo()
    {
        return contactNo;
    }

    public void setContactNo(String contactNo)
    {
        this.contactNo = contactNo;
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

    public String getDesignation()
    {
        return designation;
    }

    public void setDesignation(String designation)
    {
        this.designation = designation;
    }

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getIsInitialPassword()
    {
        return isInitialPassword;
    }

    public void setIsInitialPassword(String isInitialPassword)
    {
        this.isInitialPassword = isInitialPassword;
    }

    public String getLastLoggingAttempt()
    {
        return lastLoggingAttempt;
    }

    public void setLastLoggingAttempt(String lastLoggingAttempt)
    {
        this.lastLoggingAttempt = lastLoggingAttempt;
    }

    public String getLastPasswordResetDate()
    {
        return lastPasswordResetDate;
    }

    public void setLastPasswordResetDate(String lastPasswordResetDate)
    {
        this.lastPasswordResetDate = lastPasswordResetDate;
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

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getNeedDownloadToBIM()
    {
        return needDownloadToBIM;
    }

    public void setNeedDownloadToBIM(String needDownloadToBIM)
    {
        this.needDownloadToBIM = needDownloadToBIM;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getRemarks()
    {
        return remarks;
    }

    public void setRemarks(String remarks)
    {
        this.remarks = remarks;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public long getTimeDiff()
    {
        return timeDiff;
    }

    public void setTimeDiff(long timeDiff)
    {
        this.timeDiff = timeDiff;
    }

    public int getUnSccessfulLoggingAttempts()
    {
        return unSccessfulLoggingAttempts;
    }

    public void setUnSccessfulLoggingAttempts(int unSccessfulLoggingAttempts)
    {
        this.unSccessfulLoggingAttempts = unSccessfulLoggingAttempts;
    }

    public String getUserId()
    {
        return userId;
    }

    public void setUserId(String userId)
    {
        this.userId = userId;
    }

    public String getUserLevelDesc()
    {
        return userLevelDesc;
    }

    public void setUserLevelDesc(String userLevelDesc)
    {
        this.userLevelDesc = userLevelDesc;
    }

    public String getUserLevelId()
    {
        return userLevelId;
    }

    public void setUserLevelId(String userLevelId)
    {
        this.userLevelId = userLevelId;
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

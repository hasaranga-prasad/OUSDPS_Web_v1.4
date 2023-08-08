/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.purposecode;

/**
 *
 * @author Dinesh
 */
public class PurposeCode
{

    private String purposeCode;
    private String desc;
    private String status;
    private String modifiedBy;
    private String modifiedDate;

    public PurposeCode()
    {
    }

    public PurposeCode(String purposeCode, String desc, String status, String modifiedBy)
    {
        this.purposeCode = purposeCode;
        this.desc = desc;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public String getPurposeCode()
    {
        return purposeCode;
    }

    public void setPurposeCode(String purposeCode)
    {
        this.purposeCode = purposeCode;
    }

    public String getDesc()
    {
        return desc;
    }

    public void setDesc(String desc)
    {
        this.desc = desc;
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

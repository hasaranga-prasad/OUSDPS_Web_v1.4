/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.returnreason;

/**
 *
 * @author Dinesh
 */
public class ReturnReason
{

    private String returnCode;
    private String returnReason;
    private String printAS;
    private String status;
    private String modifiedBy;
    private String modifiedDate;

    public ReturnReason()
    {
    }

    public ReturnReason(String returnCode, String returnReason, String printAS, String status, String modifiedBy)
    {
        this.returnCode = returnCode;
        this.returnReason = returnReason;
        this.printAS = printAS;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public String getReturnCode()
    {
        return returnCode;
    }

    public void setReturnCode(String returnCode)
    {
        this.returnCode = returnCode;
    }

    public String getReturnReason()
    {
        return returnReason;
    }

    public void setReturnReason(String returnReason)
    {
        this.returnReason = returnReason;
    }

    public String getPrintAS()
    {
        return printAS;
    }

    public void setPrintAS(String printAS)
    {
        this.printAS = printAS;
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

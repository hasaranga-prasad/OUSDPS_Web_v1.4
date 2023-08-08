/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.rejectreason;

/**
 *
 * @author Dinesh
 */
public class RejectReason
{

    private String rejectCode;
    private String rejectReason;
    private String description;
    private String htmlDescription;

    public RejectReason()
    {
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getHtmlDescription()
    {
        return htmlDescription;
    }

    public void setHtmlDescription(String htmlDescription)
    {
        this.htmlDescription = htmlDescription;
    }

    public String getRejectCode()
    {
        return rejectCode;
    }

    public void setRejectCode(String rejectCode)
    {
        this.rejectCode = rejectCode;
    }

    public String getRejectReason()
    {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason)
    {
        this.rejectReason = rejectReason;
    }
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.parameter;

/**
 *
 * @author Dinesh
 */
public class Parameter
{

    private String name;
    private String description;
    private String value;
    private String decrytedValue;
    private String currentValue;
    private String type;
    private String modifiedby;
    private String modifiedDate;
    private String updateStatus;
    private String updateStatusMsg;

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getValue()
    {
        return value;
    }

    public void setValue(String value)
    {
        this.value = value;
    }

    public String getDecrytedValue()
    {
        return decrytedValue;
    }

    public void setDecrytedValue(String decrytedValue)
    {
        this.decrytedValue = decrytedValue;
    }

    public String getCurrentValue()
    {
        return currentValue;
    }

    public void setCurrentValue(String currentValue)
    {
        this.currentValue = currentValue;
    }

    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public String getModifiedby()
    {
        return modifiedby;
    }

    public void setModifiedby(String modifiedby)
    {
        this.modifiedby = modifiedby;
    }

    public String getModifiedDate()
    {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate)
    {
        this.modifiedDate = modifiedDate;
    }

    public String getUpdateStatus()
    {
        return updateStatus;
    }

    public void setUpdateStatus(String updateStatus)
    {
        this.updateStatus = updateStatus;
    }

    public String getUpdateStatusMsg()
    {
        return updateStatusMsg;
    }

    public void setUpdateStatusMsg(String updateStatusMsg)
    {
        this.updateStatusMsg = updateStatusMsg;
    }
}

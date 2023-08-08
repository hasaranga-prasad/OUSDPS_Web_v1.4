/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.window;

/**
 *
 * @author Dinesh
 */
public class Window
{

    private String bankcode;
    private String bankShortName;
    private String bankFullName;
    private String session;
    private String cutontime;
    private String cutofftime;
    private String defaultcutontime;
    private String defaultcutofftime;
    private String modifiedby;
    private String modifieddate;
    private int cutontimeHour;
    private int cutontimeMinutes;
    private int cutofftimeHour;
    private int cutofftimeMinutes;
    private int defaultcutontimeHour;
    private int defaultcutontimeMinutes;
    private int defaultcutofftimeHour;
    private int defaultcutofftimeMinutes;

    public Window()
    {
    }

    public Window(String bankcode, String session, String cutontime, String cutofftime, String defaultcutontime, String defaultcutofftime, String modifiedby)
    {
        this.bankcode = bankcode;
        this.session = session;
        this.cutontime = cutontime;
        this.cutofftime = cutofftime;
        this.defaultcutontime = defaultcutontime;
        this.defaultcutofftime = defaultcutofftime;
        this.modifiedby = modifiedby;
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

    public String getBankcode()
    {
        return bankcode;
    }

    public void setBankcode(String bankcode)
    {
        this.bankcode = bankcode;
    }

    public String getCutofftime()
    {
        return cutofftime;
    }

    public void setCutofftime(String cutofftime)
    {
        this.cutofftime = cutofftime;
    }

    public int getCutofftimeHour()
    {
        return cutofftimeHour;
    }

    public void setCutofftimeHour(int cutofftimeHour)
    {
        this.cutofftimeHour = cutofftimeHour;
    }

    public int getCutofftimeMinutes()
    {
        return cutofftimeMinutes;
    }

    public void setCutofftimeMinutes(int cutofftimeMinutes)
    {
        this.cutofftimeMinutes = cutofftimeMinutes;
    }

    public String getCutontime()
    {
        return cutontime;
    }

    public void setCutontime(String cutontime)
    {
        this.cutontime = cutontime;
    }

    public int getCutontimeHour()
    {
        return cutontimeHour;
    }

    public void setCutontimeHour(int cutontimeHour)
    {
        this.cutontimeHour = cutontimeHour;
    }

    public int getCutontimeMinutes()
    {
        return cutontimeMinutes;
    }

    public void setCutontimeMinutes(int cutontimeMinutes)
    {
        this.cutontimeMinutes = cutontimeMinutes;
    }

    public String getDefaultcutofftime()
    {
        return defaultcutofftime;
    }

    public void setDefaultcutofftime(String defaultcutofftime)
    {
        this.defaultcutofftime = defaultcutofftime;
    }

    public int getDefaultcutofftimeHour()
    {
        return defaultcutofftimeHour;
    }

    public void setDefaultcutofftimeHour(int defaultcutofftimeHour)
    {
        this.defaultcutofftimeHour = defaultcutofftimeHour;
    }

    public int getDefaultcutofftimeMinutes()
    {
        return defaultcutofftimeMinutes;
    }

    public void setDefaultcutofftimeMinutes(int defaultcutofftimeMinutes)
    {
        this.defaultcutofftimeMinutes = defaultcutofftimeMinutes;
    }

    public String getDefaultcutontime()
    {
        return defaultcutontime;
    }

    public void setDefaultcutontime(String defaultcutontime)
    {
        this.defaultcutontime = defaultcutontime;
    }

    public int getDefaultcutontimeHour()
    {
        return defaultcutontimeHour;
    }

    public void setDefaultcutontimeHour(int defaultcutontimeHour)
    {
        this.defaultcutontimeHour = defaultcutontimeHour;
    }

    public int getDefaultcutontimeMinutes()
    {
        return defaultcutontimeMinutes;
    }

    public void setDefaultcutontimeMinutes(int defaultcutontimeMinutes)
    {
        this.defaultcutontimeMinutes = defaultcutontimeMinutes;
    }

    public String getModifiedby()
    {
        return modifiedby;
    }

    public void setModifiedby(String modifiedby)
    {
        this.modifiedby = modifiedby;
    }

    public String getModifieddate()
    {
        return modifieddate;
    }

    public void setModifieddate(String modifieddate)
    {
        this.modifieddate = modifieddate;
    }

    public String getSession()
    {
        return session;
    }

    public void setSession(String session)
    {
        this.session = session;
    }
}

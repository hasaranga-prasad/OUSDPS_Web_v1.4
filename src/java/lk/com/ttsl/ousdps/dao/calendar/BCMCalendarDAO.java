/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.calendar;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface BCMCalendarDAO
{

    public String getMsg();

    public Collection<String> getAvailableYears();

    public BCMCalendar getCalendar(String date);

    public Collection<BCMCalendar> getCalendarDetails(String year, String month, String day, String dayType);

    public boolean addBulkCalendarDetails(String year, String modifiedby);
    
    public boolean addCalendarDetail(BCMCalendar cal);

    public boolean updateCalendarDetail(BCMCalendar cal);
}

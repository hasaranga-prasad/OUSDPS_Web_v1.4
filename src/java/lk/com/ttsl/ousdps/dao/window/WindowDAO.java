/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package lk.com.ttsl.ousdps.dao.window;

import java.util.Collection;

/**
 * 
 * @author Dinesh
 */
public interface WindowDAO {

    public Window getWindow(String bankCode, String session);
    
    public Collection<Window> getWindowDetails(String bankCode, String session);
    
    public boolean isWindowActive(String bankCode, String session);

    public  boolean addWindow(Window win);

    public boolean updateWindow(Window win);
    
    public boolean updateWindow_CutOffTime(Window win);
    
    public Collection<Window> getBankWindow(String bankcode);

    public String getCurrentTime_HHmm();
    
    public String getMsg();
}

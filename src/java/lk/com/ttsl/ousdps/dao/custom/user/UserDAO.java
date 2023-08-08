/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.user;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface UserDAO
{
    public String getMsg();

    public boolean isAuthorized(User usr);
    
    public boolean isCurrentlyLoggedin(String userId, int sessionExpTimeInMinutes);

    public boolean isInitialLogin(String userId, String status);

    public Collection<User> getUserDetails(String status);

    public Collection<User> getUsers(User usr, String statusNotIn);
    
    public Collection<User> getAuthPendingUsers(String createdUser);

    public User getUserDetails(String userId, String status);

    public boolean addUser(User usr);
    
    public boolean updateUser(User usr);

    public boolean setUserStatus(String userId, String status);
    
    public boolean setUserLoggingAttempts(String userId, String status);

    public boolean changeUserPassword(User usr, String curPwd, boolean isInitial);
    
    public boolean isOkToChangePassword(String userId, int iMinPwdResetDays);

    public boolean resetUserPassword(User usr);
    
    public boolean doAuthorizedNewUser(String userId, String authBy);

    public Collection<User> getUserList(String UserLevel);

    public int getPasswordValidityPeriod(String userId);
    
    public boolean updateUserVisitStat(String userId, String isCurrentlyLoggedIn);
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.user;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class UserUtil
{

    private UserUtil()
    {
    }

    static Collection<User> makeUserIdObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<User> result = new java.util.ArrayList();

        while (rs.next())
        {
            User user = new User(rs.getString("UserId"));

            result.add(user);
        }

        return result;
    }

    static Collection<User> makeUserObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<User> result = new java.util.ArrayList();

        while (rs.next())
        {
            User user = new User();

            user.setUserId(rs.getString("UserId"));
            user.setUserLevelDesc(rs.getString("UserLevelDesc"));
            user.setUserLevelId(rs.getString("UserLevelId"));
            user.setBankCode(rs.getString("BankCode"));
            user.setBankFullName(rs.getString("BankFullName"));
            user.setBankShortName(rs.getString("BankShortName"));
            user.setBranchCode(rs.getString("BranchCode"));
            //user.setBranchName(rs.getString("BranchName"));
            user.setStatus(rs.getString("Status"));
            user.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                user.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                user.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            if (rs.getTimestamp("LastPasswordResetDate") != null)
            {
                user.setLastPasswordResetDate(DateFormatter.doFormat(rs.getTimestamp("LastPasswordResetDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setName(rs.getString("Name"));
            user.setDesignation(rs.getString("Designation"));
            user.setEmail(rs.getString("Email"));
            user.setContactNo(rs.getString("ContactNo"));

            user.setRemarks(rs.getString("Remarks"));
            user.setIsInitialPassword(rs.getString("IsInitialPassword"));
            user.setNeedDownloadToBIM(rs.getString("NeedDownloadToBIM"));
            user.setUnSccessfulLoggingAttempts(rs.getInt("UnSuccessfulLoggingAttempts"));

            if (rs.getTimestamp("LastLoggingAttempt") != null)
            {
                user.setLastLoggingAttempt(DateFormatter.doFormat(rs.getTimestamp("LastLoggingAttempt").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(user);
        }

        return result;
    }

    static User makeUserObject(ResultSet rs) throws SQLException
    {
        User user = null;

        if (rs == null)
        {
            System.out.println("WARNING : Null resultset parameter.");
            return user;
        }

        if (rs.isBeforeFirst())
        {
            rs.next();

            user = new User();

            user.setUserId(rs.getString("UserId"));
            user.setUserLevelDesc(rs.getString("UserLevelDesc"));
            user.setUserLevelId(rs.getString("UserLevelId"));
            user.setBankCode(rs.getString("BankCode"));
            user.setBankFullName(rs.getString("BankFullName"));
            user.setBankShortName(rs.getString("BankShortName"));
            user.setBranchCode(rs.getString("BranchCode"));
            //user.setBranchName(rs.getString("BranchName"));
            user.setStatus(rs.getString("Status"));
            user.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                user.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            user.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                user.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            if (rs.getTimestamp("LastPasswordResetDate") != null)
            {
                user.setLastPasswordResetDate(DateFormatter.doFormat(rs.getTimestamp("LastPasswordResetDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            user.setName(rs.getString("Name"));
            user.setDesignation(rs.getString("Designation"));
            user.setEmail(rs.getString("Email"));
            user.setContactNo(rs.getString("ContactNo"));

            user.setRemarks(rs.getString("Remarks"));
            user.setIsInitialPassword(rs.getString("IsInitialPassword"));
            user.setNeedDownloadToBIM(rs.getString("NeedDownloadToBIM"));
            user.setUnSccessfulLoggingAttempts(rs.getInt("UnSuccessfulLoggingAttempts"));

            if (rs.getTimestamp("LastLoggingAttempt") != null)
            {
                user.setLastLoggingAttempt(DateFormatter.doFormat(rs.getTimestamp("LastLoggingAttempt").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
        }

        return user;
    }
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.accounttype;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class AccountTypeUtil
{

    static AccountType makeAccountTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        AccountType accType = null;

        if (rs.isBeforeFirst())
        {
            accType = new AccountType();

            rs.next();

            accType.setAccountCode(rs.getString("accd"));
            accType.setAccountType(rs.getString("actype"));
            accType.setStatus(rs.getString("status"));
            accType.setModifiedBy(rs.getString("modifiedby"));

            if (rs.getString("modifieddate") != null)
            {
                accType.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("modifieddate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            } 
        }

        return accType;
    }   
    
    static Collection<AccountType> makeAccountTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<AccountType> result = new java.util.ArrayList();

        while (rs.next())
        {
            AccountType accType = new AccountType();           

            accType.setAccountCode(rs.getString("accd"));
            accType.setAccountType(rs.getString("actype"));
            accType.setStatus(rs.getString("status"));
            accType.setModifiedBy(rs.getString("modifiedby"));

            if (rs.getString("modifieddate") != null)
            {
                accType.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("modifieddate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            result.add(accType);
        }

        return result;
    }
}

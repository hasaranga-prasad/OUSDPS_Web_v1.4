/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.bank;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh - ProntoIT
 */
class BankUtil
{

    private BankUtil()
    {
    }

    static Bank makeBankObject(ResultSet rs) throws SQLException
    {

        Bank bank = null;

        if (rs != null && rs.isBeforeFirst())
        {
            rs.next();

            bank = new Bank();

            bank.setBankCode(rs.getString("BankCode"));
            bank.setShortName(rs.getString("ShortName"));
            bank.setBankFullName(rs.getString("FullName"));
            bank.setAccNo(rs.getString("BankAC"));
            bank.setStatus(rs.getString("BankStatus"));
            bank.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                bank.setModifiedBy(rs.getString("ModifiedDate"));
            }

            bank.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                bank.setAuthorizedDate(rs.getString("AuthorizedDate"));
            }

        }

        return bank;
    }

    static Collection<Bank> makeBankObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Bank> result = new java.util.ArrayList();

        while (rs.next())
        {
            Bank bank = new Bank();

            bank.setBankCode(rs.getString("BankCode"));
            bank.setShortName(rs.getString("ShortName"));
            bank.setBankFullName(rs.getString("FullName"));
            bank.setAccNo(rs.getString("BankAC"));
            bank.setStatus(rs.getString("BankStatus"));
            bank.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                bank.setModifiedBy(rs.getString("ModifiedDate"));
            }

            bank.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                bank.setAuthorizedDate(rs.getString("AuthorizedDate"));
            }

            result.add(bank);

        }

        return result;
    }
}

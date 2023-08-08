/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.file;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class FileInfoUtil
{

    private FileInfoUtil()
    {
    }

    static Collection<FileInfo> makeFileObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<FileInfo> result = new java.util.ArrayList();

        while (rs.next())
        {
            FileInfo file = new FileInfo();

            file.setFileId(rs.getString("fileid"));
            file.setOwBank(rs.getString("bank"));
            file.setOwBankShortName(rs.getString("BankShortName"));
            file.setOwBankFullName(rs.getString("BankFullName"));
            
            if (rs.getTimestamp("BusinessDate") != null)
            {
                file.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }
            
            file.setStatusCode(rs.getString("status"));
            file.setStatusDesc(rs.getString("StatusDesc"));
            file.setSession(rs.getString("WindowSession"));
            file.setOrgNoOfTransaction(rs.getInt("orgnooftransaction"));
            file.setOrgTotalAmount(rs.getLong("orgtotalAmount"));
            file.setRejNoOfTransaction(rs.getInt("rejnooftransaction"));
            file.setRejTotalAmount(rs.getLong("rejtotalAmount"));

            if (rs.getTimestamp("processtime") != null)
            {
                file.setTransactionTime(DateFormatter.doFormat(rs.getTimestamp("processtime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            result.add(file);
        }

        return result;
    }
}

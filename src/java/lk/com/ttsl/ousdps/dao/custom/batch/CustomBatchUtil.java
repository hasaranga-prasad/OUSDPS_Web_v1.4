/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.batch;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class CustomBatchUtil
{

    private CustomBatchUtil()
    {
    }

    public static Collection makeBatchCollection(ResultSet rs) throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {            
            CustomBatch batch = new CustomBatch(); 

            batch.setFileId(rs.getString("fileid"));
            batch.setOwBank(rs.getString("bank"));
            batch.setOwBankShortName(rs.getString("BankShortName"));
            batch.setOwBankFullName(rs.getString("BankFullName"));
            batch.setOwBranch(rs.getString("branch"));
            batch.setOwBranchName(rs.getString("BranchName"));

            if (rs.getTimestamp("BusinessDate") != null)
            {
                batch.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }
            
            batch.setSession(rs.getString("WindowSession"));
            batch.setItemCountCredit(rs.getInt("citem"));
            batch.setAmountCredit(rs.getLong("ctotal"));
            batch.setFormattedAmountCredit(new DecimalFormat("#0.00").format((new Long(rs.getLong("ctotal")).doubleValue()) / 100));

            result.add(batch);
        }

        return result;
    }
}

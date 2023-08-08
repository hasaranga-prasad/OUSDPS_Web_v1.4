/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.transactiontype;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class TransactionTypeUtil
{

    static TransactionType makeTransactionTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        TransactionType transType = null;

        if (rs.isBeforeFirst())
        {
            transType = new TransactionType();

            rs.next();

            transType.setTc(rs.getString("TC"));
            transType.setDesc(rs.getString("Description"));
            transType.setType(rs.getString("C/D"));
            //transactiontype.setMaxAmount(rs.getString("MaxAmount"));
            transType.setlMaxAmount(rs.getLong("MaxAmount"));
            //System.out.println("transactiontype.getMaxAmount() ---> " + transactiontype.getMaxAmount());

            //transactiontype.setMinAmount(rs.getString("MinAmount"));
            transType.setlMinAmount(rs.getLong("MinAmount"));
            //System.out.println("transactiontype.getMaxAmount() ---> " + transactiontype.getMaxAmount());

            //transactiontype.setMaxValueDate(rs.getString("MaxValueDate"));
            transType.setiMaxValueDate(rs.getInt("MaxValueDate"));
            //transactiontype.setMinValueDate(rs.getString("MinValueDate"));
            transType.setiMinValueDate(rs.getInt("MinValueDate"));
            transType.setMan1(rs.getString("Mandatory_1"));
            transType.setMan2(rs.getString("Mandatory_2"));
            transType.setMan3(rs.getString("Mandatory_3"));
            transType.setDesc(rs.getString("Description"));
            transType.setMinReturnDate(rs.getString("MinRtnDate"));
            transType.setMaxReturnDate(rs.getString("MaxRtnDate"));

            transType.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                transType.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            transType.setDesChargeAmount(new DecimalFormat("#0.00").format((new Long(rs.getLong("DesChargeAmount")).doubleValue()) / 100));
            transType.setOrgChargeAmount(new DecimalFormat("#0.00").format((new Long(rs.getLong("OrgChargeAmount")).doubleValue()) / 100));
            
            transType.setStatus(rs.getString("status"));

        }

        return transType;
    }

    static Collection<TransactionType> makeTransactionTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<TransactionType> result = new java.util.ArrayList();

        while (rs.next())
        {
            TransactionType transType = new TransactionType();

            transType.setTc(rs.getString("TC"));
            transType.setDesc(rs.getString("Description"));
            transType.setType(rs.getString("C/D"));
            //transactiontype.setMaxAmount(rs.getString("MaxAmount"));
            transType.setlMaxAmount(rs.getLong("MaxAmount"));
            //transactiontype.setMinAmount(rs.getString("MinAmount"));
            transType.setlMinAmount(rs.getLong("MinAmount"));
            //transactiontype.setMaxValueDate(rs.getString("MaxValueDate"));
            transType.setiMaxValueDate(rs.getInt("MaxValueDate"));
            //transactiontype.setMinValueDate(rs.getString("MinValueDate"));
            transType.setiMinValueDate(rs.getInt("MinValueDate"));
            transType.setMan1(rs.getString("Mandatory_1"));
            transType.setMan2(rs.getString("Mandatory_2"));
            transType.setMan3(rs.getString("Mandatory_3"));
            transType.setDesc(rs.getString("Description"));
            transType.setMinReturnDate(rs.getString("MinRtnDate"));
            transType.setMaxReturnDate(rs.getString("MaxRtnDate"));

            transType.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                transType.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            transType.setDesChargeAmount(new DecimalFormat("#0.00").format((new Long(rs.getLong("DesChargeAmount")).doubleValue()) / 100));
            transType.setOrgChargeAmount(new DecimalFormat("#0.00").format((new Long(rs.getLong("OrgChargeAmount")).doubleValue()) / 100));

            transType.setStatus(rs.getString("status"));
            
            result.add(transType);
        }

        return result;
    }
}

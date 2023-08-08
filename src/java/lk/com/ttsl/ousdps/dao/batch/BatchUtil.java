/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.batch;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collection;


import java.text.SimpleDateFormat;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;

/**
 *
 * @author Isanka
 */
public class BatchUtil
{

    public BatchUtil()
    {
    }
    static final SimpleDateFormat sdf_with_time = new SimpleDateFormat(
            "dd/MM/yyyy hh:mm:ss aa");

    public static Collection makeBatchCollection(ResultSet rs) throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {

            Batch batch = new Batch();

            batch.setBatchno(rs.getString("batchno"));
            batch.setPrebk(rs.getString("prebk"));
            batch.setPrebr(rs.getString("prebr"));
            batch.setType(rs.getString("type"));
            batch.setApplicationdate(rs.getString("applicationdate"));
            batch.setBatchcount(rs.getString("batchcount"));

            //batch.setBatchamount(rs.getString("batchamount"));

            batch.setBatchamountFormatted(rs.getString("batchamount"));

            // batch.setBatchamount(new DecimalFormat("#0.00").format((new Long(Long.parseLong(rs.getString("batchamount"))).doubleValue())/100));
            //batch.setTotalSum(totalSum);


            batch.setBatchamount(rs.getString("batchamount"));


            batch.setStatus(rs.getString("status"));
            batch.setDeliveryid(rs.getString("deliveryid"));

            if (rs.getTimestamp("time") != null)
            {
                batch.setTime(DateFormatter.doFormat(rs.getTimestamp("time").getTime(), "yyyy-MM-dd HH:mm:ss"));
            }

            batch.setErrorcode(rs.getString("errorcode"));
            batch.setBankName(rs.getString("ShortName"));
            batch.setBranchName(rs.getString("BranchName"));

            result.add(batch);

        }

        return result;
    }
}

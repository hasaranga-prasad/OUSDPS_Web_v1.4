/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.returnreason;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class ReturnReasonUtil
{

    static ReturnReason makeReturnReasonObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        ReturnReason returnReason = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            returnReason = new ReturnReason();

            returnReason.setReturnCode(rs.getString("RtnCode"));
            returnReason.setReturnReason(rs.getString("RtnReason"));
            returnReason.setPrintAS(rs.getString("PrintAS"));
            returnReason.setStatus(rs.getString("status"));
            returnReason.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                returnReason.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return returnReason;
    }

    static Collection<ReturnReason> makeReturnReasonObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<ReturnReason> result = new java.util.ArrayList();

        while (rs.next())
        {
            ReturnReason returnReason = new ReturnReason();

            returnReason.setReturnCode(rs.getString("RtnCode"));
            returnReason.setReturnReason(rs.getString("RtnReason"));
            returnReason.setPrintAS(rs.getString("PrintAS"));
            returnReason.setStatus(rs.getString("status"));
            returnReason.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                returnReason.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(returnReason);
        }

        return result;
    }
}

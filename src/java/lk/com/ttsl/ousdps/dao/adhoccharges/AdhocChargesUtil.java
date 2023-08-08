/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.adhoccharges;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class AdhocChargesUtil
{

    static AdhocCharges makeAdhocChargesTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        AdhocCharges ac = null;

        if (rs.isBeforeFirst())
        {
            ac = new AdhocCharges();

            rs.next();

            ac.setAdhocChargeCode(rs.getString("AdhocCode"));
            ac.setAdhocChargeDesc(rs.getString("Description"));
            ac.setlAmount(rs.getLong("Amount"));
            ac.setStatus(rs.getString("Status"));

            ac.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                ac.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ac.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                ac.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
        }

        return ac;
    }

    static Collection<AdhocCharges> makeAdhocChargesTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<AdhocCharges> result = new java.util.ArrayList();

        while (rs.next())
        {
            AdhocCharges ac = new AdhocCharges();

            ac.setAdhocChargeCode(rs.getString("AdhocCode"));
            ac.setAdhocChargeDesc(rs.getString("Description"));
            ac.setlAmount(rs.getLong("Amount"));
            ac.setStatus(rs.getString("Status"));

            ac.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                ac.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ac.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                ac.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(ac);
        }

        return result;
    }
}

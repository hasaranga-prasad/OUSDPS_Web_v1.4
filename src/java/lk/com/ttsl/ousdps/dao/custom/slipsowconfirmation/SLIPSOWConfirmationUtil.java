/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.slipsowconfirmation;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class SLIPSOWConfirmationUtil
{

    private SLIPSOWConfirmationUtil()
    {
    }

    public static SLIPSOWConfirmation makeOWConfirmationObject(ResultSet rs) throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        SLIPSOWConfirmation slipsowconfimation = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            
            slipsowconfimation = new SLIPSOWConfirmation();


            if (rs.getTimestamp("BusinessDate") != null)
            {
                slipsowconfimation.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }

            slipsowconfimation.setSession(rs.getString("Session"));
            slipsowconfimation.setOwBank(rs.getString("Bank"));
            slipsowconfimation.setOwBankShortName(rs.getString("ShortName"));
            slipsowconfimation.setOwBankFullName(rs.getString("FullName"));
            slipsowconfimation.setStatusId(rs.getString("Status"));
            slipsowconfimation.setStatusDesc(rs.getString("Description"));
            slipsowconfimation.setRemarks(rs.getString("Remarks"));
            slipsowconfimation.setConfirmedBy(rs.getString("ConfirmedBy"));

            if (rs.getTimestamp("ConfirmationTime") != null)
            {
                slipsowconfimation.setConfirmedTime(DateFormatter.doFormat(rs.getTimestamp("ConfirmationTime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return slipsowconfimation;
    }

    public static Collection makeOWConfirmationObjectsCollection(ResultSet rs) throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {
            SLIPSOWConfirmation slipsowconfimation = new SLIPSOWConfirmation();


            if (rs.getTimestamp("BusinessDate") != null)
            {
                slipsowconfimation.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }

            slipsowconfimation.setSession(rs.getString("Session"));
            slipsowconfimation.setOwBank(rs.getString("Bank"));
            slipsowconfimation.setOwBankShortName(rs.getString("ShortName"));
            slipsowconfimation.setOwBankFullName(rs.getString("FullName"));
            slipsowconfimation.setStatusId(rs.getString("Status"));
            slipsowconfimation.setStatusDesc(rs.getString("Description"));
            slipsowconfimation.setRemarks(rs.getString("Remarks"));
            slipsowconfimation.setConfirmedBy(rs.getString("ConfirmedBy"));

            if (rs.getTimestamp("ConfirmationTime") != null)
            {
                slipsowconfimation.setConfirmedTime(DateFormatter.doFormat(rs.getTimestamp("ConfirmationTime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(slipsowconfimation);
        }

        return result;
    }
}

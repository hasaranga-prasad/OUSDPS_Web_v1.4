/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.subpurposecode;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class SubPurposeCodeUtil
{

    static SubPurposeCode makeSubPurposeCodeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        SubPurposeCode prCode = null;

        if (rs.isBeforeFirst())
        {
            prCode = new SubPurposeCode();

            rs.next();

            prCode.setPurposeCode(rs.getString("purcd"));
            prCode.setSubPurposeCode(rs.getString("subpurcd"));
            prCode.setDescMain(rs.getString("mdesc"));
            prCode.setDesc(rs.getString("sdesc"));
            prCode.setStatus(rs.getString("status"));
            prCode.setModifiedBy(rs.getString("modifiedby"));

            if (rs.getString("modifieddate") != null)
            {
                prCode.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("modifieddate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
        }

        return prCode;
    }

    static Collection<SubPurposeCode> makeSubPurposeCodesObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<SubPurposeCode> result = new java.util.ArrayList();

        while (rs.next())
        {
            SubPurposeCode prCode = new SubPurposeCode();

            prCode.setPurposeCode(rs.getString("purcd"));
            prCode.setSubPurposeCode(rs.getString("subpurcd"));
            prCode.setDescMain(rs.getString("mdesc"));
            prCode.setDesc(rs.getString("sdesc"));
            prCode.setStatus(rs.getString("status"));
            prCode.setModifiedBy(rs.getString("modifiedby"));

            if (rs.getString("modifieddate") != null)
            {
                prCode.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("modifieddate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(prCode);
        }

        return result;
    }
}

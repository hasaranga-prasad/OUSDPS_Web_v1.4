/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.reportType;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class ReportTypeUtil
{
    static ReportType makeReportTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        ReportType rt = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            
            rt = new ReportType();

            rt.setType(rs.getString("ReprotType"));
            rt.setDescription(rs.getString("ReprotTypeDesc"));

        }

        return rt;
    }

    static Collection<ReportType> makeReportTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<ReportType> result = new java.util.ArrayList();

        while (rs.next())
        {
            ReportType rt = new ReportType();

            rt.setType(rs.getString("ReprotType"));
            rt.setDescription(rs.getString("ReprotTypeDesc"));

            result.add(rt);
        }

        return result;
    }
}

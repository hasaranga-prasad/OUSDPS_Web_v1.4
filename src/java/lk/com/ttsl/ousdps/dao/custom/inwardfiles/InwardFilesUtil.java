/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.inwardfiles;

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
public class InwardFilesUtil
{

    static String makeReportPathObject(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        String path = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            path = rs.getString("ReportPath");
        }

        return path;
    }

    static InwardFiles makeReportObject(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        InwardFiles report = null;

        while (rs.isBeforeFirst() && rs.next())
        {

            report = new InwardFiles();

            report.setReportName(rs.getString("ReportName"));
            report.setReportPath(rs.getString("ReportPath"));
            report.setReportType(rs.getString("ReportType"));
            report.setBank(rs.getString("BankCode"));
            report.setBankShortName(rs.getString("BankShortName"));
            report.setBankFullName(rs.getString("BankFullName"));

            report.setSubBank(rs.getString("SubBankCode"));
            report.setSubBankShortName(rs.getString("SubBankShortName"));
            report.setSubBankFullName(rs.getString("SubBankFullName"));

            if (rs.getTimestamp("BusinessDate") != null)
            {
                report.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }
            report.setSession(rs.getString("WindowSession"));
            report.setIsDownloadable(rs.getString("IsDownloadable"));

            if (rs.getTimestamp("CreatedTime") != null)
            {
                report.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            if (rs.getString("IsAlreadyDownloaded") == null)
            {
                report.setIsAlreadyDownloaded(LCPL_Constants.status_no);
            }
            else
            {
                report.setIsAlreadyDownloaded(rs.getString("IsAlreadyDownloaded"));
            }

            report.setDownloadedBy(rs.getString("DownloadedBy"));

            if (rs.getTimestamp("DownloadedTime") != null)
            {
                report.setDownloadedTime(DateFormatter.doFormat(rs.getTimestamp("DownloadedTime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }


        }
        return report;
    }

    static Collection makeReportObjectCollection(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {
            InwardFiles report = new InwardFiles();

            report.setReportName(rs.getString("ReportName"));
            report.setReportPath(rs.getString("ReportPath"));
            report.setReportType(rs.getString("ReportType"));
            report.setBank(rs.getString("BankCode"));
            report.setBankShortName(rs.getString("BankShortName"));
            report.setBankFullName(rs.getString("BankFullName"));

            report.setSubBank(rs.getString("SubBankCode"));
            report.setSubBankShortName(rs.getString("SubBankShortName"));
            report.setSubBankFullName(rs.getString("SubBankFullName"));

            report.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            report.setSession(rs.getString("WindowSession"));
            report.setIsDownloadable(rs.getString("IsDownloadable"));
            report.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));

            if (rs.getString("IsAlreadyDownloaded") == null)
            {
                report.setIsAlreadyDownloaded(LCPL_Constants.status_no);
            }
            else
            {
                report.setIsAlreadyDownloaded(rs.getString("IsAlreadyDownloaded"));
            }

            report.setDownloadedBy(rs.getString("DownloadedBy"));

            if (rs.getTimestamp("DownloadedTime") != null)
            {
                report.setDownloadedTime(DateFormatter.doFormat(rs.getTimestamp("DownloadedTime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(report);
        }
        return result;
    }
}

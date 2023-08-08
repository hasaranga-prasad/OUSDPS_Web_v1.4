/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.report;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import java.util.Vector;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class ReportDAOImpl implements ReportDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public File getFile(String reportName, String okToDownload)
    {
        File file = null;
        String path = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (reportName == null)
        {
            System.out.println("WARNING : Null reportName parameter.");
            return file;
        }

        if (okToDownload == null)
        {
            System.out.println("WARNING : Null okToDownload parameter.");
            return file;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ReportPath from ");
            sbQuery.append(LCPL_Constants.tbl_report + " ");
            sbQuery.append("where ReportName = ? ");

            if (!okToDownload.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and IsDownloadable = ? ");
            }

            //System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, reportName);

            if (!okToDownload.equals(LCPL_Constants.status_all))
            {
                pstm.setString(2, okToDownload);
            }

            rs = pstm.executeQuery();

            path = ReportUtil.makeReportPathObject(rs);

            if (path != null)
            {
                file = new File(path);

                if (!file.exists())
                {
                    file = null;
                }
            }
        }
        catch (Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return file;
    }

    public Report getReportDetails(String reportName, String type, String okToDownload)
    {
        Report report = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        //System.out.println("reportName : " + reportName);
        //System.out.println("type : " + type);
        //System.out.println("okToDownload : " + okToDownload);

        if (reportName == null)
        {
            System.out.println("WARNING : Null reportName parameter.");
            return report;
        }
        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return report;
        }
        if (okToDownload == null)
        {
            System.out.println("WARNING : Null okToDownload parameter.");
            return report;
        }


        try
        {
            Vector<Integer> vt = new Vector();

            int val_reportName = 1;
            int val_type = 2;
            int val_okToDownload = 3;


            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select rp.ReportName, rp.ReportPath, rp.ReportType, rpt.ReprotTypeDesc, rp.BankCode, "
                    + "ba.ShortName as BankShortName, ba.FullName as BankFullName, "
                    + "IFNULL(rp.SubBankCode, 'N/A') as SubBankCode, sb.ShortName as SubBankShortName, sb.FullName as SubBankFullName, "
                    + "rp.BusinessDate, "
                    + "rp.session as WindowSession, rp.IsDownloadable, "
                    + "rp.CreatedTime, rp.IsAlreadyDownloaded, rp.DownloadedBy, rp.DownloadedTime from ");

            sbQuery.append(LCPL_Constants.tbl_report + " rp, ");
            sbQuery.append(LCPL_Constants.tbl_report_type + " rpt, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " sb ");
            //sbQuery.append(LCPL_Constants.tbl_branch + "  br ");

            sbQuery.append("where rp.BankCode = ba.BankCode ");
            sbQuery.append("and IFNULL(rp.SubBankCode, '9999') = sb.BankCode ");
            sbQuery.append("and rp.ReportType = rpt.ReprotType ");
            //sbQuery.append("and rp.BranchCode = br.BranchCode ");

            if (!reportName.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.ReportName = ? ");
                vt.add(val_reportName);
            }

            if (!okToDownload.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.IsDownloadable = ? ");
                vt.add(val_okToDownload);
            }
            if (!type.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.ReportType = ? ");
                vt.add(val_type);
            }

            //System.out.println("sbQuery : " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, reportName);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, type);
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, okToDownload);
                    i++;
                }

            }

            rs = pstm.executeQuery();
            
            //System.out.println("rs ---> " + rs);
            
            report = ReportUtil.makeReportObject(rs);
            
            
        }
        catch (Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return report;
    }

    public Collection<Report> getReportDetails(String bankCode, String branchCode, String session, String type, String status, String fromBusinessDate, String toBusinessDate)
    {
        Collection<Report> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
//        if (branchCode == null)
//        {
//            System.out.println("WARNING : Null branchCode parameter.");
//            return col;
//        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return col;
        }
        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (fromBusinessDate == null)
        {
            System.out.println("WARNING : Null fromBusinessDate parameter.");
            return col;
        }
        if (toBusinessDate == null)
        {
            System.out.println("WARNING : Null toBusinessDate parameter.");
            return col;
        }

        try
        {
            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_Session = 2;
            int val_Status = 3;
            int val_Type = 4;
            int val_fromBusinessDate = 5;
            int val_toBusinessDate = 6;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select rp.ReportName, rp.ReportPath, rp.ReportType, rpt.ReprotTypeDesc, rp.BankCode, "
                    + "ba.ShortName as BankShortName, ba.FullName as BankFullName, "
                    + "IFNULL(rp.SubBankCode, 'N/A') as SubBankCode, sb.ShortName as SubBankShortName, sb.FullName as SubBankFullName, "
                    + "rp.BusinessDate, "
                    + "rp.session as WindowSession, rp.IsDownloadable, "
                    + "rp.CreatedTime, rp.IsAlreadyDownloaded, rp.DownloadedBy, rp.DownloadedTime from ");

            sbQuery.append(LCPL_Constants.tbl_report + " rp, ");
            sbQuery.append(LCPL_Constants.tbl_report_type + " rpt, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " sb ");
            //sbQuery.append(LCPL_Constants.tbl_branch + "  br ");

            sbQuery.append("where rp.BankCode = ba.BankCode ");
            sbQuery.append("and IFNULL(rp.SubBankCode, '9999') = sb.BankCode ");
            sbQuery.append("and rp.ReportType = rpt.ReprotType ");
            //sbQuery.append("and rp.BranchCode = br.BranchCode ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.BankCode = ? ");
                vt.add(val_bankCode);
            }
//            if (!branchCode.equals(LCPL_Constants.status_all))
//            {
//                sbQuery.append("and rp.BranchCode = ?  ");
//                vt.add(val_branchCode);
//            }
            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.session = ? ");
                vt.add(val_Session);
            }
            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.IsDownloadable = ? ");
                vt.add(val_Status);
            }
            if (!type.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.ReportType = ? ");
                vt.add(val_Type);
            }
            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.BusinessDate >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.BusinessDate <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toBusinessDate);
            }

            //System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, session);
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == 4)
                {
                    pstm.setString(i, type);
                    i++;
                }
                if (val_item == 5)
                {
                    pstm.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == 6)
                {
                    pstm.setString(i, toBusinessDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();
            col = ReportUtil.makeReportObjectCollection(rs);
        }
        catch (Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    public boolean updateDownloadDetails(String reportName, String downloadedBy)
    {

        if (reportName == null)
        {
            System.out.println("WARNING : Null reportName parameter.");
            return false;
        }
        if (downloadedBy == null)
        {
            System.out.println("WARNING : Null downloadedBy parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_report + " ");
            sbQuery.append("set IsAlreadyDownloaded = ?, DownloadedBy = ?, DownloadedTime = NOW() ");
            sbQuery.append("where ReportName = ? ");

            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, LCPL_Constants.status_yes);
            psmt.setString(2, downloadedBy);
            psmt.setString(3, reportName);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                con.rollback();
            }
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    public boolean isSubBankReportAvailable(String bankCode, String branchCode, String session, String type, String status, String fromBusinessDate, String toBusinessDate)
    {
        //System.out.println("inside isSubBankReportAvailable ---> ");

        boolean isAvailable = false;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return isAvailable;
        }
//        if (branchCode == null)
//        {
//            System.out.println("WARNING : Null branchCode parameter.");
//            return col;
//        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return isAvailable;
        }
        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return isAvailable;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return isAvailable;
        }

        if (fromBusinessDate == null)
        {
            System.out.println("WARNING : Null fromBusinessDate parameter.");
            return isAvailable;
        }
        if (toBusinessDate == null)
        {
            System.out.println("WARNING : Null toBusinessDate parameter.");
            return isAvailable;
        }

        try
        {
            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            //int val_branchCode = 2;
            int val_Session = 3;
            int val_Status = 4;
            int val_Type = 5;
            int val_fromBusinessDate = 6;
            int val_toBusinessDate = 7;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select * from ");

            sbQuery.append(LCPL_Constants.tbl_report + " rp ");
            sbQuery.append("where rp.SubBankCode is not null ");


            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.BankCode = ? ");
                vt.add(val_bankCode);
            }
            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.session = ? ");
                vt.add(val_Session);
            }
            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.IsDownloadable = ? ");
                vt.add(val_Status);
            }
            if (!type.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.ReportType = ? ");
                vt.add(val_Type);
            }
            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.BusinessDate >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and rp.BusinessDate <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toBusinessDate);
            }

            //System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, branchCode);
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, session);
                    i++;
                }
                if (val_item == 4)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == 5)
                {
                    pstm.setString(i, type);
                    i++;
                }
                if (val_item == 6)
                {
                    pstm.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == 7)
                {
                    pstm.setString(i, toBusinessDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                isAvailable = true;
            }
        }
        catch (Exception e)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isAvailable;
    }
}

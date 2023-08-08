/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.report;

import java.io.File;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ReportDAO
{

    public File getFile(String reportName, String okToDownload);

    public Report getReportDetails(String reportName, String type, String okToDownload);

    public Collection<Report> getReportDetails(String bankCode, String branchCode, String session, String type, String status,
            String fromBusinessDate, String toBusinessDate);
    
    public boolean isSubBankReportAvailable(String bankCode, String branchCode, String session, String type, String status,
            String fromBusinessDate, String toBusinessDate);
    
    public boolean updateDownloadDetails(String reportName, String downloadedBy);
}

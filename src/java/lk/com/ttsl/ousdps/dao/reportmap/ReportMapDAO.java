/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.reportmap;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ReportMapDAO
{

    public Collection<ReportMap> getReportMapDetails(String srcBankCode, String desBankCode, String session, String status);

    public boolean addReportMap(ReportMap rMap);

    public boolean updateReportMap(ReportMap rMap);    

    public String getMsg();
}

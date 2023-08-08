/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.reportType;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ReportTypeDAO
{
    public ReportType getReprtType(String type);

    public Collection<ReportType> getReportTypes();
}

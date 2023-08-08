/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.archivalowdetails;

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
public class ArchivalOWDetailsDAOUtil
{

    public static Collection<ArchivalOWDetails> makeOWDetailsObjectCollection(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {

            ArchivalOWDetails details = new ArchivalOWDetails();

            details.setFileId(rs.getString("fileid"));
            details.setRefId(rs.getString("RefID"));
            details.setOwBank(rs.getString("bank"));
            details.setOwBranch(rs.getString("branch"));

            if (rs.getTimestamp("BusinessDate") != null)
            {
                details.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }
            if (rs.getTimestamp("ValueDate") != null)
            {
                details.setValueDate(DateFormatter.doFormat(rs.getTimestamp("ValueDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd));
            }

            details.setSession(rs.getString("WindowSession"));
            
            details.setStatus(rs.getString("status"));
            details.setStatusDesc(rs.getString("StatusDesc"));
            
            details.setTc(rs.getString("tc"));
            details.setRc(rs.getString("rc"));
            details.setCurrencyCode(rs.getString("curid"));
            details.setPurposeCode(rs.getString("purposecd"));
            details.setSubpurposeCode(rs.getString("subpurposecd"));

            details.setOrgBankCode(rs.getString("orgbankcode"));
            details.setOrgBranchCode(rs.getString("orgbranchcode"));
            details.setOrgAcNo(rs.getString("orgacno"));
            details.setOrgAcType(rs.getString("orgactype"));
            details.setOrgAcTypeDesc(rs.getString("orgAcTypeDesc"));
            details.setOrgAcName(rs.getString("orgacname"));
            details.setOrgAcNoDec(rs.getString("orgacnoDec"));
            details.setOrgAcNameDec(rs.getString("orgacnameDec"));

            details.setDesBankCode(rs.getString("desbankcode"));
            details.setDesBranchcode(rs.getString("desbranchcode"));
            details.setDesAcNo(rs.getString("desacno"));
            details.setDesAcType(rs.getString("desactype"));
            details.setDesAcTypeDesc(rs.getString("desAcTypeDesc"));
            details.setDesAcName(rs.getString("desacname"));
            details.setDesAcNoDec(rs.getString("desacnoDec"));
            details.setDesAcNameDec(rs.getString("desacnameDec"));

            if (rs.getString("cdate") != null)
            {
                if (rs.getString("cdate").equals(LCPL_Constants.default_original_return_date))
                {
                    details.setCurrentDate(LCPL_Constants.msg_not_available);
                }
                else
                {
                    details.setCurrentDate(rs.getString("cdate"));
                }
            }

            details.setAmountEnc(rs.getString("amount"));

            if (rs.getString("amountDec") != null)
            {
                try
                {
                    details.setAmount(Long.parseLong(rs.getString("amountDec")));
                }
                catch (Exception e)
                {
                    details.setAmount(-1);
                    System.out.println("OWDetailsDAOUtil : Long.parseLong Error --> " + e.getMessage());
                }
            }

            
            details.setParticulars(rs.getString("particulars"));
            details.setInstruction(rs.getString("instruction"));

            if (rs.getTimestamp("inwardtime") != null)
            {
                details.setInwardtime(DateFormatter.doFormat(rs.getTimestamp("inwardtime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            if (rs.getTimestamp("setlementtime") != null)
            {
                details.setInwardtime(DateFormatter.doFormat(rs.getTimestamp("setlementtime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            details.setIsReturn(rs.getString("IsReturn"));

            result.add(details);
        }
        return result;
    }
}

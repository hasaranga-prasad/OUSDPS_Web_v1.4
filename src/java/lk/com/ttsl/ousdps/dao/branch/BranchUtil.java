/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.branch;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 * 
 * @author Dinesh
 */
public class BranchUtil
{

    private BranchUtil()
    {
    }

    static Branch makeBranchObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Branch branch = null;

        if (rs.isBeforeFirst())
        {
            branch = new Branch();

            rs.next();

            branch.setBranchCode(rs.getString("BranchCode"));
            branch.setBranchName(rs.getString("BranchName"));
            branch.setBankCode(rs.getString("BankCode"));
            branch.setBankShortName(rs.getString("ShortName"));
            branch.setBankFullName(rs.getString("FullName"));
            branch.setStatus(rs.getString("BranchStatus"));
            branch.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                branch.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return branch;
    }

    static Collection<Branch> makeBranchObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Branch> result = new java.util.ArrayList();

        while (rs.next())
        {
            Branch branch = new Branch();

            branch.setBranchCode(rs.getString("BranchCode"));
            branch.setBranchName(rs.getString("BranchName"));
            branch.setBankCode(rs.getString("BankCode"));
            branch.setBankShortName(rs.getString("ShortName"));
            branch.setBankFullName(rs.getString("FullName"));
            branch.setStatus(rs.getString("BranchStatus"));
            branch.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                branch.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(branch);
        }

        return result;
    }
}

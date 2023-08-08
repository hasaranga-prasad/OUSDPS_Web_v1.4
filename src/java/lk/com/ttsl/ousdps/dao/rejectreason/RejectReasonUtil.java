/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.rejectreason;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class RejectReasonUtil
{

    static RejectReason makeRejectReasonObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        RejectReason rejectReason = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            rejectReason = new RejectReason();

            rejectReason.setRejectCode(rs.getString("RJCode"));
            rejectReason.setRejectReason(rs.getString("RJReason"));
            rejectReason.setDescription(rs.getString("Description"));
            rejectReason.setHtmlDescription(rs.getString("HtmlDescription"));
        }

        return rejectReason;
    }

    static Collection<RejectReason> makeRejectReasonObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<RejectReason> result = new java.util.ArrayList();

        while (rs.next())
        {
            RejectReason rejectReason = new RejectReason();

            rejectReason.setRejectCode(rs.getString("RJCode"));
            rejectReason.setRejectReason(rs.getString("RJReason"));
            rejectReason.setDescription(rs.getString("Description"));
            rejectReason.setHtmlDescription(rs.getString("HtmlDescription"));

            result.add(rejectReason);
        }

        return result;
    }
}

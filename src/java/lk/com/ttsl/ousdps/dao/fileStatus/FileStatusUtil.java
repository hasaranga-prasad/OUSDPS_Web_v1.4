/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.fileStatus;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class FileStatusUtil
{

    static FileStatus makeFileStatusObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        FileStatus status = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            status = new FileStatus();

            status.setStatusId(rs.getString("StatusId"));
            status.setDescription(rs.getString("StatusDesc"));
        }

        return status;
    }

    static Collection<FileStatus> makeFileStatusObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<FileStatus> result = new java.util.ArrayList();

        while (rs.next())
        {
            FileStatus status = new FileStatus();

            status.setStatusId(rs.getString("StatusId"));
            status.setDescription(rs.getString("StatusDesc"));

            result.add(status);
        }

        return result;
    }
}

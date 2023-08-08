/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.fileStatus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class FileStatusDAOImpl implements FileStatusDAO
{
    
    String msg = null;
    
    public String getMsg()
    {
        return msg;
    }
    
    public FileStatus getFileStatus(String id)
    {
        FileStatus fs = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        if (id == null)
        {
            System.out.println("WARNING : Null id parameter.");
            return fs;
        }
        
        try
        {
            con = DBUtil.getInstance().getConnection();
            
            StringBuilder sbQuery = new StringBuilder();
            
            sbQuery.append("select StatusId, StatusDesc from ");
            sbQuery.append(LCPL_Constants.tbl_status + " ");
            sbQuery.append("where StatusId = ?  ");
            
            
            pstm = con.prepareStatement(sbQuery.toString());
            
            pstm.setString(1, id);
            
            rs = pstm.executeQuery();
            
            fs = FileStatusUtil.makeFileStatusObject(rs);
            
            if (fs == null)
            {
                msg = LCPL_Constants.msg_no_records;
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
        
        return fs;
    }
    
    public Collection<FileStatus> getFileStatusDetails()
    {
        Collection<FileStatus> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try
        {
            con = DBUtil.getInstance().getConnection();
            
            StringBuilder sbQuery = new StringBuilder();
            
            sbQuery.append("select StatusId, StatusDesc from ");
            sbQuery.append(LCPL_Constants.tbl_status);
            pstm = con.prepareStatement(sbQuery.toString());
            
            rs = pstm.executeQuery();
            
            col = FileStatusUtil.makeFileStatusObjectsCollection(rs);
            
            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
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
        
        return col;
    }
}

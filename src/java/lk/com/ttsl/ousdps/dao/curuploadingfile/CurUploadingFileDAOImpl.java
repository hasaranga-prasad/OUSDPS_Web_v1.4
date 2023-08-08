/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.curuploadingfile;

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
public class CurUploadingFileDAOImpl implements CurUploadingFileDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<CurUploadingFile> getCurUploadingFileDetails()
    {
        
        Collection<CurUploadingFile> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT cf.bank, b.ShortName, b.FullName, cf.fileid, cf.starttime FROM ");
            sbQuery.append(LCPL_Constants.tbl_bank + " b, ");
            sbQuery.append(LCPL_Constants.tbl_curuploadingfile + " cf ");
            sbQuery.append("WHERE b.BankCode = cf.bank  ");
            sbQuery.append("order by bank  ");

            pstm = con.prepareStatement(sbQuery.toString());
            
            rs = pstm.executeQuery();

            col = CurUploadingFileUtil.makeCurUploadingFileObjectsCollection(rs);

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

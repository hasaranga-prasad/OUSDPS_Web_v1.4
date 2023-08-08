/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.message.priority;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;
import lk.com.ttsl.ousdps.dao.DAOFactory;

/**
 *
 * @author Dinesh
 */
public class MsgPriorityDAOImpl implements MsgPriorityDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public MsgPriority getPriority(String id)
    {
        MsgPriority msgPriority = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        System.out.println("getPriority id -------> " + id);

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT Level, Description FROM ");
            sbQuery.append(LCPL_Constants.tbl_messagepriority + " ");
            sbQuery.append("where Level = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, id);

            rs = pstm.executeQuery();

            msgPriority = MsgPriorityUtil.makeMsgPriorityObject(rs);

            if (msgPriority == null)
            {
                msg = LCPL_Constants.msg_no_records;
            }
            else
            {
                System.out.println("msgPriority not null ---> " + msgPriority.getPriorityDesc());
            
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

        return msgPriority;
    }

    public Collection<MsgPriority> getPriorityDetails()
    {
        Collection<MsgPriority> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT Level, Description FROM ");
            sbQuery.append(LCPL_Constants.tbl_messagepriority + " ");
            sbQuery.append("ORDER BY Level");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = MsgPriorityUtil.makeMsgPriorityObjectsCollection(rs);

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

//    public static void main(String[] args)
//    {
//        Collection<MsgPriority> colMsgPriority = DAOFactory.getMsgPriorityDAO().getPriorityDetails();
//        
//        for(MsgPriority msgPriority : colMsgPriority)
//        {
//            System.out.println("priority level - " + msgPriority.getPriorityLevel() + "  desc - " + msgPriority.getPriorityDesc());
//        }
//    }
}

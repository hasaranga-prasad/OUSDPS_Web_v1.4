/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.file;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import java.util.Vector;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class FileInfoDAOImpl implements FileInfoDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<FileInfo> getFileDetailsByCriteria(String bankCode, String status, String session, String fromBusinessDate, String toBusinessDate)
    {
        Collection<FileInfo> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return col;
        }
        if (fromBusinessDate == null)
        {
            System.out.println("WARNING : Null fromBusinessDate parameter.");
            return col;
        }
        if (toBusinessDate == null)
        {
            System.out.println("WARNING : Null toBusinessDate parameter.");
            return col;
        }


        try
        {

            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_Status = 2;
            int val_Session = 3;
            int val_fromBusinessDate = 4;
            int val_toBusinessDate = 5;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select sf.fileid, sf.bank, ba.ShortName as BankShortName, "
                    + "ba.FullName as BankFullName, "
                    + "str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, "
                    + "sf.session as WindowSession, sf.status, st.StatusDesc, "
                    + "sf.orgnooftransaction, sf.orgtotalAmount, sf.rejnooftransaction, "
                    + "sf.rejtotalAmount, sf.processtime from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_status + " st, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba ");

            sbQuery.append("where sf.bank = ba.BankCode ");
            sbQuery.append("and sf.status = st.StatusId ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.bank = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.status = ? ");
                vt.add(val_Status);
            }
            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.session = ? ");
                vt.add(val_Session);
            }

            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sf.bdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sf.bdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toBusinessDate);
            }

            //System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, session);
                    i++;
                }
                if (val_item == 4)
                {
                    pstm.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == 5)
                {
                    pstm.setString(i, toBusinessDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();
            col = FileInfoUtil.makeFileObjectsCollection(rs);
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

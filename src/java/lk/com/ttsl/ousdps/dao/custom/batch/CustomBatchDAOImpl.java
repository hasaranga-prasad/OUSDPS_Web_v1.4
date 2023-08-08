/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.batch;

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
public class CustomBatchDAOImpl implements CustomBatchDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<CustomBatch> getBatchDetails(String bankCode, String branchCode,
            String session, String fromBusinessDate,
            String toBusinessDate)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
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
            int val_branchCode = 2;
            int val_Session = 3;
            int val_fromBusinessDate = 4;
            int val_toBusinessDate = 5;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select sf.fileid,  sb.bank, ba.ShortName as BankShortName, "
                    + "ba.FullName as BankFullName, sb.branch, br.BranchName, "
                    + "str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, "
                    + "sf.session as WindowSession, sb.citem, sb.ctotal from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_slipbatch + " sb, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " ba, ");
            sbQuery.append(LCPL_Constants.tbl_branch + "  br ");
            sbQuery.append("where sf.fileid = sb.fileid ");
            sbQuery.append("and sb.bank = ba.BankCode ");
            sbQuery.append("and sb.bank = br.BankCode ");
            sbQuery.append("and sb.branch = br.BranchCode ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sb.bank = ? ");
                vt.add(val_bankCode);
            }
            if (!branchCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sb.branch = ? ");
                vt.add(val_branchCode);
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

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    psmt.setString(i, branchCode);
                    i++;
                }
                if (val_item == 3)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == 4)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == 5)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
            }

            rs = psmt.executeQuery();
            
            col = CustomBatchUtil.makeBatchCollection(rs);
            
            

        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }
}

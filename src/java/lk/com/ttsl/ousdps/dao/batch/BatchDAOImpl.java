/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.batch;

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
public class BatchDAOImpl implements BatchDAO
{

    /**
     * @return Collection <Batch> for current business date
     */
    public Collection<Batch> getBatchDetails(String bankCode, String branchCode,
            String transactionType, String batchStatus, String businessDate)
    {


        Collection col_batch = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {

            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_branchCode = 2;
            int val_transactionType = 3;
            int val_batchStatus = 4;
            int val_businessDate = 5;
            // int val_toBusinessDate = 6;


            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();


            sbQuery.append("select ba.batchno,ba.prebk, bk.ShortName,");
            sbQuery.append("ba.prebr,br.BranchName,ba.type,ba.applicationdate,ba.batchcount,");
            sbQuery.append("ba.batchamount,ba.deliveryid,ba.time,");
            sbQuery.append("rp.replydescription as errorcode,st.description as status from ");
            sbQuery.append(LCPL_Constants.tbl_batch + " ba,");
            sbQuery.append(LCPL_Constants.tbl_bank + " bk,");
            sbQuery.append(LCPL_Constants.tbl_branch + " br,");
            sbQuery.append(LCPL_Constants.tbl_status + " st,");
            sbQuery.append(LCPL_Constants.tbl_reply + " rp ");
            sbQuery.append(" where bk.BankCode =  ba.prebk ");
            sbQuery.append("and ba.prebr =  br.BranchCode ");
            sbQuery.append("and	 bk.BankCode = br.BankCode ");
            sbQuery.append("and	 ba.status = st.statusid ");
            sbQuery.append("and	 ba.replycode = rp.replycode ");
            sbQuery.append("and ba.prebk = ? ");
            sbQuery.append("and ba.applicationdate = ? ");

            int i = 0;

            if(!branchCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.prebr = ? ");
                vt.add(val_branchCode);
                //System.out.println("2");
            }
            if(!transactionType.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.type = ? ");
                vt.add(val_transactionType);
                //System.out.println("3");
            }
            if(!batchStatus.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.status = ? ");
                vt.add(val_batchStatus);
                //System.out.println("4");
            }

            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bankCode);
            psmt.setString(2, businessDate);

            for(int val_item : vt)
            {
//                if(val_item == 1)
//                {
//                    psmt.setString(i, bankCode);
//                    i++;
//                }
                if(val_item == 2)
                {
                    psmt.setString(i, branchCode);
                    i++;
                }
                if(val_item == 3)
                {
                    psmt.setString(i, transactionType);
                    i++;
                }
                if(val_item == 4)
                {
                    psmt.setString(i, batchStatus);
                    i++;
                }
//                if(val_item == 5)
//                {
//                    psmt.setString(i, businessDate);
//                    i++;
//                }


            }

            rs = psmt.executeQuery();

            col_batch = BatchUtil.makeBatchCollection(rs);

            //System.out.println("col_batch" + col_batch.size());

            if(col_batch.isEmpty())
            {
                String msg = LCPL_Constants.msg_no_records;
            }

        }
        catch(Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return col_batch;
    }

    public Collection<Batch> getBatchDetails(String bankCode, String branchCode,
            String transactionType, String batchStatus)
    {

        Collection col_batch = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ba.batchno,ba.prebk, bk.ShortName,");
            sbQuery.append("ba.prebr,br.BranchName,ba.type,ba.applicationdate,ba.batchcount,");
            sbQuery.append("ba.batchamount,ba.deliveryid,ba.time,");
            //sbQuery.append("ba.batchamount,ba.deliveryid,ba.time,");
            sbQuery.append("ba.replycode as errorcode,ba.status from ");
            sbQuery.append(LCPL_Constants.tbl_batch + " ba,");
            sbQuery.append(LCPL_Constants.tbl_bank + " bk,");
            sbQuery.append(LCPL_Constants.tbl_branch + " br ");
            sbQuery.append("where bk.BankCode =  ba.prebk ");
            sbQuery.append("and ba.prebr =  br.BranchCode ");
            sbQuery.append("and	 bk.BankCode =br.BankCode ");

            int i = 0;

            if(!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.prebk = ? ");
                i = i + 1;
            }

            if(!branchCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.prebr = ? ");
                i = i + 2;
            }

            if(!transactionType.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.type = ? ");
                i = i + 4;
            }

            if(!batchStatus.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.status = ? ");
                i = i + 8;
            }

            //  sbQuery.append("and ba.applicationdate= ?");

            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());


            switch(i)
            {
                case 1:
                    psmt.setString(1, bankCode);
                    break;
                case 2:
                    psmt.setString(1, branchCode);
                    break;
                case 3:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, branchCode);
                    break;
                case 4:
                    psmt.setString(1, transactionType);
                    break;
                case 5:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, transactionType);
                    break;
                case 6:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, transactionType);
                    break;
                case 7:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, branchCode);
                    psmt.setString(3, transactionType);
                    break;

                case 8:
                    psmt.setString(1, batchStatus);
                    break;

                case 9:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, batchStatus);
                    break;

                case 10:
                    psmt.setString(1, branchCode);
                    psmt.setString(2, batchStatus);
                    break;

                case 11:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, branchCode);
                    psmt.setString(3, batchStatus);
                    break;

                case 12:
                    psmt.setString(1, transactionType);
                    psmt.setString(2, batchStatus);
                    break;

                case 13:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, transactionType);
                    psmt.setString(3, batchStatus);
                    break;

                case 14:
                    psmt.setString(1, branchCode);
                    psmt.setString(2, transactionType);
                    psmt.setString(3, batchStatus);
                    break;

                case 15:
                    psmt.setString(1, bankCode);
                    psmt.setString(2, branchCode);
                    psmt.setString(3, transactionType);
                    psmt.setString(4, batchStatus);
                    break;
            }



            rs = psmt.executeQuery();

            col_batch = BatchUtil.makeBatchCollection(rs);

            if(col_batch.isEmpty())
            {
                String msg = LCPL_Constants.msg_no_records;
            }
            // System.out.println("44444");
            //  System.out.println("col_batch - "+col_batch.size());
        }
        catch(Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return col_batch;
    }

    /**
     * @param bankCode 
     * @param transactionType
     * @param branchCode
     * @param batchStatus
     * @param toBusinessDate
     * @param fromBusinessDate
     * @return Collection <Batch> for given date range
     */
    public Collection<Batch> getBatchDetails(String bankCode, String branchCode,
            String transactionType, String batchStatus,
            String fromBusinessDate, String toBusinessDate)
    {

        Collection col_batch = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        // System.out.println("from" +fromBusinessDate);
        try
        {

            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_branchCode = 2;
            int val_transactionType = 3;
            int val_batchStatus = 4;
            int val_fromBusinessDate = 5;
            int val_toBusinessDate = 6;


            /*
            int val_presentingBank = 1;
            int val_presentingSB = 2;
            int val_presentingBranch = 3;
            int val_transactionType = 4;
            int val_batchStatus = 5;
            int val_fromBusinessDate = 6;
            int val_toBusinessDate = 7;
             */


            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ba.batchno,ba.prebk, bk.ShortName,");
            sbQuery.append("ba.prebr,br.BranchName,ba.type,ba.applicationdate,ba.batchcount,");
            sbQuery.append("ba.batchamount,ba.deliveryid,ba.time,");
            sbQuery.append("rp.replydescription as errorcode,st.description as status from ");
            sbQuery.append(LCPL_Constants.tbl_batch + " ba,");
            sbQuery.append(LCPL_Constants.tbl_bank + " bk,");
            sbQuery.append(LCPL_Constants.tbl_branch + " br,");
            sbQuery.append(LCPL_Constants.tbl_status + " st,");
            sbQuery.append(LCPL_Constants.tbl_reply + " rp ");
            sbQuery.append(" where bk.BankCode =  ba.prebk ");
            sbQuery.append("and ba.prebr =  br.BranchCode ");
            sbQuery.append("and	 bk.BankCode =br.BankCode ");
            sbQuery.append("and	 ba.status =st.statusid ");
            sbQuery.append("and	 ba.replycode =rp.replycode ");

            if(!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.prebk = ? ");
                vt.add(val_bankCode);
            }
            if(!branchCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.prebr = ? ");
                vt.add(val_branchCode);
            }
            if(!transactionType.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.type = ? ");
                vt.add(val_transactionType);
            }
            if(!batchStatus.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.status = ? ");
                vt.add(val_batchStatus);
            }
            if(!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and ba.applicationdate >= DATE_FORMAT(date(?),'%Y%m%d') ");
                vt.add(val_fromBusinessDate);
            }
            if(!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("AND ba.applicationdate <= DATE_FORMAT(date(?),'%Y%m%d') ");
                vt.add(val_toBusinessDate);
            }
            
            //System.out.println(sbQuery.toString());
            
            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for(int val_item : vt)
            {
                if(val_item == 1)
                {
                    psmt.setString(i, bankCode);
                    i++;
                }
                if(val_item == 2)
                {
                    psmt.setString(i, branchCode);
                    i++;
                }
                if(val_item == 3)
                {
                    psmt.setString(i, transactionType);
                    i++;
                }
                if(val_item == 4)
                {
                    psmt.setString(i, batchStatus);
                    i++;
                }
                if(val_item == 5)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if(val_item == 6)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }

            }
            rs = psmt.executeQuery();

            col_batch = BatchUtil.makeBatchCollection(rs);

        }
        catch(Exception e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col_batch;
    }

}


/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.slipsowconfirmation;

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
public class SLIPSOWConfirmationDAOImpl implements SLIPSOWConfirmationDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public SLIPSOWConfirmation getConfirmationDetail(String bankCode, String businessDate, String session)
    {
        SLIPSOWConfirmation slipsowconfirmation = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return slipsowconfirmation;
        }

        if (businessDate == null)
        {
            System.out.println("WARNING : Null businessDate parameter.");
            return slipsowconfirmation;
        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return slipsowconfirmation;
        }

        try
        {

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select s.BusinessDate, s.Session, s.Bank, b.ShortName, b.FullName, s.Status, c.Description, s.Remarks, s.ConfirmedBy, s.ConfirmationTime from ");
            sbQuery.append(LCPL_Constants.tbl_slipowconfirmation + " s, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " b, ");
            sbQuery.append(LCPL_Constants.tbl_confirmstatus + "  c ");
            sbQuery.append("where s.Bank = b.BankCode ");
            sbQuery.append("and s.Status = c.ID ");
            sbQuery.append("and s.BusinessDate = str_to_date(REPLACE(?, '-', '') ,'%Y%m%d') ");
            sbQuery.append("and s.Session = ? ");
            sbQuery.append("and s.Bank = ? ");

            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, businessDate);
            psmt.setString(2, session);
            psmt.setString(3, bankCode);

            rs = psmt.executeQuery();
            slipsowconfirmation = SLIPSOWConfirmationUtil.makeOWConfirmationObject(rs);

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

        return slipsowconfirmation;
    }

    public Collection<SLIPSOWConfirmation> getConfirmationDetails(String bankCode, String status,
            String businessDate, String session)
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
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }
        if (businessDate == null)
        {
            System.out.println("WARNING : Null businessDate parameter.");
            return col;
        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return col;
        }



        try
        {

            Vector<Integer> vt = new Vector();

            int val_bankCode = 1;
            int val_status = 2;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select BusinessDate, Session, Bank, ShortName, FullName, Status, Description, Remarks, ConfirmedBy, ConfirmationTime from "
                    + "(select s.BusinessDate, s.Session, s.Bank, b.ShortName, b.FullName, s.Status, c.Description, s.Remarks, s.ConfirmedBy, s.ConfirmationTime from ");

            sbQuery.append(LCPL_Constants.tbl_slipowconfirmation + " s, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " b, ");
            sbQuery.append(LCPL_Constants.tbl_confirmstatus + "  c ");

            sbQuery.append("where s.Bank = b.BankCode ");
            sbQuery.append("and s.Status = c.ID ");
            sbQuery.append("and s.BusinessDate = str_to_date(REPLACE(?, '-', '') ,'%Y%m%d') ");
            sbQuery.append("and s.Session = ? ");

            sbQuery.append("union ");
            sbQuery.append("select str_to_date(REPLACE(?, '-', '') ,'%Y%m%d') as BusinessDate, ? as Session, b2.BankCode, b2.ShortName, b2.FullName, c2.ID, c2.Description, null as Remarks, null as ConfirmedBy, null as ConfirmationTime from ");

            sbQuery.append(LCPL_Constants.tbl_bank + " b2, ");
            sbQuery.append(LCPL_Constants.tbl_confirmstatus + "  c2 ");

            sbQuery.append("where c2.ID = ? ");
            sbQuery.append("and b2.BankCode not in ( ");
            sbQuery.append("select s.Bank from ");
            sbQuery.append(LCPL_Constants.tbl_slipowconfirmation + " s, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " b, ");
            sbQuery.append(LCPL_Constants.tbl_confirmstatus + "  c ");
            sbQuery.append("where s.Bank = b.BankCode ");
            sbQuery.append("and s.Status = c.ID ");
            sbQuery.append("and s.BusinessDate = str_to_date(REPLACE(?, '-', '') ,'%Y%m%d') ");
            sbQuery.append("and s.Session = ? ");
            sbQuery.append(") ");
            sbQuery.append("and b2.BankCode not in ('9999','9991') ");

            sbQuery.append(") as tbl_slipsowconfirmation ");
            sbQuery.append("where BusinessDate =  str_to_date(REPLACE(?, '-', '') ,'%Y%m%d') ");
            sbQuery.append("and Session = ? ");

            if (!bankCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and Bank = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and Status = ? ");
                vt.add(val_status);
            }


            sbQuery.append("order by BusinessDate, Session, Status, Bank ");


            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, businessDate);
            psmt.setString(2, session);
            psmt.setString(3, businessDate);
            psmt.setString(4, session);
            psmt.setString(5, LCPL_Constants.confirmation_status_three);
            psmt.setString(6, businessDate);
            psmt.setString(7, session);
            psmt.setString(8, businessDate);
            psmt.setString(9, session);


            int i = 10;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    psmt.setString(i, status);
                    i++;
                }
            }

            rs = psmt.executeQuery();
            col = SLIPSOWConfirmationUtil.makeOWConfirmationObjectsCollection(rs);

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

    public boolean isAlreadyConfirmed(SLIPSOWConfirmation slipsowconfirmation)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean isAlreadyConfirmed = false;
        ResultSet rs = null;
        int count = 0;

        if (slipsowconfirmation.getBusinessDate() == null)
        {
            System.out.println("WARNING : Null businessDate parameter.");
            return false;
        }

        if (slipsowconfirmation.getSession() == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return false;
        }

        if (slipsowconfirmation.getOwBank() == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return false;
        }


        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(*) as Hits from ");
            sbQuery.append(LCPL_Constants.tbl_slipowconfirmation + " ");
            sbQuery.append("where  BusinessDate = str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
            sbQuery.append("and  Session = ? ");
            sbQuery.append("and  Bank = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, slipsowconfirmation.getBusinessDate());
            psmt.setString(2, slipsowconfirmation.getSession());
            psmt.setString(3, slipsowconfirmation.getOwBank());

            rs = psmt.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();

                if(rs.getInt("Hits") > 0)
                {
                    isAlreadyConfirmed = true;
                }
                else
                {
                    isAlreadyConfirmed = false;
                }
            }
            else
            {
                isAlreadyConfirmed = false;
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return isAlreadyConfirmed;
    }

    public boolean doConfirm(SLIPSOWConfirmation slipsowconfirmation)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        if (slipsowconfirmation.getBusinessDate() == null)
        {
            System.out.println("WARNING : Null businessDate parameter.");
            return false;
        }

        if (slipsowconfirmation.getSession() == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return false;
        }

        if (slipsowconfirmation.getOwBank() == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return false;
        }

        if (slipsowconfirmation.getStatusId() == null)
        {
            System.out.println("WARNING : Null statusId parameter.");
            return false;
        }

        if (slipsowconfirmation.getConfirmedBy() == null)
        {
            System.out.println("WARNING : Null confirmedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            if (slipsowconfirmation.getRemarks() != null && slipsowconfirmation.getRemarks().trim().length() > 0)
            {
                sbQuery.append("insert into ");
                sbQuery.append(LCPL_Constants.tbl_slipowconfirmation + " ");
                sbQuery.append("(BusinessDate ,Session ,Bank ,Status, Remarks, ConfirmedBy ,ConfirmationTime) ");
                sbQuery.append("values (str_to_date(REPLACE(?, '-', '') ,'%Y%m%d'),?,?,?,?,?,now())");

                psmt = con.prepareStatement(sbQuery.toString());

                psmt.setString(1, slipsowconfirmation.getBusinessDate());
                psmt.setString(2, slipsowconfirmation.getSession());
                psmt.setString(3, slipsowconfirmation.getOwBank());
                psmt.setString(4, slipsowconfirmation.getStatusId());
                psmt.setString(5, slipsowconfirmation.getRemarks());
                psmt.setString(6, slipsowconfirmation.getConfirmedBy());
            }
            else
            {
                sbQuery.append("insert into ");
                sbQuery.append(LCPL_Constants.tbl_slipowconfirmation + " ");
                sbQuery.append("(BusinessDate ,Session ,Bank ,Status, ConfirmedBy ,ConfirmationTime) ");
                sbQuery.append("values (str_to_date(REPLACE(?, '-', '') ,'%Y%m%d'),?,?,?,?,now())");

                psmt = con.prepareStatement(sbQuery.toString());

                psmt.setString(1, slipsowconfirmation.getBusinessDate());
                psmt.setString(2, slipsowconfirmation.getSession());
                psmt.setString(3, slipsowconfirmation.getOwBank());
                psmt.setString(4, slipsowconfirmation.getStatusId());
                psmt.setString(5, slipsowconfirmation.getConfirmedBy());
            }

            count = psmt.executeUpdate();

            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
                msg = LCPL_Constants.msg_duplicate_records;
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }
}

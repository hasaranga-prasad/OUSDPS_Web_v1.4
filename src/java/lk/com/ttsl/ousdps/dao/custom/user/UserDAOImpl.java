/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;
import lk.com.ttsl.ousdps.dao.DAOFactory;

/**
 *
 * @author Dinesh
 */
public class UserDAOImpl implements UserDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public boolean isAuthorized(User usr)
    {
        boolean isAuthorized = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isAuthorized;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null password parameter.");
            return isAuthorized;
        }
        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return isAuthorized;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsAuthorized FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND Password = MD5(?) ");

            if (!usr.getStatus().equals(LCPL_Constants.status_all))
            {
                sbQuery.append("AND Status = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usr.getUserId());
            pstm.setString(2, usr.getUserId() + usr.getPassword());

            if (!usr.getStatus().equals(LCPL_Constants.status_all))
            {
                pstm.setString(3, usr.getStatus());
            }

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsAuthorized");

                if (count > 0)
                {
                    isAuthorized = true;
                }
            }

            if (count == -1)
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isAuthorized;
    }

    @Override
    public boolean isCurrentlyLoggedin(String userId, int sessionExpTimeInMinutes)
    {
        boolean isCurLoggedin = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            msg = LCPL_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsCurLoggedin FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND IsCurrentlyLoggedIn = ? ");
            sbQuery.append("AND TIMESTAMPDIFF(MINUTE,LastSuccessfulVisit,now()) <= ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);
            pstm.setString(2, LCPL_Constants.status_yes);
            pstm.setInt(3, sessionExpTimeInMinutes);

            //System.out.println("PropertyLoader.getInstance().getUserSessionTimeout() --> " + PropertyLoader.getInstance().getUserSessionTimeout());
            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsCurLoggedin");

                if (count > 0)
                {
                    isCurLoggedin = true;
                }
            }

            if (count == -1)
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isCurLoggedin;
    }

    @Override
    public boolean isInitialLogin(String userId, String status)
    {
        boolean isInitLogin = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            msg = LCPL_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            msg = LCPL_Constants.msg_null_or_invalid_parameter;
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsInitLogin FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = BINARY(?) ");
            sbQuery.append("AND IsInitialPassword = ? ");

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("AND Status = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);
            pstm.setString(2, LCPL_Constants.status_yes);

            if (!status.equals(LCPL_Constants.status_all))
            {
                pstm.setString(3, status);
            }

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsInitLogin");

                if (count > 0)
                {
                    isInitLogin = true;
                }
            }

            if (count == -1)
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isInitLogin;
    }
    
    @Override
    public Collection<User> getUserDetails(String status)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");
            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bank.ShortName as BankShortName, ");
            sbQuery.append("bank.FullName as BankFullName, ");
            sbQuery.append("usr.Branch as BranchCode, ");
            //sbQuery.append("branch.BranchName as BranchName, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.LastPasswordResetDate, ");

            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.ContactNo, ");

            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.NeedDownloadToBIM, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");
            sbQuery.append("usr.LastLoggingAttempt FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " usr, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " bank, ");
            //sbQuery.append(LCPL_Constants.tbl_branch + " branch, ");
            sbQuery.append(LCPL_Constants.tbl_userlevel + " usrlevel ");
            sbQuery.append("WHERE usr.Bank = bank.BankCode ");
            //sbQuery.append("AND usr.Bank = branch.BankCode ");
            //sbQuery.append("AND usr.Branch = branch.BranchCode ");
            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("AND usr.Status = ? ");
            }

            sbQuery.append("ORDER BY UserId");

            System.out.println("getUserDetails(sbQuery) ======> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            if (!status.equals(LCPL_Constants.status_all))
            {
                pstm.setString(1, status);
            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
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
    
    @Override
    public Collection<User> getUsers(User usr, String statusNotIn)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usr.getUserLevelId() == null)
        {
            System.out.println("WARNING : Null userLevelId parameter.");
            return col;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (usr.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }

        if (usr.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_userLevel = 1;
            int val_userStatus = 2;
            int val_userBank = 3;
            int val_userBranch = 4;
            int val_statusNotIn = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " usr ");

            sbQuery.append("WHERE usr.UserId != ? ");
            sbQuery.append("and usr.Status != ? ");

            if (!usr.getUserLevelId().equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and usr.UserLevel = ? ");
                vt.add(val_userLevel);
            }
            if (!usr.getStatus().equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and usr.Status = ? ");
                vt.add(val_userStatus);
            }
            if (!usr.getBankCode().equals(LCPL_Constants.status_all))
            {
                sbQuery.append("AND usr.Bank = ? ");
                vt.add(val_userBank);
            }
            if (!usr.getBranchCode().equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and usr.Branch = ? ");
                vt.add(val_userBranch);
            }

            if (statusNotIn != null)
            {
                sbQuery.append("and usr.Status != ? ");
                vt.add(val_statusNotIn);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, LCPL_Constants.param_id_user_system);
            pstm.setString(2, LCPL_Constants.status_pending);

            int i = 3;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, usr.getUserLevelId());
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, usr.getStatus());
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, usr.getBankCode());
                    i++;
                }
                if (val_item == 4)
                {
                    pstm.setString(i, usr.getBranchCode());
                    i++;
                }
                if (val_item == 5)
                {
                    pstm.setString(i, statusNotIn);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserIdObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
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

    @Override
    public boolean addUser(User usr)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null Password parameter.");
            return false;
        }
        if (usr.getUserLevelId() == null)
        {
            System.out.println("WARNING : Null User Level parameter.");
            return false;
        }
        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        if (usr.getBankCode() == null)
        {
            System.out.println("WARNING : Null Bank Code parameter.");
            return false;
        }
//        if (usr.getBranchCode() == null)
//        {
//            System.out.println("WARNING : Null Branch Code parameter.");
//            return false;
//        }
        if (usr.getCreatedBy() == null)
        {
            System.out.println("WARNING : Null Created By parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("(UserId,UserLevel,Password,Bank,Branch,Status,CreatedDate,"
                    + "CreatedBy,LastPasswordResetDate,Remarks,"
                    + "IsInitialPassword,NeedDownloadToBIM,Name,Designation,Email,ContactNo) ");
            sbQuery.append("values ");
            sbQuery.append("(?,?,MD5(?),?,?,?,NOW(),?,NOW(),?,?,?,?,?,?,?)");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, usr.getUserId());
            psmt.setString(2, usr.getUserLevelId());
            psmt.setString(3, usr.getUserId() + usr.getPassword());
            psmt.setString(4, usr.getBankCode());
            psmt.setString(5, usr.getBranchCode());
            psmt.setString(6, usr.getStatus());
            psmt.setString(7, usr.getCreatedBy());
            psmt.setString(8, usr.getRemarks());
            psmt.setString(9, usr.getIsInitialPassword());
            psmt.setString(10, usr.getNeedDownloadToBIM());
            psmt.setString(11, usr.getName());
            psmt.setString(12, usr.getDesignation());
            psmt.setString(13, usr.getEmail());
            psmt.setString(14, usr.getContactNo());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                con.rollback();
                msg = LCPL_Constants.msg_no_records_updated;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean updateUser(User usr)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        if (usr.getStatus() == null)
        {
            System.out.println("WARNING : Null Status parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("set Status = ?, Remarks = ?, NeedDownloadToBIM = ?, "
                    + "Name = ?, Designation = ?, Email = ?, ContactNo = ? ");
            sbQuery.append("where UserId = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, usr.getStatus());
            psmt.setString(2, usr.getRemarks());
            psmt.setString(3, usr.getNeedDownloadToBIM());
            psmt.setString(4, usr.getName());
            psmt.setString(5, usr.getDesignation());
            psmt.setString(6, usr.getEmail());
            psmt.setString(7, usr.getContactNo());
            psmt.setString(8, usr.getUserId());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                con.rollback();
                msg = LCPL_Constants.msg_no_records_updated;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean changeUserPassword(User usr, String curPwd, boolean isInitial)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null Password parameter.");
            return false;
        }

        if (!isInitial && curPwd == null)
        {
            System.out.println("WARNING : Null currentPassword parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            if (!isInitial)
            {
                if (DAOFactory.getUserDAO().isAuthorized(new User(usr.getUserId(), curPwd, LCPL_Constants.status_all)))
                {

                    con = DBUtil.getInstance().getConnection();
                    con.setAutoCommit(false);

                    StringBuilder sbQuery = new StringBuilder();

                    sbQuery.append("update ");
                    sbQuery.append(LCPL_Constants.tbl_user + " ");
                    sbQuery.append("set Password=MD5(?), LastPasswordResetDate=now(), IsInitialPassword = ?, NeedDownloadToBIM = ? ");

                    sbQuery.append("where userId = ? ");

                    sbQuery.append("and Password = MD5(?) ");

                    //System.out.println(sbQuery.toString());
                    psmt = con.prepareStatement(sbQuery.toString());

                    psmt.setString(1, usr.getUserId() + usr.getPassword());
                    psmt.setString(2, LCPL_Constants.status_no);
                    psmt.setString(3, LCPL_Constants.status_yes);
                    psmt.setString(4, usr.getUserId());
                    psmt.setString(5, usr.getUserId() + curPwd);

                    count = psmt.executeUpdate();

                    //System.out.println("count ---> " + count);
                    if (count > 0)
                    {
                        con.commit();
                        query_status = true;
                    }
                    else
                    {
                        msg = LCPL_Constants.msg_error_while_processing;
                        con.rollback();
                    }

                    //System.out.println("msg ---> " + msg);
                }
                else
                {
                    msg = "Current Password Does not match!";
                }

            }
            else
            {
                con = DBUtil.getInstance().getConnection();
                con.setAutoCommit(false);

                StringBuilder sbQuery = new StringBuilder();

                sbQuery.append("update ");
                sbQuery.append(LCPL_Constants.tbl_user + " ");
                sbQuery.append("set Password=MD5(?), LastPasswordResetDate=now(), IsInitialPassword = ?, NeedDownloadToBIM = ? ");

                sbQuery.append("where userId = ? ");

                //System.out.println(sbQuery.toString());
                psmt = con.prepareStatement(sbQuery.toString());

                psmt.setString(1, usr.getUserId() + usr.getPassword());
                psmt.setString(2, LCPL_Constants.status_no);
                psmt.setString(3, LCPL_Constants.status_yes);
                psmt.setString(4, usr.getUserId());

                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    query_status = true;
                }
                else
                {
                    msg = LCPL_Constants.msg_error_while_processing;
                    con.rollback();
                }
            }
        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean isOkToChangePassword(String userId, int iMinPwdResetDays)
    {
        boolean isOkToChangePassword = false;  //100;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isOkToChangePassword;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select DATEDIFF(now(), LastPasswordResetDate) as NoDays FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();

                if (rs.getInt("NoDays") >= iMinPwdResetDays)
                {
                    isOkToChangePassword = true;
                }
                else
                {
                    isOkToChangePassword = false;
                }
            }
            else
            {
                msg = LCPL_Constants.msg_no_records;
                isOkToChangePassword = false;
            }
        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return isOkToChangePassword;
    }

    @Override
    public boolean resetUserPassword(User usr)
    {

        if (usr.getUserId() == null)
        {
            System.out.println("WARNING : Null User Id parameter.");
            return false;
        }
        if (usr.getPassword() == null)
        {
            System.out.println("WARNING : Null Password parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("set Password=MD5(?), LastPasswordResetDate=now(), IsInitialPassword = ?, NeedDownloadToBIM = ?, Status = ?, UnSuccessfulLoggingAttempts = 0 ");

            if (usr.getStatus() != null)
            {
                sbQuery.append(", Status = ? ");
            }

            sbQuery.append("where userId = ? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, usr.getUserId() + usr.getPassword());
            psmt.setString(2, LCPL_Constants.status_yes);
            psmt.setString(3, LCPL_Constants.status_yes);
            psmt.setString(4, LCPL_Constants.status_active);

            if (usr.getStatus() != null)
            {
                psmt.setString(5, usr.getStatus());
                psmt.setString(6, usr.getUserId());
            }
            else
            {
                psmt.setString(5, usr.getUserId());
            }

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = LCPL_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    
    @Override
    public User getUserDetails(String userId, String status)
    {
        User user = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return user;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return user;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");
            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bank.ShortName as BankShortName, ");
            sbQuery.append("bank.FullName as BankFullName, ");
            sbQuery.append("usr.Branch as BranchCode, ");
            //sbQuery.append("branch.BranchName as BranchName, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.LastPasswordResetDate, ");

            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.ContactNo, ");

            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.NeedDownloadToBIM, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");
            sbQuery.append("usr.LastLoggingAttempt FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " usr, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " bank, ");
            //sbQuery.append(LCPL_Constants.tbl_branch + " branch, ");
            sbQuery.append(LCPL_Constants.tbl_userlevel + " usrlevel ");
            sbQuery.append("WHERE usr.Bank = bank.BankCode ");
            //sbQuery.append("AND usr.Bank = branch.BankCode ");
            //sbQuery.append("AND usr.Branch = branch.BranchCode ");
            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.UserId = BINARY(?) ");

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("AND usr.Status = ? ");
            }

            sbQuery.append("ORDER BY FullName");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);

            if (!status.equals(LCPL_Constants.status_all))
            {
                pstm.setString(2, status);
            }

            rs = pstm.executeQuery();

            user = UserUtil.makeUserObject(rs);

            if (user == null)
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return user;
    }

    @Override
    public Collection<User> getUserList(String UserLevel)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");
            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bank.ShortName as BankShortName, ");
            sbQuery.append("bank.FullName as BankFullName, ");
            sbQuery.append("usr.Branch as BranchCode, ");
            //sbQuery.append("branch.BranchName as BranchName, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.LastPasswordResetDate, ");

            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.ContactNo, ");

            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.NeedDownloadToBIM, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");
            sbQuery.append("usr.LastLoggingAttempt FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " usr, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " bank, ");
            //sbQuery.append(LCPL_Constants.tbl_branch + " branch, ");
            sbQuery.append(LCPL_Constants.tbl_userlevel + " usrlevel ");
            sbQuery.append("WHERE usr.Bank = bank.BankCode ");
            //sbQuery.append("AND usr.Bank = branch.BankCode ");
            //sbQuery.append("AND usr.Branch = branch.BranchCode ");
            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");

            if (!UserLevel.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and usr.UserLevel = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            if (!UserLevel.equals(LCPL_Constants.status_all))
            {

                pstm.setString(1, UserLevel);
            }

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
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

    @Override
    public int getPasswordValidityPeriod(String userId)
    {
        int validityPeriod = -1;  //100;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return validityPeriod;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select (? - DATEDIFF(now(), LastPasswordResetDate)) as NoDays, UserLevel FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = ? ");
            
            System.out.println("getPasswordValidityPeriod(sbQuery) ====> " + sbQuery.toString());

            System.out.println("getPasswordValidityPeriod(sbQuery) ====> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            if (userId.equals(LCPL_Constants.param_id_user_system))
            {
                pstm.setInt(1, LCPL_Constants.system_pwd_expire_duration);
            }
            else
            {
                pstm.setInt(1, LCPL_Constants.user_pwd_expire_duration);
            }

            pstm.setString(2, userId);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                validityPeriod = rs.getInt("NoDays");
            }
            else
            {
                msg = LCPL_Constants.msg_no_records;
            }
        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return validityPeriod;
    }

    @Override
    public boolean setUserStatus(String userId, String status)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("set Status = ? , UnSuccessfulLoggingAttempts = 0 ");
            sbQuery.append("where userId = ? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, status);
            psmt.setString(2, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = LCPL_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    

    public Collection<User> getAuthPendingUsers(String createdUser)
    {
        Collection<User> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (createdUser == null)
        {
            System.out.println("WARNING : Null createdUser parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT usr.UserId, ");
            sbQuery.append("usr.UserLevel as UserLevelId, ");
            sbQuery.append("usrlevel.UserLevelDesc as UserLevelDesc, ");
            sbQuery.append("usr.Bank as BankCode, ");
            sbQuery.append("bank.ShortName as BankShortName, ");
            sbQuery.append("bank.FullName as BankFullName, ");
            sbQuery.append("usr.Branch as BranchCode, ");
            //sbQuery.append("branch.BranchName as BranchName, ");
            sbQuery.append("usr.Status, ");
            sbQuery.append("usr.CreatedDate, ");
            sbQuery.append("usr.CreatedBy, ");
            sbQuery.append("usr.ModifiedDate, ");
            sbQuery.append("usr.ModifiedBy, ");
            sbQuery.append("usr.LastPasswordResetDate, ");

            sbQuery.append("usr.Name, ");
            sbQuery.append("usr.Designation, ");
            sbQuery.append("usr.Email, ");
            sbQuery.append("usr.ContactNo, ");

            sbQuery.append("usr.Remarks, ");
            sbQuery.append("usr.IsInitialPassword, ");
            sbQuery.append("usr.NeedDownloadToBIM, ");
            sbQuery.append("usr.UnSuccessfulLoggingAttempts, ");
            sbQuery.append("usr.LastLoggingAttempt FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " usr, ");
            sbQuery.append(LCPL_Constants.tbl_bank + " bank, ");
            //sbQuery.append(LCPL_Constants.tbl_branch + " branch, ");
            sbQuery.append(LCPL_Constants.tbl_userlevel + " usrlevel ");
            sbQuery.append("WHERE usr.Bank = bank.BankCode ");
            //sbQuery.append("AND usr.Bank = branch.BankCode ");
            //sbQuery.append("AND usr.Branch = branch.BranchCode ");
            sbQuery.append("AND usr.UserLevel = usrlevel.UserLevelId ");
            sbQuery.append("AND usr.Status = ? ");
            sbQuery.append("AND usr.CreatedBy != ? ");
            sbQuery.append("ORDER BY UserId");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, LCPL_Constants.status_pending);
            pstm.setString(2, createdUser);

            rs = pstm.executeQuery();

            col = UserUtil.makeUserObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {
            msg = e.getMessage();
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

    public boolean doAuthorizedNewUser(String userId, String authBy)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (authBy == null)
        {
            System.out.println("WARNING : Null authBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("set ");
            sbQuery.append("Status = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("AuthorizedDate = now() ");
            sbQuery.append("where UserId = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, LCPL_Constants.status_active);
            psmt.setString(2, authBy);
            psmt.setString(3, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                con.rollback();
            }

        }
        catch (Exception ex)
        {
            msg = LCPL_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean setUserLoggingAttempts(String userId, String status)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        User user = null;
        boolean query_status = false;

        try
        {
            user = new UserDAOImpl().getUnSuccessfulLoggingAttemptsDetails(userId);

            if (user != null)
            {
                int unSuccessLoggingcount = user.getUnSccessfulLoggingAttempts();
                long timeDiff = user.getTimeDiff();
                int paramSetId = 0;

                //System.out.println("unSuccessLoggingcount ---> " + unSuccessLoggingcount);
                //System.out.println("timeDiff ---> " + timeDiff);
                con = DBUtil.getInstance().getConnection();
                con.setAutoCommit(false);

                StringBuilder sbQuery = new StringBuilder();

                sbQuery.append("update ");
                sbQuery.append(LCPL_Constants.tbl_user + " ");

                if (status.equals(LCPL_Constants.status_fail))
                {
                    if (timeDiff < 300)
                    {
                        if (unSuccessLoggingcount < 4)
                        {
                            unSuccessLoggingcount++;
                            sbQuery.append("set UnSuccessfulLoggingAttempts = ?, ");
                            sbQuery.append("LastLoggingAttempt = now() ");
                            sbQuery.append("where userId = ? ");

                            paramSetId = 1;
                        }
                        else
                        {
                            unSuccessLoggingcount++;
                            sbQuery.append("set UnSuccessfulLoggingAttempts = ?, ");
                            sbQuery.append("Status = ?, ");
                            sbQuery.append("LastLoggingAttempt = now() ");
                            sbQuery.append("where userId = ? ");
                            paramSetId = 2;
                        }
                    }
                    else
                    {
                        unSuccessLoggingcount = 1;
                        sbQuery.append("set UnSuccessfulLoggingAttempts = ?, ");
                        sbQuery.append("LastLoggingAttempt = now() ");
                        sbQuery.append("where userId = ? ");
                        paramSetId = 3;
                    }

                    //System.out.println(sbQuery.toString());
                    psmt = con.prepareStatement(sbQuery.toString());

                    if (paramSetId == 1)
                    {
                        psmt.setInt(1, unSuccessLoggingcount);
                        psmt.setString(2, userId);
                    }
                    else if (paramSetId == 2)
                    {
                        psmt.setInt(1, unSuccessLoggingcount);
                        psmt.setString(2, LCPL_Constants.status_locked);
                        psmt.setString(3, userId);
                    }
                    else if (paramSetId == 3)
                    {
                        psmt.setInt(1, unSuccessLoggingcount);
                        psmt.setString(2, userId);
                    }
                }
                else if (status.equals(LCPL_Constants.status_success))
                {
                    sbQuery.append("set UnSuccessfulLoggingAttempts=0, LastLoggingAttempt = now() ");
                    sbQuery.append("where userId = ? ");

                    psmt = con.prepareStatement(sbQuery.toString());
                    psmt.setString(1, userId);
                }
                else
                {
                    sbQuery.append("set LastLoggingAttempt = now() ");
                    sbQuery.append("where userId = ? ");

                    psmt = con.prepareStatement(sbQuery.toString());
                    psmt.setString(1, userId);
                }

                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    query_status = true;
                }
                else
                {
                    msg = LCPL_Constants.msg_error_while_processing;
                    con.rollback();
                }
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    public User getUnSuccessfulLoggingAttemptsDetails(String userId)
    {
        User user = null;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return user;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select UnSuccessfulLoggingAttempts, TIMESTAMPDIFF(SECOND,LastLoggingAttempt,now()) as timeDifference FROM ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("WHERE UserId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, userId);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                user = new User(rs.getInt("UnSuccessfulLoggingAttempts"), rs.getLong("timeDifference"));
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return user;
    }

    public boolean updateUserVisitStat(String userId, String isCurrentlyLoggedIn)
    {

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return false;
        }
        if (isCurrentlyLoggedIn == null)
        {
            System.out.println("WARNING : Null isCurrentlyLoggedIn parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(LCPL_Constants.tbl_user + " ");
            sbQuery.append("set IsCurrentlyLoggedIn = ? , LastSuccessfulVisit = now() ");
            sbQuery.append("where userId = ? ");

            System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, isCurrentlyLoggedIn);
            psmt.setString(2, userId);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                msg = LCPL_Constants.msg_error_while_processing;
                con.rollback();
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

}

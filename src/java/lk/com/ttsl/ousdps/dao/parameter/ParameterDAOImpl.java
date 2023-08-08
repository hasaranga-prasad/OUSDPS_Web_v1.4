/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.parameter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Hashtable;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;
import lk.com.ttsl.ousdps.dao.DAOFactory;

/**
 *
 * @author Dinesh
 */
public class ParameterDAOImpl implements ParameterDAO
{

    String msg = null;
    Hashtable fail_Query = null;
    Hashtable success_Query = null;
    Hashtable<String, Parameter> fail_Query2 = null;
    Hashtable<String, Parameter> success_Query2 = null;

    public Hashtable getFailQuery()
    {
        return fail_Query;
    }

    public Hashtable getSuccessQuery()
    {
        return success_Query;
    }

    public Hashtable<String, Parameter> getFailQuery2()
    {
        return fail_Query2;
    }

    public Hashtable<String, Parameter> getSuccessQuery2()
    {
        return success_Query2;
    }

    public String getMsg()
    {
        return msg;
    }

    public String getParamValueById(String paramId)
    {
        String paramValue = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (paramId == null)
        {
            System.out.println("WARNING : Null paramId parameter.");
            return paramValue;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT ParamValue FROM ");
            sbQuery.append(LCPL_Constants.tbl_parameter + " ");
            sbQuery.append("WHERE ParamId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, paramId);

            //System.out.println(sbQuery.toString());

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                paramValue = rs.getString("ParamValue");
            }
            else
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


        return paramValue;
    }

    @Override
    public String getParamValue(String paramId, String paramType)
    {
        String paramValue = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (paramId == null)
        {
            System.out.println("WARNING : Null paramId parameter.");
            return paramValue;
        }

        if (paramType == null)
        {
            System.out.println("WARNING : Null paramType parameter.");
            return paramValue;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            if (paramType.equals(LCPL_Constants.param_type_pwd))
            {
                sbQuery.append("SELECT CONVERT(AES_DECRYPT(ParamValueBlob, ? )USING utf8) as val FROM ");
                sbQuery.append(LCPL_Constants.tbl_parameter + " ");
                sbQuery.append("WHERE ParamId = ? ");

                pstm = con.prepareStatement(sbQuery.toString());

                String kk = LCPL_Constants.desk_s + LCPL_Constants.desk_l + LCPL_Constants.desk_i
                        + LCPL_Constants.desk_p + LCPL_Constants.desk_s + LCPL_Constants.desk_b
                        + LCPL_Constants.desk_c + LCPL_Constants.desk_m + LCPL_Constants.desk_2
                        + LCPL_Constants.desk_0 + LCPL_Constants.desk_1 + LCPL_Constants.desk_2;

                pstm.setString(1, kk);
                pstm.setString(2, paramId);

                System.out.println("decryptKey (kk) --> " + kk);
                System.out.println("paramId (pwd) --> " + paramId);
            }
            else
            {
                sbQuery.append("SELECT ParamValue as val FROM ");
                sbQuery.append(LCPL_Constants.tbl_parameter + " ");
                sbQuery.append("WHERE ParamId = ? ");

                pstm = con.prepareStatement(sbQuery.toString());

                pstm.setString(1, paramId);

                //System.out.println("paramId  --> " + paramId);
            }

            System.out.println(sbQuery.toString());

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                paramValue = rs.getString("val");

                //System.out.println("paramValue --> " + paramValue);
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


        return paramValue;
    }

    @Override
    public String getParamValueById_notFormatted(String paramId)
    {

        String paramValue = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (paramId == null)
        {
            System.out.println("WARNING : Null paramId parameter.");
            return paramValue;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT ParamValue FROM ");
            sbQuery.append(LCPL_Constants.tbl_parameter + " ");
            sbQuery.append("WHERE ParamId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, paramId);

            // System.out.println(sbQuery.toString());

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                paramValue = rs.getString("ParamValue");
            }
            else
            {
                msg = LCPL_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
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

        return paramValue;
    }

    @Override
    public Collection<Parameter> getAllParamterValues()
    {

        Collection<Parameter> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ParamId, ParamDesc, ParamValue, ParamType,CONVERT(AES_DECRYPT(ParamValueBlob, ?)USING utf8) as  decrypVal from ");
            sbQuery.append(LCPL_Constants.tbl_parameter + " ");
            sbQuery.append("order by ParamId");

            pstm = con.prepareStatement(sbQuery.toString());

            String kk = LCPL_Constants.desk_s + LCPL_Constants.desk_l + LCPL_Constants.desk_i
                    + LCPL_Constants.desk_p + LCPL_Constants.desk_s + LCPL_Constants.desk_b
                    + LCPL_Constants.desk_c + LCPL_Constants.desk_m + LCPL_Constants.desk_2
                    + LCPL_Constants.desk_0 + LCPL_Constants.desk_1 + LCPL_Constants.desk_2;

            pstm.setString(1, kk);

            rs = pstm.executeQuery();

            col = ParameterUtil.makeParameterCollection(rs);

            if (col.isEmpty())
            {
                msg = LCPL_Constants.msg_no_records;
            }
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    public boolean update(Collection<Parameter> col_para)
    {
        boolean status = false;

        try
        {
            if (fail_Query == null)
            {
                fail_Query = new Hashtable();
            }
            if (success_Query == null)
            {
                success_Query = new Hashtable();
            }

            if (!col_para.isEmpty())
            {
                for (Parameter param : col_para)
                {
                    boolean status_Query = DAOFactory.getParameterDAO().update(param);

                    if (status_Query == false)
                    {
                        fail_Query.put(param.getName(), "F");
                    }
                    else
                    {
                        success_Query.put(param.getName(), "S");
                    }
                }
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }

        if (fail_Query.isEmpty())
        {
            status = true;
        }

        return status;
    }

    public boolean update(Parameter parameter)
    {

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            if (fail_Query2 == null)
            {
                fail_Query2 = new Hashtable<String, Parameter>();
            }
            if (success_Query2 == null)
            {
                success_Query2 = new Hashtable<String, Parameter>();
            }

            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            if (parameter.getValue().length() > 0)
            {
                if (parameter.getType().equals(LCPL_Constants.param_type_pwd))
                {
                    sbQuery.append("update ");
                    sbQuery.append(LCPL_Constants.tbl_parameter + " ");
                    sbQuery.append("set ParamValueBlob = AES_ENCRYPT(?,?) ");
                    sbQuery.append("where ParamId = ?");

                    psmt = con.prepareStatement(sbQuery.toString());

                    String kk = LCPL_Constants.desk_s + LCPL_Constants.desk_l + LCPL_Constants.desk_i
                            + LCPL_Constants.desk_p + LCPL_Constants.desk_s + LCPL_Constants.desk_b
                            + LCPL_Constants.desk_c + LCPL_Constants.desk_m + LCPL_Constants.desk_2
                            + LCPL_Constants.desk_0 + LCPL_Constants.desk_1 + LCPL_Constants.desk_2;

                    psmt.setString(1, parameter.getValue());
                    psmt.setString(2, kk);
                    psmt.setString(3, parameter.getName());

                }
                else
                {

                    sbQuery.append("update ");
                    sbQuery.append(LCPL_Constants.tbl_parameter + " ");
                    sbQuery.append("set ParamValue =?  ");
                    sbQuery.append("where ParamId = ?");

                    psmt = con.prepareStatement(sbQuery.toString());

                    psmt.setString(1, parameter.getValue());
                    psmt.setString(2, parameter.getName());
                }

                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    parameter.setUpdateStatus(LCPL_Constants.status_success);
                    success_Query2.put(parameter.getName(), parameter);
                    query_status = true;
                }
                else
                {
                    con.rollback();
                    parameter.setUpdateStatus(LCPL_Constants.status_fail);
                    parameter.setUpdateStatusMsg(msg);
                    fail_Query2.put(parameter.getName(), parameter);
                    msg = LCPL_Constants.msg_error_while_processing;
                }
            }
            else
            {
                query_status = true;
            }
        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            parameter.setUpdateStatus(LCPL_Constants.status_fail);
            parameter.setUpdateStatusMsg(msg);
            fail_Query2.put(parameter.getName(), parameter);
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    /**
     * @return no of records which contains date values
     */
    @Override
    public int getDateTypeParameterCount()
    {
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        int count = 0;
        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(ParamId) as NoOfRecords from ");
            sbQuery.append(LCPL_Constants.tbl_parameter + " ");
            sbQuery.append("where ParamType=?");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, "Y");

            rs = pstm.executeQuery();
            while (rs.next())
            {
                count = rs.getInt("NoOfRecords");
            }


        }
        catch (ClassNotFoundException | SQLException e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return count;
    }
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.owdetails;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import java.util.Vector;
import lk.com.ttsl.ousdps.common.utils.DBUtil;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;
import lk.com.ttsl.ousdps.dao.DAOFactory;

/**
 *
 * @author Dinesh
 */
public class OWDetailsDAOImpl implements OWDetailsDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<OWDetails> getOWDetails(String fileID)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (fileID == null)
        {
            System.out.println("WARNING : Null fileID parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select st.fileid, sf.bank, sf.branch, ");
            sbQuery.append("str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, sf.status, fs.StatusDesc, ");
            sbQuery.append("str_to_date(st.vdate,'%Y%m%d') as ValueDate, sf.session as WindowSession, ");
            sbQuery.append("st.RefID, st.desbankcode, st.desbranchcode, ");
            sbQuery.append("st.desacno, CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) as desacnoDec, ");
            sbQuery.append("st.desacname, CONVERT(AES_DECRYPT(st.desacname,?) USING utf8) as desacnameDec, ");
            sbQuery.append("st.desacaddr1, st.desacaddr2, st.desacaddr3, ");
            sbQuery.append("st.desactype, atd.actype as desAcTypeDesc, ");
            sbQuery.append("st.tc, st.rc, st.curid, st.purposecd, st.subpurposecd, ");
            sbQuery.append("st.amount, CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("st.orgbankcode, st.orgbranchcode, ");
            sbQuery.append("st.orgacno, CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("st.orgacname, CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("st.orgacaddr1, st.orgacaddr2, st.orgacaddr3, ");
            sbQuery.append("st.orgactype, ato.actype as orgAcTypeDesc, ");
            sbQuery.append("st.particulars, st.instruction, st.cdate,  ");
            sbQuery.append("st.inwardtime, st.setlementtime, 'No' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");            
            sbQuery.append(LCPL_Constants.tbl_status + " fs, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atd, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ato ");

            sbQuery.append("where sf.fileid = st.fileid ");
            sbQuery.append("and sf.status = fs.StatusId ");
            sbQuery.append("and st.desactype = atd.accd ");
            sbQuery.append("and st.orgactype = ato.accd ");

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.fileid = ? ");
            }

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, sfr.bank, sfr.branch, ");
            sbQuery.append("str_to_date(sfr.bdate,'%Y%m%d') as BusinessDate, sfr.status, fsr.StatusDesc, ");
            sbQuery.append("str_to_date(str.vdate,'%Y%m%d') as ValueDate, sfr.session as WindowSession, ");
            sbQuery.append("str.RefID, str.desbankcode, str.desbranchcode, ");
            sbQuery.append("str.desacno, CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) as desacnoDec, ");
            sbQuery.append("str.desacname, CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8) as desacnameDec, ");
            sbQuery.append("str.desacaddr1, str.desacaddr2, str.desacaddr3, ");
            sbQuery.append("str.desactype, atdr.actype as desAcTypeDesc, ");
            sbQuery.append("str.tc, str.rc, str.curid, str.purposecd, str.subpurposecd, ");
            sbQuery.append("str.amount, CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("str.orgbankcode, str.orgbranchcode, ");
            sbQuery.append("str.orgacno, CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("str.orgacname, CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("str.orgacaddr1, str.orgacaddr2, str.orgacaddr3, ");
            sbQuery.append("str.orgactype, ator.actype as orgAcTypeDesc, ");
            sbQuery.append("str.particulars, str.instruction, str.cdate,  ");
            sbQuery.append("str.inwardtime, str.setlementtime, 'Yes' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fsr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atdr, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ator ");

            sbQuery.append("where sfr.fileid = str.fileid ");
            sbQuery.append("and sfr.status = fsr.StatusId ");
            sbQuery.append("and str.desactype = atdr.accd ");
            sbQuery.append("and str.orgactype = ator.accd ");

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.fileid = ? ");
            }

            sbQuery.append("order by BusinessDate, fileid, RefID, orgbankcode, orgbranchcode ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);

            psmt.setString(1, kk);
            psmt.setString(2, kk);
            psmt.setString(3, kk);
            psmt.setString(4, kk);
            psmt.setString(5, kk);

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                psmt.setString(6, fileID);
                psmt.setString(7, kk);
                psmt.setString(8, kk);
                psmt.setString(9, kk);
                psmt.setString(10, kk);
                psmt.setString(11, kk);
                psmt.setString(12, fileID);
            }
            else
            {
                psmt.setString(6, kk);
                psmt.setString(7, kk);
                psmt.setString(8, kk);
                psmt.setString(9, kk);
                psmt.setString(10, kk);
            }

            rs = psmt.executeQuery();

            col = OWDetailsDAOUtil.makeOWDetailsObjectCollection(rs);

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

    public long getRecordCountOWDetails(String fileID)
    {
        long recCount = 0;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (fileID == null)
        {
            System.out.println("WARNING : Null fileID parameter.");
            return recCount;
        }

        try
        {

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(*) as rowCount from (");

            sbQuery.append("select st.fileid, st.RefID, 'No' as IsReturn from ");
            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st ");

            sbQuery.append("where sf.fileid = st.fileid ");

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.fileid = ? ");
            }

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, str.RefID, 'Yes' as IsReturn from ");
            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str ");

            sbQuery.append("where sfr.fileid = str.fileid ");

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.fileid = ? ");
            }

            sbQuery.append(") as stf");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                psmt.setString(1, fileID);
                psmt.setString(2, fileID);
            }

            rs = psmt.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();

                //System.out.println(rs.getDouble("rowCount"));
                recCount = rs.getLong("rowCount");
            }

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

        return recCount;
    }

    public Collection<OWDetails> getOWDetails(String fileID, int page, int recordsPrepage)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (fileID == null)
        {
            System.out.println("WARNING : Null fileID parameter.");
            return col;
        }

        try
        {

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select st.fileid, sf.bank, sf.branch, ");
            sbQuery.append("str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, sf.status, fs.StatusDesc, ");
            sbQuery.append("str_to_date(st.vdate,'%Y%m%d') as ValueDate, sf.session as WindowSession, ");
            sbQuery.append("st.RefID, st.desbankcode, st.desbranchcode, ");
            sbQuery.append("st.desacno, CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) as desacnoDec, ");
            sbQuery.append("st.desacname, CONVERT(AES_DECRYPT(st.desacname,?) USING utf8) as desacnameDec, ");
            sbQuery.append("st.desacaddr1, st.desacaddr2, st.desacaddr3, ");
            sbQuery.append("st.desactype, atd.actype as desAcTypeDesc, ");
            sbQuery.append("st.tc, st.rc, st.curid, st.purposecd, st.subpurposecd, ");
            sbQuery.append("st.amount, CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("st.orgbankcode, st.orgbranchcode, ");
            sbQuery.append("st.orgacno, CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("st.orgacname, CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("st.orgacaddr1, st.orgacaddr2, st.orgacaddr3, ");
            sbQuery.append("st.orgactype, ato.actype as orgAcTypeDesc, ");
            sbQuery.append("st.particulars, st.instruction, st.cdate,  ");
            sbQuery.append("st.inwardtime, st.setlementtime, 'No' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fs, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atd, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ato ");

            sbQuery.append("where sf.fileid = st.fileid ");
            sbQuery.append("and sf.status = fs.StatusId ");
            sbQuery.append("and st.desactype = atd.accd ");
            sbQuery.append("and st.orgactype = ato.accd ");

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.fileid = ? ");
            }

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, sfr.bank, sfr.branch, ");
            sbQuery.append("str_to_date(sfr.bdate,'%Y%m%d') as BusinessDate, sfr.status, fsr.StatusDesc, ");
            sbQuery.append("str_to_date(str.vdate,'%Y%m%d') as ValueDate, sfr.session as WindowSession, ");
            sbQuery.append("str.RefID, str.desbankcode, str.desbranchcode, ");
            sbQuery.append("str.desacno, CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) as desacnoDec, ");
            sbQuery.append("str.desacname, CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8) as desacnameDec, ");
            sbQuery.append("str.desacaddr1, str.desacaddr2, str.desacaddr3, ");
            sbQuery.append("str.desactype, atdr.actype as desAcTypeDesc, ");
            sbQuery.append("str.tc, str.rc, str.curid, str.purposecd, str.subpurposecd, ");
            sbQuery.append("str.amount, CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("str.orgbankcode, str.orgbranchcode, ");
            sbQuery.append("str.orgacno, CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("str.orgacname, CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("str.orgacaddr1, str.orgacaddr2, str.orgacaddr3, ");
            sbQuery.append("str.orgactype, ator.actype as orgAcTypeDesc, ");
            sbQuery.append("str.particulars, str.instruction, str.cdate,  ");
            sbQuery.append("str.inwardtime, str.setlementtime, 'Yes' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fsr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atdr, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ator ");

            sbQuery.append("where sfr.fileid = str.fileid ");
            sbQuery.append("and sfr.status = fsr.StatusId ");
            sbQuery.append("and str.desactype = atdr.accd ");
            sbQuery.append("and str.orgactype = ator.accd ");

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.fileid = ? ");
            }

            sbQuery.append("order by BusinessDate, fileid, RefID, orgbankcode, orgbranchcode ");

            sbQuery.append("limit ?,? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);

            psmt.setString(1, kk);
            psmt.setString(2, kk);
            psmt.setString(3, kk);
            psmt.setString(4, kk);
            psmt.setString(5, kk);

            if (!fileID.equals(LCPL_Constants.status_all))
            {
                psmt.setString(6, fileID);
                psmt.setString(7, kk);
                psmt.setString(8, kk);
                psmt.setString(9, kk);
                psmt.setString(10, kk);
                psmt.setString(11, kk);
                psmt.setString(12, fileID);
                psmt.setInt(13, (page - 1) * recordsPrepage);
                psmt.setInt(14, recordsPrepage);
            }
            else
            {
                psmt.setString(6, kk);
                psmt.setString(7, kk);
                psmt.setString(8, kk);
                psmt.setString(9, kk);
                psmt.setString(10, kk);
                psmt.setInt(11, (page - 1) * recordsPrepage);
                psmt.setInt(12, recordsPrepage);
            }

            rs = psmt.executeQuery();

            col = OWDetailsDAOUtil.makeOWDetailsObjectCollection(rs);

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

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String session, String fromBusinessDate, String toBusinessDate)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (owBank == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return col;
        }
        if (owBranch == null)
        {
            System.out.println("WARNING : Null owBranch parameter.");
            return col;
        }

        if (desBank == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return col;
        }
        if (desBranch == null)
        {
            System.out.println("WARNING : Null desBranchCode parameter.");
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
            Vector<Integer> vtr = new Vector();

            int val_owBank = 1;
            int val_owBranch = 2;
            int val_desBank = 3;
            int val_desBranch = 4;
            int val_session = 5;
            int val_fromBusinessDate = 6;
            int val_toBusinessDate = 7;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select st.fileid, sf.bank, sf.branch, ");
            sbQuery.append("str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, sf.status, fs.StatusDesc, ");
            sbQuery.append("str_to_date(st.vdate,'%Y%m%d') as ValueDate, sf.session as WindowSession, ");
            sbQuery.append("st.RefID, st.desbankcode, st.desbranchcode, ");
            sbQuery.append("st.desacno, CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) as desacnoDec, ");
            sbQuery.append("st.desacname, CONVERT(AES_DECRYPT(st.desacname,?) USING utf8) as desacnameDec, ");
            sbQuery.append("st.desacaddr1, st.desacaddr2, st.desacaddr3, ");
            sbQuery.append("st.desactype, atd.actype as desAcTypeDesc, ");
            sbQuery.append("st.tc, st.rc, st.curid, st.purposecd, st.subpurposecd, ");
            sbQuery.append("st.amount, CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("st.orgbankcode, st.orgbranchcode, ");
            sbQuery.append("st.orgacno, CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("st.orgacname, CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("st.orgacaddr1, st.orgacaddr2, st.orgacaddr3, ");
            sbQuery.append("st.orgactype, ato.actype as orgAcTypeDesc, ");
            sbQuery.append("st.particulars, st.instruction, st.cdate,  ");
            sbQuery.append("st.inwardtime, st.setlementtime, 'No' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fs, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atd, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ato ");

            sbQuery.append("where sf.fileid = st.fileid ");
            sbQuery.append("and sf.status = fs.StatusId ");
            sbQuery.append("and st.desactype = atd.accd ");
            sbQuery.append("and st.orgactype = ato.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.bank = ? ");
                vt.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.branch = ? ");
                vt.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbankcode = ? ");
                vt.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbranchcode = ? ");
                vt.add(val_desBranch);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.session = ? ");
                vt.add(val_session);
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

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, sfr.bank, sfr.branch, ");
            sbQuery.append("str_to_date(sfr.bdate,'%Y%m%d') as BusinessDate, sfr.status, fsr.StatusDesc, ");
            sbQuery.append("str_to_date(str.vdate,'%Y%m%d') as ValueDate, sfr.session as WindowSession, ");
            sbQuery.append("str.RefID, str.desbankcode, str.desbranchcode, ");
            sbQuery.append("str.desacno, CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) as desacnoDec, ");
            sbQuery.append("str.desacname, CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8) as desacnameDec, ");
            sbQuery.append("str.desacaddr1, str.desacaddr2, str.desacaddr3, ");
            sbQuery.append("str.desactype, atdr.actype as desAcTypeDesc, ");
            sbQuery.append("str.tc, str.rc, str.curid, str.purposecd, str.subpurposecd, ");
            sbQuery.append("str.amount, CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("str.orgbankcode, str.orgbranchcode, ");
            sbQuery.append("str.orgacno, CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("str.orgacname, CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("str.orgacaddr1, str.orgacaddr2, str.orgacaddr3, ");
            sbQuery.append("str.orgactype, ator.actype as orgAcTypeDesc, ");
            sbQuery.append("str.particulars, str.instruction, str.cdate,  ");
            sbQuery.append("str.inwardtime, str.setlementtime, 'Yes' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fsr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atdr, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ator ");

            sbQuery.append("where sfr.fileid = str.fileid ");
            sbQuery.append("and sfr.status = fsr.StatusId ");
            sbQuery.append("and str.desactype = atdr.accd ");
            sbQuery.append("and str.orgactype = ator.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.bank = ? ");
                vtr.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.branch = ? ");
                vtr.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbankcode = ? ");
                vtr.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbranchcode = ? ");
                vtr.add(val_desBranch);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.session = ? ");
                vtr.add(val_session);
            }

            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toBusinessDate);
            }

            sbQuery.append("order by BusinessDate, fileid, RefID, orgbankcode, orgbranchcode ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);

            psmt.setString(1, kk);
            psmt.setString(2, kk);
            psmt.setString(3, kk);
            psmt.setString(4, kk);
            psmt.setString(5, kk);

            int i = 6;

            for (int val_item : vt)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
            }

            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;

            for (int val_item : vtr)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
            }

            rs = psmt.executeQuery();

            col = OWDetailsDAOUtil.makeOWDetailsObjectCollection(rs);

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

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (owBank == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return col;
        }
        if (owBranch == null)
        {
            System.out.println("WARNING : Null owBranch parameter.");
            return col;
        }

        if (desBank == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return col;
        }
        if (desBranch == null)
        {
            System.out.println("WARNING : Null desBranchCode parameter.");
            return col;
        }

        if (orgBank == null)
        {
            System.out.println("WARNING : Null orgBank parameter.");
            return col;
        }
        if (orgBranch == null)
        {
            System.out.println("WARNING : Null orgBranch parameter.");
            return col;
        }

        if (transCode == null)
        {
            System.out.println("WARNING : Null transCode parameter.");
            return col;
        }
        if (returnCode == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
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
            Vector<Integer> vtr = new Vector();

            int val_owBank = 1;
            int val_owBranch = 2;
            int val_desBank = 3;
            int val_desBranch = 4;
            int val_orgBank = 5;
            int val_orgBranch = 6;
            int val_transCode = 7;
            int val_returnCode = 8;
            int val_session = 9;
            int val_fromBusinessDate = 10;
            int val_toBusinessDate = 11;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select st.fileid, sf.bank, sf.branch, ");
            sbQuery.append("str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, sf.status, fs.StatusDesc, ");
            sbQuery.append("str_to_date(st.vdate,'%Y%m%d') as ValueDate, sf.session as WindowSession, ");
            sbQuery.append("st.RefID, st.desbankcode, st.desbranchcode, ");
            sbQuery.append("st.desacno, CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) as desacnoDec, ");
            sbQuery.append("st.desacname, CONVERT(AES_DECRYPT(st.desacname,?) USING utf8) as desacnameDec, ");
            sbQuery.append("st.desacaddr1, st.desacaddr2, st.desacaddr3, ");
            sbQuery.append("st.desactype, atd.actype as desAcTypeDesc, ");
            sbQuery.append("st.tc, st.rc, st.curid, st.purposecd, st.subpurposecd, ");
            sbQuery.append("st.amount, CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("st.orgbankcode, st.orgbranchcode, ");
            sbQuery.append("st.orgacno, CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("st.orgacname, CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("st.orgacaddr1, st.orgacaddr2, st.orgacaddr3, ");
            sbQuery.append("st.orgactype, ato.actype as orgAcTypeDesc, ");
            sbQuery.append("st.particulars, st.instruction, st.cdate,  ");
            sbQuery.append("st.inwardtime, st.setlementtime, 'No' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fs, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atd, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ato ");

            sbQuery.append("where sf.fileid = st.fileid ");
            sbQuery.append("and sf.status = fs.StatusId ");
            sbQuery.append("and st.desactype = atd.accd ");
            sbQuery.append("and st.orgactype = ato.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.bank = ? ");
                vt.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.branch = ? ");
                vt.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbankcode = ? ");
                vt.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbranchcode = ? ");
                vt.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbankcode = ? ");
                vt.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbranchcode = ? ");
                vt.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.tc = ? ");
                vt.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.rc = ? ");
                vt.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.session = ? ");
                vt.add(val_session);
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

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, sfr.bank, sfr.branch, ");
            sbQuery.append("str_to_date(sfr.bdate,'%Y%m%d') as BusinessDate, sfr.status, fsr.StatusDesc, ");
            sbQuery.append("str_to_date(str.vdate,'%Y%m%d') as ValueDate, sfr.session as WindowSession, ");
            sbQuery.append("str.RefID, str.desbankcode, str.desbranchcode, ");
            sbQuery.append("str.desacno, CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) as desacnoDec, ");
            sbQuery.append("str.desacname, CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8) as desacnameDec, ");
            sbQuery.append("str.desacaddr1, str.desacaddr2, str.desacaddr3, ");
            sbQuery.append("str.desactype, atdr.actype as desAcTypeDesc, ");
            sbQuery.append("str.tc, str.rc, str.curid, str.purposecd, str.subpurposecd, ");
            sbQuery.append("str.amount, CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("str.orgbankcode, str.orgbranchcode, ");
            sbQuery.append("str.orgacno, CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("str.orgacname, CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("str.orgacaddr1, str.orgacaddr2, str.orgacaddr3, ");
            sbQuery.append("str.orgactype, ator.actype as orgAcTypeDesc, ");
            sbQuery.append("str.particulars, str.instruction, str.cdate,  ");
            sbQuery.append("str.inwardtime, str.setlementtime, 'Yes' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fsr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atdr, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ator ");

            sbQuery.append("where sfr.fileid = str.fileid ");
            sbQuery.append("and sfr.status = fsr.StatusId ");
            sbQuery.append("and str.desactype = atdr.accd ");
            sbQuery.append("and str.orgactype = ator.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.bank = ? ");
                vtr.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.branch = ? ");
                vtr.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbankcode = ? ");
                vtr.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbranchcode = ? ");
                vtr.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbankcode = ? ");
                vtr.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbranchcode = ? ");
                vtr.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.tc = ? ");
                vtr.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.rc = ? ");
                vtr.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.session = ? ");
                vtr.add(val_session);
            }

            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toBusinessDate);
            }

            sbQuery.append("order by BusinessDate, fileid, RefID, orgbankcode, orgbranchcode ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);

            psmt.setString(1, kk);
            psmt.setString(2, kk);
            psmt.setString(3, kk);
            psmt.setString(4, kk);
            psmt.setString(5, kk);

            int i = 6;

            for (int val_item : vt)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }

                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
            }

            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;

            for (int val_item : vtr)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }

                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
            }

            rs = psmt.executeQuery();

            col = OWDetailsDAOUtil.makeOWDetailsObjectCollection(rs);

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

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fileId, String desActNo, String orgActNo, String minAmount, String maxAmount)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (owBank == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return col;
        }
        if (owBranch == null)
        {
            System.out.println("WARNING : Null owBranch parameter.");
            return col;
        }

        if (desBank == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return col;
        }
        if (desBranch == null)
        {
            System.out.println("WARNING : Null desBranchCode parameter.");
            return col;
        }

        if (orgBank == null)
        {
            System.out.println("WARNING : Null orgBank parameter.");
            return col;
        }
        if (orgBranch == null)
        {
            System.out.println("WARNING : Null orgBranch parameter.");
            return col;
        }

        if (transCode == null)
        {
            System.out.println("WARNING : Null transCode parameter.");
            return col;
        }
        if (returnCode == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
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
            Vector<Integer> vtr = new Vector();

            int val_owBank = 1;
            int val_owBranch = 2;
            int val_desBank = 3;
            int val_desBranch = 4;
            int val_orgBank = 5;
            int val_orgBranch = 6;
            int val_transCode = 7;
            int val_returnCode = 8;
            int val_session = 9;
            int val_fromBusinessDate = 10;
            int val_toBusinessDate = 11;
            int val_fileId = 12;
            int val_desActNo = 13;
            int val_orgActNo = 14;
            int val_minAmount = 15;
            int val_maxAmount = 16;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select st.fileid, sf.bank, sf.branch, ");
            sbQuery.append("str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, sf.status, fs.StatusDesc, ");
            sbQuery.append("str_to_date(st.vdate,'%Y%m%d') as ValueDate, sf.session as WindowSession, ");
            sbQuery.append("st.RefID, st.desbankcode, st.desbranchcode, ");
            sbQuery.append("st.desacno, CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) as desacnoDec, ");
            sbQuery.append("st.desacname, CONVERT(AES_DECRYPT(st.desacname,?) USING utf8) as desacnameDec, ");
            sbQuery.append("st.desacaddr1, st.desacaddr2, st.desacaddr3, ");
            sbQuery.append("st.desactype, atd.actype as desAcTypeDesc, ");
            sbQuery.append("st.tc, st.rc, st.curid, st.purposecd, st.subpurposecd, ");
            sbQuery.append("st.amount, CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("st.orgbankcode, st.orgbranchcode, ");
            sbQuery.append("st.orgacno, CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("st.orgacname, CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("st.orgacaddr1, st.orgacaddr2, st.orgacaddr3, ");
            sbQuery.append("st.orgactype, ato.actype as orgAcTypeDesc, ");
            sbQuery.append("st.particulars, st.instruction, st.cdate,  ");
            sbQuery.append("st.inwardtime, st.setlementtime, 'No' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fs, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atd, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ato ");

            sbQuery.append("where sf.fileid = st.fileid ");
            sbQuery.append("and sf.status = fs.StatusId ");
            sbQuery.append("and st.desactype = atd.accd ");
            sbQuery.append("and st.orgactype = ato.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.bank = ? ");
                vt.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.branch = ? ");
                vt.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbankcode = ? ");
                vt.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbranchcode = ? ");
                vt.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbankcode = ? ");
                vt.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbranchcode = ? ");
                vt.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.tc = ? ");
                vt.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.rc = ? ");
                vt.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.session = ? ");
                vt.add(val_session);
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

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sf.fileid like ? ");
                vt.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) like ? ");
                vt.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) like ? ");
                vt.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vt.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vt.add(val_maxAmount);
            }

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, sfr.bank, sfr.branch, ");
            sbQuery.append("str_to_date(sfr.bdate,'%Y%m%d') as BusinessDate, sfr.status, fsr.StatusDesc, ");
            sbQuery.append("str_to_date(str.vdate,'%Y%m%d') as ValueDate, sfr.session as WindowSession, ");
            sbQuery.append("str.RefID, str.desbankcode, str.desbranchcode, ");
            sbQuery.append("str.desacno, CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) as desacnoDec, ");
            sbQuery.append("str.desacname, CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8) as desacnameDec, ");
            sbQuery.append("str.desacaddr1, str.desacaddr2, str.desacaddr3, ");
            sbQuery.append("str.desactype, atdr.actype as desAcTypeDesc, ");
            sbQuery.append("str.tc, str.rc, str.curid, str.purposecd, str.subpurposecd, ");
            sbQuery.append("str.amount, CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("str.orgbankcode, str.orgbranchcode, ");
            sbQuery.append("str.orgacno, CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("str.orgacname, CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("str.orgacaddr1, str.orgacaddr2, str.orgacaddr3, ");
            sbQuery.append("str.orgactype, ator.actype as orgAcTypeDesc, ");
            sbQuery.append("str.particulars, str.instruction, str.cdate,  ");
            sbQuery.append("str.inwardtime, str.setlementtime, 'Yes' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fsr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atdr, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ator ");

            sbQuery.append("where sfr.fileid = str.fileid ");
            sbQuery.append("and sfr.status = fsr.StatusId ");
            sbQuery.append("and str.desactype = atdr.accd ");
            sbQuery.append("and str.orgactype = ator.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.bank = ? ");
                vtr.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.branch = ? ");
                vtr.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbankcode = ? ");
                vtr.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbranchcode = ? ");
                vtr.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbankcode = ? ");
                vtr.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbranchcode = ? ");
                vtr.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.tc = ? ");
                vtr.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.rc = ? ");
                vtr.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.session = ? ");
                vtr.add(val_session);
            }

            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toBusinessDate);
            }

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sfr.fileid like ? ");
                vtr.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) like ? ");
                vtr.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) like ? ");
                vtr.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vtr.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vtr.add(val_maxAmount);
            }

            sbQuery.append("order by BusinessDate, fileid, RefID, orgbankcode, orgbranchcode ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);

            psmt.setString(1, kk);
            psmt.setString(2, kk);
            psmt.setString(3, kk);
            psmt.setString(4, kk);
            psmt.setString(5, kk);

            int i = 6;

            for (int val_item : vt)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
            }

            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;

            for (int val_item : vtr)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
            }

            rs = psmt.executeQuery();

            col = OWDetailsDAOUtil.makeOWDetailsObjectCollection(rs);

        }
        catch (Exception e)
        {
            msg = e.getMessage();
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

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate, String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String minAmount, String maxAmount)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (owBank == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return col;
        }
        if (owBranch == null)
        {
            System.out.println("WARNING : Null owBranch parameter.");
            return col;
        }

        if (desBank == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return col;
        }
        if (desBranch == null)
        {
            System.out.println("WARNING : Null desBranchCode parameter.");
            return col;
        }

        if (orgBank == null)
        {
            System.out.println("WARNING : Null orgBank parameter.");
            return col;
        }
        if (orgBranch == null)
        {
            System.out.println("WARNING : Null orgBranch parameter.");
            return col;
        }

        if (transCode == null)
        {
            System.out.println("WARNING : Null transCode parameter.");
            return col;
        }
        if (returnCode == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
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
            Vector<Integer> vtr = new Vector();

            int val_owBank = 1;
            int val_owBranch = 2;
            int val_desBank = 3;
            int val_desBranch = 4;
            int val_orgBank = 5;
            int val_orgBranch = 6;
            int val_transCode = 7;
            int val_returnCode = 8;
            int val_session = 9;
            int val_fromBusinessDate = 10;
            int val_toBusinessDate = 11;
            int val_fileId = 12;
            int val_desActNo = 13;
            int val_orgActNo = 14;
            int val_minAmount = 15;
            int val_maxAmount = 16;
            int val_fromValueDate = 17;
            int val_toValueDate = 18;
            int val_desActName = 19;
            int val_orgActName = 20;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select st.fileid, sf.bank, sf.branch, ");
            sbQuery.append("str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, sf.status, fs.StatusDesc, ");
            sbQuery.append("str_to_date(st.vdate,'%Y%m%d') as ValueDate, sf.session as WindowSession, ");
            sbQuery.append("st.RefID, st.desbankcode, st.desbranchcode, ");
            sbQuery.append("st.desacno, CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) as desacnoDec, ");
            sbQuery.append("st.desacname, CONVERT(AES_DECRYPT(st.desacname,?) USING utf8) as desacnameDec, ");
            sbQuery.append("st.desacaddr1, st.desacaddr2, st.desacaddr3, ");
            sbQuery.append("st.desactype, atd.actype as desAcTypeDesc, ");
            sbQuery.append("st.tc, st.rc, st.curid, st.purposecd, st.subpurposecd, ");
            sbQuery.append("st.amount, CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("st.orgbankcode, st.orgbranchcode, ");
            sbQuery.append("st.orgacno, CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("st.orgacname, CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("st.orgacaddr1, st.orgacaddr2, st.orgacaddr3, ");
            sbQuery.append("st.orgactype, ato.actype as orgAcTypeDesc, ");
            sbQuery.append("st.particulars, st.instruction, st.cdate,  ");
            sbQuery.append("st.inwardtime, st.setlementtime, 'No' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fs, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atd, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ato ");

            sbQuery.append("where sf.fileid = st.fileid ");
            sbQuery.append("and sf.status = fs.StatusId ");
            sbQuery.append("and st.desactype = atd.accd ");
            sbQuery.append("and st.orgactype = ato.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.bank = ? ");
                vt.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.branch = ? ");
                vt.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbankcode = ? ");
                vt.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbranchcode = ? ");
                vt.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbankcode = ? ");
                vt.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbranchcode = ? ");
                vt.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.tc = ? ");
                vt.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.rc = ? ");
                vt.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.session = ? ");
                vt.add(val_session);
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

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sf.fileid like ? ");
                vt.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) like ? ");
                vt.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) like ? ");
                vt.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vt.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vt.add(val_maxAmount);
            }

            if (fromValueDate != null && fromValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(st.vdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromValueDate);
            }
            if (toValueDate != null && toValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(st.vdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toValueDate);
            }

            if (desActName != null && desActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(st.desacname,?) USING utf8)) like upper(?) ");
                vt.add(val_desActName);
            }

            if (orgActName != null && orgActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8)) like upper(?) ");
                vt.add(val_orgActName);
            }

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, sfr.bank, sfr.branch, ");
            sbQuery.append("str_to_date(sfr.bdate,'%Y%m%d') as BusinessDate, sfr.status, fsr.StatusDesc, ");
            sbQuery.append("str_to_date(str.vdate,'%Y%m%d') as ValueDate, sfr.session as WindowSession, ");
            sbQuery.append("str.RefID, str.desbankcode, str.desbranchcode, ");
            sbQuery.append("str.desacno, CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) as desacnoDec, ");
            sbQuery.append("str.desacname, CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8) as desacnameDec, ");
            sbQuery.append("str.desacaddr1, str.desacaddr2, str.desacaddr3, ");
            sbQuery.append("str.desactype, atdr.actype as desAcTypeDesc, ");
            sbQuery.append("str.tc, str.rc, str.curid, str.purposecd, str.subpurposecd, ");
            sbQuery.append("str.amount, CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("str.orgbankcode, str.orgbranchcode, ");
            sbQuery.append("str.orgacno, CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("str.orgacname, CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("str.orgacaddr1, str.orgacaddr2, str.orgacaddr3, ");
            sbQuery.append("str.orgactype, ator.actype as orgAcTypeDesc, ");
            sbQuery.append("str.particulars, str.instruction, str.cdate,  ");
            sbQuery.append("str.inwardtime, str.setlementtime, 'Yes' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fsr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atdr, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ator ");

            sbQuery.append("where sfr.fileid = str.fileid ");
            sbQuery.append("and sfr.status = fsr.StatusId ");
            sbQuery.append("and str.desactype = atdr.accd ");
            sbQuery.append("and str.orgactype = ator.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.bank = ? ");
                vtr.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.branch = ? ");
                vtr.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbankcode = ? ");
                vtr.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbranchcode = ? ");
                vtr.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbankcode = ? ");
                vtr.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbranchcode = ? ");
                vtr.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.tc = ? ");
                vtr.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.rc = ? ");
                vtr.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.session = ? ");
                vtr.add(val_session);
            }

            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toBusinessDate);
            }

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sfr.fileid like ? ");
                vtr.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) like ? ");
                vtr.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) like ? ");
                vtr.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vtr.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vtr.add(val_maxAmount);
            }

            if (fromValueDate != null && fromValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(str.vdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromValueDate);
            }
            if (toValueDate != null && toValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(str.vdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toValueDate);
            }

            if (desActName != null && desActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8)) like upper(?) ");
                vtr.add(val_desActName);
            }

            if (orgActName != null && orgActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8)) like upper(?) ");
                vtr.add(val_orgActName);
            }

            sbQuery.append("order by BusinessDate, fileid, RefID, orgbankcode, orgbranchcode ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);

            psmt.setString(1, kk);
            psmt.setString(2, kk);
            psmt.setString(3, kk);
            psmt.setString(4, kk);
            psmt.setString(5, kk);

            int i = 6;

            for (int val_item : vt)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
                if (val_item == val_fromValueDate)
                {
                    psmt.setString(i, fromValueDate);
                    i++;
                }
                if (val_item == val_toValueDate)
                {
                    psmt.setString(i, toValueDate);
                    i++;
                }
                if (val_item == val_desActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + desActName + "%");
                    i++;
                }
                if (val_item == val_orgActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + orgActName + "%");
                    i++;
                }
            }

            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;

            for (int val_item : vtr)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
                if (val_item == val_fromValueDate)
                {
                    psmt.setString(i, fromValueDate);
                    i++;
                }
                if (val_item == val_toValueDate)
                {
                    psmt.setString(i, toValueDate);
                    i++;
                }
                if (val_item == val_desActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + desActName + "%");
                    i++;
                }
                if (val_item == val_orgActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + orgActName + "%");
                    i++;
                }
            }

            rs = psmt.executeQuery();

            col = OWDetailsDAOUtil.makeOWDetailsObjectCollection(rs);

        }
        catch (Exception e)
        {
            msg = e.getMessage();
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

    public long getRecordCountOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate, String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String status, String minAmount, String maxAmount)
    {
        long recCount = 0;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (owBank == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return recCount;
        }
        if (owBranch == null)
        {
            System.out.println("WARNING : Null owBranch parameter.");
            return recCount;
        }

        if (desBank == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return recCount;
        }
        if (desBranch == null)
        {
            System.out.println("WARNING : Null desBranchCode parameter.");
            return recCount;
        }

        if (orgBank == null)
        {
            System.out.println("WARNING : Null orgBank parameter.");
            return recCount;
        }
        if (orgBranch == null)
        {
            System.out.println("WARNING : Null orgBranch parameter.");
            return recCount;
        }

        if (transCode == null)
        {
            System.out.println("WARNING : Null transCode parameter.");
            return recCount;
        }
        if (returnCode == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
            return recCount;
        }

        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return recCount;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return recCount;
        }

        if (fromBusinessDate == null)
        {
            System.out.println("WARNING : Null fromBusinessDate parameter.");
            return recCount;
        }

        if (toBusinessDate == null)
        {
            System.out.println("WARNING : Null toBusinessDate parameter.");
            return recCount;
        }

        //System.out.println("Inside getRecordCountOWDetails");

        try
        {

            Vector<Integer> vt = new Vector();
            Vector<Integer> vtr = new Vector();

            int val_owBank = 1;
            int val_owBranch = 2;
            int val_desBank = 3;
            int val_desBranch = 4;
            int val_orgBank = 5;
            int val_orgBranch = 6;
            int val_transCode = 7;
            int val_returnCode = 8;
            int val_session = 9;
            int val_fromBusinessDate = 10;
            int val_toBusinessDate = 11;
            int val_fileId = 12;
            int val_desActNo = 13;
            int val_orgActNo = 14;
            int val_minAmount = 15;
            int val_maxAmount = 16;
            int val_fromValueDate = 17;
            int val_toValueDate = 18;
            int val_desActName = 19;
            int val_orgActName = 20;
            int val_status = 21;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(*) as rowCount from (");

            sbQuery.append("select st.fileid, st.RefID, 'No' as IsReturn from ");
            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st ");

            sbQuery.append("where sf.fileid = st.fileid ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.bank = ? ");
                vt.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.branch = ? ");
                vt.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbankcode = ? ");
                vt.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbranchcode = ? ");
                vt.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbankcode = ? ");
                vt.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbranchcode = ? ");
                vt.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.tc = ? ");
                vt.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.rc = ? ");
                vt.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.session = ? ");
                vt.add(val_session);
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

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sf.fileid like ? ");
                vt.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) like ? ");
                vt.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) like ? ");
                vt.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vt.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vt.add(val_maxAmount);
            }

            if (fromValueDate != null && fromValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(st.vdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromValueDate);
            }
            if (toValueDate != null && toValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(st.vdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toValueDate);
            }

            if (desActName != null && desActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(st.desacname,?) USING utf8)) like upper(?) ");
                vt.add(val_desActName);
            }

            if (orgActName != null && orgActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8)) like upper(?) ");
                vt.add(val_orgActName);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.status = ? ");
                vt.add(val_status);
            }

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, str.RefID, 'Yes' as IsReturn from ");
            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str ");

            sbQuery.append("where sfr.fileid = str.fileid ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.bank = ? ");
                vtr.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.branch = ? ");
                vtr.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbankcode = ? ");
                vtr.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbranchcode = ? ");
                vtr.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbankcode = ? ");
                vtr.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbranchcode = ? ");
                vtr.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.tc = ? ");
                vtr.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.rc = ? ");
                vtr.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.session = ? ");
                vtr.add(val_session);
            }

            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toBusinessDate);
            }

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sfr.fileid like ? ");
                vtr.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) like ? ");
                vtr.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) like ? ");
                vtr.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vtr.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vtr.add(val_maxAmount);
            }

            if (fromValueDate != null && fromValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(str.vdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromValueDate);
            }
            if (toValueDate != null && toValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(str.vdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toValueDate);
            }

            if (desActName != null && desActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8)) like upper(?) ");
                vtr.add(val_desActName);
            }

            if (orgActName != null && orgActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8)) like upper(?) ");
                vtr.add(val_orgActName);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.status = ? ");
                vtr.add(val_status);
            }

            sbQuery.append(") as stf");

            //System.out.println("sbQuery>>>" + sbQuery.toString());
            
            
            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
                if (val_item == val_fromValueDate)
                {
                    psmt.setString(i, fromValueDate);
                    i++;
                }
                if (val_item == val_toValueDate)
                {
                    psmt.setString(i, toValueDate);
                    i++;
                }
                if (val_item == val_desActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + desActName + "%");
                    i++;
                }
                if (val_item == val_orgActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + orgActName + "%");
                    i++;
                }

                if (val_item == val_status)
                {
                    psmt.setString(i, status);
                    i++;
                }
            }

            for (int val_item : vtr)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
                if (val_item == val_fromValueDate)
                {
                    psmt.setString(i, fromValueDate);
                    i++;
                }
                if (val_item == val_toValueDate)
                {
                    psmt.setString(i, toValueDate);
                    i++;
                }
                if (val_item == val_desActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + desActName + "%");
                    i++;
                }
                if (val_item == val_orgActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + orgActName + "%");
                    i++;
                }

                if (val_item == val_status)
                {
                    psmt.setString(i, status);
                    i++;
                }
            }

            rs = psmt.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();

                //System.out.println(rs.getDouble("rowCount"));
                recCount = rs.getLong("rowCount");
            }

        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return recCount;
    }

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate, String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String status, String minAmount, String maxAmount, int page, int recordsPrepage)
    {
        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (owBank == null)
        {
            System.out.println("WARNING : Null owBank parameter.");
            return col;
        }
        if (owBranch == null)
        {
            System.out.println("WARNING : Null owBranch parameter.");
            return col;
        }

        if (desBank == null)
        {
            System.out.println("WARNING : Null desBankCode parameter.");
            return col;
        }
        if (desBranch == null)
        {
            System.out.println("WARNING : Null desBranchCode parameter.");
            return col;
        }

        if (orgBank == null)
        {
            System.out.println("WARNING : Null orgBank parameter.");
            return col;
        }
        if (orgBranch == null)
        {
            System.out.println("WARNING : Null orgBranch parameter.");
            return col;
        }

        if (transCode == null)
        {
            System.out.println("WARNING : Null transCode parameter.");
            return col;
        }
        if (returnCode == null)
        {
            System.out.println("WARNING : Null returnCode parameter.");
            return col;
        }

        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
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
            Vector<Integer> vtr = new Vector();

            int val_owBank = 1;
            int val_owBranch = 2;
            int val_desBank = 3;
            int val_desBranch = 4;
            int val_orgBank = 5;
            int val_orgBranch = 6;
            int val_transCode = 7;
            int val_returnCode = 8;
            int val_session = 9;
            int val_fromBusinessDate = 10;
            int val_toBusinessDate = 11;
            int val_fileId = 12;
            int val_desActNo = 13;
            int val_orgActNo = 14;
            int val_minAmount = 15;
            int val_maxAmount = 16;
            int val_fromValueDate = 17;
            int val_toValueDate = 18;
            int val_desActName = 19;
            int val_orgActName = 20;
            int val_status = 21;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select st.fileid, sf.bank, sf.branch, ");
            sbQuery.append("str_to_date(sf.bdate,'%Y%m%d') as BusinessDate, sf.status, fs.StatusDesc, ");
            sbQuery.append("str_to_date(st.vdate,'%Y%m%d') as ValueDate, sf.session as WindowSession, ");
            sbQuery.append("st.RefID, st.desbankcode, st.desbranchcode, ");
            sbQuery.append("st.desacno, CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) as desacnoDec, ");
            sbQuery.append("st.desacname, CONVERT(AES_DECRYPT(st.desacname,?) USING utf8) as desacnameDec, ");
            sbQuery.append("st.desacaddr1, st.desacaddr2, st.desacaddr3, ");
            sbQuery.append("st.desactype, atd.actype as desAcTypeDesc, ");
            sbQuery.append("st.tc, st.rc, st.curid, st.purposecd, st.subpurposecd, ");
            sbQuery.append("st.amount, CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("st.orgbankcode, st.orgbranchcode, ");
            sbQuery.append("st.orgacno, CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("st.orgacname, CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("st.orgacaddr1, st.orgacaddr2, st.orgacaddr3, ");
            sbQuery.append("st.orgactype, ato.actype as orgAcTypeDesc, ");
            sbQuery.append("st.particulars, st.instruction, st.cdate,  ");
            sbQuery.append("st.inwardtime, st.setlementtime, 'No' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sf, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fs, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction + " st, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atd, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ato ");

            sbQuery.append("where sf.fileid = st.fileid ");
            sbQuery.append("and sf.status = fs.StatusId ");
            sbQuery.append("and st.desactype = atd.accd ");
            sbQuery.append("and st.orgactype = ato.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.bank = ? ");
                vt.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.branch = ? ");
                vt.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbankcode = ? ");
                vt.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.desbranchcode = ? ");
                vt.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbankcode = ? ");
                vt.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.orgbranchcode = ? ");
                vt.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.tc = ? ");
                vt.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and st.rc = ? ");
                vt.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.session = ? ");
                vt.add(val_session);
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

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sf.fileid like ? ");
                vt.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.desacno,?) USING utf8) like ? ");
                vt.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(st.orgacno,?)  USING utf8) like ? ");
                vt.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vt.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(st.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vt.add(val_maxAmount);
            }

            if (fromValueDate != null && fromValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(st.vdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromValueDate);
            }
            if (toValueDate != null && toValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(st.vdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toValueDate);
            }

            if (desActName != null && desActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(st.desacname,?) USING utf8)) like upper(?) ");
                vt.add(val_desActName);
            }

            if (orgActName != null && orgActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(st.orgacname,?)  USING utf8)) like upper(?) ");
                vt.add(val_orgActName);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sf.status = ? ");
                vt.add(val_status);
            }

            sbQuery.append("union ");

            sbQuery.append("select str.fileid, sfr.bank, sfr.branch, ");
            sbQuery.append("str_to_date(sfr.bdate,'%Y%m%d') as BusinessDate, sfr.status, fsr.StatusDesc, ");
            sbQuery.append("str_to_date(str.vdate,'%Y%m%d') as ValueDate, sfr.session as WindowSession, ");
            sbQuery.append("str.RefID, str.desbankcode, str.desbranchcode, ");
            sbQuery.append("str.desacno, CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) as desacnoDec, ");
            sbQuery.append("str.desacname, CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8) as desacnameDec, ");
            sbQuery.append("str.desacaddr1, str.desacaddr2, str.desacaddr3, ");
            sbQuery.append("str.desactype, atdr.actype as desAcTypeDesc, ");
            sbQuery.append("str.tc, str.rc, str.curid, str.purposecd, str.subpurposecd, ");
            sbQuery.append("str.amount, CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) as amountDec, ");
            sbQuery.append("str.orgbankcode, str.orgbranchcode, ");
            sbQuery.append("str.orgacno, CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) as orgacnoDec, ");
            sbQuery.append("str.orgacname, CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8) as orgacnameDec, ");
            sbQuery.append("str.orgacaddr1, str.orgacaddr2, str.orgacaddr3, ");
            sbQuery.append("str.orgactype, ator.actype as orgAcTypeDesc, ");
            sbQuery.append("str.particulars, str.instruction, str.cdate,  ");
            sbQuery.append("str.inwardtime, str.setlementtime, 'Yes' as IsReturn from ");

            sbQuery.append(LCPL_Constants.tbl_slipfile + " sfr, ");
            sbQuery.append(LCPL_Constants.tbl_status + " fsr, ");
            sbQuery.append(LCPL_Constants.tbl_sliptransaction_return + " str, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " atdr, ");
            sbQuery.append(LCPL_Constants.tbl_accountType + " ator ");

            sbQuery.append("where sfr.fileid = str.fileid ");
            sbQuery.append("and sfr.status = fsr.StatusId ");
            sbQuery.append("and str.desactype = atdr.accd ");
            sbQuery.append("and str.orgactype = ator.accd ");

            if (!owBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.bank = ? ");
                vtr.add(val_owBank);
            }

            if (!owBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.branch = ? ");
                vtr.add(val_owBranch);
            }

            if (!desBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbankcode = ? ");
                vtr.add(val_desBank);
            }

            if (!desBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.desbranchcode = ? ");
                vtr.add(val_desBranch);
            }

            if (!orgBank.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbankcode = ? ");
                vtr.add(val_orgBank);
            }

            if (!orgBranch.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.orgbranchcode = ? ");
                vtr.add(val_orgBranch);
            }

            if (!transCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.tc = ? ");
                vtr.add(val_transCode);
            }

            if (!returnCode.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str.rc = ? ");
                vtr.add(val_returnCode);
            }

            if (!session.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.session = ? ");
                vtr.add(val_session);
            }

            if (!fromBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and str_to_date(sfr.bdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toBusinessDate);
            }

            if (fileId != null && fileId.length() > 0)
            {
                sbQuery.append("and sfr.fileid like ? ");
                vtr.add(val_fileId);
            }

            if (desActNo != null && desActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.desacno,?)  USING utf8) like ? ");
                vtr.add(val_desActNo);
            }

            if (orgActNo != null && orgActNo.length() > 0)
            {
                sbQuery.append("and CONVERT(AES_DECRYPT(str.orgacno,?)  USING utf8) like ? ");
                vtr.add(val_orgActNo);
            }

            if (minAmount != null && minAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) >= ? ");
                vtr.add(val_minAmount);
            }

            if (maxAmount != null && maxAmount.length() > 0)
            {
                sbQuery.append("and CAST(CONVERT(AES_DECRYPT(str.amount,?)  USING utf8) AS UNSIGNED) <= ? ");
                vtr.add(val_maxAmount);
            }

            if (fromValueDate != null && fromValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(str.vdate,'%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_fromValueDate);
            }
            if (toValueDate != null && toValueDate.length() > 0)
            {
                sbQuery.append("and str_to_date(str.vdate,'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vtr.add(val_toValueDate);
            }

            if (desActName != null && desActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(str.desacname,?)  USING utf8)) like upper(?) ");
                vtr.add(val_desActName);
            }

            if (orgActName != null && orgActName.length() > 0)
            {
                sbQuery.append("and upper(CONVERT(AES_DECRYPT(str.orgacname,?)  USING utf8)) like upper(?) ");
                vtr.add(val_orgActName);
            }

            if (!status.equals(LCPL_Constants.status_all))
            {
                sbQuery.append("and sfr.status = ? ");
                vtr.add(val_status);
            }

            sbQuery.append("order by BusinessDate, fileid, RefID, orgbankcode, orgbranchcode ");

            sbQuery.append("limit ?,? ");

            System.out.println("sbQuery2>>" + sbQuery.toString());
            
            psmt = con.prepareStatement(sbQuery.toString());

            String kk = DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_1, LCPL_Constants.param_type_pwd) + DAOFactory.getParameterDAO().getParamValue(LCPL_Constants.param_id_db_enc_pw_2, LCPL_Constants.param_type_pwd);
            
            System.out.println("sbQuery2 KK>>" + kk);
            
            psmt.setString(1, kk);
            psmt.setString(2, kk);
            psmt.setString(3, kk);
            psmt.setString(4, kk);
            psmt.setString(5, kk);

            int i = 6;

            for (int val_item : vt)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
                if (val_item == val_fromValueDate)
                {
                    psmt.setString(i, fromValueDate);
                    i++;
                }
                if (val_item == val_toValueDate)
                {
                    psmt.setString(i, toValueDate);
                    i++;
                }
                if (val_item == val_desActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + desActName + "%");
                    i++;
                }
                if (val_item == val_orgActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + orgActName + "%");
                    i++;
                }
                if (val_item == val_status)
                {
                    psmt.setString(i, status);
                    i++;
                }
            }

            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;
            psmt.setString(i, kk);
            i++;

            for (int val_item : vtr)
            {
                if (val_item == val_owBank)
                {
                    psmt.setString(i, owBank);
                    i++;
                }
                if (val_item == val_owBranch)
                {
                    psmt.setString(i, owBranch);
                    i++;
                }
                if (val_item == val_desBank)
                {
                    psmt.setString(i, desBank);
                    i++;
                }
                if (val_item == val_desBranch)
                {
                    psmt.setString(i, desBranch);
                    i++;
                }
                if (val_item == val_orgBank)
                {
                    psmt.setString(i, orgBank);
                    i++;
                }
                if (val_item == val_orgBranch)
                {
                    psmt.setString(i, orgBranch);
                    i++;
                }
                if (val_item == val_transCode)
                {
                    psmt.setString(i, transCode);
                    i++;
                }
                if (val_item == val_returnCode)
                {
                    psmt.setString(i, returnCode);
                    i++;
                }
                if (val_item == val_session)
                {
                    psmt.setString(i, session);
                    i++;
                }
                if (val_item == val_fromBusinessDate)
                {
                    psmt.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    psmt.setString(i, toBusinessDate);
                    i++;
                }
                if (val_item == val_fileId)
                {
                    psmt.setString(i, fileId + "%");
                    i++;
                }
                if (val_item == val_desActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, desActNo + "%");
                    i++;
                }
                if (val_item == val_orgActNo)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, orgActNo + "%");
                    i++;
                }
                if (val_item == val_minAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(minAmount));
                    i++;
                }
                if (val_item == val_maxAmount)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setLong(i, Long.parseLong(maxAmount));
                    i++;
                }
                if (val_item == val_fromValueDate)
                {
                    psmt.setString(i, fromValueDate);
                    i++;
                }
                if (val_item == val_toValueDate)
                {
                    psmt.setString(i, toValueDate);
                    i++;
                }
                if (val_item == val_desActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + desActName + "%");
                    i++;
                }
                if (val_item == val_orgActName)
                {
                    psmt.setString(i, kk);
                    i++;
                    psmt.setString(i, "%" + orgActName + "%");
                    i++;
                }
                if (val_item == val_status)
                {
                    psmt.setString(i, status);
                    i++;
                }
            }

            psmt.setInt(i, (page - 1) * recordsPrepage);
            i++;
            psmt.setInt(i, recordsPrepage);

            rs = psmt.executeQuery();

            col = OWDetailsDAOUtil.makeOWDetailsObjectCollection(rs);

        }
        catch (Exception e)
        {
            msg = e.getMessage();
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

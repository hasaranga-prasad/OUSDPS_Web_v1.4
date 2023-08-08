/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao;

import lk.com.ttsl.ousdps.dao.accounttype.AccountTypeDAO;
import lk.com.ttsl.ousdps.dao.accounttype.AccountTypeDAOImpl;
import lk.com.ttsl.ousdps.dao.adhoccharges.AdhocChargesDAO;
import lk.com.ttsl.ousdps.dao.adhoccharges.AdhocChargesDAOImpl;
import lk.com.ttsl.ousdps.dao.reportType.ReportTypeDAO;
import lk.com.ttsl.ousdps.dao.reportType.ReportTypeDAOImpl;
import lk.com.ttsl.ousdps.dao.bank.BankDAO;
import lk.com.ttsl.ousdps.dao.bank.BankDAOImpl;
import lk.com.ttsl.ousdps.dao.batch.BatchDAO;
import lk.com.ttsl.ousdps.dao.batch.BatchDAOImpl;
import lk.com.ttsl.ousdps.dao.billingadhoccharges.BillingAdhocChargesDAO;
import lk.com.ttsl.ousdps.dao.billingadhoccharges.BillingAdhocChargesDAOImpl;
import lk.com.ttsl.ousdps.dao.branch.BranchDAO;
import lk.com.ttsl.ousdps.dao.branch.BranchDAOImpl;
import lk.com.ttsl.ousdps.dao.calendar.BCMCalendarDAO;
import lk.com.ttsl.ousdps.dao.calendar.BCMCalendarDAOImpl;
import lk.com.ttsl.ousdps.dao.certificates.CertificateDAO;
import lk.com.ttsl.ousdps.dao.certificates.CertificateDAOImpl;
import lk.com.ttsl.ousdps.dao.confirmstatus.ConfirmStatusDAO;
import lk.com.ttsl.ousdps.dao.confirmstatus.ConfirmStatusDAOImpl;
import lk.com.ttsl.ousdps.dao.curuploadingfile.CurUploadingFileDAO;
import lk.com.ttsl.ousdps.dao.curuploadingfile.CurUploadingFileDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.CustomDAO;
import lk.com.ttsl.ousdps.dao.custom.CustomDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.archivalowdetails.ArchivalOWDetailsDAO;
import lk.com.ttsl.ousdps.dao.custom.archivalowdetails.ArchivalOWDetailsDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.batch.CustomBatchDAO;
import lk.com.ttsl.ousdps.dao.custom.batch.CustomBatchDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.file.FileInfoDAO;
import lk.com.ttsl.ousdps.dao.custom.file.FileInfoDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.inwardfiles.InwardFilesDAO;
import lk.com.ttsl.ousdps.dao.custom.inwardfiles.InwardFilesDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.message.CustomMsgDAO;
import lk.com.ttsl.ousdps.dao.custom.message.CustomMsgDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.owdetails.OWDetailsDAO;
import lk.com.ttsl.ousdps.dao.custom.owdetails.OWDetailsDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.report.ReportDAO;
import lk.com.ttsl.ousdps.dao.custom.report.ReportDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.slipsowconfirmation.SLIPSOWConfirmationDAO;
import lk.com.ttsl.ousdps.dao.custom.slipsowconfirmation.SLIPSOWConfirmationDAOImpl;
import lk.com.ttsl.ousdps.dao.custom.user.UserDAO;
import lk.com.ttsl.ousdps.dao.custom.user.UserDAOImpl;
import lk.com.ttsl.ousdps.dao.fileStatus.FileStatusDAO;
import lk.com.ttsl.ousdps.dao.fileStatus.FileStatusDAOImpl;
import lk.com.ttsl.ousdps.dao.log.LogDAO;
import lk.com.ttsl.ousdps.dao.log.LogDAOImpl;
import lk.com.ttsl.ousdps.dao.logType.LogTypeDAO;
import lk.com.ttsl.ousdps.dao.logType.LogTypeDAOImpl;
import lk.com.ttsl.ousdps.dao.message.body.MsgBodyDAO;
import lk.com.ttsl.ousdps.dao.message.body.MsgBodyDAOImpl;
import lk.com.ttsl.ousdps.dao.message.header.MsgHeaderDAO;
import lk.com.ttsl.ousdps.dao.message.header.MsgHeaderDAOImpl;
import lk.com.ttsl.ousdps.dao.message.priority.MsgPriorityDAO;
import lk.com.ttsl.ousdps.dao.message.priority.MsgPriorityDAOImpl;
import lk.com.ttsl.ousdps.dao.parameter.ParameterDAO;
import lk.com.ttsl.ousdps.dao.parameter.ParameterDAOImpl;
import lk.com.ttsl.ousdps.dao.purposecode.PurposeCodeDAO;
import lk.com.ttsl.ousdps.dao.purposecode.PurposeCodeDAOImpl;
import lk.com.ttsl.ousdps.dao.rejectreason.RejectReasonDAO;
import lk.com.ttsl.ousdps.dao.rejectreason.RejectReasonDAOImpl;
import lk.com.ttsl.ousdps.dao.reportmap.ReportMapDAO;
import lk.com.ttsl.ousdps.dao.reportmap.ReportMapDAOImpl;
import lk.com.ttsl.ousdps.dao.returnreason.ReturnReasonDAO;
import lk.com.ttsl.ousdps.dao.returnreason.ReturnReasonDAOImpl;
import lk.com.ttsl.ousdps.dao.subpurposecode.SubPurposeCodeDAO;
import lk.com.ttsl.ousdps.dao.subpurposecode.SubPurposeCodeDAOImpl;
import lk.com.ttsl.ousdps.dao.transactiontype.TransactionTypeDAO;
import lk.com.ttsl.ousdps.dao.transactiontype.TransactionTypeDAOImpl;
import lk.com.ttsl.ousdps.dao.user.pwd.history.PWD_HistoryDAO;
import lk.com.ttsl.ousdps.dao.user.pwd.history.PWD_HistoryDAOImpl;
import lk.com.ttsl.ousdps.dao.userLevel.UserLevelDAO;
import lk.com.ttsl.ousdps.dao.userLevel.UserLevelDAOImpl;
import lk.com.ttsl.ousdps.dao.window.WindowDAO;
import lk.com.ttsl.ousdps.dao.window.WindowDAOImpl;

/**
 *
 * @author Dinesh
 */
public class DAOFactory
{

    /**
     * 
     */
    private DAOFactory()
    {
    }

    /**
     * 
     * @return 
     */
    public static AccountTypeDAO getAccountTypeDAO()
    {
        return new AccountTypeDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static AdhocChargesDAO getAdhocChargesDAO()
    {
        return new AdhocChargesDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static ArchivalOWDetailsDAO getArchivalOWDetailsDAO()
    {
        return new ArchivalOWDetailsDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static BankDAO getBankDAO()
    {
        return new BankDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static BatchDAO getBatchDAO()
    {
        return new BatchDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static BillingAdhocChargesDAO getBillingAdhocChargesDAO()
    {
        return new BillingAdhocChargesDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static BranchDAO getBranchDAO()
    {
        return new BranchDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static BCMCalendarDAO getBCMCalendarDAO()
    {
        return new BCMCalendarDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static CertificateDAO getCertificateDAO()
    {
        return new CertificateDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static ConfirmStatusDAO getConfirmStatusDAO()
    {
        return new ConfirmStatusDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static CurUploadingFileDAO getCurUploadingFileDAO()
    {
        return new CurUploadingFileDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static CustomDAO getCustomDAO()
    {
        return new CustomDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static CustomBatchDAO getCustomBatchDAO()
    {
        return new CustomBatchDAOImpl();
    }

    /**
     *
     * @return
     */
    public static CustomMsgDAO getCustomMsgDAO()
    {
        return new CustomMsgDAOImpl();
    }
    
    /**
     * 
     * @return 
     */
    public static InwardFilesDAO getInwardFilesDAO()
    {
        return new InwardFilesDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static OWDetailsDAO getOWDetailsDAO()
    {
        return new OWDetailsDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static FileInfoDAO getFileInfoDAO()
    {
        return new FileInfoDAOImpl();
    }

    
    /**
     * 
     * @return 
     */
    public static LogTypeDAO getLogTypeDAO()
    {
        return new LogTypeDAOImpl();
    }

    /**
     *
     * @return
     */
    public static UserDAO getUserDAO()
    {
        return new UserDAOImpl();
    }

    /**
     *
     * @return
     */
    public static LogDAO getLogDAO()
    {
        return new LogDAOImpl();
    }

    /**
     *
     * @return
     */
    public static MsgBodyDAO getMsgBodyDAO()
    {
        return new MsgBodyDAOImpl();
    }

    /**
     *
     * @return
     */
    public static MsgHeaderDAO getMsgHeaderDAO()
    {
        return new MsgHeaderDAOImpl();
    }

    /**
     *
     * @return
     */
    public static MsgPriorityDAO getMsgPriorityDAO()
    {
        return new MsgPriorityDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static ParameterDAO getParameterDAO()
    {
        return new ParameterDAOImpl();
    }
    
    
    public static PWD_HistoryDAO getPWD_HistoryDAO()
    {
        return new PWD_HistoryDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static PurposeCodeDAO getPurposeCodeDAO()
    {
        return new PurposeCodeDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static RejectReasonDAO getRejectReasonDAO()
    {
        return new RejectReasonDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static ReturnReasonDAO getReturnReasonDAO()
    {
        return new ReturnReasonDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static ReportDAO getReportDAO()
    {
        return new ReportDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static ReportTypeDAO getReportTypeDAO()
    {
        return new ReportTypeDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static ReportMapDAO getReportMapDAO()
    {
        return new ReportMapDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static FileStatusDAO getFileStatusDAO()
    {
        return new FileStatusDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static SLIPSOWConfirmationDAO getSLIPSOWConfirmationDAO()
    {
        return new SLIPSOWConfirmationDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static SubPurposeCodeDAO getSubPurposeCodeDAO()
    {
        return new SubPurposeCodeDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static TransactionTypeDAO getTransactionTypeDAO()
    {
        return new TransactionTypeDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static UserLevelDAO getUserLevelDAO()
    {
        return new UserLevelDAOImpl();
    }

    /**
     * 
     * @return 
     */
    public static WindowDAO getWindowDAO()
    {
        return new WindowDAOImpl();
    }
}

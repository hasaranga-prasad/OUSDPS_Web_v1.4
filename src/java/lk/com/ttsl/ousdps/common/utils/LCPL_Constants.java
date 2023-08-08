/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.common.utils;

/**
 *
 * @author Dinesh
 */
public class LCPL_Constants
{

    private LCPL_Constants()
    {
    }

    /**
     * Common Bank Code and CCD code
     */
    public static final String default_bank_code = "9991";
    public static final String default_branch_code = "999";
    public static final String default_user_branch_code = "001";
    //public static final String default_counter_code = "999";
    public static final String ccd_code = "001";

    
    
    public static final String param_id_businessdate = "BatchBusinessDate";
    public static final String param_id_web_businessdate = "BatchBusinessDate";
    public static final String param_id_cits_cutoff_time = "CITS";
    public static final String param_id_default_pwd = "defaultPwd";
    public static final String param_id_db_enc_pw_1 = "DBEncPW_1";
    public static final String param_id_db_enc_pw_2 = "DBEncPW_2";
    public static final String param_id_session = "Session";
    public static final String param_id_start_time_session1 = "Session1StartTime";
    public static final String param_id_end_time_session1 = "Session1EndTime";
    public static final String param_id_start_time_session2 = "Session2StartTime";
    public static final String param_id_end_time_session2 = "Session2EndTime";
    public static final String param_id_user_system = "system";
    public static final String param_id_setlement_bank = "setlementBank";
    public static final String param_id_msg_reply_before = "MsgReplyBefore";
    public static final String param_id_msg_max_length = "MsgMaxLength";
    public static final String param_id_minimum_pwd_history = "MinPwdHistory";
    public static final String param_id_minimum_pwd_change_days = "MinPwdChangeDays";
    public static final String param_id_msg_max_attachment_size = "MsgAttachmentMaxSize";
    public static final String param_id_web_session_exptime = "WebSessionExpTime";

    public static final String LCPL_bank_code = "9991";
    public static final String Not_Available_bank_code = "9999";
    public static final String LCPL_default_branch_code = "001";
    public static final String bank_default_branch_code = "001";
    //public static final String des_key = "bcm2012slips"; // please shuffle 
    public static final String cert_type = "X.509";
    public static final int noPageRecords = 1000;
    public static final int maxWebRecords = 400000;
    /**
     * User Password expire duration (days)
     */
    public static final int user_pwd_expire_duration = 60;
    public static final int system_pwd_expire_duration = 365;
    /**
     * session types (days)
     */
    public static final String window_session_one = "1";
    public static final String window_session_two = "2";
    /**
     * confirmation status types
     */
    public static final String confirmation_status_one = "1";
    public static final String confirmation_status_two = "2";
    public static final String confirmation_status_three = "3";
    /**
     * calendar day types
     */
    public static final String calendar_day_type_fbd = "FBD";
    public static final String calendar_day_type_pbd = "PBD";
    public static final String calendar_day_type_nbd = "NBD";
    
    /**
     * OUSDPS Tables
     */
    public static final String tbl_accountType = "accounttype";
    public static final String tbl_adhocchargestype = "billingadhoccharges";
    public static final String tbl_bank = "bank";
    public static final String tbl_bankdownloadreport = "bankdownloadreport";
    public static final String tbl_batch = "batch";
    public static final String tbl_billingadhocstat = "billingadhocstat";
    public static final String tbl_branch = "branch";
    public static final String tbl_calender = "calender";
    public static final String tbl_confirmstatus = "confirmstatus";
    public static final String tbl_curuploadingfile = "curuploadingfile";
    public static final String tbl_activitylog = "activitylog";
    public static final String tbl_slipfile = "slipfile";
    public static final String tbl_slipbatch = "slipbatch";
    public static final String tbl_sliptransaction = "sliptransaction";
    public static final String tbl_sliptransaction_return = "slipreturntransaction";
    public static final String tbl_logtype = "logtype";
    public static final String tbl_micr = "micr";

    public static final String tbl_messageheader = "messageheader";
    public static final String tbl_messagebody = "messagebody";
    public static final String tbl_messagepriority = "messagepriority";

    public static final String tbl_parameter = "parameter";
    public static final String tbl_purposecode = "purpose";
    public static final String tbl_parameterhistory = "parameterhistory";    
    public static final String tbl_remarkheader = "remarkheader";
    public static final String tbl_remarks = "remarks";
    public static final String tbl_reply = "reply";
    public static final String tbl_rejectreason = "rejectreason";
    public static final String tbl_returnreason = "returnreason";
    public static final String tbl_report = "reports";
    public static final String tbl_report_type = "reporttype";
    public static final String tbl_reportmap = "reportmap";
    public static final String tbl_slipowconfirmation = "slipowconfirmation";
    public static final String tbl_subpurposecd = "subpurposecd";
    public static final String tbl_inwardfiles = "inwardfiles";
    public static final String tbl_status = "filestatus";
    public static final String tbl_transactiontype = "transaction";
    public static final String tbl_user = "user";
    public static final String tbl_user_pw_history = "user_pw_history";
    public static final String tbl_userlevel = "userlevel";
    public static final String tbl_window = "window";
    public static final String tbl_windowhistory = "windowhistory";

    public static final String desk_0 = "0";
    public static final String desk_1 = "1";
    public static final String desk_2 = "2";
    public static final String desk_b = "b";
    public static final String desk_c = "c";
    public static final String desk_i = "i";
    public static final String desk_l = "l";
    public static final String desk_m = "m";
    public static final String desk_p = "p";
    public static final String desk_s = "s";

    /**
     *  CITS_FT status
     */
    public static final String status_all = "ALL";
    public static final String status_active = "A";
    public static final String status_cancled = "C";
    public static final String status_deactive = "D";
    public static final String status_locked = "L";
    public static final String status_expired = "E";
    public static final String status_pending = "P";
    public static final String status_yes = "Y";
    public static final String status_no = "N";
    public static final String status_waiting = "0";
    public static final String status_processing = "1";
    public static final String status_success = "2";
    public static final String status_fail = "9";
    public static final String transaction_type_credit = "C";
    public static final String transaction_type_debit = "D";
    
    
    /*
     * User Types
     */
    public static final String user_type_lcpl_administrator = "0";
    public static final String user_type_lcpl_bcm_operator = "1";
    public static final String user_type_lcpl_helpdesk_user = "2";
    public static final String user_type_bank_user = "3";
    public static final String user_type_lcpl_supervisor = "4";
    public static final String user_type_lcpl_super_user = "5";
    public static final String user_type_settlement_bank_user = "6";
    
    
    /**
     * Message details
     */
    public static final String msg_null_or_invalid_parameter = "Null or Invalid Parameter.";
    public static final String msg_no_records = "No records were found.";
    public static final String msg_no_records_updated = "No records were updated.";
    public static final String msg_error_while_processing = "An error occured while performing the task.";
    public static final String msg_duplicate_records = "Duplicate records were found.";
    public static final String msg_not_available = "N/A";

    /**
     * messenger service related parameters
     */
    public static final String msg_isred_no = "0";
    public static final String msg_isred_yes = "1";
    public static final String msg_prioritylevel_high = "1";
    public static final String msg_prioritylevel_normal = "2";
    public static final String msg_prioritylevel_low = "3";
    public static final String msg_recipient_lcpl = "LCPL";
    public static final String msg_recipient_bank = "Bank";
    public static final String msg_recipient_extensioncounter = "ec";
    public static final String msg_branch_counter_seperator = "-";

    /**
     * Transaction details
     */
    public static final String transaction_type_normal = "OWNM";
    public static final String transaction_type_representment = "OREM";
    public static final String transaction_type_return = "ONRM";
    
    
    /**
     * Directory details
     */
    public static final String directory_separator = "/";
    public static final String directory_separator_windows = "\\";
    public static final String directory_separator_web = "/";
    public static final String directory_uploadedFiles = "uploadedFiles";
    public static final String directory_inward = "inward";
    
    /**
     * simple date formats
     */
    public static final String simple_date_format_yyyy = "yyyy";
    public static final String simple_date_format_MM = "MM";
    public static final String simple_date_format_dd = "dd";
    public static final String simple_date_format_HH = "HH";
    public static final String simple_date_format_mm = "mm";
    public static final String simple_date_format_ss = "ss";
    public static final String simple_date_format_SSS = "SSS";
    public static final String simple_date_format_yyyyMMdd = "yyyyMMdd";
    public static final String simple_date_format_yyyy_MM_dd = "yyyy-MM-dd";
    public static final String simple_date_format_yyyy_MM_dd_hh_mm = "yyyy-MM-dd hh:mm a";
    public static final String simple_date_format_yyyy_MM_dd_HH_mm = "yyyy-MM-dd HH:mm";
    public static final String simple_date_format_yyyy_MM_dd_hh_mm_ss_a = "yyyy-MM-dd hh:mm:ss a";
    public static final String simple_date_format_yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss";
    public static final String simple_date_format_yyyyMMddhhmm = "yyyyMMddhhmm";
    public static final String simple_date_format_hhmm = "hhmm";
    public static final String simple_date_format_hh_mm = "hh:mm";
    public static final String simple_date_format_HHmm = "HHmm";
    public static final String simple_date_format_HH_mm = "HH:mm";
    
    
    /**
     * Decimal Number Format Patterns
     */
    public static final String decimal_number_format_comma_sep_for_non_decimal_values = "###,###";
    
    
    /**
     * Property file paths
     */   

    //public static final String path_dbProperty = "D:\\Projects_LCPL\\dclg\\db_properties.properties";
    //public static final String path_common_properties = "D:\\Projects_LCPL\\dclg\\common.properties";
    
 public static final String path_dbProperty = "/LCPL/properties/db_properties.properties";
 public static final String path_common_properties = "/LCPL/properties/common.properties";

    public static final String is_authorized_yes = "yes";
    
    //Redownload Request
    public static final String redownload_type_data = "Data";
    public static final String redownload_type_report = "Report";
    
    //tbl_parameter
    public static final String param_type_time = "T";
    public static final String param_type_day = "D";
    public static final String param_type_other = "N";
    public static final String param_type_pwd = "P";

    public static final String tbl_status_value_0 = "0";
    public static final String tbl_status_value_7 = "7";
    //tbl_reply
    public static final String default_web_combo_select = "-1";
    public static final String default_original_return_date = "000000";
    public static final String file_ext_type_pdf = ".pdf";
    public static final String file_ext_type_sig = ".sig";
    public static final String file_ext_type_cert = ".cer";
    public static final String file_cert_prefix = "CRT";
    public static final String report_type_owd_bk1_report_name_suffix = "BNK1";
    public static final String report_type_owd_bk1_report_name_suffix_full = "BK1.PDF";
    public static final String report_type_owd_bk1_report_name_original_suffix = "SLIPS-S-BNK01.pdf";
    public static final String report_type_owd_vl1_report_name_suffix = "VLD1";
    public static final String report_type_owd_bk1_report = "OWDUPL_BNK1";
    public static final String report_type_owd_vl1_report = "OWDUPL_VLD1";
    public static final String report_type_iwd_report = "IWDM";
    public static final String report_type_lcpl_daily_reports = "LCPLD";
    public static final String report_type_lcpl_monthly_reports = "LCPLM";
    public static final String report_type_iwd_report_settlement = "STLM";
    public static final String report_type_iwd_report_settlement_adhoc = "STLMAD";
    public static final String report_type_monthly_report = "BNKM";
    public static final String report_type_daily_report = "BNKD";
    public static final String report_type_session_report = "BNKS";
    public static final String report_type_branch_report = "BRNCH";
    public static final String report_type_adhoc_report = "RPAD";

    /**
     * Log types
     */
    public static final String log_type_user_access_denied = "0000";
    public static final String log_type_user_login_info = "0001";
    public static final String log_type_user_init_password_reset = "0002";
    public static final String log_type_user_password_change = "0003";
    public static final String log_type_user_account_expired = "0004";
    public static final String log_type_user_account_locked = "0005";
    public static final String log_type_user_inquiry_transaction_ows_batch_status = "0006";
    public static final String log_type_user_inquiry_transaction_ows_file_transmission_status = "0007";
    public static final String log_type_user_inquiry_transaction_inward_download = "0008";
    public static final String log_type_user_inquiry_transaction_outward_details = "0009";
    public static final String log_type_user_inquiry_view_bank_details = "0010";
    public static final String log_type_user_inquiry_view_bank_window = "0011";
    public static final String log_type_user_inquiry_view_branch_details = "0012";
    public static final String log_type_user_inquiry_view_certificate_details = "0013";
    public static final String log_type_user_inquiry_view_cealring_calendar_details = "0014";
    public static final String log_type_user_inquiry_view_reject_reasons = "0015";
    public static final String log_type_user_inquiry_view_return_types = "0016";
    public static final String log_type_user_inquiry_view_transaction_types = "0017";
    public static final String log_type_user_inquiry_transaction_adhoc_reports = "0018";
    public static final String log_type_user_inquiry_transaction_ows_summary_ows_file_download = "0019";
    public static final String log_type_user_inquiry_transaction_ows_summary_transmission_confirmation = "0020";
    public static final String log_type_user_inquiry_transaction_ows_currently_transmitting_files = "0021";
    public static final String log_type_user_inquiry_transaction_report_summary_settlement = "0022";
    public static final String log_type_user_inquiry_transaction_confirm_transmission_status = "0030";
    public static final String log_type_user_inquiry_transaction_modify_window_details_while_confirm_transmission_status = "0031";
    public static final String log_type_user_logout_info = "0040";
    public static final String log_type_admin_user_maintenance_add_new_user = "0050";
    public static final String log_type_admin_user_maintenance_modify_user_details = "0051";
    public static final String log_type_admin_user_maintenance_view_user_details = "0052";
    public static final String log_type_admin_user_maintenance_deactivate_user = "0053";
    public static final String log_type_admin_user_maintenance_activate_user = "0054";
    public static final String log_type_admin_user_maintenance_reset_user_password = "0055";
    public static final String log_type_admin_user_maintenance_deactivate_all_users_when_bank_deactivate = "0056";
    public static final String log_type_admin_bank_branch_maintenance_add_new_bank = "0060";
    public static final String log_type_admin_bank_branch_maintenance_modify_bank_details = "0061";
    public static final String log_type_admin_bank_branch_maintenance_view_bank_details = "0062";
    public static final String log_type_admin_bank_branch_maintenance_add_new_branch = "0063";
    public static final String log_type_admin_bank_branch_maintenance_modify_branch_details = "0064";
    public static final String log_type_admin_bank_branch_maintenance_view_branch_details = "0065";
    public static final String log_type_admin_bank_branch_maintenance_authorized_new_bank = "0066";
    public static final String log_type_admin_bank_branch_maintenance_authorized_new_branch = "0067";
    public static final String log_type_admin_user_maintenance_authorized_new_user = "0068";
    public static final String log_type_admin_calendar_maintenance_add_calendar_year = "0070";
    public static final String log_type_admin_calendar_maintenance_add_calendar_details = "0071";
    public static final String log_type_admin_calendar_maintenance_modify_calendar_details = "0072";
    public static final String log_type_admin_calendar_maintenance_view_calendar_details = "0073";
    public static final String log_type_admin_parameter_maintenance_set_param_value = "0080";
    public static final String log_type_admin_parameter_maintenance_view_param_details = "0081";
    public static final String log_type_admin_return_maintenance_add_new_return_types = "0090";
    public static final String log_type_admin_return_maintenance_modify_return_types = "0091";
    public static final String log_type_admin_return_maintenance_view_return_types = "0092";
    public static final String log_type_admin_transaction_maintenance_add_new_transaction_types = "0100";
    public static final String log_type_admin_transaction_maintenance_modify_transaction_types = "0101";
    public static final String log_type_admin_transaction_maintenance_view_transaction_types = "0102";
    public static final String log_type_admin_window_maintenance_add_new_window_details = "0110";
    public static final String log_type_admin_window_maintenance_modify_window_details = "0111";
    public static final String log_type_admin_window_maintenance_view_window_details = "0112";
    public static final String log_type_admin_functions_view_log_details = "0120";
    public static final String log_type_admin_reportmap_maintenance_add_new_reportmap_details = "0130";
    public static final String log_type_admin_reportmap_maintenance_view_reportmap_details = "0132";
    public static final String log_type_admin_reportmap_maintenance_modify_reportmap_details_search = "0131";
    public static final String log_type_admin_reportmap_maintenance_modify_reportmap_details_selection = "0133";
    public static final String log_type_admin_reportmap_maintenance_modify_reportmap_details_confirmation = "0134";

    public static final String log_type_admin_purposecode_maintenance_add_purpose_code = "0140";
    public static final String log_type_admin_purposecode_maintenance_modify_purpose_code = "0141";
    public static final String log_type_admin_purposecode_maintenance_view_purpose_code = "0142";
    public static final String log_type_admin_purposecode_maintenance_add_subpurpose_code = "0143";
    public static final String log_type_admin_purposecode_maintenance_modify_subpurpose_code = "0144";
    public static final String log_type_admin_purposecode_maintenance_view_subpurpose_code = "0145";

    public static final String log_type_download_bank_branch_xml = "0150";
    public static final String log_type_download_account_type_file = "0151";
    public static final String log_type_download_purpose_code_file = "0152";
    public static final String log_type_download_return_type_file = "0153";
    public static final String log_type_download_transaction_type_file = "0154";

    public static final String log_type_admin_accounttype_maintenance_add_account_type = "0160";
    public static final String log_type_admin_accounttype_maintenance_modify_account_type = "0161";
    public static final String log_type_admin_accounttype_maintenance_view_account_type = "0162";

    public static final String log_type_admin_adhoccharge_maintenance_add_adhoccharge_type = "0170";
    public static final String log_type_admin_adhoccharge_maintenance_modify_adhoccharge_type = "0171";
    public static final String log_type_admin_adhoccharge_maintenance_view_adhoccharge_type = "0172";

    public static final String log_type_billing_adhoccharges_add_bill = "0173";
    public static final String log_type_billing_adhoccharges_cancel_bill_search = "0174";
    public static final String log_type_billing_adhoccharges_cancel_bill_confirmation = "0175";
    public static final String log_type_billing_adhoccharges_view_bill = "0176";
    
    public static final String log_type_user_message_download_attachment = "0180";
    public static final String log_type_user_message_compose_message_init = "0181";
    public static final String log_type_user_message_compose_message_send = "0182";
    public static final String log_type_user_message_search_inbox = "0183";
    public static final String log_type_user_message_search_outbox = "0184";
    public static final String log_type_user_message_view_new_msg_summary = "0185";
    public static final String log_type_user_message_view_recived_msg_details = "0186";
    public static final String log_type_user_message_view_sent_msg_details = "0187";
    public static final String log_type_user_message_reply_message_init = "0188";
    public static final String log_type_user_message_reply_message_send = "0189";
    
    
    /**
     * Web Session expire duration (minutes)
     */
    public static final int default_web_session_expire_time = 15;
    
}

<%@page import="lk.com.ttsl.ousdps.dao.custom.report.Report" errorPage="../../../../error.jsp"%>
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat,java.io.File" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.file.FileInfo" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.reportType.ReportType" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.CommonUtils" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.batch.CustomBatch" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../../../error.jsp"%>


<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>

<%
    String userName = null;
    String userType = null;
    String userTypeDesc = null;
    String sessionBankName = null;
    String sessionBankCode = null;
    String branchId = null;
    String branchName = null;
    String menuId = null;
    String menuName = null;

    userName = (String) session.getAttribute("session_userName");

    if (userName == null || userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        userType = (String) session.getAttribute("session_userType");
        userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
        sessionBankCode = (String) session.getAttribute("session_bankCode");
        sessionBankName = (String) session.getAttribute("session_bankName");
        branchId = (String) session.getAttribute("session_branchId");
        branchName = (String) session.getAttribute("session_branchName");
        menuId = (String) session.getAttribute("session_menuId");
        menuName = (String) session.getAttribute("session_menuName");

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user) || userType.equals(LCPL_Constants.user_type_lcpl_supervisor) || userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator) || userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user)))
        {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
        }
        else
        {

%>

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(sessionBankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
%>

<%
    String bankCode = null;
    String rptType = null;
    String winSess = null;
    String fromBusinessDate = null;
    String toBusinessDate = null;

    Collection<Report> colResult = null;
    Collection<Report> colResult2 = null;
    Collection<Report> colResult3 = null;
    Collection<Bank> colBank = null;
    Collection<ReportType> colRptType = null;
    Collection<ReportType> colRptTypeTemp = null;

    String isSearchReq = null;
    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);
    colRptTypeTemp = DAOFactory.getReportTypeDAO().getReportTypes();

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = LCPL_Constants.status_all;
        }

        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user))
        {
            for (ReportType rt : colRptTypeTemp)
            {
                if (rt.getType() != null)
                {

                    if (rt.getType().equals(LCPL_Constants.report_type_iwd_report_settlement) || rt.getType().equals(LCPL_Constants.report_type_iwd_report_settlement_adhoc))
                    {
                        if (colRptType == null)
                        {
                            colRptType = new java.util.ArrayList();
                        }

                        colRptType.add(rt);
                    }
                }
            }

            rptType = LCPL_Constants.status_all;
        }
        else if (userType.equals(LCPL_Constants.user_type_bank_user))
        {

            for (ReportType rt : colRptTypeTemp)
            {
                if (rt.getType() != null)
                {
                    if (rt.getType().equals(LCPL_Constants.report_type_daily_report) || rt.getType().equals(LCPL_Constants.report_type_session_report) || rt.getType().equals(LCPL_Constants.report_type_branch_report) || rt.getType().equals(LCPL_Constants.report_type_owd_bk1_report) || rt.getType().equals(LCPL_Constants.report_type_owd_vl1_report) || rt.getType().equals(LCPL_Constants.report_type_adhoc_report))
                    {
                        if (colRptType == null)
                        {
                            colRptType = new java.util.ArrayList();
                        }

                        colRptType.add(rt);
                    }
                }
            }

            rptType = LCPL_Constants.status_all;
        }
        else
        {
            if (colRptType == null)
            {
                colRptType = new java.util.ArrayList();
            }

            colRptType.addAll(colRptTypeTemp);

            rptType = LCPL_Constants.status_all;
        }

        winSess = LCPL_Constants.status_all;

        fromBusinessDate = webBusinessDate;
        toBusinessDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = (String) request.getParameter("cmbBank");
        }

        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user))
        {
            for (ReportType rt : colRptTypeTemp)
            {
                if (rt.getType().equals(LCPL_Constants.report_type_iwd_report_settlement) || rt.getType().equals(LCPL_Constants.report_type_iwd_report_settlement_adhoc))
                {
                    if (colRptType == null)
                    {
                        colRptType = new java.util.ArrayList();
                    }

                    colRptType.add(rt);
                }

            }

            rptType = (String) request.getParameter("cmbRepType");
        }
        else if (userType.equals(LCPL_Constants.user_type_bank_user))
        {
            for (ReportType rt : colRptTypeTemp)
            {
                if (rt.getType().equals(LCPL_Constants.report_type_daily_report) || rt.getType().equals(LCPL_Constants.report_type_session_report) || rt.getType().equals(LCPL_Constants.report_type_branch_report) || rt.getType().equals(LCPL_Constants.report_type_owd_bk1_report) || rt.getType().equals(LCPL_Constants.report_type_owd_vl1_report) || rt.getType().equals(LCPL_Constants.report_type_adhoc_report))
                {
                    if (colRptType == null)
                    {
                        colRptType = new java.util.ArrayList();
                    }

                    colRptType.add(rt);
                }

            }

            rptType = (String) request.getParameter("cmbRepType");
        }
        else
        {
            if (colRptType == null)
            {
                colRptType = new java.util.ArrayList();
            }

            colRptType.addAll(colRptTypeTemp);

            rptType = (String) request.getParameter("cmbRepType");
        }

        winSess = (String) request.getParameter("cmbSession");
        //rptType = (String) request.getParameter("cmbRepType");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");
    }
    else if (isSearchReq.equals("1"))
    {
        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = (String) request.getParameter("cmbBank");
        }

        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user))
        {
            for (ReportType rt : colRptTypeTemp)
            {
                if (rt.getType().equals(LCPL_Constants.report_type_iwd_report_settlement) || rt.getType().equals(LCPL_Constants.report_type_iwd_report_settlement_adhoc))
                {
                    if (colRptType == null)
                    {
                        colRptType = new java.util.ArrayList();
                    }

                    colRptType.add(rt);
                }

            }

            rptType = (String) request.getParameter("cmbRepType");
        }
        else if (userType.equals(LCPL_Constants.user_type_bank_user))
        {
            for (ReportType rt : colRptTypeTemp)
            {
                if (rt.getType().equals(LCPL_Constants.report_type_daily_report) || rt.getType().equals(LCPL_Constants.report_type_session_report) || rt.getType().equals(LCPL_Constants.report_type_branch_report) || rt.getType().equals(LCPL_Constants.report_type_owd_bk1_report) || rt.getType().equals(LCPL_Constants.report_type_owd_vl1_report) || rt.getType().equals(LCPL_Constants.report_type_adhoc_report))
                {
                    if (colRptType == null)
                    {
                        colRptType = new java.util.ArrayList();
                    }

                    colRptType.add(rt);
                }

            }

            rptType = (String) request.getParameter("cmbRepType");
        }
        else
        {
            if (colRptType == null)
            {
                colRptType = new java.util.ArrayList();
            }

            colRptType.addAll(colRptTypeTemp);

            rptType = (String) request.getParameter("cmbRepType");
        }

        winSess = (String) request.getParameter("cmbSession");
        //rptType = (String) request.getParameter("cmbRepType");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");

        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user))
        {
            if (rptType.equals(LCPL_Constants.status_all))
            {
                if (colResult == null)
                {
                    colResult = new java.util.ArrayList();
                }

                // add results of report type iwd_report_settlement  
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_iwd_report_settlement, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
                   
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult3 = DAOFactory.getReportDAO().getReportDetails(LCPL_Constants.LCPL_bank_code, null, winSess, LCPL_Constants.report_type_iwd_report_settlement, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);

                if (colResult3 != null && colResult3.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                // add results of report type iwd_report_settlement_adhoc 
                
                colResult2 = null;
                colResult3 = null;
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_iwd_report_settlement_adhoc, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
                   
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult3 = DAOFactory.getReportDAO().getReportDetails(LCPL_Constants.LCPL_bank_code, null, winSess, LCPL_Constants.report_type_iwd_report_settlement_adhoc, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);

                if (colResult3 != null && colResult3.size() > 0)
                {
                    colResult.addAll(colResult2);
                }

            }
            else
            {
                colResult = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, rptType, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);

                colResult2 = DAOFactory.getReportDAO().getReportDetails(LCPL_Constants.LCPL_bank_code, null, winSess, rptType, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);

                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
            }
        }
        else if (userType.equals(LCPL_Constants.user_type_bank_user))
        {
            if (rptType.equals(LCPL_Constants.status_all))
            {
               if (colResult == null)
                {
                    colResult = new java.util.ArrayList();
                }                   

                // add results of report type daily_report 
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_daily_report, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
            
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult2 = null;
                
                // add results of report type session_report 
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_session_report, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
            
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult2 = null;
                
                // add results of report type branch_report 
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_branch_report, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
            
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult2 = null;
                
                // add results of report type owd_bk1_report 
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_owd_bk1_report, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
            
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult2 = null;
                
                // add results of report type owd_vl1_report 
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_owd_vl1_report, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
            
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult2 = null;
                
                // add results of report type adhoc_report 
                
                colResult2 = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, LCPL_Constants.report_type_adhoc_report, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
            
                if (colResult2 != null && colResult2.size() > 0)
                {
                    colResult.addAll(colResult2);
                }
                
                colResult2 = null;
            
            }
            else
            {
                colResult = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, rptType, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);
            }
        }
        else
        {
            colResult = DAOFactory.getReportDAO().getReportDetails(bankCode, null, winSess, rptType, LCPL_Constants.status_yes, fromBusinessDate, toBusinessDate);

        }

        ReportType rt = DAOFactory.getReportTypeDAO().getReprtType(rptType);

        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_report_summary_settlement, "| Search Criteria - (Bank : " + (userType.equals(LCPL_Constants.user_type_settlement_bank_user) ? bankCode + " and " + LCPL_Constants.LCPL_bank_code : bankCode) + ", Report Type : " + (rt != null ? rt.getType() + "-" + rt.getDescription() : "N/A") + ", Bus.Date From : " + fromBusinessDate + ", Bus.Date To : " + toBusinessDate + ", Session : " + winSess + ") | Result Count - " + colResult.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
        //System.out.println("colResult.size()   ---> " + colResult.size());

    }
%>
<html>
    <head>
        <title>OUSDPS Web - File Transmission Status</title>
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../../../../css/tcal.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>


        <script language="javascript" type="text/JavaScript">


            function showClock(type)
            {
            if(type==1)
            {
            clock(document.getElementById('showText'),type,null);
            }
            else if(type==2)
            {
            var val = new Array(<%=serverTime%>);
            clock(document.getElementById('showText'),type,val);
            }
            else if(type==3)
            {
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window.getCutontimeHour()%>, <%=window.getCutontimeMinutes()%>, <%=window.getCutofftimeHour()%>, <%=window.getCutofftimeMinutes()%>);
            clock(document.getElementById('showText'),type,val);

            }
            }

            function resetDates()
            {
            var from_elementId = 'txtFromBusinessDate';
            var to_elementId = 'txtToBusinessDate';

            document.getElementById(from_elementId).value = "<%=webBusinessDate%>";
            document.getElementById(to_elementId).value = "<%=webBusinessDate%>";
            }

            function isInitReq(status) {

            if(status)
            {
            document.getElementById('hdnInitReq').value = "1";
            }
            else
            {
            document.getElementById('hdnInitReq').value = "0";
            }

            }

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnSearchReq').value = "1";
            }
            else
            {
            document.getElementById('hdnSearchReq').value = "0";
            }
            }

            function clearResultData()
            {
            if(document.getElementById('resultdata')!= null)
            {
            document.getElementById('resultdata').style.display='none';
            }

            if(document.getElementById('noresultbanner')!= null)
            {
            document.getElementById('noresultbanner').style.display='none';
            }

            if(document.getElementById('clickSearch')!= null)
            {
            document.getElementById('clickSearch').style.display='block';
            }

            }

            function downloadReport(index,id)
            {				
            if(id==1)
            {
            var objFileName = "hdnFileNameVL1_" + index;
            var objFilePath = "hdnFilePathVL1_" + index;

            document.getElementById('hdnFileName').value = document.getElementById(objFileName).value;
            document.getElementById('hdnFilePath').value = document.getElementById(objFilePath).value;

            //alert('hdnFilePath value ---> ' + document.getElementById('hdnFilePath').value);

            document.frmDownload.action="DownloadReport.jsp";
            document.frmDownload.submit();	
            }
            else if(id==2)
            {
            var objFileName = "hdnFileNameBK1_" + index;
            var objFilePath = "hdnFilePathBK1_" + index;

            document.getElementById('hdnFileName').value = document.getElementById(objFileName).value;
            document.getElementById('hdnFilePath').value = document.getElementById(objFilePath).value;                    


            document.frmDownload.action="DownloadReport.jsp";
            document.frmDownload.submit();	
            }


            }

            function doPrint()
            { 
            var disp_setting="toolbar=yes,location=no,directories=yes,menubar=yes,"; 
            disp_setting+="scrollbars=no,width=750, height=550, left=0, top=0"; 
            var content_vlue = document.getElementById("printableArea").innerHTML; 

            var docprint = window.open("","",disp_setting); 
            docprint.document.open(); 
            docprint.document.write('<html><head><title>Outward Details</title><link href="../../../../css/cits.css" rel="stylesheet" type="text/css" />'); 
            //docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../../../js/tableenhance.js" />');
            docprint.document.write('</head><body onLoad="self.print();self.close()"><center>');          
            docprint.document.write(content_vlue);          
            docprint.document.write('</center></body></html>');                  
            docprint.focus(); 
            docprint.document.close();

            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="showClock(3)">
        <table style="min-width:980" height="600" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" class="cits_bgRepeat_center">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_bgRepeat_left">
                        <tr>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="102" class="cits_header_center">

                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_header_left">
                                                            <tr>
                                                                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_header_right">
                                                                        <tr>
                                                                            <td><table height="102" width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td height="74"><table width="980" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="22"><table width="100%" height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                    <td>

                                                                                                        <div style="padding:1;height:100%;width:100%;">
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** CITS ****</div>
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=menuName%>" vqp_uid0=<%=menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";
                                                                                                                cdd__codebase<%=menuId%> = "<%=request.getContextPath()%>/js/";</script>
                                                                                                            <script language="JavaScript" vqptag="datafile" src="<%=request.getContextPath()%>/js/<%=menuName%>"></script>
                                                                                                            <script vqptag="placement" vqp_menuid="<%=menuId%>" language="JavaScript">create_menu(<%=menuId%>)</script>
                                                                                                        </div></td>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td align="right" valign="middle"><table height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td class="cits_menubar_text">Welcome :</td>
                                                                                                                <td width="5"></td>
                                                                                                                <td class="cits_menubar_text"><b><%=userName%></b> - <%=sessionBankName%></td>
                                                                                                                <td width="15">&nbsp;</td>
                                                                                                                <td valign="bottom"><a href="<%=request.getContextPath()%>/pages/user/userProfile.jsp" title=" My Profile "><img src="<%=request.getContextPath()%>/images/user.png" width="18"
                                                                                                                                                                                                        height="22" border="0" align="middle" ></a></td>
                                                                                                                <td width="10"></td>
                                                                                                                <td class="cits_menubar_text">[ <a href="<%=request.getContextPath()%>/pages/logout.jsp" class="cits_sub_link"><u>Logout</u></a> ]</td>
                                                                                                                <td width="5"></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5">                                        </td>
                                                                                    </tr>
                                                                                </table></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td  height="470" align="center" valign="top" class="cits_bgCommon">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="24" align="center" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>

                                                                            <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td valign="middle" class="cits_menubar_text">Business Date : <%=webBusinessDate%></td>
                                                                                        <td width="5" valign="middle"></td>
                                                                                        <td valign="middle" class="cits_menubar_text">Session : <%=winSession%></td>
                                                                                        <td width="5" valign="middle"></td>
                                                                                        <td valign="middle"><div id="actSession" align="center" ><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgOK" id="imgOK" width="12" height="12" title="Session is active!" ></div>
                                                                                            <div id="expSession" align="center" ><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgError" id="imgError" width="12" height="12" title="Session is expired!" ></div></td>
                                                                                        <td width="5" valign="middle"></td>
                                                                                        <td valign="middle" class="cits_menubar_text">[ Current : <%=currentDate%></td>
                                                                                        <td width="5" valign="middle"></td>
                                                                                        <td valign="middle" class="cits_menubar_text"><div id="showText" class="cits_menubar_text"></div></td>
                                                                                        <td valign="middle" class="cits_menubar_text"> ]</td>
                                                                                        <td width="5"></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15"></td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="center" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="center" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text"><%=userType.equals(LCPL_Constants.user_type_settlement_bank_user) ? "Settlement" : userType.equals(LCPL_Constants.user_type_bank_user) ? "Summary": "Summary & Settlement"%> Reports</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text"><form id="frmViewFileStat" name="frmViewFileStat" method="post" action="ReportDetails.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >
                                                                                                    <tr>
                                                                                                        <td><table border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Bank :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" ><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBank" id="cmbBank" onChange="isSearchRequest(false);
                                                                                                                                                    frmViewFileStat.submit()" class="cits_field_border" <%=(userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (bankCode == null || (bankCode != null && bankCode.equals(LCPL_Constants.status_all)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%              }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colBank != null && colBank.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Bank bank : colBank)
                                                                                                                                                {
                                                                                                                                                    if (userType.equals(LCPL_Constants.user_type_bank_user) && (bank != null && bank.getBankCode().equals(LCPL_Constants.LCPL_bank_code)))
                                                                                                                                                    {
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(bankCode != null && bank.getBankCode().equals(bankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                                        <%
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="cits_error">No bank details available.</span>
                                                                                                                                    <%  }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }

                                                                                                                                    %>                                                                                                        </td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"><!--Outward Branch :-->Report Type :</td>
                                                                                                                                <td align="left" valign="top" bgcolor="#DFEFDE" >

                                                                                                                                    <select name="cmbRepType" id="cmbRepType"  class="cits_field_border" onChange="clearResultData()" >
                                                                                                                                        <%                                                                                                                                            if (rptType == null || rptType.equals(LCPL_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%
                                                                                                                                            }

                                                                                                                                        %>



                                                                                                                                        <%                                                                                                                                            if (colRptType != null && colRptType.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (ReportType rt : colRptType)
                                                                                                                                                {

                                                                                                                                                    if (userType.equals(LCPL_Constants.user_type_bank_user) && (rt != null && (rt.getType().equals(LCPL_Constants.report_type_iwd_report_settlement) || rt.getType().equals(LCPL_Constants.report_type_monthly_report) || rt.getType().equals(LCPL_Constants.report_type_lcpl_daily_reports) || rt.getType().equals(LCPL_Constants.report_type_lcpl_monthly_reports))))
                                                                                                                                                    {
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=rt.getType()%>" <%=(rptType != null && rt.getType().equals(rptType)) ? "selected" : ""%> > <%=rt.getType() + " - " + rt.getDescription()%></option>
                                                                                                                                        <%
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>                                                                                                                                </td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"> Business Date :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromBusinessDate" id="txtFromBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(fromBusinessDate == null || fromBusinessDate.equals("0") || fromBusinessDate.equals(LCPL_Constants.status_all)) ? "" : fromBusinessDate%>" >                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToBusinessDate" id="txtToBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(toBusinessDate == null || toBusinessDate.equals("0") || toBusinessDate.equals(LCPL_Constants.status_all)) ? "" : toBusinessDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="Reset Dates" type="button" onClick="resetDates()" class="cits_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>



                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Session :                                                                                                         </td>
                                                                                                                                <td align="left" bgcolor="#DFEFDE"><select name="cmbSession" id="cmbSession" class="cits_field_border" onChange="clearResultData();">
                                                                                                                                        <%%>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" <%=(winSess != null && winSess.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <option value="<%=LCPL_Constants.window_session_one%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_one)) ? "selected" : ""%>><%=LCPL_Constants.window_session_one%></option>
                                                                                                                                        <option value="<%=LCPL_Constants.window_session_two%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_two)) ? "selected" : ""%>><%=LCPL_Constants.window_session_two%></option>
                                                                                                                                    </select> </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="4" align="right" bgcolor="#CDCDCD" class="cits_tbl_header_text">


                                                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center">                                                                                                                     
                                                                                                                                                <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    frmViewFileStat.submit()"  class="cits_custom_button"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>
                                                                                        </td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td><table border="0" cellpadding="0" cellspacing="0">
                                                                                                            <%
                                                                                                                if (isSearchReq.equals("1") && colResult.size() == 0)
                                                                                                                {%>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%   }
                                                                                                            else if (isSearchReq.equals("1") && colResult.size() > 0)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">




                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                                                        <tr bgcolor="#DFE0E1">
                                                                                                                                            <td align="right" bgcolor="#D8D8D8">&nbsp;</td>
                                                                                                                                            <td width="25" align="left" bgcolor="#D8D8D8"><input type="image" src="<%=request.getContextPath()%>/images/printer2.png" width="18" height="18" title="Print" onClick="doPrint()"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td><table  border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                                        <tr>
                                                                                                                                            <td rowspan="2" align="right" bgcolor="#B3D5C0"></td>
                                                                                                                                            <td rowspan="2" align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business<br/>
                                                                                                                                                Date</td>
                                                                                                                                            <td rowspan="2" align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Ses.</td>
                                                                                                                                            <td rowspan="2" align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Bank</td>
                                                                                                                                            <!--td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Outward<br/>Branch</td-->
                                                                                                                                            <td rowspan="2" align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Report<br/>Name</td>
                                                                                                                                            <td rowspan="2" align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Report<br/>Type</td>
                                                                                                                                            <td rowspan="2" align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created<br/>
                                                                                                                                                Time</td>
                                                                                                                                            <td colspan="4" align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Download Status</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">Report</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">Already<br/>
                                                                                                                                                D.load</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">D.load<br/>
                                                                                                                                                By</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">D.load<br/>
                                                                                                                                                Time</td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                            int rowNum = 0;
                                                                                                                                            int orgNoOfTrans = 0;
                                                                                                                                            long orgTotalAmount = 0;
                                                                                                                                            int rjtNoOfTrans = 0;
                                                                                                                                            long rjtTotalAmount = 0;

                                                                                                                                            for (Report rpt : colResult)
                                                                                                                                            {

                                                                                                                                                if (userType.equals(LCPL_Constants.user_type_bank_user) && (rpt != null && (rpt.getReportType().equals(LCPL_Constants.report_type_iwd_report_settlement) || rpt.getReportType().equals(LCPL_Constants.report_type_monthly_report))))
                                                                                                                                                {
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {

                                                                                                                                                    rowNum++;

                                                                                                                                        %>
                                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                            <td align="right" class="cits_common_text" ><%=rowNum%>.</td>
                                                                                                                                            <td align="center"  class="cits_common_text"><%=rpt.getBusinessDate()%></td>
                                                                                                                                            <td align="center"  class="cits_common_text"><%=rpt.getSession()%></td>
                                                                                                                                            <td align="center"  class="cits_common_text"><span class="cits_common_text" title="<%=rpt.getBankFullName()%>"><%=rpt.getBank() + " - " + rpt.getBankShortName()%></span></td>
                                                                                                                                            <!--td rowspan="2" align="center"  class="cits_common_text"><%=rpt.getBranch() + " - " + rpt.getBranchName()%></td-->
                                                                                                                                            <td  class="cits_common_text"><%=rpt.getReportName()%></td>
                                                                                                                                            <td  class="cits_common_text"><%=rpt.getReportTypeDesc()%></td>
                                                                                                                                            <td align="center"  class="cits_common_text"><%=rpt.getCreatedTime()%></td>

                                                                                                                                            <td align="center"  class="cits_common_text"><%
                                                                                                                                                if (userType != null && userType.equals(LCPL_Constants.user_type_lcpl_helpdesk_user))
                                                                                                                                                {
                                                                                                                                                    //System.out.print("reportVL1.getReportPath() -->" + reportVL1.getReportPath());

                                                                                                                                                    if (rpt.getReportPath() != null && new CommonUtils().isFileAvailable(rpt.getReportPath()))
                                                                                                                                                    {

                                                                                                                                                %>
                                                                                                                                                <span class="cits_success" title="Verification Report Available">Available</span>
                                                                                                                                                <%                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <span class="cits_error" title="Verification Report Not Available">Not Available</span>
                                                                                                                                                <%
                                                                                                                                                    }

                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {

                                                                                                                                                    if (rpt.getReportPath() != null && new CommonUtils().isFileAvailable(rpt.getReportPath()))
                                                                                                                                                    {


                                                                                                                                                %>
                                                                                                                                                <input type="hidden" id="hdnFileNameVL1_<%=rowNum%>" name="hdnFileNameVL1_<%=rowNum%>" value="<%=rpt.getReportName()%>" />
                                                                                                                                                <input type="hidden" id="hdnFilePathVL1_<%=rowNum%>" name="hdnFilePathVL1_<%=rowNum%>" value="<%=rpt.getReportPath()%>" />
                                                                                                                                                <input type="button" name="btnDwnReport" id="btnDwnReport" value="Download" class="cits_custom_button_small" onClick="downloadReport(<%=rowNum%>, 1)" width="30">
                                                                                                                                                <%
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <span class="cits_error" title="Verification Report Not Available">Not Available</span>
                                                                                                                                                <%
                                                                                                                                                        }
                                                                                                                                                    }


                                                                                                                                                %>                                                                                                          </td>
                                                                                                                                            <td align="center"  class="cits_common_text"><%=rpt != null && rpt.getIsAlreadyDownloaded().equals(LCPL_Constants.status_yes) ? "Yes" : "No"%></td>
                                                                                                                                            <td align="center"  class="cits_common_text"><%=rpt != null && rpt.getDownloadedBy() != null ? rpt.getDownloadedBy() : "-"%></td>
                                                                                                                                            <td align="center"  class="cits_common_text"><%=rpt != null && rpt.getDownloadedTime() != null ? rpt.getDownloadedTime() : "-"%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                                }

                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                        <form id="frmDownload" name="frmDownload" method="post" target="_self">
                                                                                                                                            <tr  class="cits_common_text">
                                                                                                                                                <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <!--td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td-->
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                                                <td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <td bgcolor="#B3D5C0" class="cits_common_text"><input type="hidden" id="hdnFileName" name="hdnFileName"  />
                                                                                                                                                    <input type="hidden" id="hdnFilePath" name="hdnFilePath"  /></td>
                                                                                                                                                <td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <!--td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td-->
                                                                                                                                            </tr>
                                                                                                                                        </form>
                                                                                                                                    </table>

                                                                                                                                    <div id="printableArea" style="display:none">

                                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                                            <tr>
                                                                                                                                                <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business<br/>
                                                                                                                                                    Date</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Ses.</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Outward<br/>
                                                                                                                                                    Bank</td>
                                                                                                                                                <!--td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Outward<br/>Branch</td-->
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">File ID</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Original<br/>
                                                                                                                                                    No. Of Transactions</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Original<br/>
                                                                                                                                                    Total Amount</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Rejected<br/>No. Of Transactions</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Rejected<br/>
                                                                                                                                                    Total Amount</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Status</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Transmission<br/>
                                                                                                                                                    Time</td>
                                                                                                                                            </tr>
                                                                                                                                            <%                                                                                                                                                int rowNum2 = 0;
                                                                                                                                                int orgNoOfTrans2 = 0;
                                                                                                                                                int orgTotalAmount2 = 0;
                                                                                                                                                int rjtNoOfTrans2 = 0;
                                                                                                                                                int rjtTotalAmount2 = 0;

                                                                                                                                                for (Report rpt2 : colResult)
                                                                                                                                                {
                                                                                                                                                    rowNum2++;


                                                                                                                                            %>
                                                                                                                                            <tr bgcolor="<%=rowNum2 % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                                <td align="right" class="cits_common_text" ><%=rowNum2%>.</td>
                                                                                                                                                <td align="center"  class="cits_common_text"><%=rpt2.getBusinessDate()%></td>
                                                                                                                                                <td align="center"  class="cits_common_text"><%=rpt2.getSession()%></td>
                                                                                                                                                <td align="center"  class="cits_common_text"><span class="cits_common_text" title="<%=rpt2.getBankFullName()%>"><%=rpt2.getBank() + " - " + rpt2.getBankShortName()%></span></td>
                                                                                                                                                <!--td rowspan="2" align="center"  class="cits_common_text"><%=rpt2.getBranch() + " - " + rpt2.getBranchName()%></td-->
                                                                                                                                                <td align="center"  class="cits_common_text"><%=rpt2.getReportName()%></td>

                                                                                                                                                <td align="center"  class="cits_common_text"><%=rpt2.getReportTypeDesc()%></td>
                                                                                                                                                <td align="center"  class="cits_common_text"><%=rpt2.getCreatedTime()%></td>
                                                                                                                                            </tr>
                                                                                                                                            <%
                                                                                                                                                }
                                                                                                                                            %>

                                                                                                                                            <tr  class="cits_common_text">
                                                                                                                                                <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <!--td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td-->
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">Total</td>
                                                                                                                                                <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=orgNoOfTrans2%></td>
                                                                                                                                                <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=orgTotalAmount2%></td>
                                                                                                                                                <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=rjtNoOfTrans2%></td>
                                                                                                                                                <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=rjtTotalAmount2%></td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                                                <td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                                <!--td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td-->
                                                                                                                                            </tr>
                                                                                                                                        </table>

                                                                                                                                    </div>


                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                                                        <tr bgcolor="#DFE0E1">
                                                                                                                                            <td align="right" bgcolor="#D8D8D8">&nbsp;</td>
                                                                                                                                            <td width="25" align="left" bgcolor="#D8D8D8"><input type="image" src="<%=request.getContextPath()%>/images/printer2.png" width="18" height="18" title="Print" onClick="doPrint()"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table>



                                                                                                                    </div></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }
                                                                                                            %>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15">&nbsp;</td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="50" align="center" valign="top"></td>
                                                            </tr>
                                                        </table>                          </td>
                                                </tr>


                                            </table></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                </td></tr>
            <tr>
                <td height="39" class="cits_footter_center">                  
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_left">
                        <tr>
                            <td height="39">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_right">
                                    <tr>
                                        <td height="39">
                                            <table width="100%" height="35" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="25"></td>
                                                    <td align="left" class="cits_copyRight">2015 &copy; LankaClear. All rights reserved.</td>
                                                    <td align="right" class="cits_copyRight">Developed By - Pronto Lanka (Pvt) Ltd.</td>
                                                    <td width="25"></td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table>




                </td>
            </tr>
        </table>


    </body>
</html>
<%
        }
    }
%>

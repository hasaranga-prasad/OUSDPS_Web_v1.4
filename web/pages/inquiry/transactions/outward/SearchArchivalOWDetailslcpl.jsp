<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.archivalowdetails.ArchivalOWDetails" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.transactiontype.TransactionType" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.returnreason.ReturnReason" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.fileStatus.FileStatus" errorPage="../../../../error.jsp"%>
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

        if (!userType.equals(LCPL_Constants.user_type_lcpl_super_user))
        {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
        }
        else
        {


%>

<%
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(sessionBankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
%>

<%
    String originalBankCode = null;
    String originalBranchCode = null;
    String desBankCode = null;
    String desBranchCode = null;
    //String orgBankCode = null;
    //String orgBranchCode = null;
    String transCode = null;
    String returnCode = null;
    String winSess = null;
    String fromBusinessDate = null;
    String toBusinessDate = null;
    String fromValueDate = null;
    String toValueDate = null;
    String fileId = null;
    String orgActNo = null;
    String orgActName = null;
    String desActNo = null;
    String desActName = null;
    String minAmount = null;
    String maxAmount = null;
    
    String status = null;
    
    long totalRecordCount = 0;
    int totalPageCount = 0;
    int reqPageNo = 1;

    Collection<ArchivalOWDetails> colResult = null;
    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;
    Collection<Bank> colDesBank = null;
    Collection<Branch> colDesBranch = null;
    //Collection<Bank> colOrgBank = null;
    //Collection<Branch> colOrgBranch = null;
    Collection<TransactionType> colTransType = null;
    Collection<ReturnReason> colReturnReason = null;
    Collection<FileStatus> colStatus = null;

    String isSearchReq = null;
    isSearchReq = (String) request.getParameter("hdnSearchReq");

    colBank = DAOFactory.getBankDAO().getBank(LCPL_Constants.status_all);
    colDesBank = DAOFactory.getBankDAO().getBank(LCPL_Constants.status_all);
    //colOrgBank = DAOFactory.getBankDAO().getBank(LCPL_Constants.status_all);
    colTransType = DAOFactory.getTransactionTypeDAO().getTransTypeDetails();
    colReturnReason = DAOFactory.getReturnReasonDAO().getReTurnTypes();
    colStatus = DAOFactory.getFileStatusDAO().getFileStatusDetails();

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        if (userType.equals("3"))
        {
            originalBankCode = sessionBankCode;
            colBranch = DAOFactory.getBranchDAO().getBranch(originalBankCode);
            originalBranchCode = LCPL_Constants.status_all;
        }
        else
        {
            originalBankCode = LCPL_Constants.status_all;
            originalBranchCode = LCPL_Constants.status_all;
        }

        desBankCode = LCPL_Constants.status_all;
        desBranchCode = LCPL_Constants.status_all;
        transCode = LCPL_Constants.status_all;
        returnCode = LCPL_Constants.status_all;
        winSess = LCPL_Constants.status_all;
        status = LCPL_Constants.status_all;
        
        fromBusinessDate = webBusinessDate;
        toBusinessDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        if (userType.equals("3"))
        {
            originalBankCode = sessionBankCode;
        }
        else
        {
            originalBankCode = (String) request.getParameter("cmbBankOrginal");
        }

        if (originalBankCode.equals(LCPL_Constants.status_all))
        {
            originalBranchCode = LCPL_Constants.status_all;
        }
        else
        {
            colBranch = DAOFactory.getBranchDAO().getBranch(originalBankCode);
            originalBranchCode = (String) request.getParameter("cmbBranchOW");
        }

        desBankCode = (String) request.getParameter("cmbBankDes");

        if (desBankCode.equals(LCPL_Constants.status_all))
        {
            desBranchCode = LCPL_Constants.status_all;
        }
        else
        {
            colDesBranch = DAOFactory.getBranchDAO().getBranch(desBankCode);
            desBranchCode = (String) request.getParameter("cmbBranchDes");
        }

        transCode = (String) request.getParameter("cmbTransType");
        returnCode = (String) request.getParameter("cmbReturnReason");
        winSess = (String) request.getParameter("cmbSession");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");
        fileId = (String) request.getParameter("txtFileId");
        desActNo = (String) request.getParameter("txtDesActNo");
        orgActNo = (String) request.getParameter("txtOrgActNo");
        minAmount = (String) request.getParameter("txtAmountMin");
        maxAmount = (String) request.getParameter("txtAmountMax");
        fromValueDate = (String) request.getParameter("txtFromValueDate");
        toValueDate = (String) request.getParameter("txtToValueDate");
        desActName = (String) request.getParameter("txtDesActName");
        orgActName = (String) request.getParameter("txtOrgActName");        
        status = (String) request.getParameter("cmbStatus");
    }
    else if (isSearchReq.equals("1"))
    {
        if (userType.equals("3"))
        {
            originalBankCode = sessionBankCode;
        }
        else
        {
            originalBankCode = (String) request.getParameter("cmbBankOrginal");
        }

        if (originalBankCode.equals(LCPL_Constants.status_all))
        {
            originalBranchCode = LCPL_Constants.status_all;
        }
        else
        {
            colBranch = DAOFactory.getBranchDAO().getBranch(originalBankCode);
            originalBranchCode = (String) request.getParameter("cmbBranchOW");
        }

        desBankCode = (String) request.getParameter("cmbBankDes");

        if (desBankCode.equals(LCPL_Constants.status_all))
        {
            desBranchCode = LCPL_Constants.status_all;
        }
        else
        {
            colDesBranch = DAOFactory.getBranchDAO().getBranch(desBankCode);
            desBranchCode = (String) request.getParameter("cmbBranchDes");
        }

        transCode = (String) request.getParameter("cmbTransType");
        returnCode = (String) request.getParameter("cmbReturnReason");
        winSess = (String) request.getParameter("cmbSession");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");
        fileId = (String) request.getParameter("txtFileId");
        desActNo = (String) request.getParameter("txtDesActNo");
        orgActNo = (String) request.getParameter("txtOrgActNo");
        minAmount = (String) request.getParameter("txtAmountMin");
        maxAmount = (String) request.getParameter("txtAmountMax");
        fromValueDate = (String) request.getParameter("txtFromValueDate");
        toValueDate = (String) request.getParameter("txtToValueDate");
        desActName = (String) request.getParameter("txtDesActName");
        orgActName = (String) request.getParameter("txtOrgActName");
        
        status = (String) request.getParameter("cmbStatus");

        if (request.getParameter("hdnReqPageNo") != null)
        {
            reqPageNo = Integer.parseInt(request.getParameter("hdnReqPageNo"));
        }

        totalRecordCount = DAOFactory.getArchivalOWDetailsDAO().getRecordCountOWDetails(LCPL_Constants.status_all, LCPL_Constants.status_all, desBankCode, desBranchCode, originalBankCode, originalBranchCode, transCode, returnCode, winSess, fromBusinessDate, toBusinessDate, fromValueDate, toValueDate, fileId, desActNo, desActName, orgActNo, orgActName, status, minAmount, maxAmount);

        if (totalRecordCount > 0)
        {
            totalPageCount = (int) Math.ceil((Double.parseDouble(String.valueOf(totalRecordCount))) / LCPL_Constants.noPageRecords);

            colResult = DAOFactory.getArchivalOWDetailsDAO().getOWDetails(LCPL_Constants.status_all, LCPL_Constants.status_all, desBankCode, desBranchCode, originalBankCode, originalBranchCode, transCode, returnCode, winSess, fromBusinessDate, toBusinessDate, fromValueDate, toValueDate, fileId, desActNo, desActName, orgActNo, orgActName, status, minAmount, maxAmount, reqPageNo, LCPL_Constants.noPageRecords);

            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_adhoc_reports, "| Search Criteria - (Originate Bank : " + originalBankCode + ", Originate Branch : " + originalBranchCode + ", Originate Account No. : " + (orgActNo != null ? orgActNo : "") + ", Originate Account Name : " + (orgActName != null ? orgActName : "") + ", Destination Bank : " + desBankCode + ", Destination Branch : " + desBranchCode + ", Destination Account No. : " + (desActNo != null ? desActNo : "") + ", Destination Account Name : " + (desActName != null ? desActName : "") + ", Transaction type : " + transCode + ", Return reason : " + returnCode + ", Min Amount : " + (minAmount != null ? minAmount : "") + ", Max Amount : " + (maxAmount != null ? maxAmount : "") + ", File Id : " + (fileId != null ? fileId : "") + ", Bus.Date From : " + fromBusinessDate + ", Bus.Date To : " + toBusinessDate + ", Val.Date From : " + (fromValueDate != null ? fromValueDate : "") + ", Val.Date To : " + (toValueDate != null ? toValueDate : "") + ", Session : " + winSess + ", Page No. - " + reqPageNo + ") | Record Count - " + colResult.size() + ", Total Record Count - " + totalRecordCount + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_adhoc_reports, "| Search Criteria - (Originate Bank : " + originalBankCode + ", Originate Branch : " + originalBranchCode + ", Originate Account No. : " + (orgActNo != null ? orgActNo : "") + ", Originate Account Name : " + (orgActName != null ? orgActName : "") + ", Destination Bank : " + desBankCode + ", Destination Branch : " + desBranchCode + ", Destination Account No. : " + (desActNo != null ? desActNo : "") + ", Destination Account Name : " + (desActName != null ? desActName : "") + ", Transaction type : " + transCode + ", Return reason : " + returnCode + ", Min Amount : " + (minAmount != null ? minAmount : "") + ", Max Amount : " + (maxAmount != null ? maxAmount : "") + ", File Id : " + (fileId != null ? fileId : "") + ", Bus.Date From : " + fromBusinessDate + ", Bus.Date To : " + toBusinessDate + ", Val.Date From : " + (fromValueDate != null ? fromValueDate : "") + ", Val.Date To : " + (toValueDate != null ? toValueDate : "") + ", Session : " + winSess + ") | Total Record Count - 0 | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>
<html>
    <head>
        <title>OUSDPS Web - Archival Transaction Reports (Outward Details)</title>
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
                else if(type==2                 )
                {
                    var val = new Array(<%=serverTime%>);
                    clock(document.getElementById('showText'),type,val);
                }
                else if(type==3                 )
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
			
            function resetValueDates()
            {                
				
                var from_elementId = 'txtFromValueDate';
                var to_elementId = 'txtToValueDate';
				
                document.getElementById(from_elementId).value = "";
                document.getElementById(to_elementId).value = "";
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
			
            function clearRecords()
            {
                clearResultData();                
                document.getElementById('cmbBankOrginal').selectedIndex = 0;
                document.getElementById('cmbBranchOW').selectedIndex = 0;
                document.getElementById('cmbBankDes').selectedIndex = 0;
                document.getElementById('cmbBranchDes').selectedIndex = 0;
                //document.getElementById('cmbBankOrg').selectedIndex = 0;
                //document.getElementById('cmbBranchOrg').selectedIndex = 0;
                document.getElementById('cmbTransType').selectedIndex = 0;
                document.getElementById('cmbReturnReason').selectedIndex = 0;
                document.getElementById('cmbSession').selectedIndex = 0;
                document.getElementById('txtFileId').value = "";
                document.getElementById('txtDesActNo').value = "";
                document.getElementById('txtOrgActNo').value = "";
                document.getElementById('txtAmountMin').value = "";
                document.getElementById('txtAmountMax').value = "";				
                resetDates();
            }
            
            function hideMessage_onFocus()
            {		
                if(document.getElementById('hdnSearchReq')!=null && document.getElementById('hdnSearchReq').value == '1')
                {
                    clearRecords();
                    document.getElementById('hdnSearchReq').value = '0';
                }
				   
                if(document.getElementById('hdnSearchReq')!=null && document.getElementById('hdnSearchReq').value == '1')
                {
                    clearRecords();
                    document.getElementById('hdnSearchReq').value = '0';
                }
            }
            
            function fieldValidation()
            {
                var fileIdVal = document.getElementById('txtFileId').value;
                var descActNoVal = document.getElementById('txtDesActNo').value;
                var orgActNoVal = document.getElementById('txtOrgActNo').value;
                var minAmountVal = document.getElementById('txtAmountMin').value;
                var maxAmountVal = document.getElementById('txtAmountMax').value; 
                
                var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
                var numbers = /^[0-9]*$/;                
                
                if(!isempty(descActNoVal))
                {
                    if(!numbers.test(descActNoVal))
                    {
                        alert("Only numbers allowed for Des. Acc. No.!");
                        document.getElementById('txtDesActNo').focus();
                        return false;
                    }                    
                }				                
                
                if(!isempty(orgActNoVal))
                {
                    if(!numbers.test(orgActNoVal))
                    {
                        alert("Only numbers allowed for Org. Acc. No.!");
                        document.getElementById('txtOrgActNo').focus();
                        return false;
                    }
                }                
                
                if(!isempty(minAmountVal))
                {
                    if(!numbers.test(minAmountVal))
                    {
                        alert("Only numbers allowed for Min Amount!");
                        document.getElementById('txtAmountMin').focus();
                        return false;
                    }
                } 
                
                if(!isempty(maxAmountVal))
                {
                    if(!numbers.test(maxAmountVal))
                    {
                        alert("Only numbers allowed for Max Amount!");
                        document.getElementById('txtAmountMax').focus();
                        return false;
                    }
                }
                return true;

            }
			
            function doSearch(val)
            {
                if(val==0)
                {
                    isSearchRequest(false);
                    document.frmArchivalOWDetailsLCPL.action="SearchArchivalOWDetailslcpl.jsp";
                    document.frmArchivalOWDetailsLCPL.submit();				
                    return true;
                    
                }
                else if(val==1)
                {
                    isSearchRequest(true);
				
                    if(fieldValidation())
                    {
                        document.frmArchivalOWDetailsLCPL.action="SearchArchivalOWDetailslcpl.jsp";
                        document.frmArchivalOWDetailsLCPL.submit();				
                        return true;
                    }
                    else
                    {
                        return false;
                    }                
                }
            }
			
            function isempty(Value)
            {
                if(Value.length < 1)
                {
                    return true;
                }
                else
                {
                    var str = Value;

                    while(str.indexOf(" ") != -1)
                    {
                        str = str.replace(" ","");
                    }

                    if(str.length < 1)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            
            function trim(str) 
            {
                return str.replace(/^\s+|\s+$/g,"");
            }
			
            function setReqPageNoForCombo2()
            {
                document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo2').value;
                isSearchRequest(true);
                document.frmArchivalOWDetailsLCPL.action="SearchArchivalOWDetailslcpl.jsp";
                document.frmArchivalOWDetailsLCPL.submit();
            }
			
            function setReqPageNoForCombo()
            {
                document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo').value;
                isSearchRequest(true);
                document.frmArchivalOWDetailsLCPL.action="SearchArchivalOWDetailslcpl.jsp";
                document.frmArchivalOWDetailsLCPL.submit();
            }
			
            function setReqPageNo(no)
            {
                document.getElementById('hdnReqPageNo').value = no;
                isSearchRequest(true);
                document.frmArchivalOWDetailsLCPL.action="SearchArchivalOWDetailslcpl.jsp";
                document.frmArchivalOWDetailsLCPL.submit();				
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
    <table style="min-width:980" height="600" align="center" border="0" cellpadding="0" cellspacing="0">
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
                                        <td height="75"><table width="980" border="0" cellspacing="0" cellpadding="0">
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
                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=menuName%>" vqp_uid0=<%=menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";cdd__codebase<%=menuId%> = "<%=request.getContextPath()%>/js/";</script>
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
                                                                <td align="left" valign="top" class="cits_header_text">Archival Transaction Inquiry (Outward Details)</td>
                                                                <td width="10">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td height="15"></td>
                                                                <td></td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="10"></td>
                                                                <td align="center" valign="top" class="cits_header_text"><form id="frmArchivalOWDetailsLCPL" name="frmArchivalOWDetailsLCPL" method="post" >
                                                                        <table border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="cits_table_boder" >
                                                                            <tr>
                                                                                <td><table border="0" cellspacing="0" cellpadding="0" align="center">
                                                                                        <tr>
                                                                                            <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                    <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" ><span class="cits_tbl_header_text" title="Originate Bank">O.   Bk. :</span></td>
                                                                                                        <td align="left" valign="middle" bgcolor="#DFEFDE" ><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBankOrginal" id="cmbBankOrginal" onChange="doSearch(0)" class="cits_field_border" <%=(userType.equals(LCPL_Constants.user_type_bank_user) || userType.equals(LCPL_Constants.user_type_settlement_bank_user)) ? "disabled" : ""%>>
                                                                                                                <%
                                                                                                                    if (originalBankCode == null || (originalBankCode != null && originalBankCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                <%
                                                                                                                    if (colBank != null && colBank.size() > 0)
                                                                                                                    {
                                                                                                                        for (Bank bank : colBank)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=bank.getBankCode()%>" <%=(originalBankCode != null && bank.getBankCode().equals(originalBankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                <%
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
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Originate Branch">O. Br. :</span></td>
                                                                                                        <td align="left" valign="top" bgcolor="#DFEFDE" ><%


                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBranchOW" id="cmbBranchOW" class="cits_field_border" onChange="clearResultData()" >
                                                                                                                <%
                                                                                                                    if (originalBranchCode == null || (originalBranchCode != null && originalBranchCode.equals(LCPL_Constants.status_all)))
                                                                                                                    {
                                                                                                                %>
                                                                                                                <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                <%                                                                                                                        }
                                                                                                                else
                                                                                                                {
                                                                                                                %>
                                                                                                                <option value="<%=LCPL_Constants.status_all%>">-- All --</option>
                                                                                                                <%                                                                                                                                                            }
                                                                                                                %>
                                                                                                                <%
                                                                                                                    if (colBranch != null && colBranch.size() > 0)
                                                                                                                    {
                                                                                                                        for (Branch branch : colBranch)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=branch.getBranchCode()%>" <%=(originalBranchCode != null && branch.getBranchCode().equals(originalBranchCode)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                <%
                                                                                                                    }
                                                                                                                %>
                                                                                                            </select>
                                                                                                            <%
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <span class="cits_error">No branch details available.</span>
                                                                                                      <%}
                                                                                                                }
                                                                                                                catch (Exception e)
                                                                                                                {
                                                                                                                    System.out.println(e.getMessage());
                                                                                                                }
                                                                                                            %>                                                                                                        </td>
                                                                                                        <td align="left" valign="top" bgcolor="#B3D5C0" class="cits_tbl_header_text" ><span class="cits_tbl_header_text" title="Originate Account Details">O. Ac. :</span></td>
                                                                                                        <td align="left" valign="top" bgcolor="#DFEFDE" ><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td class="cits_common_text"><span class="cits_common_text" title="Originate Account Number.">No.</span></td>
                                                                                                                    <td width="2px"></td>
                                                                                                                    <td><input name="txtOrgActNo" type="text" class="cits_field_border" id="txtOrgActNo" size="20" maxlength="34" value="<%=(orgActNo != null) ? orgActNo : ""%>" onFocus="clearResultData()"></td>
                                                                                                                    <td width="5px"></td>
                                                                                                                    <td class="cits_common_text"><span class="cits_common_text" title="Name of the Originate Account.">Name</span></td>
                                                                                                                    <td width="2px"></td>
                                                                                                                    <td><input name="txtOrgActName" type="text" class="cits_field_border" id="txtOrgActName" size="28" maxlength="40" value="<%=(orgActName != null) ? orgActName : ""%>" onFocus="clearResultData()"></td>
                                                                                                                </tr>
                                                                                                            </table>                                                                                                        </td>
                                                                                                    </tr>

                                                                                                    <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Destination Bank">D. Bk. :</span></td>
                                                                                                        <td align="left" valign="middle" bgcolor="#DFEFDE"><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBankDes" id="cmbBankDes" onChange="doSearch(0)" class="cits_field_border" >
                                                                                                                <%
                                                                                                                    if (desBankCode == null || (desBankCode != null && desBankCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                <%
                                                                                                                    if (colDesBank != null && colDesBank.size() > 0)
                                                                                                                    {
                                                                                                                        for (Bank bank : colDesBank)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=bank.getBankCode()%>" <%=(desBankCode != null && bank.getBankCode().equals(desBankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                <%
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



                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Destination Branch">D. Br. :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE"><%

                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBranchDes" id="cmbBranchDes" class="cits_field_border" onChange="clearResultData()">
                                                                                                                <%
                                                                                                                    if (desBranchCode == null || (desBranchCode != null && desBranchCode.equals(LCPL_Constants.status_all)))
                                                                                                                    {
                                                                                                                %>
                                                                                                                <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                <%                                                                                                                        }
                                                                                                                else
                                                                                                                {
                                                                                                                %>
                                                                                                                <option value="<%=LCPL_Constants.status_all%>">-- All --</option>
                                                                                                                <%                                                                                                                                                            }
                                                                                                                %>
                                                                                                                <%
                                                                                                                    if (colDesBranch != null && colDesBranch.size() > 0)
                                                                                                                    {
                                                                                                                        for (Branch branch : colDesBranch)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=branch.getBranchCode()%>" <%=(desBranchCode != null && branch.getBranchCode().equals(desBranchCode)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                <%
                                                                                                                    }
                                                                                                                %>
                                                                                                            </select>
                                                                                                            <%
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <span class="cits_error">No branch details available.</span>
                                                                                                      <%}
                                                                                                                }
                                                                                                                catch (Exception e)
                                                                                                                {
                                                                                                                    System.out.println(e.getMessage());
                                                                                                                }
                                                                                                            %>                                                                                                        </td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Destination Account Details">D. Ac. :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE"> <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td class="cits_common_text"><span class="cits_common_text" title="Destination Account Number.">No.</span></td>
                                                                                                                    <td width="2px"></td>
                                                                                                                    <td><input name="txtDesActNo" type="text" class="cits_field_border" id="txtDesActNo" size="20" maxlength="34" value="<%=(desActNo != null) ? desActNo : ""%>" onFocus="clearResultData()"></td>
                                                                                                                    <td width="5px"></td>
                                                                                                                    <td class="cits_common_text"><span class="cits_common_text" title="Name of the Destination Account.">Name</span></td>
                                                                                                                    <td width="2px"></td>
                                                                                                                    <td><input name="txtDesActName" type="text" class="cits_field_border" id="txtDesActName" size="28" maxlength="40" value="<%=(desActName != null) ? desActName : ""%>" onFocus="clearResultData()"></td>
                                                                                                                </tr>
                                                                                                            </table>                                                                                                         </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Transaction Type">T. Ty. :</span></td>
                                                                                                        <td align="left" valign="middle" bgcolor="#DFEFDE"><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbTransType" id="cmbTransType" onChange="clearResultData()" class="cits_field_border" >
                                                                                                                <%
                                                                                                                    if (desBankCode == null || (desBankCode != null && desBankCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                <%
                                                                                                                    if (colTransType != null && colTransType.size() > 0)
                                                                                                                    {
                                                                                                                        for (TransactionType tType : colTransType)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=tType.getTc()%>" <%=(transCode != null && tType.getTc().equals(transCode)) ? "selected" : ""%> ><%=tType.getTc()%> - <%=tType.getType() != null ? (tType.getType().equals(LCPL_Constants.transaction_type_credit) ? "Cr" : "Db") : "N/A"%> - <%=tType.getDesc()%></option>
                                                                                                                <%
                                                                                                                    }
                                                                                                                %>
                                                                                                            </select>
                                                                                                          <%

                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <span class="cits_error">No transaction types available.</span>
                                                                                                            <%  }


                                                                                                                }
                                                                                                                catch (Exception e)
                                                                                                                {
                                                                                                                    System.out.println(e.getMessage());
                                                                                                                }

                                                                                                            %>                                                                                                        </td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Return Reason">R. Rs. :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE"><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbReturnReason" id="cmbReturnReason" onChange="clearResultData()" class="cits_field_border" >
                                                                                                                <%
                                                                                                                    if (desBankCode == null || (desBankCode != null && desBankCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                <%
                                                                                                                    if (colReturnReason != null && colReturnReason.size() > 0)
                                                                                                                    {
                                                                                                                        for (ReturnReason rtnReason : colReturnReason)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=rtnReason.getReturnCode()%>" <%=(returnCode != null && rtnReason.getReturnCode().equals(returnCode)) ? "selected" : ""%> ><%=rtnReason.getReturnCode()%> - <%=rtnReason.getPrintAS()%></option>
                                                                                                                <%
                                                                                                                    }
                                                                                                                %>
                                                                                                            </select>
                                                                                                          <%

                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <span class="cits_error">No return reasons available.</span>
                                                                                                            <%  }


                                                                                                                }
                                                                                                                catch (Exception e)
                                                                                                                {
                                                                                                                    System.out.println(e.getMessage());
                                                                                                                }

                                                                                                            %>                                                                                                        </td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Amount">Amt. :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td class="cits_common_text"><span class="cits_common_text" title="Minimum Amount.">Mn.</span></td>
                                                                                                                    <td width="2px"></td>
                                                                                                                    <td><input name="txtAmountMin" type="text" class="cits_field_border" id="txtAmountMin" size="20" maxlength="16" value="<%=(minAmount != null) ? minAmount : ""%>" onFocus="clearResultData()"></td>
                                                                                                                    <td width="5px"></td>
                                                                                                                    <td class="cits_common_text"><span class="cits_common_text" title="Maximum Amount.">&nbsp;&nbsp;&nbsp;Mx.</span></td>
                                                                                                                    <td width="2px"></td>
                                                                                                                    <td><input name="txtAmountMax" type="text" class="cits_field_border" id="txtAmountMax" size="20" maxlength="16" value="<%=(maxAmount != null) ? maxAmount : ""%>" onFocus="clearResultData()"></td>
                                                                                                                    <td width="5px"></td>
                                                                                                                    <td class="cits_common_text"><span class="cits_common_text" title="Please Enter the Amounts in cents.">(cents)</span></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Business Date">B. Dt. :</span></td>
                                                                                                        <td align="left" valign="middle" bgcolor="#DFEFDE"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td valign="middle"><input name="txtFromBusinessDate" id="txtFromBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(fromBusinessDate == null || fromBusinessDate.equals("0") || fromBusinessDate.equals(LCPL_Constants.status_all)) ? "" : fromBusinessDate%>" >                                                                                                                    </td>
                                                                                                                    
                                                                                                                    
                                                                                                                    <td width="10" valign="middle"></td>
                                                                                                                    <td valign="middle"><input name="txtToBusinessDate" id="txtToBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(toBusinessDate == null || toBusinessDate.equals("0") || toBusinessDate.equals(LCPL_Constants.status_all)) ? "" : toBusinessDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                    
                                                                                                                    
                                                                                                                    <td width="10px" valign="middle"></td>
                                                                                                                    <td valign="middle"><input name="btnClear" id="btnClear" value="Reset" type="button" onClick="resetDates()" class="cits_custom_button_small" /></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Session">Sess. :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE"><select name="cmbSession" id="cmbSession" class="cits_field_border" onChange="clearResultData()">

                                                                                                                <option value="<%=LCPL_Constants.status_all%>" <%=(winSess != null && winSess.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                <option value="<%=LCPL_Constants.window_session_one%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_one)) ? "selected" : ""%>><%=LCPL_Constants.window_session_one%></option>
                                                                                                                <option value="<%=LCPL_Constants.window_session_two%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_two)) ? "selected" : ""%>><%=LCPL_Constants.window_session_two%></option>
                                                                                                            </select></td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="File Id">F. Id :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE">
                                                                                                          <table border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                              <td width="18"></td>
                                                                                                              <td width="2px"></td>
                                                                                                              <td><input name="txtFileId" type="text" class="cits_field_border" id="txtFileId" size="20" maxlength="20" value="<%=(fileId != null) ? fileId : ""%>" onFocus="clearResultData()"></td>
                                                                                                            </tr>
                                                                                                          </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Value Date">V. Dt. :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE" class="cits_tbl_header_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td valign="middle"><input name="txtFromValueDate" id="txtFromValueDate" type="text" onFocus="this.blur();clearResultData()" class="tcal" size="11" value="<%=(fromValueDate == null || fromValueDate.equals("0") || fromValueDate.equals(LCPL_Constants.status_all)) ? "" : fromValueDate%>" >                                                                                                                    </td>                                                                                                                    
                                                                                                                    
                                                                                                                    <td width="10" valign="middle"></td>
                                                                                                                    <td valign="middle"><input name="txtToValueDate" id="txtToValueDate" type="text" onFocus="this.blur();clearResultData()" class="tcal" size="11" value="<%=(toValueDate == null || toValueDate.equals("0") || toValueDate.equals(LCPL_Constants.status_all)) ? "" : toValueDate%>" onChange="clearResultData()">                                                                                                                    </td>                                                                                                                    
                                                                                                                    
                                                                                                                    <td width="10px" valign="middle"></td>
                                                                                                                    <td valign="middle"><input name="btnClear" id="btnClear" value="Reset" type="button" onClick="resetValueDates()" class="cits_custom_button_small" /></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text"><span class="cits_tbl_header_text" title="Status">Stat :</span></td>
                                                                                                        <td align="left" bgcolor="#DFEFDE" class="cits_tbl_header_text"><select name="cmbStatus" id="cmbStatus"  class="cits_field_border" onChange="clearResultData()">
                                                                                                                                        <%
                                                                                                                                            if (status == null || status.equals(LCPL_Constants.status_all))
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
                                                                                                                                            if (colStatus != null && colStatus.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (FileStatus st : colStatus)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=st.getStatusId()%>" <%=(status != null && st.getStatusId().equals(status)) ? "selected" : ""%> > <%=st.getStatusId() + " - " + st.getDescription()%></option>
                                                                                                                                        <%
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select></td>
                                                                                                        <td colspan="2" align="right" bgcolor="#CDCDCD" class="cits_tbl_header_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /><input type="hidden" id="hdnReqPageNo" name="hdnReqPageNo" value="<%=reqPageNo%>" /></td>
                                                                                                                    <td align="center">                                                                                                                     
                                                                                                                        <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                    <td width="5"></td>
                                                                                                                    <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="doSearch(1)"  class="cits_custom_button"/></td>
                                                                                                                    <td align="right" width="5"></td>
                                                                                                                    <td align="right"><input name="btnClear" id="btnClear" value="Clear" type="button" onClick="clearRecords()" class="cits_custom_button" /></td>
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
                                                                <td align="center" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                    <%
                                                                                        if (isSearchReq != null && isSearchReq.equals("1"))
                                                                                        {

                                                                                            if (totalRecordCount == 0)
                                                                                            {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="15" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                    </tr>

                                                                                    <%                                                                                    }
                                                                                    else if (colResult.size() > LCPL_Constants.maxWebRecords)
                                                                                    {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="15" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="noresultbanner" class="cits_error">Sorry! Details view prevented due to too many records. (Max Viewable Records Count - <%=LCPL_Constants.maxWebRecords%> , Current Records Count - <%=colResult.size()%>, This can be lead to memory overflow in your machine.)<br/>Please refine your search criteria and Search again.</div></td>
                                                                                    </tr>


                                                                                    <%   }
                                                                                    else
                                                                                    {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="10" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="resultdata" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="right">

                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                                <tr bgcolor="#DFE0E1">
                                                                                                                    <td width="25" align="right" bgcolor="#D8D8D8"><input type="image" src="<%=request.getContextPath()%>/images/printer2.png" width="18" height="18" title="Print" onClick="doPrint()"/></td>
                                                                                                                    <td align="right" bgcolor="#D8D8D8"><table border="0" cellspacing="0" cellpadding="2">
                                                                                                                            <tr>
                                                                                                                              <td align="right" valign="middle" class="cits_common_text"> <b><%=totalRecordCount%></b> - Total Result(s) Found.</td>
                                                                                                                              <td align="center" valign="middle" class="cits_common_text" width="15"> <b>|</b> </td>
                                                                                                                                <td align="right" valign="middle" class="cits_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                <td width="15"></td>
                                                                                                                                <td align="center" valign="middle">
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == 1)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16" title="First Page" /> 													<%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                                <td align="center" valign="middle">
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == 1)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>

                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                                <td width="2"></td>
                                                                                                                                <td><select class="cits_field_border_number" name="cmbPageNo" id="cmbPageNo" onChange="setReqPageNoForCombo()">
                                                                                                                                        <%
                                                                                                                                            for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                                      <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select></td>
                                                                                                                                <td width="2"></td>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == totalPageCount)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                                    <%}
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)" /><%}%> </td>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == totalPageCount)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                                <td width="5"></td>
                                                                                                                            </tr>
                                                                                                                  </table></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                        <table  border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" class="cits_table_boder">
                                                                                                                    <tr>
                                                                                                                        <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business<br/>
                                                                                                                            Date</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Session">Ses.</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">File ID</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Status">Stat.</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Reference ID">Ref.<br/>ID</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Bank-Branch">Org.<br/>
                                                                                                                            Bk-Br</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Account No.">Org.<br/>Acc. No.</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Account Type">Org.<br/>Acc.<br/>Type</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Account Name">Org.<br/>
                                                                                                                            Acc. Name</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Bank-Branch">Des.<br/>Bk-Br</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Account No.">Des.<br/>Acc. No.</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Account Type">Des.<br/>Acc.<br/>Type</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Account Name">Des.<br/>Acc. Name</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Transaction Type(Code)">TC</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Reject Code">RC</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Value<br/>Date</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Currency Code">Cur.<br/>Code</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Amount</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Purpose Code (Main-Sub)" >Purp.<br/>Code</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Is<br/>Return</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Particulars">Part.</td>
                                                                                                                    </tr>
                                                                                                                    <%
                                                                                                                        int rowNum = 0 + ((reqPageNo - 1) * LCPL_Constants.noPageRecords);                                                                                                                   

                                                                                                                        long totalAmount = 0;

                                                                                                                        for (ArchivalOWDetails owdetails : colResult)
                                                                                                                        {
                                                                                                                            rowNum++;
                                                                                                                            totalAmount += owdetails.getAmount();
                                                                                                                    %>
                                                                                                                                                                                                        <!--form action="" id="frmRemarks_<%=rowNum%>" name="frmRemarks_<%=rowNum%>" method="post" target="_self"-->
                                                                                                                    <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                        <td align="right" class="cits_common_text" ><%=rowNum%>.</td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getBusinessDate()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getSession()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getFileId()%></td>
                                                                                                                        <td align="center"  class="cits_common_text" title="<%=owdetails.getStatusDesc()!=null?owdetails.getStatusDesc():"N/A" %>"><%=owdetails.getStatusDesc()!=null?owdetails.getStatusDesc().length()>6?owdetails.getStatusDesc().substring(0, 4)+ "..":owdetails.getStatusDesc():"N/A" %></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getRefId() %></td>
                                                                                                                        <td  class="cits_common_text"><%=owdetails.getOrgBankCode()%>-<%=owdetails.getOrgBranchCode()%></td>
                                                                                                                      <td  class="cits_common_text"><%=owdetails.getOrgAcNoDec()%></td>
                                                                                                                      <td align="center"  class="cits_common_text" title="<%=owdetails.getOrgAcTypeDesc() %>"><%=owdetails.getOrgAcType() %></td>
                                                                                                                      <td  class="cits_common_text"><%=owdetails.getOrgAcNameDec() %></td>
                                                                                                                      <td  class="cits_common_text"><%=owdetails.getDesBankCode()%>-<%=owdetails.getDesBranchcode()%></td>
                                                                                                                      <td  class="cits_common_text"><%=owdetails.getDesAcNoDec() %></td>
                                                                                                                      <td align="center"  class="cits_common_text" title="<%=owdetails.getDesAcTypeDesc() %>"><%=owdetails.getDesAcType()%></td>
                                                                                                                        <td  class="cits_common_text"><%=owdetails.getDesAcNameDec() %></td>
                                                                                                                      <td align="center"  class="cits_common_text"><%=owdetails.getTc()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getRc()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getValueDate()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getCurrencyCode()%></td>
                                                                                                                        <td align="right"  class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(owdetails.getAmount()).doubleValue()) / 100)%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getPurposeCode() %><%=(owdetails.getSubpurposeCode()!=null&&owdetails.getSubpurposeCode().length()>4)?"-"+owdetails.getSubpurposeCode().substring(4):"" %></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getIsReturn() %></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getParticulars() %></td>
                                                                                                                    </tr>
                                                                                                                    <!--/form-->
                                                                                                          <%
                                                                                                                        }

                                                                                                                    %>
                                                                                                                    <tr  class="cits_common_text">
                                                                                                                        <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">Total</td>
                                                                                                                        <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=new DecimalFormat("#0.00").format((new Long(totalAmount).doubleValue()) / 100)%></td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                          </table>
<div id="printableArea" style="display:none">



                                                                                                                <table  border="0" cellspacing="1" cellpadding="2" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                    <tr>
                                                                                                                        <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business<br/>
                                                                                                                            Date</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Session">Ses.</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">File ID</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Reference ID">Ref.<br/>ID</td>
                                                                                                                        <!--td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Out.<br/>Bk-Br</td-->
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Bank-Branch">Org.<br/>
                                                                                                                            Bk-Br</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Account No.">Org.<br/>Acc. No.</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Account Type">Org.<br/>Acc.<br/>Type</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Originating Account Name">Org.<br/>
                                                                                                                            Acc. Name</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Bank-Branch">Des.<br/>Bk-Br</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Account No.">Des.<br/>Acc. No.</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Account Type">Des.<br/>Acc.<br/>Type</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Destination Account Name">Des.<br/>Acc. Name</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Transaction Type(Code)">TC</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Reject Code">RC</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Value<br/>Date</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Cur.<br/>
                                                                                                                            Code</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Amount</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Purpose Code (Main-Sub)" >Purp.<br/>Code</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" title="Particulars">Part.</td>
                                                                                                                    </tr>
                                                                                                                    <%
                                                                                                                        int rowNum2 = 0 + ((reqPageNo - 1) * LCPL_Constants.noPageRecords);                                                                                                                     

                                                                                                                        long totalAmount2 = 0;                                                                                                                       

                                                                                                                        for (ArchivalOWDetails owdetails : colResult)
                                                                                                                        {
                                                                                                                            rowNum2++;                                                                                                                            
                                                                                                                            totalAmount2 += owdetails.getAmount();
                                                                                                                    %>
                                                                                                                                                                                                        
                                                                                                                    <tr bgcolor="<%=rowNum2 % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>" >
                                                                                                                        <td align="right" class="cits_common_text" ><%=rowNum2%>.</td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getBusinessDate()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getSession()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getFileId()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getRefId() %></td>                                                                                                                        
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getOrgBankCode()%>-<%=owdetails.getOrgBranchCode()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getOrgAcNoDec()%></td>
                                                                                                                        <td align="center"  class="cits_common_text" title="<%=owdetails.getOrgAcTypeDesc() %>"><%=owdetails.getOrgAcType() %></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getOrgAcNameDec() %></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getDesBankCode()%>-<%=owdetails.getDesBranchcode()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getDesAcNoDec() %></td>
                                                                                                                        <td align="center"  class="cits_common_text" title="<%=owdetails.getDesAcTypeDesc() %>"><%=owdetails.getDesAcType()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getDesAcNameDec() %></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getTc()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getRc()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getValueDate()%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getCurrencyCode()%></td>
                                                                                                                        <td align="right"  class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(owdetails.getAmount()).doubleValue()) / 100)%></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getPurposeCode() %><%=(owdetails.getSubpurposeCode()!=null&&owdetails.getSubpurposeCode().length()>4)?"-"+owdetails.getSubpurposeCode().substring(4):"" %></td>
                                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getParticulars() %></td>
                                                                                                                    </tr>
                                                                                                                    
                                                                                                          <%
                                                                                                                        }

                                                                                                                    %>
                                                                                                                    <tr  class="cits_common_text">
                                                                                                                        <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">Total</td>
                                                                                                                        <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=new DecimalFormat("#0.00").format((new Long(totalAmount2).doubleValue()) / 100)%></td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>

                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr >
                                                                                                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                                <tr bgcolor="#DFE0E1">
                                                                                                                    <td width="25" align="right" valign="middle" bgcolor="#D8D8D8"><input type="image" src="<%=request.getContextPath()%>/images/printer2.png" width="18" height="18" title="Print" onClick="doPrint()"/></td>
                                                                                                                    <td align="right" bgcolor="#D7D7D7"><table border="0" cellspacing="0" cellpadding="2">
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" class="cits_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                <td width="15"></td>
                                                                                                                                <td align="center" valign="middle">
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == 1)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16"  /> 													<%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                                <td align="center" valign="middle">
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == 1)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>

                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                                <td width="2"></td>
                                                                                                                                <td><select class="cits_field_border_number" name="cmbPageNo2" id="cmbPageNo2" onChange="setReqPageNoForCombo2()">
                                                                                                                                        <%
                                                                                                                                            for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                                      <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select></td>
                                                                                                                                <td width="2"></td>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == totalPageCount)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                                    <%}
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)"/><%}%> </td>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        if (reqPageNo == totalPageCount)
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                              <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                                <td width="5"></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>




                                                                                            </div></td>
                                                                                    </tr>
                                                                                    <%
                                                                                            }
                                                                                        }

                                                                                    %>
                                                                                    <tr><td height="10"></td>
                                                                                    </tr>


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

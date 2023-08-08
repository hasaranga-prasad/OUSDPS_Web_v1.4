
<%@page import="java.util.*,java.sql.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../../error.jsp"%>
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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user) || userType.equals(LCPL_Constants.user_type_lcpl_supervisor)))
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
    Collection<Bank> colBank = null;
    Bank bankDetails = null;
    String reqType = null;
    String cmbBankCode = null;
    String bankCode = null;
    String shortName = null;
    String fullName = null;
    String bankAC = null;
    String status = null;

    String msg = null;

    boolean result = false;

    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);

    reqType = (String) request.getParameter("hdnRequestType");

    if (reqType == null)
    {
        cmbBankCode = "-1";
    }
    else if (reqType.equals("0"))
    {
        cmbBankCode = (String) request.getParameter("cmbBank");
        bankDetails = DAOFactory.getBankDAO().getBankDetails(cmbBankCode);

        bankCode = bankDetails.getBankCode();
        shortName = bankDetails.getShortName();
        fullName = bankDetails.getBankFullName();
        bankAC = bankDetails.getAccNo();
        status = bankDetails.getStatus();
    }
    else if (reqType.equals("1"))
    {
        cmbBankCode = (String) request.getParameter("cmbBank");
        bankDetails = DAOFactory.getBankDAO().getBankDetails(cmbBankCode);

        bankCode = (String) request.getParameter("txtBankCode");
        shortName = (String) request.getParameter("txtShortName");
        fullName = (String) request.getParameter("txtFullName");
        bankAC = (String) request.getParameter("txtBankAC");
        status = (String) request.getParameter("cmbStatus");
        BankDAO bankDAO = DAOFactory.getBankDAO();

        result = bankDAO.modifyBank(new Bank(bankCode, shortName, fullName, bankAC, status, userName));

        if (!result)
        {
            msg = bankDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_bank_branch_maintenance_modify_bank_details, "| Bank Code - " + bankCode + ", Short Name - (New : " + shortName + ", Old : " + bankDetails.getShortName() + "), Full Name - (New :" + fullName + ", Old : " + bankDetails.getBankFullName() + "), Account No. - (New :" + bankAC + ", Old : " + bankDetails.getAccNo() + "), Bank Status - (New : " + status + ", Old : " + bankDetails.getStatus() + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_bank_branch_maintenance_modify_bank_details, "| Bank Code - " + bankCode + ", Short Name - (New : " + shortName + ", Old : " + bankDetails.getShortName() + "), Full Name - (New :" + fullName + ", Old : " + bankDetails.getBankFullName() + "), Account No. - (New :" + bankAC + ", Old : " + bankDetails.getAccNo() + "), Bank Status - (New : " + status + ", Old : " + bankDetails.getStatus() + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));

            if (status.equals(LCPL_Constants.status_deactive))
            {
                Collection<User> col_user = DAOFactory.getUserDAO().getUsers(new User(LCPL_Constants.status_all, bankCode, LCPL_Constants.status_all, LCPL_Constants.status_all), LCPL_Constants.status_pending);

                for (User usrData : col_user)
                {

                    UserDAO userDAO = DAOFactory.getUserDAO();

                    boolean result_usr = userDAO.setUserStatus(usrData.getUserId(), LCPL_Constants.status_deactive);

                    String currentUserStat = usrData.getStatus() != null ? usrData.getStatus().equals(LCPL_Constants.status_active) ? "Active" : usrData.getStatus().equals(LCPL_Constants.status_deactive) ? "Inactive" : usrData.getStatus().equals(LCPL_Constants.status_locked) ? "Locked" : usrData.getStatus().equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";

                    if (!result_usr)
                    {
                        msg = userDAO.getMsg();
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_deactivate_all_users_when_bank_deactivate, "| User Name - " + usrData.getUserId() + ", Status - (New : Inactive, Old : " + currentUserStat + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                    }
                    else
                    {
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_deactivate_all_users_when_bank_deactivate, "| User Name - " + usrData.getUserId() + ", Status - (New : Inactive, Old : " + currentUserStat + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                    }
                }
            }

        }
    }
%>
<html>
    <head><title>OUSDPS Web - Modify Bank</title>
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

            function setRequestType(status) 
            {
            if(status) 
            {
            document.getElementById('hdnRequestType').value = "1";
            }
            else 
            {
            document.getElementById('hdnRequestType').value = "0";
            }
            }


            function clearRecords_onPageLoad()
            {                
            showClock(3);
            }          

            function clearRecords()
            {
            document.getElementById('txtShortName').value = "";
            document.getElementById('txtFullName').value = "";				
            document.getElementById('cmbStatus').selectedIndex = 0;				
            document.getElementById('txtBankAC').value = "";
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
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error')!= null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            doSearch();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }

            if(document.getElementById('displayMsg_success')!=null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            doSearch();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }                
            }

            function fieldValidation()
            {                
            var shortname = document.getElementById('txtShortName').value;
            var fullname = document.getElementById('txtFullName').value;
            var bnkAC = document.getElementById('txtBankAC').value;
            var status = document.getElementById('cmbStatus').value;

            var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
            var numbers = /^[0-9]*$/;


            if(isempty(shortname))
            {
            alert("Bank Must Have a Short Name");
            document.getElementById('txtShortName').focus();
            return false;
            }
            else if (numbers.test(shortname)) 
            {
            alert("Short Name should not contain Numbers");
            document.getElementById('txtShortName').focus();
            return false;
            }

            for (var i = 0; i < shortname.length; i++) 
            {
            if (iChars.indexOf(shortname.charAt(i)) != -1) 
            {
            alert ("Special Characters are not allowed to Short Name!) ");
            document.getElementById('txtShortName').focus();
            return false;
            }
            }

            if(isempty(fullname))
            {
            alert("Full Name can not be empty!");
            document.getElementById('txtFullName').focus();
            return false;
            }

            if(isempty(bnkAC))
            {
            alert("Account No. Can't be Empty");
            document.getElementById('txtBankAC').focus();
            return false;
            }
            else if (!numbers.test(bnkAC)) 
            {
            alert("Account No. should contain Numbers Only");
            document.getElementById('txtBankAC').focus();
            return false;
            }

            if(status==null || status=="-1")
            {
            alert("Select Bank Status");
            document.getElementById('cmbStatus').focus();
            return false;
            }






            document.frmModifyBank.action="ModifyBank.jsp";
            document.frmModifyBank.submit();
            return true;   
            }			

            function doSearch()
            {
            var cmbBankVal = document.getElementById('cmbBank').value;

            if(cmbBankVal==null || cmbBankVal=="-1")
            {
            clearResultData();
            return false;
            }
            else
            {
            setRequestType(false);
            document.frmModifyBank.action="ModifyBank.jsp";
            document.frmModifyBank.submit();
            return true;				
            }			
            }

            function doUpdate()
            {
            setRequestType(true);                    
            fieldValidation();				
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

            function findSpaces(str)
            {               
            var status = false;
            var strTrimed = this.trim(str);

            for (var i=0;i<strTrimed.length;i++)
            {
            if(strTrimed[i]== " ")
            {
            status = true;
            break;
            }
            }

            return status;                
            }

            function trim(str) 
            {
            return str.replace(/^\s+|\s+$/g,"");
            }


        </script>

    </head>

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="clearRecords_onPageLoad()">
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
                                                                <td align="center" valign="middle"><table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="left" valign="top" >
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">Modify Bank</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="100"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text">
                                                                                            <form name="frmModifyBank" id="frmModifyBank" method="post" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><table border="0" align="center" cellspacing="1" cellpadding="5" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Bank :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE">
                                                                                                                        <select name="cmbBank" id="cmbBank" class="cits_field_border" onChange="setRequestType(false);
                                                                                                                                        doSearch();">

                                                                                                                            <option value="-1" <%=(cmbBankCode == null || cmbBankCode.equals("-1")) ? "selected" : ""%>>-- Select Bank --</option>

                                                                                                                            <%
                                                                                                                                if (colBank != null && !colBank.isEmpty())
                                                                                                                                {

                                                                                                                                    for (Bank bank : colBank)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=bank.getBankCode()%>" <%=(cmbBankCode != null && bank.getBankCode().equals(cmbBankCode)) ? "selected" : ""%>><%=bank.getBankCode()%> - <%=bank.getBankFullName()%></option>

                                                                                                                            <% }%>
                                                                                                                        </select>
                                                                                                                        <% }
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                        <span class="cits_error">No bank details available.</span>
                                                                                                                        <%}%><input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" /></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">
                                                                                                            <%
                                                                                                                if (reqType != null)
                                                                                                                {
                                                                                                            %>

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
                                                                                                                    if (bankDetails == null)
                                                                                                                    {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                                </tr>

                                                                                                                <%                                                                                    }
                                                                                                                else
                                                                                                                {

                                                                                                                %>

                                                                                                                <tr>

                                                                                                                    <td><div id="resultdata"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                <tr>
                                                                                                                                    <td align="center">
                                                                                                                                        <%                                                                                                                                            if (reqType.equals("1"))
                                                                                                                                            {

                                                                                                                                                if (result == true)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <div id="displayMsg_success" class="cits_Display_Success_msg" >

                                                                                                                                            Bank data modified Sucessfully.                                                                                                </div>
                                                                                                                                            <% }
                                                                                                                                            else
                                                                                                                                            {%>


                                                                                                                                        <div id="displayMsg_error" class="cits_Display_Error_msg" >Bank data modification Failed.- <span class="cits_error"><%=msg%></span></div>
                                                                                                                                            <%                                                                                            }
                                                                                                                                            %>
                                                                                                                                        <input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" />
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %></td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td height="10"></td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td align="center" valign="middle">

                                                                                                                                        <table border="0" cellspacing="1" cellpadding="5" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                                            <tr>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Current Value</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">New Value</td>
                                                                                                                                            </tr>

                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Bank Code :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text"><%=bankDetails.getBankCode()%>                                                                                </td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                    <input type="hidden" name="txtBankCode" id="txtBankCode" class="cits_success" value="<%=bankCode%>" maxlength="4" readonly/></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Short Name :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text"><%=bankDetails.getShortName()%>
                                                                                                                                                    <input type="hidden" name="hdnShortName" id="hdnShortName" class="cits_common_text" value="<%=bankDetails.getShortName()%>"/>                                                                                </td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                    <input type="text" name="txtShortName" id="txtShortName" class="cits_field_border" maxlength="6" value="<%=shortName != null ? shortName : ""%>" onFocus="hideMessage_onFocus()"/>                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Full Name :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text"><%=bankDetails.getBankFullName()%>
                                                                                                                                                    <input type="hidden" name="hdnFullName" id="hdnFullName" class="cits_common_text" value="<%=bankDetails.getBankFullName()%>"/>                                                                                </td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                    <input name="txtFullName" type="text" class="cits_field_border" id="txtFullName" size="50" value="<%=fullName != null ? fullName : ""%>" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Account No. :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text"><%=bankDetails.getAccNo()%>
                                                                                                                                                    <input type="hidden" name="hdnBankAC" id="hdnBankAC" class="cits_common_text" value="<%=bankDetails.getAccNo()%>"/></td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text"><input name="txtBankAC" type="text" class="cits_field_border" id="txtBankAC" onFocus="hideMessage_onFocus()"
                                                                                                                                                                                                        value="<%=bankAC != null ? bankAC : ""%>" size="15" maxlength="15"/></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Bank Status :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                    <%
                                                                                                                                                        String stat = null;

                                                                                                                                                        if (bankDetails.getStatus() == null)
                                                                                                                                                        {
                                                                                                                                                            stat = "N/A";
                                                                                                                                                        }
                                                                                                                                                        else if (bankDetails.getStatus().equals(LCPL_Constants.status_active))
                                                                                                                                                        {
                                                                                                                                                            stat = "Active";
                                                                                                                                                        }
                                                                                                                                                        else if (bankDetails.getStatus().equals(LCPL_Constants.status_deactive))
                                                                                                                                                        {
                                                                                                                                                            stat = "Inactive";
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            stat = "Other";
                                                                                                                                                        }
                                                                                                                                                    %>

                                                                                                                                                    <%=stat%>                                                                                                                        </td>
                                                                                                                                                <td bgcolor="#DFEFDE">
                                                                                                                                                    <select name="cmbStatus" id="cmbStatus" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                        <option value="-1" <%=status == null ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                        <option value="<%=LCPL_Constants.status_active%>" <%=status != null && status.equals(LCPL_Constants.status_active) ? "selected" : ""%>>Active</option>
                                                                                                                                                        <option value="<%=LCPL_Constants.status_deactive%>" <%=status != null && status.equals(LCPL_Constants.status_deactive) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                    </select>                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>  <td height="35" colspan="3" align="right" bgcolor="#CDCDCD" class="cits_common_text_bold">



                                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td><input type="button" value="Update" onClick="doUpdate()" class="cits_custom_button">                             </td>
                                                                                                                                                            <td width="5"></td>
                                                                                                                                                            <td><input type="button" name="btnClear" id="btnClear" value="Clear" class="cits_custom_button" onClick="clearRecords()"/>                                                            </td></tr>
                                                                                                                                                    </table>

                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                        </table>                                                                                                            </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>                                                                                            </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>

                                                                                                            <%                                                                                                                }
                                                                                                            %>                                                                                </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                                </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">                                                                </td>
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
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../../error.jsp"%>

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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user) || userType.equals(LCPL_Constants.user_type_lcpl_supervisor) || userType.equals(LCPL_Constants.user_type_lcpl_administrator)))
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
    Collection<UserLevel> colUserLevel = null;
    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;
    Collection<User> col_user = null;

    String isReq = null;
    String selectedUserId = null;
    String newUserPassword = null;
    String newUserReTypePassword = null;
    String newUserLevel = null;
    String newUserStatus = null;
    String newUserBank = null;
    String newUserBranch = null;
    String msg = null;
    String defaultPwd = null;

    boolean result = false;

    colUserLevel = DAOFactory.getUserLevelDAO().getUserLevelDetails();
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);

    defaultPwd = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_default_pwd);

    isReq = (String) request.getParameter("hdnReq");

    //System.out.println("isReq - " + isReq);
    if (isReq == null)
    {
        isReq = "0";
        newUserLevel = LCPL_Constants.status_all;
        newUserStatus = LCPL_Constants.status_all;
        newUserBank = LCPL_Constants.status_all;
        newUserBranch = LCPL_Constants.status_all;
        selectedUserId = "-1";

        col_user = DAOFactory.getUserDAO().getUsers(new User(newUserLevel, newUserBank, newUserBranch, newUserStatus), LCPL_Constants.status_pending);
    }
    else if (isReq.equals("0"))
    {
        selectedUserId = (String) request.getParameter("cmbUserId");
        newUserPassword = (String) request.getParameter("txtUserPassword");
        newUserReTypePassword = (String) request.getParameter("txtReTypePassword");
        newUserLevel = (String) request.getParameter("cmbUserLevel");
        newUserStatus = (String) request.getParameter("cmbStatus");
        newUserBank = (String) request.getParameter("cmbBank");
        newUserBranch = (String) request.getParameter("cmbBranch");

        if (newUserLevel != null && (newUserLevel.equals(LCPL_Constants.user_type_bank_user) || newUserLevel.equals(LCPL_Constants.user_type_settlement_bank_user) || newUserLevel.equals(LCPL_Constants.status_all)))
        {
            if (newUserLevel.equals(LCPL_Constants.status_all))
            {
                newUserBank = LCPL_Constants.status_all;
                newUserBranch = LCPL_Constants.status_all;
                selectedUserId = "-1";
            }
            else
            {

                if (newUserBank != null && !newUserBank.equals(LCPL_Constants.status_all))
                {
                    if (newUserBank.equals(LCPL_Constants.LCPL_bank_code))
                    {
                        newUserBank = LCPL_Constants.status_all;
                    }
                    else
                    {
                        colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, LCPL_Constants.status_pending);
                    }
                }
            }
        }
        else
        {
            newUserBank = LCPL_Constants.LCPL_bank_code;
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, LCPL_Constants.status_pending);
            newUserBranch = LCPL_Constants.LCPL_default_branch_code;
        }

        col_user = DAOFactory.getUserDAO().getUsers(new User(newUserLevel, newUserBank, newUserBranch, newUserStatus), LCPL_Constants.status_pending);

    }
    else if (isReq.equals("1"))
    {
        selectedUserId = (String) request.getParameter("cmbUserId");
        newUserPassword = (String) request.getParameter("txtUserPassword");
        newUserReTypePassword = (String) request.getParameter("txtReTypePassword");
        newUserLevel = (String) request.getParameter("cmbUserLevel");
        newUserStatus = (String) request.getParameter("cmbStatus");
        newUserBank = (String) request.getParameter("cmbBank");
        newUserBranch = (String) request.getParameter("cmbBranch");

        col_user = DAOFactory.getUserDAO().getUsers(new User(newUserLevel, newUserBank, newUserBranch, newUserStatus), LCPL_Constants.status_pending);

        if (newUserBank != null && !newUserBank.equals(LCPL_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, LCPL_Constants.status_pending);
        }

        String currentUserStat = null;
        String userStat = null;

        if (newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_all))
        {
            User objUser = DAOFactory.getUserDAO().getUserDetails(selectedUserId, LCPL_Constants.status_all);

            currentUserStat = objUser.getStatus();

            if (objUser != null && (objUser.getStatus().equals(LCPL_Constants.status_expired) || objUser.getStatus().equals(LCPL_Constants.status_locked)))
            {
                userStat = LCPL_Constants.status_active;
            }
        }
        else if (newUserStatus != null && (newUserStatus.equals(LCPL_Constants.status_expired) || newUserStatus.equals(LCPL_Constants.status_locked)))
        {
            currentUserStat = newUserStatus;
            //userStat = LCPL_Constants.status_active;
        }

        UserDAO userDAO = DAOFactory.getUserDAO();

        result = userDAO.resetUserPassword(new User(selectedUserId, newUserPassword, userStat));

        if (!result)
        {
            msg = userDAO.getMsg();

            currentUserStat = currentUserStat != null ? currentUserStat.equals(LCPL_Constants.status_active) ? "Active" : currentUserStat.equals(LCPL_Constants.status_deactive) ? "Deactive" : currentUserStat.equals(LCPL_Constants.status_locked) ? "Locked" : currentUserStat.equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";
            userStat = userStat != null ? userStat.equals(LCPL_Constants.status_active) ? "Active" : userStat.equals(LCPL_Constants.status_deactive) ? "Deactive" : userStat.equals(LCPL_Constants.status_locked) ? "Locked" : userStat.equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";

            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_reset_user_password, "| User Name - " + selectedUserId + ", Status - (New : " + userStat + ", Old : " + currentUserStat + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            currentUserStat = currentUserStat != null ? currentUserStat.equals(LCPL_Constants.status_active) ? "Active" : currentUserStat.equals(LCPL_Constants.status_deactive) ? "Deactive" : currentUserStat.equals(LCPL_Constants.status_locked) ? "Locked" : currentUserStat.equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";
            userStat = userStat != null ? userStat.equals(LCPL_Constants.status_active) ? "Active" : userStat.equals(LCPL_Constants.status_deactive) ? "Deactive" : userStat.equals(LCPL_Constants.status_locked) ? "Locked" : userStat.equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";

            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_reset_user_password, "| User Name - " + selectedUserId + ", Status - (New : " + userStat + ", Old : " + currentUserStat + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>


<head>

    <title>OUSDPS Web - Reset Password</title>

    <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
    <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />
    <link href="../../../css/tcal.css" rel="stylesheet" type="text/css" />

    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
    <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
    <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
    <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>


    <script language="javascript" type="text/JavaScript">

        function validate()
        {

        var selUser = document.getElementById('cmbUserId').value;
        var password = document.getElementById('txtUserPassword').value;
        var reType_password = document.getElementById('txtReTypePassword').value;

        if(selUser == "-1")
        {
        alert("You must select valid user name for reset password!");
        document.getElementById('cmbUserId').focus();
        return false;
        }
        else
        {
        if(isempty(password))
        {
        alert("Password field can't be empty.");
        return false;
        }
        else
        {
        if(isempty(reType_password))
        {
        alert("Password and Re-type Password does not match.");
        return false;
        }
        else
        {
        if(password != reType_password)
        {
        alert("Password does not match with the Re-type Password!");
        document.getElementById('txtUserPassword').value="";
        document.getElementById('txtReTypePassword').value="";
        document.getElementById('txtUserPassword').focus();
        this.setAnimLights();
        return false;
        }
        else
        {
        document.frmResetPwd.submit();
        }
        }
        }	
        }
        }

        function showClock(type)
        {
        if(type==1)
        {
        clock(document.getElementById('showText'),type,null);
        }
        else if(type==2 )
        {
        var val = new Array(<%=serverTime%>);
        clock(document.getElementById('showText'),type,val);
        }
        else if(type==3 )
        {
        var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window.getCutontimeHour()%>, <%=window.getCutontimeMinutes()%>, <%=window.getCutofftimeHour()%>, <%=window.getCutofftimeMinutes()%>);
        clock(document.getElementById('showText'),type,val);

        }

        }

        function isRequest(status)
        {
        if(status)
        {
        document.getElementById('hdnReq').value = "1";
        }
        else
        {                    
        document.getElementById('hdnReq').value = "0";
        }
        }


        function validatePassword()
        {
        var newPassword = document.getElementById('txtUserPassword').value;

        if(isempty(newPassword))
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Empty Password!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        else
        {
        if(findSpaces(newPassword))
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Spaces not allowed!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        else
        {
        if(trim(newPassword).length < 8)
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Password length less than 8 characters!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        else
        {
        if (trim(newPassword).match(/[0-9]/) && trim(newPassword).match(/[a-zA-Z]/))
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='block';
        document.getElementById('imgOK').title='Correct password which match with password policy.';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='none';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=false;
        }
        }
        else
        {
        if(document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display='none';
        }

        if(document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display='block';
        document.getElementById('imgError').title='Password must be a combination of alpha-numeric characters!';
        }

        if(document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled=true;
        }
        }
        }

        }

        }
        }

        function hideMessage_onFocus()
        {
        if(document.getElementById('displayMsg_error') != null)
        {
        document.getElementById('displayMsg_error').style.display='none';
        }

        if(document.getElementById('displayMsg_success') != null)
        {
        document.getElementById('displayMsg_success').style.display = 'none';
        }
        }


        function resetRecords()
        {


        document.getElementById('cmbUserLevel').selectedIndex = 0;
        document.getElementById('cmbStatus').selectedIndex = 0;
        document.getElementById('cmbBank').selectedIndex = 0; 


        if(document.getElementById('cmbBranch')!=null)
        {
        document.getElementById('cmbBranch').selectedIndex = 0; 
        }

        document.getElementById('cmbUserId').selectedIndex = 0; 				
        document.getElementById('txtUserPassword').value = "<%=defaultPwd%>";
        document.getElementById('txtReTypePassword').value = "<%=defaultPwd%>";
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
                                                            <td align="center" valign="middle"><table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td width="15">&nbsp;</td>
                                                                        <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                <tr>
                                                                                    <td width="10">&nbsp;</td>
                                                                                    <td align="left" valign="top" class="cits_header_text">Reset User  Password</td>
                                                                                    <td width="10">&nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td height="20"></td>
                                                                                    <td></td>
                                                                                    <td></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="10"></td>
                                                                                    <td align="center" valign="top" class="cits_header_text">


                                                                                        <form id="frmResetPwd" name="frmResetPwd" action="UserPwdReset.jsp">

                                                                                            <table border="0" align="center" cellpadding="0" cellspacing="0">

                                                                                                <%
                                                                                                    if (isReq.equals("1") && result == true)
                                                                                                    {%>
                                                                                                <tr>
                                                                                                    <td align="center" ><div id="displayMsg_success" class="cits_Display_Success_msg" >Password Changed Succesfully.</div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" ></td>
                                                                                                </tr>
                                                                                                <%                     }
                                                                                                else if (isReq.equals("1") && result == false)
                                                                                                {%>
                                                                                                <tr>

                                                                                                    <td align="center" class="cits_Display_Error_msg"><div id="displayMsg_error" class="cits_Display_Error_msg" >Password Reset Failed - <span class="cits_error"><%=msg%></span></div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" ></td>
                                                                                                </tr>

                                                                                                <% }%>


                                                                                                <tr>
                                                                                                    <td align="center" valign="top" class="cits_Display_Error_msg"><table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >

                                                                                                            <tr>
                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User Type :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><select name="cmbUserLevel" id="cmbUserLevel" class="cits_field_border" onChange="isRequest(false);
                                                                                                                                            frmResetPwd.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                    <option value="<%=LCPL_Constants.status_all%>" <%=(newUserLevel != null && newUserLevel.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                    <%for (UserLevel usrlvl : colUserLevel)
                                                                                                                                        {%>
                                                                                                                                    <option value=<%=usrlvl.getUserLevelId()%> <%=(newUserLevel != null && usrlvl.getUserLevelId().equals(newUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                    <%}%>
                                                                                                                                </select></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><select name="cmbStatus" id="cmbStatus" class="cits_field_border" onChange="isRequest(false);
                                                                                                                                    frmResetPwd.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                    <option value="<%=LCPL_Constants.status_all%>" <%=(newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                    <option value="<%=LCPL_Constants.status_active%>" <%=(newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                    <option value="<%=LCPL_Constants.status_deactive%>" <%=(newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                                    <option value="<%=LCPL_Constants.status_expired%>" <%=(newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_expired)) ? "selected" : ""%>>Expired</option>
                                                                                                                                    <option value="<%=LCPL_Constants.status_locked%>" <%=(newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_locked)) ? "selected" : ""%>>Locked</option>
                                                                                                                                </select></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><select name="cmbBank" id="cmbBank" class="cits_field_border" onChange="isRequest(false);
                                                                                                                                    frmResetPwd.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                    <%
                                                                                                                                        if (newUserBank == null || newUserBank.equals(LCPL_Constants.status_all))
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
                                                                                                                                        if (colBank != null && colBank.size() > 0)
                                                                                                                                        {
                                                                                                                                            for (Bank bank : colBank)
                                                                                                                                            {%>
                                                                                                                                    <option value="<%=bank.getBankCode()%>" <%=(newUserBank != null && bank.getBankCode().equals(newUserBank)) ? "selected" : ""%> >
                                                                                                                                        <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                                        <%}
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                </select>

                                                                                                                                <select name="cmbBranch" id="cmbBranch" class="cits_field_border" onChange="isRequest(false);
                                                                                                                                        frmResetPwd.submit()" onFocus="hideMessage_onFocus()" style="visibility:hidden;width:5px">
                                                                                                                                    <%                                                                                                                                        if (newUserBranch == null || newUserBranch.equals(LCPL_Constants.status_all))
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
                                                                                                                                        if (colBranch != null && colBranch.size() > 0)
                                                                                                                                        {
                                                                                                                                            for (Branch branch : colBranch)
                                                                                                                                            {%>
                                                                                                                                    <option value="<%=branch.getBranchCode()%>" <%=(newUserBranch != null && branch.getBranchCode().equals(newUserBranch)) ? "selected" : ""%> >
                                                                                                                                        <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                                        <%}
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                </select>
                                                                                                                            </td>
                                                                                                                        </tr>
                                                                                                                        <!--tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Branch :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"></td>
                                                                                                                        </tr-->
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User Name :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"> <select name="cmbUserId" class="cits_field_border" id="cmbUserId" onFocus="hideMessage_onFocus()" >
                                                                                                                                    <option value="-1" <%=(selectedUserId==null|| selectedUserId.equals("-1")) ? "selected" : ""%>>-- Select User --</option>
                                                                                                                                    <% if (col_user != null && col_user.size() > 0)
                                                                                                                                        {
                                                                                                                                            for (User u : col_user)
                                                                                                                                            {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=u.getUserId()%>" <%=(selectedUserId != null && u.getUserId().equals(selectedUserId)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                    <% }
                                                                                                                                        }%>
                                                                                                                                </select>  </td></tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">New Password <span class="cits_required_field">*</span> :</td>

                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><input name="txtUserPassword" type="password" class="cits_field_border" id="txtUserPassword" value="<%=(newUserPassword != null) ? newUserPassword : defaultPwd%>" size="35" maxlength="32" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                        </tr>

                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Re-Type Password <span class="cits_required_field">*</span> :</td>

                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text">
                                                                                                                                <input name="txtReTypePassword" type="password" class="cits_field_border" id="txtReTypePassword" value="<%=(newUserPassword != null) ? newUserPassword : defaultPwd%>" size="35" maxlength="32" onFocus="hideMessage_onFocus()"/>                    </td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td height="35" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /></td>
                                                                                                                            <td align="right" valign="bottom" bgcolor="#CDCDCD"class="cits_tbl_header_text"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td><input type="button" value="Change" name="btnChange" id="btnChange" class="cits_custom_button" onClick="isRequest(true);
                                                                                                                                                validate();"/>                             </td>
                                                                                                                                        <td width="5"></td>
                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Reset" type="button" onClick="resetRecords()" class="cits_custom_button" />                                                </td></tr>
                                                                                                                                </table></td>
                                                                                                                        </tr>

                                                                                                                    </table></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                            </table>




                                                                                        </form>



                                                                                    </td>
                                                                                    <td width="10"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td></td>

                                                                                    <td align="center" valign="top">&nbsp;</td>


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

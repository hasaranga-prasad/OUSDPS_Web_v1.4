
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.bank.BankDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.BranchDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.user.pwd.history.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../error.jsp"%>

<%
    String session_userName = null;
    String userType = null;
    String userTypeDesc = null;
    String session_pw = null;
    String sessionBankName = null;
    String sessionBankCode = null;
    String branchId = null;
    String branchName = null;
    String menuId = null;
    String menuName = null;

    session_userName = (String) session.getAttribute("session_userName");

    if (session_userName == null || session_userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        userType = (String) session.getAttribute("session_userType");
        userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
        session_pw = (String) session.getAttribute("session_password");
        sessionBankCode = (String) session.getAttribute("session_bankCode");
        sessionBankName = (String) session.getAttribute("session_bankName");
        branchId = (String) session.getAttribute("session_branchId");
        branchName = (String) session.getAttribute("session_branchName");
        menuId = (String) session.getAttribute("session_menuId");
        menuName = (String) session.getAttribute("session_menuName");

    }
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
    User usr = null;
    String isReq = null;
    String msg = null;
    boolean result = false;
    
    int iMinPwdHistory = 1;
    int iMinPwdResetDays = 1;

    try
    {
        String strMinPwdHistory = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_minimum_pwd_history);

        if (strMinPwdHistory != null)
        {
            iMinPwdHistory = Integer.parseInt(strMinPwdHistory);
        }
        else
        {
            iMinPwdHistory = 1;
        }
    }
    catch (Exception e)
    {
        iMinPwdHistory = 1;
    }

    try
    {
        String strPwdResetDays = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_minimum_pwd_change_days);

        if (strPwdResetDays != null)
        {
            iMinPwdResetDays = Integer.parseInt(strPwdResetDays);
        }
        else
        {
            iMinPwdResetDays = 1;
        }
    }
    catch (Exception e)
    {
        iMinPwdResetDays = 1;
    }

    boolean isOkToChangePassword = DAOFactory.getUserDAO().isOkToChangePassword(session_userName, iMinPwdResetDays);
    
    isReq = (String) request.getParameter("hdnReq");

    usr = DAOFactory.getUserDAO().getUserDetails(session_userName, LCPL_Constants.status_active);

    if (isReq == null)
    {
        isReq = "0";
    }
    else if (isReq.equals("1"))
    {
        String user = request.getParameter("txt_User");
        String currentPwd = request.getParameter("txt_CurrentPassword");
        String new_pw = request.getParameter("txtNewPwd");

        UserDAO userDAO = DAOFactory.getUserDAO();
        //result = userDAO.changeUserPassword(new User(user, new_pw.trim()), currentPwd.trim(), false);

        if (user != null && new_pw != null)
        {
            result = userDAO.changeUserPassword(new User(user, new_pw.trim()), currentPwd.trim(), false);
        }

        if (result)
        {
            PWD_HistoryDAO pwdHisDAO = DAOFactory.getPWD_HistoryDAO();

            boolean pwdHisUpdateStat = pwdHisDAO.addPWD_History(new PWD_History(user, new_pw.trim()));

            if (pwdHisUpdateStat)
            {                
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_password_change, "| User Name - " + user + ") | Process Status - Success | Done By - " + user + " (" + userTypeDesc + ") |"));
                
            }
            else
            {
                msg = pwdHisDAO.getMsg();
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_password_change, "| User Name - " + user + ") | Process Status - Unsuccess update password history (" + msg + ") | Done By - " + user + " (" + userTypeDesc + ") |"));
                
            }
        }
        else
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_password_change, "| User Name - " + user + ") | Process Status - Unsuccess (" + msg + ") | Done By - " + user + " (" + userTypeDesc + ") |"));            
        }      
        
//        if (!result)
//        {
//            msg = userDAO.getMsg();
//            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_password_change, "| User Name - " + user + ") | Process Status - Unsuccess (" + msg + ") | Done By - " + session_userName + " (" + userTypeDesc + ") |"));
//        }
//        else
//        {
//            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_password_change, "| User Name - " + user + ") | Process Status - Success | Done By - " + session_userName + " (" + userTypeDesc + ") |"));
//        }
    }

%>

<head>   
    <title>OUSDPS Web - User Profile</title>
    <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
    <link href="../../css/cits.css" rel="stylesheet" type="text/css" />

    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>


    <script language="javascript" type="text/JavaScript">
	
	
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
	

       function passwordValidation()
        {

            var curPassword = document.getElementById('txt_CurrentPassword').value;
            var password = document.getElementById('txtNewPwd').value;
            var reType_password = document.getElementById('txtConfirmPwd').value;

            if(isempty(curPassword))
            {
            alert("Current Password field can't be empty!");
            document.getElementById('txt_CurrentPassword').focus();
            return false;
            }
            else if(isempty(password))
            {
            alert("Password field can not be empty!");
            document.getElementById('txtNewPwd').focus();
            return false;
            }
            else
            {
                if(isempty(reType_password))
                {
                        alert("Confirm Password field can not be empty!");
                        return false;
                }
                else
                {
                        if(password != reType_password)
                        {
                                alert("Password does not match with the Confirm Password!");
                                document.getElementById('txtNewPwd').value="";
                                document.getElementById('txtConfirmPwd').value="";
                                document.getElementById('txtNewPwd').focus();
                                this.setAnimLights();
                                return false;	
                        }
                        else
                        {
                        document.frmprofilechange.submit();
                        }
                }
            }
        }       

        function isRequest(status)
        {
        if(status)
        {
        document.getElementById('hdnReq').value = "1";
        }
        }

        function setAnimLights()
        {
            if(document.getElementById('validPwd') != null)
            {
            document.getElementById('validPwd').style.display='none';					
            }

            if(document.getElementById('invalidPwd') != null)
            {
            document.getElementById('invalidPwd').style.display='none';
            }

            if(document.getElementById('btnChange') != null)
            {
                document.getElementById('btnChange').disabled=true;
            }
        }

        function clearRecords()
        {
            document.getElementById('txt_CurrentPassword').value = "";
            document.getElementById('txtNewPwd').value = "";
            document.getElementById('txtConfirmPwd').value = "";
        }		

        function validatePassword()
        {
        var newPassword = document.getElementById('txtNewPwd').value;

        if (isempty(newPassword))
        {
            if (document.getElementById('validPwd') != null)
            {
                document.getElementById('validPwd').style.display = 'none';
            }

            if (document.getElementById('txtNewPwd') != null)
            {
                document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
            }

            if (document.getElementById('invalidPwd') != null)
            {
                document.getElementById('invalidPwd').style.display = 'block';
                document.getElementById('imgError').title = 'Empty Password!';
            }

            if (document.getElementById('btnChange') != null)
            {
                document.getElementById('btnChange').disabled = true;
            }
        }
        else
        {
            if (findSpaces(newPassword))
            {
                if (document.getElementById('validPwd') != null)
                {
                document.getElementById('validPwd').style.display = 'none';
                }
		
		if (document.getElementById('txtNewPwd') != null)
		{
			document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
		}

                if (document.getElementById('invalidPwd') != null)
                {
                    document.getElementById('invalidPwd').style.display = 'block';
                    document.getElementById('imgError').title = 'Spaces not allowed!';
                }

                if (document.getElementById('btnChange') != null)
                {
                document.getElementById('btnChange').disabled = true;
                }
            }
            else
            {
        if (trim(newPassword).length < 8)
        {
        if (document.getElementById('validPwd') != null)
        {
            document.getElementById('validPwd').style.display = 'none';
        }
		
		if (document.getElementById('txtNewPwd') != null)
		{

			document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
		}

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password length less than 8 characters!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        else
        {
        var userID = '<%=session_userName%>';

        if ((newPassword.toUpperCase()).indexOf(userID.toUpperCase()) >= 0)
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }
		
		if (document.getElementById('txtNewPwd') != null)
		{
			document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
		}

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password can not contain UserId!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        else
        {
        if (trim(newPassword).match(/[0-9]/) && trim(newPassword).match(/[a-zA-Z]/) && trim(newPassword).match(/[^\w\s]/))
        {
        isPWDNotAvailableInHistory();
        //validatePassword();
        }
        else
        {
        if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'none';
        }
		
		if (document.getElementById('txtNewPwd') != null)
		{
			document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
		}

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'block';
        document.getElementById('imgError').title = 'Password must be a combination of alpha-numeric characters and at least one special character!';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = true;
        }
        }
        }

        }

        }

        }
        }

        function isPWDNotAvailableInHistory()
        {
        var xmlhttp;
        var k = document.getElementById("txtNewPwd").value;
        //alert('txtNewPwd - ' + k)
        var urls = "getPWDHis.jsp?p=" + encodeURIComponent(k);
        var status = false;

        var res;

        if (window.XMLHttpRequest)
        {
        xmlhttp = new XMLHttpRequest();
        }
        else
        {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }

        xmlhttp.onreadystatechange = function ()
        {
        if (xmlhttp.readyState == 4)
        {

        res = xmlhttp.responseText;
        //alert("res 1 ---> " + xmlhttp.responseText + " trimed res -->   " + trim(res));

        if (trim(res) == "1")
        {
        status = true;
        document.getElementById("hdnIsPWDAvailableHis").value = "1";

        if (document.getElementById('txtNewPwd') != null)
		{
			document.getElementById('txtNewPwd').className = 'cits_login_input_text_ok';
		}
		
		if (document.getElementById('validPwd') != null)
        {
        document.getElementById('validPwd').style.display = 'block';
        document.getElementById('imgOK').title = 'Correct password which match with password policy.';
        }

        if (document.getElementById('invalidPwd') != null)
        {
        document.getElementById('invalidPwd').style.display = 'none';
        }

        if (document.getElementById('btnChange') != null)
        {
        document.getElementById('btnChange').disabled = false;
        }
        }
            else if (trim(res) == "0")
            {
            status = false;
            document.getElementById("hdnIsPWDAvailableHis").value = "0";

            if (document.getElementById('validPwd') != null)
            {
            document.getElementById('validPwd').style.display = 'none';
            }

                if (document.getElementById('txtNewPwd') != null)
                {
                        document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
                }

                if (document.getElementById('invalidPwd') != null)
                {
                document.getElementById('invalidPwd').style.display = 'block';
                document.getElementById('imgError').title = 'Password shuold not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
                }

                if (document.getElementById('btnChange') != null)
                {
                document.getElementById('btnChange').disabled = true;
                }
            }
            else
            {
                status = false;
                document.getElementById("hdnIsPWDAvailableHis").value = "0";

                if (document.getElementById('validPwd') != null)
                {
                    document.getElementById('validPwd').style.display = 'none';
                }

                if (document.getElementById('txtNewPwd') != null)
                {
                        document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
                }

                if (document.getElementById('invalidPwd') != null)
                {
                    document.getElementById('invalidPwd').style.display = 'block';
                    document.getElementById('imgError').title = 'Password shuold not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
                }

                if (document.getElementById('btnChange') != null)
                {
                    document.getElementById('btnChange').disabled = true;
                }
            }
        }
        }

        xmlhttp.open("POST", urls, true);
        //xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send();


        //alert("res 2 ---> " + xmlhttp.responseText + " trimed res -->   " + trim(res));

        //return status;
        }

        function hideMessage_onFocus()
        {
        if(document.getElementById('displayMsg_error') != null)
        {
        document.getElementById('displayMsg_error').style.display='none';

        if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
        {
        clearRecords();
        document.getElementById('hdnCheckPOSForClearREcords').value = '0';
        }
        }

        if(document.getElementById('displayMsg_success') != null)
        {
        document.getElementById('displayMsg_success').style.display = 'none';

        if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
        {
        clearRecords();
        document.getElementById('hdnCheckPOSForClearREcords').value = '0';
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
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="showClock(3);
        setAnimLights()">
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
                                                                                                            <td class="cits_menubar_text"><b><%=session_userName %></b> - <%=sessionBankName%></td>
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
                                                                                    <td valign="middle"><div id="actSession" align="center" ><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgActiveSession" id="imgActiveSession" width="12" height="12" title="Session is active!" ></div>
                                                                                        <div id="expSession" align="center" ><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgExpiredSession" id="imgExpiredSession" width="12" height="12" title="Session is expired!" ></div></td>
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
                                                                                    <td align="left" valign="top" class="cits_header_text">User Profile</td>
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


                                                                                        <form id="frmprofilechange" name="frmprofilechange" method="post"  action="userProfile.jsp">

                                                                                            <table border="0" align="center" cellpadding="0" cellspacing="0">

                                                                                                <%
                                                                      if (isReq.equals("1") && result == true)
                                                                      {%>
                                                                                                <tr>
                                                                                                    <td align="center" ><div id="displayMsg_success" class="cits_Display_Success_msg" >Password Changed Succesfully.</div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" align="center" ><input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" /></td>
                                                                                                </tr>
                                                                                                <%                     }
                                                                                                else if (isReq.equals("1") && result == false)
                                                                                                {%>
                                                                                                <tr>

                                                                                                    <td align="center" class="cits_Display_Error_msg"><div id="displayMsg_error" class="cits_Display_Error_msg" >Password change Failed - <span class="cits_error"><%=msg%></span></div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" align="center" ><input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" /></td>
                                                                                                </tr>

                                                                                                <% }%>


                                                                                                <tr>
                                                                                                    <td align="center" valign="top" class="cits_Display_Error_msg"><table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >

                                                                                                            <tr>
                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User Name :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_common_text"> <%=session_userName %> <input name="txt_User" type="hidden" id="txt_User" value="<%=session_userName %>" />  </td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User Level :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><%=usr.getUserLevelDesc()%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><%=usr.getBankCode()%> - <%=usr.getBankFullName()%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Name : </td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><%=usr.getName() != null ? usr.getName() : "N/A"%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Designation :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><%=usr.getDesignation() != null ? usr.getDesignation() : "N/A"%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">E-Mail :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><%=usr.getEmail() != null ? usr.getEmail() : "N/A"%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Contact No. :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><%=usr.getContactNo() != null ? usr.getContactNo() : "N/A"%></td>
                                                                                                                        </tr>
                                                                                                                        <%
                                                                                                                            if (!isOkToChangePassword)
                                                                                                                            {

                                                                                                                        %>

                                                                                                                        <tr>
                                                                                                                            <td colspan="2" align="center" valign="middle" bgcolor="#CECED7" class="cits_error">Reset your current password is disabled due to minimum password reset days are not completed! <br>
                                                                                                                                [ You have to wait minimum of <%=iMinPwdResetDays%> day(s) from last password reset date. - <%=usr.getLastPasswordResetDate()%>]</td>
                                                                                                                        </tr>

                                                                                                                        <%
                                                                                                                            }
																															else
																															{

                                                                                                                        %>
                                                                                                                        
                                                                                                                        <tr>
                                                                                                                            <td colspan="2" align="center" valign="middle" bgcolor="#CECED7" class="cits_error">Note : New password can not be equal to last <%=iMinPwdHistory %> password(s) you used,<br/>must be a combination of alpha numeric and at least one special character and<br/>minimum of 8 characters in length!</td>
                                                                                                                  </tr>
                                                                                                                        
                                                                                                                        <%
																														}
																														%>
                                                                                                                        
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Current Password <span class="cits_required_field">*</span> :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><input name="txt_CurrentPassword" type="password" class="cits_field_border" id="txt_CurrentPassword" size="35" maxlength="32" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">New Password <span class="cits_required_field">*</span> :</td>

                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text">

                                                                                                                                <table  border="0" cellspacing="0" cellpadding="0">
                                                                                                                                    <tr>
                                                                                                                                        <td><input name="txtNewPwd" type="password" class="cits_field_border" id="txtNewPwd" size="35" maxlength="32" onKeyUp="validatePassword()" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                                        <td width="5"></td>
                                                                                                                                        <td align="center" valign="middle" width="12"><div id="validPwd" align="center" ><img src="../../images/animGreen.gif" name="imgOK" id="imgOK" width="12" height="12" title=""></div>
                              <div id="invalidPwd" align="center" ><img src="../../images/animRed.gif" name="imgError" id="imgError" width="12" height="12" title=""></div></td>
                                                                                                                                    </tr>
                                                                                                                                </table></td>
                                                                                                                        </tr>

                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Re-Type Password <span class="cits_required_field">*</span> :</td>

                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text">
                                                                                                                                <input name="txtConfirmPwd" type="password" class="cits_field_border" id="txtConfirmPwd" size="35" maxlength="32" onFocus="hideMessage_onFocus()"/>                    </td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td height="35" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /><input type="hidden" name="hdnIsPWDAvailableHis" id="hdnIsPWDAvailableHis"></td>
                                                                                                                            <td align="right" valign="bottom" bgcolor="#CDCDCD"class="cits_tbl_header_text"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td><input type="button" value="Change" name="btnChange" id="btnChange" class="cits_custom_button" onClick="isRequest(true);
                                                                                                                      passwordValidation();"/>                             </td>
                                                                                                                                        <td width="5"></td>
                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Clear" type="button" onClick="clearRecords()"  class="cits_custom_button" />                                                </td></tr>
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

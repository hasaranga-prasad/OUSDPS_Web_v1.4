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

<%

    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
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
    User userDetails = null;

    String reqType = null;
    String selectedUsername = null;
    String selectedUserLevel = null;
    String selectedUserStatus = null;
    String selectedUserBank = null;
    String selectedUserBranch = null;

    String userID = null;
    String newUserStatus = null;
    String newUserStatusDesc = null;
    String oldUserStatusDesc = null;
    String newName = null;
    String newDesignation = null;
    String newEmail = null;
    String newContactNo = null;
    String newUserRemarks = null;
    String defaultPwd = null;
    String msg = null;

    boolean result = false;

    colUserLevel = DAOFactory.getUserLevelDAO().getUserLevelDetails();
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);
    col_user = DAOFactory.getUserDAO().getUsers(new User(LCPL_Constants.status_all, LCPL_Constants.status_all, LCPL_Constants.status_all, LCPL_Constants.status_all), LCPL_Constants.status_pending);

    defaultPwd = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_default_pwd);

    reqType = (String) request.getParameter("hdnRequestType");
    //System.out.println("reqType - " + reqType);

    if (reqType == null)
    {
        //reqType = "0";
        selectedUserLevel = LCPL_Constants.status_all;
        selectedUserStatus = LCPL_Constants.status_all;
        selectedUserBank = LCPL_Constants.status_all;
        selectedUserBranch = LCPL_Constants.status_all;
        selectedUsername = "-1";

        //System.out.println("1. selectedUserLevel ---> " + selectedUserLevel );
        //System.out.println("1. selectedUserStatus ---> " + selectedUserStatus );
        //System.out.println("1. selectedUserBank ---> " + selectedUserBank );
        //System.out.println("1. selectedUserBranch ---> " + selectedUserBranch );
        //System.out.println("1. selectedUsername ---> " + selectedUsername );

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, selectedUserBranch, selectedUserStatus), LCPL_Constants.status_pending);
    }
    else if (reqType.equals("0"))
    {

        selectedUserLevel = request.getParameter("search_cmbUserLevel");
        selectedUserStatus = request.getParameter("search_cmbUserStatus");
        selectedUserBank = request.getParameter("search_cmbBank");
        selectedUserBranch = LCPL_Constants.bank_default_branch_code;

        selectedUsername = request.getParameter("search_cmbUserId");

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, selectedUserBranch, selectedUserStatus), LCPL_Constants.status_pending);

        if (col_user != null && col_user.size() > 0)
        {
            boolean isuseravailable = false;

            for (User u : col_user)
            {
                if (selectedUsername != null && selectedUsername.equals(u.getUserId()))
                {
                    isuseravailable = true;
                    break;
                }
            }

            if (!isuseravailable)
            {
                selectedUsername = "-1";
            }
        }
        else
        {
            selectedUsername = "-1";
        }

        if (selectedUsername != null && !selectedUsername.equals("-1"))
        {
            userDetails = DAOFactory.getUserDAO().getUserDetails(selectedUsername, LCPL_Constants.status_all);
            oldUserStatusDesc = userDetails.getStatus() != null ? userDetails.getStatus().equals(LCPL_Constants.status_active) ? "Active" : userDetails.getStatus().equals(LCPL_Constants.status_deactive) ? "Deactive" : userDetails.getStatus().equals(LCPL_Constants.status_locked) ? "Locked" : userDetails.getStatus().equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";
        }
    }
    else if (reqType.equals("1"))
    {
        selectedUserLevel = request.getParameter("search_cmbUserLevel");
        selectedUserStatus = request.getParameter("search_cmbUserStatus");
        selectedUserBank = request.getParameter("search_cmbBank");
        selectedUserBranch = LCPL_Constants.bank_default_branch_code;
        selectedUsername = request.getParameter("search_cmbUserId");

        col_user = DAOFactory.getUserDAO().getUsers(new User(selectedUserLevel, selectedUserBank, selectedUserBranch, selectedUserStatus), LCPL_Constants.status_pending);

        if (selectedUsername != null && !selectedUsername.equals("-1"))
        {
            userDetails = DAOFactory.getUserDAO().getUserDetails(selectedUsername, LCPL_Constants.status_all);
        }


        userID = request.getParameter("hdnUsername");
        newUserStatus = request.getParameter("cmbUserStatus");
        newName = request.getParameter("txtName");
        newDesignation = request.getParameter("txtDesignation");
        newEmail = request.getParameter("txtEmail");
        newContactNo = request.getParameter("txtContactNo");
        newUserRemarks = request.getParameter("txtaRemarks");

        /*
         System.out.println("3. userID ---> " + userID);
         System.out.println("3. newUserStatus ---> " + newUserStatus);
         System.out.println("3. newName ---> " + newName);
         System.out.println("3. newDesignation ---> " + newDesignation);
         System.out.println("3. newEmail ---> " + newEmail);
         System.out.println("3. newContactNo ---> " + newContactNo);
         System.out.println("3. newUserRemarks ---> " + newUserRemarks);
         */

        User usr = new User();

        usr.setUserId(userID);
        usr.setStatus(newUserStatus);
        usr.setName(newName);
        usr.setDesignation(newDesignation);
        usr.setEmail(newEmail);
        usr.setContactNo(newContactNo);
        usr.setRemarks(newUserRemarks);
        usr.setNeedDownloadToBIM(LCPL_Constants.status_yes);

        UserDAO userDAO = DAOFactory.getUserDAO();
        result = userDAO.updateUser(usr);

        newUserStatusDesc = newUserStatus != null ? newUserStatus.equals(LCPL_Constants.status_active) ? "Active" : newUserStatus.equals(LCPL_Constants.status_deactive) ? "Deactive" : newUserStatus.equals(LCPL_Constants.status_locked) ? "Locked" : newUserStatus.equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";
        oldUserStatusDesc = userDetails.getStatus() != null ? userDetails.getStatus().equals(LCPL_Constants.status_active) ? "Active" : userDetails.getStatus().equals(LCPL_Constants.status_deactive) ? "Deactive" : userDetails.getStatus().equals(LCPL_Constants.status_locked) ? "Locked" : userDetails.getStatus().equals(LCPL_Constants.status_expired) ? "Expired" : "N/A" : "N/A";

        if (!result)
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_modify_user_details, "| User Name - " + userDetails.getUserId() + ", Type - " + userDetails.getUserLevelDesc() + ", Bank - " + userDetails.getBankCode() + ", Status - (New : " + newUserStatusDesc + ", Old : " + oldUserStatusDesc + "), Name - (New : " + newName + ", Old : " + (userDetails.getName() != null ? userDetails.getName() : "") + "), Designation - (New : " + newDesignation + ", Old : " + (userDetails.getDesignation() != null ? userDetails.getDesignation() : "") + "), E-Mail - (New : " + newEmail + ", Old : " + (userDetails.getEmail() != null ? userDetails.getEmail() : "") + "), Contact No. - (New : " + newContactNo + ", Old : " + (userDetails.getContactNo() != null ? userDetails.getContactNo() : "") + "), Remarks - (New : " + (newUserRemarks != null ? newUserRemarks : "") + ", Old : " + (userDetails.getRemarks() != null ? userDetails.getRemarks() : "") + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_modify_user_details, "| User Name - " + userDetails.getUserId() + ", Type - " + userDetails.getUserLevelDesc() + ", Bank - " + userDetails.getBankCode() + ", Status - (New : " + newUserStatusDesc + ", Old : " + oldUserStatusDesc + "), Name - (New : " + newName + ", Old : " + (userDetails.getName() != null ? userDetails.getName() : "") + "), Designation - (New : " + newDesignation + ", Old : " + (userDetails.getDesignation() != null ? userDetails.getDesignation() : "") + "), E-Mail - (New : " + newEmail + ", Old : " + (userDetails.getEmail() != null ? userDetails.getEmail() : "") + "), Contact No. - (New : " + newContactNo + ", Old : " + (userDetails.getContactNo() != null ? userDetails.getContactNo() : "") + "), Remarks - (New : " + (newUserRemarks != null ? newUserRemarks : "") + ", Old : " + (userDetails.getRemarks() != null ? userDetails.getRemarks() : "") + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>


<html>
    <head><title>OUSDPS Web - Modify User Details</title>
        
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



            function clearRecords_onPageLoad()
            {
            showClock(3);
            }

            function resetRecords()
            {
            document.getElementById('cmbUserStatus').selectedIndex = 0;
            document.getElementById('txtName').value = "";
            document.getElementById('txtDesignation').value = "";
            document.getElementById('txtEmail').value = "";
            document.getElementById('txtContactNo').value = "";				
            document.getElementById('txtaRemarks').value = "";				
            document.getElementById('txtaRemarks').value = "";
            }

            function password_Validation()
            {               
            var password = document.getElementById('txtUserPassword').value;
            var reType_password = document.getElementById('txtReTypePassword').value;

            if(password != reType_password)
            {

            return false;
            }
            else
            {
            return true;
            }
            }



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

            function fieldValidation()
            {
            //var username = document.getElementById('txtUserName').value;
            //var password = document.getElementById('txtUserPassword').value;
            //var reType_password = document.getElementById('txtReTypePassword').value;
            //var userLevel = document.getElementById('cmbUserLevel').value;
            //var selbank = document.getElementById('cmbBank').value;
            //var selbranch = document.getElementById('cmbBranch').value; 
            //var selbranch = "001";

            var status = document.getElementById('cmbUserStatus').value; 
            var v_name = document.getElementById('txtName').value;
            var v_desig = document.getElementById('txtDesignation').value;  
            var v_email = document.getElementById('txtEmail').value;  
            var v_contactno = document.getElementById('txtContactNo').value;            



            if(status == "-1" || status == null)
            {
            alert("Select Status of the user.");
            document.getElementById('cmbUserStatus').focus();
            return false;
            }                

            else if(isempty(trim(v_name)))
            {
            alert("Name Can't be Empty");
            document.getElementById('txtName').value = "";
            document.getElementById('txtName').focus();
            return false;
            }

            else if(isempty(trim(v_desig)))
            {
            alert("Designation Can't be Empty");
            document.getElementById('txtDesignation').value = "";
            document.getElementById('txtDesignation').focus();
            return false;
            }

            else if(isempty(trim(v_email)))
            {
            alert("E-Mail Can't be Empty");
            document.getElementById('txtEmail').value = "";
            document.getElementById('txtEmail').focus();
            return false;
            }

            else if(isempty(trim(v_contactno)))
            {
            alert("Contact No. Can't be Empty");
            document.getElementById('txtContactNo').value = "";
            document.getElementById('txtContactNo').focus();
            return false;
            }

            setRequestType(true);        
            document.frmModifyUser.action="UserModification.jsp";
            document.frmModifyUser.submit();
            return true;

            }

            function showDivisionArea()
            {        
            if('<%=reqType%>' == '0')
            {
            // alert("reqType");
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'none';                    
            }
            else 
            {
            if('<%=result%>' == 'true')
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            else
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            }
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error') != null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            //resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            doSearchUser();
            }
            }

            if(document.getElementById('displayMsg_success') != null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            //resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            doSearchUser();
            }
            }
            }


            function doSearchUser()
            {
            setRequestType(false);
            document.frmModifyUser.action="UserModification.jsp";
            document.frmModifyUser.submit();                    
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


            function updateUserDetails()
            {                                   
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
                                                                <td align="center" valign="middle"><table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">Modify User Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">
                                                                                            <form method="post" name="frmModifyUser" id="frmModifyUser">

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center"><table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >

                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User Type :</td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><select name="search_cmbUserLevel" id="search_cmbUserLevel" class="cits_field_border" onChange="setRequestType(false);
                    doSearchUser();" onFocus="hideMessage_onFocus()">
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" <%=(selectedUserLevel != null && selectedUserLevel.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <%for (UserLevel usrlvl : colUserLevel)
                                                                                                                                            {%>
                                                                                                                                        <option value=<%=usrlvl.getUserLevelId()%> <%=(selectedUserLevel != null && usrlvl.getUserLevelId().equals(selectedUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                        <%}%>
                                                                                                                                    </select>

                                                                                                                                    <input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" />
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status :</td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><select name="search_cmbUserStatus" id="search_cmbUserStatus" class="cits_field_border" onChange="setRequestType(false);
            doSearchUser();" onFocus="hideMessage_onFocus()">
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <option value="<%=LCPL_Constants.status_active%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(LCPL_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                        <option value="<%=LCPL_Constants.status_deactive%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(LCPL_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                                        <option value="<%=LCPL_Constants.status_expired%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(LCPL_Constants.status_expired)) ? "selected" : ""%>>Expired</option>
                                                                                                                                        <option value="<%=LCPL_Constants.status_locked%>" <%=(selectedUserStatus != null && selectedUserStatus.equals(LCPL_Constants.status_locked)) ? "selected" : ""%>>Locked</option>
                                                                                                                                    </select></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank :</td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><select name="search_cmbBank" id="search_cmbBank" class="cits_field_border" onChange="setRequestType(false);
            doSearchUser();" onFocus="hideMessage_onFocus()">
                                                                                                                                        <%
                                                                                                                                            if (selectedUserBank == null || selectedUserBank.equals(LCPL_Constants.status_all))
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
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(selectedUserBank != null && bank.getBankCode().equals(selectedUserBank)) ? "selected" : ""%> >
                                                                                                                                            <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                                            <%}
                                                                                                                                                }

                                                                                                                                            %>
                                                                                                                                    </select>

                                                                                                                                    <select name="search_cmbBranch" id="search_cmbBranch" class="cits_field_border" onChange="setRequestType(false);
            doSearchUser();" onFocus="hideMessage_onFocus()" style="visibility:hidden;width:0px">
                                                                                                                                        <%
                                                                                                                                            if (selectedUserBranch == null || selectedUserBranch.equals(LCPL_Constants.status_all))
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
                                                                                                                                        <option value="<%=branch.getBranchCode()%>" <%=(selectedUserBranch != null && branch.getBranchCode().equals(selectedUserBranch)) ? "selected" : ""%> >
                                                                                                                                            <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                                            <%}
                                                                                                                                                }

                                                                                                                                            %>
                                                                                                                                    </select>                                                                                                    </td>
                                                                                                                            </tr>
                                                                                                                            <!--tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Branch :</td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"></td>
                                                                                                                            </tr-->
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Username :</td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"> <select name="search_cmbUserId" class="cits_field_border" id="search_cmbUserId" onChange="setRequestType(false);
            doSearchUser();" onFocus="hideMessage_onFocus()">
                                                                                                                                        <option value="-1" <%=(selectedUsername != null && selectedUsername.equals("-1")) ? "selected" : ""%>>-- Select User --</option>
                                                                                                                                        <% if (col_user != null && col_user.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (User u : col_user)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=u.getUserId()%>" <%=(selectedUsername != null && u.getUserId().equals(selectedUsername)) ? "selected" : ""%> > <%=u.getUserId()%> </option>
                                                                                                                                        <% }
                                                                                                                                            }%>
                                                                                                                                    </select>  </td></tr>

                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center">





                                                                                                            <%
                                                                                                                if (reqType != null)
                                                                                                                {
                                                                                                            %>

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%


                                                                                                                    if (userDetails == null)
                                                                                                                    {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td align="center">&nbsp;</td>
                                                                                                                </tr>
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
                                                                                                                                        <%

                                                                                                                                            if (reqType.equals("1"))
                                                                                                                                            {

                                                                                                                                                if (result == true)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <div id="displayMsg_success" class="cits_Display_Success_msg" >

                                                                                                                                            User Details Modified Sucessfully.


                                                                                                                                        </div>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {%>


                                                                                                                                        <div id="displayMsg_error" class="cits_Display_Error_msg" >User Details Modification Failed.- <span class="cits_error"><%=msg%></span></div>
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


                                                                                                                                        <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder">
                                                                                                                                            <tr>
                                                                                                                                                <td>

                                                                                                                                                    <table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td>
                                                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0"class="cits_tbl_header_text">Current Value</td>
                                                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0"class="cits_tbl_header_text">New Value</td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td width="126" align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                                Username :        </td>

                                                                                                                                                            <td width="185" valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><%=userDetails.getUserId()%></td>
                                                                                                                                                            <td width="185" valign="middle" bgcolor="#DFEFDE"class="cits_common_text"><input type="hidden" name="hdnUsername" id="hdnUsername" class="cits_success" value="<%=userDetails.getUserId()%>" /></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User Type :</td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=userDetails.getUserLevelDesc()%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"> <input type="hidden" name="hdnUserType" id="hdnUserType" class="cits_success" value="<%=userDetails.getUserLevelId()%>" />                                                                                                                                                                            </td>
                                                                                                                                                        </tr>


                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank : </td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=userDetails.getBankCode()%> - <%=userDetails.getBankFullName()%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><input type="hidden" name="hdnBankCode" id="hdnBankCode" class="cits_success" value="<%=userDetails.getBankCode()%>" /></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status :</td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=oldUserStatusDesc%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                                <select name="cmbUserStatus" id="cmbUserStatus" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                                    <option value="-1" <%=(newUserStatus != null && newUserStatus.equals("-1")) ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                                    <option value="<%=LCPL_Constants.status_active%>" <%=(newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                                                    <option value="<%=LCPL_Constants.status_deactive%>" <%=(newUserStatus != null && newUserStatus.equals(LCPL_Constants.status_deactive)) ? "selected" : ""%>>De-active</option>
                                                                                                                                                                </select>                             </td>
                                                                                                                                                        </tr>

                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Name :</td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=userDetails.getName() != null ? userDetails.getName() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtName" id="txtName" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newName != null) ? newName : (userDetails.getName() != null ? userDetails.getName() : "N/A")%>" size="80" maxlength="200"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Designation :</td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=userDetails.getDesignation() != null ? userDetails.getDesignation() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtDesignation" id="txtDesignation" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newDesignation != null) ? newDesignation : (userDetails.getDesignation() != null ? userDetails.getDesignation() : "N/A")%>" size="80" maxlength="200"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">E-Mail : </td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=userDetails.getEmail() != null ? userDetails.getEmail() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtEmail" id="txtEmail" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newEmail != null) ? newEmail : (userDetails.getEmail() != null ? userDetails.getEmail() : "N/A")%>" size="80" maxlength="200"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Contact No. :</td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=userDetails.getContactNo() != null ? userDetails.getContactNo() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtContactNo" id="txtContactNo" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newContactNo != null) ? newContactNo : (userDetails.getContactNo() != null ? userDetails.getContactNo() : "N/A")%>" size="20" maxlength="20"></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Remarks :</td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_common_text"><%=userDetails.getRemarks() != null ? userDetails.getRemarks() : "N/A"%></td>
                                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><textarea name="txtaRemarks" id="txtaRemarks" rows="3" cols="60" onFocus="hideMessage_onFocus()" class="cits_field_border"><%=(newUserRemarks != null) ? newUserRemarks : ""%></textarea></td>
                                                                                                                                                        </tr>
                                                                                                                                                        <tr>
                                                                                                                                                            <td height="35" colspan="3" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text">                                                                                                                      <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                    <tr>
                                                                                                                                                                        <td><input type="button" value="Update" name="btnUpdate" id="btnUpdate" class="cits_custom_button" onClick="updateUserDetails()"/>                             </td>
                                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=reqType%>" /></td>
                                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Reset" type="button" onClick="resetRecords()" class="cits_custom_button" />                                                            </td></tr>
                                                                                                                                                                </table></td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table>


                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                        </table>










                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>                                                                                            </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>

                                                                                                            <%
                                                                                                                }
                                                                                                            %>                                                                                





                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>



                                                                                            </form>
                                                                                        </td>
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

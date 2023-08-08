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

    String isReq = null;
    String newUserId = null;
    String newUserPassword = null;
    String newUserReTypePassword = null;
    String newUserLevel = null;
    //String newUserStatus = null;
    String newUserBank = null;
    String newUserBranch = null;
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

    defaultPwd = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_default_pwd);

    isReq = (String) request.getParameter("hdnReq");
    //System.out.println("isReq - " + isReq);

    if (isReq == null)
    {
        isReq = "0";
        newUserLevel = "-1";
        //newUserStatus = "-1";
        newUserBank = LCPL_Constants.status_all;
        newUserBranch = LCPL_Constants.status_all;
    }
    else if (isReq.equals("0"))
    {
        newUserId = request.getParameter("txtUserName");
        newUserPassword = request.getParameter("txtUserPassword");
        newUserReTypePassword = request.getParameter("txtReTypePassword");
        newUserLevel = request.getParameter("cmbUserLevel");
        //newUserStatus = request.getParameter("cmbStatus");
        newUserBank = request.getParameter("cmbBank");
        //newUserBranch = request.getParameter("cmbBranch");
        newUserBranch = LCPL_Constants.bank_default_branch_code;
        newName = request.getParameter("txtName");
        newDesignation = request.getParameter("txtDesignation");
        newEmail = request.getParameter("txtEmail");
        newContactNo = request.getParameter("txtContactNo");
        newUserRemarks = request.getParameter("txtaRemarks");

        if (newUserLevel != null && (newUserLevel.equals(LCPL_Constants.user_type_bank_user) || newUserLevel.equals("-1")))
        {
            if (newUserBank != null && !newUserBank.equals(LCPL_Constants.status_all))
            {
                colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, LCPL_Constants.status_pending);
            }
        }
        else
        {
            if (newUserLevel != null && (newUserLevel.equals(LCPL_Constants.user_type_settlement_bank_user)))
            {
                newUserBank = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_setlement_bank);
                colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, LCPL_Constants.status_pending);
                newUserBranch = LCPL_Constants.bank_default_branch_code;
            }
            else
            {
                newUserBank = LCPL_Constants.LCPL_bank_code;
                colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, LCPL_Constants.status_pending);
                newUserBranch = LCPL_Constants.LCPL_default_branch_code;
            }
        }
    }
    else if (isReq.equals("1"))
    {
        newUserId = request.getParameter("txtUserName");
        newUserPassword = request.getParameter("txtUserPassword");
        newUserReTypePassword = request.getParameter("txtReTypePassword");
        newUserLevel = request.getParameter("cmbUserLevel");
        //newUserStatus = request.getParameter("cmbStatus");
        newUserBank = request.getParameter("cmbBank");
        //newUserBranch = request.getParameter("cmbBranch");
        newUserBranch = LCPL_Constants.bank_default_branch_code;

        newName = request.getParameter("txtName");
        newDesignation = request.getParameter("txtDesignation");
        newEmail = request.getParameter("txtEmail");
        newContactNo = request.getParameter("txtContactNo");

        newUserRemarks = request.getParameter("txtaRemarks");

        if (newUserBank != null && !newUserBank.equals(LCPL_Constants.status_all))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(newUserBank, LCPL_Constants.status_pending);
        }

        User usr = new User();

        usr.setUserId(newUserId.trim());
        usr.setUserLevelId(newUserLevel);
        usr.setPassword(newUserPassword.trim());
        usr.setBankCode(newUserBank);
        usr.setBranchCode(newUserBranch);
        usr.setStatus(LCPL_Constants.status_pending);

        usr.setName(newName);
        usr.setDesignation(newDesignation);
        usr.setEmail(newEmail);
        usr.setContactNo(newContactNo);

        usr.setRemarks(newUserRemarks);
        usr.setCreatedBy(userName);
        usr.setIsInitialPassword(LCPL_Constants.status_yes);
        usr.setNeedDownloadToBIM(LCPL_Constants.status_yes);

        UserDAO userDAO = DAOFactory.getUserDAO();
        result = userDAO.addUser(usr);

        UserLevel usrlvl = DAOFactory.getUserLevelDAO().getUserLevel(newUserLevel);

        String newUserStatusDesc = "Pending";

        if (!result)
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_add_new_user, "| User Name - " + newUserId + ", Type - " + usrlvl.getUserLevelDesc() + ", Status - " + newUserStatusDesc + ", Bank - " + newUserBank + ", Name - " + newName + ", Designation - " + newDesignation + ", E-Mail - " + newEmail + ", Contact No. - " + newContactNo + ", Remarks - " + (newUserRemarks != null ? newUserRemarks : "") + " | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_add_new_user, "| User Name - " + newUserId + ", Type - " + usrlvl.getUserLevelDesc() + ", Status - " + newUserStatusDesc + ", Bank - " + newUserBank + ", Name - " + newName + ", Designation - " + newDesignation + ", E-Mail - " + newEmail + ", Contact No. - " + newContactNo + ", Remarks - " + (newUserRemarks != null ? newUserRemarks : "") + " | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>


<html>
    <head><title>OUSDPS Web - Create Usres</title>
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
            document.getElementById('txtUserName').setAttribute("autocomplete","off");
            document.getElementById('txtUserPassword').setAttribute("autocomplete","off");
            document.getElementById('txtReTypePassword').setAttribute("autocomplete","off");

            showClock(3);
            checkUserType();
            //showDivisionArea();
            }

            function resetRecords()
            {
            document.getElementById('txtUserName').value = "";
            document.getElementById('txtUserPassword').value = "<%=defaultPwd%>";
            document.getElementById('txtReTypePassword').value = "<%=defaultPwd%>";
            document.getElementById('cmbUserLevel').selectedIndex = 0;
            //document.getElementById('cmbStatus').selectedIndex = 0;
            document.getElementById('cmbBank').selectedIndex = 0; 

            if(document.getElementById('cmbBranch')!=null)
            {
            document.getElementById('cmbBranch').selectedIndex = 0; 
            }

            document.getElementById('txtName').value = "";
            document.getElementById('txtDesignation').value = "";
            document.getElementById('txtEmail').value = "";
            document.getElementById('txtContactNo').value = "";				
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

            function checkUserType()
            {
            var val_usrLvl = document.getElementById('cmbUserLevel').value;

            //alert("val_usrLvl - " + val_usrLvl);

            if(val_usrLvl=="-1")
            {
            document.getElementById('cmbBank').disabled = false;
            if(document.getElementById('cmbBranch')!=null)
            {
            document.getElementById('cmbBranch').disabled = false;
            }
            //document.getElementById('cmbBank').value = '<%=LCPL_Constants.status_all%>';                
            }
            else if(val_usrLvl=="3") 
            {                    
            document.getElementById('cmbBank').disabled = false;
            if(document.getElementById('cmbBranch')!=null)
            {
            document.getElementById('cmbBranch').disabled = false;
            }
            //document.getElementById('cmbBank').value='<%=LCPL_Constants.status_all%>';
            }
            else 
            {
            //document.getElementById('cmbBank').value = "9991";                                
            document.getElementById('cmbBank').disabled =true;
            if(document.getElementById('cmbBranch')!=null)
            {
            document.getElementById('cmbBranch').disabled = true;
            }
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
                
           var username = document.getElementById('txtUserName').value;
           var numbers = /\d/;
            var iChars = "!@#$%^&*()+=-[]\\';,./{}|\":<>?";
            
            
            var password = document.getElementById('txtUserPassword').value;
            var reType_password = document.getElementById('txtReTypePassword').value;
            var userLevel = document.getElementById('cmbUserLevel').value;
            //var status = document.getElementById('cmbStatus').value;
            var selbank = document.getElementById('cmbBank').value;
            //var selbranch = document.getElementById('cmbBranch').value;  
            var selbranch = "001";

            var v_name = document.getElementById('txtName').value;
            var v_desig = document.getElementById('txtDesignation').value;  
            var v_email = document.getElementById('txtEmail').value;  
            var v_contactno = document.getElementById('txtContactNo').value;  
            
           if (isEmpty(trim(username))) {
    alert("Username can't be empty!");
    document.getElementById('txtUserName').focus();
    return false;
}
// Check if the username contains numbers using the numbers regular expression
else if (numbers.test(username)) {
    alert("Username should not contain numbers!");
    document.getElementById('txtUserName').focus();
    return false;
}
    

// Check for special characters in the username
for (var i = 0; i < username.length; i++) {
    if (iChars.indexOf(username.charAt(i)) != -1) {
        alert("Username should not contain special characters!");
        document.getElementById('txtUserName').focus();
        return false;
    }
}

        
     
             if(isempty(trim(password)))
            {
            alert("Password Can't be Empty!");
            document.getElementById('txtUserPassword').focus();
            return false;
            }				

            if(isempty(trim(reType_password)))
            {
            alert("Re-type Password Can't be Empty");
            document.getElementById('txtReTypePassword').focus();
            return false;
            }

            /*
            if(status == "-1" || status == null)
            {
            alert("Select Status of the user.");
            document.getElementById('cmbStatus').focus();
            return false;
            }
            */

            if(userLevel == "-1" || userLevel == null)
            {
            alert("Select User Type.");
            document.getElementById('cmbUserLevel').focus();
            return false;
            }

            if (userLevel == "<%=LCPL_Constants.user_type_bank_user%>" && selbank=="<%=LCPL_Constants.status_all%>")
            {
            alert("Please Select the Bank for the user.");
            document.getElementById('cmbBank').focus();
            return false;
            }               


            /*
            if(userLevel == "<%=LCPL_Constants.user_type_bank_user%>" && selbranch=="<%=LCPL_Constants.status_all%>")
            {
            alert("Please Select the Branch for the user.");
            document.getElementById('cmbBranch').focus();
            return false;                    
            } 
            */ 


            if(isempty(trim(v_name)))
            {
            alert("Name Can't be Empty");
            document.getElementById('txtName').focus();
            return false;
            }

            if(isempty(trim(v_desig)))
            {
            alert("Designation Can't be Empty");
            document.getElementById('txtDesignation').focus();
            return false;
            }

            if(isempty(trim(v_email)))
            {
            alert("E-Mail Can't be Empty!");
            document.getElementById('txtEmail').focus();
            return false;
            }
            else
            {
            if(!checkEmail(trim(v_email)))
            {
            alert('Please Provide a Valid E-Mail Address!');
            document.getElementById('txtEmail').focus();
            return false;
            }

            }

            if(isempty(trim(v_contactno)))
            {
            alert("Contact No. Can't be Empty!");
            document.getElementById('txtContactNo').focus();
            return false;
            }
            else
            {
            if(!checkContactNo(trim(v_contactno)))
            {
            alert('Please Provide a Valid Contact No!');
            document.getElementById('txtContactNo').focus();
            return false;
            }
            }


            if(password_Validation())
            {
            document.getElementById('cmbBank').disabled =false;

            if(document.getElementById('cmbBranch')!=null)
            {
            document.getElementById('cmbBranch').disabled = false;
            }

            document.frmCreateUser.action="UserCreation.jsp";
            document.frmCreateUser.submit();
            return true;
            }
            else
            {
            alert("Password does not match with the Re-type Password!");

            document.getElementById('txtUserPassword').value="";
            document.getElementById('txtReTypePassword').value="";                    
            document.getElementById('txtUserPassword').focus();

            return false;
            }
            
            }
            
             function isEmpty(str) {
             return (!str || str.trim().length === 0);
             }

              // Additional function to trim leading and trailing whitespace
             function trim(str) {
             return str.replace(/^\s+|\s+$/g, '');
             }
            
            

            function isRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnReq').value = "1";
            }
            }

            function showDivisionArea()
            {        
            if('<%=isReq%>' == '0')
            {
            // alert("isReq");
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
            resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }

            if(document.getElementById('displayMsg_success') != null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            resetRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }
            }

            function isSearchRequest(status)
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


            function createUserSubmit()
            {
            isRequest(true);                    
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

           

            function checkEmail(emailVal) 
            {	
            var filter =/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i

            if (!filter.test(emailVal)) 
            {					
            return false;
            }
            else
            {
            return true;
            }
            }

            function checkContactNo(contactVal) 
            {	
            //var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
            var iChars2 = "+0123456789";

            var plusMarkCount = 0;
            var dashMarkCount = 0;

            var tempContactVal = contactVal;

            while(tempContactVal.indexOf("+") != -1)
            {
            tempContactVal = tempContactVal.replace("+","");
            plusMarkCount = plusMarkCount + 1;
            }				

            /*while(tempContactVal.indexOf("-") != -1)
            {
            tempContactVal = tempContactVal.replace("-","");
            dashMarkCount = dashMarkCount + 1;
            }	*/			

            if(plusMarkCount > 1 || dashMarkCount > 1)
            {					
            return false;
            }
            else
            {				

            for (var i = 0; i < contactVal.length; i++) 
            {
            if (iChars2.indexOf(contactVal.charAt(i)) < 0 ) 
            {
            return false;							
            }						
            }

            if (tempContactVal.length==10 || tempContactVal.length==11) 
            {					
            return true;
            }
            else
            {
            return false;
            }

            }
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
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">Create New User</td>
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
                                                                                            <form method="post" name="frmCreateUser" id="frmCreateUser">

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                            <%

                                                                                                                if (isReq.equals("1"))
                                                                                                                {

                                                                                                                    if (result == true)
                                                                                                                    {

                                                                                                            %>
                                                                                                            <div id="displayMsg_success" class="cits_Display_Success_msg" >

                                                                                                                User Created Sucessfully and pending for authorization.


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >User Creation Failed.- <span class="cits_error"><%=msg%></span></div>
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




                                                                                                                        <table border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">

                                                                                                                                        <tr>
                                                                                                                                            <td width="126" align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Username <span class="cits_required_field">*</span>  :        </td>

                                                                                                                                            <td width="185" valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text">
                                                                                                                                                <input name="txtUserName" type="text" class="cits_field_border" id="txtUserName" onFocus="hideMessage_onFocus()"  value="<%=(newUserId != null) ? newUserId : ""%>" size="50" maxlength="50" /></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Password<span  class="cits_required_field">*</span> :</td>

                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <input name="txtUserPassword" type="password" class="cits_field_border" id="txtUserPassword" onFocus="hideMessage_onFocus()" value="<%=(newUserPassword != null) ? newUserPassword : defaultPwd%>" size="34"  maxlength="32"/>              </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Re-Type Password<span  class="cits_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <input name="txtReTypePassword" type="password" class="cits_field_border" id="txtReTypePassword"  onFocus="hideMessage_onFocus()" value="<%=(newUserReTypePassword != null) ? newUserReTypePassword : defaultPwd%>" size="34" maxlength="32"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User Type <span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <select name="cmbUserLevel" id="cmbUserLevel" class="cits_field_border" onChange="isSearchRequest(false);
                                                                                                                                                        frmCreateUser.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <option value="-1" <%=(newUserLevel != null && newUserLevel.equals("-1")) ? "selected" : ""%>>--Select User Type--</option>
                                                                                                                                                    <%for (UserLevel usrlvl : colUserLevel)
                                                                                                                                                        {%>
                                                                                                                                                    <option value=<%=usrlvl.getUserLevelId()%> <%=(newUserLevel != null && usrlvl.getUserLevelId().equals(newUserLevel)) ? "selected" : ""%>><%=usrlvl.getUserLevelDesc()%></option>
                                                                                                                                                    <%}%>
                                                                                                                                                </select>                             </td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank <span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <select name="cmbBank" id="cmbBank" class="cits_field_border" onChange="isSearchRequest(false);
                                                                                                                                                        frmCreateUser.submit()" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <%
                                                                                                                                                        if (newUserBank == null || newUserBank.equals(LCPL_Constants.status_all))
                                                                                                                                                        {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- Select Bank --</option>
                                                                                                                                                    <% }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_all%>">-- Select Bank --</option>
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
                                                                                                                                                </select></td>
                                                                                                                                        </tr>
                                                                                                                                        <!-- tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Branch :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><select name="cmbBranch" id="cmbBranch" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                        <%                                                                                                                                            if (newUserBranch == null || newUserBranch.equals(LCPL_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- Select Branch --</option>
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
                                                                                                                                </select></td>
                                                                                                                        </tr -->
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Name <span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtName" id="txtName" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newName != null) ? newName : ""%>" size="80" maxlength="200"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Designation <span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtDesignation" id="txtDesignation" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newDesignation != null) ? newDesignation : ""%>" size="80" maxlength="200"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">E-Mail <span class="cits_required_field">*</span> : </td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtEmail" id="txtEmail" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newEmail != null) ? newEmail : ""%>" size="80" maxlength="200"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Contact No. <span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input type="text" name="txtContactNo" id="txtContactNo" class="cits_field_border" onFocus="hideMessage_onFocus()" value="<%=(newContactNo != null) ? newContactNo : ""%>" size="20" maxlength="20"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Remarks :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><textarea name="txtaRemarks" id="txtaRemarks" rows="3" cols="60" onFocus="hideMessage_onFocus()" class="cits_field_border"><%=(newUserRemarks != null) ? newUserRemarks : ""%></textarea></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="35" colspan="2" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text">                                                                                                                      <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="button" value="Create User" name="btnAdd" class="cits_custom_button" onClick="createUserSubmit()"/>                             </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /></td>
                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Reset" type="button" onClick="resetRecords()" class="cits_custom_button" />                                                            </td></tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>

                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table>


                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>










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
                                                    <td align="left" class="cits_copyRight">2012 &copy; Lanka Clear. All rights reserved.</td>
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


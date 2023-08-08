<%@page import="lk.com.ttsl.ousdps.dao.returnreason.ReturnReason"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.returnreason.*" errorPage="../../../error.jsp"%>
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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user)))
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
    Collection<ReturnReason> colReturnReason = null;
    ReturnReason objReturnReason = null;
    String isReq = null;
    String rtnCode = null;
    String old_desc = null;
    String desc = null;
    String old_printAs = null;
    String printAs = null;
    String old_status = null;
    String status = null;
    String msg = null;
    boolean result = false;

    colReturnReason = DAOFactory.getReturnReasonDAO().getReTurnTypes();
    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "0";
        rtnCode = LCPL_Constants.default_web_combo_select;
        old_desc = "";
        desc = "";
        old_printAs = "";
        printAs = "";
        old_status = "";
        status = LCPL_Constants.default_web_combo_select;

    }
    else if (isReq.equals("0"))
    {
        rtnCode = request.getParameter("cmbRtnCode");

        if (!rtnCode.equals(LCPL_Constants.default_web_combo_select))
        {
            objReturnReason = DAOFactory.getReturnReasonDAO().getReTurnTypeDetails(rtnCode);

            if (objReturnReason != null)
            {
                old_desc = objReturnReason.getReturnReason();
                desc = objReturnReason.getReturnReason();
                old_printAs = objReturnReason.getPrintAS();
                printAs = objReturnReason.getPrintAS();
                old_status = objReturnReason.getStatus() != null ? objReturnReason.getStatus().equals(LCPL_Constants.status_active) ? "Active" : "Inactive" : "N/A";
                status = objReturnReason.getStatus();
            }
            else
            {
                old_desc = "N/A";
                desc = "";
                old_printAs = "N/A";
                printAs = "";
                old_status = "N/A";
                status = LCPL_Constants.default_web_combo_select;
            }
        }
        else
        {
            old_desc = "";
            desc = "";
            old_printAs = "";
            printAs = "";
            old_status = "";
            status = LCPL_Constants.default_web_combo_select;
        }

    }
    else if (isReq.equals("1"))
    {
        rtnCode = request.getParameter("cmbRtnCode");
        desc = request.getParameter("txtDesc");
        printAs = request.getParameter("txtPrintAs");
        status = request.getParameter("cmbStatus");

        objReturnReason = DAOFactory.getReturnReasonDAO().getReTurnTypeDetails(rtnCode);

        ReturnReasonDAO returnDAO = DAOFactory.getReturnReasonDAO();
        result = returnDAO.modifyReturnTypes(new ReturnReason(rtnCode, desc, printAs, status, userName));

        String newStatDesc = "N/A";

        if (objReturnReason != null)
        {
            old_desc = objReturnReason.getReturnReason();
            old_printAs = objReturnReason.getPrintAS();
            old_status = objReturnReason.getStatus() != null ? objReturnReason.getStatus().equals(LCPL_Constants.status_active) ? "Active" : "Inactive" : "N/A";
        }
        else
        {
            old_desc = "N/A";
            old_printAs = "N/A";
            old_status = "N/A";
        }

        newStatDesc = status != null ? status.equals(LCPL_Constants.status_active) ? "Active" : "Inactive" : "N/A";

        if (!result)
        {
            msg = returnDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_return_maintenance_modify_return_types, "| Return Code  - " + rtnCode + ", Description - (New : " + desc + ", Old : " + old_desc + "), Print As - (New : " + printAs + ", Old : " + old_printAs + "), Status - (New : " + newStatDesc + ", Old : " + old_status + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_return_maintenance_modify_return_types, "| Return Code  - " + rtnCode + ", Description - (New : " + desc + ", Old : " + old_desc + "), Print As - (New : " + printAs + ", Old : " + old_printAs + "), Status - (New : " + newStatDesc + ", Old : " + old_status + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>


<html>
    <head><title>OUSDPS Web - Modify Return Reasons</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="../../../../js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/tigra_hints.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../../js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../../js/tableenhance.js"></script>
        <script language="javascript" type="text/JavaScript">



            function clearRecords_onPageLoad()
            {
            document.getElementById('cmbRtnCode').setAttribute("autocomplete","off");
            document.getElementById('txtDesc').setAttribute("autocomplete","off");
            document.getElementById('txtPrintAs').setAttribute("autocomplete","off");

            showClock(3);
            }


            function clearRecords()
            {
            document.getElementById('cmbRtnCode').selectedIndex = 0;
            document.getElementById('txtDesc').value = "";
            document.getElementById('txtPrintAs').value = "";
            document.getElementById('cmbStatus').selectedIndex = 0;
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
            var rc = document.getElementById('cmbRtnCode').value;
            var desc = document.getElementById('txtDesc').value;
            var printAs = document.getElementById('txtPrintAs').value;
            var stat = document.getElementById('cmbStatus').value;

            var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
            var numbers = /^[0-9]*$/;

            if(rc==null || rc=="-1")
            {
            alert("Please Select a Valid Return Code!");
            document.getElementById('cmbRtnCode').focus();
            return false;
            }

            if(isempty(desc))
            {
            alert("Description Can't be Empty!");
            document.getElementById('txtDesc').focus();
            return false;
            }

            if(isempty(printAs))
            {
            alert("Print As Can't be Empty!");
            document.getElementById('txtPrintAs').focus();
            return false;
            }

            if(stat==null || stat=="-1")
            {
            alert("Please Select a Valid Status for Return Code!");
            document.getElementById('cmbStatus').focus();
            return false;
            }

            document.frmModifyReturnReasons.action="ModifyReturnReasons.jsp";
            document.frmModifyReturnReasons.submit();
            return true;
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
            if(document.getElementById('displayMsg_error') != null )
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

            function doSearch()
            {
            isRequest(false);
            document.frmModifyReturnReasons.action="ModifyReturnReasons.jsp";
            document.frmModifyReturnReasons.submit();
            return true;
            }

            function doSubmit()
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Modify Return Reasons</td>
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
                                                                                            <form method="post" name="frmModifyReturnReasons" id="frmModifyReturnReasons">

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

                                                                                                                Return Reason modified Sucessfully.


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >Return Reason modification Failed.- <span class="cits_error"><%=msg%></span></div>
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
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td>
                                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">

                                                                                                                                                <%
                                                                                                                                                    String txtHName = "Current";

                                                                                                                                                    if (isReq.equals("1"))
                                                                                                                                                    {
                                                                                                                                                        if (result == true)
                                                                                                                                                        {
                                                                                                                                                            txtHName = "Old";
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            txtHName = "Current";
                                                                                                                                                        }
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        txtHName = "Current";
                                                                                                                                                    }

                                                                                                                                                %> <%=txtHName%>  Value</td>
                                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0"class="cits_tbl_header_text"> New Value</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td width="126" align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Retrun Code<span class="cits_required_field">*</span>  :        </td>

                                                                                                                                            <td width="126" align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><select name="cmbRtnCode" id="cmbRtnCode" class="cits_field_border" onChange="doSearch();" onFocus="hideMessage_onFocus()">

                                                                                                                                                    <option value="-1" <%=(rtnCode == null || rtnCode.equals("-1")) ? "selected" : ""%>>-- Select Return Reason --</option>

                                                                                                                                                    <%
                                                                                                                                                        if (colReturnReason != null && !colReturnReason.isEmpty())
                                                                                                                                                        {

                                                                                                                                                            for (ReturnReason rtnReason : colReturnReason)
                                                                                                                                                            {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=rtnReason.getReturnCode()%>" <%=(rtnCode != null && rtnReason.getReturnCode().equals(rtnCode)) ? "selected" : ""%>><%=rtnReason.getReturnCode()%> - <%=rtnReason.getPrintAS()%></option>

                                                                                                                                                    <% }%>
                                                                                                                                                </select>
                                                                                                                                                <% }
                                                                                                                                                else
                                                                                                                                                {%>
                                                                                                                                                <span class="cits_error">No Return Reason available.</span>
                                                                                                                                                <%}%></td>
                                                                                                                                            <td width="185" valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text">                                                                                                                        

                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Description <span  class="cits_required_field">*</span> :</td>

                                                                                                                                            <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><%=old_desc%></td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <input name="txtDesc" type="text" class="cits_field_border" id="txtDesc" onFocus="hideMessage_onFocus()" value="<%=(desc != null) ? desc : ""%>" size="46"  maxlength="45"/>              </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Print As <span  class="cits_required_field">*</span> :</td>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><%=old_printAs%></td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input name="txtPrintAs" type="text" class="cits_field_border" id="txtPrintAs" onFocus="hideMessage_onFocus()" value="<%=(printAs != null) ? printAs : ""%>" size="32"  maxlength="30"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status <span  class="cits_required_field">*</span> :</td>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><%=old_status%></td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><select name="cmbStatus" id="cmbStatus" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <option value="-1" <%=status == null || status.equals(LCPL_Constants.default_web_combo_select) ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_active%>" <%=status != null && status.equals(LCPL_Constants.status_active) ? "selected" : ""%>>Active</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_deactive%>" <%=status != null && status.equals(LCPL_Constants.status_deactive) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                </select></td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td height="35" colspan="3" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text">                                                                                                                      <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="button" value="Modify" name="btnAdd" class="cits_custom_button" onClick="doSubmit()"/>                             </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /></td>
                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Clear" type="button" onClick="clearRecords()" class="cits_custom_button" />                                                            </td></tr>
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

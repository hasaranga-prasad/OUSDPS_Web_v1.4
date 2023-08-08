<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.confirmstatus.ConfirmStatus" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.slipsowconfirmation.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.*" errorPage="../../../../error.jsp"%>
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

        if (!userType.equals(LCPL_Constants.user_type_bank_user))
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
    Collection<ConfirmStatus> colStatus = null;

    String isReq = null;
    String status = null;
    String remarks = null;
    String msg = null;

    boolean result = false;
    boolean isAlreadyConfirmed = false;
    boolean isWindowActive = false;
    SLIPSOWConfirmation slipsowconfirmation = null;

    colStatus = DAOFactory.getConfirmStatusDAO().getConfirmStatusDetails();

    isReq = (String) request.getParameter("hdnReq");

    //System.out.println("isReq - " + isReq);
    isWindowActive = DAOFactory.getWindowDAO().isWindowActive(sessionBankCode, winSession);

    if (isReq == null || isReq.equals("0"))
    {
        isReq = "0";

        isAlreadyConfirmed = DAOFactory.getSLIPSOWConfirmationDAO().isAlreadyConfirmed(new SLIPSOWConfirmation(webBusinessDate, winSession, sessionBankCode));

        if (isAlreadyConfirmed)
        {
            slipsowconfirmation = DAOFactory.getSLIPSOWConfirmationDAO().getConfirmationDetail(sessionBankCode, webBusinessDate, winSession);
            status = slipsowconfirmation.getStatusId();
            remarks = slipsowconfirmation.getRemarks();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_confirm_transmission_status, "| Business Date - " + webBusinessDate + ", session - " + winSession + ", Bank - " + sessionBankCode + ", OW Transmission Status - " + status + "  | Update Status - Unsuccess (" + msg + ") | Confirmed By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
    else if (isReq.equals("1"))
    {
        status = (String) request.getParameter("cmbStatus");
        remarks = (String) request.getParameter("txtaRemarks");

        SLIPSOWConfirmationDAO slipowconfirmDAO = DAOFactory.getSLIPSOWConfirmationDAO();

        result = slipowconfirmDAO.doConfirm(new SLIPSOWConfirmation(webBusinessDate, winSession, sessionBankCode, status, remarks, userName));

        if (!result)
        {
            msg = slipowconfirmDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_confirm_transmission_status, "| Business Date - " + webBusinessDate + ", session - " + winSession + ", Bank - " + sessionBankCode + ", OW Transmission Status - " + status + ", Remarks - " + remarks != null ? remarks : "N/A" + "  | Update Status - Unsuccess (" + msg + ") | Confirmed By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_confirm_transmission_status, "| Business Date - " + webBusinessDate + ", session - " + winSession + ", Bank - " + sessionBankCode + ", OW Transmission Status - " + status + ", Remarks - " + remarks != null ? remarks : "N/A" + " | Update Status - Success | Confirmed By - " + userName + " (" + userTypeDesc + ") |"));

            WindowDAO windowDAO = DAOFactory.getWindowDAO();

            Window windowUpdate = new Window();

            String cutOffTime = DAOFactory.getWindowDAO().getCurrentTime_HHmm();

            windowUpdate.setBankcode(sessionBankCode);
            windowUpdate.setSession(winSession);
            windowUpdate.setCutofftime(cutOffTime);
            windowUpdate.setModifiedby(LCPL_Constants.param_id_user_system);

            Window win = DAOFactory.getWindowDAO().getWindow(sessionBankCode, winSession);

            if (windowDAO.updateWindow_CutOffTime(windowUpdate))
            {
                isAlreadyConfirmed = true;
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_modify_window_details_while_confirm_transmission_status, "| Bank Code  - " + sessionBankCode + ", Session  - " + winSession + ", CutOffTime - (New : " + cutOffTime + ", Old : " + win.getCutofftime() + ") | Process Status - Success | Modified By - " + LCPL_Constants.param_id_user_system + " |"));
            }
            else
            {
                msg = windowDAO.getMsg();
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_modify_window_details_while_confirm_transmission_status, "| Bank Code  - " + sessionBankCode + ", Session  - " + winSession + ", CutOffTime - (New : " + cutOffTime + ", Old : " + win.getCutofftime() + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + LCPL_Constants.param_id_user_system + " |"));
            }
        }
    }
%>


<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>OUSDPS Web - Outward Transmission Confirmation</title>
    <link href="../../../../css/cits.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript" type="text/javascript" src="../../../../js/fade.js"></script>
    <script language="JavaScript" type="text/javascript" src="../../../../js/digitalClock.js"></script>
    <script language="JavaScript" type="text/javascript" src="../../../../js/datetimepicker.js"></script>
    <script language="javascript" type="text/JavaScript">

        function validate()
        {

        var selStatus = document.getElementById('cmbStatus').value;


        if(selStatus == "-1")
        {
        alert("Please select a Status before the confirmation!");
        document.getElementById('cmbStatus').focus();
        return false;
        }
        else
        {
        if(selStatus == "4" && isempty(trim(document.getElementById('txtaRemarks').value)))
        {
        alert("Please give a valid remark for the status type 'Other'!");
        document.getElementById('txtaRemarks').value = "";
        document.getElementById('txtaRemarks').focus();
        return false;
        }
        else
        {
        isRequest(true);
        document.frmConfirmOWT.submit();
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



        function hideMessage_onFocus()
        {
        if(document.getElementById('displayMsg_error') != null)
        {
        document.getElementById('displayMsg_error').style.display='none';
        document.getElementById('hdnReq').value = "0";
        document.frmConfirmOWT.submit();
        }

        if(document.getElementById('displayMsg_success') != null)
        {
        document.getElementById('displayMsg_success').style.display = 'none';
        document.getElementById('hdnReq').value = "0";
        document.frmConfirmOWT.submit();
        }
        }


        function resetRecords()
        {       

        document.getElementById('cmbStatus').selectedIndex = 0;
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
                                                                                    <td align="left" valign="top" class="cits_header_text">Outward Transmission Confirmation</td>
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


                                                                                        <form id="frmConfirmOWT" name="frmConfirmOWT" action="OWConfirmation.jsp">

                                                                                            <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                                                                <%
                                                                                                    if (!isWindowActive)
                                                                                                    {
                                                                                                %>

                                                                                                <tr>
                                                                                                    <td align="center" ><div id="displayMsg_success" class="cits_Display_Error_msg" >Sorry Session Is Expired!.</div></td>
                                                                                                </tr>


                                                                                                <%
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    if (isReq.equals("1") && result == true)
                                                                                                    {%>
                                                                                                <tr>
                                                                                                    <td align="center" ><div id="displayMsg_success" class="cits_Display_Success_msg" >Outward Transmission Confirmation Updated Succesfully.</div></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td height="5" ></td>
                                                                                                </tr>
                                                                                                <%                     }
                                                                                                else if (isReq.equals("1") && result == false)
                                                                                                {%>
                                                                                                <tr>

                                                                                                    <td align="center" class="cits_Display_Error_msg"><div id="displayMsg_error" class="cits_Display_Error_msg" >Outward Transmission Confirmation Failed - <span class="cits_error"><%=msg%></span></div></td>
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
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business Date :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><%=webBusinessDate%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Session  :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><%=winSession%></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><%=sessionBankCode%> - <%=sessionBankName%></td>
                                                                                                                        </tr>

                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"> <select name="cmbStatus" id="cmbStatus" class="cits_field_border" onFocus="hideMessage_onFocus()" <%=isAlreadyConfirmed == true ? "disabled" : ""%>>
                                                                                                                                    <%
                                                                                                                                        if (status == null || (status != null && status.equals("-1")))
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <option value="-1" selected="selected">-- Select --</option>
                                                                                                                                    <%                                                                                                                        }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <option value="-1">-- All --</option>
                                                                                                                                    <%                                                                                                                                                            }
                                                                                                                                    %>
                                                                                                                                    <%
                                                                                                                                        if (colStatus != null && colStatus.size() > 0)
                                                                                                                                        {
                                                                                                                                            for (ConfirmStatus cStat : colStatus)
                                                                                                                                            {

                                                                                                                                                if (!cStat.getID().equals(LCPL_Constants.confirmation_status_three))
                                                                                                                                                {
                                                                                                                                    %>
                                                                                                                                    <option value="<%=cStat.getID()%>" <%=(status != null && cStat.getID().equals(status)) ? "selected" : ""%> > <%=cStat.getDescription()%></option>
                                                                                                                                    <%

                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                </select>  </td></tr>
                                                                                                                        <tr>
                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Remarks :</td>
                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><textarea name="txtaRemarks" id="txtaRemarks" rows="3" cols="50" onFocus="hideMessage_onFocus()" class="cits_field_border" <%=isAlreadyConfirmed == true ? "disabled" : ""%>><%=(remarks != null) ? remarks : ""%></textarea></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td height="35" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /></td>
                                                                                                                            <td align="right" valign="middle" bgcolor="#CDCDCD"class="cits_tbl_header_text">
                                                                                                                                <%
                                                                                                                                    if (isAlreadyConfirmed)
                                                                                                                                    {
                                                                                                                                %>
                                                                                                                                You Have Already Confirmed Your Outward Transmission Status !

                                                                                                                                <%                                                                                                                                                                                                                                                        }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                %>
                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td>&nbsp;</td>
                                                                                                                                        <td></td>
                                                                                                                                        <td>&nbsp;</td>
                                                                                                                                    </tr>
                                                                                                                                    <tr>
                                                                                                                                        <td><input type="button" value="Confirm" name="btnConfirm" id="btnConfirm" class="cits_custom_button" onClick="validate();" <%=isAlreadyConfirmed == true ? "disabled" : ""%>/>                             </td>
                                                                                                                                        <td width="5"></td>
                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Reset" type="button" onClick="resetRecords()" class="cits_custom_button" <%=isAlreadyConfirmed == true ? "disabled" : ""%>/>                                                </td></tr>
                                                                                                                                </table>

                                                                                                                                <%                                                                                                                                    }
                                                                                                                                %>                                                                                                                            </td>
                                                                                                                        </tr>

                                                                                                                    </table></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>

                                                                                                <%
                                                                                                    }
                                                                                                %>
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

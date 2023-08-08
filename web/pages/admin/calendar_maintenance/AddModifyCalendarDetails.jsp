<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.calendar.*" errorPage="../../../error.jsp"%>
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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user) || userType.equals(LCPL_Constants.user_type_lcpl_supervisor)))
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

    BCMCalendar objCal = null;

    String isReq = null;
    String newCalDate = null;
    String newCalType = null;
    String newcalCategory = null;
    String newCalRemarks = null;
    String addOrUpdate = null;
    String msg = null;

    boolean result = false;
    boolean isDateAlreadySet = false;

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "0";
        newCalType = "-1";
        newcalCategory = "0";
    }
    else if (isReq.equals("0"))
    {
        newCalDate = request.getParameter("txtDate");

        objCal = DAOFactory.getBCMCalendarDAO().getCalendar(newCalDate);

        if (objCal != null)
        {
            isDateAlreadySet = true;

            newCalType = objCal.getDayType();
            newcalCategory = objCal.getDayCategory();
            newCalRemarks = objCal.getRemarks() == null ? "" : objCal.getRemarks();
        }
        else
        {
            newCalType = request.getParameter("cmbType");
            //newcalCategory = request.getParameter("cmbCategory");
            newcalCategory = "0";
            newCalRemarks = request.getParameter("txtaRemarks");
        }

    }
    else if (isReq.equals("1"))
    {
        newCalDate = request.getParameter("txtDate");
        newCalType = request.getParameter("cmbType");
        //newcalCategory = request.getParameter("cmbCategory");
        newcalCategory = "0";
        newCalRemarks = request.getParameter("txtaRemarks");
        addOrUpdate = (String) request.getParameter("hdnAddorUpdate");

        objCal = DAOFactory.getBCMCalendarDAO().getCalendar(newCalDate);

        BCMCalendarDAO calendarDAO = DAOFactory.getBCMCalendarDAO();

        /*
         if (!result)
         {
         msg = calendarDAO.getMsg();
         }
         */

        if (addOrUpdate != null && addOrUpdate.equals("1"))
        {
            result = calendarDAO.updateCalendarDetail(new BCMCalendar(newCalDate, newCalType, newcalCategory, newCalRemarks, userName));

            if (!result)
            {
                msg = calendarDAO.getMsg();
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_calendar_maintenance_modify_calendar_details, "| Calendar Date - " + newCalDate + ", Type - (New : " + newCalType + ", Old : " + objCal.getDayType() + "), Category - (New : " + newcalCategory + ", Old : " + objCal.getDayCategory() + "), Remarks - (New : " + newCalRemarks + ", Old : " + objCal.getRemarks() == null ? "" : objCal.getRemarks() + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
            }
            else
            {
                isDateAlreadySet = true;
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_calendar_maintenance_modify_calendar_details, "| Calendar Date - " + newCalDate + ", Type - (New : " + newCalType + ", Old : " + objCal.getDayType() + "), Category - (New : " + newcalCategory + ", Old : " + objCal.getDayCategory() + "), Remarks - (New : " + newCalRemarks + ", Old : " + (objCal.getRemarks() == null ? "" : objCal.getRemarks()) + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
            }
        }
        else if (addOrUpdate != null && addOrUpdate.equals("0"))
        {
            result = calendarDAO.addCalendarDetail(new BCMCalendar(newCalDate, newCalType, newcalCategory, newCalRemarks, userName));

            if (!result)
            {
                msg = calendarDAO.getMsg();
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_calendar_maintenance_add_calendar_details, "| Calendar Date - " + newCalDate + ", Type - " + newCalType + ", Category - " + newcalCategory + ", Remarks - " + newCalRemarks + " | Process Status - Unsuccess (" + msg + ") | Added By - " + userName + " (" + userTypeDesc + ") |"));
            }
            else
            {
                isDateAlreadySet = true;
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_calendar_maintenance_add_calendar_details, "| Calendar Date - " + newCalDate + ", Type - " + newCalType + ", Category - " + newcalCategory + ", Remarks - " + newCalRemarks + " | Process Status - Success | Added By - " + userName + " (" + userTypeDesc + ") |"));
            }
        }
        else
        {
            msg = LCPL_Constants.msg_error_while_processing;
        }
    }
%>


<html>
    <head><title>OUSDPS Web - Add New Calendar Details</title>
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
            document.getElementById('txtDate').setAttribute("autocomplete","off");

            showClock(3);                
            }

            function clearRecords()
            {
            document.getElementById('txtDate').value = "";
            document.getElementById('cmbType').selectedIndex = 0;
            document.getElementById('cmbCategory').selectedIndex = 0;				
            document.getElementById('txtaRemarks').value = "";
            document.getElementById('hdnReq').value = "0";
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
            var calDate = document.getElementById('txtDate').value;
            var calType = document.getElementById('cmbType').value;
            var calCategory = document.getElementById('cmbCategory').value;         

            if(isempty(calDate))
            {
            alert("Date Can't be Empty!");
            document.getElementById('txtDate').focus();
            return false;
            }

            if(calType == "-1" || calType == null)
            {
            alert("Select Type!");
            document.getElementById('cmbType').focus();
            return false;
            }

            if(calCategory == "-1" || calCategory == null)
            {
            alert("Select Category!");
            document.getElementById('cmbCategory').focus();
            return false;
            }

            document.frmAddCalendarDetail.action="AddModifyCalendarDetails.jsp";
            document.frmAddCalendarDetail.submit();
            return true;

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

            function searchCalDetailSubmit()
            {
            var calDate = document.getElementById('txtDate').value;

            if(isempty(calDate))
            {
            alert("Date Can't be Empty!");
            document.getElementById('txtDate').focus();
            return false;
            }
            else
            {                
            isRequest(false);  
            document.getElementById('cmbType').selectedIndex = 0;
            document.getElementById('cmbCategory').selectedIndex = 0;				
            document.getElementById('txtaRemarks').value = "";
            document.frmAddCalendarDetail.action="AddModifyCalendarDetails.jsp";
            document.frmAddCalendarDetail.submit();
            return true;	
            }		
            }


            function addCalDetailSubmit()
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Add / Modify Calendar Detail</td>
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
                                                                                            <form method="post" name="frmAddCalendarDetail" id="frmAddCalendarDetail">

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

                                                                                                                Calendar Details Updated Sucessfully.


                                                                                                            </div>
                                                                                                            <% }
                                                                                else
                                                                                {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >Calendar Details Updating Failed.- <span class="cits_error"><%=msg%></span></div>
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




                                                                                                                        <table border="0" cellspacing="0" cellpadding="0" >
                                                                                                                            <tr>
                                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">

                                                                                                                                        <tr>
                                                                                                                                            <td width="126" align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Date <span class="cits_required_field">*</span>  :        </td>

                                                                                                                                            <td valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text">
                                                                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td valign="middle"><input name="txtDate" id="txtDate" type="text"
                                                                                                                                                                                   class="cits_field_border" size="8" onFocus="this.blur();
                    searchCalDetailSubmit();" value="<%=(newCalDate == null || newCalDate.equals("0") || newCalDate.equals(LCPL_Constants.status_all)) ? "" : newCalDate%>" >                                                                                                                    </td>
                                                                                                                                                        <td width="5" valign="middle"></td>
                                                                                                                                                        <td valign="middle"><a href="javascript:cal_from.popup();hideMessage_onFocus()"><img
                                                                                                                                                                    src="../../../images/cal_old.gif" border="0"
                                                                                                                                                                    title=" From " height="24"
                                                                                                                                                                    width="22"></a></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table> </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Type <span class="cits_required_field">* </span>:</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <select name="cmbType" id="cmbType" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <option value="-1" <%=(newCalType != null && newCalType.equals("-1")) ? "selected" : ""%>>--Select Type--</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.calendar_day_type_fbd%>" <%=(newCalType != null && newCalType.equals(LCPL_Constants.calendar_day_type_fbd)) ? "selected" : ""%>><%=LCPL_Constants.calendar_day_type_fbd%></option>
                                                                                                                                                    <option value="<%=LCPL_Constants.calendar_day_type_nbd%>" <%=(newCalType != null && newCalType.equals(LCPL_Constants.calendar_day_type_nbd)) ? "selected" : ""%>><%=LCPL_Constants.calendar_day_type_nbd%></option>
                                                                                                                                                    <option value="<%=LCPL_Constants.calendar_day_type_pbd%>" <%=(newCalType != null && newCalType.equals(LCPL_Constants.calendar_day_type_pbd)) ? "selected" : ""%>><%=LCPL_Constants.calendar_day_type_pbd%></option>
                                                                                                                                                </select> 


                                                                                                                                                <select name="cmbCategory" id="cmbCategory" class="cits_field_border" onFocus="hideMessage_onFocus()" style="visibility:hidden;width:0px" >
                                                                                                                                                    <option value="-1" <%=(newcalCategory != null && newcalCategory.equals("-1")) ? "selected" : ""%>>--Select Category--</option>
                                                                                                                                                    <option value="0" <%=(newcalCategory != null && newcalCategory.equals("0")) ? "selected" : ""%>>0</option>
                                                                                                                                                    <option value="1" <%=(newcalCategory != null && newcalCategory.equals("1")) ? "selected" : ""%>>1</option>
                                                                                                                                                    <option value="2" <%=(newcalCategory != null && newcalCategory.equals("2")) ? "selected" : ""%>>2</option>
                                                                                                                                                    <option value="3" <%=(newcalCategory != null && newcalCategory.equals("3")) ? "selected" : ""%>>3</option>
                                                                                                                                                </select>


                                                                                                                                            </td>
                                                                                                                                        </tr>


                                                                                                                                        <!--tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Category <span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                                             </td>
                                                                                                                                        </tr-->

                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Remarks :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><textarea name="txtaRemarks" id="txtaRemarks" rows="3" cols="40" onFocus="hideMessage_onFocus()" class="cits_field_border"><%=(newCalRemarks != null) ? newCalRemarks : ""%></textarea></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="35" colspan="2" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text">                                                                                                                      <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="button" value="<%=isDateAlreadySet ? "Update" : "Add"%>" name="btnAdd" class="cits_custom_button" onClick="addCalDetailSubmit()"/></td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /><input type="hidden" name="hdnAddorUpdate" id="hdnAddorUpdate" value="<%=isDateAlreadySet ? "1" : "0"%>" /></td>
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
                                                                                            <script language="javascript" type="text/JavaScript">
                                                                                                <!--
                                                                                                // create calendar object(s) just after form tag closed
                                                                                                // specify form element as the only parameter (document.forms['formname'].elements['inputname']);
                                                                                                // note: you can have as many calendar objects as you need for your application


                                                                                                var cal_from = new calendar1(document.forms['frmAddCalendarDetail'].elements['txtDate']);
                                                                                                cal_from.year_scroll = true;
                                                                                                cal_from.time_comp = false;

                                                                                                //-->
                                                                                            </script>
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

<%@page import="java.sql.*,java.util.*,java.io.*,java.text.SimpleDateFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.message.CustomMsg" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.message.Recipient" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.header.MsgHeader" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.body.MsgBody" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.priority.MsgPriority" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../error.jsp"%>
<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>
<%
    String session_userName = null;
    String session_userType = null;
    String session_userTypeDesc = null;
    String session_bankCode = null;
    String session_bankName = null;
    String session_sbCode = null;
    String session_sbType = null;
    String session_branchId = null;
    String session_branchName = null;
    String session_menuId = null;
    String session_menuName = null;

    session_userName = (String) session.getAttribute("session_userName");

    if (session_userName == null || session_userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        session_userType = (String) session.getAttribute("session_userType");
        session_userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
        session_bankCode = (String) session.getAttribute("session_bankCode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");

%>
<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();

    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, LCPL_Constants.status_yes);
%>
<%
    //String msgFrom = null;
    String msgFromBank = null;
    String msgFromCounter = null;
    String priority = null;
    String readStatus = null;
    String fromDate = null;
    String toDate = null;

    String isInitReq = null;
    String isSearchReq = null;

    Collection<MsgPriority> colMsgPriority = null;
    Collection<Recipient> colMsgFromBank = null;
    Collection<Recipient> colMsgFromCounter = null;
    Collection<CustomMsg> colMsg = null;

    //isInitReq = (String) request.getParameter("hdnInitReq");
    isSearchReq = (String) request.getParameter("hdnSearchReq");

    colMsgPriority = DAOFactory.getMsgPriorityDAO().getPriorityDetails();
    //colMsgFrom = DAOFactory.getBranchDAO().getBranch(bankCode, LCPL_Constants.status_all, LCPL_Constants.status_all);
    //colMsgFrom = DAOFactory.getCustomMsgDAO().getAvailableRecipientList(userType, bankCode, branchId, counterCode);
    colMsgFromBank = DAOFactory.getCustomMsgDAO().getAvailableFullRecipientList(session_userType, session_bankCode);

    if (isSearchReq == null)
    {
        isSearchReq = "0";
        msgFromBank = LCPL_Constants.status_all;
        priority = LCPL_Constants.status_all;
        readStatus = LCPL_Constants.status_all;
        fromDate = currentDate;
        toDate = currentDate;
        
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_search_inbox, "| Initail visit. | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }
    else
    {

        msgFromBank = (String) request.getParameter("cmbMsgFromBank");
        priority = (String) request.getParameter("cmbPriority");
        readStatus = (String) request.getParameter("cmbReadStatus");
        fromDate = (String) request.getParameter("txtFromSentDate");
        toDate = (String) request.getParameter("txtToSentDate");

        if (isSearchReq.equals("1"))
        {
            if (fromDate == null || fromDate.equals(""))
            {
                fromDate = LCPL_Constants.status_all;
            }

            if (toDate == null || toDate.equals(""))
            {
                toDate = LCPL_Constants.status_all;
            }
            
            
            colMsg = DAOFactory.getCustomMsgDAO().getMessageList(msgFromBank, session_bankCode, priority, readStatus, fromDate, toDate);

            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_search_inbox, "| From  - " + msgFromBank + ", Priority - " + priority + ", Read Status - " + readStatus + ", From Date - " + fromDate + ", To Date - " + toDate + "| Result Count - " + colMsg.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
            
        }
    }
%>
<html>
    <head>
        <title>OUSDPS Web (Version 1.2.0 - 2018)</title>
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../../css/tcal.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tcal.js"></script>


        <script language="javascript" type="text/JavaScript">

            function doSubmit()
            {				
            if(validate())
            {
            document.frmMessageSummary.submit();
            }
            }

            function validate()
            {
            var fromDateValue = null;
            var toDateValue = null;

            fromDateValue = document.getElementById('txtFromSentDate').value;
            toDateValue = document.getElementById('txtToSentDate').value;

            if(dateValidate(fromDateValue, toDateValue))
            {
            return true;
            }
            else
            {
            //alert('From date should be lesser than To date.');
            return false;
            }

            }

            function dateValidate(fromDate, toDate)
            {
            var from_date = new Date();
            var to_date = new Date();

            if(fromDate != null && fromDate.length > 0)
            {
            if(toDate != null && toDate.length > 0)
            {
            from_date.setFullYear(fromDate.substring(0,4), (parseInt(fromDate.substring(5,7)))-1, fromDate.substring(8,10));
            to_date.setFullYear(toDate.substring(0,4), (parseInt(toDate.substring(5,7)))-1, toDate.substring(8,10));

            if(from_date.getTime() <= to_date.getTime())
            {
            if((to_date.getTime()-from_date.getTime()) <= 16070400000)
            {
            return true;
            }
            else
            {
            alert('From-Date and To-Date gap must be less than or equal to 186 days!');
            return false;
            }
            }
            else
            {
            alert('From-Date should be lesser than To-Date!');
            return false;
            }
            }
            else
            {
            alert('To-Date Can not be empty!');
            return true;
            }                    
            }
            else
            {
            alert('From-Date Can not be empty!');
            return true;
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
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window != null ? window.getCutontimeHour() : null%>, <%=window != null ? window.getCutontimeMinutes() : null%>, <%=window != null ? window.getCutofftimeHour() : null%>, <%=window != null ? window.getCutofftimeMinutes() : null%>);
            clock(document.getElementById('showText'),type,val);
            }
            }


            function clearDates()
            {
            var from_elementId = 'txtFromSentDate';
            var to_elementId = 'txtToSentDate';

            document.getElementById(from_elementId).value = "<%=webBusinessDate%>";
            document.getElementById(to_elementId).value = "<%=webBusinessDate%>";

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

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="showClock(3)">
        <table style="min-width:980" height="600" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_bgRepeat_left">
                        <tr>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="95" class="cits_header_center">

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
                                                                                                    <td valign="middle">

                                                                                                        <div style="padding:1;height:100%;width:100%;">
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** CITS ****</div>
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=session_menuName%>" vqp_uid0=<%=session_menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";
                                                                                                                cdd__codebase<%=session_menuId%> = "<%=request.getContextPath()%>/js/";</script>
                                                                                                            <script language="JavaScript" vqptag="datafile" src="<%=request.getContextPath()%>/js/<%=session_menuName%>"></script>
                                                                                                            <script vqptag="placement" vqp_menuid="<%=session_menuId%>" language="JavaScript">create_menu(<%=session_menuId%>)</script>
                                                                                                        </div></td>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td align="right" valign="middle"><table height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td class="cits_menubar_text">Welcome :</td>
                                                                                                                <td width="5"></td>
                                                                                                                <td class="cits_menubar_text"><b><%=session_userName%></b> - <%=session_bankName%></td>
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
                                                                <td height="24" align="right" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
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
                                                                <td align="center" valign="top"><table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text">Inbox -  Message Summary</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"><form id="frmMessageSummary" name="frmMessageSummary" method="post" action="MessageSummary.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" align="center">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellspacing="0" cellpadding="0" align="center">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                            <input type="hidden" name="hdnInitReq" id="hdnInitReq" value="<%=isInitReq%>" />
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">From :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="cits_tbl_header_text"><%

                                                                                                                                    try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbMsgFromBank" class="cits_field_border" id="cmbMsgFromBank" onChange="isSearchRequest(false);
                                                                                                                                                    doSubmit();" >
                                                                                                                                        <%                                                                                                                    if (msgFromBank == null || msgFromBank.equals(LCPL_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" selected="selected">- All Banks -</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>">- All Banks -</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colMsgFromBank != null && colMsgFromBank.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Recipient branchSender : colMsgFromBank)
                                                                                                                                                {


                                                                                                                                        %>
                                                                                                                                        <option value="<%=branchSender.getRecipientCode()%>" <%=(msgFromBank != null && branchSender.getRecipientCode().equals(msgFromBank)) ? "selected" : ""%>   ><%=branchSender.getRecipientCode()%> - <%=branchSender.getRecipientName()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="cits_error">No From Bank details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>



                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Priority :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="cits_tbl_header_text"><%                                                                                                          try
                                                                                                                                    {


                                                                                                                                    %>
                                                                                                                                    <select name="cmbPriority" class="cits_field_border" id="cmbPriority" onChange="clearResultData()">
                                                                                                                                        <%                                                                                                                    if (priority == null || priority.equals(LCPL_Constants.status_all))
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
                                                                                                                                            if (colMsgPriority != null && !colMsgPriority.isEmpty())
                                                                                                                                            {

                                                                                                                                                for (MsgPriority msgPriority : colMsgPriority)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <option value="<%=msgPriority.getPriorityLevel()%>" <%=(priority != null && msgPriority.getPriorityLevel().equals(priority)) ? "selected" : ""%> ><%=msgPriority.getPriorityDesc()%></option>
                                                                                                                                        <%

                                                                                                                                            }


                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="cits_error">No priority details available.</span>
                                                                                                                                    <%                            }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }


                                                                                                                                    %></td>


                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Read Status  :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="cits_tbl_header_text"><select name="cmbReadStatus" id="cmbReadStatus" class="cits_field_border" onChange="clearResultData()">
                                                                                                                                        <%                                                                                                                    if (readStatus == null)
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" <%=readStatus != null && readStatus.equals(LCPL_Constants.status_all) ? "selected" : ""%> >-- All --</option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.msg_isred_no%>" <%=readStatus != null && readStatus.equals(LCPL_Constants.msg_isred_no) ? "selected" : ""%>>Unread</option>
                                                                                                                                        <option value="<%=LCPL_Constants.msg_isred_yes%>" <%=readStatus != null && readStatus.equals(LCPL_Constants.msg_isred_yes) ? "selected" : ""%>>Read</option>
                                                                                                                                    </select></td>

                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Sent Date :</td>
                                                                                                                                <td valign="middle" bgcolor="#E1E3EC" class="cits_tbl_header_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromSentDate" id="txtFromSentDate" type="text"
                                                                                                                                                                       class="tcal" size="8" onFocus="this.blur();
                                                                                                                                                                               clearResultData();" value="<%=(fromDate == null || fromDate.equals("0") || fromDate.equals(LCPL_Constants.status_all)) ? "" : fromDate%>" >                                                                                                                    </td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToSentDate" id="txtToSentDate" type="text"
                                                                                                                                                                       class="tcal" size="8" onFocus="this.blur();
                                                                                                                                                                               clearResultData();" value="<%=(toDate == null || toDate.equals("0") || toDate.equals(LCPL_Constants.status_all)) ? "" : toDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="Reset Dates" type="button" onClick="clearDates()" class="cits_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                        </td>


                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="2" align="right" valign="middle" bgcolor="#CECED7" class="cits_tbl_header_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center"><div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    doSubmit();"  class="cits_custom_button"/></td>
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
                                                                                                                if (isSearchReq.equals("1") && colMsg.size() == 0)
                                                                                                                {%>
                                                                                                            <tr>
                                                                                                                <td class="cits_header_text" align="center"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="cits_tbl_header_text">No Records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%                                                                                    }
                                                                                                            else if (isSearchReq.equals("1") && !colMsg.isEmpty())
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td class="cits_header_text" align="center"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">
                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                            <tr>
                                                                                                                                <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >From</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Subject</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Message</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Priority</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Attachment</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created Time</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                int rowNum = 0;
                                                                                                                                String msgSubjectPart = null;
                                                                                                                                String msgPart = null;

                                                                                                                                for (CustomMsg customMsg : colMsg)
                                                                                                                                {
                                                                                                                                    rowNum++;

                                                                                                                                    MsgHeader msgHeader = customMsg.getMsgHeader();
                                                                                                                                    MsgBody msgBody = customMsg.getMsgBody();
                                                                                                                                    MsgPriority msgPriority = customMsg.getMsgPriority();

                                                                                                                                    if ((msgHeader != null) && (msgHeader.getSubject() != null))
                                                                                                                                    {
                                                                                                                                        if (msgHeader.getSubject().length() > 35)
                                                                                                                                        {
                                                                                                                                            msgSubjectPart = msgHeader.getSubject().substring(0, 31) + "....";
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            msgSubjectPart = msgHeader.getSubject();
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        msgSubjectPart = "";
                                                                                                                                    }

                                                                                                                                    if ((msgBody != null) && (msgBody.getBody() != null))
                                                                                                                                    {
                                                                                                                                        if (msgBody.getBody().length() > 25)
                                                                                                                                        {
                                                                                                                                            msgPart = msgBody.getBody().substring(0, 21) + "....";
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            msgPart = msgBody.getBody();
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        msgPart = "";
                                                                                                                                    }

                                                                                                                            %>
                                                                                                                            <form name="frmMsgDetails" id="frmMsgDetails" action="MessageDetail.jsp" method="post">
                                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E7E9ED" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                    <td align="right" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                                                    <td align="left" class="cits_msg_from" ><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%> [<%=msgHeader.getCreatedBy()%>]</td>
                                                                                                                                    <td align="left" class="cits_msg_subject"><%=msgSubjectPart %></td>
                                                                                                                                    <td align="left" class="cits_common_text" ><%=msgPart %></td>
                                                                                                                                    <td align="center" class="cits_common_text" ><%=msgPriority.getPriorityDesc()%></td>
                                                                                                                                    <td align="center" class="cits_common_text">
																																	
																																	<% 
																																	if(msgBody.getIsRed().equals(LCPL_Constants.msg_isred_yes))
																																	{ %>
                                                                                                                                    
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/read_msg.png" width="25"
                                                                                                                                             height="20" border="0" align="middle" title="You have already read this messgae!" >
                                                                                                                                    
                                                                                                                                    <%
																																	} 
																																	else 
																																	{
																																	%>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/unread_msg.png" width="25"
                                                                                                                                             height="20" border="0" align="middle" title="Unread Message" >
                                                                                                                                    <%
																																	}
																																	%>
                                                                                                                                    </td>
                                                                                                                                    <td align="center" class="cits_header_text" >
                                                                                                                                        <% if (msgHeader.getAttachmentOriginalName() != null)
                                                                                                                                            {%>  <img src="<%=request.getContextPath()%>/images/attachment_small.png" width="16"
                                                                                                                                             height="20" border="0" align="middle" > <%  }%>

                                                                                                                                    </td>
                                                                                                                                    <td align="center" class="cits_common_text"><%=msgHeader.getCreatedTime() == null ? "N/A" : msgHeader.getCreatedTime()%></td>
                                                                                                                                    <td align="center" class="cits_tbl_header_text">
                                                                                                                                        <input type="hidden" name="msgId" id="msgId" value="<%=msgHeader.getMsgId()%>">
                                                                                                                                        <input type="hidden" name="msgHeaderFromBank" id="msgHeaderFromBank" value="<%=msgHeader.getMsgFromBank()%>">
                                                                                                                                        
                                                                                                                                        <input type="hidden" name="msgParentId" id="msgParentId" value="<%=msgHeader.getMsgParentId()%>">
                                                                                                                                        <input type="hidden" name="msgGrandParentId" id="msgGrandParentId" value="<%=msgHeader.getMsgGrandParentId()%>">
                                                                                                                                        <input type="hidden" name="reqPage" id="reqPage" value="MessageSummary.jsp">
                                                                                                                                        <input type="hidden" name="isAlreadyRed" id="isAlreadyRed" value="<%=msgBody.getIsRed()%>">
                                                                                                                                        <input type="hidden" name="hdnMsgFromBank" id="hdnMsgFromBank" value="<%=msgFromBank%>" />   
                                                                                                                                        <input type="hidden" name="hdnPriority" id="hdnPriority" value="<%=priority%>" />
                                                                                                                                        <input type="hidden" name="hdnReadStatus" id="hdnReadStatus" value="<%=readStatus%>" />
                                                                                                                                        <input type="hidden" name="hdnFromDate" id="hdnFromDate" value="<%=fromDate%>" />
                                                                                                                                        <input type="hidden" name="hdnToDate" id="hdnToDate" value="<%=toDate%>" />
                                                                                                                                        <input type="submit" name="btnView" id="btnView" value="View" class="cits_custom_button_small">                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </form>
                                                                                                                            <%}%>
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
                                                                            <td width="15"></td>
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
                <td height="35" class="cits_footter_center">                  
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_left">
                        <tr>
                            <td height="35">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_right">
                                    <tr>
                                        <td height="35">
                                            <table width="100%" height="35" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="25"></td>
                                                    <td align="center" class="cits_copyRight">&copy; 2015 LankaClear. All rights reserved.| Contact Us: +94 11 2356900 | info@lankaclear.com</td>
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
%>

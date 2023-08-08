<%@taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.logType.LogType" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.User" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.CommonUtils" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.report.Report" errorPage="../../../error.jsp"%>
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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user) || userType.equals(LCPL_Constants.user_type_lcpl_administrator)))
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
    String logType = null;
    String logText = null;
    String fromLogDate = null;
    String toLogDate = null;
    long totalRecordCount = 0;
    int totalPageCount = 0;
    int reqPageNo = 1;

    Collection<Log> colResult = null;
    Collection<LogType> colLogType = null;

    String isSearchReq = null;
    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colLogType = DAOFactory.getLogTypeDAO().getLogTypes();

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        logType = LCPL_Constants.status_all;
        logText = "";
        fromLogDate = webBusinessDate;
        toLogDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        logType = (String) request.getParameter("cmbLogType");
        logText = (String) request.getParameter("txtLogText");
        fromLogDate = (String) request.getParameter("txtFromLogDate");
        toLogDate = (String) request.getParameter("txtToLogDate");
    }
    else if (isSearchReq.equals("1"))
    {

        logType = (String) request.getParameter("cmbLogType");
        logText = (String) request.getParameter("txtLogText");

        //System.out.println("logText ---> " + logText);

        fromLogDate = (String) request.getParameter("txtFromLogDate");
        toLogDate = (String) request.getParameter("txtToLogDate");

        if (request.getParameter("hdnReqPageNo") != null)
        {
            reqPageNo = Integer.parseInt(request.getParameter("hdnReqPageNo"));
        }


        LogType lt = DAOFactory.getLogTypeDAO().getLogType(logType);


        totalRecordCount = DAOFactory.getLogDAO().getRecordCountLogDetails(logType, logText, fromLogDate, toLogDate);

        if (totalRecordCount > 0)
        {
            totalPageCount = (int) Math.ceil((Double.parseDouble(String.valueOf(totalRecordCount))) / LCPL_Constants.noPageRecords);
            colResult = DAOFactory.getLogDAO().getLogDetails(logType, logText, fromLogDate, toLogDate, reqPageNo, LCPL_Constants.noPageRecords);
            request.setAttribute("LogDetails", new ArrayList(colResult));
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_functions_view_log_details, "| Search Criteria - (Log Type  : " + (lt != null ? lt.getDescription() : "All") + ", Log Text : " + (logText != null ? logText : "") + ", Log Date From : " + fromLogDate + ", Log Date To : " + toLogDate + ", Page No. - " + reqPageNo + ") | Record Count - " + colResult.size() + ", Total Record Count - " + totalRecordCount + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_functions_view_log_details, "| Search Criteria - (Log Type  : " + (lt != null ? lt.getDescription() : "All") + ", Log Text : " + (logText != null ? logText : "") + ", Log Date From : " + fromLogDate + ", Log Date To : " + toLogDate + ") | Total Record Count - 0 | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>



<html>
    <head>
        <title>OUSDPS Web - Log Details</title>      
        
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/displaytag.css" rel="stylesheet" type="text/css" />        
        <link href="<%=request.getContextPath()%>/css/tabView.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />

        <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/displaytag.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/tabView.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/tcal.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
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
            var from_elementId = 'txtFromLogDate';
            var to_elementId = 'txtToLogDate';

            document.getElementById(from_elementId).value = "<%=webBusinessDate%>";
            document.getElementById(to_elementId).value = "<%=webBusinessDate%>";
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

            function setReqPageNoForCombo2()
            {
            document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo2').value;
            isSearchRequest(true);
            document.frmViewLogDetails.action="ViewLogDetails.jsp";
            document.frmViewLogDetails.submit();
            }

            function setReqPageNoForCombo()
            {
            document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo').value;
            isSearchRequest(true);
            document.frmViewLogDetails.action="ViewLogDetails.jsp";
            document.frmViewLogDetails.submit();
            }

            function setReqPageNo(no)
            {
            document.getElementById('hdnReqPageNo').value = no;
            isSearchRequest(true);
            document.frmViewLogDetails.action="ViewLogDetails.jsp";
            document.frmViewLogDetails.submit();				
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Log Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text"><form id="frmViewLogDetails" name="frmViewLogDetails" method="post" action="ViewLogDetails.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >
                                                                                                    <tr>
                                                                                                        <td><table border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Log Type :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" ><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbLogType" id="cmbLogType" onChange="clearResultData();" class="cits_field_border" >
                                                                                                                                        <%
                                                                                                                                            if (logType == null || (logType != null && logType.equals(LCPL_Constants.status_all)))
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
                                                                                                                                            if (colLogType != null && colLogType.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (LogType logtype : colLogType)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=logtype.getTypeId()%>" <%=(logType != null && logtype.getTypeId().equals(logType)) ? "selected" : ""%> > <%=logtype.getDescription()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%

                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="cits_error">No log type details available.</span>
                                                                                                                                    <%  }


                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }

                                                                                                                                    %>                                                                                                        </td>

                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Log Date :</td>
                                                                                                                                <td align="left" valign="top" bgcolor="#DFEFDE" ><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromLogDate" id="txtFromLogDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(fromLogDate == null || fromLogDate.equals("0") || fromLogDate.equals(LCPL_Constants.status_all)) ? "" : fromLogDate%>" >                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToLogDate" id="txtToLogDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(toLogDate == null || toLogDate.equals("0") || toLogDate.equals(LCPL_Constants.status_all)) ? "" : toLogDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="Reset Dates" type="button" onClick="resetDates()" class="cits_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                              </table></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"><!--Inward Branch : -->Log Text :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><input name="txtLogText" type="text" id="txtLogText" size="73" maxlength="73" class="cits_field_border" value="<%=logText%>" onFocus="clearResultData();"></td>
                                                                                                                                <td colspan="2" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /><input type="hidden" id="hdnReqPageNo" name="hdnReqPageNo" value="<%=reqPageNo%>" /></td>
                                                                                                                                            <td align="center">                                                                                                                     
                                                                                                                                                <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
            frmViewLogDetails.submit()"  class="cits_custom_button"/></td>
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
                                                                                                    <td>
                                                                                                        <%
                                                                                                            if (isSearchReq != null && isSearchReq.equals("1"))
                                                                                                            {

                                                                                                        %>

                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                            <%



                                                                                                                if (totalRecordCount == 0)
                                                                                                                {

                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                            </tr>

                                                                                                            <%                                                                                               }
                                                                                                            else if (colResult.size() > LCPL_Constants.maxWebRecords)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="cits_error">Sorry! log Details view prevented due to too many records. (Max Viewable Records Count - <%=LCPL_Constants.maxWebRecords%> , Current Records Count - <%=colResult.size()%>,   This can be lead to memory overflow in your machine.)<br/>Please refine your search criteria and Search again.</div></td>
                                                                                                            </tr>


                                                                                                            <%   }
                                                                                                            else
                                                                                                            {

                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="resultdata">
                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td align="right">

                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                                                        <tr bgcolor="#DFE0E1">
                                                                                                                                            <td width="25" align="right" bgcolor="#D8D8D8">&nbsp;</td>
                                                                                                                                            <td align="right" bgcolor="#D8D8D8"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="right" valign="middle" class="cits_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                                        <td width="10"></td>
                                                                                                                                                        <td align="center" valign="middle">
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == 1)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16" /> 													<%                                                                                                                        }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                            %>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                                                        <td width="5"></td>
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
                                                                                                                                                        <td width="5"></td>
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
                                                                                                                                                        <td width="5"></td>
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
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>

                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                            
                                                                                                                            <tr>
                                                                                                    <td align="center">
                                                                                                        <div id="resultdata"> 
                                                                                                            
                                                                                                            <jsp:scriptlet> 
                                                                                                                org.displaytag.decorator.TotalTableDecorator totals = new org.displaytag.decorator.TotalTableDecorator();

                                                                                                                totals.setTotalLabel("Total");
                                                                                                                pageContext.setAttribute("totals", totals);
                                                                                                            </jsp:scriptlet>

                                                                                                            <display:table name="LogDetails" export="true" id="tblLogDetails" class="icps_displaytag" cellspacing="1" cellpadding="3">
                                                                                                                <display:setProperty name="export.pdf.filename" value="USD_Online_System_Log_Details.pdf" />
                                                                                                                <display:setProperty name="export.excel.filename" value="USD_Online_System_Log_Details.xls" />

                                                                                                                <display:column style="text-align:right" media="html"> <%=pageContext.getAttribute("tblLogDetails_rowNum")%>. </display:column>

                                                                                                                <display:column property="logTypeDesc" title="Log Type" media="html" sortable="true" style="text-align:left;min-width:180px" />
                                                                                                                <display:column property="logTypeDesc" title="Log Type" media="excel pdf" sortable="true" headerClass="r2" style="text-align:left;min-width:180px" />

                                                                                                                <display:column property="logValue" title="Detail" media="html" sortable="true" style="text-align:left;min-width:400px" />
                                                                                                                <display:column property="logValue" title="Detail" media="excel pdf" sortable="true" style="text-align:left;min-width:400px" />

                                                                                                                
                                                                                                                <display:column property="logtime" title="Time" media="html" sortable="true" style="text-align:center;min-width:110px" />
                                                                                                                <display:column property="logtime" title="Time" media="excel pdf" sortable="true"  style="text-align:center;min-width:110px" />

                                                                                                                
                                                                                                            </display:table>
                                                                                                                
                                                                                                            <script type="text/javascript">highlightTableRows('tblLogDetails');</script>



                                                                                                        </div></td>
                                                                                                </tr>
                                                                                                                            
                                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="right">

                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                                                        <tr bgcolor="#DFE0E1">
                                                                                                                                            <td width="25" align="right" bgcolor="#D8D8D8">&nbsp;</td>
                                                                                                                                            <td align="right" bgcolor="#D8D8D8"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="right" valign="middle" class="cits_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                                                        <td width="10"></td>
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
                                                                                                                                                        <td width="5"></td>
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
                                                                                                                                                        <td width="5"></td>
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
                                                                                                                                                        <td width="5"></td>
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
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
                                                                                                                                                                if (reqPageNo == totalPageCount)
                                                                                                                                                                {
                                                                                                                                                            %>
                                                                                                                                                            <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                                                            else
                                                                                                                                                            {%>
                                                                                                                                                            <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
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
                                                                                                            %>
                                                                                                        </table>
                                                                                                        <%
                                                                                                            }
                                                                                                        %>

                                                                                                    </td>
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

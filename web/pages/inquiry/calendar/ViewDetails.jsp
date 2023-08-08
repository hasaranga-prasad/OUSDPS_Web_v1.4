<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.calendar.BCMCalendar" errorPage="../../../error.jsp"%>
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

    String isSearchReq = null;
    String year = null;
    String month = null;
    String day = null;
    String type = null;

    Collection<String> colAvailableYears = null;
    Collection<BCMCalendar> colCalendar = null;

    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colAvailableYears = DAOFactory.getBCMCalendarDAO().getAvailableYears();

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        year = "" + customDate.getYear();
        month = LCPL_Constants.status_all;
        day = LCPL_Constants.status_all;
        type = LCPL_Constants.status_all;

    }
    else if (isSearchReq.equals("1"))
    {

        year = (String) request.getParameter("cmbYear");
        month = (String) request.getParameter("cmbMonth");
        day = (String) request.getParameter("cmbDay");
        type = (String) request.getParameter("cmbType");

        //System.out.println("year - " + year + "    month - " + month + "    day - " + day + "    type - " + type);

        colCalendar = DAOFactory.getBCMCalendarDAO().getCalendarDetails(year, month, day, type);;

        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_calendar_maintenance_view_calendar_details, "| Search Criteria - (Year : " + year + " Month : " + month + " Day : " + day + " Type : " + type + ") | Result Count - " + colCalendar.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }



%>
<html>
    <head>
        <title>OUSDPS Web - View Calendar Details</title>
        
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

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnSearchReq').value = "1";
            }
            else 
            {document.getElementById('hdnSearchReq').value = "0";
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
                                                                                        <td align="left" valign="top" class="cits_header_text">View Calendar Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text">
                                                                                            <form id="frmViewCalendar" name="frmViewCalendar" method="post" action="ViewDetails.jsp" >
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" align="center">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top" >

                                                                                                            <table border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" > Year :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text" ><%
                                                                                                                        try
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <select name="cmbYear" id="cmbYear" onChange="isSearchRequest(false);
                    clearResultData()" class="cits_field_border" >

                                                                                                                            <%
                                                                                                                                if (colAvailableYears != null && colAvailableYears.size() > 0)
                                                                                                                                {
                                                                                                                                    for (String avYear : colAvailableYears)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=avYear%>" <%=(year != null && avYear.equals(year)) ? "selected" : ""%> > <%=avYear%></option>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                        <%

                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span class="cits_error">No Years details available.</span>
                                                                                                                        <%  }


                                                                                                                            }
                                                                                                                            catch (Exception e)
                                                                                                                            {
                                                                                                                                System.out.println(e.getMessage());
                                                                                                                            }

                                                                                                                        %>                                                                                            </td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Month  :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text" >
                                                                                                                        <select name="cmbMonth" id="cmbMonth" class="cits_field_border" onChange="clearResultData();">
                                                                                                                            <% %>
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>" <%=(month != null && month.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <option value="1" <%=(month != null && month.equals("1")) ? "selected" : ""%>>01 - January</option>
                                                                                                                            <option value="2" <%=(month != null && month.equals("2")) ? "selected" : ""%>>02 - February</option>
                                                                                                                            <option value="3" <%=(month != null && month.equals("3")) ? "selected" : ""%>>03 - March</option>
                                                                                                                            <option value="4" <%=(month != null && month.equals("4")) ? "selected" : ""%>>04 - April</option>
                                                                                                                            <option value="5" <%=(month != null && month.equals("5")) ? "selected" : ""%>>05 - May</option>
                                                                                                                            <option value="6" <%=(month != null && month.equals("6")) ? "selected" : ""%>>06 - June</option>
                                                                                                                            <option value="7" <%=(month != null && month.equals("7")) ? "selected" : ""%>>07 - July</option>
                                                                                                                            <option value="8" <%=(month != null && month.equals("8")) ? "selected" : ""%>>08 - August</option>
                                                                                                                            <option value="9" <%=(month != null && month.equals("9")) ? "selected" : ""%>>09 - September</option>
                                                                                                                            <option value="10" <%=(month != null && month.equals("10")) ? "selected" : ""%>>10 - October</option>
                                                                                                                            <option value="11" <%=(month != null && month.equals("11")) ? "selected" : ""%>>11 - November</option>
                                                                                                                            <option value="12" <%=(month != null && month.equals("12")) ? "selected" : ""%>>12 - December</option>
                                                                                                                        </select></td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Day :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text" ><select name="cmbDay" id="cmbDay" class="cits_field_border" onChange="clearResultData();">
                                                                                                                            <% %>
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>" <%=(day != null && day.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <%
                                                                                                                                for (int i = 1; i < 32; i++)
                                                                                                                                {
                                                                                                                                    if (i < 10)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=i%>" <%=day.equals("" + i) ? "selected" : ""%>><%="0" + i%></option>
                                                                                                                            <%
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <option value="<%=i%>" <%=day.equals("" + i) ? "selected" : ""%>><%=i%></option>
                                                                                                                            <%
                                                                                                        }
                                                                                                    }%>
                                                                                                                        </select></td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Type :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text" ><select name="cmbType" id="cmbType" class="cits_field_border" onChange="clearResultData();">                                                                                                    
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>" <%=(type != null && month.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <option value="<%=LCPL_Constants.calendar_day_type_fbd%>" <%=(type != null && type.equals(LCPL_Constants.calendar_day_type_fbd)) ? "selected" : ""%>><%=LCPL_Constants.calendar_day_type_fbd%></option>
                                                                                                                            <option value="<%=LCPL_Constants.calendar_day_type_nbd%>" <%=(type != null && type.equals(LCPL_Constants.calendar_day_type_nbd)) ? "selected" : ""%>><%=LCPL_Constants.calendar_day_type_nbd%></option>
                                                                                                                            <option value="<%=LCPL_Constants.calendar_day_type_pbd%>" <%=(type != null && type.equals(LCPL_Constants.calendar_day_type_pbd)) ? "selected" : ""%>><%=LCPL_Constants.calendar_day_type_pbd%></option>
                                                                                                                        </select></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="8" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text" ><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                <td align="center">                                                                                                                     
                                                                                                                                    <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
            frmViewCalendar.submit()"  class="cits_custom_button"/></td>
                                                                                                                            </tr></table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                </table>


                                                                                            </form>
                                                                                        </td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>

                                                                                        <td align="center" valign="top">
                                                                                            <table>
                                                                                                <% if (isSearchReq != null && isSearchReq.equals("1"))
                                                                                                    {

                                                                                                        if (colCalendar.isEmpty())
                                                                                                        {

                                                                                                %>
                                                                                                <tr>
                                                                                                    <td height="15" align="center" class="cits_header_text"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td class="cits_header_text" align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                </tr>
                                                                                                <%                                                                        }
                                                                                                else
                                                                                                {

                                                                                                %>
                                                                                                <tr>
                                                                                                    <td height="15" align="center" class="cits_header_text"></td>
                                                                                                </tr>

                                                                                                <td> 

                                                                                                    <div id="resultdata">
                                                                                                        <table border="0" align="center" cellpadding="5" cellspacing="1" bgcolor="#FFFFFF" class="cits_table_boder">
                                                                                                            <tr bgcolor="#B3D5C0" class="cits_tbl_header_text" align="center">
                                                                                                                <th></th>

                                                                                                                <th>Date</th>
                                                                                                                <th>Day Name</th>
                                                                                                                <th>Type</th>
                                                                                                                <!--th>Category</th-->
                                                                                                                <th>Remarks</th>
                                                                                                                <% 
																												if(!(userType.equals(LCPL_Constants.user_type_settlement_bank_user)|| userType.equals(LCPL_Constants.user_type_bank_user)))
																												{
																												%>
                                                                                                                <th>Last<br/>Modified By</th>
																												
                                                                                                                <th>Last<br/>Modified Date</th>
                                                                                                                <%
																												}
																												%>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                int rowNum = 0;
                                                                                                                for (BCMCalendar cal : colCalendar)
                                                                                                                {
                                                                                                                    rowNum++;

                                                                                                                    //System.out.println("window.getBankcode() ---> " + window.getBankcode());


                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">


                                                                                                                <td align="right" class="cits_common_text" ><%=rowNum%>.</td>

                                                                                                                <td align="center" class="cits_common_text"><%=cal.getCalenderDate()%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=cal.getDay()%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=cal.getDayType()%></td>
                                                                                                                <!--td align="center" class="cits_common_text"><%=cal.getDayCategory()%></td-->
                                                                                                                <td align="center" class="cits_common_text"><%=cal.getRemarks() == null || cal.getRemarks().length() <= 0 ? "N/A" : cal.getRemarks()%></td>
                                                                                                                 <% 
																												if(!(userType.equals(LCPL_Constants.user_type_settlement_bank_user)|| userType.equals(LCPL_Constants.user_type_bank_user)))
																												{
																												%><td align="center" class="cits_common_text"><%=cal.getModifiedby() == null || cal.getModifiedby().length() <= 0 ? "N/A" : cal.getModifiedby()%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=cal.getModifieddate() == null || cal.getModifieddate().length() <= 0 ? "N/A" : cal.getModifieddate()%></td><%}%>
                                                                                                            </tr>
                                                                                                            <% }%>
                                                                                                        </table>
                                                                                                    </div>

                                                                                                </td></tr>
                                                                                                <%
                                                                                                        }

                                                                                                    }
                                                                                                %>


                                                                                </table>


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
%>

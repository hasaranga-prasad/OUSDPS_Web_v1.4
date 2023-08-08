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
<%@page import="lk.com.ttsl.ousdps.dao.reportmap.ReportMap" errorPage="../../../error.jsp"%>
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

    String isSearchReq = null;
    String srcBankCode = null;
    String desBankCode = null;
    String selSession = null;
    String selStatus = null;

    Collection<Bank> colSrcBank = null;
    Collection<Bank> colDesBank = null;
    Collection<ReportMap> colReportMap = null;

    isSearchReq = (String) request.getParameter("hdnReq");

    colSrcBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);
    colDesBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        srcBankCode = LCPL_Constants.status_all;
        desBankCode = LCPL_Constants.status_all;
        selSession = LCPL_Constants.status_all;
        selStatus = LCPL_Constants.status_all;

    }
    else if (isSearchReq.equals("1"))
    {

        srcBankCode = (String) request.getParameter("cmbSrcBank");
        desBankCode = (String) request.getParameter("cmbDesBank");
        selSession = (String) request.getParameter("cmbSession");
        selStatus = (String) request.getParameter("cmbStatus");
        
        String selStatusDesc = null;
        
        if(selStatus!=null)
        {
            if(selStatus.equals(LCPL_Constants.status_all))
            {
                selStatusDesc = "All";
            }
            else if(selStatus.equals(LCPL_Constants.status_active))
            {
                selStatusDesc = "Active";
            }
            else if(selStatus.equals(LCPL_Constants.status_deactive))
            {
                selStatusDesc = "Inactive";
            }
            else
            {
                selStatusDesc = "n/a";
            }            
        }
        else
        {
            selStatusDesc = "n/a";
        }

        colReportMap = DAOFactory.getReportMapDAO().getReportMapDetails(srcBankCode, desBankCode, selSession, selStatus);
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_reportmap_maintenance_modify_reportmap_details_search, "| Search Criteria - (Source Bank  : " + srcBankCode + ", Destination Bank : " + desBankCode + ", Session : " + selSession + ", Status : " + selStatusDesc + ") | Result Count - " + colReportMap.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }



%>
<html>
    <head>
        <title>OUSDPS Web - View Report Map Details</title>
        <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="../../../js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../js/tableenhance.js"></script>
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
            document.getElementById('hdnReq').value = "1";
            }
            else document.getElementById('hdnReq').value = "0";
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
                                                                                        <td height="75"><table width="980" border="0" cellspacing="0" cellpadding="0">
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
                                                                                                    <td align="right" valign="bottom"><table height="22" border="0" cellspacing="0" cellpadding="0">
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Modify (Status Activate/Deactivate) Report Mapping Data</td>
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
                                                                                            <form id="frmModifyRMP_Search" name="frmModifyRMP_Search" method="post" action="ModifyReportMappingDetailsSearch.jsp" >
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" align="center">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top" >

                                                                                                            <table border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Source Bank :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text" ><%
                                                                                                                        try
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <select name="cmbSrcBank" id="cmbSrcBank" onChange="isSearchRequest(false);
                    clearResultData();" class="cits_field_border" <%=userType.equals("3") ? "disabled" : ""%>>
                                                                                                                            <%
                                                                                                                                if (srcBankCode == null || (srcBankCode != null && srcBankCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                                if (colSrcBank != null && colSrcBank.size() > 0)
                                                                                                                                {
                                                                                                                                    for (Bank bank : colSrcBank)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=bank.getBankCode()%>" <%=(srcBankCode != null && bank.getBankCode().equals(srcBankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                        <%

                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span class="cits_error">No bank details available.</span>
                                                                                                                        <%  }


                                                                                                                            }
                                                                                                                            catch (Exception e)
                                                                                                                            {
                                                                                                                                System.out.println(e.getMessage());
                                                                                                                            }

                                                                                                                        %>                                                                                            </td>
                                                                                                                    <td  align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Session  :</td>
                                                                                                                    <td align="left" valign="top" bgcolor="#DFEFDE" class="cits_tbl_header_text" >
                                                                                                                        <select name="cmbSession" id="cmbSession" class="cits_field_border" onChange="clearResultData();">
                                                                                                                            
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>" <%=(selSession==null||selSession.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <option value="<%=LCPL_Constants.window_session_one%>" <%=(selSession != null && selSession.equals(LCPL_Constants.window_session_one)) ? "selected" : ""%>><%=LCPL_Constants.window_session_one%></option>
                                                                                                                            <option value="<%=LCPL_Constants.window_session_two%>" <%=(selSession != null && selSession.equals(LCPL_Constants.window_session_two)) ? "selected" : ""%>><%=LCPL_Constants.window_session_two%></option>
                                                                                                                        </select></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Destination Bank :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text" ><%
                                                                                                                        try
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <select name="cmbDesBank" id="cmbDesBank" onChange="isSearchRequest(false);
            clearResultData();" class="cits_field_border" <%=userType.equals("3") ? "disabled" : ""%>>
                                                                                                                            <%
                                                                                                                                if (desBankCode == null || (desBankCode != null && desBankCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                                if (colDesBank != null && colDesBank.size() > 0)
                                                                                                                                {
                                                                                                                                    for (Bank bank : colDesBank)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=bank.getBankCode()%>" <%=(desBankCode != null && bank.getBankCode().equals(desBankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                        <%

                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span class="cits_error">No bank details available.</span>
                                                                                                                        <%  }


                                                                                                                            }
                                                                                                                            catch (Exception e)
                                                                                                                            {
                                                                                                                                System.out.println(e.getMessage());
                                                                                                                            }

                                                                                                                        %></td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Staus :</td>
                                                                                                                    <td align="right" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><select name="cmbStatus" id="cmbStatus" class="cits_field_border" onChange="clearResultData();">
                                                                                                                            
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>" <%=(selStatus != null && selStatus.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                            <option value="<%=LCPL_Constants.status_active%>" <%=(selStatus != null && selStatus.equals(LCPL_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                            <option value="<%=LCPL_Constants.status_deactive%>" <%=(selStatus != null && selStatus.equals(LCPL_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                        </select></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="4" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text" ><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                <td align="center">                                                                                                                     
                                                                                                                                    <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
            frmModifyRMP_Search.submit()"  class="cits_custom_button"/></td>
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

                                                                                                        if (colReportMap.isEmpty())
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

                                                                                                                <th>Source<br>Bank</th>
                                                                                                                <th>Source<br>File</th>
                                                                                                                <th>Destination<br>Bank</th>
                                                                                                                <th>Destination<br>File</th>
                                                                                                                <th>Sesion</th>
                                                                                                                <th>Status</th>
                                                                                                                <th>Modified<br>By</th>
                                                                                                                <th>Modified<br>Time</th>
                                                                                                                <th>&nbsp;</th>
                                                                                                            </tr>


                                                                                                            <%
                                                                                                                int rowNum = 0;
                                                                                                                for (ReportMap rmap : colReportMap)
                                                                                                                {
                                                                                                                    rowNum++;

                                                                                                                    //System.out.println("window.getBankcode() ---> " + window.getBankcode());


                                                                                                            %>
                                                                                                            
                                                                                                            <form action="ModifyReportMappingDetails.jsp" method="post" name="frmModifyRMP" id="frmModifyRMP">
                                                                                                            
                                                                                                            
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">


                                                                                                                <td align="right" class="cits_common_text" ><%=rowNum%>.</td>

                                                                                                                <td align="center" class="cits_common_text"><span class="cits_common_text" title="<%=rmap.getSrcBankFullName()%>"><%=rmap.getSrcBankCode()%> - <%=rmap.getSrcBankShortName()%></span><input type="hidden" name="hdnSrcBank" id="hdnSrcBank" value="<%=rmap.getSrcBankCode()%>"></td>
                                                                                                                <td class="cits_common_text"><%=rmap.getSrcFileName() %><input type="hidden" name="hdnSrcFileName"  id="hdnSrcFileName" value="<%=rmap.getSrcFileName()%>"></td>
                                                                                                              <td align="center" class="cits_common_text"><span class="cits_common_text" title="<%=rmap.getDesBankFullName()%>"><%=rmap.getDesBankCode()%> - <%=rmap.getDesBankShortName()%></span><input type="hidden" name="hdnDesBank" id="hdnDesBank" value="<%=rmap.getDesBankCode()%>"></td>
                                                                                                                <td class="cits_common_text"><%=rmap.getDesFileName() %><input type="hidden" name="hdnDesFileName" id="hdnDesFileName" value="<%=rmap.getDesFileName()%>"></td>
                                                                                                              <td align="center" class="cits_common_text"><%=rmap.getSession()%><input type="hidden" name="hdnSelSession" id="hdnSelSession" value="<%=rmap.getSession()%>"></td>
                                                                                                                <td align="center" class="cits_common_text"><%=rmap.getStatus()!=null?rmap.getStatus().equals(LCPL_Constants.status_active)?"Active":"Inactive":"-" %><input type="hidden" name="hdnCurrentStatus" id="hdnCurrentStatus" value="<%=rmap.getStatus()%>"></td>
                                                                                                                <td align="center" class="cits_common_text"><%=rmap.getModifiedBy()!=null?rmap.getModifiedBy():"-" %></td>
                                                                                                                <td align="center" class="cits_common_text"><%=rmap.getModifiedTime()!=null?rmap.getModifiedTime():"-" %></td>
                                                                                                                <td align="center" class="cits_common_text">
<input type="submit" value="Modify" class="cits_custom_button_small"><input type="hidden" name="hdnCmbSrcBank" id="hdnCmbSrcBank" value="<%=srcBankCode%>"><input type="hidden" name="hdnCmbDesBank" id="hdnCmbDesBank" value="<%=desBankCode%>"><input type="hidden" name="hdnCmbSession" id="hdnCmbSession" value="<%=selSession%>"><input type="hidden" name="hdnCmbStatus" id="hdnCmbStatus" value="<%=selStatus%>"></td>
                                                                                                            </tr>
                                                                                                            </form>
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                            
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
    }
%>

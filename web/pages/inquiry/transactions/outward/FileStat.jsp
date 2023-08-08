<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.batch.CustomBatch" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../../../error.jsp"%>
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

%>
<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(sessionBankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
%>


<%
    String bankCode = null;
    String branchCode = null;
    String winSess = null;
    String fromBusinessDate = null;
    String toBusinessDate = null;
    String isSearchReq = null;

    Collection<CustomBatch> colResult = null;
    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;

    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user))
        {
            bankCode = sessionBankCode;
            //System.out.println(" bankCode --> " + bankCode);
            colBranch = DAOFactory.getBranchDAO().getBranch(bankCode);
            branchCode = LCPL_Constants.status_all;
        }
        else
        {
            bankCode = LCPL_Constants.status_all;
            branchCode = LCPL_Constants.status_all;
        }

        winSess = LCPL_Constants.status_all;
        fromBusinessDate = webBusinessDate;
        toBusinessDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = (String) request.getParameter("cmbBank");
        }

        if (bankCode.equals(LCPL_Constants.status_all))
        {
            branchCode = LCPL_Constants.status_all;
        }
        else
        {
            colBranch = DAOFactory.getBranchDAO().getBranch(bankCode);
            branchCode = (String) request.getParameter("cmbBranch");
        }

        winSess = (String) request.getParameter("cmbSession");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");
    }
    else if (isSearchReq.equals("1"))
    {
        if (userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = (String) request.getParameter("cmbBank");
        }

        if (bankCode.equals(LCPL_Constants.status_all))
        {
            branchCode = LCPL_Constants.status_all;
        }
        else
        {
            colBranch = DAOFactory.getBranchDAO().getBranch(bankCode);
            branchCode = (String) request.getParameter("cmbBranch");
        }

        winSess = (String) request.getParameter("cmbSession");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");

        colResult = DAOFactory.getCustomBatchDAO().getBatchDetails(bankCode, branchCode, winSess, fromBusinessDate, toBusinessDate);
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_ows_batch_status, "| Search Criteria - (OW Bank : " + bankCode + ", OW Branch : " + branchCode + ", Bus.Date From : " + fromBusinessDate + ", Bus.Date To : " + toBusinessDate + ", Session : " + winSess + ") | Result Count - " + colResult.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }
%>
<html>
    <head>
        <title>OUSDPS Web - View File Details</title>

        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../../../../css/tcal.css" rel="stylesheet" type="text/css" />
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
            var from_elementId = 'txtFromBusinessDate';
            var to_elementId = 'txtToBusinessDate';

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
                                                                <td align="center" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="center" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">File Status</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text"><form id="frmViewFileStat" name="frmViewFileStat" method="post" action="FileStat.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >
                                                                                                    <tr>
                                                                                                        <td><table border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Outward  Bank :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" ><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBank" id="cmbBank" onChange="isSearchRequest(false);
                                                                                                                                                    frmViewFileStat.submit()" class="cits_field_border" <%=(userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user)) ? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (bankCode == null || (bankCode != null && bankCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                                            if (colBank != null && colBank.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Bank bank : colBank)
                                                                                                                                                {
                                                                                                                                                    if (userType.equals(LCPL_Constants.user_type_bank_user) && (bank != null && bank.getBankCode().equals(LCPL_Constants.LCPL_bank_code)))
                                                                                                                                                    {
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(bankCode != null && bank.getBankCode().equals(bankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                                        <%
                                                                                                                                                }
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

                                                                                                                                    %>                                                                                                        </td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business Date :</td>
                                                                                                                                <td align="left" valign="top" bgcolor="#DFEFDE" ><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromBusinessDate" id="txtFromBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(fromBusinessDate == null || fromBusinessDate.equals("0") || fromBusinessDate.equals(LCPL_Constants.status_all)) ? "" : fromBusinessDate%>" >                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToBusinessDate" id="txtToBusinessDate" type="text" onFocus="this.blur()" class="tcal" size="11" value="<%=(toBusinessDate == null || toBusinessDate.equals("0") || toBusinessDate.equals(LCPL_Constants.status_all)) ? "" : toBusinessDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="Reset Dates" type="button" onClick="resetDates()" class="cits_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Outward Branch :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE">



                                                                                                                                    <%

                                                                                                                                        try
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBranch" id="cmbBranch" class="cits_field_border" onChange="clearResultData()" >
                                                                                                                                        <%
                                                                                                                                            if (branchCode == null || (branchCode != null && branchCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                                            if (colBranch != null && colBranch.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Branch branch : colBranch)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=branch.getBranchCode()%>" <%=(branchCode != null && branch.getBranchCode().equals(branchCode)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="cits_error">No branch details available.</span>
                                                                                                                                    <%}
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %>                                                                                                        </td>



                                                                                                                                <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text">Session : </td>
                                                                                                                                <td align="left" bgcolor="#DFEFDE" class="cits_tbl_header_text"><select name="cmbSession" id="cmbSession" class="cits_field_border" onChange="clearResultData();">
                                                                                                                                        <% %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" <%=(winSess != null && winSess.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <option value="<%=LCPL_Constants.window_session_one%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_one)) ? "selected" : ""%>><%=LCPL_Constants.window_session_one%></option>
                                                                                                                                        <option value="<%=LCPL_Constants.window_session_two%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_two)) ? "selected" : ""%>><%=LCPL_Constants.window_session_two%></option>
                                                                                                                                    </select></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="4" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center">                                                                                                                     
                                                                                                                                                <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    frmViewFileStat.submit()"  class="cits_custom_button"/></td>
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
                                                                                                                if (isSearchReq.equals("1") && colResult.size() == 0)
                                                                                                                {%>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%   }
                                                                                                            else if (isSearchReq.equals("1") && colResult.size() > 0)
                                                                                                            {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="10" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">
                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                            <tr>
                                                                                                                                <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business<br/>
                                                                                                                                    Date</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Session</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Outward<br/>Bank</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Outward<br/>Branch</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">File ID</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Item Count<br/>(Credit)</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Amount<br/>(Credit)</td>
                                                                                                                                    <%
                                                                                                                                        if (userType.equals("0") || userType.equals("3"))
                                                                                                                                        {
                                                                                                                                    %>

                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td><%}%>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                int rowNum = 0;
                                                                                                                                int itemCountCredit = 0;
                                                                                                                                int itemCountDebit = 0;

                                                                                                                                long totalAmountCredit = 0;
                                                                                                                                long totalAmountDebit = 0;

                                                                                                                                for (CustomBatch batch : colResult)
                                                                                                                                {
                                                                                                                                    rowNum++;

                                                                                                                                    itemCountCredit += batch.getItemCountCredit();
                                                                                                                                    totalAmountCredit += batch.getAmountCredit();
                                                                                                                            %>
                                                                                                                            <form action="OWDetails.jsp" id="frmOWDetails<%=rowNum%>" name="frmOWDetails<%=rowNum%>" method="post" target="_self">
                                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                    <td align="right" class="cits_common_text" ><%=rowNum%>.</td>
                                                                                                                                    <td align="center"  class="cits_common_text"><%=batch.getBusinessDate()%></td>
                                                                                                                                    <td align="center"  class="cits_common_text"><%=batch.getSession()%></td>
                                                                                                                                    <td  class="cits_common_text"><span class="cits_common_text" title="<%=batch.getOwBankFullName()%>"><%=batch.getOwBank() + " - " + batch.getOwBankShortName()%></span></td>
                                                                                                                                    <td  class="cits_common_text"><%=batch.getOwBranch() + " - " + batch.getOwBranchName()%></td>
                                                                                                                                    <td align="center"  class="cits_common_text"><%=batch.getFileId()%></td>
                                                                                                                                    <td align="right"  class="cits_common_text"><%=batch.getItemCountCredit()%></td>
                                                                                                                                    <td align="right"  class="cits_common_text"><%=batch.getFormattedAmountCredit()%></td>
                                                                                                                                    <%
                                                                                                                                        if (userType.equals("0") || userType.equals("3"))
                                                                                                                                        {
                                                                                                                                    %>

                                                                                                                                    <td align="center"  class="cits_common_text">

                                                                                                                                        <input type="hidden" id="hdnFileID" name="hdnFileID" value="<%=batch.getFileId()%>" />
                                                                                                                                        <input type="hidden" id="hdnBank" name="hdnBank" value="<%=bankCode%>" />
                                                                                                                                        <input type="hidden" id="hdnSession" name="hdnSession" value="<%=winSess%>" />
                                                                                                                                        <input type="hidden" id="hdnFromBD" name="hdnFromBD" value="<%=fromBusinessDate%>" />                                                                                                              
                                                                                                                                        <input type="hidden" id="hdnBranch" name="hdnBranch" value="<%=branchCode%>" />
                                                                                                                                        <input type="hidden" id="hdnToBD" name="hdnToBD" value="<%=toBusinessDate%>" />
                                                                                                                                        <input type="submit" name="btnView" id="btnView" value="View" class="cits_custom_button_small" >                                                                                                                                                                                        </td><%}%>
                                                                                                                                </tr>
                                                                                                                            </form>
                                                                                                                            <%
                                                                                                                                }

                                                                                                                            %>
                                                                                                                            <tr  class="cits_common_text">
                                                                                                                                <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">Total</td>
                                                                                                                                <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=itemCountCredit%></td>
                                                                                                                                <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%= new DecimalFormat("#0.00").format((new Long(totalAmountCredit).doubleValue()) / 100)%></td>
                                                                                                                                <%
                                                                                                                                    if (userType.equals("0") || userType.equals("3"))
                                                                                                                                    {
                                                                                                                                %>
                                                                                                                                <td bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                <%}%>
                                                                                                                            </tr>
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

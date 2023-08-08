
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.adhoccharges.AdhocCharges" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.billingadhoccharges.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp" %>
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

        if (userType.equals(LCPL_Constants.user_type_bank_user))
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
    String bankCode = null;
    String branchCode = null;
    String adhocChargeCode = null;
    String status = null;
    String fromBillingDate = null;
    String toBillingDate = null;
    String isSearchReq = null;

    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;
    Collection<AdhocCharges> colAC = null;
    Collection<BillingAdhocCharges> colResult = null;

    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);
    colAC = DAOFactory.getAdhocChargesDAO().getAdhocChargesTypeDetails(LCPL_Constants.status_all);

    if (isSearchReq == null)
    {
        isSearchReq = "0";
        bankCode = LCPL_Constants.status_all;
        branchCode = LCPL_Constants.status_all;
        adhocChargeCode = LCPL_Constants.status_all;
        status = LCPL_Constants.status_all;
        fromBillingDate = webBusinessDate;
        toBillingDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        bankCode = request.getParameter("cmbBank");
        branchCode = request.getParameter("cmbBranch");
        adhocChargeCode = request.getParameter("cmbActCode");
        status = (String) request.getParameter("cmbStatus");
        fromBillingDate = (String) request.getParameter("txtFromBillingDate");
        toBillingDate = (String) request.getParameter("txtToBillingDate");

        if (bankCode != null && (!bankCode.equals(LCPL_Constants.status_all)))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(bankCode, LCPL_Constants.status_pending);
        }
    }
    else if (isSearchReq.equals("1"))
    {
        bankCode = request.getParameter("cmbBank");
        branchCode = request.getParameter("cmbBranch");
        adhocChargeCode = request.getParameter("cmbActCode");
        status = (String) request.getParameter("cmbStatus");
        fromBillingDate = (String) request.getParameter("txtFromBillingDate");
        toBillingDate = (String) request.getParameter("txtToBillingDate");

        if (bankCode != null && (!bankCode.equals(LCPL_Constants.status_all)))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(bankCode, LCPL_Constants.status_pending);
        }

        colResult = DAOFactory.getBillingAdhocChargesDAO().getBillingAdhocChargeDetails(bankCode, branchCode, adhocChargeCode, status, fromBillingDate, toBillingDate);

        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_billing_adhoccharges_view_bill, "| Search Criteria - (Bank : " + bankCode + ", Branch : " + branchCode + ", Charge Type : " + adhocChargeCode + ", Billing Date (From : " + fromBillingDate + ", To : " + toBillingDate + "), Status : " + (status != null ? status.equals(LCPL_Constants.status_all) ? "All" : status.equals(LCPL_Constants.status_active) ? "Active" : "Canceled" : "N/A") + ") | Result Count - " + colResult.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
        //System.out.println("colResult.size()   ---> " + colResult.size());

    }
%>


<html>
    <head><title>OUSDPS Web - View Adhoc-Charge Bill Detail(s)</title>
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


            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error')!= null)
            {
            document.getElementById('displayMsg_error').style.display='none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }


            if(document.getElementById('displayMsg_success')!=null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }                
            }


            function resetDates()
            {
            var from_elementId = 'txtFromBillingDate';
            var to_elementId = 'txtToBillingDate';

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
                                                                <td align="center" valign="middle"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">View Adhoc-Charge Bill Detail(s)</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text"><form id="frmViewACB_Details" name="frmViewACB_Details" method="post" action="ViewBills.jsp">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >
                                                                                                    <tr>
                                                                                                        <td><table border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Bank  :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" >                                                                                                        


                                                                                                                                    <%
                                                                                                                                        try
                                                                                                                                        {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBank" id="cmbBank" onChange="isSearchRequest(false);
                                                                                                                                                    frmViewACB_Details.submit()" class="cits_field_border" >
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
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(bankCode != null && bank.getBankCode().equals(bankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
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

                                                                                                                                    %>                                                                                                                                    </td>

                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Charge Type :</td>
                                                                                                                                <td align="left" valign="top" bgcolor="#DFEFDE" ><select name="cmbActCode" id="cmbActCode" class="cits_field_border" onChange="clearResultData();">

                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" <%=(adhocChargeCode == null || adhocChargeCode.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>

                                                                                                                                        <%
                                                                                                                                            if (colAC != null && !colAC.isEmpty())
                                                                                                                                            {

                                                                                                                                                for (AdhocCharges ac : colAC)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=ac.getAdhocChargeCode()%>" <%=(adhocChargeCode != null && ac.getAdhocChargeCode().equals(adhocChargeCode)) ? "selected" : ""%>><%=ac.getAdhocChargeCode()%> - <%=ac.getAdhocChargeDesc()%> </option>

                                                                                                                                        <% }%>
                                                                                                                                    </select>                                  
                                                                                                                                    <% }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                                    <span class="cits_error">No Adhoc Charges Type details available.</span>
                                                                                                                                    <%}%></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Branch : </td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" ><%                                                                                                                                  try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBranch" id="cmbBranch" class="cits_field_border" onChange="clearResultData();">
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
                                                                                                                                    %></td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"> Billing Date :</td>
                                                                                                                                <td align="left" valign="top" bgcolor="#DFEFDE" ><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="middle"><input name="txtFromBillingDate" id="txtFromBillingDate" type="text" onFocus="this.blur();
                                                                                                                                                    clearResultData()" class="tcal" size="11" value="<%=(fromBillingDate == null || fromBillingDate.equals("0") || fromBillingDate.equals(LCPL_Constants.status_all)) ? "" : fromBillingDate%>" title="From">                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="txtToBillingDate" id="txtToBillingDate" type="text" onFocus="this.blur();
                                                                                                                                                    clearResultData()" class="tcal" size="11" value="<%=(toBillingDate == null || toBillingDate.equals("0") || toBillingDate.equals(LCPL_Constants.status_all)) ? "" : toBillingDate%>" onChange="clearResultData()" title="To">                                                                                                                    </td>
                                                                                                                                            <td width="5" valign="middle"></td>
                                                                                                                                            <td width="10px" valign="middle"></td>
                                                                                                                                            <td valign="middle"><input name="btnClear" id="btnClear" value="Reset Dates" type="button" onClick="resetDates()" class="cits_custom_button_small" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"><!--Inward Branch : --> Status :                                                                                                                                </td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><select name="cmbStatus" id="cmbStatus"  class="cits_field_border" onChange="clearResultData()">
                                                                                                                                        <%
                                                                                                                                            if (status == null || status.equals(LCPL_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%              }
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_active%>" <%=(status != null && status.equals(LCPL_Constants.status_active)) ? "selected" : ""%> >Active</option>

                                                                                                                                        <option value="<%=LCPL_Constants.status_cancled%>" <%=(status != null && status.equals(LCPL_Constants.status_cancled)) ? "selected" : ""%> >Canceled</option>

                                                                                                                                    </select></td>
                                                                                                                                <td colspan="2" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center">                                                                                                                     
                                                                                                                                                <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);
                                                                                                                                                    frmViewACB_Details.submit()"  class="cits_custom_button"/></td>
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
                                                                                                            <%                                                                                                                if (colResult == null || colResult.size() <= 0)
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
                                                                                                                                <td align="center"><table  border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                                        <tr>
                                                                                                                                            <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Billing<br>ID</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Billing<br>Date</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Branch</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Adhoc Charge<br>Type</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Quantity</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Total</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Remarks</td>

                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Cancel<br>Reason</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Modified<br>By</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Modified<br>Time</td>
                                                                                                                                        </tr>
                                                                                                                                        <%                                                                                                                                            int rowNum = 0;

                                                                                                                                            for (BillingAdhocCharges bac : colResult)
                                                                                                                                            {
                                                                                                                                                rowNum++;

                                                                                                                                        %>

                                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                            <td align="right" class="cits_common_text" ><%=rowNum%>.</td>
                                                                                                                                            <td align="right"  class="cits_common_text"><%=bac.getBillingId()%></td>
                                                                                                                                            <td  class="cits_common_text"><%=bac.getBillingDate()%></td>
                                                                                                                                            <td  class="cits_common_text"><span class="cits_common_text" title="<%=bac.getBankFullName()%>"><%=bac.getBankCode() + " - " + bac.getBankShortName()%></span></td>
                                                                                                                                            <td  class="cits_common_text"><%=bac.getBranchCode() + " - " + bac.getBranchName()%></td>
                                                                                                                                            <td  class="cits_common_text"><%=bac.getAdhocChargeCode() + " - " + bac.getAdhocChargeDesc()%></td>
                                                                                                                                            <td align="right"  class="cits_common_text"><%=bac.getlQuantity()%></td>
                                                                                                                                            <td align="right"  class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(bac.getlTotal()).doubleValue()) / 100)%></td>
                                                                                                                                            <td  class="cits_common_text"><%=(bac.getStatus() != null ? bac.getStatus().equals(LCPL_Constants.status_all) ? "All" : bac.getStatus().equals(LCPL_Constants.status_active) ? "Active" : "Canceled" : "N/A")%></td>
                                                                                                                                            <td  class="cits_common_text"><%=bac.getRemarks() != null ? bac.getRemarks() : ""%></td>                                                                                                                                                                                                       
                                                                                                                                            <td  class="cits_common_text"><%=bac.getReasonForCancel() != null ? bac.getReasonForCancel() : "N/A"%></td>
                                                                                                                                            <td align="center" nowrap  class="cits_common_text"><%=bac.getModifiedBy() != null ? bac.getModifiedBy() : "N/A"%></td>
                                                                                                                                            <td align="center" nowrap  class="cits_common_text"><%=bac.getModifiedDate() != null ? bac.getModifiedDate() : "N/A"%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <tr  class="cits_common_text">
                                                                                                                                            <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
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
<%        }
    }

%>
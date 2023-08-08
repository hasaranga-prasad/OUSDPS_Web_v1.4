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
<%@page import="lk.com.ttsl.ousdps.dao.custom.owdetails.OWDetails" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.transactiontype.TransactionType" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.returnreason.ReturnReason" errorPage="../../../../error.jsp"%>
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
		
		if (userType.equals("2"))
        {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
        }
		
    

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
    String bankCode = null;
    String branchCode = null;
    String desBankCode = null;
    String desBranchCode = null;
    String transCode = null;
    String returnCode = null;
    String winSess = null;
    String fromBusinessDate = null;
    String toBusinessDate = null;

    Collection<OWDetails> colResult = null;
    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;
    Collection<Bank> colDesBank = null;
    Collection<Branch> colDesBranch = null;
    Collection<TransactionType> colTransType = null;
    Collection<ReturnReason> colReturnReason = null;

    String isSearchReq = null;
    isSearchReq = (String) request.getParameter("hdnSearchReq");

    colBank = DAOFactory.getBankDAO().getBank(LCPL_Constants.status_all);
    colDesBank = DAOFactory.getBankDAO().getBank(LCPL_Constants.status_all);
    colTransType = DAOFactory.getTransactionTypeDAO().getTransTypeDetails();
    colReturnReason = DAOFactory.getReturnReasonDAO().getReTurnTypes();

    if (isSearchReq == null)
    {
        isSearchReq = "0";

        if (userType.equals("3"))
        {
            bankCode = sessionBankCode;
            colBranch = DAOFactory.getBranchDAO().getBranch(bankCode);
            branchCode = LCPL_Constants.status_all;
        }
        else
        {
            bankCode = LCPL_Constants.status_all;
            branchCode = LCPL_Constants.status_all;
        }

        desBankCode = LCPL_Constants.status_all;
        desBranchCode = LCPL_Constants.status_all;
        transCode = LCPL_Constants.status_all;
        returnCode = LCPL_Constants.status_all;
        winSess = LCPL_Constants.status_all;
        fromBusinessDate = webBusinessDate;
        toBusinessDate = webBusinessDate;
    }
    else if (isSearchReq.equals("0"))
    {
        if (userType.equals("3"))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = (String) request.getParameter("cmbBankOri");
        }

        if (bankCode.equals(LCPL_Constants.status_all))
        {
            branchCode = LCPL_Constants.status_all;
        }
        else
        {
            colBranch = DAOFactory.getBranchDAO().getBranch(bankCode);
            branchCode = (String) request.getParameter("cmbBranchOW");
        }

        desBankCode = (String) request.getParameter("cmbBankDes");

        if (desBankCode.equals(LCPL_Constants.status_all))
        {
            desBranchCode = LCPL_Constants.status_all;
        }
        else
        {
            colDesBranch = DAOFactory.getBranchDAO().getBranch(desBankCode);
            desBranchCode = (String) request.getParameter("cmbBranchDes");
        }

        transCode = (String) request.getParameter("cmbTransType");
        returnCode = (String) request.getParameter("cmbReturnReason");
        winSess = (String) request.getParameter("cmbSession");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");
    }
    else if (isSearchReq.equals("1"))
    {
        if (userType.equals("3"))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = (String) request.getParameter("cmbBankOri");
        }

        if (bankCode.equals(LCPL_Constants.status_all))
        {
            branchCode = LCPL_Constants.status_all;
        }
        else
        {
            colBranch = DAOFactory.getBranchDAO().getBranch(bankCode);
            branchCode = (String) request.getParameter("cmbBranchOW");
        }

        desBankCode = (String) request.getParameter("cmbBankDes");

        if (desBankCode.equals(LCPL_Constants.status_all))
        {
            desBranchCode = LCPL_Constants.status_all;
        }
        else
        {
            colDesBranch = DAOFactory.getBranchDAO().getBranch(desBankCode);
            desBranchCode = (String) request.getParameter("cmbBranchDes");
        }

        transCode = (String) request.getParameter("cmbTransType");
        returnCode = (String) request.getParameter("cmbReturnReason");
        winSess = (String) request.getParameter("cmbSession");
        fromBusinessDate = (String) request.getParameter("txtFromBusinessDate");
        toBusinessDate = (String) request.getParameter("txtToBusinessDate");

        colResult = DAOFactory.getOWDetailsDAO().getOWDetails(LCPL_Constants.status_all, LCPL_Constants.status_all, desBankCode, desBranchCode, bankCode, branchCode, transCode, returnCode, winSess, fromBusinessDate, toBusinessDate);

    }
%>
<html>
    <head>
        <title>OUSDPS Web - View Batch Details</title>
        <link href="../../../../css/cits.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="../../../../js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../../js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../../js/tableenhance.js"></script>
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
        <table width="1024" height="650" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" class="cits_bgRepeat"><table width="1024" border="0" cellpadding="0" cellspacing="0" >
                        <tr>
                            <td height="102" class="cits_header"><table height="102" width="1024" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="75">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="22"><table width="1024" height="22" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="15">&nbsp;</td>
                                                    <td><div style="padding:1;height:100%;width:100%;">
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
                                                                <td class="cits_menubar_text"><b><%=userName%></b> - <%=sessionBankName%> </td>
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
                                            </table></td>
                                    </tr>
                                    <tr>
                                        <td height="5"></td>
                                    </tr>
                                </table></td>
                        </tr>
                        <tr>
                            <td  height="509" align="center" valign="top" class="cits_bgCommon"><table width="1024" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="24" align="center" valign="top"><table width="1024" height="24" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="15"></td>
                                                    <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td valign="middle" class="cits_menubar_text">Business Date : <%=webBusinessDate%></td>
                                                                <td width="5" valign="middle"></td>
                                                                <td valign="middle" class="cits_menubar_text">Session : <%=winSession%></td>
                                                                <td width="5" valign="middle"></td>
                                                                <td valign="middle"><div id="actSession" align="center" ><img src="../../../../images/animGreen.gif" name="imgOK" id="imgOK" width="12" height="12" title="Session is active!" ></div>
                                                                    <div id="expSession" align="center" ><img src="../../../../images/animRed.gif" name="imgError" id="imgError" width="12" height="12" title="Session is expired!" ></div></td>
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
                                        <td height="16" align="center" valign="top"><table width="1024" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="15"></td>
                                                    <td align="center" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td width="10"></td>
                                                                <td align="left" valign="top" class="cits_header_text">Outward Details (Transaction Inquiry)</td>
                                                              <td width="10"></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="15"></td>
                                                                <td></td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="10"></td>
                                                                <td align="center" valign="top" class="cits_header_text"><form id="frmOWDetails" name="frmOWDetails" method="post" action="SearchOWDetails.jsp">
                                                                        <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >
                                                                            <tr>
                                                                                <td><table border="0" cellspacing="0" cellpadding="0" align="center">
                                                                                        <tr>
                                                                                            <td align="center" valign="top" ><table border="0" cellspacing="1" cellpadding="3" >
                                                                      <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Originate  Bank :</td>
                                                                                                      <td align="left" valign="middle" bgcolor="#DFEFDE" ><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBankOri" id="cmbBankOri" onChange="isSearchRequest(false);frmOWDetails.submit()" class="cits_field_border" <%=userType.equals("3") ? "disabled" : ""%>>
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

                                                                                                            %>                                                                                                        </td>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Originate Branch : </td>
                                                                                        <td align="left" valign="top" bgcolor="#DFEFDE" ><%

                                                                                                            
																											try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBranchOW" id="cmbBranchOW" class="cits_field_border" onChange="clearResultData()" >
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
                                                                                                            %>                                                                                                        
                                                                                                            
                                                                                                            </td>
                                                                                                    </tr>

                                                                                                    <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Destination Bank :</td>
                                                                                                      <td align="left" valign="middle" bgcolor="#DFEFDE"><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBankDes" id="cmbBankDes" onChange="isSearchRequest(false);frmOWDetails.submit()" class="cits_field_border" >
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

                                                                                                            %>                                                                                                        </td>



                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Destination Branch :</td>
                                                                                                      <td align="left" bgcolor="#DFEFDE"><%

                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbBranchDes" id="cmbBranchDes" class="cits_field_border" onChange="clearResultData()">
                                                                                                                <%
                                                                                                                    if (desBranchCode == null || (desBranchCode != null && desBranchCode.equals(LCPL_Constants.status_all)))
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
                                                                                                                    if (colDesBranch != null && colDesBranch.size() > 0)
                                                                                                                    {
                                                                                                                        for (Branch branch : colDesBranch)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=branch.getBranchCode()%>" <%=(desBranchCode != null && branch.getBranchCode().equals(desBranchCode)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
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
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Transaction Type :</td>
                                                                                                      <td align="left" valign="middle" bgcolor="#DFEFDE"><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbTransType" id="cmbTransType" onChange="clearResultData()" class="cits_field_border" >
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
                                                                                                                    if (colTransType != null && colTransType.size() > 0)
                                                                                                                    {
                                                                                                                        for (TransactionType tType : colTransType)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=tType.getTc()%>" <%=(transCode != null && tType.getTc().equals(transCode)) ? "selected" : ""%> ><%=tType.getType() != null ? (tType.getType().equals(LCPL_Constants.transaction_type_credit) ? "Credit" : "Debit") : "N/A"%> - <%=tType.getTc()%> - <%=tType.getDesc()%></option>
                                                                                                                <%
                                                                                                                    }
                                                                                                                %>
                                                                                                            </select>
                                                                                            <%

                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <span class="cits_error">No transaction types available.</span>
                                                                                                            <%  }


                                                                                                                }
                                                                                                                catch (Exception e)
                                                                                                                {
                                                                                                                    System.out.println(e.getMessage());
                                                                                                                }

                                                                                                            %>                                                                                                        </td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Return Reason :</td>
                                                                                                      <td align="left" bgcolor="#DFEFDE"><%
                                                                                                            try
                                                                                                            {
                                                                                                            %>
                                                                                                            <select name="cmbReturnReason" id="cmbReturnReason" onChange="clearResultData()" class="cits_field_border" >
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
                                                                                                                    if (colReturnReason != null && colReturnReason.size() > 0)
                                                                                                                    {
                                                                                                                        for (ReturnReason rtnReason : colReturnReason)
                                                                                                                        {
                                                                                                                %>
                                                                                                                <option value="<%=rtnReason.getReturnCode()%>" <%=(returnCode != null && rtnReason.getReturnCode().equals(returnCode)) ? "selected" : ""%> ><%=rtnReason.getReturnCode()%> - <%=rtnReason.getPrintAS()%></option>
                                                                                                                <%
                                                                                                                    }
                                                                                                                %>
                                                                                                            </select>
                                                                                                <%

                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                            %>
                                                                                                            <span class="cits_error">No return reasons available.</span>
                                                                                                            <%  }


                                                                                                                }
                                                                                                                catch (Exception e)
                                                                                                                {
                                                                                                                    System.out.println(e.getMessage());
                                                                                                                }

                                                                                                            %>                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business Date :</td>
                                                                                              <td align="left" valign="middle" bgcolor="#DFEFDE"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td valign="middle"><input name="txtFromBusinessDate" id="txtFromBusinessDate" type="text"
                                                                                                                                               class="cits_field_border" size="8" onFocus="this.blur()" value="<%=(fromBusinessDate == null || fromBusinessDate.equals("0") || fromBusinessDate.equals(LCPL_Constants.status_all)) ? "" : fromBusinessDate%>" >                                                                                                                    </td>
                                                                                                                    <td width="5" valign="middle"></td>
                                                                                                                    <td valign="middle"><a href="javascript:cal_from.popup();clearResultData();"><img
                                                                                                                                src="../../../../images/cal.gif" border="0"
                                                                                                                                title=" From " height="24"
                                                                                                                                width="22"></a></td>
                                                                                                                    <td width="10" valign="middle"></td>
                                                                                                                    <td valign="middle"><input name="txtToBusinessDate" id="txtToBusinessDate" type="text"
                                                                                                                                               class="cits_field_border" size="8" onFocus="this.blur()" value="<%=(toBusinessDate == null || toBusinessDate.equals("0") || toBusinessDate.equals(LCPL_Constants.status_all)) ? "" : toBusinessDate%>" onChange="clearResultData()">                                                                                                                    </td>
                                                                                                                    <td width="5" valign="middle"></td>
                                                                                                                    <td valign="middle"><a href="javascript:cal_to.popup();clearResultData();"><img
                                                                                                                                src="../../../../images/cal.gif" border="0"
                                                                                                                                title=" To " height="24"
                                                                                                                                width="22"></a></td>
                                                                                                                    <td width="10px" valign="middle"></td>
                                                                                                                    <td valign="middle"><input name="btnClear" id="btnClear" value="Reset Dates" type="button" onClick="resetDates()" class="cits_custom_button_small" /></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                        <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Session : </td>
                                                                                              <td align="left" bgcolor="#DFEFDE"><select name="cmbSession" id="cmbSession" class="cits_field_border" onChange="clearResultData();">

                                                                                                                <option value="<%=LCPL_Constants.status_all%>" <%=(winSess != null && winSess.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                <option value="<%=LCPL_Constants.window_session_one%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_one)) ? "selected" : ""%>><%=LCPL_Constants.window_session_one%></option>
                                                                                                                <option value="<%=LCPL_Constants.window_session_two%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_two)) ? "selected" : ""%>><%=LCPL_Constants.window_session_two%></option>
                                                                                                            </select></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="4" align="right" bgcolor="#CDCDCD" class="cits_tbl_header_text"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                    <td align="center">                                                                                                                     
                                                                                                                        <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                    <td width="5"></td>
                                                                                                                    <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);frmOWDetails.submit()"  class="cits_custom_button"/></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table></td>
                                                                                    </table></td>
                                                                            </tr>
                                                                        </table>
                                                                    </form>
                                                                    <script language="javascript" type="text/JavaScript">
                                                                        <!--
                                                                        // create calendar object(s) just after form tag closed
                                                                        // specify form element as the only parameter (document.forms['formname'].elements['inputname']);
                                                                        // note: you can have as many calendar objects as you need for your application


                                                                        var cal_from = new calendar1(document.forms['frmOWDetails'].elements['txtFromBusinessDate']);
                                                                        cal_from.year_scroll = true;
                                                                        cal_from.time_comp = false;


                                                                        var cal_to = new calendar1(document.forms['frmOWDetails'].elements['txtToBusinessDate']);
                                                                        cal_to.year_scroll = true;
                                                                        cal_to.time_comp = false;


                                                                        //-->
                                                                    </script>
                                                                </td>
                                                                <td width="10"></td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td align="center" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td><table border="0" cellpadding="0" cellspacing="0">
                                                                                    <%
                                                                                        if (isSearchReq != null && isSearchReq.equals("1"))
                                                                                        {

                                                                                            if (colResult == null || colResult.isEmpty())
                                                                                            {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="5" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                    </tr>
                                                                                     <%   }
                                                                                    else if (colResult.size() > 5000)
                                                                                    {
                                                                                    %>
<tr>
                                                                                        <td height="5" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="noresultbanner" class="cits_error">Sorry! Details view prevented due to too many records. (Records Count - <%=colResult.size()%>, This can be lead to memory overflow in your machine.) Please refine your search criteria and Search again.</div></td>
                                                                                    </tr>
                                                                                    
                                                                                    
                                                                                    <%   }
                                                                                    else
                                                                                    {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="10" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td><div id="resultdata">
                                                                                                <table  border="0" cellspacing="1" cellpadding="2" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                    <tr>
                                                                                                        <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business<br/>
                                                                                                            Date</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Ses.</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">File ID</td>
                                                                                                        <!--td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Out.<br/>Bk-Br</td-->
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Org.<br/>
                                                                                                            Bk-Br</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Org.<br/>
                                                                                                            Acc. No.</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Org.<br/>
                                                                                                            Acc. Name</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Des.<br/>Bk-Br</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Des.<br/>Acc. No.</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Des.<br/>Acc. Name</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >TC</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >RC</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Value<br/>Date</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Is<br/>Return</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Cur.<br/>
                                                                                                            Code</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Amount</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Part.</td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        int rowNum = 0;
                                                                                                        //int itemCountCredit = 0;
                                                                                                        //int itemCountDebit = 0;

                                                                                                        long totalAmount = 0;
                                                                                                        //long totalAmountDebit = 0;

                                                                                                        for (OWDetails owdetails : colResult)
                                                                                                        {
                                                                                                            rowNum++;

                                                                                                            //itemCountCredit += owdetails.getItemCountCredit();
                                                                                                            //itemCountDebit += owdetails.getItemCountDebit();
                                                                                                            totalAmount += owdetails.getAmount();
                                                                                                            //totalAmountCredit += owdetails.getAmountCredit();
%>
                                                                                                                                                                                                        <!--form action="" id="frmRemarks_<%=rowNum%>" name="frmRemarks_<%=rowNum%>" method="post" target="_self"-->
                                                                                                    <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                        <td align="right" class="cits_common_text" ><%=rowNum%>.</td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getBusinessDate()%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getSession()%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getFileId()%></td>
                                                                                                        <!--td align="center"  class="cits_common_text"><%=owdetails.getOwBank()%>-<%=owdetails.getOwBranch()%></td-->
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getOrgBankCode()%>-<%=owdetails.getOrgBranchCode()%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getOrgAcNoDec() %></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getOrgAcNameDec() %></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getDesBankCode()%>-<%=owdetails.getDesBranchcode()%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getDesAcNoDec() %></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getDesAcNameDec() %></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getTc()%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getRc()%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getValueDate() %></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getIsReturn()  %></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getCurrencyCode()%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(owdetails.getAmount()).doubleValue()) / 100)%></td>
                                                                                                        <td align="center"  class="cits_common_text"><%=owdetails.getParticulars()%></td>
                                                                                                    </tr>
                                                                                                    <!--/form-->
                                                                                                    <%
                                                                                                        }

                                                                                                    %>
                                                                                                    <tr  class="cits_common_text">
                                                                                                        <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                        <!--td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td-->
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">Total</td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=new DecimalFormat("#0.00").format((new Long(totalAmount).doubleValue()) / 100)%></td>
                                                                                                        <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </div></td>
                                                                                    </tr>
                                                                                    <%
                                                                                            }
                                                                                        }

                                                                                    %>
                                                                                    <tr><td height="10"></td>
                                                                                    </tr>


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
                                </table></td>
                        </tr>
                        <tr>
                            <td height="39" class="cits_footter"><table width="1024" height="39" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="25"></td>
                                        <td align="left" class="cits_copyRight">2011 &copy; Lanka Clear. All rights reserved.</td>
                                        <td align="right" class="cits_copyRight">Developed By - Pronto Lanka (Pvt) Ltd.</td>
                                        <td width="25"></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table></td>
            </tr>
        </table>
    </body>
</html>
<%
    }
%>

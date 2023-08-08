<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.certificates.Certificate" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
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

        //if (!(userType.equals("0") || userType.equals("1") || userType.equals("2")))
        //{
        //    session.invalidate();
        //    response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
        //}


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
    String status = null;
    String isSearchReq = null;

    Hashtable<String, Collection<Certificate>> htResult = null;
    Collection<Bank> colBank = null;

    colBank = DAOFactory.getBankDAO().getBank(LCPL_Constants.status_all);
    isSearchReq = (String) request.getParameter("hdnSearchReq");


    if (isSearchReq == null)
    {
        isSearchReq = "0";
        
        if (userType.equals(LCPL_Constants.user_type_bank_user) || userType.equals(LCPL_Constants.user_type_settlement_bank_user))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = LCPL_Constants.status_all;
        }

        status = LCPL_Constants.status_all;
    }
    else if (isSearchReq.equals("1"))
    {
        if (userType.equals(LCPL_Constants.user_type_bank_user) || userType.equals(LCPL_Constants.user_type_settlement_bank_user))
        {
            bankCode = sessionBankCode;
        }
        else
        {
            bankCode = (String) request.getParameter("cmbBank");
        }

        status = (String) request.getParameter("cmbStatus");

        if (status != null)
        {
            if (status.equals("1"))
            {
                htResult = DAOFactory.getCertificateDAO().analyze(bankCode, LCPL_Constants.status_yes);
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_view_certificate_details, "| Search Criteria - (Bank - " + bankCode + ", Status - Valid) | Result Count - " + htResult.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
            }
            else if (status.equals("2"))
            {
                htResult = DAOFactory.getCertificateDAO().analyze(bankCode, LCPL_Constants.status_yes);
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_view_certificate_details, "| Search Criteria - (Bank - " + bankCode + ", Status - Valid Expire Soon) | Result Count - " + htResult.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
            }
            else if (status.equals("3"))
            {
                htResult = DAOFactory.getCertificateDAO().analyze(bankCode, LCPL_Constants.status_no);
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_view_certificate_details, "| Search Criteria - (Bank - " + bankCode + ", Status - Invalid) | Result Count - " + htResult.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
            }
            else
            {
                htResult = DAOFactory.getCertificateDAO().analyze(bankCode, LCPL_Constants.status_all);
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_view_certificate_details, "| Search Criteria - (Bank - " + bankCode + ", Status - All) | Result Count - " + htResult.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
            }
        }
    }




%>
<html>
    <head><title>OUSDPS Web - View Certificate Details</title>
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
                                                                            <td align="left" valign="top" >
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text"> Certificate Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="100"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text">
                                                                                            <form name="frmViewBranch" id="frmViewBranch" method="post" action="ViewDetails.jsp">

                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" align="center" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Bank :</td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE">
                                                                                                                                    <select name="cmbBank" id="cmbBank" class="cits_field_border" onChange="clearResultData();" <%=(userType.equals(LCPL_Constants.user_type_settlement_bank_user) || userType.equals(LCPL_Constants.user_type_bank_user))? "disabled" : ""%>>
                                                                                                                                        <%
                                                                                                                                            if (bankCode == null || bankCode.equals(LCPL_Constants.status_all))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                                        <%
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>">-- All --</option>
                                                                                                                                        <%}
                                                                                                                                            if (colBank != null && colBank.size() > 0)
                                                                                                                                            {

                                                                                                                                                for (Bank b : colBank)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=b.getBankCode()%>" <%=(bankCode != null && b.getBankCode().equals(bankCode)) ? "selected" : ""%>><%= b.getBankCode() + " - " + b.getBankFullName()%></option>

                                                                                                                                        <% }%>
                                                                                                                                    </select>
                                                                                                                                    <% }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                                    <span class="cits_error">No bank details available.</span>
                                                                                                                                    <%}%>        </td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Status : </td>
                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE">
                                                                                                                                    <select name="cmbStatus" id="cmbStatus" class="cits_field_border" onChange="clearResultData()">
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>" <%=(status == null || status.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                                                        <option value="1" <%=status != null && status.equals("1") ? "selected" : ""%>>Valid</option>
                                                                                                                                        <option value="2" <%=status != null && status.equals("2") ? "selected" : ""%>>Valid - Expire Soon</option>                                                                                                                                        <option value="3" <%=status != null && status.equals("3") ? "selected" : ""%>>Invalid</option>
                                                                                                                                    </select></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td colspan="4" align="right" bgcolor="#CDCDCD"><table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                                                            <td align="center">                                                                                                                     
                                                                                                                                                <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td align="right"><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);frmViewBranch.submit()"  class="cits_custom_button"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                                </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td align="center">
                                                                                                        <%
                                                                                                            if (isSearchReq.equals("1"))
                                                                                                            {

                                                                                                        %>
                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                            <%
                                                                                                                if (htResult.isEmpty())
                                                                                                                {

                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td height="15" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                            </tr>
                                                                                                            <%                                                                                                            }
                                                                                                            else if (htResult.size() > 0)
                                                                                                            {
                                                                                                                int rowNum = 0;
                                                                                                                boolean isVESCertAvailable = false;

                                                                                                                List<String> liKeys = new ArrayList<String>(htResult.keySet());
                                                                                                                Collections.sort(liKeys);

                                                                                                                java.util.Date certExpDate = null;
                                                                                                                java.util.Date curDate = null;

                                                                                                                long curTime = 0;
                                                                                                                long expTime = 0;
                                                                                                                long addTime = 0;
                                                                                                                long seconds = 0;
                                                                                                                long minutes = 0;
                                                                                                                long hours = 0;
                                                                                                                long days = 0;

                                                                                                                curDate = new java.util.Date();

                                                                                                                curTime = curDate.getTime();

                                                                                                                //System.out.print("curTime 1 : " + curTime);

                                                                                                                seconds = 1000;
                                                                                                                minutes = seconds * 60;
                                                                                                                hours = minutes * 60;
                                                                                                                days = hours * 24;

                                                                                                                addTime = days * 30;

                                                                                                                //System.out.print("addTime 1 : " + addTime);

                                                                                                                curTime = curTime + addTime;

                                                                                                                //System.out.print("curTime 2 : " + curTime);


                                                                                                                if (status.equals("2"))
                                                                                                                {
                                                                                                                    for (String keyBankCode : liKeys)
                                                                                                                    {
                                                                                                                        Collection<Certificate> colCert = htResult.get(keyBankCode);

                                                                                                                        if (colCert != null && !colCert.isEmpty())
                                                                                                                        {
                                                                                                                            for (Certificate cert : colCert)
                                                                                                                            {
                                                                                                                                if (!cert.isIsExpired() && cert.isIsValid())
                                                                                                                                {
                                                                                                                                    certExpDate = new java.util.Date();

                                                                                                                                    certExpDate.setTime(DateFormatter.getTime(cert.getValidTo(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));

                                                                                                                                    expTime = certExpDate.getTime();

                                                                                                                                    if (expTime < curTime)
                                                                                                                                    {
                                                                                                                                        isVESCertAvailable = true;
                                                                                                                                        break;
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                }

                                                                                                                if (status.equals("2") && !isVESCertAvailable)
                                                                                                                {
																												%>
                                                                                                                
                                                                                                                 <tr>
                                                                                                                <td height="15" align="center" class="cits_header_text"></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                            </tr>
																												
                                                                                                                <%
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td><div id="resultdata">

                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td height="10" align="right" class="cits_header_text"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                                                        <tr bgcolor="#DFE0E1">
                                                                                                                                            <td align="right" bgcolor="#F3F3F3"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="cits_common_text_bold">Legend :</td>
                                                                                                                                                        <td width="10"></td>
                                                                                                                                                        <td><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgValidCert" id="imgValidCert" width="12" height="12" title="Valid Certificate." ></td>
                                                                                                                                                                    <td width="5"></td>
                                                                                                                                                                    <td class="cits_success">Valid</td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table></td>
                                                                                                                                                        <td width="10"></td>
                                                                                                                                                        <td><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><img src="<%=request.getContextPath()%>/images/animOrange.gif" name="imgValidCert" id="imgValidCert2" width="12" height="12" title="Valid Certificate - Will be expire soon! (Within one month of time)" ></td>
                                                                                                                                                                    <td width="5"></td>
                                                                                                                                                                    <td class="cits_success_orange">Valid - Expire Soon</td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table></td>
                                                                                                                                                        <td width="10"></td>
                                                                                                                                                        <td><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><img src="<%=request.getContextPath()%>/images/animRed.gif" alt="" name="imgValidCert" width="12" height="12" id="imgValidCert3" title="Invalid Certificate!" ></td>
                                                                                                                                                                    <td width="5"></td>
                                                                                                                                                                    <td class="cits_error">Invalid</td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table></td>
                                                                                                                                                        <td width="20">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10" align="center" class="cits_header_text"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td><table  border="0" cellspacing="1" cellpadding="4" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                                        <tr>
                                                                                                                                            <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Cer.<br>Name</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Cer.<br>ID</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Ver.</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">SN</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Email</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Issuer</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Is<br>Valid</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Valid<br>From</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Valid<br>To</td>
                                                                                                                                        </tr>
                                                                                                                                        <%


                                                                                                                                            for (String keyBankCode : liKeys)
                                                                                                                                            {
                                                                                                                                                Collection<Certificate> colCert = htResult.get(keyBankCode);

                                                                                                                                                if (colCert != null && !colCert.isEmpty())
                                                                                                                                                {

                                                                                                                                                    for (Certificate cert : colCert)
                                                                                                                                                    {

                                                                                                                                                        String cssClass = null;
                                                                                                                                                        boolean showVES_data = false;

                                                                                                                                                        if (!cert.isIsExpired() && cert.isIsValid())
                                                                                                                                                        {
                                                                                                                                                            certExpDate = new java.util.Date();

                                                                                                                                                            certExpDate.setTime(DateFormatter.getTime(cert.getValidTo(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));

                                                                                                                                                            expTime = certExpDate.getTime();

                                                                                                                                                            if (expTime > curTime)
                                                                                                                                                            {
                                                                                                                                                                cssClass = "cits_success";
                                                                                                                                                            }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                                cssClass = "cits_success_orange";

                                                                                                                                                                if (status.equals("2"))
                                                                                                                                                                {
                                                                                                                                                                    showVES_data = true;
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            cssClass = "cits_error";
                                                                                                                                                        }

                                                                                                                                                        if (status.equals("2"))
                                                                                                                                                        {
                                                                                                                                                            if (showVES_data)
                                                                                                                                                            {
                                                                                                                                                                rowNum++;
                                                                                                                                        %>

                                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                            <td align="right" class="<%=cssClass%>" ><%=rowNum%>.</td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><span class="<%=cssClass%>" title="<%=cert.getBankName()%>"><%=cert.getBankCode()%></span></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getName()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getId()!=null?cert.getId():"N/A"  %></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=cert.getVersion()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getSerialNumber()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getEmail()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getIssuer()%></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=(!cert.isIsExpired() && cert.isIsValid()) == true ? "Yes" : "No"%></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=cert.getValidFrom()%></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=cert.getValidTo()%></td>
                                                                                                                                        </tr>


                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            rowNum++;

                                                                                                                                        %>

                                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                                            <td align="right" class="<%=cssClass%>" ><%=rowNum%>.</td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><span class="<%=cssClass%>" title="<%=cert.getBankName()%>"><%=cert.getBankCode()%></span></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getName()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getId()!=null?cert.getId():"N/A"  %></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=cert.getVersion()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getSerialNumber()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getEmail()%></td>
                                                                                                                                            <td align="left"  class="<%=cssClass%>"><%=cert.getIssuer()%></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=(!cert.isIsExpired() && cert.isIsValid()) == true ? "Yes" : "No"%></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=cert.getValidFrom()%></td>
                                                                                                                                            <td align="center"  class="<%=cssClass%>"><%=cert.getValidTo()%></td>
                                                                                                                                        </tr>

                                                                                                                                        <%

                                                                                                                                                        }
                                                                                                                                                    }

                                                                                                                                                }
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                        <tr  class="cits_common_text">
                                                                                                                                            <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                                            <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
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
%>
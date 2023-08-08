
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.WindowDAO" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
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
        sessionBankName = (String) session.getAttribute("session_bankName");
        sessionBankCode = (String) session.getAttribute("session_bankCode");
        branchId = (String) session.getAttribute("session_branchId");
        branchName = (String) session.getAttribute("session_branchName");
        menuId = (String) session.getAttribute("session_menuId");
        menuName = (String) session.getAttribute("session_menuName");

        /*
         * if (!userType.equals("0")) { session.invalidate();
         * response.sendRedirect(request.getContextPath() +
         * "/pages/accessDenied.jsp"); }
         */
    
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
    String bankCode = null;
    String wSession = null;

    Collection<Bank> colBank = null;
    Collection<Window> colWindow = null;

    isSearchReq = (String) request.getParameter("hdnSearchReq");
    colBank = DAOFactory.getBankDAO().getBank(LCPL_Constants.status_all);

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

        wSession = (String) request.getParameter("cmbSession");

        colWindow = DAOFactory.getWindowDAO().getWindowDetails(bankCode, wSession);
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_view_bank_window, "| Search Criteria - (Bank  : " + bankCode + ", Session : " + winSession + ") | Result Count - " + colWindow.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }



%>
<html>
    <head>
        <title>OUSDPS Web - View Window Status</title>
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
                    document.getElementById('hdnSearchReq').value = "1";
                }
                else document.getElementById('hdnSearchReq').value = "0";
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
                                                                <td align="left" valign="top" class="cits_header_text">View Window Details</td>
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
                                                                    <form id="frmViewWindow" name="frmViewWindow" method="post" action="ViewDetails.jsp" >
                                                                        <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" align="center">
                                                                            <tr>
                                                                                <td align="center" valign="top" >

                                                                                    <table border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                  <tr>
                                                                                            <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" > Bank :</td>
                                                                                            <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text" ><%
                                                                                                try
                                                                                                {
                                                                                                %>
                                                                                                <select name="cmbBank" id="cmbBank" onChange="isSearchRequest(false);frmViewWindow.submit()" class="cits_field_border" <%=(userType.equals(LCPL_Constants.user_type_bank_user) || userType.equals(LCPL_Constants.user_type_settlement_bank_user))?"disabled" : ""%>>
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

                                                                                                %>
                                                                                            </td>
                                                                                            <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Session  :</td>
                                                                                            <td align="left" valign="top" bgcolor="#DFEFDE" class="cits_tbl_header_text" >
                                                                                                <select name="cmbSession" id="cmbSession" class="cits_field_border" onChange="clearResultData();">
                                                                                                    <% %>
                                                                                                    <option value="<%=LCPL_Constants.status_all%>" <%=(wSession != null && wSession.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>-- All --</option>
                                                                                                    <option value="<%=LCPL_Constants.window_session_one%>" <%=(wSession != null && wSession.equals(LCPL_Constants.window_session_one)) ? "selected" : ""%>><%=LCPL_Constants.window_session_one%></option>
                                                                                                    <option value="<%=LCPL_Constants.window_session_two%>" <%=(wSession != null && wSession.equals(LCPL_Constants.window_session_two)) ? "selected" : ""%>><%=LCPL_Constants.window_session_two%></option>
                                                                                                </select></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="4" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text" ><table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="<%=isSearchReq%>" /></td>
                                                                                                        <td align="center">                                                                                                                     
                                                                                                            <div id="clickSearch" class="cits_common_text" style="display:<%=(isSearchReq != null && isSearchReq.equals("1")) ? "none" : "block"%>">Click Search to get results.</div>                                                                                                                    </td>
                                                                                                        <td width="5"></td>
                                                                                                        <td><input name="btnSearch" id="btnSearch" value="Search" type="button" onClick="isSearchRequest(true);frmViewWindow.submit()"  class="cits_custom_button"/></td>
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

                                                                                if (colWindow.isEmpty())
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
                                                                                        <th rowspan="2"></th>

                                                                                        <th rowspan="2">Bank</th>
                                                                                        <th rowspan="2">Sesion</th>
                                                                                        <th colspan="2">Current Time</th>
                                                                                        <th colspan="2">Default Time</th>
                                                                                    </tr>

                                                                                    <tr>
                                                                                        <th align="center" bgcolor="#B0B1BD" valign="middle" class="cits_tbl_header_text">From</th>
                                                                                        <th align="center" bgcolor="#B0B1BD" valign="middle" class="cits_tbl_header_text">To</th>
                                                                                        <th align="center" bgcolor="#B0B1BD" valign="middle" class="cits_tbl_header_text">From</th>
                                                                                        <th align="center" bgcolor="#B0B1BD" valign="middle" class="cits_tbl_header_text">To</th>
                                                                                    </tr>
                                                                                    <%
                                                                                        int rowNum = 0;
                                                                                        for (Window win : colWindow)
                                                                                        {
                                                                                            rowNum++;

                                                                                            //System.out.println("window.getBankcode() ---> " + window.getBankcode());


                                                                                    %>
                                                                                    <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">


                                                                                        <td align="right" class="cits_common_text" ><%=rowNum%>.</td>

                                                                                        <td align="center" class="cits_common_text"><span class="cits_common_text" title="<%=win.getBankFullName()%>"><%=win.getBankcode()%> - <%=win.getBankShortName()%></span></td>
                                                                                        <td align="center" class="cits_common_text"><%=win.getSession()%></td>
                                                                                        <td align="center" class="cits_common_text"><%=win.getCutontime() == null || win.getCutontime().length() <= 0 ? "Not Available" : win.getCutontime()%></td>
                                                                                        <td align="center" class="cits_common_text"><%=win.getCutofftime() == null || win.getCutofftime().length() <= 0 ? "Not Available" : win.getCutofftime()%></td>
                                                                                        <td align="center" class="cits_common_text"><%=win.getDefaultcutontime() == null || win.getDefaultcutontime().length() <= 0 ? "Not Available" : win.getDefaultcutontime()%></td>
                                                                                        <td align="center" class="cits_common_text"><%=win.getDefaultcutofftime() == null || win.getDefaultcutofftime().length() <= 0 ? "Not Available" : win.getDefaultcutofftime()%></td>
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

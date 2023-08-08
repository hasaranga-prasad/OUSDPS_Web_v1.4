
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.adhoccharges.*" errorPage="../../../error.jsp" %>
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

<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(sessionBankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
%>

<%
    String acStatus = (String) request.getParameter("rbStatus");

    Collection<AdhocCharges> col_ac = null;

    if (acStatus != null)
    {
        col_ac = DAOFactory.getAdhocChargesDAO().getAdhocChargesTypeDetails(acStatus);
        String acStatusDesc = acStatus.equals(LCPL_Constants.status_active) ? "Active" : acStatus.equals(LCPL_Constants.status_deactive) ? "Inactive" : acStatus.equals(LCPL_Constants.status_all) ? "All" : "N/A";
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_adhoccharge_maintenance_view_adhoccharge_type, "| Search Criteria - (Status : " + acStatusDesc + ") | Result Count - " + col_ac.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }
    else
    {
        col_ac = DAOFactory.getAdhocChargesDAO().getAdhocChargesTypeDetails(LCPL_Constants.status_all);
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_adhoccharge_maintenance_view_adhoccharge_type, "| Search Criteria - (Status : All) | Result Count - " + col_ac.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }
%>


<html>
    <head><title>OUSDPS Web - View Adhoc Charges Type(s)</title>
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
                                                                                        <td align="left" valign="top" class="cits_header_text">View Adhoc Charges Type(s)</td>
                                                                                      <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">


                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td height="15" align="center" valign="middle"><table border="0" cellspacing="0" cellpadding="0" align="center">
                                                                                                            <tr>
                                                                                                                <td align="center" valign="middle">





                                                                                                                    <form name="frmAdhocChargesType" method="post" action="ViewChargesType.jsp">


                                                                                                                        <table  border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF" align="center">
                                                                                                                            <tr>
                                                                                                                                <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;&nbsp; Status</td>
                                                                      <td width="" align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text_bold"><table  border="0" cellpadding="0" cellspacing="0" >
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=LCPL_Constants.status_all%>" id="rbAll" onClick="frmAdhocChargesType.submit()" <%=(acStatus == null || (acStatus != null && acStatus.equals(LCPL_Constants.status_all))) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="cits_common_text_bold">All</td>
                                                                                                                                            <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=LCPL_Constants.status_active%>" id="rbActive" onClick="frmAdhocChargesType.submit()" <%=(acStatus != null && acStatus.equals(LCPL_Constants.status_active)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="cits_common_text_bold">Active</td>
                                                                                                                                            <td width="15"></td>
                                                                                                                                            <td><input type="radio" name="rbStatus" value="<%=LCPL_Constants.status_deactive%>" id="rbDeactive" onClick="frmAdhocChargesType.submit()" <%=(acStatus != null && acStatus.equals(LCPL_Constants.status_deactive)) ? "checked" : ""%>></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td class="cits_common_text_bold">Inactive</td><td width="10"></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                              </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </form>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <tr><td height="15"></td>
                                                                                                </tr>

                                                                                                <%
                                                                                                    int col_size = col_ac.size();

                                                                                                    if (col_size == 0)
                                                                                                    {
                                                                                                %>
                                                                                                <tr><td colspan="4" align="center" class="cits_tbl_header_text">No records Available !</td></tr>
                                                                                                <%}
                                                                                                else
                                                                                                {%>


                                                                                                <tr>
                                                                                                    <td align="center" valign="middle">
                                                                                                        <table border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                            <tr>
                                                                                                                <td bgcolor="#B3D5C0" class="csks_top_link_nav"></td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Adhoc Charges<br>Code</td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Adhoc Charges<br>Description</td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Amount</td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status</td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created<br>By</td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created<br>Date</td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Modified<br>By</td>
                                                                                                                <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Modified<br>Date</td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                int rowNum = 0;
                                                                                                                for (AdhocCharges b : col_ac)
                                                                                                                {
                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>" onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                <td align="right" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                                <td align="center" class="cits_common_text"><%=b.getAdhocChargeCode() != null ? b.getAdhocChargeCode() : "N/A"%></td>
                                                                                                                <td align="left" class="cits_common_text"><%=b.getAdhocChargeDesc() != null ? b.getAdhocChargeDesc() : "N/A"%></td>
                                                                                                                <td align="right" class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(b.getlAmount()).doubleValue()) / 100)%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=b.getStatus() != null ? b.getStatus().equals(LCPL_Constants.status_active) ? "Active" : b.getStatus().equals(LCPL_Constants.status_pending) ? "Pending" : "Inactive" : "N/A"%></td>
                                                                                                                <td class="cits_common_text"><%=b.getCreatedBy()!=null?b.getCreatedBy():"N/A" %></td>
                                                                                                                <td align="center" class="cits_common_text"><%=b.getCreatedDate()!=null?b.getCreatedDate():"N/A" %></td>
                                                                                                                <td class="cits_common_text"><%=b.getModifiedBy()!=null?b.getModifiedBy():"N/A" %></td>
                                                                                                              <td align="center" class="cits_common_text"><%=b.getModifiedDate()!=null?b.getModifiedDate():"N/A" %></td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }


                                                                                                            %>
                                                                                                  </table>                                                                            </td>
                                                                                                </tr>

                                                                                                <%                                                                            }

                                                                                                %>


                                                                                            </table>                                                        </td>
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
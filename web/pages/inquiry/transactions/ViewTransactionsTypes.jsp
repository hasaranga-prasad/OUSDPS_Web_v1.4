<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.transactiontype.*" errorPage="../../../error.jsp"%>
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
    Collection<TransactionType> col = DAOFactory.getTransactionTypeDAO().getTransTypeDetails();
    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_view_transaction_types, "| Search Criteria - (All) | Result Count - " + col.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
%>


<html>
    <head><title>OUSDPS Web - View Transaction Types</title>
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
                                                                <td align="left" valign="top" class="cits_header_text"> Transaction Types</td>
                                                                <td width="10">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20"></td>
                                                                <td align="left" valign="top" ></td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td align="center" valign="top">









                                                                    <table border="0" cellspacing="0" cellpadding="0" >

                                                                        <%

                                                                            if (col != null && col.size() == 0)
                                                                            {

                                                                        %>

                                                                        <tr>
                                                                            <td align="center" class="cits_header_small_text">No Records Available!</td>
                                                                        </tr>

                                                                        <%  }
                                                                        else if (col.size() > 0)
                                                                        {
                                                                            int rowNum = 0;

                                                                        %>


                                                                        <tr><td>





                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder"><tr><td>

                                                                                            <table border="0" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
                                                                                  <tr>
                                                                                                    <td bgcolor="#B3D5C0" class="cits_tbl_header_text"></td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">TC</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Description</td>
                                                                                                    <!--td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Type</td-->
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Min<br/>Amount<br/>(Rs.)</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Max<br/>
                                                                                                        Amount<br/>(Rs.)</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Min<br/>
                                                                                                        Value<br/>Date</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Max<br/>
                                                                                                        Value<br/>Date</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Min<br/>
                                                                                                        Return<br/>Date</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Max<br/>Return<br/>Date</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Validation<br/>One</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Validation<br/>
                                                                                                        Two</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Validation<br/>Three</td>
                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status</td>
                                                                                  </tr>


                                                                                                <% for (TransactionType transType : col)
                                                                                                    {
                                                                                                        rowNum++;
                                                                                                %>
                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                    <td align="right" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                    <td align="left" class="cits_common_text"><%=transType.getTc()%></td>
                                                                                                    <td align="left" class="cits_common_text"><%=transType.getDesc()%></td>
                                                                                                    <!--td align="left" class="cits_common_text"><span title="<%=transType.getType().equals(LCPL_Constants.transaction_type_credit) ? "Credit" : "Debit"%>" class="cits_common_text"><%=transType.getType()%></span></td-->
                                                                                                    <td align="right" class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(transType.getlMinAmount()).doubleValue()) / 100)%></td>
                                                                                                    <td align="right" class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(transType.getlMaxAmount()).doubleValue()) / 100)%></td>
                                                                                                    <td align="center" class="cits_common_text"><%=transType.getiMinValueDate()%></td>
                                                                                                    <td align="center" class="cits_common_text"><%=transType.getiMaxValueDate()%></td>
                                                                                                    <td align="center" class="cits_common_text"><%=transType.getMinReturnDate()%></td>
                                                                                                    <td align="center" class="cits_common_text"><%=transType.getMaxReturnDate() != null ? transType.getMaxReturnDate() : ""%></td>
                                                                                                    <td class="cits_common_text"><%=transType.getMan1() != null ? transType.getMan1() : ""%></td>
                                                                                                    <td align="left" class="cits_common_text"><%=transType.getMan2() != null ? transType.getMan2() : ""%></td>
                                                                                                    <td align="left" class="cits_common_text"><%=transType.getMan3() != null ? transType.getMan3() : ""%></td>
                                                                                                    <td class="cits_common_text"><%=transType.getStatus()!= null?transType.getStatus().equals(LCPL_Constants.status_active)?"Active":"Inactive":"N/A"%></td>
                                                                                                </tr>

                                                                                                <%
                                                                                                    }



                                                                                                %>
                                                                                            </table>

                                                                                        </td>
                                                                                    </tr>
                                                                                </table>

                                                                            </td>
                                                                        </tr>


                                                                        <%
                                                                            }

                                                                        %>
                                                                    </table>                                                              </td>
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
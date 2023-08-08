<%@page import="java.sql.*,java.util.*,java.io.*" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../error.jsp"%>

<%	
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%>

<%
    String userName = null;
    String userType = null;
    String sessionBankName = null;
    String sessionBankCode = null;
    String branchId = null;
    String branchName = null;
    String menuId = null;
    String menuName = null;    

    int pwdValidityPeriod = -1;

    userName = (String) session.getAttribute("session_userName");    
    
    System.out.println(" userName (HomePage) - " + userName);
    System.out.println(" userType (HomePage) - " + session.getAttribute("session_userType"));

    if (userName == null || userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect("sessionExpired.jsp");
    }
    else
    {
        userType = (String) session.getAttribute("session_userType");
        sessionBankCode = (String) session.getAttribute("session_bankCode");
        sessionBankName = (String) session.getAttribute("session_bankName");
        branchId = (String) session.getAttribute("session_branchId");
        branchName = (String) session.getAttribute("session_branchName");
        menuId = (String) session.getAttribute("session_menuId");
        menuName = (String) session.getAttribute("session_menuName");      
        

        pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(userName);

        if (pwdValidityPeriod < 0)
        {
            DAOFactory.getUserDAO().setUserStatus(userName, LCPL_Constants.status_expired);
            session.invalidate();
            response.sendRedirect("pages/userAccountExpired.jsp");
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


<html>
    <head>
        <title>OUSDPS Web - Welcome (Version 1.4.0 - 2023)</title>
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../css/cits.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        
        <script language="JavaScript" type="text/javascript">

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
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window!=null?window.getCutontimeHour():null %>, <%=window!=null?window.getCutontimeMinutes():null %>, <%=window!=null?window.getCutofftimeHour():null %>, <%=window!=null?window.getCutofftimeMinutes():null %>);
                    clock(document.getElementById('showText'),type,val);
                }
            }
            
            function checkPwdValidity(days)
            {
                if(days<=7)
                {
                    if(days==0)
                    {
                        var confirmVal = confirm("Your current password will be expired after today! Do you want to change the password?");
                    
                        if(confirmVal==true)
                        {
                            window.location = "user/userProfile.jsp";
                        }
                    }
                    else
                    {
                        var msg = "Your current password will be expired after "+  days + " days! Do you want to change the password?"; 
                        
                        var confirmVal = confirm(msg);
                    
                        if(confirmVal==true)
                        {
                            window.location = "user/userProfile.jsp";
                        }
                    }
                }                
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="showClock(3);checkPwdValidity(<%=pwdValidityPeriod%>)">

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
                                                    <td valign="middle">

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
                            <td  height="470" align="center" valign="top" class="cits_bgHome">
                              <table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
                                        <td height="24" align="center" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="15"></td>

                                                    <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                                <td align="right" valign="middle" class="icps_menubar_text"><table width="200" height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>

                                                                                                    <td align="right" valign="middle" width="500"><iframe id="ifrmMessageAlert" name="ifrmMessageAlert" src="<%=request.getContextPath()%>/pages/messages/msgAlert.jsp" marginheight="0"
                                                                                                                                                   marginwidth="0" allowtransparency="true" height="24"  width="400" align="right" scrolling="no" frameborder="0" >if you can see this your browser doesn't support iframe !</iframe></td>
                                                                  </tr>
                                                                                </table></td>
                                                              <td width="10" valign="top" nowrap class="cits_menubar_text">&nbsp;</td>
                                                                <td valign="top" class="cits_menubar_text">Business Date : <%=webBusinessDate%></td>
                                                              <td width="5" valign="top"></td>
                                                                <td valign="top" class="cits_menubar_text">Session : <%=winSession%></td>
                                                              <td width="5" valign="top"></td>
                                                                <td valign="top"><div id="actSession" align="center" ><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgOK" id="imgOK" width="12" height="12" title="Session is active!" ></div>
                                                <div id="expSession" align="center" ><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgError" id="imgError" width="12" height="12" title="Session is expired!" ></div></td>
                                                              <td width="5" valign="top"></td>
                                                                <td valign="top" class="cits_menubar_text">[ Current : <%=currentDate%></td>
                                                              <td width="5" valign="top"></td>
                                                              <td valign="top" class="cits_menubar_text"><div id="showText" class="cits_menubar_text"></div></td>
                                                                <td valign="top" class="cits_menubar_text"> ]</td>
                                                              <td width="5"></td>
                                                            </tr>
                                                  </table></td>
                                                    <td width="15"></td>
                                                </tr>
                                            </table></td>
                                  </tr>
                                    <tr>
                                        <td align="center" valign="middle">&nbsp;</td>
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
                                                    <td align="center" class="cits_copyRight">&copy; 2015 LankaClear. All rights reserved.| Contact Us: +94 11 2356900 | info@lankaclear.com</td>
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

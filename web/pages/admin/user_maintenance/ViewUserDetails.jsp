<%@taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.User" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter"  %>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../../error.jsp"%>
<%@page import="org.displaytag.*" errorPage="../../../error.jsp"%>

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
    Collection<UserLevel> col_usrList = DAOFactory.getUserLevelDAO().getUserLevelDetails();

    String usrlvl = request.getParameter("cmbUsrLvl");

    if (usrlvl == null)
    {
        usrlvl = LCPL_Constants.status_all;
    }

    UserLevel userLevel = DAOFactory.getUserLevelDAO().getUserLevel(usrlvl);

    Collection<User> colUser = DAOFactory.getUserDAO().getUserList(usrlvl);
    
    request.setAttribute("userDetails", new ArrayList(colUser));

    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_user_maintenance_view_user_details, "| Search Criteria - (User Level : " + (userLevel != null ? userLevel.getUserLevelDesc() : "All") + ") | Result Count - " + colUser.size() + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));

%>


<html>
    <head>
        <title>OUSDPS Web - View User Details</title>
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/displaytag.css" rel="stylesheet" type="text/css" />        
        <link href="<%=request.getContextPath()%>/css/tabView.css" rel="stylesheet" type="text/css" />

        <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/displaytag.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/tabView.css" rel="stylesheet" type="text/css" />

        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/tableenhance.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/tabView.js"></script>
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
                                                                <td align="center" valign="middle"><table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">View User Details</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top" class="cits_header_text"><form name="frmUserFilter"  id="frmUserFilter" method="post" action="ViewUserDetails.jsp">
                                                                                                <table class="cits_table_boder" cellspacing="0" cellpadding="0" border="0">
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                <tr>
                                                                                                                    <td width="80" align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text"> User Level :</td>
                                                                                                                    <td width="" align="left" valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text"><select name="cmbUsrLvl" class="cits_field_border" id="cmbUsrLvl" onChange="frmUserFilter.submit()">
                                                                                                                            <%
                                                                                                                                if (usrlvl == null || usrlvl.equals(LCPL_Constants.status_all))
                                                                                                                                {%>
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>" selected="selected">-- All --</option>
                                                                                                                            <%}
                                                                                                                            else
                                                                                                                            {%>
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>">-- All --</option>
                                                                                                                            <%  }
                                                                                                                                if (col_usrList != null && col_usrList.size() > 0)
                                                                                                                                {

                                                                                                                                    for (UserLevel u : col_usrList)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=u.getUserLevelId()%>" <%=(usrlvl != null && u.getUserLevelId().equals(usrlvl)) ? "selected" : ""%> > <%=u.getUserLevelDesc()%> </option>
                                                                                                                            <% }%>
                                                                                                                        </select>
                                                                                                                        <%}%></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td align="center" valign="top"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table  border="0" cellspacing="0" cellpadding="0" >
                                                                                                <%
                                                                                                    if (colUser.size() > 0)
                                                                                                    {


                                                                                                %>
                                                                                                
                                                                                                <tr>
                                                                                                    <td align="center"><table  border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >
                                                                                                            <tr>
                                                                                                                <td><table  border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                        <tr>
                                                                                                                            <td bgcolor="#B3D5C0"></td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User ID</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">User<br/>Level</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Name</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Designation</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">E-Mail</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Contact<br/>No.</td>
                                                                                                                            
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created<br/>By</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created<br/>Date</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Modified<br/>By</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Modified<br/>Date</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">PWD Reset<br/>Date</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Init.<br/>PWD</td>
                                                                                                                            <td align="center" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">BIM<br/>Updated</td>
                                                                                                                        </tr>
                                                                                                                        <%                                                                                                                            int rowNum = 0;
                                                                                                                            for (User usr : colUser)
                                                                                                                            {
                                                                                                                                rowNum++;

                                                                                                                                String userStat = null;

                                                                                                                                if (usr.getStatus() != null)
                                                                                                                                {
                                                                                                                                    if (usr.getStatus().equals(LCPL_Constants.status_active))
                                                                                                                                    {
                                                                                                                                        userStat = "Active";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(LCPL_Constants.status_deactive))
                                                                                                                                    {
                                                                                                                                        userStat = "Inactive";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(LCPL_Constants.status_locked))
                                                                                                                                    {
                                                                                                                                        userStat = "Locked";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(LCPL_Constants.status_expired))
                                                                                                                                    {
                                                                                                                                        userStat = "Expired";
                                                                                                                                    }
                                                                                                                                    else if (usr.getStatus().equals(LCPL_Constants.status_pending))
                                                                                                                                    {
                                                                                                                                        userStat = "Pending";
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    userStat = "N/A";
                                                                                                                                }


                                                                                                                        %>
                                                                                                                        <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                            <td align="right" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                                            <td class="cits_common_text"><%=usr.getUserId()%></td>
                                                                                                                            <td nowrap class="cits_common_text"><%=usr.getUserLevelDesc()%></td>
                                                                                                                            <td align="left" nowrap class="cits_common_text"><%=usr.getBankCode()%> - <%=usr.getBankShortName()%></td>
                                                                                                                            <td class="cits_common_text"><%=usr.getName() != null ? usr.getName() : "N/A"%></td>
                                                                                                                            <td class="cits_common_text"><%=usr.getDesignation() != null ? usr.getDesignation() : "N/A"%></td>
                                                                                                                            <td class="cits_common_text"><%=usr.getEmail() != null ? usr.getEmail() : "N/A"%></td>
                                                                                                                            <td class="cits_common_text"><%=usr.getContactNo() != null ? usr.getContactNo() : "N/A"%></td>
                                                                                                                            
                                                                                                                            <td class="cits_common_text"><%=userStat%></td>
                                                                                                                            <td class="cits_common_text"><%=usr.getCreatedBy()%></td>
                                                                                                                            <td align="center" nowrap class="cits_common_text"><%=usr.getCreatedDate()%></td>
                                                                                                                            <td align="center" nowrap class="cits_common_text"><%=(usr.getModifiedBy() != null) ? usr.getModifiedBy() : "N/A"%></td>
                                                                                                                            <td align="center" nowrap class="cits_common_text"><%=(usr.getModifiedDate() != null) ? usr.getModifiedDate() : "N/A"%></td>
                                                                                                                            <td align="center" nowrap class="cits_common_text"><%=(usr.getLastPasswordResetDate() != null) ? usr.getLastPasswordResetDate() : "N/A"%></td>
                                                                                                                            <td align="center" class="cits_common_text"><%=((usr.getIsInitialPassword() != null) && usr.getIsInitialPassword().equals(LCPL_Constants.status_yes)) ? "Yes" : "No"%></td>
                                                                                                                            <td align="center" class="cits_common_text"><%=((usr.getNeedDownloadToBIM() != null) && usr.getNeedDownloadToBIM().equals(LCPL_Constants.status_yes)) ? "No" : "Yes"%></td>
                                                                                                                        </tr>
                                                                                                                        <%}%>
                                                                                                                    </table></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                </tr>
																									-->


                                                                                                <tr>
                                                                                                    <td align="center">
                                                                                                        <div id="resultdata"> 
                                                                                                            
                                                                                                            <jsp:scriptlet> 
                                                                                                                org.displaytag.decorator.TotalTableDecorator totals = new org.displaytag.decorator.TotalTableDecorator();

                                                                                                                totals.setTotalLabel("Total");
                                                                                                                pageContext.setAttribute("totals", totals);
                                                                                                            </jsp:scriptlet>

                                                                                                            <display:table name="userDetails" export="true" id="tblUserDetails" class="icps_displaytag" cellspacing="1" cellpadding="3">
                                                                                                                <display:setProperty name="export.pdf.filename" value="USD_Online_System_User_Details.pdf" />
                                                                                                                <display:setProperty name="export.excel.filename" value="USD_Online_System_User_Details.xls" />

                                                                                                                <display:column style="text-align:right" media="html"> <%=pageContext.getAttribute("tblUserDetails_rowNum")%>. </display:column>

                                                                                                                <display:column property="userId" title="User ID" media="html" sortable="true" style="text-align:left;min-width:95px" />
                                                                                                                <display:column property="userId" title="User ID" media="excel pdf" sortable="true" headerClass="r2" style="text-align:left;min-width:95px" />

                                                                                                                <display:column property="userLevelDesc" title="User<br/>Level" media="html" sortable="true" style="text-align:left;min-width:120px" />
                                                                                                                <display:column property="userLevelDesc" title="User Level" media="excel pdf" sortable="true" style="text-align:left;min-width:120px" />

                                                                                                                <display:column title="Bank" sortable="true" media="html" style="text-align:left;min-width:80px" > <span class="icps_common_text" title="<%=((User) pageContext.getAttribute("tblUserDetails")).getBankFullName()%>"><%=((User) pageContext.getAttribute("tblUserDetails")).getBankCode()%> - <%=((User) pageContext.getAttribute("tblUserDetails")).getBankShortName()%></span> </display:column>
                                                                                                                <display:column title="Bank" media="excel pdf" style="text-align:left;min-width:80px" > <%=((User) pageContext.getAttribute("tblUserDetails")).getBankCode()%> - <%=((User) pageContext.getAttribute("tblUserDetails")).getBankShortName()%> </display:column>  

                                                                                                                <display:column property="name" title="Name" media="html" sortable="true" style="text-align:left;min-width:160px" />
                                                                                                                <display:column property="name" title="Name" media="excel pdf" sortable="true"  style="text-align:left;min-width:160px" />

                                                                                                                <display:column property="designation" title="Designation" media="html" sortable="true" style="text-align:left;min-width:120px" />
                                                                                                                <display:column property="designation" title="Designation" media="excel pdf" sortable="true"  style="text-align:left;min-width:120px" />

                                                                                                                <display:column property="email" title="E-Mail" media="html" sortable="true" style="text-align:left;min-width:100px" />
                                                                                                                <display:column property="email" title="E-Mail" media="excel pdf" sortable="true"  style="text-align:left;min-width:100px" />

                                                                                                                <display:column property="contactNo" title="Contact<br/>No." media="html" sortable="true" style="text-align:center;min-width:80px" />
                                                                                                                <display:column property="contactNo" title="Contact No." media="excel pdf" sortable="true"  style="text-align:center;min-width:80px" />                                                                                                                                                                                                                                                                                                                                     

                                                                                                                <%
                                                                                                                    String userStat = "";
                                                                                                                    String userStatDesc = "";       
                                                                                                                   
                                                                                                                    if (((User) pageContext.getAttribute("tblUserDetails")).getStatus() != null)
                                                                                                                    {
                                                                                                                        userStat = ((User) pageContext.getAttribute("tblUserDetails")).getStatus();

                                                                                                                        if (userStat.equals(LCPL_Constants.status_active))
                                                                                                                        {
                                                                                                                            userStatDesc = "Active";
                                                                                                                        }
                                                                                                                        else if (userStat.equals(LCPL_Constants.status_deactive))
                                                                                                                        {
                                                                                                                            userStatDesc = "Inactive";
                                                                                                                        }
                                                                                                                        else if (userStat.equals(LCPL_Constants.status_locked))
                                                                                                                        {
                                                                                                                            userStatDesc = "Locked";
                                                                                                                        }
                                                                                                                        else if (userStat.equals(LCPL_Constants.status_expired))
                                                                                                                        {
                                                                                                                            userStatDesc = "Expired";
                                                                                                                        }
                                                                                                                        else if (userStat.equals(LCPL_Constants.status_pending))
                                                                                                                        {
                                                                                                                            userStatDesc = "Pending";
                                                                                                                        }
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        userStatDesc = "N/A";
                                                                                                                    }

                                                                                                                %>


                                                                                                                <display:column title="Status" media="html"  sortable="true" style="text-align:center;min-width:70px" ><%=userStatDesc%></display:column>
                                                                                                                <display:column title="Status" media="excel pdf" sortable="true" style="min-width:70px" ><%=userStatDesc%></display:column> 

                                                                                                                <display:column property="createdBy" title="Created<br/>By" media="html" sortable="true" style="text-align:left;min-width:80px" />
                                                                                                                <display:column property="createdBy" title="Created By" media="excel pdf" sortable="true"  style="text-align:left;min-width:80px" />

                                                                                                                <display:column property="createdDate" title="Created<br/>Date" media="html" sortable="true" style="text-align:center;min-width:110px" />
                                                                                                                <display:column property="createdDate" title="Created Date" media="excel pdf" sortable="true"  style="text-align:center;min-width:110px" />

                                                                                                                <%
                                                                                                                    String modifiedBy = "n/a";

                                                                                                                    if (((User) pageContext.getAttribute("tblUserDetails")).getModifiedBy() != null)
                                                                                                                    {
                                                                                                                        modifiedBy = ((User) pageContext.getAttribute("tblUserDetails")).getModifiedBy();
                                                                                                                    }
                                                                                                                %>

                                                                                                                <display:column title="Modified<br/>By" media="html" sortable="true" style="text-align:left;min-width:80px" ><%=modifiedBy%></display:column>                                                                                                                                                                                                                                                               
                                                                                                                <display:column  title="ModifiedBy" media="excel pdf" sortable="true" style="text-align:left;min-width:80px" ><%=modifiedBy%></display:column>


                                                                                                                <%
                                                                                                                    String modifiedDate = "n/a";

                                                                                                                    if (((User) pageContext.getAttribute("tblUserDetails")).getModifiedDate() != null)
                                                                                                                    {
                                                                                                                        modifiedDate = ((User) pageContext.getAttribute("tblUserDetails")).getModifiedDate();
                                                                                                                    }
                                                                                                                %>                                                                                                                                

                                                                                                                <display:column title="Modified<br/>Date" media="html" sortable="true" style="text-align:center;min-width:110px" ><%=modifiedDate%></display:column>                                                                                                                                                                                                                                                               
                                                                                                                <display:column  title="Modified Date" media="excel pdf" sortable="true" style="text-align:center;min-width:110px" ><%=modifiedDate%></display:column>

                                                                                                                <%
                                                                                                                    String lastPwdResetDate = "n/a";

                                                                                                                    if (((User) pageContext.getAttribute("tblUserDetails")).getLastPasswordResetDate() != null)
                                                                                                                    {
                                                                                                                        lastPwdResetDate = ((User) pageContext.getAttribute("tblUserDetails")).getLastPasswordResetDate();
                                                                                                                    }
                                                                                                                %>                                                                                                                                

                                                                                                                <display:column title="Last PWD<br/>ResetDate" media="html" sortable="true" style="text-align:center;min-width:110px" ><%=lastPwdResetDate%></display:column>                                                                                                                                                                                                                                                               
                                                                                                                <display:column  title="Last PWD ResetDate" media="excel pdf" sortable="true" style="text-align:center;min-width:110px" ><%=lastPwdResetDate%></display:column>

                                                                                                                <%
                                                                                                                    String isInitialPwd = "n/a";

                                                                                                                    if (((User) pageContext.getAttribute("tblUserDetails")).getIsInitialPassword() != null)
                                                                                                                    {
                                                                                                                        isInitialPwd = ((User) pageContext.getAttribute("tblUserDetails")).getIsInitialPassword();

                                                                                                                        if (isInitialPwd.equals(LCPL_Constants.status_yes))
                                                                                                                        {
                                                                                                                            isInitialPwd = "Yes";
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            isInitialPwd = "No";
                                                                                                                        }
                                                                                                                    }
                                                                                                                %>                                                                                                                                

                                                                                                                <display:column title="Initial<br/>PWD" media="html" sortable="true" style="text-align:center;min-width:72px" ><%=isInitialPwd%></display:column>                                                                                                                                                                                                                                                               
                                                                                                                <display:column  title="Initial PWD" media="excel pdf" sortable="true" style="text-align:center;min-width:72px" ><%=isInitialPwd%></display:column>

                                                                                                                <%
                                                                                                                    String isBIM_Updated = "n/a";

                                                                                                                    if (((User) pageContext.getAttribute("tblUserDetails")).getNeedDownloadToBIM() != null)
                                                                                                                    {
                                                                                                                        isBIM_Updated = ((User) pageContext.getAttribute("tblUserDetails")).getNeedDownloadToBIM();

                                                                                                                        if (isBIM_Updated.equals(LCPL_Constants.status_yes))
                                                                                                                        {
                                                                                                                            isBIM_Updated = "No";
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            isBIM_Updated = "Yes";
                                                                                                                        }
                                                                                                                    }
                                                                                                                %>                                                                                                                                

                                                                                                                <display:column title="Is BIM<br/>Updated" media="html" sortable="true" style="text-align:center;min-width:80px" ><%=isBIM_Updated%></display:column>                                                                                                                                                                                                                                                               
                                                                                                                <display:column  title="Is BIM Updated" media="excel pdf" sortable="true" style="text-align:center;min-width:80px" ><%=isBIM_Updated%></display:column>

                                                                                                            </display:table>
                                                                                                                
                                                                                                            <script type="text/javascript">highlightTableRows('tblUserDetails');</script>



                                                                                                        </div></td>
                                                                                                </tr>


                                                                                                <%
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td align="center" class="cits_header_small_text">No Records Available!</td>
                                                                                                </tr>
                                                                                                <%                                    }
                                                                                                %>
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
    }

%>

<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.transactiontype.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../../error.jsp"%>

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

    userName = (String) session.getAttribute("session_userName");

    if (userName == null || userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
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
    ParameterDAO para_dao = DAOFactory.getParameterDAO();
    Collection<Parameter> col = para_dao.getAllParamterValues();

    Vector<String> vDateParams = null;
    String recordCounter_dayType = "";

    Vector<String> vDateParams_No = null;
    String recordCounter_dayType_No = "";

%>
<html>
    <head>
        <title>OUSDPS Web - Set Parameter Values</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

            function validate()
            {
                var noOfItems = document.getElementById('hdncol_size').value;
                var completeNewParamValues = "";

                for(var i = 1; i <= noOfItems; i++)
                {
                    var hdn_paramTypeName = 'hdnParamType_' + i;
                    var hdn_paramTypeValue = document.getElementById(hdn_paramTypeName).value;

                    if(hdn_paramTypeValue == '<%=LCPL_Constants.param_type_pwd%>')
                    {
                        var paramValuePwd = document.getElementById('txtPwd_'+i).value;
                        var paramValueRePwd = document.getElementById('txtRePwd_'+i).value;

                        if(paramValuePwd != null && !isempty(paramValuePwd))
                        {                           
                        
                            if(isempty(paramValueRePwd))
                            {
                                alert("Re-type Password Can not be empty!");
                                return false;
                            }
                            else
                            {
                                if(paramValuePwd != paramValueRePwd)
                                {
                                    alert("Password does not match with the Re-type Password!");
                                    document.getElementById('txtPwd_'+i).value="";
                                    document.getElementById('txtRePwd_'+i).value="";
                                    document.getElementById('txtPwd_'+i).focus();                                
                                    return false;
                                }
                                else
                                {
                                    completeNewParamValues = completeNewParamValues + i + ":"
                                }
                             } 
                        }
                    }
                    
                    else if(hdn_paramTypeValue == '<%=LCPL_Constants.param_type_day%>')
                    {
                        var paramValue = document.getElementById('txtParamValue_'+i).value;

                        if(paramValue != null && !isempty(paramValue))
                        {
                            completeNewParamValues = completeNewParamValues + i + ":"
                        }
                    }
                    else if(hdn_paramTypeValue == '<%=LCPL_Constants.param_type_time%>')
                    {
                        var paramValueHH = document.getElementById('cmbHH_'+i).value;
                        var paramValueMM = document.getElementById('cmbMM_'+i).value;

                        if(paramValueHH != null && !isempty(paramValueHH) && paramValueHH != '<%=LCPL_Constants.status_all%>')
                        {
                            if(paramValueMM != null && !isempty(paramValueMM) && paramValueMM != '<%=LCPL_Constants.status_all%>')
                            {
                            completeNewParamValues = completeNewParamValues + i + ":"
                            }
                            else
                            {
                            alert('Select the Minute value for parameter in row no. - ' + i +'.');
                            return false;
                            }
                        }
                        else
                        {
                            if(paramValueMM != null && !isempty(paramValueMM) && paramValueMM != '<%=LCPL_Constants.status_all%>')
                            {
                            alert('Select the Hour value for parameter in row no. - ' + i +'.');
                            return false;
                            }
                        }

            }
            else if(hdn_paramTypeValue == '<%=LCPL_Constants.param_type_other%>')
            {
            var paramValue = document.getElementById('txtParamValue_'+i).value;

            if(paramValue != null && !isempty(paramValue))
            {
            completeNewParamValues = completeNewParamValues + i + ":"
            }

            }
            else
            {
            alert('Invalid Parameter Type In row number -' + i +'.');
            return false;
            }
            }

            if(completeNewParamValues != null && !isempty(completeNewParamValues))
            {
            document.getElementById('hdnNewParamIds').value = completeNewParamValues;
            document.frmSetParam.submit();
            }
            else
            {
            alert('Sorry! There is no change to the parameters to update.');
            return false;
            }

            }

            function isempty(Value)
            {
            if(Value.length < 1)
            {
            return true;
            }
            else
            {
            var str = Value;

            while(str.indexOf(" ") != -1)
            {
            str = str.replace(" ","");
            }

            if(str.length < 1)
            {
            return true;
            }
            else
            {
            return false;
            }
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Set Parameter Values</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><form name="frmSetParam" id="frmSetParam" action="ParameterUpdationConformation.jsp" method="post"
                                                                                                                              >
                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <%


                                                                                                        try
                                                                                                        {

                                                                                                            if (col != null && col.size() == 0)
                                                                                                            {

                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td align="center" class="cits_header_small_text">No Records Available !</td>
                                                                                                    </tr>
                                                                                                    <%                                                                                                                              }
                                                                                                    else if (col != null && col.size() > 0)
                                                                                                    {

                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td><table border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <th height="30" bgcolor="#B3D5C0" class="csks_top_link_nav"></th>
                                                                                                                    <th align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Parameter</th>
                                                                                                                    <th align="center" bgcolor="#B3D5C0" valign="middle" class="cits_tbl_header_text">Current Value</th>
                                                                                                                    <th align="center" bgcolor="#B3D5C0" valign="middle" class="cits_tbl_header_text">New Value</th>
                                                                                                                </tr>
                                                                                                                <%
                                                                                                                    int rowNum = 0;
                                                                                                                    int col_size = 0;


                                                                                                                    for (Parameter p : col)
                                                                                                                    {
                                                                                                                        rowNum++;
                                                                                                                %>
                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>" onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td align="right" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                                    <td align="left" class="cits_common_text"><%=p.getDescription()%>
                                                                                                                        <input type="hidden" id="hdnParamId_<%=rowNum%>" name="hdnParamId_<%=rowNum%>" value="<%=p.getName()%>" />
                                                                                                                        <input type="hidden" id="hdnParamDesc_<%=rowNum%>" name="hdnParamDesc_<%=rowNum%>" value="<%=p.getDescription()%>" />
                                                                                                                    </td>
                                                                                                                    <td class="cits_common_text"><%
                                                                                                                        String formattedValue = null;

                                                                                                                        if (p.getType() != null && p.getValue() != null)
                                                                                                                        {
                                                                                                                            if (p.getType().equals(LCPL_Constants.param_type_time))
                                                                                                                            {
                                                                                                                                formattedValue = DateFormatter.doFormat(DateFormatter.getTime(p.getValue(), LCPL_Constants.simple_date_format_HHmm), LCPL_Constants.simple_date_format_HH_mm);
                                                                                                                            }
                                                                                                                            else if (p.getType().equals(LCPL_Constants.param_type_day))
                                                                                                                            {
                                                                                                                                formattedValue = DateFormatter.doFormat(DateFormatter.getTime(p.getValue(), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                            }
                                                                                                                            else if (p.getType().equals(LCPL_Constants.param_type_pwd))
                                                                                                                            {
                                                                                                                                if (p.getDecrytedValue() != null)
                                                                                                                                {
                                                                                                                                    formattedValue = "";

                                                                                                                                    for (int i = 0; i < p.getDecrytedValue().length(); i++)
                                                                                                                                    {
                                                                                                                                        formattedValue = formattedValue + "*";
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    formattedValue = "Not Available.";
                                                                                                                                }

                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                formattedValue = p.getValue();
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            formattedValue = "Not Available.";
                                                                                                                        }
                                                                                                                        %>
                                                                                                                        <%=formattedValue%>
                                                                                                                        <input type="hidden" id="hdnCurrentParamValue_<%=rowNum%>" name="hdnCurrentParamValue_<%=rowNum%>" value="<%=p.getValue()%>" /></td>
                                                                                                                    <td>


                                                                                                                        <%

                                                                                                                            if ((p.getType() != null) && (p.getType().equals(LCPL_Constants.param_type_pwd)))
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <table cellpadding="1" cellspacing="0" border="0">
                                                                                                                    <tr>
                                                                                                                              <td align="center" class="cits_common_text">Password</td>
                                                                                                                              <td></td>
                                                                                                                              <td align="center" class="cits_common_text">Re-type Password</td>
                                                                                                                              <td></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td><input name="txtPwd_<%=rowNum%>" type="password" class="cits_field_border" id="txtPwd_<%=rowNum%>" size="22" maxlength="18" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><input name="txtRePwd_<%=rowNum%>" type="password" class="cits_field_border" id="txtRePwd_<%=rowNum%>" size="22" maxlength="20" onFocus="hideMessage_onFocus()"/></td>
                                                                                                                                <td><input type="hidden" id="hdnParamType_<%=rowNum%>" name="hdnParamType_<%=rowNum%>" value="<%=p.getType()%>" /></td>
                                                                                                                            </tr>
                                                                                                                        </table>


                                                                                                                  <%

                                                                                                                        }
                                                                                                                        else if ((p.getType() != null) && (p.getType().equals(LCPL_Constants.param_type_time)))
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td><select name="cmbHH_<%=rowNum%>" id="cmbHH_<%=rowNum%>" class="cits_field_border">
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>">- Hour -</option>
                                                                                                                                        <%                                                                                                                                                                                                                                                                                                                                                                                                                                                                            for (int i = 0; i < 24; i++)
                                                                                                                                            {
                                                                                                                                                if (i <= 9)
                                                                                                                                                {%>
                                                                                                                                        <option value="<%="0" + i%>"><%="0" + i%></option>
                                                                                                                                        <%}
                                                                                                                                        else
                                                                                                                                        {%>
                                                                                                                                        <option value="<%=i%>"><%=i%></option>
                                                                                                                                <%}
                                                                                                                                            }%>
                                                                                                                                    </select></td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><select name="cmbMM_<%=rowNum%>" id="cmbMM_<%=rowNum%>" class="cits_field_border">
                                                                                                                                        <option value="<%=LCPL_Constants.status_all%>">- Minute -</option>
                                                                                                                                        <%for (int i = 0; i <= 59; i++)
                                                                                                                                            {
                                                                                                                                                if (i <= 9)
                                                                                                                                                {%>
                                                                                                                                        <option value="<%="0" + i%>"><%="0" + i%></option>
                                                                                                                                        <%}
                                                                                                                                        else
                                                                                                                                        {%>
                                                                                                                                        <option value="<%=i%>"><%=i%></option>
                                                                                                                                        <%}
                                                                                                                                            }%>
                                                                                                                              </select></td>
                                                                                                                                <td><input type="hidden" id="hdnParamType_<%=rowNum%>" name="hdnParamType_<%=rowNum%>" value="<%=p.getType()%>" /></td>
                                                                                                                          </tr>
                                                                                                                      </table>
                                                                                                                        <%
                                                                                                                            }
                                                                                                                            if ((p.getType() != null) && (p.getType().equalsIgnoreCase(LCPL_Constants.param_type_day)))
                                                                                                                            {

                                                                                                                                if (vDateParams == null)
                                                                                                                                {
                                                                                                                                    vDateParams = new Vector();
                                                                                                                                }
                                                                                                                                String txtParamValueId = "txtParamValue_" + rowNum;
                                                                                                                                recordCounter_dayType = recordCounter_dayType + rowNum + "_";
                                                                                                                                vDateParams.add(txtParamValueId);
                                                                                                                        %>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="text" name="txtParamValue_<%=rowNum%>" id="txtParamValue_<%=rowNum%>" onFocus="this.blur()" class="tcal" size="11" />                                                                                                                                </td>
                                                                                                                                <td width="5"></td>
                                                                                                                                <td><input type="hidden" id="hdnParamType_<%=rowNum%>" name="hdnParamType_<%=rowNum%>" value="<%=p.getType()%>" /></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <%}
                                                                                                                            if ((p.getType() != null) && (p.getType().equalsIgnoreCase(LCPL_Constants.param_type_other)))
                                                                                                                            {
                                                                                                                                if (vDateParams_No == null)
                                                                                                                                {
                                                                                                                                    vDateParams_No = new Vector();
                                                                                                                                }
                                                                                                                                String txtParamValueId = "txtParamValue_" + rowNum;
                                                                                                                                recordCounter_dayType_No = recordCounter_dayType_No + rowNum + "_";
                                                                                                                                vDateParams_No.add(txtParamValueId);


                                                                                                                        %>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        if (p.getName() != null && p.getName().equals(LCPL_Constants.param_id_session))
                                                                                                                                        {
                                                                                                                                    %>

                                                                                                                                    <select name="txtParamValue_<%=rowNum%>" id="txtParamValue_<%=rowNum%>" class="cits_field_border" >
                                                                                                                                        <option value="" selected>- Select -</option>
                                                                                                                                        <option value="1">1</option>
                                                                                                                                        <option value="2">2</option>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <input type="text" name="txtParamValue_<%=rowNum%>" id="txtParamValue_<%=rowNum%>" class="cits_field_border" size="14"/>
                                                                                                                                    <%
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                </td>
                                                                                                                                <td><input type="hidden" id="hdnParamType_<%=rowNum%>" name="hdnParamType_<%=rowNum%>" value="<%=p.getType()%>" /></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%                                                                                                                                                                                     }
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td height="35" colspan="4" align="right" valign="bottom" bgcolor="#CDCDCD"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="hidden" id="hdncol_size" name="hdncol_size" value="<%=col != null ? col.size() : "0"%>" />
                                                                                                                                    <input type="hidden" name="hdnNewParamIds" id="hdnNewParamIds" >
                                                                                                                                </td>
                                                                                                                                <td><input name="btnSubmit" id="btnSubmit" type="button" value="Update" class="cits_custom_button" onClick="javascript:validate();"/>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                            }
                                                                                                        }
                                                                                                        catch (Exception e)
                                                                                                        {
                                                                                                            System.out.print(e.toString());
                                                                                                        }

                                                                                                    %>
                                                                                                </table>
                                                                                            </form>
                                                                                            <script language="javascript" type="text/JavaScript">
                                                                                                <!--
                                                                                                // create calendar object(s) just after form tag closed
                                                                                                // specify form element as the only parameter (document.forms['formname'].elements['inputname']);
                                                                                                // note: you can have as many calendar objects as you need for your application
                                                                                                <%
																								/*

                                                                                                    if (vDateParams != null)
                                                                                                    {
                                                                                                        for (String txtParamName : vDateParams)
                                                                                                        {

                                                                                                            String id = txtParamName.substring(txtParamName.lastIndexOf("_") + 1);
                                                                                                %>
                                                                                                var cal_from_<%=id%> = new                                       calendar1(document.forms['frmSetParam'].elements['<%=txtParamName%>']);
                                                                                                cal_from_<%=id%>.year_scroll = true;
                                                                                                cal_from_<%=id%>.time_comp = false;

                                                                                                <%
                                                                                                        }
                                                                                                    } */
                                                                                                %>

                                                                                                //-->
                                                                                            </script>
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

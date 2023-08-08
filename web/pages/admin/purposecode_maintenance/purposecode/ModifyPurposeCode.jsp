
<%@page import="java.util.*,java.sql.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.purposecode.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../../error.jsp" %>
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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user)))
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
    Collection<PurposeCode> colPC = null;
    PurposeCode pcDetails = null;
    String reqType = null;
    String cmbPC = null;
    String purposeCode = null;
    String desc = null;
    String status = null;

    String msg = null;

    boolean result = false;
    
    colPC = DAOFactory.getPurposeCodeDAO().getPurposeCodesDetails(LCPL_Constants.status_all);

    reqType = (String) request.getParameter("hdnRequestType");

    if (reqType == null)
    {
        cmbPC = "-1";        
    }
    else if (reqType.equals("0"))
    {
        cmbPC = (String) request.getParameter("cmbPurCode");
        pcDetails = DAOFactory.getPurposeCodeDAO().getPurposeCode(cmbPC);

        purposeCode = pcDetails.getPurposeCode();
        desc = pcDetails.getDesc();
        status = pcDetails.getStatus();
    }
    else if (reqType.equals("1"))
    {
        cmbPC = (String) request.getParameter("cmbPurCode");
        pcDetails = DAOFactory.getPurposeCodeDAO().getPurposeCode(cmbPC);

        purposeCode = (String) request.getParameter("hdnPurCode");
        desc = (String) request.getParameter("txtDesc");
        status = (String) request.getParameter("cmbStatus");

        PurposeCodeDAO pcDAO = DAOFactory.getPurposeCodeDAO();

        result = pcDAO.modifyPurposeCode(new PurposeCode(purposeCode, desc, status, userName));

        if (!result)
        {
            msg = pcDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_purposecode_maintenance_modify_purpose_code, "| Purpose Code - " + purposeCode + "), Description - (New :" + desc + ", Old : " + pcDetails.getDesc() + "), Status - (New : " + status + ", Old : " + pcDetails.getStatus() + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_purposecode_maintenance_modify_purpose_code, "| Purpose Code - " + purposeCode + "), Description - (New :" + desc + ", Old : " + pcDetails.getDesc() + "), Status - (New : " + status + ", Old : " + pcDetails.getStatus() + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>
<html>
    <head><title>OUSDPS Web - Modify Purpose Code</title>
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

            function setRequestType(status) 
            {
                if(status) 
                {
                document.getElementById('hdnRequestType').value = "1";
                }
                else 
                {
                document.getElementById('hdnRequestType').value = "0";
                }
            }


            function clearRecords_onPageLoad()
            {                
                showClock(3);
            }          
     
            function clearRecords()
            {
                document.getElementById('txtDesc').value = "";				
                document.getElementById('cmbStatus').selectedIndex = 0;
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
            }

            function hideMessage_onFocus()
            {
                if(document.getElementById('displayMsg_error')!= null)
                {
                    document.getElementById('displayMsg_error').style.display='none';

                    if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
                    {
                        doSearch();
                        document.getElementById('hdnCheckPOSForClearREcords').value = '0';
                    }
                }

                if(document.getElementById('displayMsg_success')!=null)
                {
                    document.getElementById('displayMsg_success').style.display = 'none';

                    if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
                    {
                    doSearch();
                    document.getElementById('hdnCheckPOSForClearREcords').value = '0';
                    }
                }                
            }

            function fieldValidation()
            {                
                
                var description = document.getElementById('txtDesc').value;
                var status = document.getElementById('cmbStatus').value;

                var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
                var numbers = /^[0-9]*$/;
	
                if(isempty(description))
                {
                    alert("Description can not be empty!");
                    document.getElementById('txtDesc').focus();
                    return false;
                }
	
                if(status==null || status=="-1")
                {
                    alert("Select Purpose Code Status");
                    document.getElementById('cmbStatus').focus();
                    return false;
                }

                document.frmModifyPC.action="ModifyPurposeCode.jsp";
                document.frmModifyPC.submit();
                return true;   
            }			

            function doSearch()
            {
                var cmbPurCodeVal = document.getElementById('cmbPurCode').value;

                if(cmbPurCodeVal==null || cmbPurCodeVal=="-1")
                {
                    clearResultData();
                    return false;
                }
                else
                {
                    setRequestType(false);
                    document.frmModifyPC.action="ModifyPurposeCode.jsp";
                    document.frmModifyPC.submit();
                    return true;				
                }			
            }

            function doUpdate()
            {
                setRequestType(true);                    
                fieldValidation();				
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

            function findSpaces(str)
            {               
                var status = false;
                var strTrimed = this.trim(str);

                for (var i=0;i<strTrimed.length;i++)
                {
                    if(strTrimed[i]== " ")
                    {
                        status = true;
                        break;
                    }
                }

                return status;                
            }

            function trim(str) 
            {
                return str.replace(/^\s+|\s+$/g,"");
            }


        </script>

    </head>

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="clearRecords_onPageLoad()">
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
                                                                            <td align="left" valign="top" >
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">Modify Purpose Code</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="100"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text">
                                                                                            <form name="frmModifyPC" id="frmModifyPC" method="post" >

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><table border="0" align="center" cellspacing="1" cellpadding="5" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Purpose Code :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE">
                                                                                                                        <select name="cmbPurCode" id="cmbPurCode" class="cits_field_border" onChange="setRequestType(false);
                                                                                                                                        doSearch();">

                                                                                                                            <option value="-1" <%=(cmbPC == null || cmbPC.equals("-1")) ? "selected" : ""%>>-- Select Purpose Code --</option>

                                                                                                                            <%
                                                                                                                                if (colPC != null && !colPC.isEmpty())
                                                                                                                                {

                                                                                                                                    for (PurposeCode pc : colPC)
                                                                                                                                    {
                                                                                                                            %>
                                                                                                                            <option value="<%=pc.getPurposeCode()%>" <%=(cmbPC != null && pc.getPurposeCode().equals(cmbPC)) ? "selected" : ""%>><%=pc.getPurposeCode()%></option>

                                                                                                                            <% }%>
                                                                                                                        </select>
                                                                                                                        <% }
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                        <span class="cits_error">No purpose code details available.</span>
                                                                                                                        <%}%><input type="hidden" name="hdnRequestType" id="hdnRequestType" value="<%=reqType%>" /></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="15"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle">
                                                                                                            <%
                                                                                                                if (reqType != null)
                                                                                                                {
                                                                                                            %>

                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
                                                                                                                    if (pcDetails == null)
                                                                                                                    {
                                                                                                                %>

                                                                                                                <tr>
                                                                                                                    <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                                                </tr>

                                                                                                                <%                                                                                    }
                                                                                                                else
                                                                                                                {

                                                                                                                %>

                                                                                                                <tr>

                                                                                                                    <td><div id="resultdata"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                <tr>
                                                                                                                                    <td align="center">
                                                                                                                                        <%                                                                                                                                            if (reqType.equals("1"))
                                                                                                                                            {

                                                                                                                                                if (result == true)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <div id="displayMsg_success" class="cits_Display_Success_msg" >

                                                                                                                                            Purpose Code Modified Sucessfully.                                                                                                </div>
                                                                                                                                            <% }
                                                                                                                                            else
                                                                                                                                            {%>


                                                                                                                                        <div id="displayMsg_error" class="cits_Display_Error_msg" >Purpose Code Modification Failed.- <span class="cits_error"><%=msg%></span></div>
                                                                                                                                            <%                                                                                            }
                                                                                                                                            %>
                                                                                                                                        <input type="hidden" name="hdnCheckPOSForClearREcords" id="hdnCheckPOSForClearREcords" value="1" />
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %></td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td height="10"></td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td align="center" valign="middle">

                                                                                                                                        <table border="0" cellspacing="1" cellpadding="5" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                                            <tr>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Current Value</td>
                                                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">New Value</td>
                                                                                                                                            </tr>

                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Purpose Code :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text"><%=pcDetails.getPurposeCode()%>                                                                                </td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                    <input type="hidden" name="hdnPurCode" id="hdnPurCode" class="cits_success" value="<%=purposeCode%>" maxlength="4" readonly/></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Description :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text"><%=pcDetails.getDesc()%>
                                                                                                                                                    <input type="hidden" name="hdnFullName" id="hdnFullName" class="cits_common_text" value="<%=pcDetails.getDesc()%>"/>                                                                                </td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                    <input name="txtDesc" type="text" class="cits_field_border" id="txtDesc" onFocus="hideMessage_onFocus()" value="<%=desc != null ? desc : ""%>" size="100" maxlength="150"/></td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_common_text_bold">Status :</td>
                                                                                                                                                <td align="left" valign="middle" bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                    <%
                                                                                                                                                        String stat = null;

                                                                                                                                                        if (pcDetails.getStatus() == null)
                                                                                                                                                        {
                                                                                                                                                            stat = "N/A";
                                                                                                                                                        }
                                                                                                                                                        else if (pcDetails.getStatus().equals(LCPL_Constants.status_active))
                                                                                                                                                        {
                                                                                                                                                            stat = "Active";
                                                                                                                                                        }
                                                                                                                                                        else if (pcDetails.getStatus().equals(LCPL_Constants.status_deactive))
                                                                                                                                                        {
                                                                                                                                                            stat = "Inactive";
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            stat = "Other";
                                                                                                                                                        }
                                                                                                                                                    %>

                                                                                                                                                    <%=stat%>                                                                                                                        </td>
                                                                                                                                                <td bgcolor="#DFEFDE">
                                                                                                                                                    <select name="cmbStatus" id="cmbStatus" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                        <option value="-1" <%=status == null ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                        <option value="<%=LCPL_Constants.status_active%>" <%=status != null && status.equals(LCPL_Constants.status_active) ? "selected" : ""%>>Active</option>
                                                                                                                                                        <option value="<%=LCPL_Constants.status_deactive%>" <%=status != null && status.equals(LCPL_Constants.status_deactive) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                    </select>                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                            <tr>  <td height="35" colspan="3" align="right" bgcolor="#CDCDCD" class="cits_common_text_bold">



                                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td><input type="button" value="Update" onClick="doUpdate()" class="cits_custom_button">                             </td>
                                                                                                                                                            <td width="5"></td>
                                                                                                                                                            <td><input type="button" name="btnClear" id="btnClear" value="Clear" class="cits_custom_button" onClick="clearRecords()"/>                                                            </td></tr>
                                                                                                                                                    </table>

                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                        </table>                                                                                                            </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>                                                                                            </td>
                                                                                                                </tr>

                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>

                                                                                                            <%                                                                                                                }
                                                                                                            %>                                                                                </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                </table>
                                                                                            </form>                                                                </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">                                                                </td>
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
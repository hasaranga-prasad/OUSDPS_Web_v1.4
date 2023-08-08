<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.reportmap.*" errorPage="../../../error.jsp"%>
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

    Collection<Bank> colSrcBank = null;
    Collection<Bank> colDesBank = null;

    String isReq = null;


    String cmbSrcBankCode = null;
    String cmbDesBankCode = null;
    String cmbSelSession = null;
    String cmbSelStatus = null;

    String srcBankCode = null;
    String srcFilename = null;
    String desBankCode = null;
    String desFilename = null;
    String selSession = null;
    String rmpCurrentStatus = null;
    String rmpCurrentStatusDesc = null;
    String rmpNewStatus = null;
    String rmpNewStatusDesc = null;


    String msg = null;
    boolean result = false;

    colSrcBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);
    colDesBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        cmbSrcBankCode = (String) request.getParameter("hdnCmbSrcBank");
        cmbDesBankCode = (String) request.getParameter("hdnCmbDesBank");
        cmbSelSession = (String) request.getParameter("hdnCmbSession");
        cmbSelStatus = (String) request.getParameter("hdnCmbStatus");

        srcBankCode = (String) request.getParameter("hdnSrcBank");
        srcFilename = (String) request.getParameter("hdnSrcFileName");
        desBankCode = (String) request.getParameter("hdnDesBank");
        desFilename = (String) request.getParameter("hdnDesFileName");
        selSession = (String) request.getParameter("hdnSelSession");
        rmpCurrentStatus = (String) request.getParameter("hdnCurrentStatus");
        rmpNewStatus = LCPL_Constants.status_all;

        if (rmpCurrentStatus != null)
        {
            if (rmpCurrentStatus.equals(LCPL_Constants.status_active))
            {
                rmpCurrentStatusDesc = "Active";
            }
            else if (rmpCurrentStatus.equals(LCPL_Constants.status_deactive))
            {
                rmpCurrentStatusDesc = "Inactive";
            }
            else
            {
                rmpCurrentStatusDesc = "n/a";
            }
        }
        else
        {
            rmpCurrentStatusDesc = "n/a";
        }

        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_reportmap_maintenance_modify_reportmap_details_selection, "| Source Bank - " + srcBankCode + ", Source File Name - " + srcFilename + ", Destination Bank - " + desBankCode + ", Session - " + selSession + ", Destination File Name - " + srcFilename + ", Status - " + rmpCurrentStatusDesc + " | Selected By - " + userName + " (" + userTypeDesc + ") |"));


    }
    else if (isReq.equals("1"))
    {

        cmbSrcBankCode = (String) request.getParameter("cmbSrcBank");
        cmbDesBankCode = (String) request.getParameter("cmbDesBank");
        cmbSelSession = (String) request.getParameter("cmbSession");
        cmbSelStatus = (String) request.getParameter("cmbStatus");


        srcBankCode = (String) request.getParameter("hdnSrcBank");
        srcFilename = (String) request.getParameter("hdnSrcFileName");
        desBankCode = (String) request.getParameter("hdnDesBank");
        desFilename = (String) request.getParameter("hdnDesFileName");
        selSession = (String) request.getParameter("hdnSelSession");
        rmpCurrentStatus = (String) request.getParameter("hdnCurrentStatus");
        rmpNewStatus = (String) request.getParameter("cmbNewStatus");

        ReportMapDAO rmpDAO = DAOFactory.getReportMapDAO();
        ReportMap rmp = new ReportMap();

        rmp.setSrcBankCode(srcBankCode);
        rmp.setSrcFileName(srcFilename);
        rmp.setDesBankCode(desBankCode);
        rmp.setDesFileName(desFilename);
        rmp.setSession(selSession);
        rmp.setStatus(rmpNewStatus);
        rmp.setModifiedBy(userName);

        if (rmpCurrentStatus != null)
        {
            if (rmpCurrentStatus.equals(LCPL_Constants.status_active))
            {
                rmpCurrentStatusDesc = "Active";
            }
            else if (rmpCurrentStatus.equals(LCPL_Constants.status_deactive))
            {
                rmpCurrentStatusDesc = "Inactive";
            }
            else
            {
                rmpCurrentStatusDesc = "n/a";
            }
        }
        else
        {
            rmpCurrentStatusDesc = "n/a";
        }

        if (rmpNewStatus != null)
        {
            if (rmpNewStatus.equals(LCPL_Constants.status_active))
            {
                rmpNewStatusDesc = "Active";
            }
            else if (rmpNewStatus.equals(LCPL_Constants.status_deactive))
            {
                rmpNewStatusDesc = "Inactive";
            }
            else
            {
                rmpNewStatusDesc = "n/a";
            }
        }
        else
        {
            rmpNewStatusDesc = "n/a";
        }
        
        result = rmpDAO.updateReportMap(rmp);

        if (!result)
        {
            msg = rmpDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_reportmap_maintenance_modify_reportmap_details_confirmation, "| Source Bank - " + srcBankCode + ", Source File Name - " + srcFilename + ", Destination Bank - " + desBankCode + ", Session - " + selSession + ", Destination File Name - " + srcFilename + ", Status - (New :" + rmpNewStatusDesc + ", Old :" + rmpCurrentStatusDesc + ") | Process Status - Unsuccess (" + msg + ") | Added By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_reportmap_maintenance_modify_reportmap_details_confirmation, "| Source Bank - " + srcBankCode + ", Source File Name - " + srcFilename + ", Destination Bank - " + desBankCode + ", Session - " + selSession + ", Destination File Name - " + srcFilename + ", Status - (New :" + rmpNewStatusDesc + ", Old :" + rmpCurrentStatusDesc + ") | Process Status - Success | Added By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>
<html>
    <head>
        <title>OUSDPS Web - Add New Report Map</title>
        <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>

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

            function fieldValidation()
            {

            var cmbStatusVal = document.getElementById('cmbNewStatus').value;


            if(cmbStatusVal==null || cmbStatusVal=="<%=LCPL_Constants.status_all%>")
            {
            alert("Please select a New Status!");
            document.getElementById('cmbNewStatus').focus();
            return false;
            }
            else
            {
            return true;
            }

            }            


            function clearRecords()
            {

            document.getElementById('cmbNewStatus').selectedIndex = 0;

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


            function setRequestType(status) 
            {
            if(status) 
            {
            document.getElementById('hdnReq').value = "1";
            }
            else 
            {
            document.getElementById('hdnReq').value = "0";
            }
            }



            function doSubmit(val)
            {
            if(val==1)
            {
            setRequestType(true);

            if(fieldValidation())
            {                        
            document.frmModifyReportMap.action="ModifyReportMappingDetails.jsp";
            document.frmModifyReportMap.submit();
            }
            }
            else if(val==2)
            {
            setRequestType(true);

            document.frmModifyReportMap.action="ModifyReportMappingDetailsSearch.jsp";
            document.frmModifyReportMap.submit();
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
            str = str.replace(" ", "");
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

            function trim(str)
            {
            return str.replace(/^\s+|\s+$/g, "");
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Modify (Status Activate/Deactivate) Report Mapping Data</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text">
                                                                                            <form name="frmModifyReportMap" id="frmModifyReportMap" method="post">


                                                                                                <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                            <%

                                                                                                                if (isReq != null && isReq.equals("1"))
                                                                                                                {

                                                                                                                    if (result == true)
                                                                                                                    {
                                                                                                            %>
                                                                                                            <div id="displayMsg_success" class="cits_Display_Success_msg" >

                                                                                                                Report Mapping Details Modified(Status Activate/Deactivate) Sucessfully.


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >Report Mapping Details Modifying(Status Activate/Deactivate) Failed.- <span class="cits_error"><%=msg%></span></div>
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








                                                                                                            <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder">
                                                                                                                <tr>
                                                                                                                    <td>




                                                                                                                        <table border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td>

                                                                                                                                    <table border="0" cellspacing="1" cellpadding="3" align="center" >



                                                                                                                                        <tr >
                                                                                                                                            <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Source Bank  :  </td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text"><%=srcBankCode%><input type="hidden" name="hdnSrcBank" id="hdnSrcBank" value="<%=srcBankCode%>"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr >
                                                                                                                                            <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Source File Name :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text"><%=srcFilename%><input type="hidden" name="hdnSrcFileName"  id="hdnSrcFileName" value="<%=srcFilename%>"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr >
                                                                                                                                            <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Destination Bank :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text"><%=desBankCode%><input type="hidden" name="hdnDesBank" id="hdnDesBank" value="<%=desBankCode%>"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr >
                                                                                                                                            <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Destination File Name :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text"><%=desFilename%>
                                                                                                                                                <input type="hidden" name="hdnDesFileName" id="hdnDesFileName" value="<%=desFilename%>"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr >
                                                                                                                                            <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Session : </td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                <%=selSession%>
                                                                                                                                                <input type="hidden" name="hdnSelSession" id="hdnSelSession" value="<%=selSession%>"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text">Current Status :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text"><%=rmpCurrentStatusDesc%>
                                                                                                                                                <input type="hidden" name="hdnCurrentStatus" id="hdnCurrentStatus" value="<%=rmpCurrentStatus%>"></td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td align="right" bgcolor="#B3D5C0" class="cits_tbl_header_text">New Status <span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td align="left" bgcolor="#DFEFDE" class="cits_common_text"><select name="cmbNewStatus" id="cmbNewStatus" class="cits_field_border" <% if (isReq != null && isReq.equals("1") && !result)
                                                                                                                                                {%>onFocus="hideMessage_onFocus()" <%}%> <%=(isReq != null && isReq.equals("1") && result) ? "disabled" : ""%>>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_all%>" <%=(rmpNewStatus == null || rmpNewStatus.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>--Select Status --</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_active%>" <%=(rmpNewStatus != null && rmpNewStatus.equals(LCPL_Constants.status_active)) ? "selected" : ""%>>Active</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_deactive%>" <%=(rmpNewStatus != null && rmpNewStatus.equals(LCPL_Constants.status_deactive)) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                </select></td>
                                                                                                                                        </tr>

                                                                                                                                        <tr><td height="35" bgcolor="#CDCDCD"></td>
                                                                                                                                            <td align="right" valign="bottom" bgcolor="#CDCDCD">

                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="button" name="btnModify" id="btnModify" value="Modify" onClick="doSubmit(1)" class="cits_custom_button<%=(isReq != null && isReq.equals("1") && result) ? "_disabled":""%>" <%=(isReq != null && isReq.equals("1") && result) ? "disabled" : ""%> >                                                                                            </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /><input type="hidden" name="cmbSrcBank" id="cmbSrcBank" value="<%=cmbSrcBankCode%>" /><input type="hidden" name="cmbDesBank" id="cmbDesBank" value="<%=cmbDesBankCode%>" /><input type="hidden" name="cmbSession" id="cmbSession" value="<%=cmbSelSession%>" /><input type="hidden" name="cmbStatus" id="cmbStatus" value="<%=cmbSelStatus%>" /></td>
                                                                                                                                                        <td><input type="button" name="btnCancel" id="btnCancel" onClick="doSubmit(2)" value="<%=(isReq != null && isReq.equals("1") && result) ? "Back" : "Cancel"%>" class="cits_custom_button"/>                                                                                            </td></tr>
                                                                                                                                                </table>                                                                                </td></tr>
                                                                                                                                    </table>

                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>


                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>










                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>






                                                                                            </form>
                                                                                        </td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>

                                                                                        <td align="center" valign="top">


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

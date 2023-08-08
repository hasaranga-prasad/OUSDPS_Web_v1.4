<%--
    Document   : ComposeMessage
    Created on : Jan 12, 2012, 15:34:43 PM
    Author     : Dinesh
--%>
<%@page import="java.sql.*,java.util.*,java.io.*,java.text.SimpleDateFormat" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.message.CustomMsg" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.message.Recipient" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.header.MsgHeader" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.body.MsgBody" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.priority.MsgPriority" errorPage="../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../error.jsp"%>
<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>
<%
    String session_userName = null;
    String session_userType = null;
    String session_userTypeDesc = null;
    String session_bankCode = null;
    String session_bankName = null;
    String session_sbCode = null;
    String session_sbType = null;
    String session_branchId = null;
    String session_branchName = null;
    String session_menuId = null;
    String session_menuName = null;

    session_userName = (String) session.getAttribute("session_userName");

    if (session_userName == null || session_userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        session_userType = (String) session.getAttribute("session_userType");
        session_userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
        session_bankCode = (String) session.getAttribute("session_bankCode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");


%>
<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();

    String sMaxMsgLength = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_msg_max_length);
    int iMaxMsgLength = 500;

    try
    {
        iMaxMsgLength = Integer.parseInt(sMaxMsgLength);
    }
    catch (Exception e)
    {
        iMaxMsgLength = 500;
    }

    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, LCPL_Constants.status_yes);
%>
<%
    Collection<MsgPriority> colMsgPriority = null;
    Collection<Recipient> colMsgTo = null;

    colMsgPriority = DAOFactory.getMsgPriorityDAO().getPriorityDetails();
    colMsgTo = DAOFactory.getCustomMsgDAO().getAvailableFullRecipientList(session_userType, session_bankCode);

%>
<html>
    <head>
        <title>OUSDPS Web (Version 1.2.0 - 2018)</title>
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../../css/tcal.css" rel="stylesheet" type="text/css" />
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
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window != null ? window.getCutontimeHour() : null%>, <%=window != null ? window.getCutontimeMinutes() : null%>, <%=window != null ? window.getCutofftimeHour() : null%>, <%=window != null ? window.getCutofftimeMinutes() : null%>);
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

            function isInitReq(status) 
            {

            if(status)
            {
            document.getElementById('hdnInitReq').value = "1";
            }
            else
            {
            document.getElementById('hdnInitReq').value = "0";
            }
            }


            function Set_Length(obj)
            {
            if (obj.value.length<= <%=iMaxMsgLength%>)
            {

            document.getElementById('Count').value=(<%=iMaxMsgLength%> - obj.value.length);
            }

            return;
            }

            function Get_Length(obj)
            {
            if (obj.value.length><%=iMaxMsgLength%>) 
            {
            alert("Message Length is Over the Limit. Maximum is " + <%=iMaxMsgLength%> + " Characters.");
            obj.value= obj.value.substring(0,<%=iMaxMsgLength%>);		
            obj.focus();
            }

            return;
            }

            function MoveSelected(eSource,eTarget)
            {
            var eSourceObj = document.getElementById(eSource);
            var eTargetObj = document.getElementById(eTarget);

            var selectedOptions = new Array();
            var selectedOptionsIndex = 0;

            //var selectedIndex

            if(eTargetObj.length == 0)
            {                
            for (var i = 0; i < eSourceObj.length; i++)
            {
            if (eSourceObj.options[i].selected)
            {
            var newOpt = document.createElement("option");

            newOpt.text = eSourceObj.options[i].text;
            newOpt.value = eSourceObj.options[i].value;

            try
            {
            // for IE earlier than version 8
            eTargetObj.add(newOpt,eTargetObj.options[null]);
            }
            catch(e)
            {
            eTargetObj.add(newOpt,null);
            } 

            selectedOptions[selectedOptionsIndex] = i;
            selectedOptionsIndex++;
            }
            }
            }
            else
            {
            for (var i = 0; i < eSourceObj.length; i++)
            {
            if (eSourceObj.options[i].selected)
            {
            var newOpt = document.createElement("option");

            newOpt.text = eSourceObj.options[i].text;
            newOpt.value = eSourceObj.options[i].value;

            var index = getSortIndex(eTargetObj,eSourceObj.options[i].value);

            try
            {
            // for IE earlier than version 8
            if(index!=-1)
            {
            eTargetObj.add(newOpt,eTargetObj.options[index]);
            }
            else
            {
            eTargetObj.add(newOpt,eTargetObj.options[null]);
            }                        
            }
            catch(e)
            {
            if(index!=-1)
            {
            eTargetObj.add(newOpt,index);
            }
            else
            {
            eTargetObj.add(newOpt,null);                            
            }                        
            }

            selectedOptions[selectedOptionsIndex] = i;
            selectedOptionsIndex++;
            }
            }                
            }

            if(selectedOptions.length>0)
            {
            for(var j=0; j<selectedOptions.length; j++)
            {
            eSourceObj.remove(selectedOptions[j]-j);
            }
            }
            }

            function MoveAll(eSource,eTarget)
            {
            var eSourceObj = document.getElementById(eSource);
            var eTargetObj = document.getElementById(eTarget);

            if(eTargetObj.length == 0)
            {
            while(eSourceObj.length>0)
            {
            var newOpt = document.createElement("option");

            newOpt.text = eSourceObj.options[0].text;
            newOpt.value = eSourceObj.options[0].value;

            try
            {
            // for IE earlier than version 8
            eTargetObj.add(newOpt,eTargetObj.options[null]);
            }
            catch(e)
            {
            eTargetObj.add(newOpt,null);
            }                     

            eSourceObj.remove(0);
            }
            }
            else
            {
            while(eSourceObj.length>0)
            {
            var newOpt = document.createElement("option");

            newOpt.text = eSourceObj.options[0].text;
            newOpt.value = eSourceObj.options[0].value;

            var index = getSortIndex(eTargetObj,eSourceObj.options[0].value);

            try
            {
            // for IE earlier than version 8
            if(index!=-1)
            {
            eTargetObj.add(newOpt,eTargetObj.options[index]);
            }
            else
            {
            eTargetObj.add(newOpt,eTargetObj.options[null]);
            }

            }
            catch(e)
            {
            if(index!=-1)
            {
            eTargetObj.add(newOpt,index);
            }
            else
            {
            eTargetObj.add(newOpt,null);                            
            }                        
            }                     

            eSourceObj.remove(0);
            }                    
            }      

            }


            function getSortIndex(obj,val)
            {
            var index = -1;
            var valPart1 = val.substring(0,3);
            var valPart2 = val.substring(4);                

            if(parseInt(valPart2,10)==999)
            {
            for(var i=0; i<obj.length; i++)
            {
            if(parseInt(valPart1,10)<= parseInt(obj.options[i].value.substring(0,3),10))
            {
            index = i;
            break;
            }
            }   
            }
            else
            {
            for(var i=0; i<obj.length; i++)
            {   
            if(parseInt(valPart1,10)== parseInt(obj.options[i].value.substring(0,3),10))
            {
            if(parseInt(obj.options[i].value.substring(4),10)==999)                            
            {                           
            }
            else if(parseInt(valPart1+valPart2,10)< parseInt(obj.options[i].value.substring(0,3)+obj.options[i].value.substring(4),10))
            {
            index = i;
            break;
            }
            }
            else if(parseInt(valPart1,10)< parseInt(obj.options[i].value.substring(0,3),10))
            {                        
            index = i;
            break;
            }
            }                    
            }

            return index;
            }

            function Save()
            {
            document.getElementById('hdnSelectedRecipients').value = '';

            for (var cnt = 0; cnt < document.getElementById('mcmbToSelected').length; cnt++)
            {
            document.getElementById('hdnSelectedRecipients').value += document.getElementById('mcmbToSelected').options[cnt].value+'*';
            }

            document.getElementById('hdnSelectedRecipientCount').value=cnt;

            if (isempty(document.getElementById('txtSubject').value)) 
            {
            alert("Message Subject Can't be Blank.");
            document.getElementById('txtSubject').focus();
            return false;
            }
            if (document.getElementById('cmbPriority').value=='<%=LCPL_Constants.status_all%>') 
            {
            alert("Please Select a Priority Level.");
            document.getElementById('.cmbPriority').focus();
            return false;
            }                
            if (isempty(document.getElementById('txaMessage').value)) 
            {
            alert("Message Body Can't be Blank!");
            document.getElementById('txaMessage').focus();
            return false;
            }
            else if(document.getElementById('txaMessage').value.length > <%=iMaxMsgLength%>)
            {
            document.getElementById('txaMessage').value = document.getElementById('txaMessage').value.substring(1,<%=iMaxMsgLength%>);
            alert("Message Length is Over the Limit. Maximum is " + <%=iMaxMsgLength%> + " Characters.");
            document.getElementById('txaMessage').focus();
            return false;                
            }

            if (document.getElementById('hdnSelectedRecipients').value.length<1) {
            alert("Please Select Recipient(s) to Send the Message.");
            document.getElementById('mcmbToOriginal').focus();
            return false;
            }           


            if(confirm("Are You Sure You Want To Send The Message to Selected Recipient/s?"))
            {
            document.frmComposeMsg.action="SendMessages.jsp";
            document.frmComposeMsg.submit();
            return true;
            }
            else
            {
            document.getElementById('hdnSelectedRecipients').value = '';
            return false;
            }
            }

            function goBack()
            {
            document.frmComposeMsg.action="../homepage.jsp";
            document.frmComposeMsg.submit();
            }

            function Reset()
            {                
            document.getElementById('txtSubject').value = '';
            document.getElementById('cmbPriority').selectedIndex = 0;
            document.getElementById('txaMessage').value = '';
            document.getElementById('Count').value='<%=iMaxMsgLength%>';
            MoveAll('mcmbToSelected', 'mcmbToOriginal');
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
                <td align="center" valign="top" bgcolor="#FFFFFF" ><table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_bgRepeat_left">
                        <tr>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="95" class="cits_header_center"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_header_left">
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
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=session_menuName%>" vqp_uid0=<%=session_menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";
                                                                cdd__codebase<%=session_menuId%> = "<%=request.getContextPath()%>/js/";</script>
                                                                                                            <script language="JavaScript" vqptag="datafile" src="<%=request.getContextPath()%>/js/<%=session_menuName%>"></script>
                                                                                                            <script vqptag="placement" vqp_menuid="<%=session_menuId%>" language="JavaScript">create_menu(<%=session_menuId%>)</script>
                                                                                                        </div></td>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td align="right" valign="middle"><table height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td class="cits_menubar_text">Welcome :</td>
                                                                                                                <td width="5"></td>
                                                                                                                <td class="cits_menubar_text"><b><%=session_userName%></b> - <%=session_bankName%></td>
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
                                                                    </table></td>
                                                            </tr>
                                                        </table></td>
                                                </tr>
                                                <tr>
                                                    <td  height="470" align="center" valign="top" class="cits_bgCommon"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="24" align="right" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
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
                                                                <td align="center" valign="top"><table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text">Compose Message</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text"><form name="frmComposeMsg" id="frmComposeMsg" method="post" enctype="multipart/form-data">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" align="center">
                                                                                                    <tr>
                                                                                                        <td align="center" valign="top"><table border="0" cellspacing="1" cellpadding="3" >
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >To <span class="cits_common_text">(Recipient/s)</span> :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" ><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top"><select name="mcmbToOriginal" size="<%=(session_userType.equals(LCPL_Constants.user_type_bank_user) || session_userType.equals(LCPL_Constants.user_type_lcpl_administrator) || session_userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator)) ? "0" : (colMsgTo != null && !colMsgTo.isEmpty()) ? colMsgTo.size() : "0"%>" multiple class="cits_field_border" id="mcmbToOriginal" <%=(session_userType.equals(LCPL_Constants.user_type_bank_user) || session_userType.equals(LCPL_Constants.user_type_lcpl_administrator) || session_userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator)) ? "style='visibility:hidden'" : ""%> >
                                                                                                                                        <%  if (colMsgTo != null && !colMsgTo.isEmpty())
                                                                                                                                            {
                                                                                                                                                for (Recipient recipient : colMsgTo)
                                                                                                                                                {

                                                                                                                                        %>
                                                                                                                                        <option value="<%=recipient.getRecipientCode()%>"><%=recipient.getRecipientCode() + " - " + recipient.getRecipientName()%></option>
                                                                                                                                        <%

                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select></td>
                                                                                                                                <td width="5" align="center" valign="top">&nbsp;</td>
                                                                                                                                <td align="center" valign="top" class="cits_common_text">

                                                                                                                                    <% if (!(session_userType.equals(LCPL_Constants.user_type_bank_user) || session_userType.equals(LCPL_Constants.user_type_lcpl_administrator) || session_userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator)))
                                                                                                                                    { %>

                                                                                                                                    <table border="0" cellpadding="5" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" valign="middle"><input name="btnRightAll" id="btnRightAll" value=">>" type="button" onClick="MoveAll('mcmbToOriginal', 'mcmbToSelected')"  class="cits_custom_button" onMouseOver="cOn(this)" onMouseOut="cOut(this)"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" valign="middle"><input name="btnRight" id="btnRight" value=">" type="button" onClick="MoveSelected('mcmbToOriginal', 'mcmbToSelected')"  class="cits_custom_button" onMouseOver="cOn(this)" onMouseOut="cOut(this)"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" valign="middle"><input name="btnLeft" id="btnLeft" value="<" type="button" onClick="MoveSelected('mcmbToSelected', 'mcmbToOriginal')"  class="cits_custom_button" onMouseOver="cOn(this)" onMouseOut="cOut(this)"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" valign="middle"><input name="btnLeftAll" id="btnLeftAll" value="<<" type="button" onClick="MoveAll('mcmbToSelected', 'mcmbToOriginal')"  class="cits_custom_button" onMouseOver="cOn(this)" onMouseOut="cOut(this)"/></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                    <%  }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                                    9991 - LankaClear (Pvt) Ltd. 
                                                                                                                                    <% }%>

                                                                                                                                    <input type="hidden" name="hdnSelectedRecipients" id="hdnSelectedRecipients" >
                                                                                                                                    <input type="hidden" name="hdnSelectedRecipientCount" id="hdnSelectedRecipientCount" >                                                                                                                                </td>
                                                                                                                                <td width="5" align="right" valign="top">&nbsp;</td>
                                                                                                                                <td align="right" valign="top"><select name="mcmbToSelected" size="<%=(session_userType.equals(LCPL_Constants.user_type_bank_user) || session_userType.equals(LCPL_Constants.user_type_lcpl_administrator) || session_userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator)) ? "0" : (colMsgTo != null && !colMsgTo.isEmpty()) ? colMsgTo.size() : "0"%>" multiple class="cits_field_border" id="mcmbToSelected" <%=(session_userType.equals(LCPL_Constants.user_type_bank_user) || session_userType.equals(LCPL_Constants.user_type_lcpl_administrator) || session_userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator)) ? "style='visibility:hidden'" : ""%>>

                                                                                                                                        <% if (session_userType.equals(LCPL_Constants.user_type_bank_user) || session_userType.equals(LCPL_Constants.user_type_lcpl_administrator) || session_userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator))
                                                                                                                                    {%>

                                                                                                                                        <option value="<%=LCPL_Constants.default_bank_code%>"><%=LCPL_Constants.default_bank_code + " - LankaClear (Pvt) Ltd."%></option> <%  } %>
                                                                                                                                    </select>                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" > Subject : </td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" ><input name="txtSubject" type="text" class="cits_field_border" id="txtSubject" size="60" maxlength="40"/></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Priority : </td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" ><%

                                                                                                                        try
                                                                                                                        {


                                                                                                                        %>
                                                                                                                        <select name="cmbPriority" class="cits_field_border" id="cmbPriority" >
                                                                                                                            <option value="<%=LCPL_Constants.status_all%>" >-Select-</option>
                                                                                                                            <%

                                                                                                                                if (colMsgPriority != null && !colMsgPriority.isEmpty())
                                                                                                                                {

                                                                                                                                    for (MsgPriority msgPriority : colMsgPriority)
                                                                                                                                    {

                                                                                                                            %>
                                                                                                                            <option value="<%=msgPriority.getPriorityLevel()%>" ><%=msgPriority.getPriorityDesc()%></option>
                                                                                                                            <%

                                                                                                                                }


                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                        <%                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span class="cits_error">No priority details available.</span>
                                                                                                                        <%                            }

                                                                                                                            }
                                                                                                                            catch (Exception e)
                                                                                                                            {
                                                                                                                                System.out.println(e.getMessage());
                                                                                                                            }


                                                                                                                        %>                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text" > Message : </td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE" ><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><textarea cols="80" rows="4" name="txaMessage" id="txaMessage" class="cits_field_border" onKeydown="Get_Length(this.form.txaMessage)" onKeyup="Set_Length(this.form.txaMessage)"></textarea>                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td valign="top"><span title="Characters Left">
                                                                                                                                        <input name="Count" type="text" class="cits_field_border" id="Count"  value="<%=iMaxMsgLength%>" maxlength="5" readonly size="1" disabled >
                                                                                                                                    </span></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Attachement :</td>
                                                                                                                    <td align="left" valign="middle" bgcolor="#DFEFDE"  class="cits_common_text"><input name="attachedFile" id="attachedFile" type="file" class="cits_field_border"  size="75" >
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td align="center" valign="middle" bgcolor="#CECED7" colspan="2"><table border="0" align="center" cellpadding="3" cellspacing="1">
                                                                                                                            <tr>
                                                                                                                                <td><input name="btnSave" id="btnSave" value="Send" type="button" onClick="Save()"  class="cits_custom_button"/></td>
                                                                                                                                <td><input name="btnReset" id="btnReset" value="Reset" type="button" onClick="Reset()" class="cits_custom_button"/></td>
                                                                                                                                <td><input name="btnCancel" id="btnCancel" value="Cancel" type="button" onClick="goBack()"  class="cits_custom_button"/></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                </table>
                                                                                            </form></td>
                                                                                        <td width="10"></td>
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
                                            </table></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table></td>
            </tr>
            <tr>
                <td height="35" class="cits_footter_center"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_left">
                        <tr>
                            <td height="35"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_right">
                                    <tr>
                                        <td height="35"><table width="100%" height="35" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="25"></td>
                                                    <td align="center" class="cits_copyRight">&copy; 2015 LankaClear. All rights reserved.| Contact Us: +94 11 2356900 | info@lankaclear.com</td>
                                                    <td width="25"></td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table></td>
            </tr>
        </table>
    </body>
</html>
<%    }
%>

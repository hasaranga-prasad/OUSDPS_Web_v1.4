
<%@page import="java.sql.*,java.util.*,java.io.*,java.text.SimpleDateFormat" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.message.CustomMsg" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.message.Recipient" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.header.MsgHeader" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.body.MsgBody" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.message.priority.MsgPriority" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../error.jsp"%>
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

    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, LCPL_Constants.status_yes);
%>
<%
    String msgId = (String) request.getParameter("msgId");
    String msgHeaderFromBank = (String) request.getParameter("msgHeaderFromBank");
    String msgGrandParentId = (String) request.getParameter("msgGrandParentId");
    String reqPage = (String) request.getParameter("reqPage");
    String isAlreadyRed = (String) request.getParameter("isAlreadyRed");
    String replySubject = "";

    String hdnMsgFromBranch = (String) request.getParameter("hdnMsgFromBank");
    String hdnPriority = (String) request.getParameter("hdnPriority");
    String hdnReadStatus = (String) request.getParameter("hdnReadStatus");
    String hdnFromDate = (String) request.getParameter("hdnFromDate");
    String hdnToDate = (String) request.getParameter("hdnToDate");

    System.out.println("msgHeaderFromBank ---> " + msgHeaderFromBank);

    long lMsgId = -1;
    long lMsgGrandParentId = -1;

    try
    {
        lMsgId = Long.parseLong(msgId);
        lMsgGrandParentId = Long.parseLong(msgGrandParentId);
    }
    catch (Exception e)
    {
        lMsgId = -1;
        lMsgGrandParentId = -1;
    }

    if (isAlreadyRed.equals(LCPL_Constants.msg_isred_no))
    {
        if (!DAOFactory.getCustomMsgDAO().setIsRedStatus(lMsgId, session_bankCode, true, session_userName))
        {
            //System.out.println("IsRed Status updation unsuccessful for the msgID - " + msgId + "  msgTo - " + session_branchId + "  redBy - " + session_userName);
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_view_recived_msg_details, "| Message ID - " + msgId + ", Message Grand Parent Id - " + msgGrandParentId + " New Message read status update - Unsuccess | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_view_recived_msg_details, "| Message ID - " + msgId + ", Message Grand Parent Id - " + msgGrandParentId + " New Message read status update - Success | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }
    else
    {
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_view_recived_msg_details, "| Message ID - " + msgId + ", Message Grand Parent Id - " + msgGrandParentId + " Message Aleardy Read - Yes | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));
    }

    //boolean isOkToReply = DAOFactory.getCustomMsgDAO().isOkToReply(lMsgId);
    //CustomMsg customMsgSelected = DAOFactory.getCustomMsgDAO().getMessageDetails(lMsgId, session_bankCode);
    Collection<CustomMsg> colMsgHistory = DAOFactory.getCustomMsgDAO().getMessageHistoryDetails(lMsgGrandParentId, session_bankCode);


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
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jspdf.debug.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/jspdf.min.js"></script> 
        <script language="JavaScript" type="text/JavaScript" src="<%=request.getContextPath()%>/js/html2canvas.js"></script> 

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



            function isInitReq(status) {

            if(status)
            {
            document.getElementById('hdnInitReq').value = "1";
            }
            else
            {
            document.getElementById('hdnInitReq').value = "0";
            }

            }

            function isSearchRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnSearchReq').value = "1";
            }
            }


            function Reply(seqId)
            {

            var elemId_hdnParentMsgId = 'hdn_parentMsgId_' + seqId;
            var elemId_hdnGrandParentMsgId = 'hdn_grandParentMsgId_' + seqId;
            var elemId_hdnReplyTo = 'hdn_replyTo_' + seqId;
            var elemId_hdnReplyToName = 'hdn_replyToName_' + seqId;
            var elemId_hdnReplySubject = 'hdn_replySubject_' + seqId;

            document.getElementById('hdn_parentMsgId').value = document.getElementById(elemId_hdnParentMsgId).value;
            document.getElementById('hdn_grandParentMsgId').value = document.getElementById(elemId_hdnGrandParentMsgId).value;
            document.getElementById('hdn_replyTo').value = document.getElementById(elemId_hdnReplyTo).value;
            document.getElementById('hdn_replyToName').value = document.getElementById(elemId_hdnReplyToName).value;
            document.getElementById('hdn_replySubject').value = document.getElementById(elemId_hdnReplySubject).value;

            document.frmBack.action = "ReplyMessage.jsp";
            document.frmBack.submit();
            }


            function formSubmit(seqId)
            {
            //var elemId_hdnReqPage = 'hdnReqPage';
            var actionPage = document.getElementById('hdnReqPage').value;

            document.frmBack.action = actionPage;
            document.frmBack.submit();
            }

            function downloadFile(seqId)
            {                
            //var actionPage = document.getElementById('hdnReqPage').value;

            var elemId_hdnFileName = 'hdnFileName_' + seqId;
            var elemId_hdnFilePath = 'hdnFilePath_' + seqId;

            document.getElementById('hdnFileName').value = document.getElementById(elemId_hdnFileName).value;
            document.getElementById('hdnFilePath').value = document.getElementById(elemId_hdnFilePath).value;

            document.frmBack.action = "DownloadAttachment.jsp";
            document.frmBack.submit();
            }

            function doPrintAll()
            {
            this.expandAllMsg();

            var disp_setting="toolbar=yes,location=no,directories=no,menubar=no,"; 
            disp_setting+="scrollbars=no,width=750, height=550, left=0, top=0"; 

            var elemId = 'printAll';
            var content_vlue = document.getElementById(elemId).innerHTML; 

            var docprint = window.open("","",disp_setting); 
            docprint.document.open(); 
            docprint.document.write('<html><head><title>Message Trail</title><link href="../../css/cits.css" rel="stylesheet" type="text/css" />'); 
            //docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../../../js/tableenhance.js" />');
            docprint.document.write('</head><body onLoad="self.print();self.close()"><center>');          
            docprint.document.write(content_vlue);          
            docprint.document.write('</center></body></html>');
            docprint.document.close();
            docprint.focus(); 

            }





            function doPrint(seqId)
            { 
            var disp_setting="toolbar=yes,location=no,directories=no,menubar=no,"; 
            disp_setting+="scrollbars=no,width=750, height=550, left=0, top=0"; 

            var elemId = 'printableArea_' + seqId;
            var content_vlue = document.getElementById(elemId).innerHTML; 

            var docprint = window.open("","",disp_setting); 
            docprint.document.open(); 
            docprint.document.write('<html><head><title>Message Details</title><link href="../../css/cits.css" rel="stylesheet" type="text/css" />'); 
            //docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../../../js/tableenhance.js" />');
            docprint.document.write('</head><body onLoad="self.print();self.close()"><center>');          
            docprint.document.write(content_vlue);          
            docprint.document.write('</center></body></html>');
            docprint.document.close();
            docprint.focus(); 

            }

            function loadDefaultMsg()
            {                
            var col2 = document.getElementsByClassName("collapsible");
            var defaultMsg = document.getElementById('hdnDefaultMsg').value;
            //alert('defaultMsg - ' + defaultMsg);
            col2[defaultMsg-1].click();
            }


            function expandAllMsg()
            {                
            var col3 = document.getElementsByClassName("collapsible");

            for(var k = 0; k < col3.length; k++)
            {
            if(col3[k].classList == 'collapsible')
            {
            col3[k].classList.toggle("active");
            var content = col3[k].nextElementSibling;                        
            content.style.maxHeight = content.scrollHeight + "px";
            }
            }

            }






            function dwMessageTrailPDF() 
            {
            this.expandAllMsg();

            var disp_setting="toolbar=yes,location=no,directories=no,menubar=no,"; 
            disp_setting+="scrollbars=no,width=750, height=550, left=0, top=0"; 

            var elemId = 'printAll';
            var content_vlue = document.getElementById(elemId).innerHTML; 

            var docprint = window.open("","",disp_setting); 
            //docprint.document.open(); 
            docprint.document.write('<html><head><title>Message Trail</title><link href="../../css/cits.css" rel="stylesheet" type="text/css" />'); 
            docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../js/jspdf.debug.js">');
            docprint.document.write('<'+'/'+'script>');
            docprint.document.write('<script language="JavaScript" type="text/javascript" src="../../js/html2canvas.js">');
            docprint.document.write('<'+'/'+'script>');
            docprint.document.write('<script language="javascript" type="text/JavaScript">');
            docprint.document.write('function dwPDF()');
            docprint.document.write('{');
            docprint.document.write('var doc = new jsPDF("p", "mm", "a4"); ');
            docprint.document.write('var options = {pagesplit: true, background: "#ffffff"}; ');
            docprint.document.write('doc.addHTML(document.body,options,function(){doc.save("MessageTrail.pdf");}); ');
            //docprint.document.write('window.open("", "_self", "").close(); ');
            docprint.document.write('}');
            docprint.document.write('<'+'/'+'script>'); 
            docprint.document.write('</head><body onLoad="dwPDF()"><center>');          
            docprint.document.write(content_vlue);          
            docprint.document.write('</center></body></html>');
            docprint.document.close();
            docprint.focus(); 
            //docprint.close();
            //setTimeout(docprint.close(),2000);



            }






        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="showClock(3);
    loadDefaultMsg()">
        <table style="min-width:980" height="600" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_bgRepeat_left">
                        <tr>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="95" class="cits_header_center">

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
                                                                                        <td align="left" valign="top" class="cits_header_text">Received Message Details</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="20" height="10"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">





                                                                                            <table border="0" cellpadding="0" cellspacing="0">






                                                                                                <tr>
                                                                                                    <td align="right" valign="top"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td><img name="pdfview" id="pdfview"src="<%=request.getContextPath()%>/images/dwPdf.png" width="22" height="22" title="Download Message Trail as a PDF" onClick="dwMessageTrailPDF()" style="cursor:pointer" /></td>
                                                                                                                <td width="10">&nbsp;</td>
                                                                                                                <td><img name="btnPrintAll" id="btnPrintAll" src="<%=request.getContextPath()%>/images/printer_large.png" width="24" height="22" title="Print Message Trail" onClick="doPrintAll()" style="cursor:pointer" /></td>
                                                                                                            </tr>
                                                                                                        </table>                                                                                                  </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td align="right" valign="top" height="5"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td align="center" valign="top">
                                                                                                        <div id="printAll">

                                                                                                            <!-- loop start -->

                                                                                                            <%
                                                                                                                if (colMsgHistory != null && colMsgHistory.size() > 0)
                                                                                                                {
                                                                                                                    int i = 0;
                                                                                                                    String msgPart = null;
                                                                                                                    for (CustomMsg customMsg : colMsgHistory)
                                                                                                                    {

                                                                                                                        if (customMsg != null)
                                                                                                                        {
                                                                                                                            boolean isOkTOLoad = false;

                                                                                                                            //System.out.println("customMsg.getMsgBody().getMsgToBank() ---> " + customMsg.getMsgBody().getMsgToBank());
                                                                                                                            if (!(session_userType.equals(LCPL_Constants.user_type_bank_user) || session_userType.equals(LCPL_Constants.user_type_settlement_bank_user)))
                                                                                                                            {
                                                                                                                                if (customMsg.getMsgHeader().getMsgFromBank().equals(LCPL_Constants.LCPL_bank_code))
                                                                                                                                {
                                                                                                                                //System.out.println("inside (customMsg.getMsgHeader().getMsgFromBank().equals(LCPL_Constants.LCPL_bank_code)) ---> ");

                                                                                                                                    if (customMsg.getMsgBody().getMsgToBank().equals(msgHeaderFromBank))
                                                                                                                                    {
                                                                                                                                        //System.out.println("inside (customMsg.getMsgBody().getMsgToBank().equals(msgHeaderFromBank)) ---> ");
                                                                                                                                        isOkTOLoad = true;
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    if (customMsg.getMsgBody().getMsgToBank().equals(LCPL_Constants.LCPL_bank_code))
                                                                                                                                    {
                                                                                                                                        if (customMsg.getMsgHeader().getMsgFromBank().equals(msgHeaderFromBank))
                                                                                                                                        {
                                                                                                                                            isOkTOLoad = true;
                                                                                                                                        }
                                                                                                                                    }

                                                                                                                                }
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            isOkTOLoad = true;
                                                                                                                            }

                                                                                                                            System.out.println("isOkTOLoad ---> " + isOkTOLoad);

                                                                                                                            if (isOkTOLoad == true)
                                                                                                                            {

                                                                                                                                i++;

                                                                                                                                MsgHeader msgHeader = customMsg.getMsgHeader();
                                                                                                                                MsgBody msgBody = customMsg.getMsgBody();
                                                                                                                                MsgPriority msgPriority = customMsg.getMsgPriority();


                                                                                                            %>

                                                                                                            <button class="collapsible"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                    <tr>
                                                                                                                        <td width="20" nowrap class="cits_msg_from">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                                                                        <td width="250" nowrap class="cits_msg_from"><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%> [<%=msgHeader.getCreatedBy()%>]</td>
                                                                                                                        <td width="5">&nbsp;</td>
                                                                                                                        <td align="left" class="cits_msg_subject"><%=msgHeader.getSubject()%></td>
                                                                                                                        <td width="5" >&nbsp;</td>
                                                                                                                        <td width="120" align="left" nowrap class="cits_common_text"><%=msgHeader.getCreatedTime()%></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </button>

                                                                                                            <div class="content">


<table border="0" cellspacing="0" cellpadding="0">
                                                                                                                    <tr>
                                                                                                                        <td>


                                                                                                                <table border="0" cellspacing="0" cellpadding="0" class="cits_table_boder" >
                                                                                                                    <tr>
                                                                                                                        <td><table border="0" cellspacing="0" cellpadding="0" style="min-width:800">

                                                                                                                                <tr>
                                                                                                                                    <td>
                                                                                                                                        <div id="printableArea_<%=i%>" >

                                                                                                                                            <table border="0" cellspacing="1" cellpadding="5" style="min-width:800">
                                                                                                                                                <tr>
                                                                                                                                                    <td width="75" align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">From  :</td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text"><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%></td>
                                                                                                                                                </tr>
                                                                                                                                                <tr>
                                                                                                                                                    <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">To  :</td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text"><%=msgBody.getMsgToBank()%> - <%=msgBody.getMsgToBankName()%></td>
                                                                                                                                                </tr>
                                                                                                                                                <tr>
                                                                                                                                                    <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Sent Time:</td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text"><%=msgHeader.getCreatedTime()%></td>
                                                                                                                                                </tr>
                                                                                                                                                <tr>
                                                                                                                                                    <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created By :</td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text"><%=msgHeader.getCreatedBy()%></td>
                                                                                                                                                </tr>
                                                                                                                                                <tr>
                                                                                                                                                    <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Subject :</td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text"><%=msgHeader.getSubject()%></td>
                                                                                                                                                </tr>
                                                                                                                                                <tr>
                                                                                                                                                    <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Message :</td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text" ><%=msgBody.getBody()!=null?msgBody.getBody().replaceAll("\\r\\n|\\r|\\n", "<br>"):"N/A" %></td>
                                                                                                                                                </tr>
                                                                                                                                                <tr>
                                                                                                                                                    <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Priority :</td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text" ><%=msgPriority.getPriorityDesc()%></td>
                                                                                                                                                </tr>
                                                                                                                                                <tr>
                                                                                                                                                    <td align="left" bgcolor="#B3D5C0" class="cits_tbl_header_text">Attachment : </td>
                                                                                                                                                    <td bgcolor="#E1E3EC" class="cits_common_text" ><% if (msgHeader.getAttachmentPath() != null)
                                                                                                                                                        {
                                                                                                                                                        %>
                                                                                                                                                        <input type="hidden" id="hdnFileName_<%=i%>" name="hdnFileName_<%=i%>" value="<%=msgHeader.getAttachmentOriginalName() != null ? msgHeader.getAttachmentOriginalName() : ""%>" />
                                                                                                                                                        <input type="hidden" id="hdnFilePath_<%=i%>" name="hdnFilePath_<%=i%>" value="<%=msgHeader.getAttachmentPath() != null ? msgHeader.getAttachmentPath() : ""%>" /> 

                                                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                            <tr>
                                                                                                                                                                <td ><input type="image" name="btnDwnReport" id="btnDwnReport" src="<%=request.getContextPath()%>/images/attachment.png" width="18"
                                                                                                                                                                            height="24" border="0" align="middle" title="Download Attachment" onClick="downloadFile(<%=i%>)"></td>
                                                                                                                                                                <td width="5">&nbsp;</td>
                                                                                                                                                                <td class="cits_common_text"><%=msgHeader.getAttachmentOriginalName()%></td>
                                                                                                                                                            </tr>
                                                                                                                                                        </table>


                                                                                                                                                        <% }
                                                                                                                                                        else
                                                                                                                                                        { %>N/A<% }%>                                                                                                                                                        </td>
                                                                                                                                                </tr>
                                                                                                                                            </table>
                                                                                                                                        </div>                                                                                                                  </td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td align="center" bgcolor="#D2DFD7">

                                                                                                                                <%
                                                                                                                                            if (msgHeader.getMsgId() == lMsgId)
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <input type="hidden" name="hdnDefaultMsg" id="hdnDefaultMsg" value="<%=i%>" />
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>


                                                                                                                                        <input type="hidden" name="hdn_parentMsgId_<%=i%>" id="hdn_parentMsgId_<%=i%>" value="<%=msgHeader.getMsgId()%>" />
                                                                                                                                        <input type="hidden" name="hdn_grandParentMsgId_<%=i%>" id="hdn_grandParentMsgId_<%=i%>" value="<%=msgHeader.getMsgGrandParentId()%>" />
                                                                                                                                        <input type="hidden" name="hdn_replyTo_<%=i%>" id="hdn_replyTo_<%=i%>" value="<%=msgHeader.getMsgFromBank()%>" />     
                                                                                                                                        <input type="hidden" name="hdn_replyToName_<%=i%>" id="hdn_replyToName_<%=i%>" value="<%=msgHeader.getMsgFromBankName()%>" />      



                                                                                                                                        <%

                                                                                                                                            if (msgHeader.getSubject() != null)
                                                                                                                                            {
                                                                                                                                                if (msgHeader.getSubject().trim().startsWith("Re: "))
                                                                                                                                                {
                                                                                                                                                    replySubject = msgHeader.getSubject().trim();
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                    replySubject = "Re: " + msgHeader.getSubject().trim();
                                                                                                                                                }
                                                                                                                                            }

                                                                                                                                        %>


                                                                                                                                        <input type="hidden" name="hdn_replySubject_<%=i%>" id="hdn_replySubject_<%=i%>" value="<%=replySubject%>" />
                                                                                                                                        <table width="100%" border="0" cellpadding="5" cellspacing="0">
                                                                                                                                            <tr>
                                                                                                                                                <td align="center"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                        <tr>
                                                                                                                                                            <td> 
                                                                                                                                                                <%

                                                                                                                                                                    boolean isOkToReply = false;
                                                                                                                                                                    if (session_userType.equals(LCPL_Constants.user_type_lcpl_administrator) || session_userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator))
                                                                                                                                                                    {
                                                                                                                                                                        isOkToReply = false;
                                                                                                                                                                    }
                                                                                                                                                                    else
                                                                                                                                                                    {
                                                                                                                                                                        isOkToReply = DAOFactory.getCustomMsgDAO().isOkToReply(msgHeader.getMsgId());
                                                                                                                                                                    }

                                                                                                                                                                    //System.out.println("isOkToReply - |" + isOkToReply + "| msgHeader.getMsgFromBank() - |" + msgHeader.getMsgFromBank() + "| session_bankCode - |" + session_bankCode + "|");
                                                                                                                                                                    if (isOkToReply && (!msgHeader.getMsgFromBank().equals(session_bankCode)))
                                                                                                                                                                    {
                                                                                                                                                                %>
                                                                                                                                                                <input name="btnBack" id="btnBack" value="Reply" type="button" onClick="Reply(<%=i%>)"  class="cits_custom_button"/> 
                                                                                                                                                                <%
                                                                                                                                                                    }
                                                                                                                                                                %>                                                                                                                                            </td>
                                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                                            <td><input name="btnBack" id="btnBack" value="Back" type="button" onClick="formSubmit(<%=i%>)"  class="cits_custom_button"/>                                                    </td>
                                                                                                                                                        </tr>
                                                                                                                                                    </table></td>
                                                                                                                                                <td width="5"><img name="btnPrint" id="btnPrint"src="<%=request.getContextPath()%>/images/printer2.png" width="18" height="18" title="Print" onClick="doPrint(<%=i%>)" style="cursor:pointer" /></td>
                                                                                                                                            </tr>
                                                                                                                                        </table>                                                                                                                              </td>
                                                                                                                          </tr>
                                                                                                                            </table>                                                                                                                    </td>
                                                                                                                    </tr>
                                                                                                                </table>                                                                                                                 </td>
                                                                                                                    </tr>
                                                                                                                    <tr>
                                                                                                                      <td height="5"></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                          </div> 

                                                                                                                <%
                                                                                                                    }
																													%>
                                                                                                                    
                                                                                                                    
                                                                                                                    <%
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                %>
                                                                                                                
                                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                    <tr>
                                                                                                                        <td class="cits_Display_Error_msg">Sorry ! No Records were found.                                                                                                                    </td>
                                                                                                                    </tr>
                                                                                                                    <tr>
                                                                                                                        <td align="center">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr>
                                                                                                                        <td align="center"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                <tr>
                                                                                                                                    <td><input name="btnBack" id="btnBack" value="Back" type="button" onClick="formSubmit(<%=i%>)"  class="cits_custom_button"/>                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table></td>
                                                                                                                    </tr>
                                                                                                                </table>



                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                               
                                                                                                            <%    }

                                                                                                                }
                                                                                                            %>

                                                                                                            <script>
                                                                                                                var coll = document.getElementsByClassName("collapsible");
                                                                                                                var i;

                                                                                                                for (i = 0; i < coll.length; i++) {
                                                                                                                    coll[i].addEventListener("click", function () {
                                                                                                                        this.classList.toggle("active");
                                                                                                                        var content = this.nextElementSibling;
                                                                                                                        if (content.style.maxHeight) {
                                                                                                                            content.style.maxHeight = null;
                                                                                                                        } else {
                                                                                                                            content.style.maxHeight = content.scrollHeight + "px";
                                                                                                                        }
                                                                                                                    });
                                                                                                                }
                                                                                                            </script>
                                                                                                        </div> <!-- print all div end -->

                                                                                                        <div id="editor"></div>


                                                                                                        <!-- loop end -->                                                                                                    </td>
                                                                                                </tr>








                                                                                                <form name="frmBack" id="frmBack" method="post">
                                                                                                    <tr> <td><input type="hidden" name="cmbMsgFromBank" id="cmbMsgFromBank" value="<%=hdnMsgFromBranch%>" />
                                                                                                            <input type="hidden" name="cmbPriority" id="cmbPriority" value="<%=hdnPriority%>" />                                                                                                          
                                                                                                            <input type="hidden" name="cmbReadStatus" id="cmbReadStatus" value="<%=hdnReadStatus%>" />
                                                                                                            <input type="hidden" name="txtFromSentDate" id="txtFromSentDate" value="<%=hdnFromDate%>" />
                                                                                                            <input type="hidden" name="txtToSentDate" id="txtToSentDate" value="<%=hdnToDate%>" />

                                                                                                            <input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="1" />
                                                                                                            <input type="hidden" name="hdnReqPage" id="hdnReqPage" value="<%=reqPage%>" />    
                                                                                                            <input type="hidden" name="hdn_parentMsgId" id="hdn_parentMsgId" />
                                                                                                            <input type="hidden" name="hdn_grandParentMsgId" id="hdn_grandParentMsgId" />
                                                                                                            <input type="hidden" name="hdn_replyTo" id="hdn_replyTo" />     
                                                                                                            <input type="hidden" name="hdn_replyToName" id="hdn_replyToName" />      
                                                                                                            <input type="hidden" name="hdnFileName" id="hdnFileName"  />
                                                                                                            <input type="hidden" name="hdnFilePath" id="hdnFilePath"  /> 
                                                                                                            <input type="hidden" name="hdn_replySubject" id="hdn_replySubject" />    
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </form>
                                                                                            </table>




                                                                                        </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15"></td>
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
                <td height="35" class="cits_footter_center">                  
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_left">
                        <tr>
                            <td height="35">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cits_footter_right">
                                    <tr>
                                        <td height="35">
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

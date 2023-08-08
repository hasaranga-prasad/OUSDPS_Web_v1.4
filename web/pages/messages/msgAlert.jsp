<%@page import="java.sql.*,java.util.*,java.io.*,java.text.SimpleDateFormat" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../error.jsp" %>


<%

    String session_userName = null;
    String session_userType = null;
    //String session_userTypeDesc = null;
    String session_bankCode = null;
    //String session_bankName = null;

    String isSessionExp = null;
    int newMessageCount = 0;
    int newHighPriorityMsgCount = 0;

    session_userName = (String) session.getAttribute("session_userName");
    session_userType = (String) session.getAttribute("session_userType");
    //session_userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
    session_bankCode = (String) session.getAttribute("session_bankCode");
    //session_bankName = (String) session.getAttribute("session_bankName");

    if (session_userName != null)
    {
        
//        System.out.println("msg alert page (session_userName) --> " + session_userName);
//        System.out.println("msg alert page (session_userType) --> " + session_userType);
//        System.out.println("msg alert page (session_bankCode)  --> " + session_bankCode);

        isSessionExp = "0";

        if (session_userType.equals(LCPL_Constants.user_type_lcpl_administrator))
        {
            newMessageCount = 0;
            newHighPriorityMsgCount = 0;
        }
        else
        {
            newMessageCount = DAOFactory.getCustomMsgDAO().getMessageCount(LCPL_Constants.status_all, session_bankCode, LCPL_Constants.status_all, LCPL_Constants.msg_isred_no, LCPL_Constants.status_all, LCPL_Constants.status_all);
            newHighPriorityMsgCount = DAOFactory.getCustomMsgDAO().getMessageCount(LCPL_Constants.status_all, session_bankCode, LCPL_Constants.msg_prioritylevel_high, LCPL_Constants.msg_isred_no, LCPL_Constants.status_all, LCPL_Constants.status_all);
        }
    }
    else
    {
        isSessionExp = "1";
    }

%>



<html>
    <head>
        <title>OUSDPS Web (Version 1.2.0 - 2018)</title>
        <!--meta http-equiv="refresh" content="30"-->
        
        <link href="../../css/cits.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript">

            function reloadPage()
            {
                if (document.getElementById("hdnIsSessionExp").value == "0")
                {
                    setTimeout("location.reload(true);", 1200000);
                }
                else
                {
                    window.parent.location.reload();
                }
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="reloadPage();">
    <input type="hidden" id="hdnIsSessionExp" name="hdnIsSessionExp" value="<%=isSessionExp%>">
    <%
        if (newMessageCount > 0)
        {
    %>
    <table border="0" cellspacing="0" cellpadding="0" align="right">
        <tr>
            <td width="35"><a href="UnreadMessageSummary.jsp" target="_parent" title="Click Here to view messages."><img src="<%=request.getContextPath()%>/images/message_anim.gif" width="35" height="24" border="0" title="Click Here to view messages."></a></td>
            <td width="5"></td>
            <td valign="top" class="cits_menubar_text">You have <%=newMessageCount%> new message<%=newMessageCount > 1 ? "s." : "."%> <% if (newHighPriorityMsgCount > 0)
                {%> 
                <span class="cits_error">[<%=newHighPriorityMsgCount%> <%=newHighPriorityMsgCount > 1 ? "messages are" : "message is"%> High Priority!]</span> <% }%>  </td>
            <td width="15" align="right" valign="top" class="cits_menubar_text">|</td>
        </tr>
    </table>

    <%
        }
    %>

</body>
</html>

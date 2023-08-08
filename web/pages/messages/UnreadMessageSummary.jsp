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
    Collection<CustomMsg> colUnreadMsg = null;
    colUnreadMsg = DAOFactory.getCustomMsgDAO().getMessageList(LCPL_Constants.status_all, session_bankCode, LCPL_Constants.status_all, LCPL_Constants.msg_isred_no, LCPL_Constants.status_all, LCPL_Constants.status_all);

    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_view_new_msg_summary, "| New Message Summary | Result Count - " + colUnreadMsg.size() + " | Viewed By - " + session_userName + " (" + session_userTypeDesc + ") |"));

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

        <script>
            function Back()
            {
                document.BroadcastMessageList.action = "BroadcastMessageCriteria.jsp"
                document.BroadcastMessageList.submit();
            }

            function showClock(type)
            {
                if (type == 1)
                {
                    clock(document.getElementById('showText'), type, null);
                }
                else if (type == 2)
                {
                    var val = new Array(<%=serverTime%>);
                    clock(document.getElementById('showText'), type, val);
                }
                else if (type == 3)
                {
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window != null ? window.getCutontimeHour() : null%>, <%=window != null ? window.getCutontimeMinutes() : null%>, <%=window != null ? window.getCutofftimeHour() : null%>, <%=window != null ? window.getCutofftimeMinutes() : null%>);
                    clock(document.getElementById('showText'), type, val);
                }
            }


        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="showClock(3)">
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Inbox - Unread Message(s)</td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="15"></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10"></td>
                                                                                        <td align="center" valign="top" class="cits_header_text">



                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <%
                                                                                                    if (colUnreadMsg.isEmpty())
                                                                                                    {%>

                                                                                                <tr>
                                                                                                    <td class="cits_header_text" align="center"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td align="center"><div id="noresultbanner" class="cits_tbl_header_text">No Records Available !</div></td>
                                                                                                </tr>
                                                                                                <%   }
                                                                                                else
                                                                                                {
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td class="cits_header_text" align="center"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td><div id="resultdata">
                                                                                                            <table  border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                                <tr>
                                                                                                                    <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >From</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Subject</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Message</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Priority</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Attachment</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Created Time</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <%
                                                                                                                    int rowNum = 0;
                                                                                                                    String msgPart = null;
																													String msgSubjectPart = null;
																													
																													
                                                                                                                    for (CustomMsg customMsg : colUnreadMsg)
                                                                                                                    {
                                                                                                                        rowNum++;

                                                                                                                        MsgHeader msgHeader = customMsg.getMsgHeader();
                                                                                                                                    MsgBody msgBody = customMsg.getMsgBody();
                                                                                                                                    MsgPriority msgPriority = customMsg.getMsgPriority();

                                                                                                                                    if ((msgHeader != null) && (msgHeader.getSubject() != null))
                                                                                                                                    {
                                                                                                                                        if (msgHeader.getSubject().length() > 35)
                                                                                                                                        {
                                                                                                                                            msgSubjectPart = msgHeader.getSubject().substring(0, 31) + "....";
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            msgSubjectPart = msgHeader.getSubject();
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        msgSubjectPart = "";
                                                                                                                                    }

                                                                                                                                    if ((msgBody != null) && (msgBody.getBody() != null))
                                                                                                                                    {
                                                                                                                                        if (msgBody.getBody().length() > 25)
                                                                                                                                        {
                                                                                                                                            msgPart = msgBody.getBody().substring(0, 21) + "....";
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            msgPart = msgBody.getBody();
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        msgPart = "";
                                                                                                                                    }

                                                                                                                            %>

                                                                                                                <form name="frmMsgDetails" id="frmMsgDetails" action="MessageDetail.jsp" method="post">

                                                                                                                    <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">

                                                                                                                        <td align="right" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                                        <td align="left" bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>" class="cits_msg_from" ><%=msgHeader.getMsgFromBank()%> - <%=msgHeader.getMsgFromBankName()%> [<%=msgHeader.getCreatedBy()%>]</td>
                                                                                                                      <td align="left" class="cits_msg_subject"><%=msgSubjectPart %></td>
                                                                                                                        <td align="left" class="cits_common_text" ><%=msgPart %></td>
                                                                                                                      <td align="center" class="cits_common_text" ><%=msgPriority.getPriorityDesc()%></td>
                                                                                                                        <td align="center" class="cits_common_text">
																																	
																																	<% 
																																	if(msgBody.getIsRed().equals(LCPL_Constants.msg_isred_yes))
																																	{ %>
                                                                                                                                    
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/read_msg.png" width="25"
                                                                                                                                             height="20" border="0" align="middle" title="You have already read this messgae!" >
                                                                                                                                    
                                                                                                                                    <%
																																	} 
																																	else 
																																	{
																																	%>
                                                                                                                                    <img src="<%=request.getContextPath()%>/images/unread_msg.png" width="25"
                                                                                                                                             height="20" border="0" align="middle" title="Unread Message" >
                                                                                                                                    <%
																																	}
																																	%>                                                                                                                                    </td>
                                                                                                                        <td align="center" class="cits_header_text" >
                                                                                                                                        <% if (msgHeader.getAttachmentOriginalName() != null)
                                                                                                                                            {%>  <img src="<%=request.getContextPath()%>/images/attachment_small.png" width="16"
                                                                                                                                             height="20" border="0" align="middle" > <%  }%>                                                                                                                                    </td>
                                                                                                                      <td align="center" class="cits_common_text"><%=msgHeader.getCreatedTime() == null ? "N/A" : msgHeader.getCreatedTime()%></td>
                                                                                                                        <td align="center" class="cits_tbl_header_text">
                                                                                                                            
                                                                                                                            
                                                                                                                            <input type="hidden" name="msgId" id="msgId" value="<%=msgHeader.getMsgId()%>">
                                                                                                                            <input type="hidden" name="msgHeaderFromBank" id="msgHeaderFromBank" value="<%=msgHeader.getMsgFromBank()%>">
                                                                                                                            
                                                                                                                            <input type="hidden" name="msgParentId" id="msgParentId" value="<%=msgHeader.getMsgParentId()%>">
                                                                                                                            <input type="hidden" name="msgGrandParentId" id="msgGrandParentId" value="<%=msgHeader.getMsgGrandParentId()%>">
                                                                                                                            <input type="hidden" name="reqPage" id="reqPage" value="UnreadMessageSummary.jsp">
                                                                                                                            <input type="hidden" name="isAlreadyRed" id="isAlreadyRed" value="<%=msgBody.getIsRed()%>">
                                                                                                                            <input type="submit" name="btnRemarks" value="View" class="cits_custom_button_small">                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </form>


                                                                                                                <%}%>
                                                                                                            </table>
                                                                                                        </div></td>
                                                                                                </tr>
                                                                                                <%
                                                                                                    }
                                                                                                %>
                                                                                            </table>











                                                                                        </td>
                                                                                        <td width="10"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>

                                                                                        <td align="center" valign="top">&nbsp;</td>


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


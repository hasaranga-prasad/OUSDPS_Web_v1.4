<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.owdetails.OWDetails" errorPage="../../../../error.jsp"%>
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

        if (!userType.equals("3"))
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
    String bankCode = null;
    String branchCode = null;
    String winSess = null;
    String fromBusinessDate = null;
    String toBusinessDate = null;
    String fileID = null;
    //String batchNo = null;
    long totalRecordCount = 0;
    int totalPageCount = 0;
    int reqPageNo = 1;

    Collection<OWDetails> colResult = null;

    bankCode = (String) request.getParameter("hdnBank");
    branchCode = (String) request.getParameter("hdnBranch");
    winSess = (String) request.getParameter("hdnSession");
    fromBusinessDate = (String) request.getParameter("hdnFromBD");
    toBusinessDate = (String) request.getParameter("hdnToBD");

    if (request.getParameter("hdnReqPageNo") != null)
    {
        reqPageNo = Integer.parseInt(request.getParameter("hdnReqPageNo"));
    }


    fileID = (String) request.getParameter("hdnFileID");
    //batchNo = (String) request.getParameter("hdnBatchNo");

    totalRecordCount = DAOFactory.getOWDetailsDAO().getRecordCountOWDetails(fileID);

    if (totalRecordCount > 0)
    {
        totalPageCount = (int) Math.ceil((Double.parseDouble(String.valueOf(totalRecordCount))) / LCPL_Constants.noPageRecords);

        //System.out.print("totalPageCount ---> " + totalPageCount);	

        colResult = DAOFactory.getOWDetailsDAO().getOWDetails(fileID, reqPageNo, LCPL_Constants.noPageRecords);

        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_outward_details, "| File Id - " + fileID  + ", Page No. - " + reqPageNo + " | Record Count - " + colResult.size() + ", Total Record Count - " + totalRecordCount + " | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }
    else
    {
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_outward_details, "| File Id - " + fileID  + " | Total Record Count - 0 | Viewed By - " + userName + " (" + userTypeDesc + ") |"));
    }

%>
<html>
    <head>
        <title>OUSDPS Web - View Batch Details</title>
        <link href="../../../../css/cits.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="../../../../js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../../js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../../js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../../js/tableenhance.js"></script>
        <script language="javascript" type="text/JavaScript">


            function showClock(type)
            {
                if(type==1)
                {
                    clock(document.getElementById('showText'),type,null);
                }
                else if(type==2                 )
                {
                    var val = new Array(<%=serverTime%>);
                    clock(document.getElementById('showText'),type,val);
                }
                else if(type==3                 )
                {
                    var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window.getCutontimeHour()%>, <%=window.getCutontimeMinutes()%>, <%=window.getCutofftimeHour()%>, <%=window.getCutofftimeMinutes()%>);
                    clock(document.getElementById('showText'),type,val);

                }
            }
			
            function resetDates()
            {
                var from_elementId = 'txtFromBusinessDate';
                var to_elementId = 'txtToBusinessDate';
				
                document.getElementById(from_elementId).value = "<%=webBusinessDate%>";
                document.getElementById(to_elementId).value = "<%=webBusinessDate%>";
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
                else
                {
                    document.getElementById('hdnSearchReq').value = "0";
                }
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

                if(document.getElementById('clickSearch')!= null)
                {
                    document.getElementById('clickSearch').style.display='block';
                }

            }
			
            function setReqPageNoForCombo2()
            {
                document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo2').value;
                document.frmPageNavi.action="OWDetails.jsp";
                document.frmPageNavi.submit();
            }
			
            function setReqPageNoForCombo()
            {
                document.getElementById('hdnReqPageNo').value = document.getElementById('cmbPageNo').value;
                document.frmPageNavi.action="OWDetails.jsp";
                document.frmPageNavi.submit();
            }
			
            function setReqPageNo(no)
            {
                document.getElementById('hdnReqPageNo').value = no;
				
                document.frmPageNavi.action="OWDetails.jsp";
                document.frmPageNavi.submit();				
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
                                        <td align="center" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                                                    <td width="15">&nbsp;</td>
                                                    <td align="center" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td width="10">&nbsp;</td>
                                                                <td align="left" valign="top" class="cits_header_text">Batch Status (Outward Details)</td>
                                                                <td width="10">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td height="15"></td>
                                                                <td></td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td align="center" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td><table border="0" cellpadding="0" cellspacing="0">
                                                                                    <%
                                                                                        if (totalRecordCount == 0)
                                                                                        {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="15" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="noresultbanner" class="cits_header_small_text">No records Available !</div></td>
                                                                                    </tr>
                                                                                    <%   }
                                                                                    else if (colResult.size() > LCPL_Constants.maxWebRecords)
                                                                                    {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="15" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="noresultbanner" class="cits_error">Sorry! Details view prevented due to too many records. (Max Viewable Records Count - <%=LCPL_Constants.maxWebRecords%> , Current Records Count - <%=colResult.size()%>, This can be lead to memory overflow in your machine.)</div></td>
                                                                                    </tr>
                                                                                    <%}
                                                                                    else
                                                                                    {
                                                                                    %>
                                                                                    <tr>
                                                                                        <td height="10" align="center" class="cits_header_text"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center"><div id="resultdata">







                                                                                                <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td align="right">
                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print"><form name="frmPageNavi" id="frmPageNavi" method="post" target="_self">
                                                                                                          <tr bgcolor="#DFE0E1">
                                                                                                            <td align="right" bgcolor="#D7D7D7"><table border="0" cellspacing="0" cellpadding="2">
                                                                                                                    <tr>
                                                                                                                        <td class="cits_common_text">
                                                                                                                            <input type="hidden" id="hdnBank" name="hdnBank" value="<%=bankCode%>" />
                                                                                                                            <input type="hidden" id="hdnSession" name="hdnSession" value="<%=winSess%>" />
                                                                                                                            <input type="hidden" id="hdnFromBD" name="hdnFromBD" value="<%=fromBusinessDate%>" />                                                                                                              
                                                                                                                            <input type="hidden" id="hdnBranch" name="hdnBranch" value="<%=branchCode%>" />
                                                                                                                            <input type="hidden" id="hdnToBD" name="hdnToBD" value="<%=toBusinessDate%>" />
                                                                                                                            <input type="hidden" id="hdnFileID" name="hdnFileID" value="<%=fileID%>" />

                                                                                                                                                                                                               
                                                                                                                            <input type="hidden" id="hdnReqPageNo" name="hdnReqPageNo" value="<%=reqPageNo%>" />                                                                                                                        </td>
                                                                                                                        <td align="right" valign="middle" class="cits_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                        <td width="15"></td>
                                                                                                                        <td align="center" valign="middle">
                                                                                                                        <%
                                                                                                                            if (reqPageNo == 1)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16" title="First Page" /> 													<%                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                      <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                    <td align="center" valign="middle">
                                                                                                                        <%
                                                                                                                            if (reqPageNo == 1)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>

                                                                                                                      <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                    <td width="2"></td>
                                                                                                                    <td><select class="cits_field_border_number" name="cmbPageNo" id="cmbPageNo" onChange="setReqPageNoForCombo()">
                                                                                                                            <%
                                                                                                                                for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                {
                                                                                                                            %>
                                                                                                                            <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                  <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select></td>
                                                                                                                    <td width="2"></td>
                                                                                                                    <td>
                                                                                                                        <%
                                                                                                                            if (reqPageNo == totalPageCount)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                        <%}
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                      <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)" /><%}%> </td>
                                                                                                                    <td>
                                                                                                                        <%
                                                                                                                            if (reqPageNo == totalPageCount)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                      <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                    <td width="5"></td>
                                                                                                                    </tr>
                                                                                                                </table></td>
                                                                                                          </tr>
                                                                                                          </form>
                                                                                                        </table>                                                                                                                                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                      <td align="center" height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center"><table  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" class="cits_table_boder">
                                                                                                                <tr>
                                                                                                                    <td align="right" bgcolor="#B3D5C0"></td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Business<br/>
                                                                                                                        Date</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Ses.</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">File ID</td>
                                                                                                                    <!--td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Out.<br/>Bk-Br</td-->
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Org.<br/>
                                                                                                                        Bk-Br</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Org.<br/>
                                                                                                                        Acc. No.</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Org.<br/>
                                                                                                                        Acc. Name</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Des.<br/>Bk-Br</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Des.<br/>Acc. No.</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Des.<br/>Acc. Name</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >TC</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >RC</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Value<br/>Date</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Org.<br/>Rt. Date</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Cur.<br/>
                                                                                                                        Code</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Amount</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Part.</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text" >Ref.</td>
                                                                                                                </tr>
                                                                                                                <%
                                                                                                                    int rowNum = 0 + ((reqPageNo - 1) * LCPL_Constants.noPageRecords);
                                                                                                                    //int itemCountCredit = 0;
                                                                                                                    //int itemCountDebit = 0;

                                                                                                                    long totalAmount = 0;
                                                                                                                    //long totalAmountDebit = 0;

                                                                                                                    for (OWDetails owdetails : colResult)
                                                                                                                    {
                                                                                                                        rowNum++;

                                                                                                                        //itemCountCredit += owdetails.getItemCountCredit();
                                                                                                                        //itemCountDebit += owdetails.getItemCountDebit();
                                                                                                                        totalAmount += owdetails.getAmount();
                                                                                                                        //totalAmountCredit += owdetails.getAmountCredit();
                                                                                                                %>
                                                                                                                                                                                                        <!--form action="" id="frmRemarks_<%=rowNum%>" name="frmRemarks_<%=rowNum%>" method="post" target="_self"-->
                                                                                                                <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>"  onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                    <td align="right" class="cits_common_text" ><%=rowNum%>.</td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getBusinessDate()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getSession()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getFileId()%></td>
                                                                                                                    <!--td align="center"  class="cits_common_text"><%=owdetails.getOwBank()%>-<%=owdetails.getOwBranch()%></td-->
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getOrgBankCode()%>-<%=owdetails.getOrgBranchCode()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getOrgAcNoDec()%></td>
                                                                                                                    <td  class="cits_common_text"><%=owdetails.getOrgAcNameDec()%></td>
                                                                                                                  <td align="center"  class="cits_common_text"><%=owdetails.getDesBankCode()%>-<%=owdetails.getDesBranchcode()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getDesAcNoDec()%></td>
                                                                                                                    <td  class="cits_common_text"><%=owdetails.getDesAcNameDec()%></td>
                                                                                                                  <td align="center"  class="cits_common_text"><%=owdetails.getTc()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getRc()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getValueDate()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getCurrentDate() %></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getCurrencyCode()%></td>
                                                                                                                    <td align="right"  class="cits_common_text"><%=new DecimalFormat("#0.00").format((new Long(owdetails.getAmount()).doubleValue()) / 100)%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getParticulars()%></td>
                                                                                                                    <td align="center"  class="cits_common_text"><%=owdetails.getInstruction() %></td>
                                                                                                                </tr>
                                                                                                                <!--/form-->
                                                                                                                <%
                                                                                                                    }

                                                                                                                %>
                                                                                                                <tr  class="cits_common_text">
                                                                                                                    <td height="20" align="right" bgcolor="#B3D5C0" ></td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <!--td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td-->
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">Total</td>
                                                                                                                    <td align="right" bgcolor="#B3D5C0" class="cits_common_text_bold"><%=new DecimalFormat("#0.00").format((new Long(totalAmount).doubleValue()) / 100)%></td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                    <td align="center" bgcolor="#B3D5C0" class="cits_common_text_bold">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="right">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="cits_table_boder_print">
                                                                                                          <tr bgcolor="#DFE0E1">
                                                                                                            <td align="right" bgcolor="#D7D7D7"><table border="0" cellspacing="0" cellpadding="2">
                                                                                                                <tr>
                                                                                                                    <td align="right" valign="middle" class="cits_common_text"> Page <%=reqPageNo%> of <%=totalPageCount%>.</td>
                                                                                                                    <td width="15"></td>
                                                                                                                    <td align="center" valign="middle">
                                                                                                                        <%
                                                                                                                            if (reqPageNo == 1)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/firstPageDisabled.gif" width="16" height="16"  /> 													<%                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>
                                                                                                                  <input type="image" src="<%=request.getContextPath()%>/images/firstPage.gif" width="16" height="16" title="First Page" onClick="setReqPageNo(1)" /><%}%>  </td>
                                                                                                                    <td align="center" valign="middle">
                                                                                                                        <%
                                                                                                                            if (reqPageNo == 1)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/prevPageDisabled.gif" width="16" height="16" /><%                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                        %>

                                                                                                                  <input type="image" src="<%=request.getContextPath()%>/images/prevPage.gif" width="16" height="16" title="Previous Page" onClick="setReqPageNo(<%=(reqPageNo - 1)%>)"/> <%}%> </td>
                                                                                                                    <td width="2"></td>
                                                                                                                    <td><select class="cits_field_border_number" name="cmbPageNo2" id="cmbPageNo2" onChange="setReqPageNoForCombo2()">
                                                                                                                            <%
                                                                                                                                for (int i = 1; i <= totalPageCount; i++)
                                                                                                                                {
                                                                                                                            %>
                                                                                                                            <option value="<%=i%>" <%=i == reqPageNo ? "selected" : ""%>><%=i%></option>
                                                                                                                  <%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                        </select></td>
                                                                                                                    <td width="2"></td>
                                                                                                                    <td>
                                                                                                                        <%
                                                                                                                            if (reqPageNo == totalPageCount)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/nextPageDisabled.gif" width="16" height="16" />
                                                                                                                        <%}
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                  <input type="image" src="<%=request.getContextPath()%>/images/nextPage.gif" width="16" height="16" title="Next Page" onClick="setReqPageNo(<%=(reqPageNo + 1)%>)"/><%}%> </td>
                                                                                                                    <td>
                                                                                                                        <%
                                                                                                                            if (reqPageNo == totalPageCount)
                                                                                                                            {
                                                                                                                        %>
                                                                                                                        <img src="<%=request.getContextPath()%>/images/lastPageDisabled.gif" width="16" height="16" /><% }
                                                                                                                        else
                                                                                                                        {%>
                                                                                                                  <input type="image" src="<%=request.getContextPath()%>/images/lastPage.gif" width="16" height="16" title="Last Page" onClick="setReqPageNo(<%=totalPageCount%>)"/><%}%> </td>
                                                                                                                    <td width="5"></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                          </tr>
                                                                                                          
                                                                                                        </table>

                                                                                                                                                                                                                    </td>
                                                                                                    </tr>
                                                                                                </table>



                                                                                            </div></td>
                                                                                    </tr>
                                                                                    <%
                                                                                        }
                                                                                    %>
                                                                                    <tr><td height="10"></td>
                                                                                    </tr>
                                                                                    <tr><td align="center"><form action="FileStat.jsp" name="frmBack" id="frmBack"  method="post" target="_self" >
                                                                                                <input type="hidden" name="hdnSearchReq" id="hdnSearchReq" value="1" />
                                                                                                <input type="hidden" id="cmbBank" name="cmbBank" value="<%=bankCode%>" />
                                                                                                <input type="hidden" id="cmbSession" name="cmbSession" value="<%=winSess%>" />
                                                                                                <input type="hidden" id="txtFromBusinessDate" name="txtFromBusinessDate" value="<%=fromBusinessDate%>" />                                                                                                              
                                                                                                <input type="hidden" id="cmbBranch" name="cmbBranch" value="<%=branchCode%>" />
                                                                                                <input type="hidden" id="txtToBusinessDate" name="txtToBusinessDate" value="<%=toBusinessDate%>" />
                                                                                                <input type="submit" name="btnView" id="btnView" value="  Back  " class="cits_custom_button" >
                                                                                            </form></td></tr>


                                                                                </table></td>
                                                                        </tr>
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

<%@page import="java.util.*,java.sql.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.purposecode.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.subpurposecode.*" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.batch.CustomBatch" errorPage="../../../../error.jsp" %>
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

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(sessionBankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
%>
<%
    String isReq = null;
    String purCode = null;
    String spCode = null;
    String subPC_Desc = null;
    String status = null;
    String msg = null;
    boolean result = false;

    Collection<PurposeCode> col_pc = DAOFactory.getPurposeCodeDAO().getPurposeCodesDetails(LCPL_Constants.status_all);

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "0";
    }
    else if (isReq.equals("1"))
    {
        purCode = (String) request.getParameter("cmbPC");
        spCode = (String) request.getParameter("txtSPC");
        subPC_Desc = (String) request.getParameter("txtDesc");
        status = (String) request.getParameter("cmbStatus");

        SubPurposeCodeDAO spcDAO = DAOFactory.getSubPurposeCodeDAO();

        result = spcDAO.addSubPurposeCode(new SubPurposeCode(purCode, spCode, subPC_Desc.trim(), status, userName));

        if (!result)
        {
            msg = spcDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_purposecode_maintenance_add_subpurpose_code, "| Bank Code - " + purCode + ", Branch Code - " + spCode + ", Branch Name - " + subPC_Desc + " | Process Status - Unsuccess (" + msg + ") | Added By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_purposecode_maintenance_add_subpurpose_code, "| Bank Code - " + purCode + ", Branch Code - " + spCode + ", Branch Name - " + subPC_Desc + " | Process Status - Success | Added By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>

<html>
    <head><title>OUSDPS Web - Add Branch</title>
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

            function clearRecords_onPageLoad()
            {
            document.getElementById('txtSPC').setAttribute("autocomplete","off");
            document.getElementById('txtDesc').setAttribute("autocomplete","off");

            showClock(3);
            }

            function clearRecords()
            {
            document.getElementById('cmbPC').selectedIndex="0";
            document.getElementById('txtSPC').value="";
            document.getElementById('txtDesc').value="";
            document.getElementById('cmbStatus').selectedIndex="0";
            }


            function fieldValidation()
            {
            var selPC = document.getElementById('cmbPC').value;
            var subPC = document.getElementById('txtSPC').value;
            var spcDesc = document.getElementById('txtDesc').value;
            var status = document.getElementById('cmbStatus').value;


            var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
            var numbers = /^[0-9]*$/;


            if(selPC==null || selPC=="-1")
            {
				alert("Select Purpose Code!");
				document.getElementById('cmbPC').focus();
				return false;
            }

            if(isempty(subPC))
            {
				alert("Sub Purpose Code  can't be empty!");
				document.getElementById('txtSPC').focus();
				return false;
            }
            else if (!numbers.test(subPC)) 
            {
				alert("Sub Purpose Code must contain numbers only!");
				document.getElementById('txtSPC').focus();
				return false;
            }
            else if(subPC.length!=2)
            {
				alert("Sub Purpose Code must contain 2 digits!");
				document.getElementById('txtSPC').focus();
				return false;
            }               

            if(isempty(spcDesc))
            {
            alert("Description can not be empty!");
            document.getElementById('txtDesc').focus();
            return false;
            }

            
            if(status==null || status=="-1")
            {
            alert("Please Select Status!");
            document.getElementById('cmbStatus').focus();
            return false;                   

            }
            else
            {
				document.frmNewSPC.action="AddSubPurposeCode.jsp";
				document.frmNewSPC.submit();                      
            }	

            }


            function isRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnReq').value = "1";
            }
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


            function doSubmit()
            {
            isRequest(true);                    
            fieldValidation();			
            }


            function IsNumeric(strString)
            {
            // var strString=document.BranchDataUploader.NoofCDs.value;
            var strValidChars = "0123456789";
            var strChar;
            var blnResult = true;

            if (strString.length == 0)
            {
            return false;
            }

            //  test strString consists of valid characters listed above
            for (var i = 0; i <= strString.length && blnResult == true; i++)
            {

            strChar = strString.charAt(i);
            alert(strChar);
            if (strValidChars.indexOf(strChar) == -1)
            {
            blnResult = false;
            break;
            }
            }

            return blnResult;
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
                                                                                                    <td><div style="padding:1;height:100%;width:100%;">
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
                                                                                            </table></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5"></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                        </tr>
                                                                    </table></td>
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Add Sub Purpose Code</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">

                                                                                            <form  id="frmNewSPC" name="frmNewSPC"  method="post" >
                                                                                                <table border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                            <%

                                                                                                                if (isReq.equals("1"))
                                                                                                                {

                                                                                                                    if (result == true)
                                                                                                                    {

                                                                                                            %>
                                                                                                            <div id="displayMsg_success" class="cits_Display_Success_msg" >

                                                                                                                Sub Purpose Code added sucessfully.


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >Sub Purpose Code adding failed. - <span class="cits_error"><%=msg%></span></div>
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
                                                                                                        <td align="center" valign="middle"><table width="" border="0" cellspacing="0" cellpadding="0" class="cits_table_boder">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF" >

                                                                                                                            <tr>
                                                                                                                                <td width="126" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                    Purpose Code <span class="cits_required_field">*</span> :        </td>

                                                                                                                                <td width="185" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text">

                                                                                                                                    <select name="cmbPC" id="cmbPC" class="cits_field_border" onFocus="hideMessage_onFocus()">

                                                                                                                                        <option value="-1" <%=(purCode == null || purCode.equals("-1")) ? "selected" : ""%>>-- Select Purpose Code --</option>

                                                                                                                                        <%
                                                                                                                                            if (col_pc != null && !col_pc.isEmpty())
                                                                                                                                            {

                                                                                                                                                for (PurposeCode pc : col_pc)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=pc.getPurposeCode() %>" <%=(purCode != null && pc.getPurposeCode().equals(purCode)) ? "selected" : ""%>><%=pc.getPurposeCode()%> - <%=pc.getDesc() %></option>

                                                                                                                                        <% }%>
                                                                                                                                    </select>
                                                                                                                                    <% }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                                    <span class="cits_error">No bank details available.</span>
                                                                                                                                    <%}%></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td bgcolor="#B3D5C0" valign="middle" class="cits_tbl_header_text">
                                                                                                                                    Sub Purpose Code <span  class="cits_required_field">*</span> :</td>

                                                                                                                                <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">

                                                                                                                                    <input name="txtSPC" type="text" class="cits_field_border" id="txtSPC" onFocus="hideMessage_onFocus()"  value="<%=spCode != null ? spCode : ""%>" size="3" maxlength="2"/>                                                                                          </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td bgcolor="#B3D5C0" valign="middle" class="cits_tbl_header_text">
                                                                                                                                    Description <span  class="cits_required_field">* </span>:</td>
                                                                                                                                <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                    <input name="txtDesc" type="text" class="cits_field_border" id="txtDesc" onFocus="hideMessage_onFocus()"
                                                                                                                                           value="<%=subPC_Desc != null ? subPC_Desc : ""%>" size="100" maxlength="150"/>          </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                              <td bgcolor="#B3D5C0" valign="middle" class="cits_tbl_header_text">
                                                                                                                                    Status <span  class="cits_required_field">* </span>:</td>
                                                                                                                              <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><select name="cmbStatus" id="cmbStatus" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                        <option value="-1" <%=status == null ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                        <option value="<%=LCPL_Constants.status_active%>" <%=status != null && status.equals(LCPL_Constants.status_active) ? "selected" : ""%>>Active</option>
                                                                                                                                                        <option value="<%=LCPL_Constants.status_deactive%>" <%=status != null && status.equals(LCPL_Constants.status_deactive) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                    </select></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="2" bgcolor="#CDCDCD"><table border="0" align="right" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="button" value="Add" name="btnAdd" class="cits_custom_button"
                                                                                                                                                       onclick="doSubmit()"/></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td><input type="hidden" name="hdnReq" id="hdnReq" value="0" />
                                                                                                                                                <input name="btnClear" id="btnClear" value="Clear" type="button" onClick="clearRecords()" class="cits_custom_button" />                                                                                            </td></tr>
                                                                                                                                    </table></td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>


                                                                                            </form>
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
                                                    <td align="left" class="cits_copyRight">2012 &copy; Lanka Clear. All rights reserved.</td>
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

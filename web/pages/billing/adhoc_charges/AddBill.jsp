
<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.adhoccharges.AdhocCharges" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.billingadhoccharges.*" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.batch.CustomBatch" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../../error.jsp"%>
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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user) || userType.equals(LCPL_Constants.user_type_lcpl_supervisor)))
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
    String isReq = null;
    String billingDate = null;
    String bankCode = null;
    String branchCode = null;
    String adhocChargeCode = null;
    String quantity = null;
    String total = null;
    String status = null;
    String remarks = null;
    String msg = null;
    boolean result = false;

    Collection<Bank> colBank = null;
    Collection<Branch> colBranch = null;
    Collection<AdhocCharges> colAC = null;

    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);
    colAC = DAOFactory.getAdhocChargesDAO().getAdhocChargesTypeDetails(LCPL_Constants.status_active);

    isReq = (String) request.getParameter("hdnRequestType");

    if (isReq == null)
    {
        isReq = "0";
        billingDate = webBusinessDate;
    }
    else if (isReq.equals("0"))
    {
        billingDate = request.getParameter("txtBillingDate");
        bankCode = request.getParameter("cmbBank");
        branchCode = request.getParameter("cmbBranch");

        if (request.getParameter("cmbActCode") != null)
        {
            adhocChargeCode = request.getParameter("cmbActCode");

            if (adhocChargeCode.indexOf("_") > 1)
            {
                adhocChargeCode = adhocChargeCode.substring(0, (adhocChargeCode.indexOf("_") - 1));
            }
        }

        quantity = request.getParameter("txtQuantity");
        total = request.getParameter("txtTotal");
        remarks = request.getParameter("txtaRemarks");

        if (bankCode != null && (!bankCode.equals(LCPL_Constants.default_web_combo_select)))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(bankCode, LCPL_Constants.status_pending);
        }
    }
    else if (isReq.equals("1"))
    {
        billingDate = request.getParameter("txtBillingDate");
        bankCode = request.getParameter("cmbBank");
        branchCode = request.getParameter("cmbBranch");
        
                if (request.getParameter("cmbActCode") != null)
        {
            adhocChargeCode = request.getParameter("cmbActCode");

            if (adhocChargeCode.indexOf("_") > 0)
            {
                adhocChargeCode = adhocChargeCode.substring(0, adhocChargeCode.indexOf("_"));
            }
        }
        
        quantity = request.getParameter("txtQuantity");
        total = request.getParameter("txtTotal");
        remarks = request.getParameter("txtaRemarks");
        status = LCPL_Constants.status_active;

        if (bankCode != null && (!bankCode.equals(LCPL_Constants.default_web_combo_select)))
        {
            colBranch = DAOFactory.getBranchDAO().getBranchNotInStatus(bankCode, LCPL_Constants.status_pending);
        }

        BillingAdhocChargesDAO acDAO = DAOFactory.getBillingAdhocChargesDAO();

        result = acDAO.addBillingAdhocCharge(new BillingAdhocCharges(billingDate, bankCode, branchCode, adhocChargeCode, quantity, total, status, remarks, userName, userName));

        if (!result)
        {
            msg = acDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_billing_adhoccharges_add_bill, "| Billing Date - " + billingDate + ", Bank - " + bankCode + ", Branch - " + branchCode + ", Adhoc Charges Type - " + adhocChargeCode + ", Quantity - " + quantity + ", Total - " + total + ", Status - " + status + ", Remarks - " + remarks + " | Process Status - Unsuccess (" + msg + ") | Added By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_billing_adhoccharges_add_bill, "| Billing Date - " + billingDate + ", Bank - " + bankCode + ", Branch - " + branchCode + ", Adhoc Charges Type - " + adhocChargeCode + ", Quantity - " + quantity + ", Total - " + total + ", Status - " + status + ", Remarks - " + remarks + " | Process Status - Success | Added By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }


%>


<html>
    <head><title>OUSDPS Web - Add Adhoc Charges Billing Data</title>
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


            function clearRecords_onPageLoad()
            {            
            document.getElementById('txtQuantity').setAttribute("autocomplete","off");
            showClock(3);
            }

            function clearRecords()
            {
            document.getElementById('txtBillingDate').value="";
            document.getElementById('cmbBank').selectedIndex = 0;
            document.getElementById('cmbBranch').selectedIndex = 0;
            document.getElementById('cmbActCode').selectedIndex = 0;
            document.getElementById('txtQuantity').value="0";
            document.getElementById('txtTotal').value="0.00";
            document.getElementById('txtaRemarks').value=""; 
            }

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


            function fieldValidation()
            {
            var billDate = document.getElementById('txtBillingDate').value;
            var bank = document.getElementById('cmbBank').value;
            var branch = document.getElementById('cmbBranch').value;
            var adhochgcode = document.getElementById('cmbActCode').value;
            var quan = document.getElementById('txtQuantity').value;
            var amt = document.getElementById('txtTotal').value;


            var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
            var numbers = /^[0-9]*$/;

            if(isempty(billDate))
            {
            alert("Please Choose a Billing Date !");
            document.getElementById('txtBillingDate').focus();
            return false;
            }

            /*
            else if (!numbers.test(adhochgcode)) 
            {
            alert("Adhoc Charges Code should contain Numbers Only");
            return false;
            }
            else if(adhochgcode.length!=3)
            {
            alert("Adhoc Charges Code should contain only 3 digit");
            document.getElementById('cmbActCode').focus();
            return false;
            }
            */

            if(bank ==null || bank=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please Select Appropriate Bank Code !");
            document.getElementById('cmbBank').focus();
            return false;
            }

            if(branch==null || branch=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please Select Appropriate Branch Code !");
            document.getElementById('cmbBranch').focus();
            return false;
            } 

            if(adhochgcode==null || adhochgcode=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please Select Adhoc Charges Type !");
            document.getElementById('cmbActCode').focus();
            return false;
            } 


            if(isempty(quan))
            {
            alert("Quantity Can't be Empty!");					
            document.getElementById('txtTotal').focus();
            return false;
            }
            else
            {            
            if (!numbers.test(quan)) 
            {
            alert("Quantity is not a valid number!");
            document.getElementById('txtTotal').focus();
            return false;
            }
            else
            {
            if(parseFloat(quan)<0)
            {						
            alert("Quantity should not be lesser or equal to '0'!");
            document.getElementById('txtTotal').focus();
            return false;
            }
            else if(parseFloat(quan)>999999)
            {
            alert("Quantity should not be greater than '999999'!");
            document.getElementById('txtTotal').focus();
            return false;
            }
            }                 
            }            


            document.frmAddAdhocChargesBillingData.action="AddBill.jsp";
            document.frmAddAdhocChargesBillingData.submit();
            }

            function isRequest(status)
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

            function CalculateTotal()
            {
            var quant = document.getElementById('txtQuantity').value;

            var numbers = /^[0-9]*$/;

            if(isempty(quant))
            {
            }
            else
            {
            if (!numbers.test(quant)) 
            {
            alert("Quantity should contain Numbers Only !");
            document.getElementById('cmbActCode').focus();
            return false;
            }
            else
            {
            var adhochgcode = document.getElementById('cmbActCode').value;

            if(adhochgcode==null || adhochgcode=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("To calculate Total Please Select Adhoc Charges Type!");
            document.getElementById('cmbActCode').focus();
            return false;
            }
            else
            {  
            var pricePerItem = adhochgcode.substring(adhochgcode.lastIndexOf("_")+1); 

            document.getElementById('txtTotal').value= parseFloat(pricePerItem)*parseInt(quant) ;
            }                         
            }
            }			
            }


            function ResetQuantAndTotal()
            {
            document.getElementById('txtQuantity').value="0";
            document.getElementById('txtTotal').value="0.00";			
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
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="cits_header_text">Add Adhoc Charges Billing Data</td>
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
                                                                                            <form method="post" name="frmAddAdhocChargesBillingData" id="frmAddAdhocChargesBillingData">


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

                                                                                                                Adhoc Charges Billing Data Added Sucessfully.


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >Adhoc Charges Billing Data Adding Failed. - <span class="cits_error"><%=msg%></span></div>
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
                                                                                                                                <td valign="middle" nowrap bgcolor="#B3D5C0" class="cits_tbl_header_text">Billing Date <span class="cits_required_field">*</span> : </td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><input name="txtBillingDate" id="txtBillingDate" type="text" onFocus="this.blur();
                                                                                                                                                hideMessage_onFocus()" class="tcal" size="11" value="<%=billingDate == null ? "" : billingDate%>"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" nowrap bgcolor="#B3D5C0" class="cits_tbl_header_text">Bank <span class="cits_required_field">*</span> : </td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><%
                                                                                                                                    try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBank" id="cmbBank" onChange="setRequestType(false);
                                                                                                                                            frmAddAdhocChargesBillingData.submit()" class="cits_field_border" >
                                                                                                                                        <%
                                                                                                                                            if (bankCode == null || (bankCode != null && bankCode.equals(LCPL_Constants.default_web_combo_select)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.default_web_combo_select%>" selected="selected">-- Select Bank --</option>
                                                                                                                                        <% }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.default_web_combo_select%>">-- Select Bank --</option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colBank != null && colBank.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Bank bank : colBank)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=bank.getBankCode()%>" <%=(bankCode != null && bank.getBankCode().equals(bankCode)) ? "selected" : ""%> > <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="cits_error">No bank details available.</span>
                                                                                                                                    <%  }

                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }

                                                                                                                                    %>                                                                                                                                    </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" nowrap bgcolor="#B3D5C0" class="cits_tbl_header_text">Branch <span class="cits_required_field">*</span> : </td>
                                                                                                                                <td valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text"><%                                                                                                                                  try
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <select name="cmbBranch" id="cmbBranch" class="cits_field_border" onChange="hideMessage_onFocus()">
                                                                                                                                        <%
                                                                                                                                            if (branchCode == null || (branchCode != null && branchCode.equals(LCPL_Constants.default_web_combo_select)))
                                                                                                                                            {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.default_web_combo_select%>" selected="selected">-- Select Branch --</option>
                                                                                                                                        <%                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=LCPL_Constants.default_web_combo_select%>">-- Select Branch --</option>
                                                                                                                                        <%                                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <%
                                                                                                                                            if (colBranch != null && colBranch.size() > 0)
                                                                                                                                            {
                                                                                                                                                for (Branch branch : colBranch)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=branch.getBranchCode()%>" <%=(branchCode != null && branch.getBranchCode().equals(branchCode)) ? "selected" : ""%> > <%=branch.getBranchCode() + " - " + branch.getBranchName()%></option>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                    </select>
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <span class="cits_error">No branch details available.</span>
                                                                                                                                    <%}
                                                                                                                                        }
                                                                                                                                        catch (Exception e)
                                                                                                                                        {
                                                                                                                                            System.out.println(e.getMessage());
                                                                                                                                        }
                                                                                                                                    %></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" nowrap bgcolor="#B3D5C0" class="cits_tbl_header_text">Adhoc Charges Type <span class="cits_required_field">*</span> :</td>

                                                                                                                                <td width="185" valign="middle" bgcolor="#DFEFDE" class="cits_tbl_header_text">

                                                                                                                                    <select name="cmbActCode" id="cmbActCode" class="cits_field_border" onChange="hideMessage_onFocus();
                                                                                                                                            ResetQuantAndTotal()">

                                                                                                                                        <option value="<%=LCPL_Constants.default_web_combo_select%>" <%=(adhocChargeCode == null || adhocChargeCode.equals(LCPL_Constants.default_web_combo_select)) ? "selected" : ""%>>-- Select Adhoc Charges Type --</option>

                                                                                                                                        <%
                                                                                                                                            if (colAC != null && !colAC.isEmpty())
                                                                                                                                            {

                                                                                                                                                for (AdhocCharges ac : colAC)
                                                                                                                                                {
                                                                                                                                        %>
                                                                                                                                        <option value="<%=ac.getAdhocChargeCode()%>_<%=new DecimalFormat("#0.00").format((new Long(ac.getlAmount()).doubleValue()) / 100)%>" <%=(adhocChargeCode != null && ac.getAdhocChargeCode().equals(adhocChargeCode)) ? "selected" : ""%>><%=ac.getAdhocChargeCode()%> - <%=ac.getAdhocChargeDesc()%> (Rs. <%=new DecimalFormat("#0.00").format((new Long(ac.getlAmount()).doubleValue()) / 100)%> each)</option>

                                                                                                                                        <% }%>
                                                                                                                                    </select>                                  
                                                                                                                                    <% }
                                                                                                                                    else
                                                                                                                                    {%>
                                                                                                                                    <span class="cits_error">No Adhoc Charges Type details available.</span>
                                                                                                                                    <%}%></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" nowrap bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                    Quantity <span  class="cits_required_field">* </span>:</td>
                                                                                                                                <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                    <input name="txtQuantity" type="text" class="cits_field_border_number" id="txtQuantity" onFocus="hideMessage_onFocus()" onKeyUp="CalculateTotal()"
                                                                                                                                           value="<%=quantity != null ? quantity : "0"%>" size="6" maxlength="6"/>          </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td bgcolor="#B3D5C0" valign="middle" class="cits_tbl_header_text">Total :</td>
                                                                                                                                <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input name="txtTotal" type="text" class="cits_field_border_number" id="txtTotal" onFocus="hideMessage_onFocus()" value="<%=(total != null) ? total : "0.00"%>" size="12"  maxlength="12"/ readonly> </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td bgcolor="#B3D5C0" valign="middle" class="cits_tbl_header_text">Remarks :</td>
                                                                                                                                <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><textarea name="txtaRemarks" id="txtaRemarks" class="cits_field_border" cols="60" rows="5"><%=remarks != null ? remarks : ""%></textarea></td>
                                                                                                                            </tr>

                                                                                                                            <tr>
                                                                                                                                <td colspan="2" bgcolor="#CED5CF"><table border="0" align="right" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="button" value="Add" name="btnAdd" class="cits_custom_button"
                                                                                                                                                       onclick="doSubmit()"/></td>
                                                                                                                                            <td width="5"></td>
                                                                                                                                            <td><input type="hidden" name="hdnRequestType" id="hdnRequestType" value="0" />
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
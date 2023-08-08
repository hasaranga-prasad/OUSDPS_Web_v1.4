<%@page import="java.util.*,java.sql.*,java.text.DecimalFormat" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.branch.Branch" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.bank.Bank" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.transactiontype.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate"  errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="../../../error.jsp"%>
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
    Collection<TransactionType> colTransType = null;
    TransactionType objTranstype = null;
    String isReq = null;
    String transCode = null;
    String desc = null;
    String transType = null;
    String maxAmount = null;
    String minAmount = null;
    String maxValueDate = null;
    String minValueDate = null;
    String minReturnDate = null;
    String maxReturnDate = null;
    String man1From = null;
    String man1To = null;
    String man2From = null;
    String man2To = null;
    String man3From = null;
    String man3To = null;
    String concatMan1 = null;
    String concatMan2 = null;
    String concatMan3 = null;
    String desChargeAmt = null;
    String orgChargeAmt = null;
    String status = null;
    String msg = null;
    boolean result = false;

    colTransType = DAOFactory.getTransactionTypeDAO().getTransTypeDetails();
    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        isReq = "0";
        desc = "";
        transType = LCPL_Constants.transaction_type_credit;
        maxAmount = "";
        minAmount = "";
        maxValueDate = "";
        minValueDate = "";
        minReturnDate = "";
        maxReturnDate = "";
        man1From = "";
        man1To = "";
        man2From = "";
        man2To = "";
        man3From = "";
        man3To = "";

        desChargeAmt = "";
        orgChargeAmt = "";

        status = null;
    }
    else if (isReq.equals("0"))
    {
        transCode = request.getParameter("cmbTransCode");

        if (!transCode.equals(LCPL_Constants.default_web_combo_select))
        {
            objTranstype = DAOFactory.getTransactionTypeDAO().getTransType(transCode);

            desc = objTranstype.getDesc();
            transType = objTranstype.getType();
            maxAmount = new DecimalFormat("#0.00").format((new Long(objTranstype.getlMaxAmount()).doubleValue()) / 100);
            minAmount = new DecimalFormat("#0.00").format((new Long(objTranstype.getlMinAmount()).doubleValue()) / 100);
            maxValueDate = "" + objTranstype.getiMaxValueDate();
            minValueDate = "" + objTranstype.getiMinValueDate();
            minReturnDate = objTranstype.getMinReturnDate();
            maxReturnDate = objTranstype.getMaxReturnDate();

            if (objTranstype.getMan1() != null && objTranstype.getMan1().length() > 0)
            {
                //System.out.println("objTranstype.getMan1() --> " + objTranstype.getMan1());
                man1From = objTranstype.getMan1().substring(0, objTranstype.getMan1().indexOf(","));
                man1To = objTranstype.getMan1().substring(objTranstype.getMan1().indexOf(",") + 1);
            }
            else
            {
                man1From = "";
                man1To = "";
            }

            if (objTranstype.getMan2() != null && objTranstype.getMan2().length() > 0)
            {
                //System.out.println("objTranstype.getMan2() --> " + objTranstype.getMan2());

                man2From = objTranstype.getMan2().substring(0, objTranstype.getMan2().indexOf(","));
                man2To = objTranstype.getMan2().substring(objTranstype.getMan2().indexOf(",") + 1);
            }
            else
            {
                man2From = "";
                man2To = "";
            }

            if (objTranstype.getMan3() != null && objTranstype.getMan3().length() > 0)
            {
                //"objTranstype.getMan3() --> " + objTranstype.getMan3());

                man3From = objTranstype.getMan3().substring(0, objTranstype.getMan3().indexOf(","));
                man3To = objTranstype.getMan3().substring(objTranstype.getMan3().indexOf(",") + 1);
            }
            else
            {
                man3From = "";
                man3To = "";
            }

            desChargeAmt = objTranstype.getDesChargeAmount();
            orgChargeAmt = objTranstype.getOrgChargeAmount();
            status = objTranstype.getStatus();
        }
        else
        {
            desc = "";
            transType = LCPL_Constants.transaction_type_credit;
            maxAmount = "";
            minAmount = "";
            maxValueDate = "";
            minValueDate = "";
            minReturnDate = "";
            maxReturnDate = "";
            man1From = "";
            man1To = "";
            man2From = "";
            man2To = "";
            man3From = "";
            man3To = "";

            desChargeAmt = "";
            orgChargeAmt = "";
            status = null;
        }

    }
    else if (isReq.equals("1"))
    {
        transCode = request.getParameter("cmbTransCode");
        desc = request.getParameter("txtDesc");
        //transType = request.getParameter("cmbTransType");
        transType = LCPL_Constants.transaction_type_credit;
        maxAmount = request.getParameter("txtMaxAmount");
        minAmount = request.getParameter("txtMinAmount");
        maxValueDate = request.getParameter("txtMaxValDate");
        minValueDate = request.getParameter("txtMinValDate");
        minReturnDate = request.getParameter("txtMinRtnDate");
        maxReturnDate = request.getParameter("txtMaxRtnDate");
        man1From = request.getParameter("txtMan1From");
        man1To = request.getParameter("txtMan1To");
        man2From = request.getParameter("txtMan2From");
        man2To = request.getParameter("txtMan2To");
        man3From = request.getParameter("txtMan3From");
        man3To = request.getParameter("txtMan3To");

        desChargeAmt = request.getParameter("txtDesChargeAmount");
        orgChargeAmt = request.getParameter("txtOrgChargeAmount");

        status = request.getParameter("cmbStatus");

        objTranstype = DAOFactory.getTransactionTypeDAO().getTransType(transCode);

        if ((man1From != null && man1From.length() > 0) && (man1To != null && man1To.length() > 0))
        {
            concatMan1 = man1From + "," + man1To;
        }
        else
        {
            concatMan1 = "";
        }

        if ((man2From != null && man2From.length() > 0) && (man2To != null && man2To.length() > 0))
        {
            concatMan2 = man2From + "," + man2To;
        }
        else
        {
            concatMan2 = "";
        }

        if ((man3From != null && man3From.length() > 0) && (man3To != null && man3To.length() > 0))
        {
            concatMan3 = man3From + "," + man3To;
        }
        else
        {
            concatMan3 = "";
        }

        TransactionTypeDAO transDAO = DAOFactory.getTransactionTypeDAO();

        result = transDAO.modifyTransType(new TransactionType(transCode, desc, transType, maxAmount, minAmount, maxValueDate, minValueDate, minReturnDate, maxReturnDate, concatMan1, concatMan2, concatMan3, desChargeAmt, orgChargeAmt, status, userName));

        if (!result)
        {
            msg = transDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_transaction_maintenance_modify_transaction_types, "| Trans. Code  - " + transCode + ", Description - (New : " + desc + ", Old : " + objTranstype.getDesc() + "), Type - (New : " + transType + ", Old : " + objTranstype.getType() + "), Min. Amount - (New : " + minAmount + ", Old : " + objTranstype.getlMinAmount() + "), Max. Amount - (New : " + maxAmount + ", Old : " + objTranstype.getlMaxAmount() + "), Min. Value Date - (New : " + minValueDate + ", Old : " + objTranstype.getiMinValueDate() + "), Max. Value Date - (New : " + maxValueDate + ", Old : " + objTranstype.getiMaxValueDate() + "), Min. Return Date - (New : " + minReturnDate + ", Old : " + objTranstype.getMinReturnDate() + "), Max. Return Date - (New : " + maxReturnDate + ", Old : " + objTranstype.getMaxReturnDate() + "), Validation 1 - (New : " + concatMan1 + ", Old : " + objTranstype.getMan1() + "), Validation 2 - (New : " + concatMan2 + ", Old : " + objTranstype.getMan2() + "), Validation 3 - (New : " + concatMan3 + ", Old : " + objTranstype.getMan3() + "), Des.Chrg.Amt - (New : " + desChargeAmt + ", Old : " + objTranstype.getDesChargeAmount() + "), Org.Chrg.Amt - (New : " + orgChargeAmt + ", Old : " + objTranstype.getOrgChargeAmount() + "), Status - (New : " + status!= null?status.equals(LCPL_Constants.status_active)?"Active":"Inactive":"N/A" + ", Old : " + objTranstype.getStatus()!= null?objTranstype.getStatus().equals(LCPL_Constants.status_active)?"Active":"Inactive":"N/A" + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_transaction_maintenance_modify_transaction_types, "| Trans. Code  - " + transCode + ", Description - (New : " + desc + ", Old : " + objTranstype.getDesc() + "), Type - (New : " + transType + ", Old : " + objTranstype.getType() + "), Min. Amount - (New : " + minAmount + ", Old : " + objTranstype.getlMinAmount() + "), Max. Amount - (New : " + maxAmount + ", Old : " + objTranstype.getlMaxAmount() + "), Min. Value Date - (New : " + minValueDate + ", Old : " + objTranstype.getiMinValueDate() + "), Max. Value Date - (New : " + maxValueDate + ", Old : " + objTranstype.getiMaxValueDate() + "), Min. Return Date - (New : " + minReturnDate + ", Old : " + objTranstype.getMinReturnDate() + "), Max. Return Date - (New : " + maxReturnDate + ", Old : " + objTranstype.getMaxReturnDate() + "), Validation 1 - (New : " + concatMan1 + ", Old : " + objTranstype.getMan1() + "), Validation 2 - (New : " + concatMan2 + ", Old : " + objTranstype.getMan2() + "), Validation 3 - (New : " + concatMan3 + ", Old : " + objTranstype.getMan3() + "), Des.Chrg.Amt - (New : " + desChargeAmt + ", Old : " + objTranstype.getDesChargeAmount() + "), Org.Chrg.Amt - (New : " + orgChargeAmt + ", Old : " + objTranstype.getOrgChargeAmount() + "), Status - (New : " + status!= null?status.equals(LCPL_Constants.status_active)?"Active":"Inactive":"N/A" + ", Old : " + objTranstype.getStatus()!= null?objTranstype.getStatus().equals(LCPL_Constants.status_active)?"Active":"Inactive":"N/A" + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
        }
    }
%>


<html>
    <head><title>OUSDPS Web - Modify Transaction Types</title>
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
            document.getElementById('cmbTransCode').setAttribute("autocomplete","off");
            document.getElementById('txtDesc').setAttribute("autocomplete","off");
            document.getElementById('txtMaxAmount').setAttribute("autocomplete","off");
            document.getElementById('txtMinAmount').setAttribute("autocomplete","off");
            document.getElementById('txtMaxValDate').setAttribute("autocomplete","off");
            document.getElementById('txtMinValDate').setAttribute("autocomplete","off");
            document.getElementById('txtMinRtnDate').setAttribute("autocomplete","off");
            document.getElementById('txtMaxRtnDate').setAttribute("autocomplete","off");
            document.getElementById('txtMan1From').setAttribute("autocomplete","off");
            document.getElementById('txtMan1To').setAttribute("autocomplete","off");
            document.getElementById('txtMan2From').setAttribute("autocomplete","off");
            document.getElementById('txtMan2To').setAttribute("autocomplete","off");
            document.getElementById('txtMan3From').setAttribute("autocomplete","off");
            document.getElementById('txtMan3To').setAttribute("autocomplete","off");

            document.getElementById('txtDesChargeAmount').setAttribute("autocomplete","off");
            document.getElementById('txtOrgChargeAmount').setAttribute("autocomplete","off");


            showClock(3);
            }


            function clearRecords()
            {
            document.getElementById('cmbTransCode').selectedIndex = 0;
            document.getElementById('txtDesc').value = "";
            //document.getElementById('cmbTransType').selectedIndex = 0;
            document.getElementById('txtMaxAmount').value = "";
            document.getElementById('txtMinAmount').value = "";
            document.getElementById('txtMaxValDate').value = "";
            document.getElementById('txtMinValDate').value = "";
            document.getElementById('txtMinRtnDate').value = "";
            document.getElementById('txtMaxRtnDate').value = "";
            document.getElementById('txtMan1From').value = "";
            document.getElementById('txtMan1To').value = "";
            document.getElementById('txtMan2From').value = "";
            document.getElementById('txtMan2To').value = "";
            document.getElementById('txtMan3From').value = "";
            document.getElementById('txtMan3To').value = "";

            document.getElementById('txtDesChargeAmount').value = "";
            document.getElementById('txtOrgChargeAmount').value = "";

            document.getElementById('cmbStatus').selectedIndex = 0;

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

            var tc = document.getElementById('cmbTransCode').value;
            var desc = document.getElementById('txtDesc').value;
            //var type = document.getElementById('cmbTransType').value;
            var maxAmount = document.getElementById('txtMaxAmount').value;
            var minAmount = document.getElementById('txtMinAmount').value;
            var maxValDate = document.getElementById('txtMaxValDate').value;
            var minValDate = document.getElementById('txtMinValDate').value;
            var man1from = document.getElementById('txtMan1From').value;
            var man1to = document.getElementById('txtMan1To').value;
            var man2from = document.getElementById('txtMan2From').value;
            var man2to = document.getElementById('txtMan2To').value;
            var man3from = document.getElementById('txtMan3From').value;
            var man3to = document.getElementById('txtMan3To').value;
            var minRtnDate = document.getElementById('txtMinRtnDate').value;
            var maxRtnDate = document.getElementById('txtMaxRtnDate').value;

            var desChrgAmount = document.getElementById('txtDesChargeAmount').value;
            var orgChrgAmount = document.getElementById('txtOrgChargeAmount').value;

            var status = document.getElementById('cmbStatus').value;

            var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
            var numbers = /^[0-9]*$/;                


            if(tc == "-1" || tc == null)
            {
            alert("Select Transaction Code!");
            document.getElementById('cmbTransCode').focus();
            return false;
            }

            if(isempty(desc))
            {
            alert("Description Can't be Empty!");
            document.getElementById('txtDesc').focus();
            return false;
            }

            /*
            if(type == "-1" || type == null)
            {
            alert("Select Type of the Transaction!");
            document.getElementById('cmbTransType').focus();
            return false;
            }
            */

            if(isempty(minAmount))
            {
            alert("Min Amount Can't be Empty!");					
            document.getElementById('txtMinAmount').focus();
            return false;
            }
            else
            {
            //if(!numbers.test(minAmount))
            if(isNaN(minAmount))
            {
            alert("Min Amount is not a valid number!");
            document.getElementById('txtMinAmount').focus();
            return false;
            }
            else
            {
            if(parseFloat(minAmount)<0)
            {						
            alert("Min Amount should not be lesser than '0.00'!");
            document.getElementById('txtMinAmount').focus();
            return false;
            }
            else if(parseFloat(minAmount)>9999999999.99)
            {
            alert("Min Amount should not be greater than '9999999999.99'!");
            document.getElementById('txtMinAmount').focus();
            return false;
            }
            }
            }

            if(isempty(maxAmount))
            {
            alert("Max Amount Can't be Empty!");
            document.getElementById('txtMaxAmount').focus();
            return false;
            }
            else
            {
            //if(!numbers.test(maxAmount))
            if(isNaN(maxAmount))
            {
            alert("Max Amount is not a valid number!");
            document.getElementById('txtMaxAmount').focus();
            return false;
            }
            else
            {
            if(parseFloat(maxAmount)<0)
            {						
            alert("Max Amount should not be lesser than '0.00'!");
            document.getElementById('txtMaxAmount').focus();
            return false;
            }
            else if(parseFloat(maxAmount)>9999999999.99)
            {
            alert("Max Amount should not be greater than '9999999999.99'!");
            document.getElementById('txtMaxAmount').focus();
            return false;
            }

            }
            }

            if(!isempty(minAmount) && !isempty(maxAmount))
            {
            if(parseFloat(minAmount)>parseFloat(maxAmount))
            {
            alert("Max Amount should not be lesser than Min Amount!");
            document.getElementById('txtMaxAmount').focus();
            return false;
            }
            }               


            if(isempty(minValDate))
            {
            alert("Min Value Date Can't be Empty!");
            document.getElementById('txtMinValDate').focus();
            return false;
            }
            else
            {
            if(!numbers.test(minValDate))
            {
            alert("Min Value Date is not a valid number!");
            document.getElementById('txtMinValDate').focus();
            return false;
            }
            else
            {
            if(parseInt(maxValDate)<0)
            {						
            alert("Min Value Date should not be lesser than '0'!");
            document.getElementById('txtMinValDate').focus();
            return false;
            }
            else if(parseInt(maxValDate)>99)
            {
            alert("Min Value Date should not be greater than '99'!");
            document.getElementById('txtMinValDate').focus();
            return false;
            }
            }
            }

            if(isempty(maxValDate))
            {
            alert("Max Value Date Can't be Empty!");
            document.getElementById('txtMaxValDate').focus();
            return false;
            }
            else
            {
            if(!numbers.test(maxValDate))
            {
            alert("Max Value Date is not a valid number!");
            document.getElementById('txtMaxValDate').focus();
            return false;
            }
            else
            {
            if(parseInt(maxValDate)<0)
            {						
            alert("Max Value Date should not be lesser than '0'!");
            document.getElementById('txtMaxValDate').focus();
            return false;
            }
            else if(parseInt(maxValDate)>99)
            {
            alert("Max Value Date should not be greater than '99'!");
            document.getElementById('txtMaxValDate').focus();
            return false;
            }
            }
            }

            if(isempty(minRtnDate))
            {
            alert("Min Return Date Can't be Empty!");
            document.getElementById('txtMinRtnDate').focus();
            return false;
            }
            else
            {
            if(!numbers.test(minRtnDate))
            {
            alert("Min Return Date is not a valid number!");
            document.getElementById('txtMinRtnDate').focus();
            return false;
            }
            else
            {
            if(parseInt(minRtnDate)<0)
            {						
            alert("Min Return Date should not be lesser than '0'!");
            document.getElementById('txtMinRtnDate').focus();
            return false;
            }
            else if(parseInt(minRtnDate)>99)
            {
            alert("Min Return Date should not be greater than '99'!");
            document.getElementById('txtMinRtnDate').focus();
            return false;
            }
            }
            } 

            if(isempty(maxRtnDate))
            {
            alert("Max Return Date Can't be Empty!");
            document.getElementById('txtMaxRtnDate').focus();
            return false;
            }
            else
            {
            if(!numbers.test(maxRtnDate))
            {
            alert("Max Return Date is not a valid number!");
            document.getElementById('txtMaxRtnDate').focus();
            return false;
            }
            else
            {
            if(parseInt(maxRtnDate)<0)
            {						
            alert("Max Return Date should not be lesser than '0'!");
            document.getElementById('txtMaxRtnDate').focus();
            return false;
            }
            else if(parseInt(maxRtnDate)>99)
            {
            alert("Max Return Date should not be greater than '99'!");
            document.getElementById('txtMaxRtnDate').focus();
            return false;
            }
            }
            } 

            if(!isempty(man1from))
            {
            if(!numbers.test(man1from))
            {
            alert("Validation 1 (From) is not a valid number!");
            document.getElementById('txtMan1From').focus();
            return false;
            }
            else
            {
            if(!((0<parseInt(man1from)) && (parseInt(man1from)<180)))
            {
            alert("Validation 1 (From) should be between 0 and 180!");
            document.getElementById('txtMan1From').focus();
            return false;
            }                    
            }

            if(isempty(man1to))
            {
            alert("Validation 1 (To) can't be empty while Validation 1 (From) is not empty!");
            document.getElementById('txtMan1To').focus();
            return false;
            }
            }

            if(!isempty(man1to))
            {					

            if(!numbers.test(man1to))
            {
            alert("Validation 1 (To) is not a valid number!");
            document.getElementById('txtMan1To').focus();
            return false;
            }
            else
            {
            if(!((0<parseInt(man1to)) && (parseInt(man1to)<180)))
            {
            alert("Validation 1 (To) should be between 0 and 180!");
            document.getElementById('txtMan1To').focus();
            return false;
            }                    
            }

            if(isempty(man1from))
            {
            alert("Validation 1 (From) can't be empty while Validation 1 (To) is not empty!");
            document.getElementById('txtMan1From').focus();
            return false;
            }
            }


            if(parseInt(man1to)<parseInt(man1from))
            {
            alert("Validation 1 (From) can't be greater than Validation 1 (To)!");
            document.getElementById('txtMan1From').focus();
            return false;				
            }				


            if(!isempty(man2from))
            {
            if(!numbers.test(man2from))
            {
            alert("Validation 1 (From) is not a valid number!");
            document.getElementById('txtMan2From').focus();
            return false;
            }
            else
            {
            if(!((0<parseInt(man2from)) && (parseInt(man2from)<180)))
            {
            alert("Validation 2 (From) should be between 0 and 180!");
            document.getElementById('txtMan2From').focus();
            return false;
            }                    
            }

            if(isempty(man2to))
            {
            alert("Validation 2 (To) can't be empty while Validation 2 (From) is not empty!");
            document.getElementById('txtMan2To').focus();
            return false;
            }
            }

            if(!isempty(man2to))
            {
            if(!numbers.test(man2to))
            {
            alert("Validation 2 (To) is not a valid number!");
            document.getElementById('txtMan2To').focus();
            return false;
            }
            else
            {
            if(!((0<parseInt(man2to)) && (parseInt(man2to)<180)))
            {
            alert("Validation 2 (To) should be between 0 and 180!");
            document.getElementById('txtMan2To').focus();
            return false;
            }                    
            }

            if(isempty(man2from))
            {
            alert("Validation 2 (From) can't be empty while Validation 2 (To) is not empty!");
            document.getElementById('txtMan2From').focus();
            return false;
            }
            } 

            if(parseInt(man2to)<parseInt(man2from))
            {
            alert("Validation 2 (From) can't be greater than Validation 2 (To)!");
            document.getElementById('txtMan2From').focus();
            return false;				
            }


            if(!isempty(man3from))
            {
            if(!numbers.test(man3from))
            {
            alert("Validation 3 (From) is not a valid number!");
            document.getElementById('txtMan3From').focus();
            return false;
            }
            else
            {
            if(!((0<parseInt(man3from)) && (parseInt(man3from)<180)))
            {
            alert("Validation 3 (From) should be between 0 and 180!");
            document.getElementById('txtMan3From').focus();
            return false;
            }                    
            }

            if(isempty(man3to))
            {
            alert("Validation 3 (To) can't be empty while Validation 3 (From) is not empty!");
            document.getElementById('txtMan3To').focus();
            return false;
            }
            }

            if(!isempty(man3to))
            {
            if(!numbers.test(man3to))
            {
            alert("Validation 3 (To) is not a valid number!");
            document.getElementById('txtMan3To').focus();
            return false;
            }
            else
            {
            if(!((0<parseInt(man3to)) && (parseInt(man3to)<180)))
            {
            alert("Validation 3 (To) should be between 0 and 180!");
            document.getElementById('txtMan3To').focus();
            return false;
            }                    
            }

            if(isempty(man3from))
            {
            alert("Validation 3 (From) can't be empty while Validation 3 (To) is not empty!");
            document.getElementById('txtMan3From').focus();
            return false;
            }
            }

            if(parseInt(man3to)<parseInt(man3from))
            {
            alert("Validation 3 (From) can't be greater than Validation 3 (To)!");
            document.getElementById('txtMan3From').focus();
            return false;				
            }

            if(isempty(desChrgAmount))
            {
            alert("Destination Charge Amount Can't be Empty!");					
            document.getElementById('txtDesChargeAmount').focus();
            return false;
            }
            else
            {
            //if(!numbers.test(minAmount))

            if(isNaN(desChrgAmount))
            {
            alert("Destination Charge Amount is not a valid number!");
            document.getElementById('txtDesChargeAmount').focus();
            return false;
            }
            else
            {
            if(parseFloat(desChrgAmount)<0)
            {						
            alert("Destination Charge Amount should not be lesser than '0.00'!");
            document.getElementById('txtDesChargeAmount').focus();
            return false;
            }
            else if(parseFloat(desChrgAmount)>9999999999.99)
            {
            alert("Destination Charge Amount should not be greater than '9999999999.99'!");
            document.getElementById('txtDesChargeAmount').focus();
            return false;
            }
            }
            }


            if(isempty(orgChrgAmount))
            {
            alert("Originator Charge Amount Can't be Empty!");					
            document.getElementById('txtOrgChargeAmount').focus();
            return false;
            }
            else
            {
            //if(!numbers.test(minAmount))

            if(isNaN(orgChrgAmount))
            {
            alert("Originator Charge Amount is not a valid number!");
            document.getElementById('txtOrgChargeAmount').focus();
            return false;
            }
            else
            {
            if(parseFloat(orgChrgAmount)<0)
            {						
            alert("Originator Charge Amount should not be lesser than '0.00'!");
            document.getElementById('txtOrgChargeAmount').focus();
            return false;
            }
            else if(parseFloat(orgChrgAmount)>9999999999.99)
            {
            alert("Originator Charge Amount should not be greater than '9999999999.99'!");
            document.getElementById('txtOrgChargeAmount').focus();
            return false;
            }
            }
            }

            document.frmModifyTransType.action="ModifyTransactionsTypes.jsp";
            document.frmModifyTransType.submit();
            return true;

            }

            function isRequest(status)
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

            function showDivisionArea()
            {        
            if('<%=isReq%>' == '0')
            {
            // alert("isReq");
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'none';                    
            }
            else 
            {
            if('<%=result%>' == 'true')
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            else
            {
            document.getElementById('displayMsg_error').style.display='none';
            document.getElementById('displayMsg_success').style.display = 'block';
            }
            }
            }

            function hideMessage_onFocus()
            {
            if(document.getElementById('displayMsg_error') != null )
            {
            document.getElementById('displayMsg_error').style.display='none';                    

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }

            if(document.getElementById('displayMsg_success') != null)
            {
            document.getElementById('displayMsg_success').style.display = 'none';

            if(document.getElementById('hdnCheckPOSForClearREcords')!=null && document.getElementById('hdnCheckPOSForClearREcords').value == '1')
            {
            clearRecords();
            document.getElementById('hdnCheckPOSForClearREcords').value = '0';
            }
            }

            }

            function doSearch()
            {
            isRequest(false);
            document.frmModifyTransType.action="ModifyTransactionsTypes.jsp";
            document.frmModifyTransType.submit();
            return true;
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Modify  Transaction Types</td>
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
                                                                                            <form method="post" name="frmModifyTransType" id="frmModifyTransType">

                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="center">
                                                                                                            <%

                                                                                                                if (isReq.equals("1"))
                                                                                                                {

                                                                                                                    if (result == true)
                                                                                                                    {

                                                                                                            %>
                                                                                                            <div id="displayMsg_success" class="cits_Display_Success_msg" >

                                                                                                                Transaction Type modified Sucessfully.


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >Transaction Type modification Failed.- <span class="cits_error"><%=msg%></span></div>
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
                                                                                                                                <td><table border="0" cellspacing="1" cellpadding="3"  bgcolor="#FFFFFF">

                                                                                                                                        <tr>
                                                                                                                                            <td width="126" align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Transaction Code<span class="cits_required_field">*</span>  :        </td>

                                                                                                                                            <td width="185" valign="middle" bgcolor="#DFEFDE"class="cits_tbl_header_text">
                                                                                                                                                <select name="cmbTransCode" id="cmbTransCode" class="cits_field_border" onChange="doSearch();" onFocus="hideMessage_onFocus()">

                                                                                                                                                    <option value="-1" <%=(transCode == null || transCode.equals("-1")) ? "selected" : ""%>>-- Select Transaction Type --</option>

                                                                                                                                                    <%
                                                                                                                                                        if (colTransType != null && !colTransType.isEmpty())
                                                                                                                                                        {

                                                                                                                                                            for (TransactionType tType : colTransType)
                                                                                                                                                            {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=tType.getTc()%>" <%=(transCode != null && tType.getTc().equals(transCode)) ? "selected" : ""%>><%=tType.getTc()%> - <%=tType.getDesc()%></option>

                                                                                                                                                    <% }%>
                                                                                                                                                </select>
                                                                                                                                                <% }
                                                                                                                                                else
                                                                                                                                                {%>
                                                                                                                                                <span class="cits_error">No Transaction Types available.</span>
                                                                                                                                                <%}%></td>
                                                                                                                                        </tr>

                                                                                                                                        <!--tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">
                                                                                                                                                Type  :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <select name="cmbTransType" id="cmbTransType" class="cits_field_border" onFocus="hideMessage_onFocus()" disabled>
                                                                                                                                                    <option value="-1" <%=(transType != null && transType.equals("-1")) ? "selected" : ""%> disabled>--Select Type--</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.transaction_type_credit%>" <%=(transType != null && transType.equals(LCPL_Constants.transaction_type_credit)) ? "selected" : ""%>>Credit</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_deactive%>" <%=(transType != null && transType.equals(LCPL_Constants.status_deactive)) ? "selected" : ""%>>Debit</option>
                                                                                                                                                </select></td>
                                                                                                                                        </tr-->

                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Description <span  class="cits_required_field">*</span> :</td>

                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <input name="txtDesc" type="text" class="cits_field_border" id="txtDesc" onFocus="hideMessage_onFocus()" value="<%=(desc != null) ? desc : ""%>" size="46"  maxlength="45"/>              </td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Min Amount (Rs.) :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"> <input name="txtMinAmount" type="text" class="cits_field_border" id="txtMinAmount" onFocus="hideMessage_onFocus()" value="<%=(minAmount != null) ? minAmount : "0.00"%>" size="14"  maxlength="13"/>                                                                                                                 </td>
                                                                                                                                        </tr>


                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Max Amount (Rs.) :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"> <input name="txtMaxAmount" type="text" class="cits_field_border" id="txtMaxAmount" onFocus="hideMessage_onFocus()" value="<%=(maxAmount != null) ? maxAmount : "5000000.00"%>" size="14"  maxlength="13"/>                                                                                                                 </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Min Value Date :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"> <input name="txtMinValDate" type="text" class="cits_field_border" id="txtMinValDate" onFocus="hideMessage_onFocus()" value="<%=(minValueDate != null) ? minValueDate : "0"%>" size="3"  maxlength="2"/>                                                                                                                 </td>
                                                                                                                                        </tr>


                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Max Value Date  :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input name="txtMaxValDate" type="text" class="cits_field_border" id="txtMaxValDate" onFocus="hideMessage_onFocus()" value="<%=(maxValueDate != null) ? maxValueDate : "14"%>" size="3"  maxlength="2"/>                                                                                                                  </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Min Return Date :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input name="txtMinRtnDate" type="text" class="cits_field_border" id="txtMinRtnDate" onFocus="hideMessage_onFocus()" value="<%=(minReturnDate != null) ? minReturnDate : "0"%>" size="3"  maxlength="2"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Max Return Date  :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input name="txtMaxRtnDate" type="text" class="cits_field_border" id="txtMaxRtnDate" onFocus="hideMessage_onFocus()" value="<%=(maxReturnDate != null) ? maxReturnDate : "2"%>" size="3"  maxlength="2"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Validation 1 :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="cits_common_text">From -</td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input name="txtMan1From" type="text" class="cits_field_border" id="txtMan1From" onFocus="hideMessage_onFocus()" value="<%=(man1From != null) ? man1From : ""%>" size="4"  maxlength="3"/></td>
                                                                                                                                                        <td width="15"></td>
                                                                                                                                                        <td class="cits_common_text">To -</td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input name="txtMan1To" type="text" class="cits_field_border" id="txtMan1To" onFocus="hideMessage_onFocus()" value="<%=(man1To != null) ? man1To : ""%>" size="4"  maxlength="3"/></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Validation 2 :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text">
                                                                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="cits_common_text">From -</td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input name="txtMan2From" type="text" class="cits_field_border" id="txtMan2From" onFocus="hideMessage_onFocus()" value="<%=(man2From != null) ? man2From : ""%>" size="4"  maxlength="3"/></td>
                                                                                                                                                        <td width="15"></td>
                                                                                                                                                        <td class="cits_common_text">To -</td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input name="txtMan2To" type="text" class="cits_field_border" id="txtMan2To" onFocus="hideMessage_onFocus()" value="<%=(man2To != null) ? man2To : ""%>" size="4"  maxlength="3"/></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Validation 3 :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="cits_common_text">From -</td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input name="txtMan3From" type="text" class="cits_field_border" id="txtMan3From" onFocus="hideMessage_onFocus()" value="<%=(man3From != null) ? man3From : ""%>" size="4"  maxlength="3"/></td>
                                                                                                                                                        <td width="15"></td>
                                                                                                                                                        <td class="cits_common_text">To -</td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input name="txtMan3To" type="text" class="cits_field_border" id="txtMan3To" onFocus="hideMessage_onFocus()" value="<%=(man3To != null) ? man3To : ""%>" size="4"  maxlength="3"/></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Destination Charge Amount (Rs.) :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input name="txtDesChargeAmount" type="text" class="cits_field_border" id="txtDesChargeAmount" onFocus="hideMessage_onFocus()" value="<%=(desChargeAmt != null) ? desChargeAmt : "0.00"%>" size="14"  maxlength="12"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Originator Charge Amount (Rs.) :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><input name="txtOrgChargeAmount" type="text" class="cits_field_border" id="txtOrgChargeAmount" onFocus="hideMessage_onFocus()" value="<%=(orgChargeAmt != null) ? orgChargeAmt : "0.00"%>" size="14"  maxlength="12"/></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td align="left" valign="middle" bgcolor="#B3D5C0" class="cits_tbl_header_text">Status :</td>
                                                                                                                                            <td bgcolor="#DFEFDE" valign="middle" class="cits_tbl_header_text"><select name="cmbStatus" id="cmbStatus" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <option value="-1" <%=status == null ? "selected" : ""%>>--Select Status--</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_active%>" <%=status != null && status.equals(LCPL_Constants.status_active) ? "selected" : ""%>>Active</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.status_deactive%>" <%=status != null && status.equals(LCPL_Constants.status_deactive) ? "selected" : ""%>>Inactive</option>
                                                                                                                                                </select></td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td height="35" colspan="2" align="right" valign="middle" bgcolor="#CDCDCD" class="cits_tbl_header_text">                                                                                                                      <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="button" value="Update" name="btnAdd" class="cits_custom_button" onClick="doSubmit()"/>                             </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /></td>
                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Clear" type="button" onClick="clearRecords()" class="cits_custom_button" />                                                            </td></tr>
                                                                                                                                                </table></td>
                                                                                                                                        </tr>

                                                                                                                                    </table></td>
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

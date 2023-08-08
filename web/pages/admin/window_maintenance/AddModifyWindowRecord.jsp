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

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(sessionBankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
%>

<%
    Collection<Bank> colBank = null;
    String isReq = null;
    String bankCode = null;
    String winSess = null;
    String fromTimeHour = null;
    String fromTimeMinute = null;
    String toTimeHour = null;
    String toTimeMinute = null;
    String defaultSessionStartTime = null;
    String defaultSessionEndTime = null;
    String currentSessionStartTime = null;
    String currentSessionEndTime = null;
    String addOrUpdate = null;
    String msg = null;
    boolean result = false;
    boolean isWindowAlreadySet = false;

    int defaultStartTime_Hour = -1;
    int defaultStartTime_Minute = -1;
    int defaultEndTime_Hour = -1;
    int defaultEndTime_Minute = -1;

    int currentStartTime_Hour = -1;
    int currentStartTime_Minute = -1;
    int currentEndTime_Hour = -1;
    int currentEndTime_Minute = -1;

    //int startTime_Hour = -1;
    //int startTime_Minute = -1;
    //int endTime_Hour = -1;
    //int endTime_Minute = -1;
    colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);

    isReq = (String) request.getParameter("hdnReq");

    if (isReq == null)
    {
        bankCode = LCPL_Constants.default_web_combo_select;
        winSess = LCPL_Constants.default_web_combo_select;
        fromTimeHour = LCPL_Constants.default_web_combo_select;
        fromTimeMinute = LCPL_Constants.default_web_combo_select;
        toTimeHour = LCPL_Constants.default_web_combo_select;
        toTimeMinute = LCPL_Constants.default_web_combo_select;
    }
    else if (isReq.equals("0"))
    {
        bankCode = (String) request.getParameter("cmbBank");
        winSess = (String) request.getParameter("cmbSession");
        fromTimeHour = (String) request.getParameter("cmbFromHH");
        fromTimeMinute = (String) request.getParameter("cmbFromMM");
        toTimeHour = (String) request.getParameter("cmbToHH");
        toTimeMinute = (String) request.getParameter("cmbToMM");

        if (!bankCode.equals(LCPL_Constants.default_web_combo_select))
        {
            if (!winSess.equals(LCPL_Constants.default_web_combo_select))
            {
                if (winSess.equals(LCPL_Constants.window_session_one))
                {
                    defaultSessionStartTime = DAOFactory.getParameterDAO().getParamValueById_notFormatted(LCPL_Constants.param_id_start_time_session1);
                    defaultSessionEndTime = DAOFactory.getParameterDAO().getParamValueById_notFormatted(LCPL_Constants.param_id_end_time_session1);

                    if (defaultSessionStartTime != null && defaultSessionStartTime.length() == 4)
                    {
                        try
                        {
                            defaultStartTime_Hour = Integer.parseInt(defaultSessionStartTime.substring(0, 2));
                            defaultStartTime_Minute = Integer.parseInt(defaultSessionStartTime.substring(2));
                        }
                        catch (Exception e)
                        {
                            System.out.println(e.getMessage());
                            response.sendRedirect(request.getContextPath() + "/error.jsp");
                        }
                    }
                    if (defaultSessionEndTime != null && defaultSessionEndTime.length() == 4)
                    {
                        try
                        {
                            defaultEndTime_Hour = Integer.parseInt(defaultSessionEndTime.substring(0, 2));
                            defaultEndTime_Minute = Integer.parseInt(defaultSessionEndTime.substring(2));
                        }
                        catch (Exception e)
                        {
                            System.out.println(e.getMessage());
                            response.sendRedirect(request.getContextPath() + "/error.jsp");
                        }
                    }

                    if (!bankCode.equals(LCPL_Constants.default_web_combo_select))
                    {
                        if (!bankCode.equals(LCPL_Constants.status_all))
                        {
                            Window window1 = DAOFactory.getWindowDAO().getWindow(bankCode, LCPL_Constants.window_session_one);

                            if (window1 != null)
                            {
                                isWindowAlreadySet = true;

                                currentStartTime_Hour = window1.getCutontimeHour();
                                currentStartTime_Minute = window1.getCutontimeMinutes();
                                currentEndTime_Hour = window1.getCutofftimeHour();
                                currentEndTime_Minute = window1.getCutofftimeMinutes();
                            }
                        }
                        else
                        {
                            isWindowAlreadySet = true;

                            fromTimeHour = LCPL_Constants.default_web_combo_select;
                            fromTimeMinute = LCPL_Constants.default_web_combo_select;
                            toTimeHour = LCPL_Constants.default_web_combo_select;
                            toTimeMinute = LCPL_Constants.default_web_combo_select;
                        }
                    }
                }
                else if (winSess.equals(LCPL_Constants.window_session_two))
                {
                    defaultSessionStartTime = DAOFactory.getParameterDAO().getParamValueById_notFormatted(LCPL_Constants.param_id_start_time_session2);
                    defaultSessionEndTime = DAOFactory.getParameterDAO().getParamValueById_notFormatted(LCPL_Constants.param_id_end_time_session2);

                    if (defaultSessionStartTime != null && defaultSessionStartTime.length() == 4)
                    {
                        try
                        {
                            defaultStartTime_Hour = Integer.parseInt(defaultSessionStartTime.substring(0, 2));
                            defaultStartTime_Minute = Integer.parseInt(defaultSessionStartTime.substring(2));
                        }
                        catch (Exception e)
                        {
                            System.out.println(e.getMessage());
                            response.sendRedirect(request.getContextPath() + "/error.jsp");
                        }
                    }
                    if (defaultSessionEndTime != null && defaultSessionEndTime.length() == 4)
                    {
                        try
                        {
                            defaultEndTime_Hour = Integer.parseInt(defaultSessionEndTime.substring(0, 2));
                            defaultEndTime_Minute = Integer.parseInt(defaultSessionEndTime.substring(2));
                        }
                        catch (Exception e)
                        {
                            System.out.println(e.getMessage());
                            response.sendRedirect(request.getContextPath() + "/error.jsp");
                        }
                    }

                    if (!bankCode.equals(LCPL_Constants.default_web_combo_select))
                    {
                        if (!bankCode.equals(LCPL_Constants.status_all))
                        {
                            Window window1 = DAOFactory.getWindowDAO().getWindow(bankCode, LCPL_Constants.window_session_two);

                            if (window1 != null)
                            {
                                isWindowAlreadySet = true;

                                currentStartTime_Hour = window1.getCutontimeHour();
                                currentStartTime_Minute = window1.getCutontimeMinutes();
                                currentEndTime_Hour = window1.getCutofftimeHour();
                                currentEndTime_Minute = window1.getCutofftimeMinutes();
                            }
                        }
                        else
                        {
                            isWindowAlreadySet = true;

                            fromTimeHour = LCPL_Constants.default_web_combo_select;
                            fromTimeMinute = LCPL_Constants.default_web_combo_select;
                            toTimeHour = LCPL_Constants.default_web_combo_select;
                            toTimeMinute = LCPL_Constants.default_web_combo_select;
                        }

                    }
                }

                if ((currentStartTime_Hour > -1) && (currentStartTime_Minute > -1) && (currentEndTime_Hour > - 1) && (currentEndTime_Minute > -1))
                {
                    fromTimeHour = currentStartTime_Hour < 10 ? "0" + currentStartTime_Hour : "" + currentStartTime_Hour;
                    fromTimeMinute = currentStartTime_Minute < 10 ? "0" + currentStartTime_Minute : "" + currentStartTime_Minute;
                    toTimeHour = currentEndTime_Hour < 10 ? "0" + currentEndTime_Hour : "" + currentEndTime_Hour;
                    toTimeMinute = currentEndTime_Minute < 10 ? "0" + currentEndTime_Minute : "" + currentEndTime_Minute;

                    //System.out.println("fromTimeHour - " + fromTimeHour + "   fromTimeMinute - " + fromTimeMinute + "   toTimeHour - " + toTimeHour + "    toTimeMinute - " + toTimeMinute);
                }
                else
                {
                    fromTimeHour = LCPL_Constants.default_web_combo_select;
                    fromTimeMinute = LCPL_Constants.default_web_combo_select;
                    toTimeHour = LCPL_Constants.default_web_combo_select;
                    toTimeMinute = LCPL_Constants.default_web_combo_select;
                }
            }
            else
            {
                fromTimeHour = LCPL_Constants.default_web_combo_select;
                fromTimeMinute = LCPL_Constants.default_web_combo_select;
                toTimeHour = LCPL_Constants.default_web_combo_select;
                toTimeMinute = LCPL_Constants.default_web_combo_select;
            }
        }
        else
        {
            winSess = LCPL_Constants.default_web_combo_select;
            fromTimeHour = LCPL_Constants.default_web_combo_select;
            fromTimeMinute = LCPL_Constants.default_web_combo_select;
            toTimeHour = LCPL_Constants.default_web_combo_select;
            toTimeMinute = LCPL_Constants.default_web_combo_select;
        }
    }
    else if (isReq.equals("1"))
    {
        bankCode = (String) request.getParameter("cmbBank");
        winSess = (String) request.getParameter("cmbSession");
        fromTimeHour = (String) request.getParameter("cmbFromHH");
        fromTimeMinute = (String) request.getParameter("cmbFromMM");
        toTimeHour = (String) request.getParameter("cmbToHH");
        toTimeMinute = (String) request.getParameter("cmbToMM");
        addOrUpdate = (String) request.getParameter("hdnAddorUpdate");
        defaultSessionStartTime = (String) request.getParameter("hdnDefaultFromTime");
        defaultSessionEndTime = (String) request.getParameter("hdnDefaultToTime");

        if (bankCode.equals(LCPL_Constants.status_all))
        {
            for (Bank bnk : colBank)
            {
                Window win = DAOFactory.getWindowDAO().getWindow(bnk.getBankCode(), winSess);
                
                if(win==null)
                {
                    addOrUpdate = "0";
                }
                else
                {
                    addOrUpdate = "1";
                }

                WindowDAO windowDAO = DAOFactory.getWindowDAO();

                if (addOrUpdate != null && addOrUpdate.equals("1"))
                {
                    result = windowDAO.updateWindow(new Window(bnk.getBankCode(), winSess, fromTimeHour + fromTimeMinute, toTimeHour + toTimeMinute, defaultSessionStartTime, defaultSessionEndTime, userName));

                    if (!result)
                    {
                        msg = windowDAO.getMsg();
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_modify_window_details, "| Bank Code  - " + bnk.getBankCode() + ", Session  - " + winSess + ", From - (New : " + fromTimeHour + ":" + fromTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutontime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + "), To - (New : " + toTimeHour + ":" + toTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutofftime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                    }
                    else
                    {
                        isWindowAlreadySet = true;
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_modify_window_details, "| Bank Code  - " + bnk.getBankCode() + ", Session  - " + winSess + ", From - (New : " + fromTimeHour + ":" + fromTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutontime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + "), To - (New : " + toTimeHour + ":" + toTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutofftime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                    }

                }
                else if (addOrUpdate != null && addOrUpdate.equals("0"))
                {
                    result = windowDAO.addWindow(new Window(bnk.getBankCode(), winSess, fromTimeHour + fromTimeMinute, toTimeHour + toTimeMinute, defaultSessionStartTime, defaultSessionEndTime, userName));

                    if (!result)
                    {
                        msg = windowDAO.getMsg();
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_add_new_window_details, "| Bank Code - " + bnk.getBankCode() + ", Session - " + winSess + ", From - " + fromTimeHour + ":" + fromTimeMinute + ", To - " + toTimeHour + ":" + toTimeMinute + " | Process Status - Unsuccess (" + msg + ") | Added By - " + userName + " (" + userTypeDesc + ") |"));
                    }
                    else
                    {
                        isWindowAlreadySet = true;
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_add_new_window_details, "| Bank Code - " + bnk.getBankCode() + ", Session - " + winSess + ", From - " + fromTimeHour + ":" + fromTimeMinute + ", To - " + toTimeHour + ":" + toTimeMinute + " | Process Status - Success | Added By - " + userName + " (" + userTypeDesc + ") |"));
                    }
                }
                else
                {
                    msg = LCPL_Constants.msg_error_while_processing;
                }
            }
        }
        else
        {
            Window win = DAOFactory.getWindowDAO().getWindow(bankCode, winSess);

            WindowDAO windowDAO = DAOFactory.getWindowDAO();

            if (addOrUpdate != null && addOrUpdate.equals("1"))
            {
                result = windowDAO.updateWindow(new Window(bankCode, winSess, fromTimeHour + fromTimeMinute, toTimeHour + toTimeMinute, defaultSessionStartTime, defaultSessionEndTime, userName));

                if (!result)
                {
                    msg = windowDAO.getMsg();
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_modify_window_details, "| Bank Code  - " + bankCode + ", Session  - " + winSess + ", From - (New : " + fromTimeHour + ":" + fromTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutontime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + "), To - (New : " + toTimeHour + ":" + toTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutofftime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + ") | Process Status - Unsuccess (" + msg + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                }
                else
                {
                    isWindowAlreadySet = true;
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_modify_window_details, "| Bank Code  - " + bankCode + ", Session  - " + winSess + ", From - (New : " + fromTimeHour + ":" + fromTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutontime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + "), To - (New : " + toTimeHour + ":" + toTimeMinute + ", Old : " + DateFormatter.doFormat(DateFormatter.getTime(win.getCutofftime(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm) + ") | Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                }

            }
            else if (addOrUpdate != null && addOrUpdate.equals("0"))
            {
                result = windowDAO.addWindow(new Window(bankCode, winSess, fromTimeHour + fromTimeMinute, toTimeHour + toTimeMinute, defaultSessionStartTime, defaultSessionEndTime, userName));

                if (!result)
                {
                    msg = windowDAO.getMsg();
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_add_new_window_details, "| Bank Code - " + bankCode + ", Session - " + winSess + ", From - " + fromTimeHour + ":" + fromTimeMinute + ", To - " + toTimeHour + ":" + toTimeMinute + " | Process Status - Unsuccess (" + msg + ") | Added By - " + userName + " (" + userTypeDesc + ") |"));
                }
                else
                {
                    isWindowAlreadySet = true;
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_window_maintenance_add_new_window_details, "| Bank Code - " + bankCode + ", Session - " + winSess + ", From - " + fromTimeHour + ":" + fromTimeMinute + ", To - " + toTimeHour + ":" + toTimeMinute + " | Process Status - Success | Added By - " + userName + " (" + userTypeDesc + ") |"));
                }
            }
            else
            {
                msg = LCPL_Constants.msg_error_while_processing;
            }

        }

    }
%>
<html>
    <head>
        <title>OUSDPS Web - Add New Window Status</title>
        <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="../js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/digitalClock.js"></script>

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

            var cmbBankVal = document.getElementById('cmbBank').value;
            var cmbSessionVal = document.getElementById('cmbSession').value;
            var cmbFromHHVal = document.getElementById('cmbFromHH').value;
            var cmbFromMMVal = document.getElementById('cmbFromMM').value;
            var cmbToHHVal = document.getElementById('cmbToHH').value;
            var cmbToMMVal = document.getElementById('cmbToMM').value;


            if(cmbBankVal==null || cmbBankVal=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please select a Bank!");
            return false;
            }

            if(cmbSessionVal==null || cmbSessionVal=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please select a Session!");
            return false;
            }

            if(cmbFromHHVal==null || cmbFromHHVal=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please select a valid value for 'From Time - Hour'.");
            return false;
            }
            if(cmbFromMMVal==null || cmbFromMMVal=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please select a valid value for 'From Time - Minute'.");
            return false;
            }
            if(cmbToHHVal==null || cmbToHHVal=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please select a valid value for 'To Time - Hour'.");
            return false;
            }
            if(cmbToMMVal==null || cmbToMMVal=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please select a valid value for 'To Time - Minute'.");
            return false;
            }

            if(validateTimes(cmbFromHHVal, cmbFromMMVal, cmbToHHVal, cmbToMMVal))
            {
            return true;
            }
            else
            {
            return false;
            }
            }

            function validateTimes(fromHH, fromMM, toHH, toMM)
            {

            if(parseInt(toHH) > parseInt(fromHH))
            {
            return true; 
            }
            else if(parseInt(toHH) = parseInt(fromHH))
            {
            if(parseInt(toMM) >= parseInt(fromMM))
            {
            return true;
            }
            else
            {
            alert("'To Time' can't be lesser than 'From Time'!");
            return false;
            }                        
            }
            else
            {
            alert("'To Time' can't be lesser than 'From Time'!");
            return false;
            }
            }

            function clearRecords()
            {

            document.getElementById('cmbBank').selectedIndex = 0;
            document.getElementById('cmbSession').selectedIndex = 0;
            document.getElementById('cmbFromHH').selectedIndex = 0;
            document.getElementById('cmbFromMM').selectedIndex = 0;
            document.getElementById('cmbToHH').selectedIndex = 0; 
            document.getElementById('cmbToMM').selectedIndex = 0; 				
            document.getElementById('hdnDefaultFromTime').value = "<%=LCPL_Constants.default_web_combo_select%>";
            document.getElementById('hdnDefaultToTime').value = "<%=LCPL_Constants.default_web_combo_select%>";
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

            function loadDefaults()
            {				
            if("<%=defaultStartTime_Hour%>"=="<%=LCPL_Constants.default_web_combo_select%>")
            {
            alert("Please select session value for load the default values for times!'.");                    
            }
            else
            {                
            var valCmbFromHour = "<%=defaultStartTime_Hour < 10 ? "0" + defaultStartTime_Hour : "" + defaultStartTime_Hour%>";
            var valCmbFromMinutes = "<%=defaultStartTime_Minute <= 10 ? "0" + defaultStartTime_Minute : "" + defaultStartTime_Minute%>";
            var valCmbToHour = "<%=defaultEndTime_Hour < 10 ? "0" + defaultEndTime_Hour : "" + defaultEndTime_Hour%>";
            var valCmbToMinutes = "<%=defaultEndTime_Minute < 10 ? "0" + defaultEndTime_Minute : "" + defaultEndTime_Minute%>";

            var objCmbFromHour = document.getElementById('cmbFromHH');
            var objCmbFromMinutes  = document.getElementById('cmbFromMM');
            var objCmbToHour = document.getElementById('cmbToHH');
            var objCmbToMinutes = document.getElementById('cmbToMM');                

            for(i=0;i<objCmbFromHour.length;i++)
            {
            if(objCmbFromHour.options[i].value == valCmbFromHour)
            {
            objCmbFromHour.selectedIndex = i;
            }                
            }

            for(i=0;i<objCmbFromMinutes.length;i++)
            {
            if(objCmbFromMinutes.options[i].value == valCmbFromMinutes)
            {
            objCmbFromMinutes.selectedIndex = i;
            }                
            }

            for(i=0;i<objCmbToHour.length;i++)
            {
            if(objCmbToHour.options[i].value == valCmbToHour)
            {
            objCmbToHour.selectedIndex = i;
            }                
            }

            for(i=0;i<objCmbToMinutes.length;i++)
            {
            if(objCmbToMinutes.options[i].value == valCmbToMinutes)
            {
            objCmbToMinutes.selectedIndex = i;
            }                
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

            function doSearch()
            {
            var cmbBankVal = document.getElementById('cmbBank').value;

            if(cmbBankVal==null || cmbBankVal=="-1")
            {
            clearRecords();
            return false;
            }
            else
            {			
            setRequestType(false);
            document.frmAddModifyWindow.action="AddModifyWindowRecord.jsp";
            document.frmAddModifyWindow.submit();
            return true;
            }
            }

            function doUpdate()
            {
            setRequestType(true);

            if(fieldValidation())
            {                        
            document.frmAddModifyWindow.action="AddModifyWindowRecord.jsp";
            document.frmAddModifyWindow.submit();
            }
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Add / Modify Window Status</td>
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
                                                                                            <form name="frmAddModifyWindow" id="frmAddModifyWindow" >


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

                                                                                                                Window Time(s) added/Updated Sucessfully.


                                                                                                            </div>
                                                                                                            <% }
                                                                                                            else
                                                                                                            {%>


                                                                                                            <div id="displayMsg_error" class="cits_Display_Error_msg" >Window Time(s) adding/Updation Failed.- <span class="cits_error"><%=msg%></span></div>
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
                                                                                                                                            <td bgcolor="#B3D5C0" class="cits_tbl_header_text" >Bank <span class="cits_required_field">*</span> :  </td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text">
                                                                                                                                                <select name="cmbBank" id="cmbBank"  class="cits_field_border" onChange="doSearch()" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <%
                                                                                                                                                        if (bankCode == null || bankCode.equals(LCPL_Constants.default_web_combo_select))
                                                                                                                                                        {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=LCPL_Constants.default_web_combo_select%>" selected="selected">-- Select --</option>
                                                                                                                                                    <% }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=LCPL_Constants.default_web_combo_select%>">-- Select --</option>
                                                                                                                                                    <%  }
                                                                                                                                                    %>

                                                                                                                                                    <option value="<%=LCPL_Constants.status_all%>" <%=(bankCode != null && bankCode.equals(LCPL_Constants.status_all)) ? "selected" : ""%>>ALL</option>

                                                                                                                                                    <%
                                                                                                                                                        if (colBank != null && colBank.size() > 0)
                                                                                                                                                        {
                                                                                                                                                            for (Bank bank : colBank)
                                                                                                                                                            {
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=bank.getBankCode()%>" <%=(bankCode != null && bank.getBankCode().equals(bankCode)) ? "selected" : ""%> >
                                                                                                                                                        <%=bank.getBankCode() + " - " + bank.getBankFullName()%></option>
                                                                                                                                                        <%
                                                                                                                                                                }
                                                                                                                                                            }
                                                                                                                                                        %>
                                                                                                                                                </select></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td bgcolor="#B3D5C0" class="cits_tbl_header_text">Session <span class="cits_required_field">*</span> : </td>
                                                                                                                                            <td bgcolor="#DFEFDE" class="cits_common_text"><select name="cmbSession" id="cmbSession" class="cits_field_border" onChange="doSearch()" onFocus="hideMessage_onFocus()">
                                                                                                                                                    <% %>
                                                                                                                                                    <option value="<%=LCPL_Constants.default_web_combo_select%>" <%=(winSess != null && winSess.equals(LCPL_Constants.default_web_combo_select)) ? "selected" : ""%>>-- Select Session --</option>
                                                                                                                                                    <option value="<%=LCPL_Constants.window_session_one%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_one)) ? "selected" : ""%>><%=LCPL_Constants.window_session_one%></option>
                                                                                                                                                    <option value="<%=LCPL_Constants.window_session_two%>" <%=(winSess != null && winSess.equals(LCPL_Constants.window_session_two)) ? "selected" : ""%>><%=LCPL_Constants.window_session_two%></option>
                                                                                                                                                </select></td>
                                                                                                                                        </tr>

                                                                                                                                        <tr>
                                                                                                                                            <td bgcolor="#B3D5C0" class="cits_tbl_header_text">From Time<span class="cits_required_field"> *</span> :</td>
                                                                                                                                            <td align="left" bgcolor="#DFEFDE" class="cits_common_text">



                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><select name="cmbFromHH" id="cmbFromHH" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                                <option value="<%=LCPL_Constants.default_web_combo_select%>" <%=fromTimeHour.equals(LCPL_Constants.default_web_combo_select) ? "selected" : ""%>>- Hour -</option>
                                                                                                                                                                <%
                                                                                                                                                                    for (int i = 0; i < 24; i++)
                                                                                                                                                                    {
                                                                                                                                                                        if (i < 10)
                                                                                                                                                                        {
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%="0" + i%>" <%=fromTimeHour.equals("0" + i) ? "selected" : ""%>><%="0" + i%></option>
                                                                                                                                                                <%
                                                                                                                                                                }
                                                                                                                                                                else
                                                                                                                                                                {
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=i%>" <%=fromTimeHour.equals("" + i) ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                <%
                                                                                                                                                                        }
                                                                                                                                                                    }%>
                                                                                                                                                            </select>                                                                                            </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnDefaultFromTime" id="hdnDefaultFromTime" value="<%=defaultSessionStartTime%>" /></td>
                                                                                                                                                        <td><select name="cmbFromMM" id="cmbFromMM" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                                <option value="<%=LCPL_Constants.default_web_combo_select%>" <%=fromTimeMinute.equals(LCPL_Constants.default_web_combo_select) ? "selected" : ""%>>- Minute -</option>
                                                                                                                                                                <%
                                                                                                                                                                    for (int i = 0; i <= 59; i++)
                                                                                                                                                                    {
                                                                                                                                                                        if (i < 10)
                                                                                                                                                                        {%>
                                                                                                                                                                <option value="<%="0" + i%>" <%=fromTimeMinute.equals("0" + i) ? "selected" : ""%>><%="0" + i%></option>

                                                                                                                                                                <%}
                                                                                                                                                                else
                                                                                                                                                                {%>
                                                                                                                                                                <option value="<%=i%>" <%=fromTimeMinute.equals("" + i) ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                <%}
                                                                                                                                                                    }%>
                                                                                                                                                            </select>                                                                                            </td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td><input name="btnClear" id="btnClear" value="Load Defaults" type="button" onClick="loadDefaults()" class="cits_custom_button_small" /></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>                                                                                </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td bgcolor="#B3D5C0" class="cits_tbl_header_text">To Time<span class="cits_required_field">*</span> :</td>
                                                                                                                                            <td align="left" bgcolor="#DFEFDE" class="cits_common_text">



                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><select name="cmbToHH" id="cmbToHH" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                                <option value="<%=LCPL_Constants.default_web_combo_select%>" <%=toTimeHour.equals(LCPL_Constants.default_web_combo_select) ? "selected" : ""%>>- Hour -</option>
                                                                                                                                                                <%
                                                                                                                                                                    for (int i = 0; i < 24; i++)
                                                                                                                                                                    {
                                                                                                                                                                        if (i < 10)
                                                                                                                                                                        {
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%="0" + i%>" <%=toTimeHour.equals("0" + i) ? "selected" : ""%>><%="0" + i%></option>
                                                                                                                                                                <%
                                                                                                                                                                }
                                                                                                                                                                else
                                                                                                                                                                {
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=i%>" <%=toTimeHour.equals("" + i) ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                <%
                                                                                                                                                                        }
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                            </select>                                                                                            </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnDefaultToTime" id="hdnDefaultToTime" value="<%=defaultSessionEndTime%>" /></td>
                                                                                                                                                        <td><select name="cmbToMM" id="cmbToMM" class="cits_field_border" onFocus="hideMessage_onFocus()">
                                                                                                                                                                <option value="<%=LCPL_Constants.default_web_combo_select%>" <%=toTimeMinute.equals(LCPL_Constants.default_web_combo_select) ? "selected" : ""%>>- Minute -</option>
                                                                                                                                                                <%for (int i = 0;
                                                                                                                                                                            i <= 59; i++)
                                                                                                                                                                    {
                                                                                                                                                                        if (i < 10)
                                                                                                                                                                        {%>
                                                                                                                                                                <option value="<%="0" + i%>" <%=toTimeMinute.equals("0" + i) ? "selected" : ""%>><%="0" + i%></option>

                                                                                                                                                                <%}
                                                                                                                                                                else
                                                                                                                                                                {%>
                                                                                                                                                                <option value="<%=i%>" <%=toTimeMinute.equals("" + i) ? "selected" : ""%>><%=i%></option>
                                                                                                                                                                <%}
                                                                                                                                                                    }%>
                                                                                                                                                            </select>                                                                                            </td></tr>
                                                                                                                                                </table>                                                                                </td>
                                                                                                                                        </tr>

                                                                                                                                        <tr><td height="35" bgcolor="#CDCDCD"></td>
                                                                                                                                            <td align="right" valign="bottom" bgcolor="#CDCDCD">

                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input type="button" value="<%=isWindowAlreadySet ? "Update" : "Add"%>" onClick="doUpdate()" class="cits_custom_button">                                                                                            </td>
                                                                                                                                                        <td width="5"><input type="hidden" name="hdnReq" id="hdnReq" value="<%=isReq%>" /><input type="hidden" name="hdnAddorUpdate" id="hdnAddorUpdate" value="<%=isWindowAlreadySet ? "1" : "0"%>" /></td>
                                                                                                                                                        <td><input type="reset" name="btnClear" id="btnClear" value="Clear" class="cits_custom_button"/>                                                                                            </td></tr>
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

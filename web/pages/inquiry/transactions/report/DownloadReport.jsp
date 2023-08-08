
<%@page import="java.util.*,java.sql.*,java.io.File" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"%>
<%@page import="java.util.Collection,java.util.Date" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../../error.jsp"%>
<%@page import="java.io.FileInputStream" errorPage="../../../../error.jsp"%>
<%@page import="java.io.BufferedInputStream"  errorPage="../../../../error.jsp"%>
<%@page import="java.io.File"  errorPage="../../../../error.jsp"%>
<%@page import="java.io.IOException" errorPage="../../../../error.jsp"%>
<%@page import="java.io.*" errorPage="../../../../error.jsp"%>
<%@page import="java.util.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter"  errorPage="../../../../error.jsp"%>
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
    String reportName = (String) request.getParameter("hdnFileName");
    String reportPath = (String) request.getParameter("hdnFilePath");

    File reportFile = null;
    BufferedInputStream bufIn = null;
    ServletOutputStream servOut = null;
    int reportSize = -1;

    reportFile = new File(reportPath);

    if (reportFile.exists())
    {
        reportSize = (int) reportFile.length();

        try
        {
            servOut = response.getOutputStream();

            //set response headers
            response.setContentType("text/plain");

            if (reportFile.getName().endsWith(LCPL_Constants.report_type_owd_bk1_report_name_suffix_full))
            {
                response.addHeader("Content-Disposition", "attachment; filename=" + reportFile.getName().replaceAll(LCPL_Constants.report_type_owd_bk1_report_name_suffix_full, LCPL_Constants.report_type_owd_bk1_report_name_original_suffix));
            }
            else
            {
                response.addHeader("Content-Disposition", "attachment; filename=" + reportFile.getName());
            }
            
            response.setContentLength(reportSize);

            FileInputStream input = new FileInputStream(reportFile);
            bufIn = new BufferedInputStream(input);
            int readBytes = 0;

            //read from the file; write to the ServletOutputStream
            while ((readBytes = bufIn.read()) != -1)
            {
                servOut.write(readBytes);
            }

            if (DAOFactory.getReportDAO().updateDownloadDetails(reportName, userName))
            {

                System.out.println("Report file - " + reportName + "  username - " + userName + ",  download status updatation is successful.");
            }
            else
            {
                System.out.println("Report file - " + reportName + "  username - " + userName + ",  download status updatation is unsuccessful.");
            }

            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_ows_summary_ows_file_download, "| File Id - " + reportFile.getName() + ", Download Status. - Successful , Downloaded By - " + userName + " (" + userTypeDesc + ") |"));

        }
        catch (IOException e)
        {
            System.out.println(e.getMessage());
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_ows_summary_ows_file_download, "| File Id - " + reportFile.getName() + ", Download Status. - Unsuccessful (" + e.getMessage() + ") , Downloaded By - " + userName + " (" + userTypeDesc + ") |"));
            //throw new ServletException();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
        finally
        {
            if (servOut != null)
            {
                servOut.close();
            }
            if (bufIn != null)
            {
                bufIn.close();
            }
        }
    }
    else
    {
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_ows_summary_ows_file_download, "| File Id - " + reportFile.getName() + ", Download Status. - Unsuccessful (File Not Available) , Downloaded By - " + userName + " (" + userTypeDesc + ") |"));
        response.sendRedirect(request.getContextPath() + "/error.jsp");
    }
%>



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    </body>
</html>
<%
    }
%>

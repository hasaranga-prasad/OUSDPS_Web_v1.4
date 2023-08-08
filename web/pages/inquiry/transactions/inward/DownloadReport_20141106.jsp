
<%@page import="lk.com.ttsl.ousdps.services.utils.FileManager"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../../../error.jsp"%>
<%@page import="java.io.BufferedInputStream"  errorPage="../../../../error.jsp"%>
<%@page import="java.io.File"  errorPage="../../../../error.jsp"%>
<%@page import="java.io.IOException" errorPage="../../../../error.jsp"%>
<%@page import="java.io.*" errorPage="../../../../error.jsp"%>
<%@page import="java.util.*" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"%>
<%@page import="java.util.Collection,java.util.Date" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../../../error.jsp"%>
<%@page import="java.io.FileInputStream" errorPage="../../../../error.jsp"%>
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

    String reportName = request.getParameter("hdnFileName");
    String reportPath = request.getParameter("hdnFilePath");

    String businessDate = request.getParameter("hdnBusinessDate");
    String sess = request.getParameter("hdnSession");
    String bnk = request.getParameter("hdnBank");
    String subBnk = request.getParameter("hdnSubBank");


    //System.out.println("ReportName --> " +ReportName);
    //System.out.println("ReportPath --> " +ReportPath);

    String commonPathWeb = null;
    File reportFile = null;
    File desDirectory = null;
    File desFile = null;
    FileManager fm = null;
    //BufferedInputStream bufIn = null;
    //ServletOutputStream servOut = null;
    int reportSize = -1;

    commonPathWeb = request.getSession().getServletContext().getRealPath(LCPL_Constants.directory_separator);

    reportFile = new File(reportPath);

    if (subBnk != null && subBnk.length() > 0)
    {
        desDirectory = new File(commonPathWeb + LCPL_Constants.directory_uploadedFiles + LCPL_Constants.directory_separator + LCPL_Constants.directory_inward + LCPL_Constants.directory_separator + businessDate + LCPL_Constants.directory_separator + sess + LCPL_Constants.directory_separator + bnk + LCPL_Constants.directory_separator + subBnk + LCPL_Constants.directory_separator);
    }
    else
    {
        desDirectory = new File(commonPathWeb + LCPL_Constants.directory_uploadedFiles + LCPL_Constants.directory_separator + LCPL_Constants.directory_inward + LCPL_Constants.directory_separator + businessDate + LCPL_Constants.directory_separator + sess + LCPL_Constants.directory_separator + bnk + LCPL_Constants.directory_separator);
    }

    System.out.println("commonPathWeb --> " + commonPathWeb);

    //desDirectory = new File(commonPathWeb + LCPL_Constants.directory_uploadedFiles + LCPL_Constants.directory_separator + LCPL_Constants.directory_inward + LCPL_Constants.directory_separator + businessDate + LCPL_Constants.directory_separator + sess + LCPL_Constants.directory_separator + bnk + LCPL_Constants.directory_separator + subBnk + LCPL_Constants.directory_separator);

    try
    {

        if (reportFile.exists())
        {
            reportSize = (int) reportFile.length();

            if (!desDirectory.exists())
            {
                desDirectory.mkdirs();
            }

            desFile = new File(desDirectory, reportFile.getName());

            System.out.println("desFile  --> " + desFile.getAbsolutePath());

            fm = new FileManager();

            if (fm.copyfile(reportFile, desFile, false))
            {
                if (DAOFactory.getInwardFilesDAO().updateDownloadDetails(reportPath, userName))
                {

                    System.out.println("Report file - " + reportName + "  username - " + userName + ",  download status updation is successful.");
                }
                else
                {
                    System.out.println("Report file - " + reportName + "  username - " + userName + ",  download status updation is unsuccessful.");
                }

                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_inward_download, "| File Id - " + reportFile.getName() + ", File Type - .pdf, Download Status. - Successful , Downloaded By - " + userName + " (" + userTypeDesc + ") |"));



                if (subBnk != null && subBnk.length() > 0)
                {
                    response.sendRedirect(request.getContextPath() + LCPL_Constants.directory_separator_web + LCPL_Constants.directory_uploadedFiles + LCPL_Constants.directory_separator_web + LCPL_Constants.directory_inward + LCPL_Constants.directory_separator_web + businessDate + LCPL_Constants.directory_separator_web + sess + LCPL_Constants.directory_separator_web + bnk + LCPL_Constants.directory_separator_web + subBnk + LCPL_Constants.directory_separator_web + reportFile.getName());
                }
                else
                {
                    response.sendRedirect(request.getContextPath() + LCPL_Constants.directory_separator_web + LCPL_Constants.directory_uploadedFiles + LCPL_Constants.directory_separator_web + LCPL_Constants.directory_inward + LCPL_Constants.directory_separator_web + businessDate + LCPL_Constants.directory_separator_web + sess + LCPL_Constants.directory_separator_web + bnk + LCPL_Constants.directory_separator_web + reportFile.getName());
                }


            }
            else
            {
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_inward_download, "| File Id - " + reportFile.getName() + ", File Type - .pdf, Download Status. - Unsuccessful (Copy file failed!) , Downloaded By - " + userName + " (" + userTypeDesc + ") |"));
                //throw new ServletException();
                response.sendRedirect(request.getContextPath() + "/error.jsp");
            }
        }
        else
        {
            System.out.println("Source file not available!");
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_inward_download, "| File Id - " + reportFile.getName() + ", File Type - .pdf, Download Status. - Unsuccessful (Source file not available!) , Downloaded By - " + userName + " (" + userTypeDesc + ") |"));
            //throw new ServletException();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }

    }
    catch (Exception e)
    {
        System.out.println(e.getMessage());
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_inquiry_transaction_inward_download, "| File Id - " + reportFile.getName() + ", File Type - .pdf, Download Status. - Unsuccessful (" + e.getMessage() + ") , Downloaded By - " + userName + " (" + userTypeDesc + ") |"));
        //throw new ServletException();
        response.sendRedirect(request.getContextPath() + "/error.jsp");
    }



%>



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OUSDPS Web</title>
    </head>
    <body>
    </body>
</html>
<%}
%>

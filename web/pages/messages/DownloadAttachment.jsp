
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="java.io.BufferedInputStream"  errorPage="../../error.jsp"%>
<%@page import="java.io.File"  errorPage="../../error.jsp"%>
<%@page import="java.io.IOException" errorPage="../../error.jsp"%>
<%@page import="java.io.*" errorPage="../../error.jsp"%>
<%@page import="java.util.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="java.util.Collection,java.util.Date" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.CustomDate" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.Parameter" errorPage="../../error.jsp"%>
<%@page import="java.io.FileInputStream" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter"  errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.window.Window" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.services.utils.PropertyLoader" errorPage="../../error.jsp"%>
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
<%    
    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_businessdate), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_session);    
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);    
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();   
    
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, LCPL_Constants.status_yes);
%>

<%

    String fileName = request.getParameter("hdnFileName");
    String filePath = request.getParameter("hdnFilePath");
    String fileExtension = null;
    
    //System.out.println("hdnFileName --> " +fileName);
    //System.out.println("hdnFilePath --> " +filePath);   

    File attachmentFile = null;
    BufferedInputStream bufIn = null;
    ServletOutputStream servOut = null;
    int reportSize = -1;

    fileExtension = fileName.substring(fileName.indexOf("."));
    attachmentFile = new File(filePath);

    if (attachmentFile.exists())
    {
        reportSize = (int) attachmentFile.length();

        try
        {
            servOut = response.getOutputStream();

            //set response headers
            //response.setContentType("text/plain");
            response.setContentType("application/octet-stream");
            response.addHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength(reportSize);

            FileInputStream input = new FileInputStream(attachmentFile);
            bufIn = new BufferedInputStream(input);
            int readBytes = 0;

            //read from the file; write to the ServletOutputStream
            while ((readBytes = bufIn.read()) != -1)
            {
                servOut.write(readBytes);
            }

            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_download_attachment, "| Attachment Name - " + attachmentFile.getName() + ", File Type - " + fileExtension + ", Download Status. - Successful , Downloaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));

        }
        catch (IOException e)
        {
            System.out.println(e.getMessage());
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_download_attachment, "| Attachment Name - " + attachmentFile.getName() + ", File Type - " + fileExtension + ", Download Status. - Unsuccessful (" + e.getMessage() + ") , Downloaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
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
        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_message_download_attachment, "| Attachment Name - " + attachmentFile.getName() + ", File Type - " + fileExtension + ", Download Status. - Unsuccessful (Attachment Not Available) , Downloaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        response.sendRedirect(request.getContextPath() + "/error.jsp");
    }
%>



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OUSDPS Web (Version 1.2.0 - 2018)</title>
    </head>
    <body>
    </body>
</html>
<%
    }
%>

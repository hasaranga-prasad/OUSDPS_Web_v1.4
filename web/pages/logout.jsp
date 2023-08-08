<%@page import="java.sql.*,java.util.*,java.io.*" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../error.jsp"%>
<%

    String userName = null;
    String userType = null;
    String userTypeDesc = null;

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

        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_logout_info, "| Username - " + userName + " (" + userTypeDesc + ") | Status - Logout Success |"));
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collection"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" %>
<%@page import="lk.com.ttsl.ousdps.dao.user.pwd.history.PWD_History"%>
<%@page import="lk.com.ttsl.ousdps.services.utils.PropertyLoader"%>
<%
    String session_userName = null;

    session_userName = (String) session.getAttribute("session_userName");

    String pwd = request.getParameter("p");

    int iMinPwdHistory = 1;

    try
    {
        String strMinPwdHistory = DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_minimum_pwd_history);

        if (strMinPwdHistory != null)
        {
            iMinPwdHistory = Integer.parseInt(strMinPwdHistory);
        }
        else
        {
            iMinPwdHistory = 1;
        }
    }
    catch (Exception e)
    {
        iMinPwdHistory = 1;
    }

    boolean isPWDNotAvailableInHis = DAOFactory.getPWD_HistoryDAO().isPWDNotAvailableInHistory(session_userName, pwd, iMinPwdHistory);
           
    
    if (isPWDNotAvailableInHis)
    {
        out.println("1");
        //System.out.println("isPWDNotAvailableInHis ===> 1");
    }
    else
    {
        out.println("0");
        //System.out.println("isPWDNotAvailableInHis ===> 0");
    }

%>
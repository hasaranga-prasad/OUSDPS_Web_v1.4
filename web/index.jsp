%@page language="java" import="java.sql.*,java.util.*,java.io.*" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.User" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.DateFormatter" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="error.jsp"%>

<%

    String ip = null;

    String isAuhenticated = null;
    String userName = null;
    String password = null;
    String branchId = null;
    String branchName = null;
    String userType = null;
    String userTypeDesc = null;
    String menuId = null;
    String menuName = null;
    String bankName = null;
    String bankCode = null;

    try
    {
        ip = request.getHeader("x-forwarded-for");

        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getRemoteAddr();
        }

        System.out.println("Remote IP Address - " + ip);
    }
    catch (Exception e)
    {
        System.out.println("Warning: Error occured while reading remote IP address! - " + e.getMessage());
    }

    isAuhenticated = (String) session.getAttribute("session_isAuthenticated");

    if (isAuhenticated == null || isAuhenticated.equals("null"))
    {
        userName = (String) request.getParameter("txtUserName");

        if (userName == null)
        {
            session.invalidate();
            //response.sendRedirect("pages/login.jsp?msg=u");
            response.sendRedirect("pages/login.jsp");
        }
        else if (userName.equals("null") || (userName != null && userName.trim().length() < 1))
        {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=up");
        }
        else
        {
            password = (String) request.getParameter("txtPassword");

            if (password == null || password.equals("null") || (password != null && password.trim().length() < 1))
            {
                //session.invalidate();
                //session.setAttribute("session_isinitlogin", LCPL_Constants.status_no);
                response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=up");
            }
            else
            {
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_login_info, "| Username - " + userName + "| Remote IP - " + ip + " | Status - New Login Attempt. |"));

                boolean isAuth = DAOFactory.getUserDAO().isAuthorized(new User(userName, password, LCPL_Constants.status_active));

                System.out.println(" isAuth value - " + isAuth + " for the user - " + userName);

                if (isAuth)
                {
                    
                    int iWebSessionExpTime = LCPL_Constants.default_web_session_expire_time;                   

                    try
                    {
                        iWebSessionExpTime = Integer.parseInt(DAOFactory.getParameterDAO().getParamValueById(LCPL_Constants.param_id_web_session_exptime));
                    }
                    catch (Exception e)
                    {
                        iWebSessionExpTime = LCPL_Constants.default_web_session_expire_time;
                    }

                    boolean isCurLoggedIn = DAOFactory.getUserDAO().isCurrentlyLoggedin(userName, iWebSessionExpTime);
                    
                    
                    
                    
                    boolean bool = DAOFactory.getUserDAO().setUserLoggingAttempts(userName, LCPL_Constants.status_success);
               
                    if (DAOFactory.getUserDAO().isInitialLogin(userName, LCPL_Constants.status_active))
                    {
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_login_info, "| Username - " + userName + " | Status - Login Success and Prompt Initial Password Change. |"));

                        User user = DAOFactory.getUserDAO().getUserDetails(userName, LCPL_Constants.status_all);
                        userTypeDesc = user.getUserLevelDesc();

                        session.setAttribute("session_userName", userName);
                        session.setAttribute("session_userTypeDesc", userTypeDesc);
                        session.setAttribute("session_isAuthenticated", LCPL_Constants.is_authorized_yes);
                        session.setAttribute("session_isInitLogin", LCPL_Constants.status_yes);
                        response.sendRedirect("pages/user/initPwdChange.jsp");
                        
                         System.out.println("session_userName" + userName);
                         System.out.println("session_userTypeDesc"+userTypeDesc);
                         System.out.println("session_isAuthenticated" +LCPL_Constants.is_authorized_yes);
                         System.out.println("session_isInitLogin" +LCPL_Constants.status_yes);
                         
                    }
                    else
                    {
                        
                        System.out.println("just PWWWWWWWWW");
                        int pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(userName);  
                        System.out.println("userName pwdValidityPeriod" +pwdValidityPeriod);
                        if (pwdValidityPeriod < 0)
                        {
                            DAOFactory.getUserDAO().setUserStatus(userName, LCPL_Constants.status_expired);
                            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_account_expired, "| Username - " + userName + " | Status - Account Expired " + " |"));
                            session.invalidate();
                            response.sendRedirect("pages/userAccountExpired.jsp");
                            
                            System.out.println("userName pwdValidityPeriod" + userName);
                        }
                        else
                        {

                            User user = DAOFactory.getUserDAO().getUserDetails(userName, LCPL_Constants.status_all);
                            System.out.println("user!!!!!"+user);
                            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_login_info, "| Username - " + userName + " (" + user.getUserLevelDesc() + ") | Status - Login Success |"));
                            
                            System.out.println("User!!!!!"+user);
                            
                            branchId = user.getBranchCode();
                            branchName = user.getBranchName();
                            userType = user.getUserLevelId();
                            userTypeDesc = user.getUserLevelDesc();
                            bankName = user.getBankFullName();
                            bankCode = user.getBankCode();

                            if (userType.equals(LCPL_Constants.user_type_lcpl_administrator))
                            {
                                menuId = "399000";
                                menuName = "lcplAdminMenu.js";
                                System.out.println("LCPL_Constants.user_type_lcpl_administrator!!!!!"+ LCPL_Constants.user_type_lcpl_administrator);

                                
                            }
                            if (userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator))
                            {
                                menuId = "399010";
                                menuName = "lcplOperatorMenu.js";
                            }
                            else if (userType.equals(LCPL_Constants.user_type_lcpl_helpdesk_user))
                            {
                                menuId = "399020";
                                menuName = "lcplHelpDeskMenu.js";
                            }
                            else if (userType.equals(LCPL_Constants.user_type_bank_user))
                            {
                                menuId = "399030";
                                menuName = "bankOperatorMenu.js";
                            }
                            else if (userType.equals(LCPL_Constants.user_type_lcpl_supervisor))
                            {
                                menuId = "399040";
                                menuName = "lcplSupervisorMenu.js";
                            }
                            else if (userType.equals(LCPL_Constants.user_type_lcpl_super_user))
                            {
                                menuId = "399050";
                                menuName = "lcplManagerMenu.js";
                            }
                            else if (userType.equals(LCPL_Constants.user_type_settlement_bank_user))
                            {
                                menuId = "399060";
                                menuName = "settlementBankMenu.js";
                            }
                            
                            session.setAttribute("session_userName", userName);
                            session.setAttribute("session_password", password);                            
                            session.setAttribute("session_userType", userType);
                            session.setAttribute("session_userTypeDesc", userTypeDesc);
                            session.setAttribute("session_isAuthenticated", LCPL_Constants.is_authorized_yes);
                            session.setAttribute("session_branchId", branchId);
                            session.setAttribute("session_branchName", branchName);
                            session.setAttribute("session_menuId", menuId);
                            session.setAttribute("session_menuName", menuName);
                            session.setAttribute("session_bankName", bankName);
                            session.setAttribute("session_bankCode", bankCode);
                            session.setAttribute("session_pwdvalidityperiod", pwdValidityPeriod);

                            response.sendRedirect("pages/homepage.jsp");
                        }
                    }
                }
                else
                {
                    User user = DAOFactory.getUserDAO().getUserDetails(userName, LCPL_Constants.status_all);

                    if (user != null)
                    {

                        if (user.getStatus().equals(LCPL_Constants.status_active))
                        {
                            boolean bool = DAOFactory.getUserDAO().setUserLoggingAttempts(userName, LCPL_Constants.status_fail);
                            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_login_info, "| Username - " + userName + " | Status - Login Unsuccess, Invalid Password. |"));
                            session.invalidate();
                            response.sendRedirect("pages/login.jsp?msg=up");
                        }
                        else if (user.getStatus().equals(LCPL_Constants.status_pending))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_access_denied, "| Username - " + userName + " | Status - Login Unsuccess, User Access Denied Due To Pending User Account. |"));
                            session.invalidate();
                            response.sendRedirect("pages/accessDenied.jsp");
                        }
                        else if (user.getStatus().equals(LCPL_Constants.status_deactive))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_access_denied, "| Username - " + userName + " | Status - Login Unsuccess, User Access Denied Due To Inactive User Account. |"));
                            session.invalidate();
                            response.sendRedirect("pages/accessDenied.jsp");
                        }
                        else if (user.getStatus().equals(LCPL_Constants.status_locked))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_account_locked, "| Username - " + userName + " | Status - Login Unsuccess, User Account Locked. |"));
                            session.invalidate();
                            response.sendRedirect("pages/userAccountLocked.jsp");
                        }
                        else if (user.getStatus().equals(LCPL_Constants.status_expired))
                        {
                            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_account_expired, "| Username - " + userName + " | Status - Login Unsuccess, User Account Expired. |"));
                            session.invalidate();
                            response.sendRedirect("pages/userAccountExpired.jsp");
                        }
                    }
                    else
                    {
                        DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_login_info, "| Username - " + userName + " | Status - Login Unsuccess, Invalid Username. |"));
                        session.invalidate();
                        response.sendRedirect("pages/login.jsp?msg=up");
                    }

                }
            }
        }
    }
    else
    {
        userName = (String) session.getAttribute("session_userName");

        if (userName == null || userName.equals("null"))
        {
            userName = (String) request.getParameter("uName");

            if (userName == null || userName.equals("null"))
            {
                session.invalidate();
                response.sendRedirect("pages/logout.jsp");
            }
            else
            {
                int pwdValidityPeriod = DAOFactory.getUserDAO().getPasswordValidityPeriod(userName);

                if (pwdValidityPeriod < 0)
                {
                    DAOFactory.getUserDAO().setUserStatus(userName, LCPL_Constants.status_expired);
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_account_expired, "| Username - " + userName + " | Status - Account Expired. |"));
                    session.invalidate();
                    response.sendRedirect("pages/userAccountExpired.jsp");
                }
                else
                {
                    User user = DAOFactory.getUserDAO().getUserDetails(userName, LCPL_Constants.status_all);
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_login_info, "| Username - " + userName + " (" + user.getUserLevelDesc() + ") | Status - Login Success |"));

                    branchId = user.getBranchCode();
                    branchName = user.getBranchName();
                    userType = user.getUserLevelId();
                    userTypeDesc = user.getUserLevelDesc();
                    bankName = user.getBankFullName();
                    bankCode = user.getBankCode();

                    if (userType.equals(LCPL_Constants.user_type_lcpl_administrator))
                    {
                        menuId = "399000";
                        menuName = "lcplAdminMenu.js";
                        System.out.println("user_type_lcpl_administrator" + LCPL_Constants.user_type_lcpl_administrator);
                        
                    }
                    if (userType.equals(LCPL_Constants.user_type_lcpl_bcm_operator))
                    {
                        menuId = "399010";
                        menuName = "lcplOperatorMenu.js";
                         System.out.println("user_type_lcpl_bcm_operator" +LCPL_Constants.user_type_lcpl_bcm_operator);
                    }
                    else if (userType.equals(LCPL_Constants.user_type_lcpl_helpdesk_user))
                    {
                        menuId = "399020";
                        menuName = "lcplHelpDeskMenu.js";
                        System.out.println("LCPL_Constants.user_type_lcpl_helpdesk_user" +LCPL_Constants.user_type_lcpl_helpdesk_user);
                    }
                    else if (userType.equals(LCPL_Constants.user_type_bank_user))
                    {
                        menuId = "399030";
                        menuName = "bankOperatorMenu.js";
                        System.out.println("LCPL_Constants.user_type_bank_user" +LCPL_Constants.user_type_bank_user);
                    }
                    else if (userType.equals(LCPL_Constants.user_type_lcpl_supervisor))
                    {
                        menuId = "399040";
                        menuName = "lcplSupervisorMenu.js";
                        System.out.println("LCPL_Constants.user_type_lcpl_supervisor" +LCPL_Constants.user_type_lcpl_supervisor);
                    }
                    else if (userType.equals(LCPL_Constants.user_type_lcpl_super_user))
                    {
                        menuId = "399050";
                        menuName = "lcplManagerMenu.js";
                        System.out.println("LCPL_Constants.user_type_lcpl_super_user" +LCPL_Constants.user_type_lcpl_super_user);
                    }
                    else if (userType.equals(LCPL_Constants.user_type_settlement_bank_user))
                    {
                        menuId = "399060";
                        menuName = "settlementBankMenu.js";
                        System.out.println("LCPL_Constants.user_type_settlement_bank_user" +LCPL_Constants.user_type_settlement_bank_user);
                    }

                    session.setAttribute("session_userName", userName);
                    session.setAttribute("session_password", password);
                    session.setAttribute("session_userType", userType);
                    session.setAttribute("session_userTypeDesc", userTypeDesc);
                    session.setAttribute("session_isAuthenticated", LCPL_Constants.is_authorized_yes);
                    session.setAttribute("session_branchId", branchId);
                    session.setAttribute("session_branchName", branchName);
                    session.setAttribute("session_menuId", menuId);
                    session.setAttribute("session_menuName", menuName);
                    session.setAttribute("session_bankName", bankName);
                    session.setAttribute("session_bankCode", bankCode);
                    session.setAttribute("session_pwdvalidityperiod", pwdValidityPeriod);

                    response.sendRedirect("pages/homepage.jsp");
                    
                    System.out.println("session_bankName,session_bankCode"+branchName+bankCode);
                }
            }
        }
        else
        {
            response.sendRedirect("pages/homepage.jsp");
        }
    }
%>

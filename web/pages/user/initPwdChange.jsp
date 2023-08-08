
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.user.pwd.history.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.common.utils.LCPL_Constants" errorPage="../../error.jsp" %>
<%@page import="lk.com.ttsl.ousdps.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.log.LogDAO" errorPage="../../error.jsp"%>


<%
    String userName = null;
    String userTypeDesc = null;
    String isInitLogin = null;
    String isChangeReq = null;
    String strNewPassword = null;
    String msg = null;

    boolean result = false;

    userName = (String) session.getAttribute("session_userName");
    isInitLogin = (String) session.getAttribute("session_isInitLogin");

    if (userName == null || userName.equals("null"))
    {
        //session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        if (isInitLogin == null || isInitLogin.equals("null"))
        {
            //response.sendRedirect("../login.jsp");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        }
        else if (isInitLogin.equals(LCPL_Constants.status_no))
        {
            //response.sendRedirect("../../index.jsp");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
    isChangeReq = (String) request.getParameter("isChangeReq");

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

    if (isChangeReq == null || isChangeReq.equalsIgnoreCase("null"))
    {
        isChangeReq = "0";
    }
    else if (isChangeReq.equals("1"))
    {
        strNewPassword = request.getParameter("txtNewPwd");

        UserDAO userDAO = DAOFactory.getUserDAO();

        if (userName != null && strNewPassword != null)
        {
            result = userDAO.changeUserPassword(new User(userName, strNewPassword.trim()), null, true);
        }

        if (result)
        {
            PWD_HistoryDAO pwdHisDAO = DAOFactory.getPWD_HistoryDAO();

            boolean pwdHisUpdateStat = pwdHisDAO.addPWD_History(new PWD_History(userName, strNewPassword.trim()));

            if (pwdHisUpdateStat)
            {
                session.setAttribute("session_isInitLogin", LCPL_Constants.status_no);
                session.setAttribute("session_userName", null);
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_init_password_reset, "| User Name - " + userName + ") | Process Status - Success | Done By - " + userName + " (" + userTypeDesc + ") |"));
                response.sendRedirect("../../index.jsp?uName=" + userName);
            }
            else
            {
                msg = pwdHisDAO.getMsg();
                DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_init_password_reset, "| User Name - " + userName + ") | Process Status - Unsuccess update password history (" + msg + ") | Done By - " + userName + " (" + userTypeDesc + ") |"));
                response.sendRedirect("../login.jsp");
            }
        }
        else
        {
            msg = userDAO.getMsg();
            DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_user_init_password_reset, "| User Name - " + userName + ") | Process Status - Unsuccess (" + msg + ") | Done By - " + userName + " (" + userTypeDesc + ") |"));
            response.sendRedirect("../login.jsp");
        }
    }


%>
<html>
    <head>
        <title>OUSDPS Web - Initial Password Change</title>
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="<%=request.getContextPath()%>/css/tcal.css" rel="stylesheet" type="text/css" />
        <link href="../../css/cits.css" rel="stylesheet" type="text/css" />

        <script language="javascript" type="text/javascript">

            var frmChangeInitPwdActionVal = -1;

            function actionChange()
            {
                frmChangeInitPwdActionVal = 1;
            }

            function actionCancel()
            {
                frmChangeInitPwdActionVal = 0;

            }

            function validate()
            {
                if (frmChangeInitPwdActionVal == 1)
                {
                    var newPassword = document.getElementById('txtNewPwd').value;
                    var confirmPassword = document.getElementById('txtConfirmPwd').value;

                    if (isempty(newPassword))
                    {
                        alert('Please enter the New Password.');
                        return false;
                    }
                    else if (isempty(confirmPassword))
                    {
                        alert('Please enter the Confirm Password.');
                        return false;
                    }
                    else
                    {
                        if (newPassword == confirmPassword)
                        {
                            document.getElementById('isChangeReq').value = "1";
                            document.frmChangeInitPwd.action = "initPwdChange.jsp";
                            return true;
                        }
                        else
                        {
                            alert("New Password does not match with Confirm Password!");
                            document.getElementById('txtNewPwd').value = "";
                            document.getElementById('txtConfirmPwd').value = "";
                            document.getElementById('txtNewPwd').focus();
                            this.setAnimLights();
                            return false;

                        }


                    }

                }
                else if (frmChangeInitPwdActionVal == 0)
                {
                    document.frmChangeInitPwd.action = "../login.jsp";
                    return true;
                }
                else
                {
                    return false;
                }

            }

            function setAnimLights()
            {
                if (document.getElementById('validPwd') != null)
                {
                    document.getElementById('validPwd').style.display = 'none';
                }

                if (document.getElementById('invalidPwd') != null)
                {
                    document.getElementById('invalidPwd').style.display = 'none';
                }

                if (document.getElementById('btnChange') != null)
                {
                    document.getElementById('btnChange').disabled = true;
                }
            }

            function validatePassword()
            {
                var newPassword = document.getElementById('txtNewPwd').value;

                if (isempty(newPassword))
                {
                    if (document.getElementById('validPwd') != null)
                    {
                        document.getElementById('validPwd').style.display = 'none';
                    }
					
					if (document.getElementById('txtNewPwd') != null)
					{
						document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
					}

                    if (document.getElementById('invalidPwd') != null)
                    {
                        document.getElementById('invalidPwd').style.display = 'block';
                        document.getElementById('imgError').title = 'Empty Password!';
                    }

                    if (document.getElementById('btnChange') != null)
                    {
                        document.getElementById('btnChange').disabled = true;
                    }
                }
                else
                {
                    if (findSpaces(newPassword))
                    {
                        if (document.getElementById('validPwd') != null)
                        {
                            document.getElementById('validPwd').style.display = 'none';
                        }
						
						if (document.getElementById('txtNewPwd') != null)
						{
							document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
						}

                        if (document.getElementById('invalidPwd') != null)
                        {
                            document.getElementById('invalidPwd').style.display = 'block';
                            document.getElementById('imgError').title = 'Spaces not allowed!';
                        }

                        if (document.getElementById('btnChange') != null)
                        {
                            document.getElementById('btnChange').disabled = true;
                        }
                    }
                    else
                    {
                        if (trim(newPassword).length < 8)
                        {
                            if (document.getElementById('validPwd') != null)
                            {
                                document.getElementById('validPwd').style.display = 'none';
                            }
							
							if (document.getElementById('txtNewPwd') != null)
							{
								document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
							}

                            if (document.getElementById('invalidPwd') != null)
                            {
                                document.getElementById('invalidPwd').style.display = 'block';
                                document.getElementById('imgError').title = 'Password length less than 8 characters!';
                            }

                            if (document.getElementById('btnChange') != null)
                            {
                                document.getElementById('btnChange').disabled = true;
                            }
                        }
                        else
                        {
                            var userID = '<%=userName%>';                           
                            
                            if ((newPassword.toUpperCase()).indexOf(userID.toUpperCase()) >= 0)
                            {
                                if (document.getElementById('validPwd') != null)
                                    {
                                        document.getElementById('validPwd').style.display = 'none';
                                    }
									
									if (document.getElementById('txtNewPwd') != null)
									{
										document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
									}

                                    if (document.getElementById('invalidPwd') != null)
                                    {
                                        document.getElementById('invalidPwd').style.display = 'block';
                                        document.getElementById('imgError').title = 'Password can not contain UserId!';
                                    }

                                    if (document.getElementById('btnChange') != null)
                                    {
                                        document.getElementById('btnChange').disabled = true;
                                    }                                
                            }
                            else
                            {
                                if (trim(newPassword).match(/[0-9]/) && trim(newPassword).match(/[a-zA-Z]/) && trim(newPassword).match(/[^\w\s]/))
                                {
                                    isPWDNotAvailableInHistory();
                                    //validatePassword();
                                }
                                else
                                {
                                    if (document.getElementById('validPwd') != null)
                                    {
                                        document.getElementById('validPwd').style.display = 'none';
                                    }
									
									if (document.getElementById('txtNewPwd') != null)
									{
										document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
									}

                                    if (document.getElementById('invalidPwd') != null)
                                    {
                                        document.getElementById('invalidPwd').style.display = 'block';
                                        document.getElementById('imgError').title = 'Password must be a combination of alpha-numeric characters and at least one special character!';
                                    }

                                    if (document.getElementById('btnChange') != null)
                                    {
                                        document.getElementById('btnChange').disabled = true;
                                    }
                                }
                            }

                        }

                    }

                }
            }



            function isPWDNotAvailableInHistory()
            {
                var xmlhttp;
                var k = document.getElementById("txtNewPwd").value;
                //alert('txtNewPwd - ' + k)
                var urls = "getPWDHis.jsp?p=" + encodeURIComponent(k);
                var status = false;

                var res;

                if (window.XMLHttpRequest)
                {
                    xmlhttp = new XMLHttpRequest();
                }
                else
                {
                    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                }

                xmlhttp.onreadystatechange = function ()
                {
                    if (xmlhttp.readyState == 4)
                    {

                        res = xmlhttp.responseText;
                        //alert("res 1 ---> " + xmlhttp.responseText + " trimed res -->   " + trim(res));

                        if (trim(res) == "1")
                        {
                            status = true;
                            document.getElementById("hdnIsPWDAvailableHis").value = "1";

                           	if (document.getElementById('txtNewPwd') != null)
							{
								document.getElementById('txtNewPwd').className = 'cits_login_input_text_ok';
							}
							
							if (document.getElementById('validPwd') != null)
                            {
                                document.getElementById('validPwd').style.display = 'block';
                                document.getElementById('imgOK').title = 'Correct password which match with password policy.';
                            }

                            if (document.getElementById('invalidPwd') != null)
                            {
                                document.getElementById('invalidPwd').style.display = 'none';
                            }

                            if (document.getElementById('btnChange') != null)
                            {
                                document.getElementById('btnChange').disabled = false;
                            }
                        }
                        else if (trim(res) == "0")
                        {
                            status = false;
                            document.getElementById("hdnIsPWDAvailableHis").value = "0";

                            if (document.getElementById('validPwd') != null)
                            {
                                document.getElementById('validPwd').style.display = 'none';
                            }
							
							if (document.getElementById('txtNewPwd') != null)
							{
								document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
							}

                            if (document.getElementById('invalidPwd') != null)
                            {
                                document.getElementById('invalidPwd').style.display = 'block';
                                document.getElementById('imgError').title = 'Password should not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
                            }

                            if (document.getElementById('btnChange') != null)
                            {
                                document.getElementById('btnChange').disabled = true;
                            }
                        }
                        else
                        {
                            status = false;
                            document.getElementById("hdnIsPWDAvailableHis").value = "0";

                            if (document.getElementById('validPwd') != null)
                            {
                                document.getElementById('validPwd').style.display = 'none';
                            }
							
							if (document.getElementById('txtNewPwd') != null)
							{
								document.getElementById('txtNewPwd').className = 'cits_login_input_text_error';
							}

                            if (document.getElementById('invalidPwd') != null)
                            {
                                document.getElementById('invalidPwd').style.display = 'block';
                                document.getElementById('imgError').title = 'Password shuold not be equal to last ' + <%=iMinPwdHistory%> + ' passwords you used!';
                            }

                            if (document.getElementById('btnChange') != null)
                            {
                                document.getElementById('btnChange').disabled = true;
                            }
                        }
                    }
                }

                xmlhttp.open("POST", urls, true);
                //xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xmlhttp.send();


                //alert("res 2 ---> " + xmlhttp.responseText + " trimed res -->   " + trim(res));

                //return status;
            }

            function isempty(Value)
            {
                if (Value.length < 1)
                {
                    return true;
                }
                else
                {
                    var str = Value;

                    while (str.indexOf(" ") != -1)
                    {
                        str = str.replace(" ", "");
                    }

                    if (str.length < 1)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            function findSpaces(str)
            {

                var status = false;
                var strTrimed = this.trim(str);

                for (var i = 0; i < strTrimed.length; i++)
                {
                    if (strTrimed[i] == " ")
                    {
                        status = true;
                        break;
                    }
                }

                return status;
            }

            function trim(str)
            {
                return str.replace(/^\s+|\s+$/g, "");
            }

        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body" onLoad="setAnimLights()">



        <form method="post" name="frmChangeInitPwd" onSubmit="return validate()">

            <table width="443" height="450" border="0" align="center" cellpadding="0" cellspacing="0" class="cits_bgInitPassword">
                <tr>
                    <td valign="bottom">





                      <table  border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td colspan="4" align="left" valign="bottom"><table width="420" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="62" align="center" valign="top" class="cits_error_ipwd_change">&nbsp;</td>
                                          <td valign="top" class="cits_error_ipwd_change">Note : New password can not be equal to last <%=iMinPwdHistory %> password(s) you used, must be a combination of alpha numeric and at least one special character and minimum of 8 characters in length!</td>
                                            <td width="45" align="center" valign="top" class="cits_error_ipwd_change">&nbsp;</td>
                                </tr>

                              </table></td>
                            </tr>
                            <tr>
                                <td height="13"></td>
                              <td></td>
                                <td width="15"></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td width="181">&nbsp;</td>
                                <td align="left"><input type="password" name="txtNewPwd" id="txtNewPwd"  maxlength="32" style="min-width:220px;max-width:220px;min-height:16px" class="cits_login_input_text" onKeyUp="validatePassword()"></td>
                                <td align="left" valign="middle"><table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="4">&nbsp;</td>
    <td><div id="validPwd" align="center" ><img src="../../images/animGreen.gif" name="imgOK" id="imgOK" width="12" height="12" ></div>
       	<div id="invalidPwd" align="center" ><img src="../../images/animRed.gif" name="imgError" id="imgError" width="12" height="12" ></div></td>
  </tr>
</table>
</td>
<td align="center" valign="middle">
                                                                    </td>
                            </tr>
                            <tr>
                                <td height="13"></td>
                              <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td align="left"><input type="password" name="txtConfirmPwd" id="txtConfirmPwd"  maxlength="32" style="min-width:220px;max-width:220px;min-height:16px" class="cits_login_input_text"></td>
                              <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="12"></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>

                            <tr>
                                <td height="30"><input type="hidden" name="isChangeReq" id="isChangeReq"><input type="hidden" name="hdnIsPWDAvailableHis" id="hdnIsPWDAvailableHis"></td>
                                <td> 
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="97"><input type="image" name="btnChange" id="btnChange" value="Login" src="../../images/btnChange.png" width="97" height="30" class="gradualshine" onClick="actionChange()" disabled></td>
                                            <td width="5"></td>
                                            <td width="97"><input type="image" name="btnCancel" value="Cancel" src="../../images/btnCancel.png" width="97" height="30" class="gradualshine" onClick="actionCancel()"></td>
                                        </tr>
                                    </table></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>

                            <tr>
                                <td height="30">&nbsp;</td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                  </table></td>
              </tr>
            </table>
        </form>












    </body>
</html>


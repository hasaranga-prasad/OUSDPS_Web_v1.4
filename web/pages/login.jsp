<%@ page import="java.sql.*,java.util.*,java.io.*" errorPage="../error.jsp"%>
<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>

<%
    session.invalidate();
    String msg = null;
    msg = (String) request.getParameter("msg");
%>
<html>
    <head>
        <title>OUSDPS Web - Login(Version 1.4.0)</title>
        <link href="<%=request.getContextPath()%>/css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../css/cits.css" rel="stylesheet" type="text/css" /> 
        <script>
		    function hideMessage_onFocus()
            {
                if(document.getElementById('displayMsg_error') != null)
                {
                    document.getElementById('displayMsg_error').style.display='none';
				
                }			
            }
        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="cits_body">



        <form method="post" action="../index.jsp" name="frmLogin">

            <table width="443" height="450" border="0" align="center" cellpadding="0" cellspacing="0" class="cits_bgLogin">
                <tr>
                    <td valign="bottom">





                        <table  border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="2"><table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="62"></td>
<td>
                                                <%
                                                    if (msg != null)
                                                    {
                                                        if (msg.equals("up"))
                                                        {
                                                %>
                                                <div id="displayMsg_error" class="cits_error" >Invalid Username Or Password!</div>
                                                <%                                                }
                                                else if (msg.equals("up"))
                                                {
                                                %>
                                                <div id="displayMsg_error" class="cits_error" >Invalid Username Or Password!</div>
                                                <%                                                        }
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                    </table></td>
                            </tr>
                            <tr>
                                <td height="12"></td>
                              <td></td>
                            </tr>
                            <tr>
                                <td width="162"></td>
                                <td><input type="text" name="txtUserName" id="txtUserName" size="28" maxlength="32"  class="cits_login_input_text"  height="18" onFocus="hideMessage_onFocus()"></td>
                            </tr>
                            <tr>
                                <td height="18"></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="password" name="txtPassword" id="txtPassword" size="28" maxlength="32"  class="cits_login_input_text"  height="18" onFocus="hideMessage_onFocus()"></td>
                            </tr>
                            <tr>
                                <td height="15"></td>
                                <td></td>
                            </tr>

                            <tr>
                                <td height="30"><input type="hidden" name="hdnActionType" id="hdnActionType" ></td>
                                <td> 
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="97"><input type="image" name="btnChange" id="btnChange" value="Login" src="../images/btnLogin.png" width="97" height="30" class="gradualshine_btn_login"  onClick="document.frmLogin.submit()"></td>
                                            <td width="5"></td>
                                            <td width="97"><img name="btnCancel" id="btnCancel" value="Cancel" src="../images/btnCancel.png" width="97" height="30" class="gradualshine_btn_cancel"  onClick="open(location, '_self').close();"></td>
                                        </tr>
                                    </table></td>
                            </tr>

                            <tr>
                                <td height="30">&nbsp;</td>
                                <td></td>
                            </tr>
                        </table></td>
                </tr>
            </table>
        </form>
    </body>
</html>
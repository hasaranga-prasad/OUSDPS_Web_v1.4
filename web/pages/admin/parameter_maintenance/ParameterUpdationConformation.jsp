<%@page import="java.util.*,java.sql.*" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.DAOFactory" errorPage="../../../error.jsp"  %>
<%@page import="lk.com.ttsl.ousdps.dao.userLevel.UserLevel" errorPage="../../../error.jsp"%>
<%@page import="lk.com.ttsl.ousdps.dao.parameter.*" errorPage="../../../error.jsp" %>
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

        if (!(userType.equals(LCPL_Constants.user_type_lcpl_super_user) || userType.equals(LCPL_Constants.user_type_lcpl_supervisor) || userType.equals(LCPL_Constants.user_type_lcpl_administrator)))
        {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/pages/accessDenied.jsp");
        }
        else
        {

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

    String colSize = null;
    String changedParamIds = null;
    String msg = null;

    colSize = request.getParameter("hdncolSize");
    changedParamIds = (String) request.getParameter("hdnNewParamIds");

    String[] arrayParamIds = null;
    //Collection<Parameter> col_parameter = null;
    ParameterDAO dao_para = null;
    boolean result = true;

    arrayParamIds = changedParamIds.split(":");

    if (arrayParamIds != null)
    {
        //col_parameter = new ArrayList();

        for (int i = 0; i < arrayParamIds.length; i++)
        {
            String id = arrayParamIds[i];
            String paramid = request.getParameter("hdnParamId_" + id);
            String paramDesc = request.getParameter("hdnParamDesc_" + id);
            String paramType = request.getParameter("hdnParamType_" + id);
            String currentValue = request.getParameter("hdnCurrentParamValue_" + id);
            String paramValue = null;


            if (paramType.equals(LCPL_Constants.param_type_pwd))
            {
                paramValue = request.getParameter("txtPwd_" + id);                
            }
            else if (paramType.equals(LCPL_Constants.param_type_day))
            {
                paramValue = request.getParameter("txtParamValue_" + id);
                paramValue = paramValue.replaceAll("-", "");
            }
            else if (paramType.equals(LCPL_Constants.param_type_time))
            {
                paramValue = request.getParameter("cmbHH_" + id) + request.getParameter("cmbMM_" + id);
            }
            else if (paramType.equals(LCPL_Constants.param_type_other))
            {
                paramValue = request.getParameter("txtParamValue_" + id);
            }

            if (((paramValue != null && paramValue.length() > 0) && currentValue != null) && !currentValue.equalsIgnoreCase(paramValue))
            {
                if (dao_para == null)
                {
                    dao_para = DAOFactory.getParameterDAO();
                }

                Parameter p = new Parameter();
                p.setName(paramid);
                p.setDescription(paramDesc);
                p.setType(paramType);
                p.setValue(paramValue);
                p.setCurrentValue(currentValue);
                p.setModifiedby(userName);

                if (dao_para.update(p))
                {
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_parameter_maintenance_set_param_value, "| Parameter ID - " + paramid + ", Parameter Value - (New : " + paramValue + ", Old : " + currentValue + ")| Process Status - Success | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                }
                else
                {
                    result = false;
                    DAOFactory.getLogDAO().addLog(new Log(LCPL_Constants.log_type_admin_parameter_maintenance_set_param_value, "| Parameter ID - " + paramid + ", Parameter Value - (New : " + paramValue + ", Old : " + currentValue + ")| Process Status - Unsuccess (" + p.getUpdateStatusMsg() + ") | Modified By - " + userName + " (" + userTypeDesc + ") |"));
                }

            }
            //col_parameter.add(p);
        }
    }



    /*
     * if (col_parameter != null && col_parameter.size() > 0) { dao_para =
     * DAOFactory.getParameterDAO(); result = dao_para.update(col_parameter);
     *
     * if (result == true) { msg = dao_para.getMsg(); } }
     */


%>
<html>
    <head>
        <title>OUSDPS Web - Set Parameter Values</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../../../css/cits.css" rel="stylesheet" type="text/css" />
        <link href="../../../css/tabView.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="../../../js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/ajax.js"></script>
        <script language="JavaScript" type="text/javascript" src="../../../js/tabView.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../js/calendar1.js"></script>
        <script language="JavaScript" type="text/JavaScript" src="../../../js/tableenhance.js"></script>
        <script language="javascript" type="text/JavaScript">



            function showClock(type)
            {
            if(type==1)
            {
            clock(document.getElementById('showText'),type,null);
            }
            else if(type==2        )
            {
            var val = new Array(<%=serverTime%>);
            clock(document.getElementById('showText'),type,val);
            }
            else if(type==3        )
            {
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actSession'), document.getElementById('expSession'), <%=window.getCutontimeHour()%>, <%=window.getCutontimeMinutes()%>, <%=window.getCutofftimeHour()%>, <%=window.getCutofftimeMinutes()%>);
            clock(document.getElementById('showText'),type,val);
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
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=menuName%>" vqp_uid0=<%=menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";cdd__codebase<%=menuId%> = "<%=request.getContextPath()%>/js/";</script>
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
                                                                                        <td align="left" valign="top" class="cits_header_text">Set Parameter Values</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" class="cits_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                <%
                                                                                                    if (dao_para != null)
                                                                                                    {
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td align="center"><table border="0" cellspacing="1" cellpadding="3" class="cits_table_boder" bgcolor="#FFFFFF">
                                                                                                            <tr>
                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">&nbsp;</td>
                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Parameter</td>
                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Current Value</td>
                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">New Value</td>
                                                                                                                <!--   <td align="center" bgcolor="#FDCB99" class="cits_tbl_header_text">New Status </td> -->
                                                                                                                <td align="center" bgcolor="#B3D5C0" class="cits_tbl_header_text">Update Status</td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                int rowNum = 0;

                                                                                                                Hashtable<String, Parameter> htSuccess = dao_para.getSuccessQuery2();

                                                                                                                for (Enumeration en = htSuccess.keys(); en.hasMoreElements();)
                                                                                                                {

                                                                                                                    String paramid = (String) en.nextElement();
                                                                                                                    Parameter param = (Parameter) htSuccess.get(paramid);

                                                                                                                    String curVal = null;
                                                                                                                    String newVal = null;

                                                                                                                    if (param.getType() != null && param.getType().equals(LCPL_Constants.param_type_day))
                                                                                                                    {
                                                                                                                        curVal = DateFormatter.doFormat(DateFormatter.getTime(param.getCurrentValue(), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                        newVal = DateFormatter.doFormat(DateFormatter.getTime(param.getValue(), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                    }
                                                                                                                    else if (param.getType() != null && param.getType().equals(LCPL_Constants.param_type_time))
                                                                                                                    {
                                                                                                                        curVal = DateFormatter.doFormat(DateFormatter.getTime(param.getCurrentValue(), LCPL_Constants.simple_date_format_HHmm), LCPL_Constants.simple_date_format_HH_mm);
                                                                                                                        newVal = DateFormatter.doFormat(DateFormatter.getTime(param.getValue(), LCPL_Constants.simple_date_format_HHmm), LCPL_Constants.simple_date_format_HH_mm);
                                                                                                                    }
                                                                                                                    else if (param.getType() != null && param.getType().equals(LCPL_Constants.param_type_pwd))
                                                                                                                    {
                                                                                                                        if(param.getCurrentValue()!=null)
                                                                                                                        {
                                                                                                                            int i=0;
                                                                                                                            curVal = "";
                                                                                                                            
                                                                                                                            while(i <param.getCurrentValue().length())
                                                                                                                            {
                                                                                                                                curVal = curVal + "*";
                                                                                                                                i++;                                                                                                                                     
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            curVal = "-";
                                                                                                                        }
                                                                                                                        
                                                                                                                        if(param.getValue()!=null)
                                                                                                                        {
                                                                                                                            int i=0;
                                                                                                                            newVal = "";
                                                                                                                            
                                                                                                                            while(i <param.getValue().length())
                                                                                                                            {
                                                                                                                                newVal = newVal + "*";
                                                                                                                                i++;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            newVal = "-";
                                                                                                                        }
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        curVal = param.getCurrentValue();
                                                                                                                        newVal = param.getValue();
                                                                                                                    }


                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#E4EDE7" : "#F5F7FA"%>" onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                <td align="left" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                                <td align="left" class="cits_common_text"><%=param.getDescription()%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=curVal%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=newVal%></td>
                                                                                                                <td align="center" class="cits_Display_Success_msg">Success</td>
                                                                                                            </tr>
                                                                                                            <%
                                                                                                                }

                                                                                                                Hashtable<String, Parameter> htError = dao_para.getFailQuery2();

                                                                                                                for (Enumeration en = htError.keys(); en.hasMoreElements();)
                                                                                                                {
                                                                                                                    String paramid = (String) en.nextElement();
                                                                                                                    Parameter param = (Parameter) htError.get(paramid);

                                                                                                                    String curVal = null;
                                                                                                                    String newVal = null;

                                                                                                                    if (param.getType() != null && param.getType().equals(LCPL_Constants.param_type_day))
                                                                                                                    {
                                                                                                                        curVal = DateFormatter.doFormat(DateFormatter.getTime(param.getCurrentValue(), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                        newVal = DateFormatter.doFormat(DateFormatter.getTime(param.getValue(), LCPL_Constants.simple_date_format_yyyyMMdd), LCPL_Constants.simple_date_format_yyyy_MM_dd);
                                                                                                                    }
                                                                                                                    else if (param.getType() != null && param.getType().equals(LCPL_Constants.param_type_time))
                                                                                                                    {
                                                                                                                        curVal = DateFormatter.doFormat(DateFormatter.getTime(param.getCurrentValue(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm);
                                                                                                                        newVal = DateFormatter.doFormat(DateFormatter.getTime(param.getValue(), LCPL_Constants.simple_date_format_hhmm), LCPL_Constants.simple_date_format_hh_mm);
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        curVal = param.getCurrentValue();
                                                                                                                        newVal = param.getValue();
                                                                                                                    }

                                                                                                                    rowNum++;
                                                                                                            %>
                                                                                                            <tr bgcolor="<%=rowNum % 2 == 0 ? "#FEF3CF" : "#FFFFCC"%>" onMouseOver="cOn(this)" onMouseOut="cOut(this)">
                                                                                                                <td align="left" class="cits_common_text"><%=rowNum%>.</td>
                                                                                                                <td align="left" class="cits_common_text"><%=param.getDescription()%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=curVal%></td>
                                                                                                                <td align="center" class="cits_common_text"><%=newVal%></td>
                                                                                                                <td align="center" class="cits_Display_Error_msg">Fail - <span class="cits_error"><%=param.getUpdateStatusMsg()%></span></td>
                                                                                                            </tr>
                                                                                                            <%}



                                                                                                            %>
                                                                                                        </table></td>
                                                                                                </tr>
                                                                                                <%                      }
                                                                                                else
                                                                                                {%>
                                                                                                <tr>
                                                                                                    <td align="center" class="cits_tbl_header_text"> Sorry! There is no change to the parameters to update. </td>
                                                                                                </tr>
                                                                                                <%                                                                                }
                                                                                                %>
                                                                                            </table>
                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td height="25" colspan="2" align="left" class="cits_header_small_text"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td colspan="2" align="left" class="cits_header_small_text"><form action="SetParameter.jsp" name="frmBack" id="frmBack"  method="post" target="_self" >

                                                                                                            <input type="submit" name="btnView" id="btnView" value="  Back  " class="cits_custom_button" >
                                                                                                        </form></td>
                                                                                                </tr>
                                                                                            </table></td>
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

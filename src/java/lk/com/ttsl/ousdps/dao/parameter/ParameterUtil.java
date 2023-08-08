/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.parameter;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class ParameterUtil
{

    public static Collection makeParameterCollection(final ResultSet rs)
            throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Parameter> paramResult = new ArrayList();

        while (rs.next())
        {
            Parameter param = new Parameter();

            param.setName(rs.getString("ParamId"));
            param.setDescription(rs.getString("ParamDesc"));
            param.setValue(rs.getString("ParamValue"));
            param.setType(rs.getString("ParamType"));

            if (rs.getString("ParamType") != null && rs.getString("ParamType").equals(LCPL_Constants.param_type_pwd))
            {
                param.setDecrytedValue(rs.getString("decrypVal"));
            }

            paramResult.add(param);
        }

        return paramResult;
    }
}

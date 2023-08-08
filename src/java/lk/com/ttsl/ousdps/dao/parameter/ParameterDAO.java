/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.parameter;

import java.util.Collection;
import java.util.Hashtable;

/**
 *
 * @author Dinesh
 */
public interface ParameterDAO
{

    public String getMsg();

    public String getParamValueById(String paramId);

    public String getParamValueById_notFormatted(String paramId);
    
    public String getParamValue(String paramId, String paramType);

    public Collection<Parameter> getAllParamterValues();

    public boolean update(Collection<Parameter> para);

    public boolean update(Parameter parameter);

    public int getDateTypeParameterCount();

    public Hashtable getFailQuery();

    public Hashtable getSuccessQuery();

    public Hashtable getFailQuery2();

    public Hashtable getSuccessQuery2();
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.returnreason;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ReturnReasonDAO
{
    public String getMsg();
    
    public ReturnReason getReTurnTypeDetails(String returnCode);

    public Collection<ReturnReason> getReTurnTypes();

    public boolean addReTurnTypes(ReturnReason returnTypes);

    public boolean modifyReturnTypes(ReturnReason returnTypes);
}

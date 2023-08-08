/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.transactiontype;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface TransactionTypeDAO
{

    public String getMsg();

    public TransactionType getTransType(String tc);

    public Collection<TransactionType> getTransTypeDetails();

    public boolean addTransType(TransactionType tType);

    public boolean modifyTransType(TransactionType tType);
}

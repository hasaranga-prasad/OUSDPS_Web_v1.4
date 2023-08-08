/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.accounttype;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface AccountTypeDAO
{

    public String getMsg();

    public AccountType getAccountType(String accountCode);

    public Collection<AccountType> getAccountTypeDetails(String status);

    public boolean addAccountType(AccountType act);

    public boolean modifyAccountType(AccountType act);

}

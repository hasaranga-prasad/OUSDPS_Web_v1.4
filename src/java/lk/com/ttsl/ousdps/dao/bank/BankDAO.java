/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.bank;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface BankDAO
{
    public String getMsg();
    
    public Bank getBankDetails(String bankCode);

    public Collection<Bank> getBank(String status);
    
    public Collection<Bank> getBankNotInStatus(String status);
    
    public Collection<Bank> getAuthPendingBank(String createdUser);

    public Collection<Bank> getBank();

    public boolean addBank(Bank bank);

    public boolean modifyBank(Bank bank);
    
    public boolean doAuthorizedBank(Bank bank);
}

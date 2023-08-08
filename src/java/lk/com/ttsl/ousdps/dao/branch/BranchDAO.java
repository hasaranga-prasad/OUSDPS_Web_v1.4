/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.branch;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface BranchDAO
{

    public String getMsg();

    public Branch getBranchDetails(String bankCode, String branchCode);

    public Collection<Branch> getBranch(String bankCode, String status);

    public Collection<Branch> getBranchNotInStatus(String bankCode, String status);

    public Collection<Branch> getAuthPendingBranches(String bankCode, String createdUser);

    public Collection<Branch> getBranch(String bankCode);

    public boolean addBranch(Branch branch);

    public boolean modifyBranch(Branch branch);
    
    public boolean doAuthorizedBranch(Branch branch);
}

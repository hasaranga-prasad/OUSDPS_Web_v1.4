/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package lk.com.ttsl.ousdps.dao.batch;

import java.util.Collection;

/**
 *
 * @author Isanka
 */
public interface BatchDAO {


    /**
     * @param String bankCode
     * @param String branchCode
     * @param String batchStatus
     * @param String transactionType
     * @param String fromBusinessDate
     * @param String toBusinessDate
     * @return Collection which contains batch details for given conditions
     */
    public Collection<Batch> getBatchDetails(String bankCode, String branchCode,
          String transactionType, String batchStatus, 
          String fromBusinessDate,String toBusinessDate);


    /**
     * @param String bankCode
     * @param String branchCode
     * @param String batchStatus
     * @param String transactionType
     * @return Collection which contains batch details for given conditions
     */
public Collection<Batch> getBatchDetails(String bankCode, String branchCode,
            String transactionType, String batchStatus,String businessDate);

   
}
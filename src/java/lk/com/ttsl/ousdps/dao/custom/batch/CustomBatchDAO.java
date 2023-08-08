/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.batch;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface CustomBatchDAO
{

/**
 * 
 * @param bankCode
 * @param branchCode
 * @param session
 * @param fromBusinessDate
 * @param toBusinessDate
 * @return 
 */
    public Collection<CustomBatch> getBatchDetails(String bankCode, String branchCode,
            String session,
            String fromBusinessDate, String toBusinessDate);
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.rejectreason;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface RejectReasonDAO
{
    public String getMsg();
    
    public RejectReason getRejectReasonDetails(String rejectCode);

    public Collection<RejectReason> getRejectReasons();

}

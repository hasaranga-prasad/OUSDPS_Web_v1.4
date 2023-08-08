/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.slipsowconfirmation;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface SLIPSOWConfirmationDAO
{

    public String getMsg();

    public SLIPSOWConfirmation getConfirmationDetail(String bankCode,
            String businessDate, String session);

    public Collection<SLIPSOWConfirmation> getConfirmationDetails(String bankCode, String status,
            String businessDate, String session);

    public boolean isAlreadyConfirmed(SLIPSOWConfirmation slipsowconfirmation);

    public boolean doConfirm(SLIPSOWConfirmation slipsowconfirmation);
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.adhoccharges;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface AdhocChargesDAO
{

    public String getMsg();

    public AdhocCharges getAdhocChargesType(String adhocChargeCode);

    public Collection<AdhocCharges> getAdhocChargesTypeDetails(String status);

    public boolean addAdhocChargesType(AdhocCharges ac);

    public boolean modifyAdhocChargesType(AdhocCharges ac);

}

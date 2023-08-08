/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.billingadhoccharges;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface BillingAdhocChargesDAO
{

    public String getMsg();

    public BillingAdhocCharges getBillingAdhocChargeDetail(String billingId);

    public Collection<BillingAdhocCharges> getBillingAdhocChargeDetails(String bankCode, String branchCode, String adhocChargeType, String status, String fromBillingDate, String toBillingDate);

    public boolean addBillingAdhocCharge(BillingAdhocCharges bac);

    public boolean cancelBillingAdhocCharge(BillingAdhocCharges bac);

}

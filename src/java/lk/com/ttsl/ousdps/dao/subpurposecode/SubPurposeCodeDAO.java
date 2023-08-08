/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.subpurposecode;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface SubPurposeCodeDAO
{

    public String getMsg();

    public SubPurposeCode getPurposeCode(String subPurCode);

    public Collection<SubPurposeCode> getSubPurposeCodesDetails(String purCode, String status);

    public boolean addSubPurposeCode(SubPurposeCode spc);

    public boolean modifySubPurposeCode(SubPurposeCode spc);

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.purposecode;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface PurposeCodeDAO
{

    public String getMsg();

     public PurposeCode getPurposeCode(String purCode);

    public Collection<PurposeCode> getPurposeCodesDetails(String status);

    public boolean addPurposeCode(PurposeCode purCode);

    public boolean modifyPurposeCode(PurposeCode purCode);

}

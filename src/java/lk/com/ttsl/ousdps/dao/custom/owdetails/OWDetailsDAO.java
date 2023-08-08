/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.owdetails;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface OWDetailsDAO
{

    public String getMsg();

    public Collection<OWDetails> getOWDetails(String fileID);
    
    public long getRecordCountOWDetails(String fileID);
    
    public Collection<OWDetails> getOWDetails(String fileID, int page, int recordsPrepage);    

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String session, String fromBusinessDate, String toBusinessDate);

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate);

    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fileId, String desActNo, String orgActNo, String minAmount, String maxAmount);
    
    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate,String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String minAmount, String maxAmount);

    public long getRecordCountOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate,String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String status, String minAmount, String maxAmount);
    
    public Collection<OWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate,String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String status, String minAmount, String maxAmount, int page, int recordsPrepage);

}

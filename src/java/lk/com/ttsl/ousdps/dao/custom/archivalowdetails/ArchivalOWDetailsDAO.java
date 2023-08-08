/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.archivalowdetails;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface ArchivalOWDetailsDAO
{

    public String getMsg();

    public Collection<ArchivalOWDetails> getOWDetails(String fileID);
    
    public long getRecordCountOWDetails(String fileID);
    
    public Collection<ArchivalOWDetails> getOWDetails(String fileID, int page, int recordsPrepage);    

    public Collection<ArchivalOWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String session, String fromBusinessDate, String toBusinessDate);

    public Collection<ArchivalOWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate);

    public Collection<ArchivalOWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fileId, String desActNo, String orgActNo, String minAmount, String maxAmount);
    
    public Collection<ArchivalOWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate,String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String minAmount, String maxAmount);

    public long getRecordCountOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate,String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String status, String minAmount, String maxAmount);
    
    public Collection<ArchivalOWDetails> getOWDetails(String owBank, String owBranch, String desBank, String desBranch, String orgBank, String orgBranch, String transCode, String returnCode, String session, String fromBusinessDate, String toBusinessDate, String fromValueDate, String toValueDate,String fileId, String desActNo, String desActName, String orgActNo, String orgActName, String status, String minAmount, String maxAmount, int page, int recordsPrepage);

}

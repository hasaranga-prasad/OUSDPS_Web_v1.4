/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.custom.inwardfiles;

import java.io.File;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface InwardFilesDAO
{

    public InwardFiles getInwardFileDetails(String iwdFilePath, String type, String okToDownload);

    public Collection<InwardFiles> getInwardFileDetails(String bankCode, String session, String type, String status,
            String fromBusinessDate, String toBusinessDate);
    
    public boolean isSubBankInwardFileAvailable(String bankCode, String session, String type, String status,
            String fromBusinessDate, String toBusinessDate);
    
    public boolean updateDownloadDetails(String iwdFilePath, String downloadedBy);
}

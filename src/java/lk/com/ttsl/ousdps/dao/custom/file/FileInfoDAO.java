/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package lk.com.ttsl.ousdps.dao.custom.file;

import java.util.Collection;

/**
 * 
 * @author Dinesh
 */
public interface FileInfoDAO {

    /**
     * 
     * @param presentingBank
     * @param presentingSB
     * @param presentingBranch
     * @param presentingCounter
     * @param fileType
     * @param fileStatus
     * @param fromBusinessDate
     * @param toBusinessDate
     * @return Collection<FileInfo>
     */

    public Collection<FileInfo> getFileDetailsByCriteria(String bankCode, String status, String session, String fromBusinessDate, String toBusinessDate);
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.fileStatus;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface FileStatusDAO
{
    public FileStatus getFileStatus(String id);
    
    public Collection<FileStatus> getFileStatusDetails();
}

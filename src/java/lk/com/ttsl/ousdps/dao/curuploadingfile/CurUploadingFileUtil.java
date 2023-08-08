/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.curuploadingfile;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;
import lk.com.ttsl.ousdps.dao.bank.Bank;

/**
 *
 * @author Dinesh
 */
public class CurUploadingFileUtil
{

    static Collection<CurUploadingFile> makeCurUploadingFileObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CurUploadingFile> result = new java.util.ArrayList();

        while (rs.next())
        {
            CurUploadingFile curUploadingFile = new CurUploadingFile();

            curUploadingFile.setOwBank(rs.getString("bank"));
            curUploadingFile.setOwBankShortName(rs.getString("ShortName"));
            curUploadingFile.setOwBankFullName(rs.getString("FullName"));
            curUploadingFile.setFileId(rs.getString("fileid"));

            if (rs.getTimestamp("starttime") != null)
            {
                curUploadingFile.setTransmitStartTime(DateFormatter.doFormat(rs.getTimestamp("starttime").getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(curUploadingFile);

        }

        return result;
    }
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.curuploadingfile;

/**
 *
 * @author Dinesh
 */
public class CurUploadingFile
{

    private String fileId;
    private String owBank;
    private String owBankShortName;
    private String owBankFullName;
    private String transmitStartTime;

    public String getFileId()
    {
        return fileId;
    }

    public void setFileId(String fileId)
    {
        this.fileId = fileId;
    }

    public String getOwBank()
    {
        return owBank;
    }

    public void setOwBank(String owBank)
    {
        this.owBank = owBank;
    }

    public String getOwBankShortName()
    {
        return owBankShortName;
    }

    public void setOwBankShortName(String owBankShortName)
    {
        this.owBankShortName = owBankShortName;
    }

    public String getOwBankFullName()
    {
        return owBankFullName;
    }

    public void setOwBankFullName(String owBankFullName)
    {
        this.owBankFullName = owBankFullName;
    }

    public String getTransmitStartTime()
    {
        return transmitStartTime;
    }

    public void setTransmitStartTime(String transmitStartTime)
    {
        this.transmitStartTime = transmitStartTime;
    }

}

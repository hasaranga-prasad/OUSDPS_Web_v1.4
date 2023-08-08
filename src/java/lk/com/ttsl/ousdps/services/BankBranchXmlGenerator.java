/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.services;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;
import lk.com.ttsl.ousdps.dao.DAOFactory;
import lk.com.ttsl.ousdps.dao.bank.Bank;
import lk.com.ttsl.ousdps.services.utils.PropertyLoader;

/**
 *
 * @author Dinesh
 */
public class BankBranchXmlGenerator
{

    public static void main(String[] args)
    {

    }

    public boolean doGenerate()
    {
        boolean status = false;

        File fBkBrXml = PropertyLoader.getInstance().getBankBranchXmlFile();

        try
        {
            if (fBkBrXml.exists())
            {
                fBkBrXml.delete();
            }
            else
            {
                fBkBrXml.createNewFile();
                
                if(fBkBrXml.canWrite())
                {
                
                }
                else
                {
                    fBkBrXml.setWritable(true);
                    
                    
                }
            }

        }
        catch (IOException e)
        {
            System.out.println("Bank Branch Xml Creation Failed - " + e.getMessage());
        }

        Collection<Bank> colBank = DAOFactory.getBankDAO().getBankNotInStatus(LCPL_Constants.status_pending);

        return status;

    }

}

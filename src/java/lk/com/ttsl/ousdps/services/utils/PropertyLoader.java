/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.services.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.PropertyResourceBundle;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;

/**
 *
 * @author Dinesh
 */
public class PropertyLoader
{

    private static String cert_file_path;
    private static String bank_branch_xml_file_path;
    private static String account_file_path;
    private static String purpose_code_file_path;
    private static String returns_file_path;
    private static String transaction_file_path;
    private static String online_db_name;
    private static String archival_db_name;
    private static String msg_attachment_file_path;
    private static PropertyLoader pl;

    public PropertyLoader()
    {
    }

    public static PropertyLoader getInstance()
    {
        if (pl == null)
        {
            pl = new PropertyLoader();
        }
        return pl;
    }

    public File getCommonCertPath()
    {
        File file = null;

        if (cert_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                cert_file_path = bundle.getString("CERTPATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getCommonCertPath) >> " + e.getMessage());
                }
            }
        }

        file = new File(cert_file_path);

        return file;
    }
    
    public File getBankBranchXmlFile()
    {
        File file = null;

        if (bank_branch_xml_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                bank_branch_xml_file_path = bundle.getString("BKBRXMLPATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getBankBranchXmlFile) >> " + e.getMessage());
                }
            }
        }

        file = new File(bank_branch_xml_file_path);

        return file;
    }
    
    public File getAccountFile()
    {
        File file = null;

        if (account_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                account_file_path = bundle.getString("ACCOUNTFILEPATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getAccountFile) >> " + e.getMessage());
                }
            }
        }

        file = new File(account_file_path);

        return file;
    }
    
    public File getPurposeCodeFile()
    {
        File file = null;

        if (purpose_code_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                purpose_code_file_path = bundle.getString("PURPOSECODEFILEPATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getPurposeCodeFile) >> " + e.getMessage());
                }
            }
        }

        file = new File(purpose_code_file_path);

        return file;
    }
    
    
    public File getReturnFile()
    {
        File file = null;

        if (returns_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                returns_file_path = bundle.getString("RETURNFILEPATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getReturnFile) >> " + e.getMessage());
                }
            }
        }

        file = new File(returns_file_path);

        return file;
    }
    
    
    public File getTransactionFile()
    {
        File file = null;

        if (transaction_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                transaction_file_path = bundle.getString("TRANSFILEPATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getTransactionFile) >> " + e.getMessage());
                }
            }
        }

        file = new File(transaction_file_path);

        return file;
    }
    
    public  String getOnlineDB_Name()
    {
        
        if (online_db_name == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                online_db_name = bundle.getString("ONLINE_DB_NAME");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getTransactionFile) >> " + e.getMessage());
                }
            }
        }        
        
        return online_db_name;
    }
    
    public  String getArchivalDB_Name()
    {
        
        if (archival_db_name == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                archival_db_name = bundle.getString("ARCHIV_DB_NAME");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error(PropertyLoader-getTransactionFile) >> " + e.getMessage());
                }
            }
        }        
        
        return archival_db_name;
    }
    
    public File getMessageAttachmentFilePath()
    {
        File file = null;

        if (msg_attachment_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(LCPL_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                msg_attachment_file_path = bundle.getString("MSG_ATTACHMENT_FILE_PATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                }
            }
        }

        file = new File(msg_attachment_file_path);

        return file;
    }
    
}

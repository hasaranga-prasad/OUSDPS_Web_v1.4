/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.certificates;

import java.io.File;
import java.security.cert.X509Certificate;
import java.util.Collection;
import java.util.Date;
import java.util.Hashtable;
import lk.com.ttsl.ousdps.common.utils.DateFormatter;
import lk.com.ttsl.ousdps.common.utils.LCPL_Constants;
import lk.com.ttsl.ousdps.services.utils.CertificateReader;
import lk.com.ttsl.ousdps.services.utils.FilePicker;
import lk.com.ttsl.ousdps.services.utils.PropertyLoader;

/**
 *
 * @author Dinesh
 */
public class CertificateDAOImpl implements CertificateDAO
{

    static String msg;

    public String getMsg()
    {
        return msg;
    }

    public Hashtable<String, Collection<Certificate>> analyze(String bankCode, String status)
    {
        Hashtable<String, Collection<Certificate>> htCerts = null;
        File[] files = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return htCerts;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return htCerts;
        }

        if (bankCode.equals(LCPL_Constants.status_all))
        {

            files = new FilePicker().pickFiles(PropertyLoader.getInstance().getCommonCertPath(), 4, new String[]
            {
                LCPL_Constants.file_cert_prefix, LCPL_Constants.file_ext_type_cert
            }, null);

        }
        else
        {
            files = new FilePicker().pickFiles(PropertyLoader.getInstance().getCommonCertPath(), 4, new String[]
            {
                LCPL_Constants.file_cert_prefix, bankCode, LCPL_Constants.file_ext_type_cert
            }, null);
        }

        if (files != null)
        {
            //System.out.println("No. of files available :- " + files.length);

            htCerts = new Hashtable<String, Collection<Certificate>>();

            for (int i = 0; i < files.length; i++)
            {
                //System.out.println("file name ----> " + files[i].getName());

                String bank = null;
                X509Certificate cert = null;

                cert = CertificateReader.readCertificate(files[i]);

                if (cert != null)
                {
                    Certificate cb = new Certificate();

//                    System.out.println("files[i].getName() ---> " + files[i].getName());
//                    System.out.println("files[i].getPath() ---> " + files[i].getPath());
//                    System.out.println("files[i].getAbsolutePath() ---> " + files[i].getAbsolutePath());
//                    try
//                    {
//                        System.out.println("files[i].getCanonicalPath() ---> " + files[i].getCanonicalPath());
//                    }
//                    catch (IOException ex)
//                    {
//                        System.out.println(ex.getMessage());
//                    }
                    cb.setName(files[i].getName());
                    cb.setVersion(Integer.toString(cert.getVersion()));

                    cb.setSerialNumber(cert.getSerialNumber().toString(16));
                    cb.setSignatureAlgorithm(cert.getSigAlgName());

                    if (cert.getIssuerDN() != null)
                    {
                        cb.setIssuer(cert.getIssuerDN().getName().substring(cert.getIssuerDN().getName().indexOf("CN=") + 3, cert.getIssuerDN().getName().indexOf(",")));
                    }

                    if (cert.getNotBefore() != null)
                    {
                        cb.setValidFrom(DateFormatter.doFormat(cert.getNotBefore().getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));

                        Date date = new Date();

                        if (cert.getNotBefore().getTime() < date.getTime())
                        {
                            cb.setIsValid(true);
                        }
                        else
                        {
                            cb.setIsValid(false);
                        }
                    }

                    if (cert.getNotAfter() != null)
                    {
                        cb.setValidTo(DateFormatter.doFormat(cert.getNotAfter().getTime(), LCPL_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));

                        Date date = new Date();

                        if (cert.getNotAfter().getTime() < date.getTime())
                        {
                            cb.setIsExpired(true);
                        }
                        else
                        {
                            cb.setIsExpired(false);
                        }
                    }

                    if (cert.getSubjectDN() != null)
                    {
                        String subject = cert.getSubjectDN().getName();

                        if (subject != null)
                        {
                            cb.setSubject(subject);

                            int length = subject.length();
                            //int index_ = subject.indexOf("_");
                            int indexId = subject.indexOf("UID=");
                            int indexIdEnd = -1;

                            int indexId_t = subject.indexOf(" T=");
                            int indexIdEnd_t = -1;

                            int indexEmailAddress = subject.indexOf("EMAILADDRESS=");
                            int indexEmailAddressEnd = -1;

                            int indexBankName = subject.indexOf("CN=");
                            int indexBankNameEnd = -1;

//                            if (index_ > -1)
//                            {
//                                if (length > index_ + 5)
//                                {
//                                    cb.setBankCode(subject.substring(index_ + 1, index_ + 5));
//                                    bank = subject.substring(index_ + 1, index_ + 5);
//                                }
//                            }
                            if (indexId > -1)
                            {
                                indexIdEnd = subject.indexOf(",", indexId);

                                if (indexIdEnd > indexId && length > indexIdEnd)
                                {
                                    cb.setId(subject.substring(indexId + "UID=".length(), indexIdEnd));

                                    if (cb.getId() == null)
                                    {
                                        cb.setId("N/A");
                                    }

                                }

                                if (indexBankName > -1)
                                {
                                    indexBankNameEnd = subject.indexOf(",", indexBankName);

                                    if (indexBankNameEnd > indexBankName && length > indexBankNameEnd)
                                    {
                                        String bankCN = subject.substring(indexBankName + "CN=".length(), indexBankNameEnd);

                                        System.out.println("bankCN ----> " + bankCN);

                                        if (bankCN != null)
                                        {
                                            cb.setBankName(bankCN.substring(0, bankCN.indexOf("_")));
                                            cb.setBankCode(bankCN.substring(bankCN.indexOf("_") + 1));
                                            bank = bankCN.substring(bankCN.indexOf("_") + 1);
                                        }
                                    }
                                }

                            }
                            else if (indexId_t > -1)
                            {
                                indexIdEnd_t = subject.length() - 1;
                                //indexIdEnd_t = subject.length();

                                if (indexIdEnd_t > indexId_t && length > indexIdEnd_t)
                                {
                                    //cb.setId(subject.substring(indexId_t + " T=".length(), indexIdEnd_t));
                                    cb.setId(subject.substring(indexId_t + " T=".length()));

                                    if (cb.getId() == null)
                                    {
                                        cb.setId("N/A");
                                    }
                                }

                                if (indexIdEnd_t > indexId_t)
                                {
                                    String bankCN_T = subject.substring(indexId_t + " T=".length());

                                    System.out.println("bankCN_T ----> " + bankCN_T);

                                    if (bankCN_T != null)
                                    {
                                        cb.setBankName(bankCN_T.substring(0, bankCN_T.indexOf("_")));

                                        bank = bankCN_T.substring((bankCN_T.indexOf("_") + 1), bankCN_T.lastIndexOf("_"));

                                        cb.setBankCode(bank);

                                    }
                                }

                            }
                            else
                            {
                                cb.setId("N/A");
                            }

                            if (indexEmailAddress > -1)
                            {
                                indexEmailAddressEnd = subject.indexOf(",", indexEmailAddress);

                                if (indexEmailAddressEnd > indexEmailAddress && length > indexEmailAddressEnd)
                                {
                                    cb.setEmail(subject.substring(indexEmailAddress + "EMAILADDRESS=".length(), indexEmailAddressEnd));
                                }
                            }

                        }
                    }

                    if (cert.getPublicKey() != null)
                    {
                        cb.setPublicKey(cert.getPublicKey().toString());
                    }

                    System.out.println("version ----> " + (cb.getVersion() != null ? cb.getVersion() : "n/a"));
                    System.out.println("serialNumber ----> " + (cb.getSerialNumber() != null ? cb.getSerialNumber() : "n/a"));
                    System.out.println("signatureAlgorithm ----> " + (cb.getSignatureAlgorithm() != null ? cb.getSignatureAlgorithm() : "n/a"));
                    System.out.println("issuer ----> " + (cb.getIssuer() != null ? cb.getIssuer() : "n/a"));
                    System.out.println("validFrom ----> " + (cb.getValidFrom() != null ? cb.getValidFrom() : "n/a"));
                    System.out.println("isvalid ----> " + (cb.isIsValid() ? "Yes" : "No"));
                    System.out.println("validTo ----> " + (cb.getValidTo() != null ? cb.getValidTo() : "n/a"));
                    System.out.println("isExpired ----> " + (cb.isIsExpired() ? "Yes" : "No"));
                    System.out.println("subject ----> " + (cb.getSubject() != null ? cb.getSubject() : "n/a"));
                    System.out.println("id ----> " + (cb.getId() != null ? cb.getId() : "n/a"));
                    System.out.println("bank code ----> " + (cb.getBankCode() != null ? cb.getBankCode() : "n/a"));
                    System.out.println("bank name ----> " + (cb.getBankName() != null ? cb.getBankName() : "n/a"));
                    System.out.println("email ----> " + (cb.getEmail() != null ? cb.getEmail() : "n/a"));
                    System.out.println("publicKey ----> " + (cb.getPublicKey() != null ? cb.getPublicKey() : "n/a"));

                    if (status.equals(LCPL_Constants.status_all))
                    {

                        if (htCerts.get(bank) != null)
                        {
                            Collection<Certificate> col = htCerts.get(bank);
                            col.add(cb);
                            htCerts.put(bank, col);
                        }
                        else
                        {
                            Collection<Certificate> col = new java.util.ArrayList();
                            col.add(cb);
                            htCerts.put(bank, col);
                        }
                    }
                    else if (status.equals(LCPL_Constants.status_yes))
                    {
                        if (!cb.isIsExpired() && cb.isIsValid())
                        {
                            if (htCerts.get(bank) != null)
                            {
                                Collection<Certificate> col = htCerts.get(bank);
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                            else
                            {
                                Collection<Certificate> col = new java.util.ArrayList();
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                        }
                    }
                    else if (status.equals(LCPL_Constants.status_no))
                    {
                        if (cb.isIsExpired() || !cb.isIsValid())
                        {
                            if (htCerts.get(bank) != null)
                            {
                                Collection<Certificate> col = htCerts.get(bank);
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                            else
                            {
                                Collection<Certificate> col = new java.util.ArrayList();
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                        }
                    }

                }
            }
        }

//        if (htCerts != null)
//        {
//            System.out.println("htCerts.size() --->" + htCerts.size());
//
//            Collection<Certificate> col = htCerts.get("7135");
//
//            System.out.println("col.size() ---> " + col.size());
//        }
        //files[i].renameTo(new File(files[i].getParent()+ "\\edited\\" + "CRT" + bank + underscore));
        return htCerts;
    }

    public static void main(String[] args)
    {

        new CertificateDAOImpl().analyze("7083", LCPL_Constants.status_all);

    }

}

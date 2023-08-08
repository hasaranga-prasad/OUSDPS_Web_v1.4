/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.certificates;

/**
 *
 * @author Dinesh
 */
public class Certificate
{
    // General Details

    private boolean isExpired;
    private boolean isValid;
    private String name;
    // Cert Details
    private String version;
    private String serialNumber;
    private String signatureAlgorithm;
    private String issuer;
    private String validFrom;
    private String validTo;
    private String subject;
    private String publicKey;
    private String authKeyIdentifier;
    private String authInfoAccess;
    private String enhancedKeyUsage;
    private String subjectAlternativeName;
    private String keyUsage;
    private String thumbPrintAlgorithm;
    private String thumbPrint;
    // Sub Details
    private String id;
    private String bankCode;
    private String bankName;
    private String email;

    public String getAuthInfoAccess()
    {
        return authInfoAccess;
    }

    public void setAuthInfoAccess(String authInfoAccess)
    {
        this.authInfoAccess = authInfoAccess;
    }

    public String getAuthKeyIdentifier()
    {
        return authKeyIdentifier;
    }

    public void setAuthKeyIdentifier(String authKeyIdentifier)
    {
        this.authKeyIdentifier = authKeyIdentifier;
    }

    public String getBankCode()
    {
        return bankCode;
    }

    public void setBankCode(String bankCode)
    {
        this.bankCode = bankCode;
    }

    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getEnhancedKeyUsage()
    {
        return enhancedKeyUsage;
    }

    public void setEnhancedKeyUsage(String enhancedKeyUsage)
    {
        this.enhancedKeyUsage = enhancedKeyUsage;
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public boolean isIsExpired()
    {
        return isExpired;
    }

    public void setIsExpired(boolean isExpired)
    {
        this.isExpired = isExpired;
    }

    public boolean isIsValid()
    {
        return isValid;
    }

    public void setIsValid(boolean isValid)
    {
        this.isValid = isValid;
    }

    public String getIssuer()
    {
        return issuer;
    }

    public void setIssuer(String issuer)
    {
        this.issuer = issuer;
    }

    public String getKeyUsage()
    {
        return keyUsage;
    }

    public void setKeyUsage(String keyUsage)
    {
        this.keyUsage = keyUsage;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getPublicKey()
    {
        return publicKey;
    }

    public void setPublicKey(String publicKey)
    {
        this.publicKey = publicKey;
    }

    public String getSerialNumber()
    {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber)
    {
        this.serialNumber = serialNumber;
    }

    public String getSignatureAlgorithm()
    {
        return signatureAlgorithm;
    }

    public void setSignatureAlgorithm(String signatureAlgorithm)
    {
        this.signatureAlgorithm = signatureAlgorithm;
    }

    public String getSubject()
    {
        return subject;
    }

    public void setSubject(String subject)
    {
        this.subject = subject;
    }

    public String getSubjectAlternativeName()
    {
        return subjectAlternativeName;
    }

    public void setSubjectAlternativeName(String subjectAlternativeName)
    {
        this.subjectAlternativeName = subjectAlternativeName;
    }

    public String getThumbPrint()
    {
        return thumbPrint;
    }

    public void setThumbPrint(String thumbPrint)
    {
        this.thumbPrint = thumbPrint;
    }

    public String getThumbPrintAlgorithm()
    {
        return thumbPrintAlgorithm;
    }

    public void setThumbPrintAlgorithm(String thumbPrintAlgorithm)
    {
        this.thumbPrintAlgorithm = thumbPrintAlgorithm;
    }

    public String getValidFrom()
    {
        return validFrom;
    }

    public void setValidFrom(String validFrom)
    {
        this.validFrom = validFrom;
    }

    public String getValidTo()
    {
        return validTo;
    }

    public void setValidTo(String validTo)
    {
        this.validTo = validTo;
    }

    public String getVersion()
    {
        return version;
    }

    public void setVersion(String version)
    {
        this.version = version;
    }
}

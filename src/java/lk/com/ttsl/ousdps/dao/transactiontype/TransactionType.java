/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.transactiontype;

/**
 *
 * @author Dinesh
 */
public class TransactionType
{

    private String tc;
    private String desc;
    private String type;
    private String maxAmount;
    private String minAmount;
    private String minValueDate;
    private String maxValueDate;
    private String minReturnDate;
    private String maxReturnDate;
    private String man1;
    private String man2;
    private String man3;
    private long lMaxAmount;
    private long lMinAmount;
    private int iMaxValueDate;
    private int iMinValueDate;
    private String modifiedBy;
    private String modifiedDate;

    private String desChargeAmount;
    private String orgChargeAmount;
    private long lDesChargeAmount;
    private long lOrgChargeAmount;

    private String status;

    public TransactionType()
    {
    }

    public TransactionType(String tc, String desc, String type, String maxAmount, String minAmount, String maxValueDate, String minValueDate, String minReturnDate, String maxReturnDate, String man1, String man2, String man3)
    {
        this.tc = tc;
        this.desc = desc;
        this.type = type;
        this.maxAmount = maxAmount;
        this.minAmount = minAmount;
        this.maxValueDate = maxValueDate;
        this.minValueDate = minValueDate;
        this.minReturnDate = minReturnDate;
        this.maxReturnDate = maxReturnDate;
        this.man1 = man1;
        this.man2 = man2;
        this.man3 = man3;
    }

    public TransactionType(String tc, String desc, String type, String maxAmount, String minAmount, String maxValueDate, String minValueDate, String minReturnDate, String maxReturnDate, String man1, String man2, String man3, String modifiedBy)
    {
        this.tc = tc;
        this.desc = desc;
        this.type = type;
        this.maxAmount = maxAmount;
        this.minAmount = minAmount;
        this.maxValueDate = maxValueDate;
        this.minValueDate = minValueDate;
        this.minReturnDate = minReturnDate;
        this.maxReturnDate = maxReturnDate;
        this.man1 = man1;
        this.man2 = man2;
        this.man3 = man3;
        this.modifiedBy = modifiedBy;
    }

    public TransactionType(String tc, String desc, String type, String maxAmount, String minAmount, String maxValueDate, String minValueDate, String minReturnDate, String maxReturnDate, String man1, String man2, String man3, String desChargeAmount, String orgChargeAmount, String modifiedBy)
    {
        this.tc = tc;
        this.desc = desc;
        this.type = type;
        this.maxAmount = maxAmount;
        this.minAmount = minAmount;
        this.maxValueDate = maxValueDate;
        this.minValueDate = minValueDate;
        this.minReturnDate = minReturnDate;
        this.maxReturnDate = maxReturnDate;
        this.man1 = man1;
        this.man2 = man2;
        this.man3 = man3;
        this.desChargeAmount = desChargeAmount;
        this.orgChargeAmount = orgChargeAmount;
        this.modifiedBy = modifiedBy;
    }

    public TransactionType(String tc, String desc, String type, String maxAmount, String minAmount, String maxValueDate, String minValueDate, String minReturnDate, String maxReturnDate, String man1, String man2, String man3, String desChargeAmount, String orgChargeAmount, String status, String modifiedBy)
    {
        this.tc = tc;
        this.desc = desc;
        this.type = type;
        this.maxAmount = maxAmount;
        this.minAmount = minAmount;
        this.maxValueDate = maxValueDate;
        this.minValueDate = minValueDate;
        this.minReturnDate = minReturnDate;
        this.maxReturnDate = maxReturnDate;
        this.man1 = man1;
        this.man2 = man2;
        this.man3 = man3;
        this.desChargeAmount = desChargeAmount;
        this.orgChargeAmount = orgChargeAmount;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public String getDesc()
    {
        return desc;
    }

    public void setDesc(String desc)
    {
        this.desc = desc;
    }

    public int getiMaxValueDate()
    {
        return iMaxValueDate;
    }

    public void setiMaxValueDate(int iMaxValueDate)
    {
        this.iMaxValueDate = iMaxValueDate;
    }

    public int getiMinValueDate()
    {
        return iMinValueDate;
    }

    public void setiMinValueDate(int iMinValueDate)
    {
        this.iMinValueDate = iMinValueDate;
    }

    public long getlMaxAmount()
    {
        return lMaxAmount;
    }

    public void setlMaxAmount(long lMaxAmount)
    {
        this.lMaxAmount = lMaxAmount;
    }

    public long getlMinAmount()
    {
        return lMinAmount;
    }

    public void setlMinAmount(long lMinAmount)
    {
        this.lMinAmount = lMinAmount;
    }

    public String getMan1()
    {
        return man1;
    }

    public void setMan1(String man1)
    {
        this.man1 = man1;
    }

    public String getMan2()
    {
        return man2;
    }

    public void setMan2(String man2)
    {
        this.man2 = man2;
    }

    public String getMan3()
    {
        return man3;
    }

    public void setMan3(String man3)
    {
        this.man3 = man3;
    }

    public String getMaxAmount()
    {
        return maxAmount;
    }

    public void setMaxAmount(String maxAmount)
    {
        this.maxAmount = maxAmount;
    }

    public String getMaxReturnDate()
    {
        return maxReturnDate;
    }

    public void setMaxReturnDate(String maxReturnDate)
    {
        this.maxReturnDate = maxReturnDate;
    }

    public String getMaxValueDate()
    {
        return maxValueDate;
    }

    public void setMaxValueDate(String maxValueDate)
    {
        this.maxValueDate = maxValueDate;
    }

    public String getMinAmount()
    {
        return minAmount;
    }

    public void setMinAmount(String minAmount)
    {
        this.minAmount = minAmount;
    }

    public String getMinReturnDate()
    {
        return minReturnDate;
    }

    public void setMinReturnDate(String minReturnDate)
    {
        this.minReturnDate = minReturnDate;
    }

    public String getMinValueDate()
    {
        return minValueDate;
    }

    public void setMinValueDate(String minValueDate)
    {
        this.minValueDate = minValueDate;
    }

    public String getModifiedBy()
    {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy)
    {
        this.modifiedBy = modifiedBy;
    }

    public String getModifiedDate()
    {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate)
    {
        this.modifiedDate = modifiedDate;
    }

    public String getTc()
    {
        return tc;
    }

    public void setTc(String tc)
    {
        this.tc = tc;
    }

    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public String getDesChargeAmount()
    {
        return desChargeAmount;
    }

    public void setDesChargeAmount(String desChargeAmount)
    {
        this.desChargeAmount = desChargeAmount;
    }

    public String getOrgChargeAmount()
    {
        return orgChargeAmount;
    }

    public void setOrgChargeAmount(String orgChargeAmount)
    {
        this.orgChargeAmount = orgChargeAmount;
    }

    public long getlDesChargeAmount()
    {
        return lDesChargeAmount;
    }

    public void setlDesChargeAmount(long lDesChargeAmount)
    {
        this.lDesChargeAmount = lDesChargeAmount;
    }

    public long getlOrgChargeAmount()
    {
        return lOrgChargeAmount;
    }

    public void setlOrgChargeAmount(long lOrgChargeAmount)
    {
        this.lOrgChargeAmount = lOrgChargeAmount;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

}

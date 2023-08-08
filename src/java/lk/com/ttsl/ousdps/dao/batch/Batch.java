/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.dao.batch;

/**
 *
 * @author Isanka
 */
public class Batch {

    private String batchno;
    private String prebk;
    private String prebr;
    private String type;
    private String applicationdate;
    private String batchcount;
//private double  batchamount;
    private String batchamount;
    private String status;
    private String deliveryid;
    private String time;
    private String errorcode;
    private String bankName;
    private String branchName;
    
    
    private String totalSumFormatted;
    private String batchamountFormatted;

    public String getTotalSumFormatted() {
        return totalSumFormatted;
    }

    public void setTotalSumFormatted(String totalSumFormatted) {


        totalSumFormatted = totalSumFormatted.replaceAll("^0*", "");

        double db_totalSum = Double.parseDouble(totalSumFormatted);

        java.text.NumberFormat nf = java.text.NumberFormat.getInstance();
        nf.setMinimumFractionDigits(2);
        nf.setMinimumFractionDigits(2);

        String str_totalAmount=nf.format(db_totalSum/100);

        this.totalSumFormatted = str_totalAmount;

    }

    public Batch() {
    }

    /**
     * @return the batchno
     */
    public String getBatchno() {
        return batchno;
    }

    /**
     * @param batchno the batchno to set
     */
    public void setBatchno(String batchno) {
        this.batchno = batchno;
    }

    /**
     * @return the prebk
     */
    public String getPrebk() {
        return prebk;
    }

    /**
     * @param prebk the prebk to set
     */
    public void setPrebk(String prebk) {
        this.prebk = prebk;
    }

    /**
     * @return the prebr
     */
    public String getPrebr() {
        return prebr;
    }

    /**
     * @param prebr the prebr to set
     */
    public void setPrebr(String prebr) {
        this.prebr = prebr;
    }

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * @return the applicationdate
     */
    public String getApplicationdate() {
        return applicationdate;
    }

    /**
     * @param applicationdate the applicationdate to set
     */
    public void setApplicationdate(String applicationdate) {
        this.applicationdate = applicationdate;
    }

    /**
     * @return the batchcount
     */
    public String getBatchcount() {
        return batchcount;
    }

    /**
     * @param batchcount the batchcount to set
     */
    public void setBatchcount(String batchcount) {
        this.batchcount = batchcount;
    }

    /**
     * @return the batchamount
     */
    public String getBatchamountFormatted() {

        return batchamountFormatted;
    }

    /**
     * @param batchamount the batchamount to set
     */
    public void setBatchamountFormatted(String batchamount) {

        batchamount = batchamount.replaceAll("^0*", "");

        double db_amount = Double.parseDouble(batchamount);
        
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance();
        nf.setMinimumFractionDigits(2);
        nf.setMinimumFractionDigits(2);
        
        String str_batchamount=nf.format(db_amount/100);
        
        this.batchamountFormatted = str_batchamount;
    }

    /**
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return the deliveryid
     */
    public String getDeliveryid() {
        return deliveryid;
    }

    /**
     * @param deliveryid the deliveryid to set
     */
    public void setDeliveryid(String deliveryid) {
        this.deliveryid = deliveryid;
    }

    /**
     * @return the time
     */
    public String getTime() {
        return time;
    }

    /**
     * @param time the time to set
     */
    public void setTime(String time) {
        this.time = time;
    }

    /**
     * @return the errorcode
     */
    public String getErrorcode() {
        return errorcode;
    }

    /**
     * @param errorcode the errorcode to set
     */
    public void setErrorcode(String errorcode) {
        this.errorcode = errorcode;
    }

    /**
     * @return the bankName
     */
    public String getBankName() {
        return bankName;
    }

    /**
     * @param bankName the bankName to set
     */
    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    /**
     * @return the branchName
     */
    public String getBranchName() {
        return branchName;
    }

    /**
     * @param branchName the branchName to set
     */
    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    

    
   
    public String getBatchamount() {
        return batchamount;
    }

    /**
     * @param batchamountFormatted the batchamountFormatted to set
     */
    public void setBatchamount(String batchamount) {


       this.batchamount = batchamount;
    }
}

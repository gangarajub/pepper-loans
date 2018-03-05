public class InterestAdjustmentAction {
    loan__Loan_Account__c lAcc = new loan__Loan_Account__c();
    loan__Loan_Payment_Transaction__c payment = new loan__Loan_Payment_Transaction__c();
    List<loan__Interest_Posting_Transaction__c> iPTxns = new List<loan__Interest_Posting_Transaction__c>();
    Date systemDate;
    String accrualBaseMethodCode;
    Decimal txnAmount;
    Date txnDate;
    public InterestAdjustmentAction(loan__Loan_Account__c loanAccount, Decimal txnAmount,Date txnDate,Date currentSystemDate,List<loan__Interest_Posting_Transaction__c> iPTxns,String accrualBaseMethodCode){
        this.lAcc = loanAccount;
        this.txnAmount = txnAmount;
        this.txnDate = txnDate;
        this.systemDate = currentSystemDate;
        this.iPTxns = iPTxns;
        this.accrualBaseMethodCode = accrualBaseMethodCode;
    }
    
    public Decimal getAdjustedAmount(){
        Decimal txnAmount = txnAmount;
        Date startDate = txnDate;
        Decimal interestAmount = 0.0;
        Decimal interestAdjustment = 0.0;
        List<loan__Other_Transaction__c> otherTxnsForRateChange = lAcc.loan__Other_Loan_Transactions__r;
        for(loan__Interest_Posting_Transaction__c ipt:iPTxns){
            interestAmount = 0;
            if(ipt.loan__Capitalization_Date__c >= startDate && ipt.loan__Capitalization_Date__c <=systemDate){
                for(loan__Other_Transaction__c rtTxn:otherTxnsForRateChange){
                    if(rtTxn.loan__Txn_Date__c>=startDate && rtTxn.loan__Txn_Date__c<=ipt.loan__Capitalization_Date__c){
                        
                        interestAmount = loan.InterestCalc.calcSI(rtTxn.loan__Interest_Rate__c,
                                                    accrualBaseMethodCode,
                                                    lAcc.loan__Frequency_of_loan_payment__c,
                                                    txnAmount,
                                                    startDate,
                                                    rtTxn.loan__Txn_Date__c);
                        startDate = rtTxn.loan__Txn_Date__c;
                    }
                }
                
                interestAmount = loan.InterestCalc.calcSI(ipt.loan__Interest_Rate__c,
                                                    accrualBaseMethodCode,
                                                    lAcc.loan__Frequency_of_loan_payment__c,
                                                    txnAmount,
                                                    startDate,
                                                    ipt.loan__Capitalization_Date__c);
                startDate = ipt.loan__Capitalization_Date__c;
                txnAmount+=interestAmount;
                interestAdjustment += interestAmount;
            }
        }
        return interestAdjustment;
    }
}
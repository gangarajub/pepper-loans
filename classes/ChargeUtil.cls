global class ChargeUtil {

    public static void updateLoanAddCharge(loan__Loan_Account__c relatedLoan, Decimal charge) {
        relatedLoan.loan__Fees_Remaining__c += charge;
        relatedLoan.loan__Total_Due_Charges__c += charge;
        relatedLoan.loan__Pay_Off_Amount_As_Of_Today__c += charge;
    }

    /**
     * This method does not update the paid charges. That must be handled by outside of this.
    **/
    public static void updateLoanRemoveCharge(loan__Loan_Account__c relatedLoan, Decimal charge) {
        relatedLoan.loan__Fees_Remaining__c -= charge;
        relatedLoan.loan__Total_Due_Charges__c -= charge;
        relatedLoan.loan__Pay_Off_Amount_As_Of_Today__c -= charge;
    }

    public static void updateLoanCapitalizeCharge(loan__Loan_Account__c relatedLoan, Decimal charge, Date chargeDate) {

        //We are not supporting capitalization for non-Loans.
        if(relatedLoan.loan__Product_Type__c != loan.LoanConstants.LOAN)  {
            return;
        }

        Decimal interestAccruedNotDue = loan.InterestCalc.calcSIWithRounding(relatedLoan, chargeDate);
        relatedLoan.loan__Interest_Remaining__c += interestAccruedNotDue;
        relatedLoan.loan__Last_Accrual_Date__c = chargeDate;
        relatedLoan.loan__Capitalized_Fee__c += charge;
        
        //PayOff Amount needs to be updated as adding Interest Remaining and removing Interest Accrued not due
        //which was part of Pay Off Amount
        relatedLoan.loan__Pay_Off_Amount_As_Of_Today__c += (charge + interestAccruedNotDue - relatedLoan.loan__Interest_Accrued_Not_Due__c);
        relatedLoan.loan__Interest_Accrued_Not_Due__c = 0.00;
        if(relatedLoan.loan__Capitalized_Interest__c == null){
            relatedLoan.loan__Capitalized_Interest__c = 0;
        }
        if(relatedLoan.loan__Principal_Remaining__c == null){
             relatedLoan.loan__Principal_Remaining__c = 0.00;
        }
        
        relatedLoan.loan__Loan_Balance__c = relatedLoan.loan__Principal_Remaining__c + relatedLoan.loan__Capitalized_Interest__c + relatedLoan.loan__Capitalized_Fee__c;

    }
    
    webservice static String WaiveCharge(String chargeId){
         
        loan__Charge__c charge = [select id,
                                         name,
                                         loan__Loan_Account__c,
                                         loan__Date__c,
                                         loan__Original_Amount__c,
                                         loan__Waive__c 
                                    from loan__Charge__c where id =: chargeId];
        
        loan__Loan_Account__c loanAcc = [select id,
                                                name,
                                                loan__Product_Type__c,
                                                loan__Capitalized_Fee__c,
                                                loan__Capitalized_Interest__c,
                                                loan__Principal_Remaining__c,
                                                loan__Time_Counting_Method__c,
                                                loan__Interest_Remaining__c,
                                                loan__Interest_Rate__c,
                                                loan__Frequency_of_loan_payment__c,
                                                loan__Interest_Posted__c,
                                                loan__Loan_Balance__c,
                                                loan__Last_Accrual_Date__c,
                                                loan__Interest_Accrued_Not_Due__c,
                                                loan__Pay_Off_Amount_As_Of_Today__c,
                                                (Select id,
                                                        name,
                                                        loan__capitalization_date__c,
                                                        loan__interest_rate__c
                                                   from loan__Interest_Posting_Transactions__r
                                                )
                                           from loan__loan_account__c
                                          where id =: charge.loan__Loan_Account__c 
                                       ];
        
        
         
        return updateLoanUnCapitalizeCharge(charge, loanAcc, charge.loan__Original_Amount__c, charge.loan__Date__c); 
     
    }

    public static String updateLoanUnCapitalizeCharge(loan__Charge__c chargeTxn,loan__Loan_Account__c relatedLoan, Decimal charge, Date chargeDate) {
        
        try{
            List<loan__Interest_Posting_Transaction__c> ipTxnsToBeInserted = new List<loan__Interest_Posting_Transaction__c>();
            //We are not supporting capitalization for non-Loans.
            if(relatedLoan.loan__Product_Type__c != loan.LoanConstants.LOAN)  {
                return 'Loan product type should be LOAN.';
            }
            
            loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
            Date systemDate = util.getCurrentSystemDate();
            
            relatedLoan.loan__Capitalized_Fee__c -= charge;
            //relatedLoan.Total_Due_Charges__c += charge;
            //relatedLoan.loan__Pay_Off_Amount_As_Of_Today__c -= charge;
            if(relatedLoan.loan__Capitalized_Interest__c == null){
                relatedLoan.loan__Capitalized_Interest__c = 0;
            }
            if(relatedLoan.loan__Principal_Remaining__c != null){
                relatedLoan.loan__Loan_Balance__c = relatedLoan.loan__Principal_Remaining__c + relatedLoan.loan__Capitalized_Interest__c + relatedLoan.loan__Capitalized_Fee__c;
            }
            String accrualBaseMethodCode = '';
            if (relatedLoan.loan__Time_Counting_Method__c == loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS) {
                accrualBaseMethodCode = loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_365_365;
            } else if(relatedLoan.loan__Time_Counting_Method__c == loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS_366){
                accrualBaseMethodCode = loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_366_366;
            } else {
                accrualBaseMethodCode = loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_360_360;
            }
            InterestAdjustmentAction act = new InterestAdjustmentAction(relatedLoan,charge,chargeDate,systemDate,relatedLoan.loan__Interest_Posting_Transactions__r,accrualBaseMethodCode);
            Decimal adjustedAmount = act.getAdjustedAmount();
            
            Date lastCapitalizationDate;
            Decimal txnAmount = charge;
            if(relatedLoan.loan__Interest_Posting_Transactions__r.size()>0 ){
                
                lastCapitalizationDate = relatedLoan.loan__Interest_Posting_Transactions__r[relatedLoan.loan__Interest_Posting_Transactions__r.size()-1].loan__Capitalization_Date__c;
                if(lastCapitalizationDate<chargeDate){
                    lastCapitalizationDate = chargeDate;
                }
                for(loan__Other_Transaction__c rtTxn:relatedLoan.loan__Other_Loan_Transactions__r){
                    if(rtTxn.loan__Txn_Date__c>=lastCapitalizationDate && rtTxn.loan__Txn_Date__c<=systemDate){
                        relatedLoan.loan__Interest_Remaining__c += loan.InterestCalc.calcSI(rtTxn.loan__Interest_Rate__c,
                                                    accrualBaseMethodCode,
                                                    relatedLoan.loan__Frequency_of_loan_payment__c,
                                                    txnAmount+adjustedAmount,
                                                    lastCapitalizationDate,
                                                    rtTxn.loan__Txn_Date__c);
                        lastCapitalizationDate = rtTxn.loan__Txn_Date__c;
                    }
                }
                
                relatedLoan.loan__Interest_Remaining__c += loan.InterestCalc.calcSI(relatedLoan.loan__Interest_Rate__c,
                                            accrualBaseMethodCode,
                                            relatedLoan.loan__Frequency_of_loan_payment__c,
                                            txnAmount+adjustedAmount,
                                            lastCapitalizationDate,
                                            systemDate);
            }
             
            relatedLoan.loan__Capitalized_Interest__c += adjustedAmount;
            relatedLoan.loan__Interest_Posted__c += adjustedAmount;
            relatedLoan.loan__Loan_Balance__c = relatedLoan.loan__Principal_Remaining__c + relatedLoan.loan__Capitalized_Fee__c + relatedLoan.loan__Capitalized_Interest__c;
            if(adjustedAmount>0){
                ipTxnsToBeInserted.add(CustomBulkRepaymentAdjustmentAction.createInterestPostingTransaction(relatedLoan, adjustedAmount,systemDate));
            }
            
            relatedLoan.loan__Last_Accrual_Date__c = systemDate;
             
            relatedLoan.loan__Interest_Accrued_Not_Due__c = 0.0;
           
            relatedLoan.loan__Pay_Off_Amount_As_Of_Today__c = relatedLoan.loan__Loan_Balance__c;
            insert ipTxnsToBeInserted;
            
            Charge_Reversal_Transaction__c chrgRevTxn = new Charge_Reversal_Transaction__c();
            chrgRevTxn.Charge__c = chargeTxn.Id;
            chrgRevTxn.Cl_Contract__c = relatedLoan.Id;
            chrgRevTxn.Balance__c = relatedLoan.loan__Loan_Balance__c;
            chrgRevTxn.Transaction_Date__c = DateTime.newInstance(systemDate,System.now().time());
            chrgRevTxn.Transaction_Amount__c = txnAmount;
            
            insert chrgRevTxn;
            
            update relatedLoan;
            
            chargeTxn.loan__Waive__c = true;
            update chargeTxn;
            
            return 'Charge waived successfully.';
        }
        catch(Exception e){
            return ('Exception while waiving charge : ' + e.getMessage());
        }
    }

    /**
     * This method will always assume the oldCharges are sorted, either desc or asch.
    **/
    public static loan__Charge__c findSameChargeAppliedWithinMinimumDays(List<loan__Charge__c> oldCharges,
                                                            loan__Fee__c fee,
                                                            Date newChargeDate) {
        //Apply the charge only if #days past after last charge of same type
        //List<Charge__c> oldCharges = relatedLoan.Charges__r;
        if(oldCharges == null) {
            return null;
        }

        loan__Charge__c prevCharge = null;
        for(loan__Charge__c oldCharge : oldCharges) {
            if(oldCharge.loan__Fee__c != fee.Id) {
                continue;
            }
            if(fee.loan__Recurrent_Charge_Minimum_Days__c == null) {
                fee.loan__Recurrent_Charge_Minimum_Days__c = 0;
            }

            Integer  diff = oldCharge.loan__Date__c.daysBetween(newChargeDate);
            //The charge can't be put before or after the older charge
            if(fee.loan__Recurrent_Charge_Minimum_Days__c > math.abs(diff)) {
                return oldCharge;
            }
            if(prevCharge == null) {
                prevCharge = oldCharge;
            }
            else {
                Date minDate = prevCharge.loan__Date__c;
                Date maxDate = oldCharge.loan__Date__c;

                if(minDate > oldCharge.loan__Date__c) {
                    minDate = oldCharge.loan__Date__c;
                }
                if(maxDate < prevCharge.loan__Date__c) {
                    maxDate = prevCharge.loan__Date__c;
                }

                if(minDate <= newChargeDate && newChargeDate <= maxDate) {
                    //no need to check further
                    break;
                }

            }
        }
        return null;
    }

}
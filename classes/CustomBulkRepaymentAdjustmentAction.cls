global with sharing class CustomBulkRepaymentAdjustmentAction implements loan.IBulkPaymentReversalAction{
    private List<loan__Repayment_Transaction_Adjustment__c> repaymentAdjustmentList;
    private Map<Id, loan__Repayment_Schedule__c> repaymentScheduleMap;
    private Map<Id,List<loan__Interest_Posting_Loan_Payment__c>> pmtIdToIptLptMap = new Map<Id,List<loan__Interest_Posting_Loan_Payment__c>>();
    private List<loan__Interest_Posting_Transaction__c> ipTxnsToBeInserted = new List<loan__Interest_Posting_Transaction__c>();
    private List<loan__Interest_Posting_Loan_Payment__c> iPLPToBeUpdated = new List<loan__Interest_Posting_Loan_Payment__c>();
    private List<loan__Interest_Posting_Transaction__c> iptToBeUpdated = new List<loan__Interest_Posting_Transaction__c>();
    private List<loan__Fee_Payment__c> feePayments = new List<loan__Fee_Payment__c> ();
    global CustomBulkRepaymentAdjustmentAction (List<loan__Repayment_Transaction_Adjustment__c> repaymentAdjustmentList) {
        this.repaymentAdjustmentList = repaymentAdjustmentList;
    }
    
    global void setRepaymentAdjustmentList(List<loan__Repayment_Transaction_Adjustment__c> repaymentAdjustmentList){
        this.repaymentAdjustmentList = repaymentAdjustmentList;
    }
    
    global CustomBulkRepaymentAdjustmentAction (){}
   
    global void postRepaymentsAdjusment(){
        if(repaymentAdjustmentList==null || repaymentAdjustmentList.size() == 0)
            return;
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = util.getCurrentSystemDate();
        Set<ID> loanAccountIDs = new Set<ID>();
        Set<Id> loanProductIDs = new Set<Id>(); 
        Set<String> paymentDocNumbers = new Set<String>();
        Map<ID,loan__Repayment_Transaction_Adjustment__c> repaymentAdjustmentMap = new Map<ID,loan__Repayment_Transaction_Adjustment__c>();
        Set<ID> currDuePaymentIds = new Set<ID>();
        Set<ID> amzBasedPaymentIds=new Set<ID>();
        Set<ID> loanPaymentIds = new Set<ID>();
        Map<Id,loan__Charge__c> chargeMap = new Map<Id,loan__Charge__c>();
        for(loan__Repayment_Transaction_Adjustment__c repaymentTransactionAdjustment : repaymentAdjustmentList){
            loanAccountIDs.add(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Loan_Account__c);
            if((repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Payment_Application_Mode__c != null &&
                    repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Payment_Application_Mode__c.equalsIgnoreCase(loan.LoanConstants.LOAN_PAYMENT_APPLICATION_CURRENT_DUES))
               ||((repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Early_Total_Repayment_of_the_Loan__c)
                    &&(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Product_Type__c==loan.LoanConstants.AMZ))){     
                currDuePaymentIds.add(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__c);
            }
            if(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__product_type__C==loan.LoanConstants.AMZ){
               amzBasedPaymentIds.add(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__c); 
            }
            repaymentAdjustmentMap.put(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Loan_Account__c,repaymentTransactionAdjustment);
            paymentDocNumbers.add(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Receipt_ID__c);        
            
            if(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__c!=null){
                loanPaymentIds.add(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__c);
            }
        }
              Map<Id, loan__Loan_Payment_Transaction__c> paymentsMap = new Map<Id, loan__Loan_Payment_Transaction__c>([SELECT 
                                                                                                    Id, Name, 
                                                                                                    (SELECT Id, Name,
                                                                                                        Reversed__c,
                                                                                                        loan__Transaction_Amount__c,
                                                                                                        loan__Transaction_Date__c,
                                                                                                        loan__Charge__c,
                                                                                                        loan__Charge__r.id,
                                                                                                        loan__Charge__r.loan__Original_Amount__c,
                                                                                                        loan__Charge__r.loan__Paid_Amount__c,
                                                                                                        loan__Charge__r.loan__Principal_Due__c
                                                                                                    FROM loan__Fee_Payment__r
                                                                                                    where reversed__c = false
                                                                                                    ORDER BY CreatedDate DESC)
                                                                                                 FROM loan__Loan_Payment_Transaction__c
                                                                                                 WHERE Id in :loanPaymentIds]);
                                                                                                 
                                                                                                 
              Map<Id, loan__Loan_Payment_Transaction__c> currDuePayments = new Map<Id, loan__Loan_Payment_Transaction__c>([SELECT 
                                                                                                    Id, Name, 
                                                                                                    (SELECT Id, Name,
                                                                                                        loan__Due__c,
                                                                                                        loan__Interest__c,
                                                                                                        loan__Payment_Amount__c,
                                                                                                        loan__Principal__c
                                                                                                    FROM loan__Due_Payments__r
                                                                                                    ORDER BY loan__Due__r.name DESC)
                                                                                                 FROM loan__Loan_Payment_Transaction__c
                                                                                                 WHERE Id in :currDuePaymentIds]);
        
               Map<Id, loan__Loan_Payment_Transaction__c> amzBasedPaymentsMap = new Map<Id, loan__Loan_Payment_Transaction__c>([SELECT 
                                                                                                        Id, Name,
                                                                                                        (select id,name, 
                                                                                                            loan__Amortization_Schedule__c,
                                                                                                            loan__Loan_Payment_Transaction__c,
                                                                                                            loan__Paid_Principal__c, loan__Paid_Interest__c ,loan__waived_interest__c
                                                                                                        from loan__Loan_Payment_Amz_Sched_Junction__r)
                                                                                                     FROM loan__Loan_Payment_Transaction__c 
                                                                                                     WHERE Id in :amzBasedPaymentIds]);
                List<loan__Interest_Posting_Loan_Payment__c> iPTlPTList = [select id,loan__Interest_Paid__c,
                                                                    loan__Interest_Posting_Transaction__c,
                                                                    loan__Loan_Payment_Transaction__c,
                                                                    
                                                                    loan__Interest_Posting_Transaction__r.id,
                                                                    loan__Interest_Posting_Transaction__r.loan__Balance__c,
                                                                    loan__Interest_Posting_Transaction__r.loan__Is_Capitalized__c,
                                                                    loan__Interest_Posting_Transaction__r.loan__Loan_Contract__c,
                                                                    loan__Interest_Posting_Transaction__r.loan__Interest_Paid__c,
                                                                    loan__Interest_Posting_Transaction__r.loan__Interest_Posted__c,
                                                                    loan__Interest_Posting_Transaction__r.loan__Interest_Rate__c,
                                                                    loan__Interest_Posting_Transaction__r.loan__Interest_UnPaid__c,
                                                                    loan__Interest_Posting_Transaction__r.loan__Is_Paid__c,
                                                                    Interest_Reversed__c
                                                                    from loan__Interest_Posting_Loan_Payment__c
                                                                    where loan__Loan_Payment_Transaction__c IN:loanPaymentIds];
                
                for(loan__Interest_Posting_Loan_Payment__c iPTlPT : iPTlPTList){
                    if(pmtIdToIptLptMap.get(iPTlPT.loan__Loan_Payment_Transaction__c) == null){
                        pmtIdToIptLptMap.put(iPTlPT.loan__Loan_Payment_Transaction__c,new List<loan__Interest_Posting_Loan_Payment__c>());
                    }
                    pmtIdToIptLptMap.get(iPTlPT.loan__Loan_Payment_Transaction__c).add(iPTlPT);
                }
                                                                                                     
                                                                                                     
                                                                                                          
                repaymentScheduleMap= new Map<Id, loan__Repayment_Schedule__c>( [select ID,
                                                                               Name,
                                                                               loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                                               loan__Due_Interest__c,
                                                                               loan__Due_Principal__c,
                                                                               loan__Total_Installment__c, 
                                                                               loan__Total_Due_Fees__c,
                                                                               loan__Total_Paid_Fees__c,
                                                                               loan__Unpaid_Fees__c,
                                                                               loan__isPaid__c,
                                                                               loan__Is_Partially_Paid__c,
                                                                               loan__Date_Paid__c,
                                                                               loan__Interest_Accrued_Not_Due__c,
                                                                               loan__Due_Date__c,
                                                                               loan__Paid_Interest__c,
                                                                               loan__waived_Interest__c,
                                                                               loan__Paid_Principal__c,
                                                                               loan__Paid_Total__c
                                                                           FROM loan__Repayment_Schedule__c
                                                                           WHERE id in (Select loan__Amortization_Schedule__c from loan__Loan_Payment_Amz_Sched_Junction__c  where loan__loan_payment_transaction__C in :amzBasedPaymentIds) 
                                                                          ]);
        
        //Retrieve Loan Account Object
        List<loan__Loan_Account__c> loanAccountList= [select ID,Name,
                                        loan__Product_Type__C,
                                        loan__Reserve_Amount_for_Next_Due__c,
                                        loan__Loan_Product_Name__c,
                                        loan__Is_Capitalization_Enabled__c,
                                        loan__Is_Interest_Posting_Enabled__c,
                                        loan__Branch__c,
                                        loan__Loan_Amount__c,
                                        loan__Disbursal_Date__c,
                                        loan__Interest_Rate__c,
                                        loan__Loan_Status__c,
                                        loan__Fee_Set__c,
                                        loan__Interest_Paid__c,
                                        loan__Principal_Paid__c,
                                        loan__Fees_Paid__c,
                                        loan__Investment_Product_loan__c,
                                        loan__Next_Installment_Date__c,
                                        loan__Number_of_Days_Overdue__c,
                                        loan__Delinquency_Grace_Days__c,
                                        loan__LA_delinquency_flag__c,
                                        loan__Delinquent_Amount__c,
                                        loan__Metro2_First_Delinquency_Date__c,
                                        loan__Metro2_Payment_Rating__c,
                                        loan__Metro2_Account_Status_Code__c,
                                        loan__Next_Crb_Payment_Profile_Date__c,
                                        loan__Metro2_Payment_History__c,
                                        loan__Last_Transaction_Timestamp__c,
                                        loan__Last_Transaction_Type__c,
                                        loan__Interest_On_Overdue_Paid__c,
                                        loan__Principal_Remaining__c,
                                        loan__Loan_Balance__c,
                                        loan__Capitalized_Fee__c,
                                        loan__Capitalized_Interest__c,
                                        loan__Last_Accrual_Date__c,
                                        loan__Interest_Remaining__c,
                                        loan__Interest_waived__c,
                                        loan__Fees_Remaining__c,
                                        loan__Total_Due_Charges__c,
                                        loan__Frequency_of_Loan_Payment__c,
                                        loan__Interest_Accrued_Not_Due__c,
                                        loan__Payment_Frequency_Cycle__c,
                                        loan__Time_Counting_Method__c,
                                        
                                        loan__Accrual_Stop_Indicator__c,
                                        loan__Number_of_Installments__c,
                                        loan__Interest_Calculation_Method__c,
                                        loan__Principal_Adjustment__c,
                                        loan__Principal_Adjustment_Subtract__c,
                                        loan__Migration_Date__c,
                                        loan__Pre_Paid_Interest_Amount__c,
                                        loan__Pre_Paid_Interest_Paid_Till_Date__c,
                                        loan__Closed_Date__c,
                                        loan__Interest_Posted__c,
                                        loan__Oldest_Due_Date__c,
                                        loan__Refinanced__c,                                      
                                        (select Id,
                                                loan__Balance_Amount__c,
                                                loan__Due_Amt__c,
                                                loan__Due_Date__c,
                                                loan__Due_Type_Description__c,
                                                loan__Due_Type__c,
                                                loan__Payment_Amt__c,
                                                loan__Payment_Date__c,
                                                loan__Payment_Satisfied__c,
                                                loan__DD_Primary_Flag__c ,
                                                loan__Tolerance__c,
                                                loan__Transaction_Date__c                                               
                                        from loan__Dues_Details__r
                                         where loan__DD_Primary_Flag__c = true
                                         order by loan__Due_Date__c desc),
                                        (select Id,
                                                Name,
                                                loan__Accrue_Interest_From__c,
                                                loan__Calculated_Interest2__c, // deprecated
                                                loan__Calculated_Interest3__c,
                                                loan__Charge_Type__c,
                                                loan__Date__c,
                                                loan__Fee__c,
                                                loan__Interest_Bearing__c,
                                                loan__Interest_Rate__c,
                                                loan__Original_Amount__c,
                                                loan__Paid_Amount__c,
                                                loan__Reference__c,
                                                loan__Total_Due_Amount__c,
                                                loan__Waive__c,
                                                loan__Paid__c,
                                                loan__Principal_Due__c,
                                                loan__Interest_Due__c,
                                                loan__Last_Accrual_Date__c
                                                from loan__Charges__r),
                                         (select Id,
                                                 Name,
                                                 loan__Transaction_Date__c,
                                                 loan__Cleared__c,
                                                 loan__Reversed__c
                                                 from loan__Loan_Payment_Transactions__r
                                                 where loan__Cleared__c = true and loan__Reversed__c = false
                                                 order by loan__Transaction_Date__c desc, Name Desc LIMIT 1),
                                         (select id,Name,
                                                 loan__Balance__c,
                                                 loan__Capitalization_Date__c,
                                                 loan__Interest_Posted__c,
                                                 loan__Transaction_Creation_Date__c,
                                                 loan__Transaction_Posting_Date__c,
                                                 loan__Interest_Rate__c
                                                 from loan__Interest_Posting_Transactions__r
                                                 where loan__Is_Capitalized__c=true and Adjustment_Transaction__c = false
                                                 order by loan__Capitalization_Date__c asc),
                                         (select id,Name,
                                                 loan__Transaction_Type__c,
                                                 loan__Txn_Date__c,
                                                 loan__New_Interest_Rate__c,
                                                 loan__Interest_Rate__c
                                                 from loan__Other_Loan_Transactions__r
                                                 where loan__Transaction_Type__c=:loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE)
                                                 /* ordering is important as we want to get the recent cleared but not reversed payment
                                                    for each loan and this should be the only candidate for payment reversal */                                                                                                                                      
                                    from loan__Loan_Account__c where ID in :loanAccountIDs];
        Map<Id,loan__Loan_Account__c> loanMap = new Map<Id,loan__Loan_Account__c>();                                    
        for(loan__Loan_Account__c lAcc:loanAccountList){
            loanProductIDs.add(lAcc.loan__Loan_Product_Name__c);            
            loanMap.put(lAcc.Id,lAcc);
        }
        
        
        /*Map<ID,DateTime> maxTxnTimeMap = new Map<ID,DateTime>();
        AggregateResult[] groupedResults = [select max(CreatedDate) max_txn_time, Loan_Account__c loan
                                            from Loan_Payment_Transaction__c
                                            where Loan_Account__c in :loanAccountIds
                                            and Reversed__c = false
                                            and Rejected__c = false
                                            and Cleared__c = true
                                            group by Loan_Account__c];
        // Loop through the query and add chart items
        if(groupedResults != null && groupedResults.size() > 0) {
            for (AggregateResult ar : groupedResults) {
                maxTxnTimeMap.put((ID)ar.get('loan'),DateTime.ValueOf(ar.get('max_txn_time')));
            }
        } */ //commenting as a part of bug ND-94 - test case TestReverseLoanPaymentAPI.testIncorrectReversalOrder
       
        //Database operation. Insert txn and entries    
        Savepoint sp = Database.setSavepoint();
        try{
            //Get the account balances before this payment
            List<loan__Loan_Account__c> loansToBeUpdated = new List<loan__Loan_Account__c>();
            List<loan__Loan_account_Due_Details__c> duesToBeUpdated = new List<loan__Loan_account_Due_Details__c>();
            List<loan__Charge__c> chargesToBeUpdated = new List<loan__Charge__c>();
            List<loan__Loan_Payment_Transaction__c> paymentsToBeUpdated = new List<loan__Loan_Payment_Transaction__c>();
            List<loan__Refinance_Transaction__c> refinanceTxnToBeUpdated = new List<loan__Refinance_Transaction__c>();
            List<loan__Repayment_Schedule__c> repaymentSchedulesToBeUpdated=new List<loan__Repayment_Schedule__c>();
            
            for(loan__Repayment_Transaction_Adjustment__c repaymentTransactionAdjustment : repaymentAdjustmentList){
                String snapShot = repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Loan_Snapshot__c;
                String feeSnapShot = repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Fee_Snapshot__c;
                String dueSnapShot = repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Dues_Snapshot__c;
                loan__Loan_Payment_Transaction__c payment = repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r;
                loan__Refinance_Transaction__c refinTxn = repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Refinance_Transaction__r;
                loan__Loan_Account__c lAcc = loanMap.get(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__r.loan__Loan_Account__c);
                
                System.debug('lAcc.Last_Transaction_Type__c: ' + lAcc.loan__Last_Transaction_Type__c);
                System.debug('lAcc.Last_Transaction_Timestamp__c: ' + lAcc.loan__Last_Transaction_Timestamp__c);
               // System.debug('maxTxnTimeMap.get(lAcc.Id): ' + maxTxnTimeMap.get(lAcc.Id));
                System.debug('payment.Transaction_Time__c: ' + payment.loan__Transaction_Time__c);
                System.debug('lAcc.Migration_Date__c: ' + lAcc.loan__Migration_Date__c);
                
               /* if(lAcc.loan__Migration_Date__c != null && payment.loan__Transaction_Date__c <= lAcc.loan__Migration_Date__c)
                    throw new MyException('You cannot reverse this transaction. Payment transaction date is before the migration date of the loan - ' + lAcc.Name);
                   */ 
                /*if(lAcc.loan__Last_Transaction_Type__c != loan.LoanConstants.LOAN_TRANSACTION_PAYMENT && !lAcc.loan__Is_Interest_Posting_Enabled__c && !lAcc.loan__Is_Capitalization_Enabled__c)
                    throw new MyException('You cannot reverse this transaction. Please check the activity log of loan - ' + lAcc.Name + ' in Other Transaction view.');
                loan__Loan_Payment_Transaction__c recentTransaction = (lAcc.loan__Loan_Payment_Transactions__r == null ? null : 
                                                    (lAcc.loan__Loan_Payment_Transactions__r.size() == 1 ? 
                                                            lAcc.loan__Loan_Payment_Transactions__r.get(0) : null));
                
                if(lAcc.loan__Last_Transaction_Type__c == loan.LoanConstants.LOAN_TRANSACTION_PAYMENT && recentTransaction != null &&
                        recentTransaction.Id != payment.Id && !lAcc.loan__Is_Interest_Posting_Enabled__c && !lAcc.loan__Is_Capitalization_Enabled__c) {
                    throw new MyException('You must reverse the last payment transaction. Please check the activity log of loan - ' + lAcc.Name + ' in Other Transaction view.');
                }*/
                payment.loan__Reversed__c = true;
                paymentsToBeUpdated.add(payment);

                // handle refinance transaction by reducing payment amount from actual amount refinaced
                // and marking the refinance transaction settled flag as false
                if (refinTxn != null){
                    if(refinTxn.loan__Refinanced_Loan_Account__c != payment.loan__Loan_Account__c) 
                        throw new MyException('You cannot reverse this transaction. The loan on Payment Transaction is different from the loan on Refinance Transaction.');

                    refinTxn.loan__Actual_Refinance_Amount__c -= payment.loan__Transaction_Amount__c;
                    refinTxn.loan__Settled__c = false;
                    refinanceTxnToBeUpdated.add(refinTxn);
                }
                
                System.debug('before: ' + lAcc);
                
                
                // update balance on reversal transaction
                if( !lAcc.loan__Is_Interest_Posting_Enabled__c && !lAcc.loan__Is_Capitalization_Enabled__c){
                    lAcc = loan.BalanceSnapshotUnit.retrieveLoanAccountFromSnapshot(lAcc,payment, snapshot);
                    repaymentTransactionAdjustment.loan__Balance__c = lAcc.loan__Principal_Remaining__c;
                    repaymentTransactionAdjustment.loan__Payoff_Balance__c = lAcc.loan__Pay_Off_Amount_As_Of_Today__c;
                    repaymentTransactionAdjustment.loan__Interest_Rate__c = lAcc.loan__Interest_Rate__c;
                     
                }else{
                    lAcc.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
                    lAcc.loan__Interest_Remaining__c += loan.InterestCalc.calcSI(lAcc, currentSystemDate);
                    
                    if(pmtIdToIptLptMap.get(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__c)!=null){
                        for(loan__Interest_Posting_Loan_Payment__c iptLptToBeRev:pmtIdToIptLptMap.get(repaymentTransactionAdjustment.loan__Loan_Payment_Transaction__c) ){
                            iptLptToBeRev.loan__Interest_Posting_Transaction__r.loan__Interest_Paid__c -= iptLptToBeRev.loan__Interest_Paid__c;
                            lAcc.loan__Capitalized_Interest__c += iptLptToBeRev.loan__Interest_Paid__c;
                            lAcc.loan__Interest_Posted__c+= iptLptToBeRev.loan__Interest_Paid__c;
                            
                            iptLptToBeRev.Interest_Reversed__c = iptLptToBeRev.loan__Interest_Paid__c;
                            if((iptLptToBeRev.loan__Interest_Posting_Transaction__r.loan__Interest_Posted__c - iptLptToBeRev.loan__Interest_Posting_Transaction__r.loan__Interest_Paid__c)>0){
                                iptLptToBeRev.loan__Interest_Posting_Transaction__r.loan__is_Paid__c = false;
                            }
                            iPLPToBeUpdated.add(iptLptToBeRev);
                            iptToBeUpdated.add(iptLptToBeRev.loan__Interest_Posting_Transaction__r);
                        }
                    }
                    lAcc.loan__Principal_Remaining__c += payment.loan__Principal__c;
                    lAcc.loan__Capitalized_Fee__c += payment.loan__Fees__c;
                    lAcc.loan__Interest_Paid__c -= payment.loan__Interest__c;
                    lAcc.loan__Principal_Paid__c -= payment.loan__Principal__c;
                    lAcc.loan__Fees_Paid__c -= payment.loan__Fees__c;
                    repaymentTransactionAdjustment.loan__Balance__c = lAcc.loan__Principal_Remaining__c + lAcc.loan__Capitalized_Fee__c + lAcc.loan__Capitalized_Interest__c;
                    
                    String accrualBaseMethodCode;
                    if (lAcc.loan__Time_Counting_Method__c == loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS) {
                        accrualBaseMethodCode = loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_365_365;
                    } else if(lAcc.loan__Time_Counting_Method__c == loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS_366){
                        accrualBaseMethodCode = loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_366_366;
                    } else {
                        accrualBaseMethodCode = loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_360_360;
                    }
                    
                    InterestAdjustmentAction act = new InterestAdjustmentAction(lAcc,payment.loan__Transaction_Amount__c,payment.loan__Transaction_Date__c,currentSystemDate,lAcc.loan__Interest_Posting_Transactions__r,accrualBaseMethodCode);
                    Decimal adjustedAmount = act.getAdjustedAmount();
                    system.debug(adjustedAmount);
                    Date lastCapitalizationDate;
                    Decimal txnAmount = payment.loan__Transaction_Amount__c;
                    if(lAcc.loan__Interest_Posting_Transactions__r.size()>0 ){
                        
                        lastCapitalizationDate = lAcc.loan__Interest_Posting_Transactions__r[lAcc.loan__Interest_Posting_Transactions__r.size()-1].loan__Capitalization_Date__c;
                        if(lastCapitalizationDate<payment.loan__Transaction_Date__c){
                            lastCapitalizationDate = payment.loan__Transaction_Date__c;
                        }
                        for(loan__Other_Transaction__c rtTxn:lAcc.loan__Other_Loan_Transactions__r){
                            if(rtTxn.loan__Txn_Date__c>=lastCapitalizationDate && rtTxn.loan__Txn_Date__c<=currentSystemDate){
                                lAcc.loan__Interest_Remaining__c += loan.InterestCalc.calcSI(rtTxn.loan__Interest_Rate__c,
                                                            accrualBaseMethodCode,
                                                            lAcc.loan__Frequency_of_loan_payment__c,
                                                            txnAmount+adjustedAmount,
                                                            lastCapitalizationDate,
                                                            rtTxn.loan__Txn_Date__c);
                                lastCapitalizationDate = rtTxn.loan__Txn_Date__c;
                            }
                        }
                        
                        lAcc.loan__Interest_Remaining__c += loan.InterestCalc.calcSI(lAcc.loan__Interest_Rate__c,
                                                    accrualBaseMethodCode,
                                                    lAcc.loan__Frequency_of_loan_payment__c,
                                                    txnAmount+adjustedAmount,
                                                    lastCapitalizationDate,
                                                    currentSystemDate);
                    }
                     
                    lAcc.loan__Capitalized_Interest__c += adjustedAmount;
                    lAcc.loan__Interest_Posted__c += adjustedAmount;
                    lAcc.loan__Loan_Balance__c = lAcc.loan__Principal_Remaining__c + lAcc.loan__Capitalized_Fee__c + lAcc.loan__Capitalized_Interest__c;
                    if(adjustedAmount>0){
                        ipTxnsToBeInserted.add(createInterestPostingTransaction(lAcc, adjustedAmount,currentSystemDate));
                    }
                    
                    lAcc.loan__Last_Accrual_Date__c = currentSystemDate;
                     
                    lAcc.loan__Interest_Accrued_Not_Due__c = 0.0;
                   
                    lAcc.loan__Pay_Off_Amount_As_Of_Today__c = lAcc.loan__Loan_Balance__c;
                    
                    //will see if this needs to be updated
                    //repaymentTransactionAdjustment.loan__Payoff_Balance__c = lAcc.loan__Pay_Off_Amount_As_Of_Today__c;
                    repaymentTransactionAdjustment.loan__Interest_Rate__c = lAcc.loan__Interest_Rate__c;
                    
                    
                }
                
                loansToBeUpdated.add(lAcc);
                if (!lAcc.loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_REFINANCED)){
                    lAcc.loan__Refinanced__c = false;
                }
                System.debug('after: ' + lAcc);
                //Datetime dTime = SystemDateUtil.getCurrentSystemDateTime();
                lAcc.loan__Last_Transaction_Timestamp__c = currentSystemDate;
                lAcc.loan__Last_Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL;
                
                               
                
                //chargesToBeUpdated.addAll(loan.BalanceSnapshotUnit.getChargesToBeUpdatedFromSnapshot(lAcc,payment, feeSnapshot));
                //making charge unpaid
                List<loan__Fee_Payment__c> feePayment = new List<loan__Fee_Payment__c>();
                if(paymentsMap.get(payment.id)!=null){
                    if(paymentsMap.get(payment.id).loan__Fee_Payment__r.size()>0){
                        feePayment = paymentsMap.get(payment.id).loan__Fee_Payment__r;
                    }
                }
                
                if(feePayment.size()>0){
                    for(loan__Fee_Payment__C fp:feePayment){
                        fp.Reversed__c = true;
                        fp.Reversal_Date__c  = currentSystemDate;
                        if(chargeMap.get(fp.loan__charge__c)==null){
                            chargeMap.put(fp.loan__charge__c,fp.loan__charge__r);
                        }
                        chargeMap.get(fp.loan__charge__c).loan__Paid_Amount__c = chargeMap.get(fp.loan__charge__c).loan__Paid_Amount__c - fp.loan__Transaction_Amount__c;
                        chargeMap.get(fp.loan__charge__c).loan__Principal_Due__c = chargeMap.get(fp.loan__charge__c).loan__Principal_Due__c + fp.loan__Transaction_Amount__c;
                        chargeMap.get(fp.loan__charge__c).loan__Paid__c = false;
                    }
                }
                feePayments.addAll(feePayment);
                
                //As a part of fix for bug ND-225 added this
                if(payment.loan__Payment_Application_Mode__c != null &&
                        payment.loan__Payment_Application_Mode__c.equalsIgnoreCase(loan.LoanConstants.LOAN_PAYMENT_APPLICATION_CURRENT_DUES)) {
                    duesToBeUpdated.addAll(handleDues(lAcc, payment, currDuePayments.get(payment.Id).loan__Due_Payments__r));
                } else {//If its future dues keeping the old code
                    System.debug(logginglevel.error,'$$ : Early_Total_Repayment_of_the_Loan__c : payment '+payment.loan__Early_Total_Repayment_of_the_Loan__c);
                    System.debug(logginglevel.error,'lAcc.Product_Type__c : '+lAcc.loan__Product_Type__c);
                    /*if((lAcc.loan__Product_Type__c==loan.LoanConstants.AMZ)
                        &&(payment.loan__Early_Total_Repayment_of_the_Loan__c)){
                        //when there are no payment applied to dues then do nothing.. on dues..
                        System.debug(logginglevel.error,'currDuePayments.get(payment.Id) '+currDuePayments.get(payment.Id));    
                        if(currDuePayments.get(payment.Id) != null){
                            System.debug(logginglevel.error,'$$ : AMX Loan : payment '+currDuePayments.get(payment.Id).loan__Due_Payments__r.size()); 
                            duesToBeUpdated.addAll(handleDues(lAcc, payment, currDuePayments.get(payment.Id).loan__Due_Payments__r));
                        }
                    //}else{*/                      
                        duesToBeUpdated.addAll(loan.BalanceSnapshotUnit.getDuesToBeUpdatedFromSnapshot(lAcc,payment, dueSnapshot));
                    //}
                }
                if(lAcc.loan__Product_Type__c==loan.LoanConstants.AMZ){
                    System.debug('$$ : AMX Loan : payment '+amzBasedPaymentsMap.get(payment.Id));
                    //repaymentSchedulesToBeUpdated.addAll( handleSchedulesForAMZLoans(amzBasedPaymentsMap.get(payment.Id)));
                    System.debug('$$ : AMX Loan : ' + repaymentSchedulesToBeUpdated);
                }
                //M2
                //loan.LoanTransactionUtil.handleMetro2PaymentHistory(lAcc,payment.loan__Transaction_Date__c,currentSystemDate);                
            }        
            
            //Check delinquency also
            //LoanTransactionUtil.checkDelinquency(loanAccountIds,currentSystemDate);
            for(loan__Loan_Account__c l : loansToBeUpdated){
                loan.LoanTransactionUtil.interestBearingDelinquencyLogic(l, currentSystemDate);
            }
            
            update loansToBeUpdated;
            update paymentsToBeUpdated;
            update repaymentSchedulesToBeUpdated;
            insert ipTxnsToBeInserted;
            update iPLPToBeUpdated;
            update iptToBeUpdated;
            update feePayments;
            // update refinance transactions            
            if (refinanceTxnToBeUpdated.size() > 0){
                update refinanceTxnToBeUpdated;
            }
            
            chargesToBeUpdated.addAll(chargeMap.Values());
            //loan.ChargeTriggerHandler.updateLoans = false;
            loan__Trigger_Parameters__c chargeTriggerParam = loan.CustomSettingsUtil.getTriggerParameters();
            chargeTriggerParam.Disable_custom_Charge_Trigger__c = true;
            upsert chargeTriggerParam;
            update chargesToBeUpdated;
            chargeTriggerParam.Disable_custom_Charge_Trigger__c = false;
            update chargeTriggerParam;
            System.debug('duesToBeUpdated: ' + duesToBeUpdated);
            update duesToBeUpdated;
            
            //Accounting txn that was passed during payment will be reversed and accounts will be updated accordingly
            //Commenting below line for bug ND-591
            // ND-633 removing unnecessary query
            
            //mark adjustment txns as cleared
            for(loan__Repayment_Transaction_Adjustment__c repaymentTransactionAdjustment : repaymentAdjustmentList){
                repaymentTransactionAdjustment.loan__Cleared__c = true;
            }
            
            
            update repaymentAdjustmentList;
            
        }catch (System.DmlException e) {
            Database.rollback(sp);
            //LogUtil.INSTANCE.log(e,'BulkRepaymentAdjustmentAction: DML exception occurred during transaction processing. Error Message: ');
            system.debug(logginglevel.error,e.getStackTraceString());            
            throw new MyException(e);
        }catch(Exception e){
            Database.rollback(sp);
            //LogUtil.INSTANCE.log(e,'BulkRepaymentAdjustmentAction: Error occured during transaction processing. Error Message: ');
            System.debug(logginglevel.error,'Look:' + e.getMessage() + '-' + e.getCause() + '-' + e.getLineNumber());
            system.debug(logginglevel.error,e.getStackTraceString());
            
            throw new MyException(e);
        }finally{
            //LogUtil.INSTANCE.commitToDb();
        }
        return;
    }
    
    public void rejectRepaymentsAdjusment(){
        if(repaymentAdjustmentList.size() == 0)
            return;

        //mark adjustment txns as rejected
        for(loan__Repayment_Transaction_Adjustment__c repaymentTransactionAdjustment : repaymentAdjustmentList){
            repaymentTransactionAdjustment.loan__Rejected__c = true;
        }
        update repaymentAdjustmentList;                
    }
    
    //This should only be called when payment application mode is "Current"
    private List<loan__Loan_Account_Due_Details__c> handleDues(loan__Loan_Account__c loanAccount, loan__Loan_Payment_Transaction__c payment, List<loan__Due_Payment__c> duePayments) {
        List<loan__Loan_Account_Due_Details__c> duesToBeUpdated = new List<loan__Loan_Account_Due_Details__c>();       
        //Look at the Due payments    
        //Could have avoided this map, as the order of due payment and dues should be same, however not relying not that
        Map<Id, loan__Loan_Account_Due_Details__c> loanDues = new Map<Id, loan__Loan_Account_Due_Details__c>();
        for(loan__Loan_Account_Due_Details__c due : loanAccount.loan__Dues_Details__r) {
            loanDues.put(due.Id, due);
        }
        
        //Check the amount on each due payment for this LPT and uncheck the dues
        for(loan__Due_Payment__c duePayment : duePayments) {
            System.debug(logginglevel.error,'Due__c '+duePayment.loan__Due__c+' Interest__c :'+duePayment.loan__Interest__c+' Payment_Amount__c :'+duePayment.loan__Payment_Amount__c);
            if(duePayment.loan__Payment_Amount__c != null && duePayment.loan__Payment_Amount__c != 0) {
                if(loanDues.containsKey(duePayment.loan__Due__c)) {
                    System.debug(logginglevel.error,'loanDues containes key ');
                    loan__Loan_Account_Due_Details__c due = loanDues.get(duePayment.loan__Due__c);
                    due.loan__Payment_Amt__c = due.loan__Payment_Amt__c - duePayment.loan__Payment_Amount__c;
                    System.debug(logginglevel.error,'due.Payment_Amt__c '+due.loan__Payment_Amt__c); 
                    Decimal toleranceAmount = due.loan__Due_Amt__c - (due.loan__Due_Amt__c *  due.loan__Tolerance__c/100);
                    if(loan.ValueUtil.round(due.loan__Payment_Amt__c) < loan.ValueUtil.round(toleranceAmount)) {
                        due.loan__Payment_Satisfied__c = false;
                        due.loan__Payment_Date__c = null;    
                    }
                    duesToBeUpdated.add(due);
                }else{
                    System.debug(logginglevel.error,'loanDues doesn\'t containes key ');
                }
            }
        }
        return duesToBeUpdated;
    }
    
    // Handles the reversal of Schedules for the AMZ based Loans
    /*private list<loan__Repayment_Schedule__c> handleSchedulesForAMZLoans(loan__Loan_Payment_Transaction__c payment){
        List<loan__Repayment_Schedule__c> schedulesForUpdate =new List<loan__Repayment_Schedule__c>();
        if(payment==null)
            return schedulesForUpdate;
        List<loan__Loan_Payment_Amz_Sched_Junction__c> paymentSchedJnList= payment.loan__Loan_Payment_Amz_Sched_Junction__r;
        if(paymentSchedJnList==null || paymentSchedJnList.isEmpty()) return schedulesForUpdate;
        for(loan__Loan_Payment_Amz_Sched_Junction__c psj : paymentSchedJnList){
            loan__Repayment_Schedule__c amzSchedule= repaymentScheduleMap.get(psj.loan__Amortization_Schedule__c);
            amzSchedule.loan__Paid_Interest__c-=psj.loan__paid_interest__c;
            amzSchedule.loan__paid_Principal__c-=psj.loan__paid_principal__c;
            amzSchedule.loan__waived_Interest__c-=psj.loan__waived_Interest__c;
            Decimal due= loan.ValueUtil.round(amzSchedule.loan__Due_Principal__c-amzSchedule.loan__Paid_Principal__c) + loan.ValueUtil.round(amzSchedule.loan__Due_Interest__c-amzSchedule.loan__Paid_Interest__c);
            amzSchedule.loan__isPaid__c=(due==0);
            schedulesForUpdate.add(amzSchedule);
        } 
       return schedulesForUpdate;
    }*/
    
    public static loan__Interest_Posting_Transaction__c createInterestPostingTransaction(loan__Loan_Account__c lAcc, Decimal amount,Date systemDate){
        loan__Interest_Posting_Transaction__c interestPostingTxn = new loan__Interest_Posting_Transaction__c();
        interestPostingTxn.loan__Loan_Contract__c = lAcc.ID;
        interestPostingTxn.loan__Interest_Posted__c = amount;
        interestPostingTxn.loan__Transaction_Creation_Date__c = systemDate;
        interestPostingTxn.loan__Transaction_Posting_Date__c = systemDate;
        interestPostingTxn.loan__Interest_Paid__c = 0.0;
        interestPostingTxn.loan__Is_Posted__c = true;
        interestPostingTxn.loan__Is_Paid__c = false;
        interestPostingTxn.loan__Balance__c = lAcc.loan__Loan_Balance__c;
        interestPostingTxn.loan__Interest_Rate__c = lAcc.loan__Interest_Rate__c;
        interestPostingTxn.loan__Is_Capitalized__c = true;
        interestPostingTxn.loan__Capitalization_Date__c = systemDate;
        interestPostingTxn.Adjustment_Transaction__c = true;
        return interestPostingTxn;
        
    }
 }
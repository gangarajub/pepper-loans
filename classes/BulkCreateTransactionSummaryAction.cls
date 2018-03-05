public class BulkCreateTransactionSummaryAction {
    List<loan__Loan_Account__c> loanAccountList;
    Date startDate;
    Date endDate;
    Map<Id,List<loan__Repayment_Transaction_Adjustment__c>> reversalTxnMap = new Map<Id,List<loan__Repayment_Transaction_Adjustment__c>>();
    List<loan__Repayment_Transaction_Adjustment__c> reversalTxns = new List<loan__Repayment_Transaction_Adjustment__c>();
    public BulkCreateTransactionSummaryAction(List<loan__Loan_Account__c> loanAccountList,Date startDate,Date endDate){
        this.loanAccountList = loanAccountList;
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    private Map<Id,List<loan__Transaction_Summary__c>> txnSummaryMap;
    
    public Map<Id,List<loan__Transaction_Summary__c>>getSummary(){
        txnSummaryMap = new Map<Id,List<loan__Transaction_Summary__c>> ();
        Set<Id> lptIds = new Set<Id>();
        Set<ID> loanAccIds = new Set<ID>();
        for(loan__Loan_Account__c lAcc : loanAccountList)
            loanAccIds.add(lAcc.Id);
        
        loanAccountList = [select Name,
                    loan__Loan_Amount__c,
                    loan__Interest_Calculation_Method__c,
                    loan__Product_Type__c,
                    loan__Excess__c,
                    Txn_Summary_Closing_Balance__c,
                    Txn_Summary_Opening_Balance__c,
                    Txn_Summary_Total_Credit__c,
                    Txn_Summary_Total_Debit__c,
                    Txn_Summary_Total_Fees__c,
                    loan__Loan_Status__c,
                    Txn_Summary_Total_Interest__c,
                    (select Id,Name,
                            loan__Fees__c,
                            loan__Interest__c,
                            loan__Interest_rate__c,
                            loan__Principal__c,
                            loan__Excess__c,
                            loan__Cleared__c,
                            loan__Reversed__c,
                            loan__Transaction_Amount__c,
                            loan__Transaction_Date__c,
                            loan__Payment_Mode__c,
                            loan__Balance__c,
                            loan__Rejected__c,
                            loan__Transaction_Time__c,
                            loan__Payment_Mode__r.Name,
                            CreatedDate
                        from loan__Loan_Payment_Transactions__r
                        where loan__Transaction_Date__c>=:startDate and loan__Transaction_Date__c<=:endDate
                        order by loan__Transaction_Date__c,CreatedDate asc),
                    (select Id,Name,
                            loan__Reference__c,
                            loan__Disbursed_Amt__c,
                            loan__Disbursal_Date__c,
                            loan__Mode_of_Payment__c,
                            loan__Mode_of_Payment__r.name,
                            loan__Interest_Rate__c,
                            loan__Cleared__c,
                            loan__Reversed__c,
                            loan__Rejected__c,
                            CreatedDate
                        from loan__Loan_Disbursal_Transactions__r
                        where loan__Cleared__c=true and 
                        loan__Disbursal_Date__c>=:startDate and loan__Disbursal_Date__c<=:endDate
                        order by loan__Disbursal_Date__c,CreatedDate asc),
                    (select Id,Name,
                            loan__Loan_Contract__c,
                            loan__Capitalization_Date__c,
                            loan__Is_Capitalized__c,
                            loan__Interest_Paid__c,
                            loan__Interest_Posted__c,
                            loan__Interest_UnPaid__c,
                            loan__Interest_Rate__c,
                            loan__Balance__c,
                            loan__Is_Paid__c,
                            loan__Is_Posted__c,
                            loan__Transaction_Creation_Date__c,
                            loan__Transaction_Posting_Date__c,
                            loan__Transaction_Time__c,
                            CreatedDate
                        from loan__Interest_Posting_Transactions__r
                        where loan__Is_Posted__c = true and 
                        loan__Transaction_Posting_Date__c>=:startDate and loan__Transaction_Posting_Date__c<=:endDate
                        order by loan__Transaction_Posting_Date__c,loan__Transaction_Creation_Date__c asc),
                    (select Id,Name,
                            loan__Frequency_of_Loan_Payment__c,
                            loan__Frequency_Cycle_of_Loan_Payment__c,
                            loan__Loan_Account__c,
                            loan__Loan_Snapshot__c,
                            loan__Interest_rate__c,
                            loan__New_Interest_Rate__c,
                            loan__Number_of_Installments__c,
                            loan__Passed_Term__c,
                            loan__Repayment_Extension_Days__c,
                            loan__Repayment_Start_Date__c,
                            loan__Same_monthly_payment__c,
                            loan__Total_Fees_Due__c,
                            loan__Total_Interest_Due__c,
                            loan__Txn_Amt__c,
                            loan__Transaction_Type__c,
                            loan__Txn_Date__c,
                            loan__Reversed__c,
                            loan__Charged_Off_Fees__c,
                            loan__Charged_Off_Principal__c,
                            loan__Charged_Off_Interest__c,
                            CreatedDate
                    from loan__Other_Loan_Transactions__r
                    where loan__Txn_Date__c>=:startDate and loan__Txn_Date__c<=:endDate
                    order by loan__Txn_Date__c,CreatedDate asc),
                    (select Id,
                            Name,
                            loan__Accrue_Interest_From__c,
                            loan__Calculated_Interest2__c, // deprecated
                            loan__Calculated_Interest3__c,
                            loan__Charge_Type__c,
                            loan__Date__c,
                            loan__Fee__c,
                            loan__Fee__r.name,
                            loan__Fee__r.loan__Time_Of_Charge__c,
                            loan__Balance__c,
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
                            loan__Last_Accrual_Date__c,
                            CreatedDate
                            from loan__Charges__r
                            where loan__Date__c<=:endDate and loan__Date__c>=:startDate 
                        ORDER BY loan__Date__c,CreatedDate ASC),
                        (Select Id,Name,
                        Charge__c,
                        Balance__C,
                        CreatedDate,
                        Transaction_Amount__c,
                        Transaction_Date__c,
                        CL_Contract__c 
                        from Charge_Reversal_Transaction__r
                        where Txn_Date__c>=:startDate and Txn_Date__c<=:endDate order by transaction_date__c asc) // this order is important
                    from loan__Loan_Account__c where ID in:loanAccIds];
                    
                   System.debug('----' + loanAccountList);
                   System.debug('--------------------------loanAccount--------------------' + loanAccountList[0].loan__Charges__r);
                   
        for(loan__Loan_Account__c loanAcc : loanAccountList){
            for(loan__Loan_Payment_Transaction__c lpt : loanAcc.loan__Loan_Payment_Transactions__r){
                lptIds.add(lpt.id);
            }
        }
          System.debug('--------------------------loanAccount--------------------' + loanAccountList[0].loan__Charges__r);
                 
         reversalTxns = [select Id,Name,
                                loan__Adjusted_Amount__c,
                                loan__Balance__c,
                                loan__Cleared__c,
                                loan__Interest_Rate__c,
                                loan__Signed_Adjusted_Amount__c,
                                loan__Adjustment_Txn_Date__c,
                                loan__Loan_Payment_Transaction__c,createdDate
                            from loan__Repayment_Transaction_Adjustment__c 
                            where loan__cleared__c = true and loan__Loan_Payment_Transaction__r.loan__Loan_Account__c in: loanAccIds and loan__Adjustment_Txn_Date__c<=:endDate and loan__Adjustment_Txn_Date__c>=:startDate ];
        
        for(loan__Repayment_Transaction_Adjustment__c revTxn : reversalTxns){
            if(reversalTxnMap.get(revTxn.loan__Loan_Payment_Transaction__c)==null){
                reversalTxnMap.put(revTxn.loan__Loan_Payment_Transaction__c,new List<loan__Repayment_Transaction_Adjustment__c>());
            }
            reversalTxnMap.get(revTxn.loan__Loan_Payment_Transaction__c).add(revTxn);
        }
        
        for(loan__Loan_Account__c loanAcc : loanAccountList)
            txnSummaryMap.put(loanAcc.Id,txnSummaryForALoan(loanAcc));
            
        System.debug('txnSummaryMap'+txnSummaryMap);     
        return txnSummaryMap;
    }
        
    private List<loan__Transaction_Summary__c> txnSummaryForALoan(loan__Loan_Account__c loanAccount){
        List<loan__Transaction_Summary__c> txnSummaryList = new List<loan__Transaction_Summary__c>();
        
        List<loan__Loan_Payment_Transaction__c> payments = loanAccount.loan__Loan_Payment_Transactions__r;
        List<loan__Loan_Disbursal_Transaction__c> disbursals = loanAccount.loan__Loan_Disbursal_Transactions__r;
        List<loan__Charge__c> charges = loanAccount.loan__Charges__r;
        system.debug('charge1:'+charges);
        List<loan__Other_Transaction__c> othertxns = loanAccount.loan__Other_Loan_Transactions__r;
        List<loan__Interest_Posting_Transaction__c> interestPostingTransactions = loanAccount.loan__Interest_Posting_Transactions__r;
        List<Charge_Reversal_Transaction__c> chargeRevTxns = loanAccount.Charge_Reversal_Transaction__r;
        system.debug(chargeRevTxns);
        //List<SObject> oList = mergeSObjectLists(payments,disbursals,charges,othertxn,dues);
        List<SObject> oList = mergeTwoSObjectLists(payments,disbursals);

        System.debug('output: ' + oList);
        
        for(SObject obj : oList){
            loan__Transaction_Summary__c txnSummaryRec = new loan__Transaction_Summary__c();
            List<loan__Transaction_Summary__c> txnSummaryRecsforRev = new List<loan__Transaction_Summary__c>();
            txnSummaryRec.loan__Loan_Account__c = loanAccount.Id;
            if(obj instanceof loan__Loan_Payment_Transaction__c){
                loan__Loan_Payment_Transaction__c txn = (loan__Loan_Payment_Transaction__c)obj;
                txnSummaryRec.loan__Transaction_Id__c = txn.Id;
                txnSummaryRec.loan__Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_PAYMENT;    
                txnSummaryRec.loan__Excess__c = txn.loan__Excess__c;
                txnSummaryRec.loan__Interest__c = txn.loan__Interest__c;
                txnSummaryRec.loan__Fees__c = txn.loan__Fees__c;
                txnSummaryRec.loan__Principal__c = txn.loan__Principal__c;
                txnSummaryRec.loan__Txn_Date__c = txn.loan__Transaction_Date__c;
                txnSummaryRec.loan__Interest_Rate__c = txn.loan__Interest_Rate__c;
                txnSummaryRec.loan__Txn_Amt__c =  txn.loan__Principal__c + txn.loan__Interest__c + txn.loan__Fees__c + txn.loan__Excess__c;
                //Added by Nitin S. to show whether the transaction has been reversed or not on Transaction Summary Page
                txnSummaryRec.loan__Reversed__c = txn.loan__Reversed__c;
                txnSummaryRec.loan__Type__c = 'Credit';
                txnSummaryRec.Credit__c = txnSummaryRec.loan__Txn_Amt__c;
                if(loanAccount.loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET)){
                    if(txn.loan__Balance__c==0){
                        txnSummaryRec.loan__Balance__c = (-1)*txn.loan__Excess__c.setScale(2);
                    }else{
                        txnSummaryRec.loan__Balance__c = txn.loan__Balance__c.setScale(2);
                    }
                    
                }else{
                    txnSummaryRec.loan__Balance__c = txn.loan__Balance__c.setScale(2);
                }
                
                txnSummaryRec.Transaction_Creation_Date__c = txn.CreatedDate;
                //txnSummaryRec.Transaction_Timestamp__C = txn.loan__Transaction_Time__c;
                txnSummaryRec.Transaction_Timestamp__C = DateTime.newInstance(txnSummaryRec.loan__Txn_Date__c,txnSummaryRec.Transaction_Creation_Date__c.time());//txn.loan__Transaction_Time__c;
                txnSummaryRec.Transaction_Code__c = txn.loan__Payment_Mode__r.Name;
                String paymentMode = txn.loan__Payment_Mode__r.Name;
                if(txn.loan__Payment_Mode__r.Name =='Direct Credit'){
                    txnSummaryRec.Transaction_Code__c = 'DCR';
                    
                }
                if(txn.loan__Payment_Mode__r.Name =='Direct Debit' || txn.loan__Payment_Mode__r.Name =='ACH' ){
                    txnSummaryRec.Transaction_Code__c = 'DDR';
                    paymentMode = 'Direct Debit';
                }
                if(txn.loan__Payment_Mode__r.Name=='BPAY'){
                    txnSummaryRec.Transaction_Code__c = 'BPAY';
                }
                
                txnSummaryRec.Transaction_Description__c = 'Repayment with payment mode as '+paymentMode;
                
                                
            }else if(obj instanceof loan__Loan_Disbursal_Transaction__c){
                loan__Loan_Disbursal_Transaction__c txn = (loan__Loan_Disbursal_Transaction__c)obj;
                txnSummaryRec.loan__Transaction_Id__c = txn.Id;
                txnSummaryRec.loan__Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL;
                 
                //Balance field should be fixed later to have balance field on disbursal transaction, as In case of FIT it is needed.
                txnSummaryRec.loan__Balance__c = (Decimal)(loanAccount.loan__Loan_Amount__c.setScale(2));
                txnSummaryRec.loan__Interest_Rate__c = txn.loan__Interest_Rate__c;
                txnSummaryRec.loan__Type__c = 'Debit';
                txnSummaryRec.Debit__c = loanAccount.loan__Loan_Amount__c;
                txnSummaryRec.loan__Txn_Amt__c = txn.loan__Disbursed_Amt__c;
                //Modified by Arjun to accomodate LoC and Tranches Disbursals...
                /*if(loanAccount.Product_Type__c.equalsIgnoreCase(LoanConstants.LOAN)){
                    txnSummaryRec.Principal__c = -1*loanAccount.Loan_Amount__c;
                }else{
                    txnSummaryRec.Principal__c = -1*txn.Disbursed_Amt__c;
                }
                */
                txnSummaryRec.loan__Principal__c = -1*txn.loan__Disbursed_Amt__c;
                txnSummaryRec.loan__Txn_Date__c = txn.loan__Disbursal_Date__c;
                //Added by Nitin S. to show whether the transaction has been reversed or not on Transaction Summary Page
                txnSummaryRec.loan__Reversed__c = txn.loan__Reversed__c;
                txnSummaryRec.Transaction_Creation_Date__c = txn.CreatedDate;
                txnSummaryRec.Transaction_Timestamp__C = DateTime.newInstance(txnSummaryRec.loan__Txn_Date__c,txnSummaryRec.Transaction_Creation_Date__c.time());
                txnSummaryRec.Transaction_Code__c = 'PRN';
                String paymentMode = 'Direct Credit';
                txnSummaryRec.Transaction_Description__c = 'Disbursement with payment mode as '+paymentMode;
  
            }
            txnSummaryList.add(txnSummaryRec);
            //txnSummaryList.addAll(txnSummaryRecsForRev);
        }
        
        List<SObject> oList2 = mergeTwoSObjectLists(txnSummaryList,charges);
        System.debug('output: ' + oList);
        
        txnSummaryList = new List<loan__Transaction_Summary__c>();
        for(SObject obj : oList2){
            loan__Transaction_Summary__c txnSummaryRec = new loan__Transaction_Summary__c();
            txnSummaryRec.loan__Loan_Account__c = loanAccount.Id;
            if(obj instanceof loan__Charge__c){
                loan__Charge__c ch = (loan__Charge__c)obj;
                txnSummaryRec.loan__Transaction_Type__c = loan.LoanConstants.LOAN_CHARGE; 
                txnSummaryRec.loan__Transaction_Id__c = ch.Id;
                txnSummaryRec.loan__Txn_Amt__c = ch.loan__Original_Amount__c;
                txnSummaryRec.loan__Txn_Date__c = ch.loan__Date__c;
                txnSummaryRec.loan__Fee_Name__c = ch.loan__Fee__r.name;
                txnSummaryRec.loan__Principal__c = ch.loan__Principal_Due__c;
                txnSummaryRec.loan__Interest_Rate__c = ch.loan__Interest_Rate__c;
                txnSummaryRec.loan__Balance__c = ch.loan__Balance__c.setScale(2) ;
                txnSummaryRec.loan__Type__c = 'Debit';
                txnSummaryRec.Debit__c =  ch.loan__Original_Amount__c;
                txnSummaryRec.Transaction_Creation_Date__c = ch.CreatedDate;
                txnSummaryRec.Transaction_Timestamp__C = DateTime.newInstance(txnSummaryRec.loan__Txn_Date__c,txnSummaryRec.Transaction_Creation_Date__c.time());
                if(ch.loan__Fee__r.loan__Time_Of_Charge__c=='Late Fees'){
                    txnSummaryRec.Transaction_Code__c = 'Fee - late';
                    txnSummaryRec.Transaction_Description__c = 'Late repayment fee';
                }
                if(ch.loan__Fee__r.loan__Time_Of_Charge__c=='NSF Fees'){
                    txnSummaryRec.Transaction_Code__c = 'Fee - dishonour';
                    txnSummaryRec.Transaction_Description__c = 'Dishonour fee';
                }
                if(ch.loan__Fee__r.loan__Time_Of_Charge__c=='Partial Payout'){
                    txnSummaryRec.Transaction_Code__c = 'Fee - Early Repayment';
                    txnSummaryRec.Transaction_Description__c = 'Early repayment fee';
                }
                if(ch.loan__Fee__r.loan__Time_Of_Charge__c=='Other'){
                    txnSummaryRec.Transaction_Code__c = ch.loan__Fee__r.name;
                    txnSummaryRec.Transaction_Description__c = ch.loan__Fee__r.name;
                }
                
                
                txnSummaryList.add(txnSummaryRec);
            }else if(obj instanceof loan__Transaction_Summary__c) {
                txnSummaryList.add((loan__Transaction_Summary__c)obj);
            }
        }
        
        
        List<SObject> oList3 = mergeTwoSObjectLists(txnSummaryList,othertxns);
        txnSummaryList = new List<loan__Transaction_Summary__c>();
        for(SObject obj : oList3){
            loan__Transaction_Summary__c txnSummaryRec = new loan__Transaction_Summary__c();
            txnSummaryRec.loan__Loan_Account__c = loanAccount.Id;
            if(obj instanceof loan__Other_Transaction__c) {
                Boolean addToTxnSummary = false;
                loan__Other_Transaction__c oth = (loan__Other_Transaction__c)obj;
                System.debug('------due amount ' + oth.loan__Loan_Account__c);
                txnSummaryRec.loan__Transaction_Type__c = oth.loan__Transaction_Type__c;
                txnSummaryRec.loan__Txn_Date__c = oth.loan__Txn_Date__c; 
                txnSummaryRec.loan__Transaction_Id__c = oth.Id;               
                txnSummaryRec.loan__Repayment_Extension_Days__c = oth.loan__Repayment_Extension_Days__c;
                txnSummaryRec.loan__Total_Fees_Due__c = oth.loan__Total_Fees_Due__c;
                txnSummaryRec.loan__Txn_Amt__c = oth.loan__Txn_Amt__c;
                txnSummaryRec.loan__Interest_Rate__c = oth.loan__New_Interest_Rate__c;
                if(txnSummaryRec.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_REFUND)){
                    addToTxnSummary = true;
                    txnSummaryRec.Transaction_Code__c = 'RFD';
                    txnSummaryRec.Debit__c = txnSummaryRec.loan__Txn_Amt__c;
                    txnSummaryRec.loan__Type__c = 'Debit';
                    txnSummaryRec.Transaction_Description__c = 'Refund Transaction';
                }else if(txnSummaryRec.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_ADD)){
                    addToTxnSummary = true;
                    txnSummaryRec.Transaction_Code__c = 'PRN-ADD';
                    txnSummaryRec.Debit__c = txnSummaryRec.loan__Txn_Amt__c;
                    txnSummaryRec.loan__Type__c = 'Debit';
                    txnSummaryRec.Transaction_Description__c = 'Principal adjustment';
                }else if(txnSummaryRec.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB)){
                    addToTxnSummary = true;
                    txnSummaryRec.Transaction_Code__c = 'PRN-SUB';
                    txnSummaryRec.Credit__c = txnSummaryRec.loan__Txn_Amt__c;
                    txnSummaryRec.loan__Type__c = 'Credit';
                    txnSummaryRec.Transaction_Description__c = 'Principal adjustment';
                }else if(txnSummaryRec.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE)){
                    addToTxnSummary = true;
                    txnSummaryRec.Transaction_Code__c = 'RATE-CHANGE';
                    txnSummaryRec.loan__Interest_Rate__c = txnSummaryRec.loan__Interest_Rate__c;
                    txnSummaryRec.Transaction_Description__c = 'Rate change with new Interest rate as '+txnSummaryRec.loan__Interest_Rate__c +'% p.a.';
                }
                //Added by Nitin S. to show whether the transaction has been reversed or not on Transaction Summary Page
                if(oth.loan__Reversed__c!=null){
                    txnSummaryRec.loan__Reversed__c = oth.loan__Reversed__c;
                }
                
                txnSummaryRec.Transaction_Creation_Date__c = oth.CreatedDate;
                //Added by Nitin S. to restrict Reversal transaction to occur in Transaction summary
                String isreversal = (string)txnSummaryRec.loan__Transaction_Type__c;
                txnSummaryRec.Transaction_Timestamp__c = DateTime.newInstance(txnSummaryRec.loan__Txn_Date__c,txnSummaryRec.Transaction_Creation_Date__c.time());
                if(addToTxnSummary){
                    txnSummaryList.add(txnSummaryRec);
                }
                else{
                    //txnSummaryList.add(txnSummaryRec);
                }
                
            }else if(obj instanceof loan__Transaction_Summary__c) {
                txnSummaryList.add((loan__Transaction_Summary__c)obj);
            }
        }
        
        List<SObject> oList4 = mergeTwoSObjectLists(txnSummaryList,interestPostingTransactions);
        
        txnSummaryList = new List<loan__Transaction_Summary__c>();
        for(SObject obj : oList4){
            loan__Transaction_Summary__c txnSummaryRec = new loan__Transaction_Summary__c();
            txnSummaryRec.loan__Loan_Account__c = loanAccount.Id;
            if(obj instanceof loan__Interest_Posting_Transaction__c){
                loan__Interest_Posting_Transaction__c ipt = (loan__Interest_Posting_Transaction__c)obj;
                txnSummaryRec.loan__Transaction_Type__c = 'Interest Charge'; 
                txnSummaryRec.loan__Transaction_Id__c = ipt.Id;
                txnSummaryRec.loan__Txn_Amt__c = ipt.loan__Interest_Posted__c;
                txnSummaryRec.loan__Txn_Date__c = ipt.loan__Transaction_Posting_Date__c;
                txnSummaryRec.loan__Interest_Rate__c = ipt.loan__Interest_Rate__c;
                txnSummaryRec.loan__Balance__c = ipt.loan__Balance__c.setScale(2) ;
                if(txnSummaryRec.loan__Txn_Amt__c>0){
                    txnSummaryRec.loan__Type__c = 'Debit';
                    txnSummaryRec.Debit__c = txnSummaryRec.loan__Txn_Amt__c;
                }else{
                    txnSummaryRec.loan__Type__c = 'Credit';
                    txnSummaryRec.Credit__c = (-1) * txnSummaryRec.loan__Txn_Amt__c;
                }
                
                txnSummaryRec.Transaction_Creation_Date__c = ipt.CreatedDate;
                txnSummaryRec.Transaction_Timestamp__C =  DateTime.newInstance(txnSummaryRec.loan__Txn_Date__c,txnSummaryRec.Transaction_Creation_Date__c.time());//ipt.loan__Transaction_Time__c;
                txnSummaryRec.Transaction_Description__c = 'Interest charge';
                txnSummaryRec.Transaction_Code__c = 'INT';
                txnSummaryList.add(txnSummaryRec);
            }else if(obj instanceof loan__Transaction_Summary__c) {
                txnSummaryList.add((loan__Transaction_Summary__c)obj);
            }
        }
        
        List<SObject> oList5 = mergeTwoSObjectLists(txnSummaryList,reversalTxns);
        
        txnSummaryList = new List<loan__Transaction_Summary__c>();
        for(SObject obj : oList5){
            loan__Transaction_Summary__c txnSummaryRec = new loan__Transaction_Summary__c();
            txnSummaryRec.loan__Loan_Account__c = loanAccount.Id;
            if(obj instanceof loan__Repayment_Transaction_Adjustment__c){
               loan__Repayment_Transaction_Adjustment__c revTxn = (loan__Repayment_Transaction_Adjustment__c)obj;
               loan__Transaction_Summary__c txnSummaryRecForRev = new loan__Transaction_Summary__c();
                        txnSummaryRecForRev.loan__Transaction_Id__c = revTxn.id;
                        txnSummaryRecForRev.loan__Type__c = 'Debit';
                        txnSummaryRecForRev.loan__Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL;
                        txnSummaryRecForRev.loan__Txn_Amt__c = (-1) * revTxn.loan__Signed_Adjusted_Amount__c;
                        txnSummaryRecForRev.loan__Txn_Date__c = revTxn.loan__Adjustment_Txn_Date__c;
                        txnSummaryRecForRev.loan__Balance__c = revTxn.loan__Balance__c.setScale(2)  ;
                        txnSummaryRecForRev.loan__Interest_Rate__c = revTxn.loan__Interest_Rate__c;
                        txnSummaryRecForRev.loan__Loan_Account__c = loanAccount.Id;
                        txnSummaryRecForRev.Transaction_Creation_Date__c = revTxn.CreatedDate;
                        txnSummaryRecForRev.Transaction_Timestamp__c = DateTime.newInstance(txnSummaryRecForRev.loan__Txn_Date__c,txnSummaryRecForRev.Transaction_Creation_Date__c.time());
                        txnSummaryRecForRev.Transaction_Code__c = 'DIS';
                        txnSummaryRecForRev.Debit__c = txnSummaryRecForRev.loan__Txn_Amt__c;
                        txnSummaryRecForRev.Transaction_Description__c = 'Payment reversal';
                txnSummaryList.add(txnSummaryRecForRev);
            }else if(obj instanceof loan__Transaction_Summary__c) {
                txnSummaryList.add((loan__Transaction_Summary__c)obj);
            }
        }
        
        List<SObject> oList6 = mergeTwoSObjectLists(txnSummaryList,chargeRevTxns);
        txnSummaryList = new List<loan__Transaction_Summary__c>();
        for(SObject obj : oList6){
            loan__Transaction_Summary__c txnSummaryRec = new loan__Transaction_Summary__c();
            txnSummaryRec.loan__Loan_Account__c = loanAccount.id;
            if(obj instanceof Charge_Reversal_Transaction__c){
                Charge_Reversal_Transaction__c chrg = (Charge_Reversal_Transaction__c)obj;
                txnSummaryRec.loan__Transaction_Type__c = 'Charge Waive'; 
                txnSummaryRec.loan__Transaction_Id__c = chrg.Id;
                txnSummaryRec.loan__Txn_Amt__c = chrg.Transaction_Amount__c;
                txnSummaryRec.loan__Txn_Date__c = chrg.Transaction_Date__c.date();
                txnSummaryRec.loan__Balance__c = chrg.Balance__c.setScale(2) ;
                txnSummaryRec.loan__Type__c = 'Credit';
                txnSummaryRec.Credit__c =  chrg.Transaction_Amount__c;
                txnSummaryRec.Transaction_Creation_Date__c = chrg.CreatedDate;
                txnSummaryRec.Transaction_Timestamp__C = DateTime.newInstance(txnSummaryRec.loan__Txn_Date__c,txnSummaryRec.Transaction_Creation_Date__c.time());//chrg.Transaction_Date__c;
                
                txnSummaryRec.Transaction_Code__c = 'Fee Waive';
                txnSummaryRec.Transaction_Description__c = 'Charge Waive';
                
                txnSummaryList.add(txnSummaryRec);
            }else if(obj instanceof loan__Transaction_Summary__c) {
                txnSummaryList.add((loan__Transaction_Summary__c)obj);
            }
        }
        
        List<TxnSummaryWrapper> txnSum = new List<TxnSummaryWrapper>();
        for(loan__Transaction_Summary__c txn:txnSummaryList){
            txnSum.add(new TxnSummaryWrapper(txn));
        } 
        txnSum.sort();
        
        System.debug('After sort : ' + txnSum);
        txnSummaryList  = new List<loan__Transaction_Summary__C>();
        Decimal previousBalance = 0;
        if(txnSum.size()==1 && loanAccount.loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET)){
            previousBalance  = (-1) * loanAccount.loan__Excess__c;
        }
        for(TxnSummaryWrapper txnWrp:txnSum){
            if(txnWrp.txnSummary.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_REFUND)){
                txnWrp.txnSummary.loan__Balance__c = (-1) * loanAccount.loan__Excess__c;
            }else if(txnWrp.txnSummary.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_ADD)){
                txnWrp.txnSummary.loan__Balance__c = previousBalance+txnWrp.txnSummary.loan__Txn_Amt__c;
            }else if(txnWrp.txnSummary.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB)){
                txnWrp.txnSummary.loan__Balance__c = previousBalance-txnWrp.txnSummary.loan__Txn_Amt__c;
            }
            txnSummaryList.add(txnWrp.txnSummary);
            previousBalance = txnWrp.txnSummary.loan__Balance__c;
        }
        
        return txnSummaryList;
    }
    
    private List<SObject> mergeTwoSObjectLists(List<SObject> list1, List<SObject> list2){
        List<SObject> mergedTxnSummaryList = new List<SObject>();
        
        while (!list1.isEmpty() || !list2.isEmpty()) {
            if (!list1.isEmpty() && !list2.isEmpty()) {
                Datetime objADate; 
                Datetime objBDate;
                
                if(list1.get(0) instanceof loan__Loan_Payment_Transaction__c)
                    objADate = (DateTime)list1.get(0).get('loan__Transaction_Time__c');
                else if(list1.get(0) instanceof loan__Loan_Disbursal_Transaction__c)
                    objADate = DateTime.newInstance((Date)list1.get(0).get('loan__Disbursal_Date__c'),((DateTime)list1.get(0).get('CreatedDate')).time());
                else if(list1.get(0) instanceof loan__Transaction_Summary__c)
                    objADate = (DateTime)list1.get(0).get('Transaction_Timestamp__c');
                else if(list1.get(0) instanceof loan__Charge__c)
                    objADate = DateTime.newInstance((Date)list1.get(0).get('loan__Date__c'),((DateTime)list1.get(0).get('CreatedDate')).time());
                else if(list1.get(0) instanceof loan__Other_Transaction__c)
                    objADate = DateTime.newInstance((Date)list1.get(0).get('loan__Txn_Date__c'),((DateTime)list1.get(0).get('CreatedDate')).time());
                else if(list1.get(0) instanceof loan__Interest_Posting_Transaction__c)
                    objADate = (DateTime)list1.get(0).get('loan__Transaction_Time__c');
                else if(list1.get(0) instanceof loan__Repayment_Transaction_Adjustment__c)
                    objADate = DateTime.newInstance((Date)list1.get(0).get('loan__Adjustment_Txn_Date__c'),((DateTime)list1.get(0).get('CreatedDate')).time());
                else if(list1.get(0) instanceof Charge_reversal_Transaction__c)
                    objADate = (DateTime)list1.get(0).get('Transaction_Date__c');

                
                if(list2.get(0) instanceof loan__Loan_Payment_Transaction__c)
                    objBDate = (DateTime)list2.get(0).get('loan__Transaction_Time__c');
                else if(list2.get(0) instanceof loan__Loan_Disbursal_Transaction__c)
                    objBDate = DateTime.newInstance((Date)list2.get(0).get('loan__Disbursal_Date__c'),((DateTime)list2.get(0).get('CreatedDate')).time());
                else if(list2.get(0) instanceof loan__Transaction_Summary__c)
                    objBDate = (DateTime)list2.get(0).get('Transaction_Timestamp__c');
                else if(list2.get(0) instanceof loan__Charge__c)
                    objBDate = DateTime.newInstance((Date)list2.get(0).get('loan__Date__c'),((DateTime)list2.get(0).get('CreatedDate')).time());
                else if(list2.get(0) instanceof loan__Other_Transaction__c)
                    objBDate =  DateTime.newInstance((Date)list2.get(0).get('loan__Txn_Date__c'),((DateTime)list2.get(0).get('CreatedDate')).time());
                else if(list2.get(0) instanceof loan__Interest_Posting_Transaction__c)
                    objBDate = (DateTime)list2.get(0).get('loan__Transaction_Time__c');
                else if(list2.get(0) instanceof loan__Repayment_Transaction_Adjustment__c)
                    objBDate = DateTime.newInstance((Date)list2.get(0).get('loan__Adjustment_Txn_Date__c'),((DateTime)list2.get(0).get('CreatedDate')).time());
                else if(list2.get(0) instanceof Charge_reversal_Transaction__c)
                    objBDate = (DateTime)list2.get(0).get('Transaction_Date__c');
                        
                //System.debug('objADate: ' + objADate);
                system.debug(list1.get(0));
                //System.debug('objBDate: ' + objBDate);
                system.debug(list2.get(0));
                if ( objADate < objBDate) {
                    mergedTxnSummaryList.add(list1.remove(0));
                } else {
                    mergedTxnSummaryList.add(list2.remove(0));
                }
            }else if (!list1.isEmpty()) {
                mergedTxnSummaryList.add(list1.remove(0));
            } else {
                mergedTxnSummaryList.add(list2.remove(0));
            }
        }
        
        
        return mergedTxnSummaryList;
    }
     
    public class TxnSummaryWrapper implements Comparable {

        public loan__Transaction_Summary__c txnSummary;
    
        // Constructor
        public TxnSummaryWrapper(loan__Transaction_Summary__c txnSum) {
            txnSummary = txnSum;
        }
        
        public Integer compareTo(Object compareTo) {
        
            TxnSummaryWrapper compareToTxnSum = (TxnSummaryWrapper)compareTo;
            //String dateStr1 = txnSummary.Transaction_Timestamp__c.format('yyyy-MM-dd HH:mm:sss');
            //DateTime datetime1 = DateTime.newInstance(Date.valueOf(dateStr1), DateTime.ValueOf(dateStr1).time());//valueOf(dateStr1);//newInstance(Date.valueOf(dateStr1),txnSummary.Transaction_Timestamp__c.time()); 
           
            system.debug('txnSummary'+txnSummary); 
            Datetime actual =  txnSummary.Transaction_Timestamp__c;
            system.debug('Actual date'+actual);
            Integer offset = UserInfo.getTimezone().getOffset(actual);
            system.debug('offset'+offset);
            actual = actual.addSeconds(offset/1000);
            System.debug('actual : ' + actual);
            DateTime datetime1 = actual;
            
            system.debug('datetime1'+datetime1);
            
            //Datetime datetime1 = getLocalDateTime(txnSummary.Transaction_Timestamp__c);
            //String dateStr2 = compareToTxnSum.txnSummary.Transaction_Timestamp__c.format('yyyy-MM-dd HH:mm:sss');//.format('yyyy-mm-dd HH:mm:ss');
            //DateTime datetime2 = DateTime.newInstance(Date.valueOf(dateStr2), DateTime.ValueOf(dateStr2).time());//newInstance(Date.valueOf(dateStr2),compareToTxnSum.txnSummary.Transaction_Timestamp__c.time()); 
            //Datetime datetime2 = getLocalDateTime(compareToTxnSum.txnSummary.Transaction_Timestamp__c);
            system.debug('compareToTxnSum'+compareToTxnSum);
            Datetime actual1 =  compareToTxnSum.txnSummary.Transaction_Timestamp__c;
            Integer offset1 = UserInfo.getTimezone().getOffset(actual1);
            actual1 = actual1.addSeconds(offset1/1000);
            System.debug('actual1 : ' + actual1);
            DateTime datetime2 = actual1;
            
            system.debug('datetime2'+datetime2);
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue;
            if (datetime1 > datetime2) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (datetime1 < datetime2) {
                // Set return value to a negative value.
                returnValue = -1;
            }
           else if (datetime1 == datetime2) {
                
                
            String str1=txnSummary.Transaction_Description__c;
            
            String str2=compareToTxnSum.txnSummary.Transaction_Description__c;      
                
             system.debug('str1'+str1);
             
             system.debug('str2'+str2);
             
             Boolean result=str1.contains('Payment reversal') && str2.contains('Interest charge');
             
             system.debug('result'+result);
             
             if(result){
             
             system.debug('result'+result);

               returnValue = -1;
               
             }
            Boolean result1=str1.contains('Interest charge') && str2.contains('Payment reversal');
             
             system.debug('result1'+result1);
             
             if(result1){
             
             system.debug('result1'+result1);
           
               returnValue = 1;
               
             }

           }
            
        
            return returnValue;       
        }
    }

}
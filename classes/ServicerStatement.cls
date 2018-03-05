public class ServicerStatement  implements Schedulable,Database.Batchable<sobject>,Database.stateful  {

    private Integer batchSize = 500;

    private static String NAME = 'Servicer Statement';
    Map<String,loan__Loan_Account__c> loanMap = new Map<String,loan__Loan_Account__c>();
    List<String> entries = new List<String>();
    Date startDate;
    Date endDate;
    String loanId;
   
    public ServicerStatement() {
        
    }
    
    public ServicerStatement(Date startDate, Date endDate){
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    public void execute(SchedulableContext sc) {
        ServicerStatement j = new ServicerStatement();
        Database.executeBatch(j, 1);
    }
    
    public Database.queryLocator Start(Database.BatchableContext bc) {
        String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_WRITTEN_OFF + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_ACTIVE_MATURED + '\'';
        String query = 'select id,name,SPV__c,loan__Excess__c,loan__Loan_Amount__c,loan__Charged_Off_Principal__c,loan__Number_of_Days_Overdue__c,loan__Loan_Status__c,loan__Expected_Disbursal_Date__c from loan__Loan_Account__c' +
                ' WHERE loan__Loan_Status__c ' +
                'IN (' + allowabledLoanStatuses + ') AND loan__Expected_Disbursal_Date__c<='+String.valueOf(endDate) +'';
        system.debug(query);
        String header = 'SPV,Loan ID,Opening Balance,Payment Received,Opening Fees,Plus Fees Incurred,Less Fees Paid,Plus Fees Reversed,Closing Fees,Opening Interest,Interest charged,Interest Paid,Interest Reversed,Closing Interest,Opening Principal Balance,Principal Advance,Principal Paid,Principal Reversed,Principal Adjustment,Closing Principal Balance,Closing Balance,Principal Charge off,Arrears Days,Contract Status,Origination Date,Report From,Report To'+'\r\n';
        entries.add(header);
        return Database.getQueryLocator(query);
    } // do nothing
    
    public  void Execute(Database.BatchableContext bc, List<sObject> scope) {
        try {
            system.debug(startDate);
            system.debug(endDate);
            List<loan__Loan_Account__c> loanAccount = (List<loan__Loan_Account__c>)scope;
            List<loan__Charge__c> chargesBeforeStartDate = [select id ,loan__Total_Due_Amount__c,loan__Original_Amount__c,loan__Paid_Amount__c,loan__Waive__c from loan__Charge__c where  loan__Loan_Account__c=:loanAccount[0].id and loan__Date__c<:startDate];
            List<loan__Fee_Payment__c> feePaymentBeforeStartDate = [select id,loan__Transaction_Amount__c,loan__Transaction_Date__c from loan__Fee_Payment__c where loan__Loan_Payment_Transaction__r.loan__Loan_Account__c=:loanAccount[0].id and loan__Transaction_Date__c<:startDate ];
            List<loan__Fee_Payment__c> feePaymentRevBeforeStartDate = [select id,loan__Transaction_Amount__c,loan__Transaction_Date__c from loan__Fee_Payment__c where loan__Loan_Payment_Transaction__r.loan__Loan_Account__c=:loanAccount[0].id and Reversal_Date__c<:startDate and reversed__C = true];

            
            List<loan__Fee_Payment__c> feePaymentBetweenRange  = [select id,loan__Transaction_Amount__c,loan__Transaction_Date__c,loan__Loan_Payment_Transaction__r.loan__Reversed__c from loan__Fee_Payment__c where loan__Transaction_Date__c>=:startDate and loan__Transaction_Date__c<=:endDate and loan__Loan_Payment_Transaction__r.loan__Loan_Account__c=:loanAccount[0].id];
            List<loan__Fee_Payment__c> feePaymentReversedBetweenRange  = [select id,loan__Transaction_Amount__c,loan__Transaction_Date__c,loan__Loan_Payment_Transaction__r.loan__Reversed__c from loan__Fee_Payment__c where reversed__c = true and Reversal_Date__c>=:startDate and Reversal_Date__c<=:endDate and loan__Loan_Payment_Transaction__r.loan__Loan_Account__c=:loanAccount[0].id];
            List<loan__Charge__c> chargesBetweenRange = [select id ,loan__Total_Due_Amount__c,loan__Original_Amount__c,loan__Paid_Amount__c,loan__Waive__c from loan__Charge__c where  loan__Loan_Account__c=:loanAccount[0].id and loan__Date__c>=:startDate and loan__Date__c<=:endDate];
            List<Charge_Reversal_Transaction__c> chargeRevTxn = [select id,Transaction_Date__c,Transaction_Amount__C,Balance__c from Charge_Reversal_Transaction__c where Txn_Date__c>=:startDate and CL_Contract__c=:loanAccount[0].Id and Txn_Date__c<=:endDate];
            List<Charge_Reversal_Transaction__c> chargeRevTxnBeforeStartDate = [select id,Transaction_Date__c,Transaction_Amount__C,Balance__c from Charge_Reversal_Transaction__c where Txn_Date__c<:startDate and CL_Contract__c=:loanAccount[0].Id ];
            List<loan__Other_Transaction__c> othTxns = [select Id,Name,
                                                        loan__Frequency_of_Loan_Payment__c,
                                                        loan__Frequency_Cycle_of_Loan_Payment__c,
                                                        loan__Loan_Account__c,
                                                        loan__Loan_Snapshot__c,
                                                        loan__Interest_rate__c,
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
                                                from loan__Other_Transaction__c
                                                where loan__Txn_Date__c<:startDate and loan__Loan_Account__c=:loanAccount[0].id
                                                order by loan__Txn_Date__c,CreatedDate asc];
            loanMap.put(loanAccount[0].id,loanAccount[0]);
            List<String> entry = new List<String>();
            Decimal paymentReceived = 0;
            Decimal openingFees = 0;
            Decimal plusFeesIncurred = 0;
            Decimal lessFeesPaid = 0;
            Decimal plusFeesReversed = 0;
            Decimal closingFees = 0;
            Decimal openingInterest = 0;
            Decimal interestCharged = 0;
            Decimal interestPaid = 0;
            Decimal interestReversed = 0 ;
            Decimal closingInterest  = 0 ; 
            Decimal openingPrincipalBalance = 0;
            Decimal principalAdvance = 0;
            Decimal principalPaid = 0;
            Decimal principalReversed = 0;
            Decimal principalChargeOff = 0;
            Decimal closingPrincipalBalance = 0;
            Decimal closingBalance = 0;
            Decimal arrearDays = 0;
            String contractStatus = '';
            Decimal openingBalance = 0;
            Decimal principalAdjustment = 0;
            Date originationDate;
            
            String spv = '';
            list<loan__Transaction_Summary__c> txnSummary1 = new List<loan__Transaction_Summary__c>();
            List<loan__Transaction_Summary__c> txnSummary = new List<loan__Transaction_Summary__c>();
            try{
                BulkCreateTransactionSummaryAction loanAction1 = new BulkCreateTransactionSummaryAction(loanAccount, startDate.addMonths(-24),startDate.addDays(-1));
                txnSummary1 = loanAction1.getSummary().get(loanAccount[0].id);
                BulkCreateTransactionSummaryAction loanAction = new BulkCreateTransactionSummaryAction(loanAccount, startDate,endDate);
                txnSummary = loanAction.getSummary().get(loanAccount[0].id);
                
                
                if(txnSummary1.size()>0){
                    Integer lastIndex = txnSummary1.size() - 1;
                    
                    for(; lastIndex >= 0; lastIndex--){
                        if('RATE-CHANGE'.equalsIgnoreCase(txnSummary1.get(lastIndex).Transaction_Code__c)){
                            continue;
                        }
                        openingBalance = txnSummary1.get(lastIndex).loan__Balance__c;   
                        break;
                        //openingBalance = txnSummary1.get(txnSummarySize-1).loan__Balance__c;
                    }
                }
                
                Decimal previousPrincipalAdj = 0;
                
                for(loan__Other_Transaction__c txn: othTxns){
                    if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB)){
                        previousPrincipalAdj -= txn.loan__Txn_Amt__c;
                        
                    }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_ADD)){
                        previousPrincipalAdj += txn.loan__Txn_Amt__c;
                        
                    }
                }
                
                for(loan__Charge__c chrg:chargesBeforeStartDate){
                    openingFees += (chrg.loan__Original_Amount__c);
                }
                for(loan__Fee_Payment__c fp:feePaymentBeforeStartDate){
                    openingFees -= fp.loan__Transaction_Amount__c;
                }
                for(loan__Fee_Payment__c fp:feePaymentRevBeforeStartDate){
                    openingFees += fp.loan__Transaction_Amount__c;
                }
                
                for(Charge_Reversal_Transaction__c chrgRev:chargeRevTxnBeforeStartDate){
                    openingFees -= chrgRev.Transaction_Amount__c;
                }
                
                for(loan__Fee_Payment__c fp:feePaymentBetweenRange){
                    
                        lessFeesPaid += fp.loan__Transaction_Amount__c;
                    
                    /*if(fp.loan__Loan_Payment_Transaction__r.loan__Reversed__c == true){
                        plusFeesReversed += fp.loan__Transaction_Amount__c;
                    } */
                }
                
                
                
                
                
                for(Charge_Reversal_Transaction__c chrgRev:chargeRevTxn){
                    plusFeesReversed += chrgRev.Transaction_Amount__c;
                }
                
                for(loan__Charge__c chrg:chargesBetweenRange){
                    
                        plusFeesIncurred += chrg.loan__Original_Amount__c;
                    
                     
                }
                
                for(loan__Fee_Payment__c fp:feePaymentReversedBetweenRange){
                    
                        plusFeesIncurred += fp.loan__Transaction_Amount__c;
                    
                }
                closingFees = openingFees + plusFeesIncurred-lessFeesPaid - plusFeesReversed;
                Decimal principalAdded = 0;
                Decimal principalSub = 0;
                Decimal refundAmount =0;
                for(loan__Transaction_Summary__c txn: txnSummary){
                    if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT) ){
                        paymentReceived += txn.loan__Txn_Amt__c;
                    }
                    if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL) ){
                        paymentReceived -= txn.loan__Txn_Amt__c;
                    }
                    
                    if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_REFUND)){
                        refundAmount += txn.loan__Txn_Amt__c;
                        paymentReceived -= txn.loan__Txn_Amt__c;
                    }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_ADD)){
                        paymentReceived -= txn.loan__Txn_Amt__c;
                        principalPaid -= txn.loan__Txn_Amt__c;
                        
                    }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB)){
                        paymentReceived += txn.loan__Txn_Amt__c;
                        principalPaid += txn.loan__Txn_Amt__c;
                    }
                    
                    
                }
                
                //spv = loanMap.get(txnSummary[0].loan__Loan_Account__c).SPV__c!=null?loanMap.get(txnSummary[0].loan__Loan_Account__c).SPV__c:'';
                
                //loanId = loanMap.get(txnSummary[0].loan__Loan_Account__c).Name!=null?loanMap.get(txnSummary[0].loan__Loan_Account__c).Name:'';
                loanId = loanAccount[0].Name;
                List<loan__Interest_Posting_Transaction__c> ipTxnsBeforeStartDate = [select id, loan__Interest_Posted__c,loan__Is_Paid__c,loan__Interest_Paid__c,loan__Is_Posted__c from loan__Interest_posting_transaction__c where loan__Transaction_Posting_Date__c<:startDate and loan__Loan_Contract__c=:loanAccount[0].id]; 
                List<loan__Interest_Posting_Transaction__c> ipTxnsBetweenRange = [select id, loan__Interest_Posted__c,loan__Is_Paid__c,loan__Interest_Paid__c,loan__Is_Posted__c from loan__Interest_posting_transaction__c where loan__Transaction_Posting_Date__c>=:startDate and loan__Transaction_Posting_Date__c<=:endDate and loan__Loan_Contract__c=:loanAccount[0].id]; 
                List<loan__Loan_Payment_Transaction__c> lptBetweenRange = [select id,loan__Excess__c,loan__Write_Off_Recovery_Payment__c,loan__Interest__c,loan__Principal__c,loan__Cleared__c,loan__Reversed__c from loan__Loan_Payment_Transaction__c where  loan__Loan_Account__c=:loanAccount[0].id and loan__Transaction_Date__c>=:startDate and loan__Transaction_Date__c<=:endDate and loan__Cleared__c=true];
                List<loan__Loan_Payment_Transaction__c> lptBeforeStartDate = [select id,loan__excess__c,loan__Interest__c,loan__Principal__c,loan__Cleared__c,loan__Reversed__c from loan__Loan_Payment_Transaction__c  where loan__Loan_Account__c=:loanAccount[0].id and loan__Transaction_Date__c<:startDate and loan__cleared__C =true];
                List<loan__Loan_Disbursal_Transaction__c> ldtCurrentMonth = [select id , loan__Disbursed_Amt__c from loan__Loan_Disbursal_Transaction__c where loan__Loan_Account__c =:loanAccount[0].id and loan__Disbursal_Date__c<=:endDate and loan__Disbursal_Date__c>=:startDate];
                List<loan__Repayment_Transaction_Adjustment__c> rptAdjBetweenMonth  =  [select Id,Name,
                                                                            loan__Adjusted_Amount__c,
                                                                            loan__Balance__c,
                                                                            loan__Cleared__c,
                                                                            loan__Interest_Rate__c,
                                                                            loan__Signed_Adjusted_Amount__c,
                                                                            loan__Adjustment_Txn_Date__c,
                                                                            loan__Loan_Payment_Transaction__c,
                                                                            loan__Loan_Payment_Transaction__r.loan__Interest__c,
                                                                            loan__Loan_Payment_Transaction__r.loan__Principal__c,
                                                                            createdDate
                                                                        from loan__Repayment_Transaction_Adjustment__c 
                                                                        where loan__cleared__c = true and loan__Loan_Payment_Transaction__r.loan__Loan_Account__c=:loanAccount[0].id and loan__Adjustment_Txn_Date__c<=:endDate and loan__Adjustment_Txn_Date__c>=:startDate ];
                List<loan__Repayment_Transaction_Adjustment__c> rptAdjBeforeMonth  =  [select Id,Name,
                                                                            loan__Adjusted_Amount__c,
                                                                            loan__Balance__c,
                                                                            loan__Cleared__c,
                                                                            loan__Interest_Rate__c,
                                                                            loan__Signed_Adjusted_Amount__c,
                                                                            loan__Adjustment_Txn_Date__c,
                                                                            loan__Loan_Payment_Transaction__c,
                                                                            loan__Loan_Payment_Transaction__r.loan__Interest__c,
                                                                            loan__Loan_Payment_Transaction__r.loan__Principal__c,
                                                                            createdDate
                                                                        from loan__Repayment_Transaction_Adjustment__c 
                                                                        where loan__cleared__c = true and loan__Loan_Payment_Transaction__r.loan__Loan_Account__c=:loanAccount[0].id and loan__Adjustment_Txn_Date__c<:startDate ];                
                
                openingPrincipalBalance = loanAccount[0].loan__Loan_Amount__c;
                
                for(loan__Interest_Posting_Transaction__c ipt: ipTxnsBeforeStartDate){
                    if(ipt.loan__Interest_Posted__c >0){
                        openingInterest += (ipt.loan__Interest_Posted__c );
                    }else{
                        openingPrincipalBalance += (ipt.loan__Interest_Posted__c );
                    }
                    
                }
                for(loan__Loan_Payment_Transaction__c lpt:lptBeforeStartDate){
                    if(lpt.loan__Cleared__C == true ){
                        openingPrincipalBalance -= lpt.loan__principal__c;
                    }
                    if(lpt.loan__Cleared__C == true ){
                        openingInterest -= lpt.loan__Interest__c;
                    }
                }
                for(loan__Repayment_Transaction_Adjustment__c ajTxn:rptAdjBeforeMonth){
                    openingPrincipalBalance += ajTxn.loan__Loan_Payment_Transaction__r.loan__principal__c;
                    openingInterest += ajTxn.loan__Loan_Payment_Transaction__r.loan__Interest__c;
                }
                
                openingPrincipalBalance += previousPrincipalAdj;
                
                for(loan__Interest_Posting_Transaction__c ipt:ipTxnsBetweenRange){
                    if(ipt.loan__Is_Posted__C == true){
                        if(ipt.loan__Interest_Posted__c >0){
                            interestCharged += ipt.loan__Interest_Posted__c;
                        }else{
                            principalAdjustment += ipt.loan__Interest_Posted__c;
                        }
                        
                    }
                    
                }
                Decimal excess = loanAccount[0].loan__Excess__c;
                for(loan__Repayment_Transaction_Adjustment__c ajTxn:rptAdjBetweenMonth){
                    interestReversed += ajTxn.loan__Loan_Payment_Transaction__r.loan__Interest__c;
                    principalReversed += ajTxn.loan__Loan_Payment_Transaction__r.loan__principal__c;
                }
                
                for(loan__Loan_Payment_Transaction__c lpt:lptBetweenRange){
                    
                    
                    if(lpt.loan__Cleared__c == true){
                        principalPaid += lpt.loan__Principal__c + lpt.loan__excess__c;
                        interestPaid += lpt.loan__Interest__c;
                        
                    }
                    
                   
                    
                }
                principalPaid -= refundAmount;
                //openingBalance -= refundAmount;
                //openingPrincipalBalance -= refundAmount;
                if(ldtCurrentMonth.size()>0){
                    for(loan__Loan_Disbursal_Transaction__c ldt:ldtCurrentMonth){
                        principalAdvance += ldt.loan__Disbursed_Amt__c;
                        openingPrincipalBalance -= ldt.loan__Disbursed_Amt__c;
                    }
                    
                    /*if(principalAdvance == loanAccount[0].loan__Loan_Amount__c){
                        openingPrincipalBalance -= ldt.loan__Disbursed_Amt__c;
                    }*/
                    
                }
                principalChargeOff = loanAccount[0].loan__Charged_Off_Principal__c!=null?loanAccount[0].loan__Charged_Off_Principal__c:0;
                closingPrincipalBalance += openingPrincipalBalance+principalAdvance-principalPaid+principalReversed + principalAdjustment;
                closingInterest = openingInterest + interestCharged - interestPaid + interestReversed;
                
                
                closingBalance = closingPrincipalBalance+closingInterest+closingFees;
                if(loanAccount[0].loan__Number_of_Days_overdue__c!=null){
                    arrearDays = loanAccount[0].loan__Number_of_Days_overdue__c;
                }
            
            }catch(Exception e){}
            Boolean insertentry = false;
            if(loanAccount[0].loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET) && loanAccount[0].loan__Excess__c >0 && txnSummary.size()==0){
                
                loanId = loanAccount[0].Name;
                openingBalance = (-1) * loanAccount[0].loan__excess__c;
                openingPrincipalBalance = (-1) * loanAccount[0].loan__excess__c;
                closingPrincipalBalance = (-1) * loanAccount[0].loan__excess__c;
                closingBalance = (-1) * loanAccount[0].loan__excess__c;
                spv = loanAccount[0].SPV__c;
            }
            spv = loanAccount[0].SPV__c;
            loanId = loanAccount[0].Name;
            contractStatus = loanAccount[0].loan__Loan_Status__c;
            originationDate = loanAccount[0].loan__Expected_Disbursal_Date__c;
            entry.add(spv);
            entry.add(loanId);
            entry.add(String.valueOf(openingBalance));
            entry.add(String.valueOf(paymentReceived));
            entry.add(String.valueOf(openingFees));
            entry.add(String.valueOf(plusFeesIncurred));
            entry.add(String.valueOf(lessFeesPaid));
            entry.add(String.valueOf(plusFeesReversed));
            entry.add(String.valueOf(closingFees));
            entry.add(String.valueOf(openingInterest));
            entry.add(String.valueOf(interestCharged));
            entry.add(String.valueOf(interestPaid));
            entry.add(String.valueOf(interestReversed));      
            entry.add(String.valueOf(closingInterest));
            entry.add(String.valueOf(openingPrincipalBalance));
            entry.add(String.valueOf(principalAdvance));
            entry.add(String.valueOf(principalPaid));
            entry.add(String.valueOf(principalReversed));
            entry.add(String.valueOf(principalAdjustment));
            
            entry.add(String.valueOf(closingPrincipalBalance));
            entry.add(String.valueOf(closingBalance));
            entry.add(String.valueOf(principalChargeOff));
            entry.add(String.valueOf(arrearDays));
            entry.add(contractStatus);
            entry.add(String.valueOf(originationDate));
            String reportFrom = String.valueOf(startDate);
            entry.add(reportFrom);
            String reportTo = String.valueOf(endDate);
            entry.add(reportTo);
            String detail = '';
           
            for(String e :entry){
               detail += e+',';
            }
            detail.removeEnd(',');
            detail += '\r\n';
            insertEntry = true;
            if(txnSummary.size()==0 && loanAccount[0].loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_WRITTEN_OFF)){
                insertEntry = true;
            }
            if(txnSummary.size()==0 && loanAccount[0].loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET)){
                insertEntry = true;
            }
            if(loanAccount[0].loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET) && loanAccount[0].loan__Excess__c >0 && txnSummary.size()==0){
                
                insertEntry = true;
            }
            if(insertEntry){
                entries.add(detail);
            }
            
        } catch (Exception e) {
            throw e;
        }
    }
    
    public void Finish(Database.BatchableContext bc) {
        
        String fileBody = '';
        for(String s:entries){
            fileBody += s;
        }
        Report_Configuration__c rpConfig = [select id , folder_name__c from Report_Configuration__c where Name =:Name];
        String folderName= '';
        if(rpConfig!=null && rpConfig.folder_name__c!=null){
            folderName = rpConfig.folder_name__c;
        }
        
        String folderid = '';
        
        if (folderName != null) {
            Folder[] folder = [SELECT Id FROM Folder WHERE Name = :folderName];
            if (folder.size() > 0) {
                folderId = folder[0].Id;
            } else {
                folderId = (Id) UserInfo.getUserId();
            }
        } else {
            folderId = (Id) UserInfo.getUserId();
        }
        loan.GlobalLoanUtilFacade util=new loan.GlobalLoanUtilFacade();
        Date fileDate=util.getCurrentSystemDate();
        String currentTime =String.valueOf(fileDate)+String.valueOf(DateTime.Now());
        Document d = new Document();
        d.Name = Name+ '_' +currentTime+'.csv';
        d.Body = Blob.valueOf(fileBody);
        d.ContentType = 'text/csv';
        d.Type = 'csv';
        d.Description='';
        d.folderid = folderId;
        insert d;
    }

}
public class GLCSVFileGenerationJobHandler {
    
    //private List<loan__Loan_Account__c> loansToBeUpdated;
    private List<loan__Loan_Disbursal_Transaction__c> ldtList;
    private List<loan__Disbursal_Txn_Distribution__c> ldxdList;
    private List<loan__Loan_Payment_Transaction__c> lptList;
    private List<loan__Charge__c> chargeList;
    private List<loan__Interest_Posting_Transaction__c> iptList;
    private List<loan__Repayment_Transaction_Adjustment__c> rtaList;
    private List<loan__Interest_Posting_Transaction__c> iptListOnStartDate;
    private Map<String,loan__Interest_Posting_Transaction__c> iptMap = new Map<String,loan__Interest_Posting_Transaction__c>();
    private Date startDate;
    private List<loan__Other_Transaction__c> othTxns = new List<loan__Other_Transaction__c>();
    private List<String> entryRecords;
    private static Integer counter = 1;
    private Set<Id> loanIds;
    private Date systemDate;
    private List<loan__broker_Transactions__c> btxns = new List<loan__broker_transactions__c>();
    private list<Commission_Amortisation__c> commAmort = new List<Commission_Amortisation__c>();
    private Set<String> setChannel = new Set<String>();
    private Set<String> setLoanProducts = new Set<String>();
    private Map<String, GL_Account_Junction__c> mapGLAccount = new Map<String, GL_Account_Junction__c>();
    private Map<String, FinanceReportCSVFileFormat> mapGLCodeToReport;
    
    private Map<Integer,String> monthMap;
        
    public GLCSVFileGenerationJobHandler(Date systemDate){
        systemDate = systemDate.toStartofMonth().addDays(-1); //systemDate set as last Month's last date
        startDate = systemDate.toStartOfMonth(); //start date set as last month's first date      
        this.systemDate = systemDate;
        entryRecords = new List<String>();
        loanIds = new Set<Id>();
        
        monthMap = new Map<Integer,String>();
        monthMap.put(1,'JAN');
        monthMap.put(2,'FEB');
        monthMap.put(3,'MAR');
        monthMap.put(4,'APR');
        monthMap.put(5,'MAY');
        monthMap.put(6,'JUN');
        monthMap.put(7,'JUL');
        monthMap.put(8,'AUG');
        monthMap.put(9,'SEP');
        monthMap.put(10,'OCT');
        monthMap.put(11,'NOV');
        monthMap.put(12,'DEC');
        
    }
    
    
    
    public Map<String, FinanceReportCSVFileFormat> Process(List<loan__Loan_Account__c> scope, Map<String, FinanceReportCSVFileFormat> mapGLCodeToReport){
        this.mapGLCodeToReport = mapGLCodeToReport;
        try{
            setChannel = new Set<String>();
            setLoanProducts = new Set<String>();
            loanIds = new Set<Id>();
            mapGLAccount = new Map<String, GL_Account_Junction__c>();
            for(loan__Loan_Account__c l : scope){
                loanIds.add(l.Id);
                if(!'DIRECT'.equalsIgnoreCase(String.valueOf(l.Channel__c)) && !'STAFF'.equalsIgnoreCase(String.valueOf(l.Channel__c)))
                    setChannel.add('NOT_DIRECT');
                else if('DIRECT'.equalsIgnoreCase(String.valueOf(l.Channel__c))){
                    setChannel.add('DIRECT/STAFF');
                    setChannel.add('DIRECT');
                }
                else
                    setChannel.add('DIRECT/STAFF');
                setLoanProducts.add(l.loan__Loan_Product_Name__c);
            }
            
            
            List<GL_Account_Junction__c> listGLJunction = [SELECT id,
                                                                  GL_Code__c,
                                                                  Amount_Type__c,
                                                                  Loan_Product__c,
                                                                  Channel__c,
                                                                  Transaction_Type__c
                                                           FROM GL_Account_Junction__c
                                                           WHERE Loan_Product__c IN :setLoanProducts
                                                           AND Channel__c IN :setChannel                                                                  
                                                          ];
            for(GL_Account_Junction__c gajc : listGLJunction){
                mapGLAccount.put(gajc.Loan_Product__c + ':' + gajc.Channel__c + ':' + gajc.Transaction_Type__c + ':' + gajc.Amount_Type__c, gajc);                
            }
            
            iptListOnStartDate = [Select id,name,loan__Interest_Posted__c,loan__Interest_Paid__c,loan__Interest_UnPaid__c,
                        loan__Loan_Contract__r.Name
                        from loan__Interest_Posting_Transaction__c
                        where loan__Loan_Contract__c IN :loanIds AND
                        loan__Transaction_Creation_Date__c = :systemDate.addDays(1)];
                        
            for(loan__Interest_Posting_Transaction__c ipt:iptListOnStartDate){
                system.debug(ipt.loan__Loan_Contract__r.Name);
                iptMap.put(ipt.loan__Loan_Contract__r.Name,ipt);
            }
            //Decimal writtenOffAmount = 0;
            Decimal interestAccrued = 0;
            String strGLCodeCredit = '';
            String strGLCodeDebit = '';
            
            Date entryDate = startDate;
            FinanceReportCSVFileFormat details = new FinanceReportCSVFileFormat('1',
                    'SF' + monthMap.get(entryDate.month()) + String.ValueOf(entryDate.year()).subString(2),
                    String.valueOf(entryDate.month()),
                    '',//String.valueOf(GLCSVFileGenerationJobHandler.counter++)
                    '',//2550605014100
                    '',//String.ValueOf(writtenOffAmount)
                    '',//Label.WRITE_OFF
                    '',//'Loan write off'
                    entryDate,
                    '');//'I'
                    
            FinanceReportCSVFileFormat details1 = new FinanceReportCSVFileFormat('1',
                    'SF' + monthMap.get(entryDate.month()) + String.ValueOf(entryDate.year()).subString(2),
                    String.valueOf(entryDate.month()),
                    '',//String.valueOf(GLCSVFileGenerationJobHandler.counter++)
                    '',//255015401410
                    '',//String.ValueOf(-1 * writtenOffAmount)
                    '',//Label.WRITE_OFF
                    '',//Loan Receivable Charges
                    entryDate,
                    '');//NA

            for(loan__Loan_Account__c l : scope){
                System.debug('Loan : ' + l);
                Decimal individualInterestAccrued = l.loan__Interest_Accrued_Not_Due__c+l.loan__Interest_Remaining__c;
                if(l.loan__Loan_Status__c.equalsIgnoreCase(loan.LoanConstants.LOAN_STATUS_CLOSED_WRITTEN_OFF)){
                    //Write off entry...
                    //Decimal individualWrittenOffAmount = l.loan__Charged_Off_Fees__c != null ? l.loan__Charged_Off_Fees__c : 0 + 
                    //                            l.loan__Charged_Off_Interest__c != null ? l.loan__Charged_Off_Interest__c : 0 + 
                    //                            l.loan__Charged_Off_Principal__c != null ? l.loan__Charged_Off_Interest__c : 0;
                    Decimal writtenOffAmount = l.loan__Charged_Off_Fees__c + 
                                                 l.loan__Charged_Off_Interest__c + 
                                                 l.loan__Charged_Off_Principal__c;                   
                    
                    individualInterestAccrued = l.loan__Charged_Off_Interest__c;                       
                    //if(l.loan__Charged_Off_Date__c >= startDate && individualWrittenOffAmount != 0){
                    //    writtenOffAmount += individualWrittenOffAmount;
                    //}
                    System.debug('writtenOffAmount : ' + writtenOffAmount);
                    System.debug('startDate: ' + startDate);
                    if(writtenOffAmount > 0 && l.loan__Charged_Off_Date__c >= startDate){
                        //Credit
                        strGLCodeCredit = getGLCodeKey(l.loan__Loan_Product_Name__c, l.Channel__c, 'Credit:WRITTENOFFAMOUNT');
                        details.LACCNBR = getGLCode(l.loan__Loan_Product_Name__c, l.Channel__c, 'Credit:WRITTENOFFAMOUNT');
                        details.LAMOUNT1 = String.ValueOf(writtenOffAmount);
                        details.LNARR1 = Label.WRITE_OFF;
                        details.LNARR2 = 'Loan write off';
                        details.LGSTRATECODE = 'I';
                        updateMapGLAccount(strGLCodeCredit, details);
                        //Debit
                        strGLCodeDebit = getGLCodeKey(l.loan__Loan_Product_Name__c, l.Channel__c, 'Debit:WRITTENOFFAMOUNT');                    
                        details1.LACCNBR = getGLCode(l.loan__Loan_Product_Name__c, l.Channel__c, 'Debit:WRITTENOFFAMOUNT');                    
                        details1.LAMOUNT1 = String.ValueOf(-1 * writtenOffAmount);
                        details1.LNARR1 = Label.WRITE_OFF;
                        details1.LNARR2 = 'Loan Receivable Charges';
                        details1.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeDebit, details1);                            
                    }                    
                }
                //else{
                    /*Decimal individualInterestAccrued = l.loan__Interest_Accrued_Not_Due__c+l.loan__Interest_Remaining__c;
                        
                    if(individualInterestAccrued != 0){
                        interestAccrued += individualInterestAccrued;
                        //Current Month's Interest Accrued entry...P&L 
                                           
                    }else{
                        //Current Month's Interest Accrued entry...P&L 
                        if(iptMap.get(l.Name)!=null){
                            individualInterestAccrued = iptMap.get(l.Name).loan__Interest_Posted__c;
                        }
                        if(individualInterestAccrued!=null){
                            interestAccrued += individualInterestAccrued;
                        }
                        
                    }*/
                    
                    
                        
                    if(individualInterestAccrued != 0){
                        interestAccrued = individualInterestAccrued;
                        //Current Month's Interest Accrued entry...P&L 
                                           
                    }else{
                        //Current Month's Interest Accrued entry...P&L 
                        if(iptMap.get(l.Name)!=null){
                            individualInterestAccrued = iptMap.get(l.Name).loan__Interest_Posted__c;
                        }
                        if(individualInterestAccrued!=null){
                            interestAccrued = individualInterestAccrued;
                        }                        
                    }
                    
                    if(interestAccrued > 0){
                        //Credit
                        strGLCodeDebit = getGLCodeKey(l.loan__Loan_Product_Name__c, l.Channel__c, 'Debit:INTERESTACCRUEDAMOUNT');                    
                        details.LACCNBR = getGLCode(l.loan__Loan_Product_Name__c, l.Channel__c, 'Debit:INTERESTACCRUEDAMOUNT');                    
                        details.LAMOUNT1 = String.ValueOf(-1 * interestAccrued);
                        details.LNARR1 = LABEL.ACCRUED_INTEREST;
                        details.LNARR2 = 'Accrued Interest - current month';
                        details.LGSTRATECODE = 'I';
                        updateMapGLAccount(strGLCodeDebit, details);
                        //Debit
                        strGLCodeCredit = getGLCodeKey(l.loan__Loan_Product_Name__c, l.Channel__c, 'Credit:INTERESTACCRUEDAMOUNT');                    
                        details1.LACCNBR = getGLCode(l.loan__Loan_Product_Name__c, l.Channel__c, 'Credit:INTERESTACCRUEDAMOUNT');                    
                        details1.LAMOUNT1 = String.ValueOf(interestAccrued);
                        details1.LNARR1 = LABEL.ACCRUED_INTEREST;
                        details1.LNARR2 = 'Accrued Interest - current month';
                        details1.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeCredit, details1);    
                    }                    
                //}
            }
            System.debug('Initial Map1 : ' + mapGLCodeToReport);
            System.debug('Check Point 1 : ' + scope.size()); 
            System.debug('Start Date : ' + startDate);  
            System.debug('System Date : ' + systemDate);  
            lptList = [Select id,name,loan__Transaction_Amount__c,loan__Transaction_Date__c,loan__Loan_Account__r.Name,
                                    loan__Loan_Account__r.Channel__c, loan__Loan_Account__r.loan__Loan_Product_Name__c 
                                    from loan__Loan_Payment_Transaction__c
                                    where loan__Transaction_Date__c >= :startDate AND loan__Transaction_Date__c <= :systemDate AND
                                    loan__Loan_Account__c IN :loanIds AND
                                    loan__Cleared__c = true AND
                                    loan__Rejected__c = false];
            System.debug('loan__Loan_Payment_Transaction__c : ' + lptList.size());
            
            Decimal transactionAmount = 0;
            for(loan__Loan_Payment_Transaction__c lpt : lptList){
                
                Decimal individualTransactionAmount = lpt.loan__Transaction_Amount__c != null ?
                                                lpt.loan__Transaction_Amount__c : 0;
                if(individualTransactionAmount != 0){
                    //transactionAmount += individualTransactionAmount;
                    transactionAmount = individualTransactionAmount;
                    //Repayment entry..
                    System.debug('Repayment Amt : '+ transactionAmount);
                    if(transactionAmount > 0){
                        //Credit
                        strGLCodeDebit = getGLCodeKey(lpt.loan__Loan_Account__r.loan__Loan_Product_Name__c, lpt.loan__Loan_Account__r.Channel__c, 'Debit:LOANPAYMENTTRANSACTIONAMOUNT');          
                        details.LACCNBR = getGLCode(lpt.loan__Loan_Account__r.loan__Loan_Product_Name__c, lpt.loan__Loan_Account__r.Channel__c, 'Debit:LOANPAYMENTTRANSACTIONAMOUNT');
                        details.LAMOUNT1 = String.ValueOf(-1 * transactionAmount);
                        details.LNARR1 = Label.REPAYMENT;
                        details.LNARR2 = 'Customer Repayment';
                        details.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeDebit, details);
                        
                        //Debit
                        strGLCodeCredit = getGLCodeKey(lpt.loan__Loan_Account__r.loan__Loan_Product_Name__c, lpt.loan__Loan_Account__r.Channel__c, 'Credit:LOANPAYMENTTRANSACTIONAMOUNT');                    
                        details1.LACCNBR = getGLCode(lpt.loan__Loan_Account__r.loan__Loan_Product_Name__c, lpt.loan__Loan_Account__r.Channel__c, 'Credit:LOANPAYMENTTRANSACTIONAMOUNT');                    
                        details1.LAMOUNT1 = String.ValueOf(transactionAmount);
                        details1.LNARR1 = Label.REPAYMENT;
                        details1.LNARR2 = 'Collections Receipt';
                        details1.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeCredit, details1);                                          
                    }                    
                }
            }            
            
            rtaList = [Select id,name,loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c,
                                loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.Name,loan__Adjustment_Txn_Date__c,
                                loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.Channel__c
                                from loan__Repayment_Transaction_Adjustment__c
                                where loan__Loan_Payment_Transaction__r.loan__Loan_Account__c IN :loanIds AND
                                loan__Adjustment_Txn_Date__c >= :startDate AND loan__Adjustment_Txn_Date__c <= :systemDate AND
                                loan__Cleared__c = True];
            
            System.debug('loan__Repayment_Transaction_Adjustment__c : ' + rtaList.size());
            
            Decimal reversalAmount = 0;
            for(loan__Repayment_Transaction_Adjustment__c rta : rtaList){
                
                Decimal transAmount = rta.loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c != null ?
                                                rta.loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c : 0;
                
                if(transAmount != 0){
                    //reversalAmount += transAmount;
                    reversalAmount = transAmount;
                    //DisHonour Payment..
                    
                    if(reversalAmount > 0){
                        //Credit
                        strGLCodeCredit = getGLCodeKey(rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.Channel__c, 'Credit:LOANPAYMENTREVERSALAMOUNT');                    
                        details.LACCNBR = getGLCode(rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.Channel__c, 'Credit:LOANPAYMENTREVERSALAMOUNT');                    
                        details.LAMOUNT1 = String.ValueOf(reversalAmount);
                        details.LNARR1 = Label.REPAYMENT_REVERSAL;
                        details.LNARR2 = 'Dishonour Payment';
                        details.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeCredit, details);
                        //Debit
                        strGLCodeDebit = getGLCodeKey(rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.Channel__c, 'Debit:LOANPAYMENTREVERSALAMOUNT');                    
                        details1.LACCNBR = getGLCode(rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    rta.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.Channel__c, 'Debit:LOANPAYMENTREVERSALAMOUNT');                    
                        details1.LAMOUNT1 = String.ValueOf(-1 * reversalAmount);
                        details1.LNARR1 = Label.REPAYMENT_REVERSAL;
                        details1.LNARR2 = 'Collections Receipt';
                        details1.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeDebit, details1);    
                    }
                }
            }    
                        
            othTxns = [select Id,Name,
                            loan__Frequency_of_Loan_Payment__c,
                            loan__Frequency_Cycle_of_Loan_Payment__c,
                            loan__Loan_Account__c,
                            loan__Loan_Account__r.loan__Loan_Product_Name__c,
                            loan__Loan_Account__r.Channel__c,
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
                            loan__Loan_Account__r.Name,
                            CreatedDate
                    from loan__Other_Transaction__c
                    where loan__Txn_Date__c>=:startDate and loan__Txn_Date__c<=:systemDate and
                    loan__Loan_Account__c IN :loanIds
                    order by loan__Txn_Date__c,CreatedDate asc];

            System.debug('loan__Other_Transaction__c: ' + othTxns.size());

            Decimal refundAmount  = 0;
            Decimal principalSub = 0;
            for(loan__Other_Transaction__c oth : othTxns){
                
                Decimal txnAmount = oth.loan__Txn_Amt__c != null ?
                                                oth.loan__Txn_Amt__c : 0;
                if(oth.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_REFUND)){
                    if(txnAmount != 0){
                        //refundAmount += txnAmount;
                        refundAmount = txnAmount;
                        //DisHonour Payment..
                        
                        if(refundAmount > 0){
                            //Credit
                            strGLCodeCredit = getGLCodeKey(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Credit:REFUNDTRANSACTIONAMOUNT');                    
                            details.LACCNBR = getGLCode(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Credit:REFUNDTRANSACTIONAMOUNT');                    
                            details.LAMOUNT1 = String.ValueOf(refundAmount);
                            details.LNARR1 = Label.REFUND;
                            details.LNARR2 = 'Refund';
                            details.LGSTRATECODE = 'NA';
                            updateMapGLAccount(strGLCodeCredit, details);
                            //Debit
                            strGLCodeDebit = getGLCodeKey(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Debit:REFUNDTRANSACTIONAMOUNT');                    
                            details1.LACCNBR = getGLCode(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Debit:REFUNDTRANSACTIONAMOUNT');                    
                            details1.LAMOUNT1 = String.ValueOf(-1 * refundAmount);
                            details1.LNARR1 = Label.REFUND;
                            details1.LNARR2 = 'Collections Receipt';
                            details1.LGSTRATECODE = 'NA';
                            updateMapGLAccount(strGLCodeDebit, details1);    
                        }
                    }
                }else if(oth.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB)){
                    if(txnAmount != 0){
                        //principalSub += txnAmount;
                        principalSub = txnAmount;
                        //DisHonour Payment..
                        
                        if(principalSub > 0){
                            //Credit
                            strGLCodeCredit = getGLCodeKey(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Credit:PRINCIPALSUBTRACTIONAMOUNT');                    
                            details.LACCNBR = getGLCode(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Credit:PRINCIPALSUBTRACTIONAMOUNT');                    
                            details.LAMOUNT1 = String.ValueOf(principalSub);
                            details.LNARR1 = Label.PRINCIPAL_ADJUSTMENT;
                            details.LNARR2 = 'Principal Adjustment';
                            details.LGSTRATECODE = 'NA';
                            updateMapGLAccount(strGLCodeCredit, details);
                            //Debit
                            strGLCodeDebit = getGLCodeKey(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Debit:PRINCIPALSUBTRACTIONAMOUNT');                    
                            details1.LACCNBR = getGLCode(oth.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    oth.loan__Loan_Account__r.Channel__c, 'Debit:PRINCIPALSUBTRACTIONAMOUNT');                    
                            details1.LAMOUNT1 = String.ValueOf(-1 * principalSub);
                            details1.LNARR1 = Label.PRINCIPAL_ADJUSTMENT;
                            details1.LNARR2 = 'Principal Adjustment';
                            details1.LGSTRATECODE = 'NA';
                            updateMapGLAccount(strGLCodeDebit, details1);                            
                        }                        
                    }
                }                
            }    
            
            ldxdList = [Select id,name,loan__Distribution_Amount__c,loan__Distribution_Type__c,
                            loan__Loan_Disbursal_Transaction__r.loan__Disbursal_Date__c,
                            loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.Name,
                            loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                            loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.Channel__c
                            from loan__Disbursal_Txn_Distribution__c
                            where loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__c IN :loanIds AND
                            loan__Loan_Disbursal_Transaction__r.loan__Disbursal_Date__c >= :startDate AND
                            loan__Loan_Disbursal_Transaction__r.loan__Disbursal_Date__c <= :systemDate AND
                            loan__Loan_Disbursal_Transaction__r.loan__Cleared__c = True AND
                            loan__Loan_Disbursal_Transaction__r.loan__Rejected__c = False];
            
            Decimal appFee = 0;
            Decimal disbAmount = 0;
            System.debug('MAP Status1 : ' + mapGLCodeToReport);
            for(loan__Disbursal_Txn_Distribution__c ldxd : ldxdList){
                Decimal distributionAmount = ldxd.loan__Distribution_Amount__c != null ? 
                                                ldxd.loan__Distribution_Amount__c : 0; 
                
                if(distributionAmount != 0){
                    
                    if(ldxd.loan__Distribution_type__c.equalsIgnoreCase(loan.LoanConstants.DISBURSAL_DISTRIBUTION_TYPE_PRE_PAID_FEE )){
                        //appFee += ldxd.loan__Distribution_Amount__c;
                        appFee = ldxd.loan__Distribution_Amount__c;
                        //Application Fees entry..
                        if(appFee > 0){
                            //Credit
                            strGLCodeDebit = getGLCodeKey(ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.Channel__c, 'Debit:APPLICATIONFEEAMOUNT');
                            details.LACCNBR = getGLCode(ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.Channel__c, 'Debit:APPLICATIONFEEAMOUNT');
                            details.LAMOUNT1 = String.ValueOf(-1 * appFee);
                            details.LNARR1 = Label.APP_FEE;
                            details.LNARR2 = 'Application Fees';
                            details.LGSTRATECODE = 'I';
                            updateMapGLAccount(strGLCodeDebit, details);    
                        }
                    }else if(ldxd.loan__Distribution_type__c.equalsIgnoreCase(loan.LoanConstants.DISBURSAL_DISTRIBUTION_TYPE_DISBURSEMENT )
                            || ldxd.loan__Distribution_type__c.equalsIgnoreCase(loan.LoanConstants.DISBURSAL_DISTRIBUTION_TYPE_REFINANCE )){
                        //disbAmount +=  ldxd.loan__Distribution_Amount__c;
                        disbAmount =  ldxd.loan__Distribution_Amount__c;
                        //Capital Account Disbursement entry...                  
                        System.debug('DISB DEBIT 1: '+ disbAmount);
                        if(disbAmount > 0){
                            //Credit
                            strGLCodeDebit = getGLCodeKey(ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.Channel__c, 'Debit:DISBURSMENTTRANSACTIONAMOUNT');                    
                            
                            details.LACCNBR = getGLCode(ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    ldxd.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__r.Channel__c, 'Debit:DISBURSMENTTRANSACTIONAMOUNT');                    
                            details.LAMOUNT1 = String.ValueOf(-1 * disbAmount);
                            details.LNARR1 = Label.DISB_AMOUNT;
                            details.LNARR2 = 'Capital Account Disbursement';
                            details.LGSTRATECODE = 'NA';
                            updateMapGLAccount(strGLCodeDebit, details);
                            System.debug('MAP Status2 : ' + mapGLCodeToReport);                
                        }                        
                    }
                }
            }
            
            ldtList = [Select id,name,loan__Disbursed_Amt__c, loan__Disbursal_Date__c,loan__Loan_Account__r.Name,
                        loan__Loan_Account__r.loan__Loan_Product_Name__c,
                        loan__Loan_Account__r.Channel__c
                            from loan__Loan_Disbursal_Transaction__c
                            where loan__Loan_Account__c IN :loanIds AND
                        loan__Disbursal_Date__c >= :startDate AND loan__Disbursal_Date__c <= :systemDate AND
                        loan__Cleared__c = True AND
                        loan__Rejected__c = False];
            
            system.debug('loan__Loan_Disbursal_Transaction__c: ' + ldtList.size());
            Decimal totalDisbAmount = 0;     
            for(loan__Loan_Disbursal_Transaction__c ldt : ldtList){
                
                //Date entryDate = ldt.loan__Disbursal_Date__c;
                Decimal disbursedAmount = ldt.loan__Disbursed_Amt__c != null ? 
                                            ldt.loan__Disbursed_Amt__c : 0;
                
                if(disbursedAmount != 0){
                    //totalDisbAmount += disbursedAmount;
                    totalDisbAmount = disbursedAmount;
                    //Loan Origination Entry...    
                    if(totalDisbAmount > 0){
                        //Credit
                        strGLCodeCredit = getGLCodeKey(ldt.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    ldt.loan__Loan_Account__r.Channel__c, 'Credit:TOTALDISBURSMENTAMOUNT');                    
                        details.LACCNBR = getGLCode(ldt.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    ldt.loan__Loan_Account__r.Channel__c, 'Credit:TOTALDISBURSMENTAMOUNT');                    
                        details.LAMOUNT1 = String.ValueOf(totalDisbAmount);
                        details.LNARR1 = Label.TOTAL_DISBURSEMENT;
                        details.LNARR2 = 'Loan Origination';
                        details.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeCredit, details);                       
                    }                    
                }
            }
            
            iptList = [Select id,name,loan__Interest_Posted__c,loan__Interest_Paid__c,loan__Interest_UnPaid__c,
                        loan__Loan_Contract__r.Name,loan__Transaction_Creation_Date__c,
                        loan__Loan_Contract__r.loan__Loan_Product_Name__c,
                        loan__Loan_Contract__r.Channel__c
                        from loan__Interest_Posting_Transaction__c
                        where loan__Loan_Contract__c IN :loanIds AND
                        loan__Transaction_Creation_Date__c >= :startDate AND loan__Transaction_Creation_Date__c <=:systemDate];
            System.debug('loan__Interest_Posting_Transaction__c:'+ iptList.size());
            Decimal totalInterestPosted = 0;           
            for(loan__Interest_Posting_Transaction__c ipt : iptList){
                
                //Date entryDate = ipt.loan__Transaction_Creation_Date__c;
                Decimal interestPosted = ipt.loan__Interest_Posted__c != null ? 
                                            ipt.loan__Interest_Posted__c : 0;
                
                if(interestPosted != 0){
                    //totalInterestPosted += interestPosted;
                    totalInterestPosted = interestPosted;
                    //Interest Charged Entry...
                    
                    if(totalInterestPosted > 0){
                        //Credit
                        strGLCodeDebit = getGLCodeKey(ipt.loan__Loan_Contract__r.loan__Loan_Product_Name__c,
                                                    ipt.loan__Loan_Contract__r.Channel__c, 'Debit:INTERESTCHARGEDAMOUNT');                    
                        details.LACCNBR = getGLCode(ipt.loan__Loan_Contract__r.loan__Loan_Product_Name__c,
                                                    ipt.loan__Loan_Contract__r.Channel__c, 'Debit:INTERESTCHARGEDAMOUNT');                    
                        details.LAMOUNT1 = String.ValueOf(-1 * totalInterestPosted);
                        details.LNARR1 = LABEL.INTEREST_CHARGED;
                        details.LNARR2 = 'Interest Charged';
                        details.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeDebit, details);
                        //Debit
                        strGLCodeCredit = getGLCodeKey(ipt.loan__Loan_Contract__r.loan__Loan_Product_Name__c,
                                                    ipt.loan__Loan_Contract__r.Channel__c, 'Credit:INTERESTCHARGEDAMOUNT');                    
                        details1.LACCNBR = getGLCode(ipt.loan__Loan_Contract__r.loan__Loan_Product_Name__c,
                                                    ipt.loan__Loan_Contract__r.Channel__c, 'Credit:INTERESTCHARGEDAMOUNT');                    
                        details1.LAMOUNT1 = String.ValueOf(totalInterestPosted);
                        details1.LNARR1 = LABEL.INTEREST_CHARGED;
                        details1.LNARR2 = 'Interest Capitalise';
                        details1.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeCredit, details1);    
                    }
                }
            } 
            
            chargeList = [select id,name,loan__Total_Due_Amount__c,loan__Date__c,loan__Loan_Account__r.Name,loan__Original_Amount__c,
                                 loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                 loan__Loan_Account__r.Channel__c
                                from loan__Charge__c
                                where loan__Loan_Account__c IN :loanIds AND
                                loan__Date__c >= :startDate AND loan__Date__c <= :systemDate];
            System.debug('loan__Charge__c:' + chargeList.size());
            Decimal totalCharge = 0;
            for(loan__Charge__c charge : chargeList){
                
                //Date entryDate = charge.loan__Date__c;
                Decimal chargeAmount = charge.loan__Original_Amount__c != null ? 
                                            charge.loan__Original_Amount__c : 0;
                
                if(chargeAmount != 0){
                    //Fees Charged Entry...
                    //totalCharge += chargeAmount;
                    totalCharge = chargeAmount;
                    
                    if(totalCharge > 0){
                        //Credit
                        strGLCodeDebit = getGLCodeKey(charge.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    charge.loan__Loan_Account__r.Channel__c, 'Debit:CHARGEAMOUNT');                    
                        details.LACCNBR = getGLCode(charge.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    charge.loan__Loan_Account__r.Channel__c, 'Debit:CHARGEAMOUNT');                    
                        details.LAMOUNT1 = String.ValueOf(-1 * totalCharge);
                        details.LNARR1 = Label.CHARGE;
                        details.LNARR2 = 'Fees Charged';
                        details.LGSTRATECODE = 'I';
                        updateMapGLAccount(strGLCodeDebit, details);
                        //Debit
                        strGLCodeCredit = getGLCodeKey(charge.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    charge.loan__Loan_Account__r.Channel__c, 'Credit:CHARGEAMOUNT');                    
                        details1.LACCNBR = getGLCode(charge.loan__Loan_Account__r.loan__Loan_Product_Name__c,
                                                    charge.loan__Loan_Account__r.Channel__c, 'Credit:CHARGEAMOUNT');                    
                        details1.LAMOUNT1 = String.ValueOf(totalCharge);
                        details1.LNARR1 = Label.CHARGE;
                        details1.LNARR2 = 'Loan Receivable Charges';
                        details1.LGSTRATECODE = 'NA';
                        updateMapGLAccount(strGLCodeCredit, details1);     
                    }
                }                
            }
            
            // Broker disbursements
            system.debug(systemDate.addDays(1));
            system.debug(startDate);
            Btxns = [select id,Commission_Amount_Including_GST__c,loan__Transaction_Date__c,
                            loan__Broker__r.loan__Lending_Account__r.loan__Loan_Product_Name__c,
                            loan__Broker__r.loan__Lending_Account__r.Channel__c
                     from loan__Broker_Transactions__c 
                     where loan__Broker__r.loan__Lending_Account__c In:loanIds 
                     and loan__Sent_To_Ach_on__c>=:startDate 
                     and loan__Sent_to_Ach_On__c<=:systemDate.addDays(1)];
            System.debug('loan__Broker_Transactions__c : ' + Btxns.size());
            Decimal combinedCommAmount = 0;
            for(loan__Broker_transactions__c bTxn:bTxns){
                //combinedCommAmount += bTxn.Commission_Amount_Including_GST__c;
                combinedCommAmount = bTxn.Commission_Amount_Including_GST__c;
                
                if(combinedCommAmount > 0){
                    //Credit
                    strGLCodeDebit = getGLCodeKey(bTxn.loan__Broker__r.loan__Lending_Account__r.loan__Loan_Product_Name__c,
                                                    bTxn.loan__Broker__r.loan__Lending_Account__r.Channel__c, 'Debit:COMMISSIONAMOUNT');                    
                    details.LACCNBR = getGLCode(bTxn.loan__Broker__r.loan__Lending_Account__r.loan__Loan_Product_Name__c,
                                                    bTxn.loan__Broker__r.loan__Lending_Account__r.Channel__c, 'Debit:COMMISSIONAMOUNT');                    
                    details.LAMOUNT1 = String.ValueOf(-1 * combinedCommAmount);
                    details.LNARR1 = 'PL Commission';
                    details.LNARR2 = 'Commission Disbursement';
                    details.LGSTRATECODE = 'NA';
                    updateMapGLAccount(strGLCodeDebit, details);
                    //Debit
                    strGLCodeCredit = getGLCodeKey(bTxn.loan__Broker__r.loan__Lending_Account__r.loan__Loan_Product_Name__c,
                                                    bTxn.loan__Broker__r.loan__Lending_Account__r.Channel__c, 'Credit:COMMISSIONAMOUNT');                    
                    details1.LACCNBR = getGLCode(bTxn.loan__Broker__r.loan__Lending_Account__r.loan__Loan_Product_Name__c,
                                                    bTxn.loan__Broker__r.loan__Lending_Account__r.Channel__c, 'Credit:COMMISSIONAMOUNT');                    
                    details1.LAMOUNT1 = String.ValueOf(combinedCommAmount);
                    details1.LNARR1 = 'PL Commission';
                    details1.LNARR2 = 'Deferred commissions';
                    details1.LGSTRATECODE = 'C';
                    updateMapGLAccount(strGLCodeCredit, details1);    
                }
            }
                        
            commAmort = [select id,Expense_Amount__c,
                                CL_Contract__r.loan__Loan_Product_Name__c,
                                CL_Contract__r.Channel__c
                         from Commission_Amortisation__c 
                         where Cl_Contract__c in:loanIds 
                         and Date_to__c =:systemDate.addDays(1)];
            System.debug('Commission_Amortisation__c : ' + commAmort.size());
            Decimal combinedAmortAmount = 0;
            for(Commission_Amortisation__c cAmt:commAmort){
                //combinedAmortAmount += cAmt.Expense_Amount__c;
                combinedAmortAmount = cAmt.Expense_Amount__c;
                
                if(combinedAmortAmount > 0){
                    //Credit
                    strGLCodeDebit = getGLCodeKey(cAmt.CL_Contract__r.loan__Loan_Product_Name__c,
                                                    cAmt.CL_Contract__r.Channel__c, 'Debit:COMMISIONAMORTIZATIONAMOUNT');                    
                    details.LACCNBR = getGLCode(cAmt.CL_Contract__r.loan__Loan_Product_Name__c,
                                                    cAmt.CL_Contract__r.Channel__c, 'Debit:COMMISIONAMORTIZATIONAMOUNT');                    
                    details.LAMOUNT1 = String.ValueOf(-1 * combinedAmortAmount);
                    details.LNARR1 = 'PL Commission';
                    details.LNARR2 = 'Commissions expense';
                    details.LGSTRATECODE = 'NA';
                    updateMapGLAccount(strGLCodeDebit, details);
                    //Debit
                    strGLCodeCredit = getGLCodeKey(cAmt.CL_Contract__r.loan__Loan_Product_Name__c,
                                                    cAmt.CL_Contract__r.Channel__c, 'Credit:COMMISIONAMORTIZATIONAMOUNT');                    
                    details1.LACCNBR = getGLCode(cAmt.CL_Contract__r.loan__Loan_Product_Name__c,
                                                    cAmt.CL_Contract__r.Channel__c, 'Credit:COMMISIONAMORTIZATIONAMOUNT');                    
                    details1.LAMOUNT1 = String.ValueOf(combinedAmortAmount);
                    details1.LNARR1 = 'PL Commission';
                    details1.LNARR2 = 'Deferred commissions';
                    details1.LGSTRATECODE = 'NA';
                    updateMapGLAccount(strGLCodeCredit, details1);    
                }
            }       
        }catch(Exception e){
            loan__Batch_Process_Log__c log = new loan__Batch_Process_Log__c();
            log.loan__Message__c = 'GLCSVFileGenerationJob : ' + e.getMessage() + ' : ' + e.getLineNumber() ;
            insert log;
        }
    
        return this.mapGLCodeToReport;
    }
    
    public String getGLCodeKey(String productName, String channel, String amountTypeVal){
        String str = productName + ':';
        if(!'DIRECT'.equalsIgnoreCase(channel) && !'STAFF'.equalsIgnoreCase(channel)){
            //System.debug('Return val for NOTDIR');
            return (str + 'NOT_DIRECT' + ':' + amountTypeVal);
        }
        else if('STAFF'.equalsIgnoreCase(channel)){
            //System.debug('Return val for STAFF');
            return (str + 'DIRECT/STAFF' + ':' + amountTypeVal);
        }
        else{
            if(mapGLAccount.containsKey(str + 'DIRECT' + ':' + amountTypeVal)){
                return (str + 'DIRECT' + ':' + amountTypeVal);
            }
            else{
                return (str + 'DIRECT/STAFF' + ':' + amountTypeVal);
            }       
        }
    }
    
    public String getGLCode(String productName, String channel, String amountTypeVal){
        String str = productName + ':';
        if(!'DIRECT'.equalsIgnoreCase(channel) && !'STAFF'.equalsIgnoreCase(channel)){
            //System.debug('Return val for NOTDIR');
            return mapGLAccount.get(str + 'NOT_DIRECT' + ':' + amountTypeVal).GL_Code__c;
        }
        else if('STAFF'.equalsIgnoreCase(channel)){
            //System.debug('Return val for STAFF');
            return mapGLAccount.get(str + 'DIRECT/STAFF' + ':' + amountTypeVal).GL_Code__c;
        }
        else{
            if(mapGLAccount.containsKey(str + 'DIRECT' + ':' + amountTypeVal)){
                return mapGLAccount.get(str + 'DIRECT' + ':' + amountTypeVal).GL_Code__c;
            }
            else{
                return mapGLAccount.get(str + 'DIRECT/STAFF' + ':' + amountTypeVal).GL_Code__c;
            }       
        }
    }
        
    public void updateMapGLAccount(String strGLCode, FinanceReportCSVFileFormat details){
        if(mapGLCodeToReport.containsKey(strGLCode) && mapGLCodeToReport.get(strGLCode) != null){
            String amountVal = mapGLCodeToReport.get(strGLCode).getAmountValue();
            System.debug('Inside if of updatemap....amountVal : ' + amountVal);
            if(!String.isBlank(amountVal)){
                System.debug('Inside if if of updatemap....Decimal.valueOf(details.getAmountValue()) : ' + Decimal.valueOf(details.getAmountValue()));
                mapGLCodeToReport.get(strGLCode).setAmountValue(Decimal.valueOf(amountVal) + Decimal.valueOf(details.getAmountValue()));
            }
            else{
                System.debug('Inside if else of updatemap....Decimal.valueOf(details.getAmountValue()) : ' + Decimal.valueOf(details.getAmountValue()));
                mapGLCodeToReport.get(strGLCode).setAmountValue(Decimal.valueOf(details.getAmountValue()));                
            }
        }
        else{
            //details.LINEID = String.valueOf(GLCSVFileGenerationJobHandler.counter++);
            Date entryDate = startDate;
            FinanceReportCSVFileFormat detailsNew = new FinanceReportCSVFileFormat('1',
                    'SF' + monthMap.get(entryDate.month()) + String.ValueOf(entryDate.year()).subString(2),
                    String.valueOf(entryDate.month()),
                    String.valueOf(GLCSVFileGenerationJobHandler.counter++),
                    details.LACCNBR,
                    details.LAMOUNT1,
                    details.LNARR1,
                    details.LNARR2,
                    entryDate,
                    details.LGSTRATECODE);
                    
            mapGLCodeToReport.put(strGLCode, detailsNew);            
        }
    }    
}
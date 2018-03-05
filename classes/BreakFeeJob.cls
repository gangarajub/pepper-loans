public class BreakFeeJob  implements Schedulable,Database.Batchable<sobject>,Database.stateful  {

    private Integer batchSize = 500;

    private static String NAME = 'Break Fee Job';


    public BreakFeeJob() {

    }


    public void execute(SchedulableContext sc) {
        BreakFeeJob j = new BreakFeeJob();
        Database.executeBatch(j, 1);
    }

    public Database.queryLocator Start(Database.BatchableContext bc) {
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate  = util.getCurrentSystemDate();
        Date yearStartDate = Date.newInstance(systemDate.year(),01,01);
        Date yearEndDate = Date.newInstance(systemDate.year(),12,31);
        String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_ACTIVE_MATURED + '\'';
        String query = 'select id,name,loan__Fee_Set__c,loan__Last_Disbursal_Date__c,loan__Loan_Product_Name__r.loan__Interest_Rate_Type__c,loan__Reserve_Amount_for_Next_Due__c,on_payment_holiday__c,Payment_Holiday_Setup_Date__c,Default_Bank_Account__c,loan__Due_Day__c,loan__Next_Installment_Date__c,loan__Expected_Repayment_Start_Date__c ,Additional_Monthly_Debit_Amount__c,loan__ACH_Frequency__c,loan__Pmt_Amt_Cur__c,'+
                '(select id,loan__Transaction_Date__c,loan__Loan_Account__c,'+
                'loan__Transaction_Amount__c'+
                ' from loan__Loan_Payment_Transactions__r where loan__Transaction_Date__c>=:yearStartDate and loan__Transaction_Date__c<=:yearEndDate and loan__Cleared__c = true and loan__Reversed__c = false),'+
                '(select id from loan__Charges__r where loan__fee__r.Name=\'Break Cost\' and loan__Date__c>=:yearStartDate and loan__Date__c<=:yearEndDate),'+
                '(select id,loan__Due_Amt__c from loan__Dues_Details__r where loan__Due_Date__c>=:yearStartDate and loan__Due_Date__c<=:yearEndDate)'+
                ' from loan__Loan_Account__c' +
                ' WHERE loan__Loan_Status__c ' +
                'IN (' + allowabledLoanStatuses + ') and loan__invalid_data__c=false and loan__Loan_Product_Name__r.loan__Interest_Rate_Type__c=\'Fixed\'';
        system.debug(query);
        return Database.getQueryLocator(query);
    } // do nothing

    //1)break fee should be applied only on fixed type loans
    //2)It should be applied once a year
    //3)It should be applied if payments are made for more than 3 month payment amount
    //4)It should not be applied if on payment holiday
    public  void Execute(Database.BatchableContext bc, List<sObject> scope) {
        List<loan__Charge__c> charges = new List<loan__Charge__c>();
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Map<Id,loan__Fee_Junction__c> feeJunctionMap = new Map<Id,loan__Fee_Junction__c>();
        Date systemDate  = util.getCurrentSystemDate();

        try {LoanActions act = new LoanActions();
            Decimal allBillsPayment = 0;
            Set<Id> feeSetIds = new Set<Id>();
            for(loan__Loan_Account__c lAcc: (List<loan__Loan_Account__c>) scope){
                if(lAcc.loan__Fee_Set__c!=null){
                    feeSetIds.add(lAcc.loan__Fee_Set__c);
                }
            }
            List<loan__Fee_Junction__c> feeJunctions = [select id,loan__Fee__c,loan__Fee__r.loan__Amount__c,loan__Fee_Set__c from loan__Fee_Junction__c where loan__Fee__r.name='Break Cost' and loan__Fee_Set__c in:feeSetIds];
            if(feeJunctions.size()>0){
                for(loan__Fee_Junction__c feeJunc:feeJunctions){
                    if(feeJunctionMap.get(feeJunc.loan__Fee_Set__c)==null){
                        feeJunctionMap.put(feeJunc.loan__Fee_Set__c,feeJunc);
                    }
                }
            }
            if(feeJunctions.size()>0){
                
               //Code change start here     
            List<loan__Loan_account_Due_Details__c>billsList=new List<loan__Loan_account_Due_Details__c>();
            List<loan__Loan_Payment_Transaction__c>LptList=new List<loan__Loan_Payment_Transaction__c>();
            Map<Id,Decimal>loanAmountMap=new Map<Id,Decimal>();

                
                for(loan__Loan_Account__c lA:(List<loan__Loan_Account__c>)scope){
                    
                    billsList.addall(lA.loan__Dues_Details__r);
               }
            
            
             for(loan__Loan_Account__c lAc:(List<loan__Loan_Account__c>)scope){
                 
                LptList.addall(lAc.loan__Loan_Payment_Transactions__r);
            
               }
           
            for(loan__Loan_Payment_Transaction__c l: LptList){
            
             if(loanAmountMap.containskey(l.loan__Loan_Account__c)){
             loanAmountMap.put(l.loan__Loan_Account__c,loanAmountMap.get(l.loan__Loan_Account__c)+l.loan__Transaction_Amount__c);
             }
             else{
             loanAmountMap.put(l.loan__Loan_Account__c,l.loan__Transaction_Amount__c);
             }
            
            }
            
            peer__Bank_Recon_Configuration__c bankCs=peer__Bank_Recon_Configuration__c.getOrgDefaults();
           
            Decimal cancelDays=bankCs.peer__Loan_Cancellation_Period__c;
            
 
             for(loan__Loan_Account__c lAcc:(List<loan__Loan_Account__c>) scope){
                 
                 allBillsPayment=(3 + billsList.size()) * lAcc.loan__Pmt_Amt_Cur__c;
                     
                    system.debug(''+allBillsPayment);

                    if(!act.inPaymentHoliday(lAcc.Id) && lAcc.loan__charges__r.size()==0){
                    
                        System.debug('My Amounts 2: '+ allBillsPayment);
                        
                         system.debug('All lpt Amt'+loanAmountMap.get(lAcc.Id));
                         
                         Date disbursmentDate=lAcc.loan__Last_Disbursal_Date__c;
                         Date newCancellationDate =disbursmentDate.addDays(Integer.valueof(cancelDays));                         

                        if(loanAmountMap.get(lAcc.Id)>= allBillsPayment && systemDate < newCancellationDate ){
                            //applyCharge
                            if(feeJunctionMap.get(lAcc.loan__Fee_Set__c)!=null){
                                loan__Charge__c chrg = new loan__Charge__c();
                                chrg.loan__Loan_Account__c = lAcc.Id;
                                chrg.loan__Date__c = systemDate;
                                chrg.loan__Fee__c = feeJunctionMap.get(lAcc.loan__Fee_Set__c).loan__Fee__c;
                                chrg.loan__Interest_Bearing__c = false;
                                chrg.loan__original_amount__c = feeJunctionMap.get(lAcc.loan__Fee_Set__c).loan__Fee__r.loan__Amount__c;
                                charges.add(chrg);
                                
                            }
                        }
                    }
                }
            }

            insert charges;


        } catch (Exception e) {
            throw e;
        }
    }

    public void Finish(Database.BatchableContext bc) {

    }

}
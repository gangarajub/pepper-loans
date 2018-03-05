public class GenerateACHSchedule  implements Schedulable,Database.Batchable<sobject>,Database.stateful  {

    private Integer batchSize = 500;

    private static String NAME = 'Generate ACH Schedule';
    public mfiflexUtil.VOLog voLogInstance = mfiflexUtil.VOLog.getInstance('Neon');
   
    public GenerateACHSchedule() {
        
    }
    
   
    public void execute(SchedulableContext sc) {
        GenerateACHSchedule j = new GenerateACHSchedule();
        Database.executeBatch(j, 1);
    }
    
    public Database.queryLocator Start(Database.BatchableContext bc) {
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate  = util.getCurrentSystemDate();
        String type = 'RECURRING';
        String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_ACTIVE_MATURED + '\'';
        String query = 'select id,name,loan__Reserve_Amount_for_Next_Due__c,on_payment_holiday__c,Payment_Holiday_Setup_Date__c,Default_Bank_Account__c,loan__Due_Day__c,loan__Next_Installment_Date__c,loan__Expected_Repayment_Start_Date__c  ,Additional_Monthly_Debit_Amount__c,loan__ACH_Frequency__c,loan__Pmt_Amt_Cur__c,'+
                '(select id,Number_of_Payments__c,'+
                'Repayment_Amount__c,Repayment_Date__c,'+
                'Sequence__c from Automated_Repayment_Schedule__r where is_primary__c=true),'+
                '(select id,loan__Active__c,'+
                'loan__Debit_Date__c,loan__Frequency__c,'+
                'loan__Payment_Mode__c,loan__Amount_Type__c,'+
                'loan__Bank_Account__c,loan__Recurring_ACH_End_Date__c,'+
                'loan__Recurring_ACH_Start_Date__c,loan__Setup_Date__c,'+
                'loan__Transaction_Amount__c,loan__Type__c'+
                ' from loan__Automated_Payment_Setup__r  '+
                ' where loan__Type__c=:type)'+
                ' from loan__Loan_Account__c' +
                ' WHERE loan__Loan_Status__c ' +
                'IN (' + allowabledLoanStatuses + ') and loan__invalid_data__c=false';
        system.debug(query);
        return Database.getQueryLocator(query);
    } // do nothing
    
    public  void Execute(Database.BatchableContext bc, List<sObject> scope) {
        loan__Loan_Account__c loanAccount = (loan__Loan_Account__c)scope[0];
        try {
            Boolean activeAPSPresent;
            String paymentModeId ;
            loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
            Date systemDate = util.getCurrentSystemDate();
            
            Integer numberOfCycles = 1;
            
            List<loan__Automated_Payment_Setup__c> newAps = new List<loan__Automated_Payment_Setup__c>();
            //List<loan__Automated_Payment_Setup__c> ap = [select id,loan__Debit_Date__c from loan__Automated_Payment_Setup__c where loan__Cl_Contract__c=:loanAccount.Id and loan__Type__c='RECURRING' order by loan__Debit_Date__c desc];
            String bankAccId;
            LoanActions act = new LoanActions();
            Boolean onPaymentHoliday = act.inPaymentHoliday(loanAccount.id);
            if(onPaymentHoliday){
                 /*if(loanAccount.loan__Automated_Payment_Setup__r.size()>0){
                    for(loan__Automated_Payment_Setup__c aps: loanAccount.loan__Automated_Payment_Setup__r){
                        if(aps.loan__Active__c == true){
                            aps.loan__Active__c = false;
                        }
                        if(aps.loan__Bank_Account__C !=null){
                            bankAccId = aps.loan__Bank_Account__c;
                        }else{
                            bankAccId = loanAccount.Default_Bank_Account__c;
                        }
                        if(aps.loan__Payment_Mode__c!=null){
                            paymentModeId = aps.loan__Payment_Mode__c;
                        }else{
                            paymentModeId = [select id from loan__Payment_Mode__c where Name='ACH' limit 1].id;
                        }
                        
                    }
                    update loanAccount.loan__Automated_Payment_Setup__r;
                }
                
                if(String.isBlank(bankAccId)){
                    bankAccId = loanAccount.Default_Bank_Account__c;
                }
                
                if(String.isBlank(paymentModeId)){
                    paymentModeId = [select id from loan__Payment_Mode__c where Name='ACH' limit 1].id;
                }
                */
                
                loan__Automated_Payment_Setup__c aps = new loan__Automated_Payment_Setup__c();
                
                for(loan__Automated_Payment_Setup__c apSetup: loanAccount.loan__Automated_Payment_Setup__r){
                    if(apSetup.loan__Active__c == true){
                        aps = apSetup;
                    }
                }
                Decimal newDebitAmount = 0;
                Boolean AmountChanged = false;
                for(Automated_Repayment_Schedule__c ars : loanAccount.Automated_Repayment_Schedule__r){
                    Date startDate;
                    Date monthEndDate = ars.Repayment_Date__c.addMonths((Integer)ars.Number_of_Payments__c);
                    if(systemDate>=ars.Repayment_Date__c && systemDate <= monthEndDate.addDays(-1)){
                        
                        
                        if(systemDate == ars.Repayment_Date__c && ars.Repayment_Amount__c == 0){
                            Decimal holidayAmountforEntireDuration = loanAccount.loan__Pmt_Amt_Cur__c*ars.Number_Of_payments__C;
                            if(holidayAmountforEntireDuration - loanAccount.loan__Reserve_Amount_for_Next_Due__c > 1){
                                ars.Repayment_Amount__c = loanAccount.loan__Pmt_Amt_Cur__c ;
                                amountChanged = true;
                                    system.debug(amountchanged);
                                if(loanAccount.Additional_Monthly_Debit_Amount__c!=null){
                                    ars.Repayment_Amount__c += loanAccount.Additional_Monthly_Debit_Amount__c;
                                    
                                }
                            }
                        }
                        
                        if(aps.loan__Frequency__c.equalsignorecase('Weekly')){
                            Integer numberOfWeeks = 0;
                            if(loanAccount.Payment_Holiday_Setup_Date__c >= ars.Repayment_Date__c){
                                numberOfWeeks = (loanAccount.Payment_Holiday_Setup_Date__c.daysBetween(ars.Repayment_Date__c.addMonths((Integer)ars.Number_of_Payments__c)))/7;
                            }else{
                                numberOfWeeks = (ars.Repayment_Date__c.daysBetween(ars.Repayment_Date__c.addMonths((Integer)ars.Number_of_Payments__c)))/7;
                            }
                            
                            newDebitAmount = ars.Repayment_Amount__c/numberOfWeeks*ars.Number_of_Payments__c;
                            //numberOfCycles = loan.DateUtil.cyclesBetween(loanAccount.loan__Expected_Repayment_Start_Date__c , startDate ,loanAccount.loan__Ach_frequency__c)+1;
                            //startDate = loan.DateUtil.getNextCycleDate(loanAccount.loan__Expected_Repayment_Start_Date__c,numberOfCycles,loanAccount.loan__Ach_frequency__c,null,null,1);
                        }else if(aps.loan__Frequency__c.equalsignorecase('Bi-weekly')){
                            Integer numberOfBiWeeks = 0;
                            if(loanAccount.Payment_Holiday_Setup_Date__c >= ars.Repayment_Date__c){
                                numberOfBiWeeks = (loanAccount.Payment_Holiday_Setup_Date__c.daysBetween(ars.Repayment_Date__c.addMonths((Integer)ars.Number_of_Payments__c)))/14;
                            }else{
                                numberOfBiWeeks = (ars.Repayment_Date__c.daysBetween(ars.Repayment_Date__c.addMonths((Integer)ars.Number_of_Payments__c)))/14;
                            }
                            
                            newDebitAmount = ars.Repayment_Amount__c/numberOfBiWeeks*ars.Number_of_Payments__c;
                            
                            
                            //numberOfCycles = loan.DateUtil.cyclesBetween(loanAccount.loan__Expected_Repayment_Start_Date__c , startDate ,loanAccount.loan__Ach_frequency__c)+1;
                            //startDate = loan.DateUtil.getNextCycleDate(loanAccount.loan__Expected_Repayment_Start_Date__c,numberOfCycles,loanAccount.loan__Ach_frequency__c,null,null,1);
                        }else if(aps.loan__Frequency__c.equalsignorecase('Monthly')){
                            newDebitAmount = ars.Repayment_Amount__c;
                            //numberOfCycles = loan.DateUtil.cyclesBetween(loanAccount.loan__Expected_Repayment_Start_Date__c , startDate ,loanAccount.loan__Ach_frequency__c)+1;
                            //startDate = loan.DateUtil.getNextCycleDate(loanAccount.loan__Expected_Repayment_Start_Date__c,numberOfCycles,loanAccount.loan__Ach_frequency__c,null,null,1);
                        }
                        
                        
                        
                        aps.loan__Transaction_Amount__c=newDebitAmount;
                        
                        
                    }
                    
                }
                update aps;
                if(amountChanged){
                    update loanAccount.Automated_Repayment_Schedule__r;
                }
                
                
            }else{
                
                List<loan__Automated_Payment_Setup__c> apsList = new List<loan__Automated_Payment_Setup__c>();
                Boolean  isActiveAPSPresent = false;
                for(loan__Automated_Payment_Setup__c aps: loanAccount.loan__Automated_Payment_Setup__r){
                    if(aps.loan__Active__c == true ){
                        isActiveAPSPresent = true;
                    }
                    //apsList.add(aps);
                }
                for(loan__Automated_Payment_Setup__c aps: loanAccount.loan__Automated_Payment_Setup__r){
                    if(aps.loan__Recurring_ACH_Start_Date__c>=systemDate && aps.loan__Recurring_ACH_End_Date__c>=systemDate && aps.loan__Active__c == false && !isActiveAPSPresent){
                        aps.loan__Active__c = true;
                    }
                    Boolean  isDebitDateandstartDateSame;
                    if(aps.loan__Recurring_ACH_Start_Date__c == aps.loan__Debit_Date__c){
                        isDebitDateAndStartDateSame = true;
                    }
                    if(aps.loan__Recurring_ACH_Start_Date__c<=systemDate && aps.loan__Recurring_ACH_End_Date__c>=systemDate && aps.loan__Active__c == false && !isActiveAPSPresent && aps.loan__Debit_Date__c!=null && isDebitDateAndStartDateSame){
                        aps.loan__Active__c = true;
                    }
                    if(loanAccount.Additional_Monthly_Debit_Amount__c==null){
                        loanAccount.Additional_Monthly_Debit_Amount__c = 0;
                    }

                    if(aps.loan__Transaction_Amount__c==0){
                        if(aps.loan__Frequency__c.equalsignorecase('Weekly')){
                            aps.loan__Transaction_Amount__c = (loanAccount.Additional_Monthly_Debit_Amount__c+loanAccount.loan__Pmt_Amt_Cur__c)/4;
                        }else if(aps.loan__Frequency__c.equalsignorecase('Bi-weekly')){
                            aps.loan__Transaction_Amount__c = (loanAccount.Additional_Monthly_Debit_Amount__c+loanAccount.loan__Pmt_Amt_Cur__c)/2;
                        }else{
                            aps.loan__Transaction_Amount__c = (loanAccount.Additional_Monthly_Debit_Amount__c+loanAccount.loan__Pmt_Amt_Cur__c);
                        }
                    }
                    apsList.add(aps);
                }
                
                update apsList;
                
            }
            //insert newAPS;
          
        } catch (Exception e) {
            voLogInstance.logError(9001, '[GenerateACHSchedule] Exception : ' + e + ' for loan :' + loanAccount.name +', stacktrace : ' + e.getStackTraceString());
            //throw e;
        }
    }
    
    public void Finish(Database.BatchableContext bc) {
        
        voLogInstance.committodb();
        BreakFeeJob j = new BreakFeeJob();
        Database.executeBatch(j, 10);
    }

}
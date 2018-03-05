public class AutoScheduleGenerator {
    @InvocableMethod
    public static list<boolean> generate(List<Id> applicationIds) {
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate = util.getCurrentSystemDate();
        List<genesis__Applications__c> app = [select id,Name, genesis__Expected_First_Payment_Date__c ,genesis__Expected_Start_date__c,Debit_Amount__c,Automated_Payment_Start_Date__c,Debit_Frequency__c,genesis__Payment_Amount__c from genesis__Applications__c where Id=:applicationIds[0]];
        app[0].genesis__Expected_Start_date__c = systemDate;
        app[0].genesis__Expected_First_Payment_Date__c = systemDate.addMonths(1);
        update app[0];
        genesis.SkuidNewApplication.generateSchedule(applicationIds[0]);
        app = [select id,Name,genesis__Expected_Start_date__c, genesis__Expected_First_Payment_Date__c ,Debit_Amount__c,Automated_Payment_Start_Date__c,Debit_Frequency__c,genesis__Payment_Amount__c from genesis__Applications__c where Id=:applicationIds[0]];
        Decimal debitAmount = 0;
        Decimal paymentAmount = app[0].genesis__Payment_Amount__c;
        if(app[0].debit_frequency__c!=null && app[0].debit_frequency__c.equalsIgnoreCase('WEEKLY')){
            debitAmount = paymentAmount * 12 / 52;
            app[0].Automated_Payment_Start_Date__c = systemDate.addDays(7);
        }else if(app[0].debit_frequency__c!=null && app[0].debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
            
            debitAmount = paymentAmount *12 /26 ;
            app[0].Automated_Payment_Start_Date__c = systemDate.addDays(14);
        }else{
            debitAmount = paymentAmount;
            app[0].Automated_Payment_Start_Date__c = systemDate.addMonths(1);
        }
        
        
        app[0].Debit_Amount__c = debitAmount;
        update app[0];
        List<boolean> retVal = new List<boolean>();
            retVal.add(true);
            return retVal;
            
        
    }
    
}
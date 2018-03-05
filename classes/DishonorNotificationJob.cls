public class DishonorNotificationJob implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable{
    
    
    
    String query='';
    public DishonorNotificationJob(){
        
    }
    
    // Start Method
    public Database.QueryLocator start(Database.BatchableContext BC){
        query = 'select id,name,Dishonor_Notice_Sent__c,Dishonor_Notice_Sent_On__c,loan__Loan_Payment_Transaction__r.id,loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Contact__c from loan__Repayment_Transaction_Adjustment__c where Dishonor_Notice_Sent__c=false and Dishonor_Notice_Sent_On__c=null';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(SchedulableContext sc){
        DishonorNotificationJob j = new DishonorNotificationJob();
        Database.executeBatch(j,1);
    }
    
    // Execute Logic
    public void execute(Database.BatchableContext con, List<loan__Repayment_Transaction_Adjustment__c>scope){
        loan.GlobalLoanUtilFacade fc = new loan.GlobalLoanUtilFacade();
        Date systemDate = fc.getCurrentSystemDate();
        PepperEmailTemplates__c pepCustomTemplate = PepperEmailTemplates__c.getInstance();
        String statement = pepCustomTemplate.Dishonor_Notice__c;
        List<loan__Repayment_Transaction_Adjustment__c> lisOfDishonors = new list<loan__Repayment_Transaction_Adjustment__c>();
        for(loan__Repayment_Transaction_Adjustment__c d : scope){
            
            Contact c =  [select id from contact where id=:d.loan__Loan_Payment_Transaction__r.loan__Loan_Account__r.loan__Contact__c];
             if(!test.isRunningtest()){
                 EmailUtil.sendEmailByTemplate(c,String.valueOf(d.loan__Loan_Payment_Transaction__r.id),statement);
             }
             
            
            d.Dishonor_Notice_Sent__c = true;
            d.Dishonor_Notice_Sent_On__c = systemDate;
        }
        
        update scope;     
        
    }
    
    public void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}
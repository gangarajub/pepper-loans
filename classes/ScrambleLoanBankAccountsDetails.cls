global class ScrambleLoanBankAccountsDetails implements Database.Batchable<sObject>,DataBase.stateful{
  
   global integer count = 404;
    
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      string query ='Select id , Account_Holder_Name__c, loan_Bank_Account_Name__c, loan__Bank_Account_Number__c, Bank_Account_Number__c, BSB__c, loan__Routing_Number__c from loan__Bank_Account__c ';
       
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){

       
       List<loan__Bank_Account__c> loanBankAccountsToUpdate = new List<loan__Bank_Account__c>();
       
       for(Sobject s : scope){
           
           loan__Bank_Account__c p =(loan__Bank_Account__c)s;

           p.Account_Holder_Name__c= p.Account_Holder_Name__c!=null?p.Account_Holder_Name__c.substring(0,1)+'xxxx'+count:p.Account_Holder_Name__c;

           p.loan_Bank_Account_Name__c= p.loan_Bank_Account_Name__c!=null?p.loan_Bank_Account_Name__c.substring(0,1)+'xxxx'+count:p.loan_Bank_Account_Name__c;
           
           p.loan__Bank_Account_Number__c= p.loan__Bank_Account_Number__c!=null?p.loan__Bank_Account_Number__c.substring(0,1)+'0000':p.loan__Bank_Account_Number__c;

           p.Bank_Account_Number__c= p.Bank_Account_Number__c!=null?p.Bank_Account_Number__c.substring(0,1)+'0000':p.Bank_Account_Number__c;
           
           p.BSB__c = p.BSB__c!=null ? p.BSB__c.substring(0,1)+'00000' : p.BSB__c;

           p.loan__Routing_Number__c = p.loan__Routing_Number__c != null ? p.loan__Routing_Number__c.substring(0, 1)+ '00000' : p.loan__Routing_Number__c;
           
           
           loanBankAccountsToUpdate.add(p);
           count++;
       }
       
       if(loanBankAccountsToUpdate != null && loanBankAccountsToUpdate.size()>0){
           update loanBankAccountsToUpdate;
       }
       
   }

   global void finish(Database.BatchableContext BC){
   
  }

}
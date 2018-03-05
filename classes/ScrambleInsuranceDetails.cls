global class ScrambleInsuranceDetails implements Database.Batchable<sObject>,DataBase.stateful{
  
   
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      string query ='Select id , Mobile_Phone__c from Property_Insurance__c ';
       
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
                       
       List<Property_Insurance__c> insuranceToUpdate = new List<Property_Insurance__c>();
       
       string testPhoneNumber = TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c:null;
       
       for(Sobject s : scope){
           
           Property_Insurance__c p =(Property_Insurance__c)s;
           
           if(p.Mobile_Phone__c != null && p.Mobile_Phone__c != ''){
               p.Mobile_Phone__c = testPhoneNumber;
           }
           
           insuranceToUpdate.add(p);
       }
       
       if(insuranceToUpdate != null && insuranceToUpdate.size()>0){
           update insuranceToUpdate;
       }
       
   }

   global void finish(Database.BatchableContext BC){
   
  }

}
global class ScrambleCollectBankAccountsDetails implements Database.Batchable<sObject>,DataBase.stateful{
  
   global integer count = 344;
    
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      string query ='Select id , ScCollection_Account_Name__c, collect__Bank_Account_Number__c, ScCollection_BSB_Code__c, collect__Routing_Number__c from collect__Bank_Account__c ';
       
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){

       
       List<collect__Bank_Account__c> collectBankAccountsToUpdate = new List<collect__Bank_Account__c>();
       
       for(Sobject s : scope){
           
           collect__Bank_Account__c p =(collect__Bank_Account__c)s;

           p.ScCollection_Account_Name__c= p.ScCollection_Account_Name__c!=null?p.ScCollection_Account_Name__c.substring(0,1)+'xxxx'+count:p.ScCollection_Account_Name__c;
           
           if(p.collect__Bank_Account_Number__c != null && p.collect__Bank_Account_Number__c != ''){
               p.collect__Bank_Account_Number__c = p.collect__Bank_Account_Number__c.substring(0,1)+'000000';
           }
           
           if(p.ScCollection_BSB_Code__c != null && p.ScCollection_BSB_Code__c != ''){
               p.ScCollection_BSB_Code__c = p.ScCollection_BSB_Code__c.substring(0,1)+'00000';
           }
           
           if(p.collect__Routing_Number__c != null && p.collect__Routing_Number__c != ''){
               p.collect__Routing_Number__c = p.collect__Routing_Number__c.substring(0,1)+'00000';
           }
           
           collectBankAccountsToUpdate.add(p);
           count++;
       }
       
       if(collectBankAccountsToUpdate != null && collectBankAccountsToUpdate.size()>0){
           update collectBankAccountsToUpdate;
       }
       
   }

   global void finish(Database.BatchableContext BC){
   
  }

}
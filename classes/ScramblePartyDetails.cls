global class ScramblePartyDetails implements Database.Batchable<sObject>,DataBase.stateful{
  
   
   Global Integer count;
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      count=435;
      
      string query ='Select id , pepATP_Name__c, pepATPContactNumber__c from clcommon__Party__c ';
       
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
                       
       List<clcommon__Party__c> partiesToUpdate = new List<clcommon__Party__c>();
       
       string testPhoneNumber = TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c:null;
       
       for(Sobject s : scope){
  
           clcommon__Party__c p =(clcommon__Party__c)s;
           
           if(p.pepATPContactNumber__c != null && p.pepATPContactNumber__c != ''){
               p.pepATPContactNumber__c = testPhoneNumber;
           }

           p.pepATP_Name__c= p.pepATP_Name__c!=null?p.pepATP_Name__c.substring(0,1)+'xxxx'+count:p.pepATP_Name__c;

           partiesToUpdate.add(p);
           count=count+1;
      }
       
       if(partiesToUpdate != null && partiesToUpdate.size()>0){
	       update partiesToUpdate;
       }
       
   }

   global void finish(Database.BatchableContext BC){
   
  }

}
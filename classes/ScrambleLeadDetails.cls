global class ScrambleLeadDetails implements Database.Batchable<sObject>,DataBase.stateful{
  
   
   Global Integer count;
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      count=435;
      
      string query ='Select id , FirstName, LastName, MiddleName, Email, Fax, MobilePhone, Phone, CRM_DOB__c, CRM_Email__c, CRM_Work_Phone__c from Lead ';
       
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
                       
       List<Lead> leadsToUpdate = new List<Lead>();
       
       set<string> emailaddressestoexclude = new set<string>();
       if(ExcludeEmailaddresses__c.getall().keyset() != null && ExcludeEmailaddresses__c.getall().keyset().size()>0){
           for(string str:ExcludeEmailaddresses__c.getall().keyset()){
               emailaddressestoexclude.add(str.tolowercase());
           }
       }                 

       string testEmailAddress = TestContactDetailsForSandboxes__c.getinstance('Test').EmailAddress__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').EmailAddress__c:'test@pepper.com.au';
       string testPhoneNumber = TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c:null;
       
       for(Sobject s : scope){
  
           Lead l =(Lead)s;
           
           if(l.Email != null){
               if(!emailaddressestoexclude.contains(l.Email.tolowercase())){
                   l.Email = testEmailAddress;
               } 
           }

           if(l.CRM_Email__c != null){
               if(!emailaddressestoexclude.contains(l.CRM_Email__c.tolowercase())){
                   l.CRM_Email__c = testEmailAddress;
               } 
           }

    		if(l.MobilePhone != null && l.MobilePhone != ''){
               l.MobilePhone = testPhoneNumber;
           }

           if(l.Fax != null && l.Fax != ''){
               l.Fax = testPhoneNumber;
           }

           if(l.Phone != null && l.Phone != ''){
               l.Phone = testPhoneNumber;
           }
           
           if(l.CRM_Work_Phone__c != null && l.CRM_Work_Phone__c != ''){
               l.CRM_Work_Phone__c = testPhoneNumber;
           }

           l.firstname= l.firstname!=null?l.firstname.substring(0,1)+'xxxx'+count:l.firstname;
           l.MiddleName= l.MiddleName!=null?l.MiddleName.substring(0,1)+'xxxx'+count:l.MiddleName;
           l.lastname= l.lastname!=null?l.lastname.substring(0,1)+'xxxx'+count:l.lastname;

           l.CRM_DOB__c = l.CRM_DOB__c!=null?Date.Today().adddays(-304):l.CRM_DOB__c;

           leadsToUpdate.add(l);
           count=count+1;
      }
       
       if(leadsToUpdate != null && leadsToUpdate.size()>0){
	       update leadsToUpdate;
       }
       
   }

   global void finish(Database.BatchableContext BC){
   
  }

}
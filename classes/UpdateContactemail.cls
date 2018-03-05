//Written by COE to update the Contact's important data  after sandbox refresh.
global class UpdateContactemail implements Database.Batchable<sObject>,DataBase.stateful{
  
   Global Integer count;
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      count=1;
      string query='Select id,email,Birthdate,mobilephone,phone,homephone,firstname,lastname from Contact ';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
                       List<Contact> ContacttoUpdate = new List<Contact>();
                       set<string> emailaddressestoexclude = new set<string>();
                       if(ExcludeEmailaddresses__c.getall().keyset() != null && ExcludeEmailaddresses__c.getall().keyset().size()>0){
                       for(string str:ExcludeEmailaddresses__c.getall().keyset()){
                       emailaddressestoexclude.add(str.tolowercase());
                       }
                    }             
      for(Sobject s : scope){
      Contact a =(Contact)s;
      string currentcontactemail=a.email;
      string homephone=a.homephone;
      string mobilephone=a.mobilephone;
      string phone=a.phone;
      if(a.email != null){
      if(!emailaddressestoexclude.contains(a.email.tolowercase())){
      if(a.email.contains('@')  && UpdatewithpredefinedEmail__c.getinstance('TestEmail').PredefinedEmailcheck__c==False){
      a.email=a.email.replace('@','=');
      a.email=a.email+'@example.com';
      }
      else{
      a.email=UpdatewithpredefinedEmail__c.getinstance('TestEmail').email__c != null?UpdatewithpredefinedEmail__c.getinstance('TestEmail').email__c:'test@example.com';
       }
      }
     }
       if(mobilephone != null){
              if(UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Updatewithpredefinedmobile__c==False){
              a.mobilephone=null;
             }
              else{
              a.mobilephone=UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Mobile__c != null?UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Mobile__c:null;
              }
              
          }
           if(phone != null){
              if(UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Updatewithpredefinedmobile__c==False){
              a.Phone=null;
              }
               else{
               a.Phone=UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').HomePhone__c != null?UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').HomePhone__c:null;
              }
          
          }
          if(homephone != null){
              if(UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Updatewithpredefinedmobile__c==False){
              a.homePhone=null;
              }
               else{
               a.homePhone=UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').HomePhone__c != null?UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').HomePhone__c:null;
              }
          
          }
          if(a.Birthdate != null)
          a.Birthdate=Date.today().addyears(-30);
          if(a.lastname != null){
          a.lastname=!a.lastname.contains('TEST')?a.lastname.substring(0,1)+'TEST'+count:a.lastname;
          }
          if(a.firstname != null){
          a.firstname =!a.firstname.contains('TEST')?a.firstname.substring(0,1)+'TEST'+count:a.firstname;
          }
      ContacttoUpdate.add(a);
      count=count+1;
      }
      if(ContacttoUpdate != null && ContacttoUpdate.size()>0)
      update ContacttoUpdate;      
   }

   global void finish(Database.BatchableContext BC){

   }

}
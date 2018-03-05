//Written by COE to update PersonAccount's and related Application's data address once the sandbox gets refresh
global class UpdatePersonAccountemail implements Database.Batchable<sObject>,DataBase.stateful{
  
   
   Global Integer count;
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      count=1;
      
      string query ='Select id,Personemail,Phone,IsPersonAccount,pepOTP_Email__c,PersonHomePhone,firstname,lastname,PersonBirthdate,Jumio_Last_Name__c,Personmobilephone,Jumio_First_Name__c,Jumio_Date_Of_Birth__c from Account where IsPersonAccount=True ';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
                       List<Account> accountstoUpdate = new List<Account>();
                       set<string> emailaddressestoexclude = new set<string>();
                       if(ExcludeEmailaddresses__c.getall().keyset() != null && ExcludeEmailaddresses__c.getall().keyset().size()>0){
                       for(string str:ExcludeEmailaddresses__c.getall().keyset()){
                       emailaddressestoexclude.add(str.tolowercase());
                       }
                    }                 
      for(Sobject s : scope){
  
          Account a =(Account)s;
          string currentAccountemail=a.Personemail;
          string currentotpEmail=a.pepOTP_Email__c;
          string homephone=a.Personhomephone;
          string mobilephone=a.Personmobilephone;
          string phone=a.Phone;
          
          if(currentAccountemail != null){
              if(!emailaddressestoexclude.contains(currentAccountemail.tolowercase())){
              if(currentAccountemail.contains('@') && UpdatewithpredefinedEmail__c.getinstance('TestEmail').PredefinedEmailcheck__c==False){
                  a.Personemail=a.Personemail.replace('@','=');
                  a.PersonEmail=a.Personemail+'@example.com';
              }
              else{
              a.Personemail=UpdatewithpredefinedEmail__c.getinstance('TestEmail').email__c != null?UpdatewithpredefinedEmail__c.getinstance('TestEmail').email__c:'test@example.com';
              }
             } 
          }
           if(currentotpEmail != null){
                if(!emailaddressestoexclude.contains(currentotpEmail.tolowercase())){
              if(currentotpEmail.contains('@') && UpdatewithpredefinedEmail__c.getinstance('TestEmail').PredefinedEmailcheck__c==False){
                  currentotpEmail=currentotpEmail.replace('@','=');
                  a.pepOTP_Email__c=currentotpEmail+'@example.com';
              }
              else{
              a.pepOTP_Email__c=UpdatewithpredefinedEmail__c.getinstance('TestEmail').email__c != null?UpdatewithpredefinedEmail__c.getinstance('TestEmail').email__c:'test@example.com';
              }
             } 
            }
          
          if(mobilephone != null){
              if(UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Updatewithpredefinedmobile__c==False){
              a.personmobilephone=null;
             }
              else{
              a.Personmobilephone=UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Mobile__c != null?UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Mobile__c:null;
              }
              
          }
           if(homephone != null){
              if(UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').Updatewithpredefinedmobile__c==False){
              a.PersonhomePhone=null;
              }
               else{
               a.PersonhomePhone=UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').HomePhone__c != null?UpdatewithpredefinedMobile__c.getinstance('Mobilecheck').HomePhone__c:null;
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
          
          a.PersonBirthdate=a.Personbirthdate!=null?Date.Today().addyears(-30):a.Personbirthdate;
          a.jumio_date_of_birth__c=a.jumio_date_of_birth__c!=null?Date.Today().addyears(-30):a.jumio_date_of_birth__c;
          a.firstname= a.firstname!=null?a.firstname.substring(0,1)+'TEST'+count:a.firstname;
          a.lastname= a.lastname!=null?a.lastname.substring(0,1)+'TEST'+count:a.lastname;
          a.Jumio_First_Name__c=a.firstname;
          a.Jumio_Last_Name__c=a.Lastname;
          accountstoUpdate.add(a);
          count=count+1;
      }
      update accountstoUpdate;
      List<genesis__Applications__c> applicationsToUpdate = new List<genesis__Applications__c>();     
      List<genesis__Applications__c> genesisiApplications = [Select id,genesis__Account__c,Identification_Number__c from genesis__Applications__c where genesis__Account__c in:accountstoUpdate];
      if(genesisiApplications != null && genesisiApplications.size()>0){
      for(genesis__Applications__c gApp:genesisiApplications){
      genesis__Applications__c gApplication = new genesis__Applications__c(id=gApp.id,Identification_Number__c=null);
      applicationsToUpdate.add(gApplication);
      }
      }
      if(applicationsToUpdate!=null && applicationsToUpdate.size()>0)
      update applicationsToUpdate;    
   }

   global void finish(Database.BatchableContext BC){
   
      UpdateContactemail updateContactEmail = new UpdateContactemail();
      Database.executeBatch(updateContactEmail,200);
  }

}
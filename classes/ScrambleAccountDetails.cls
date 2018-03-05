//Written by COE to update PersonAccount's and related Application's data address once the sandbox gets refresh
global class ScrambleAccountDetails implements Database.Batchable<sObject>,DataBase.stateful{
  
   
   Global Integer count;
   global Database.QueryLocator start(Database.BatchableContext BC){
     
      count=545;
      
      string query ='Select id,firstname, middlename,lastname,PersonBirthdate,Personemail,pepOTP_Email__c,Phone,PersonHomePhone,Personmobilephone,PersonAssistantPhone,PersonOtherPhone,Phone1__c, '+
          'Jumio_Last_Name__c,Jumio_First_Name__c,Jumio_Date_Of_Birth__c, CRM_Mtg_Email__c, ScCollection_Home_Email__pc, '+
          'ScCollection_Next_of_Kin_Email__pc, ScCollection_Power_of_Attorney_Email__pc, ScCollection_Main_Bus_Phone__pc, ScCollection_Next_of_Kin_Home_Phone__pc, ScCollection_Next_of_Kin_Mobile__pc, ScCollection_Next_of_Kin_Name__pc,'+
          'ScCollection_Power_Attorney_Home_Ph_No__pc, ScCollection_Power_Attorney_Mobile_No__pc, ScCollection_Previous_Mobile__pc, ScCollection_Work_Phone__pc from Account where IsPersonAccount = True';
       
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
                       
       List<Account> accountstoUpdate = new List<Account>();
       set<string> emailaddressestoexclude = new set<string>();
       if(ExcludeEmailaddresses__c.getall().keyset() != null && ExcludeEmailaddresses__c.getall().keyset().size()>0){
           for(string str:ExcludeEmailaddresses__c.getall().keyset()){
               emailaddressestoexclude.add(str.tolowercase());
           }
       }                 

       string testEmailAddress = TestContactDetailsForSandboxes__c.getinstance('Test').EmailAddress__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').EmailAddress__c:'test@pepper.com.au';
       string testPhoneNumber = TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c:null;
       
       for(Sobject s : scope){
  
           Account a =(Account)s;
           string currentAccountemail=a.Personemail;
           string currentotpEmail=a.pepOTP_Email__c;
           string homephone=a.Personhomephone;
           string mobilephone=a.Personmobilephone;
           string phone=a.Phone;
           
           
           if(currentAccountemail != null){
               if(!emailaddressestoexclude.contains(currentAccountemail.tolowercase())){
                   a.Personemail=testEmailAddress;
               } 
           }

           if(currentotpEmail != null){
               if(!emailaddressestoexclude.contains(currentotpEmail.tolowercase())){
                   a.pepOTP_Email__c = testEmailAddress;
               } 
           }
           
           if(a.CRM_Mtg_Email__c != null && a.CRM_Mtg_Email__c != ''){
               if(!emailaddressestoexclude.contains(a.CRM_Mtg_Email__c.tolowercase())){
                   a.CRM_Mtg_Email__c = testEmailAddress;
               } 
           }

           if(a.ScCollection_Home_Email__pc != null && a.ScCollection_Home_Email__pc != ''){
               if(!emailaddressestoexclude.contains(a.ScCollection_Home_Email__pc.tolowercase())){
                   a.ScCollection_Home_Email__pc= testEmailAddress;
               } 
           }
           
          
           if(mobilephone != null && mobilephone != ''){
               a.Personmobilephone = testPhoneNumber;
           }

           if(homephone != null && homephone != ''){
               a.PersonhomePhone = testPhoneNumber;
           }

           if(phone != null && phone != ''){
                   a.Phone = testPhoneNumber;
           }
           
           if(a.PersonAssistantPhone != null && a.PersonAssistantPhone != ''){
               a.PersonAssistantPhone = testPhoneNumber;
           }
           
           if(a.PersonOtherPhone != null && a.PersonOtherPhone != ''){
               a.PersonOtherPhone = testPhoneNumber;
           }
           
           if(a.Phone1__c != null && a.Phone1__c != ''){
               a.Phone1__c = testPhoneNumber;
           }

           if(a.ScCollection_Next_of_Kin_Email__pc != null && a.ScCollection_Next_of_Kin_Email__pc != ''){
               if(!emailaddressestoexclude.contains(a.ScCollection_Next_of_Kin_Email__pc.tolowercase())){
                   a.ScCollection_Next_of_Kin_Email__pc= testEmailAddress;
               } 
           }

           if(a.ScCollection_Power_of_Attorney_Email__pc != null && a.ScCollection_Power_of_Attorney_Email__pc != ''){
               if(!emailaddressestoexclude.contains(a.ScCollection_Power_of_Attorney_Email__pc.tolowercase())){
                   a.ScCollection_Power_of_Attorney_Email__pc= testEmailAddress;
               } 
           }

           if(a.ScCollection_Main_Bus_Phone__pc != null && a.ScCollection_Main_Bus_Phone__pc != ''){
               a.ScCollection_Main_Bus_Phone__pc = testPhoneNumber;
           }
           if(a.ScCollection_Next_of_Kin_Home_Phone__pc != null && a.ScCollection_Next_of_Kin_Home_Phone__pc != ''){
               a.ScCollection_Next_of_Kin_Home_Phone__pc = testPhoneNumber;
           }
           if(a.ScCollection_Next_of_Kin_Mobile__pc != null && a.ScCollection_Next_of_Kin_Mobile__pc != ''){
               a.ScCollection_Next_of_Kin_Mobile__pc = testPhoneNumber;
           }

           if(a.ScCollection_Power_Attorney_Home_Ph_No__pc != null && a.ScCollection_Power_Attorney_Home_Ph_No__pc != ''){
               a.ScCollection_Power_Attorney_Home_Ph_No__pc = testPhoneNumber;
           }

           if(a.ScCollection_Power_Attorney_Mobile_No__pc != null && a.ScCollection_Power_Attorney_Mobile_No__pc != ''){
               a.ScCollection_Power_Attorney_Mobile_No__pc = testPhoneNumber;
           }

           if(a.ScCollection_Previous_Mobile__pc != null && a.ScCollection_Previous_Mobile__pc != ''){
               a.ScCollection_Previous_Mobile__pc = testPhoneNumber;
           }

           if(a.ScCollection_Work_Phone__pc != null && a.ScCollection_Work_Phone__pc != ''){
               a.ScCollection_Work_Phone__pc = testPhoneNumber;
           }

           a.ScCollection_Next_of_Kin_Name__pc= a.ScCollection_Next_of_Kin_Name__pc!=null?a.ScCollection_Next_of_Kin_Name__pc.substring(0,1)+'xxxx'+count:a.ScCollection_Next_of_Kin_Name__pc;
           

           a.firstname= a.firstname!=null?a.firstname.substring(0,1)+'xxxx'+count:a.firstname;
           a.lastname= a.lastname!=null?a.lastname.substring(0,1)+'xxxx'+count:a.lastname;
           a.Jumio_First_Name__c=a.firstname;
           a.Jumio_Last_Name__c=a.Lastname;

           a.PersonBirthdate=a.Personbirthdate!=null?Date.Today().adddays(-304):a.Personbirthdate;
           a.jumio_date_of_birth__c=a.jumio_date_of_birth__c!=null?Date.Today().adddays(-304):a.jumio_date_of_birth__c;

           accountstoUpdate.add(a);
           count=count+1;
      }
       
       if(accountstoUpdate != null && accountstoUpdate.size()>0){
	       update accountstoUpdate;
       }
       
       List<genesis__Applications__c> applicationsToUpdate = new List<genesis__Applications__c>();     
       List<genesis__Applications__c> genesisiApplications = [Select id,genesis__Account__c,Identification_Number__c,genesis__Bank_Account_Number__c,genesis__ID_Number__c,genesis__Routing_Number__c from genesis__Applications__c ];

       if(genesisiApplications != null && genesisiApplications.size()>0){
           for(genesis__Applications__c gApp : genesisiApplications){
               genesis__Applications__c gApplication = new genesis__Applications__c(
                   id=gApp.id,
                   genesis__Bank_Account_Number__c = null,
                   genesis__ID_Number__c = null,
                   genesis__Routing_Number__c = null,
                   Identification_Number__c=null);
               
               applicationsToUpdate.add(gApplication);
           }
       }
       
       if(applicationsToUpdate!=null && applicationsToUpdate.size()>0){
           update applicationsToUpdate;    
       }
   }

   global void finish(Database.BatchableContext BC){
   
      ScrambleContactDetails scrambleContacts = new ScrambleContactDetails();
      Database.executeBatch(scrambleContacts,1000);
  }

}
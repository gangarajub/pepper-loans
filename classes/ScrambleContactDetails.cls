//Written by COE to update the Contact's important data  after sandbox refresh.
global class ScrambleContactDetails implements Database.Batchable<sObject>,DataBase.stateful{
  
    Global Integer count;
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        count=358;
        string query='Select id,email,Birthdate,mobilephone,phone,homephone,firstname,lastname, ScCollection_Home_Email__c, ScCollection_Next_of_Kin_Email__c, ScCollection_Power_of_Attorney_Email__c,'+
            'AssistantPhone,OtherPhone,ScCollection_Main_Bus_Phone__c,ScCollection_Mobile_Number_Work__c,ScCollection_Next_of_Kin_Home_Phone__c,ScCollection_Next_of_Kin_Mobile__c,ScCollection_Next_of_Kin_Name__c ,ScCollection_Maiden_Name__c ,'+
            'ScCollection_Power_Attorney_Home_Ph_No__c,ScCollection_Previous_Home_Phone__c,ScCollection_Previous_Mobile__c,ScCollection_Work_Phone__c, ScCollection_Power_Attorney_Mobile_No__c from Contact ';
        
        return Database.getQueryLocator(query);
    }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
                           
       List<Contact> ContacttoUpdate = new List<Contact>();
       set<string> emailaddressestoexclude = new set<string>();
       if(ExcludeEmailaddresses__c.getall().keyset() != null && ExcludeEmailaddresses__c.getall().keyset().size()>0){
           for(string str:ExcludeEmailaddresses__c.getall().keyset()){
               emailaddressestoexclude.add(str.tolowercase());
           }
       }             
       
       String testEmailAddress = TestContactDetailsForSandboxes__c.getinstance('Test').EmailAddress__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').EmailAddress__c:'test@pepper.com.au';
       String testPhoneNumber = TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c != null?TestContactDetailsForSandboxes__c.getinstance('Test').PhoneNumber__c:null;
       
       for(Sobject s : scope){
           Contact a =(Contact)s;
           string currentcontactemail=a.email;
           string homephone=a.homephone;
           string mobilephone=a.mobilephone;
           string phone=a.phone;
           
           if(a.email != null){
               if(!emailaddressestoexclude.contains(a.email.tolowercase())){
                   a.email=testEmailAddress;
               }
           }
           
           if(a.ScCollection_Home_Email__c != null){
               if(!emailaddressestoexclude.contains(a.ScCollection_Home_Email__c.tolowercase())){
                   a.ScCollection_Home_Email__c=testEmailAddress;
               }
           }
           
           if(a.ScCollection_Next_of_Kin_Email__c != null){
               if(!emailaddressestoexclude.contains(a.ScCollection_Next_of_Kin_Email__c.tolowercase())){
                   a.ScCollection_Next_of_Kin_Email__c=testEmailAddress;
               }
           }           
               
           if(a.ScCollection_Power_of_Attorney_Email__c != null){
               if(!emailaddressestoexclude.contains(a.ScCollection_Power_of_Attorney_Email__c.tolowercase())){
                   a.ScCollection_Power_of_Attorney_Email__c=testEmailAddress;
               }
           }           
               
               
           if(a.AssistantPhone != null){
               a.AssistantPhone=testPhoneNumber;
           }
           
           if(a.OtherPhone != null){
               a.OtherPhone=testPhoneNumber;
           }
           
           if(a.ScCollection_Main_Bus_Phone__c != null){
               a.ScCollection_Main_Bus_Phone__c = testPhoneNumber ;
           }
           
           
           if(a.ScCollection_Mobile_Number_Work__c != null){
               a.ScCollection_Mobile_Number_Work__c = testPhoneNumber;
           }
                          
               
           if(a.ScCollection_Next_of_Kin_Home_Phone__c != null){
               a.ScCollection_Next_of_Kin_Home_Phone__c= testPhoneNumber;
           }
                          
           if(a.ScCollection_Next_of_Kin_Mobile__c != null){
               a.ScCollection_Next_of_Kin_Mobile__c= testPhoneNumber;
           }
                          
           if(a.ScCollection_Power_Attorney_Home_Ph_No__c != null){
               a.ScCollection_Power_Attorney_Home_Ph_No__c= testPhoneNumber;
           }
                          
           if(a.ScCollection_Power_Attorney_Mobile_No__c != null){
               a.ScCollection_Power_Attorney_Mobile_No__c= testPhoneNumber;
           }
                          
           if(a.ScCollection_Previous_Home_Phone__c != null){
               a.ScCollection_Previous_Home_Phone__c= testPhoneNumber;
           }
                          
           if(a.ScCollection_Previous_Mobile__c != null){
               a.ScCollection_Previous_Mobile__c= testPhoneNumber;
           }
                          
           if(a.ScCollection_Work_Phone__c != null){
               a.ScCollection_Work_Phone__c= testPhoneNumber;
           }
                          
               
               
           
           if(a.ScCollection_Next_of_Kin_Name__c != null){
               a.ScCollection_Next_of_Kin_Name__c=!a.ScCollection_Next_of_Kin_Name__c.contains('xxxx')?a.ScCollection_Next_of_Kin_Name__c.substring(0,1)+'xxxx'+count:a.ScCollection_Next_of_Kin_Name__c;
           }
            
               
               
                      
           if(a.ScCollection_Maiden_Name__c != null){
               a.ScCollection_Maiden_Name__c=!a.ScCollection_Maiden_Name__c.contains('xxxx')?a.ScCollection_Maiden_Name__c.substring(0,1)+'xxxx'+count:a.ScCollection_Maiden_Name__c;
           }   
           
           if(mobilephone != null){
               a.mobilephone= testPhoneNumber;
           }
           if(phone != null){
               a.Phone= testPhoneNumber;
           }
           
           if(homephone != null){
               a.homePhone= testPhoneNumber;
           }
           
           if(a.Birthdate != null){
               a.Birthdate=Date.today().adddays(-304);
           }
           
           if(a.lastname != null){
               a.lastname=!a.lastname.contains('xxxx')?a.lastname.substring(0,1)+'xxxx'+count:a.lastname;
           }
           
           if(a.firstname != null){
               a.firstname =!a.firstname.contains('xxxx')?a.firstname.substring(0,1)+'xxxx'+count:a.firstname;
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
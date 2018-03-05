// ---------------------------------------------------------------------------------------------------------
// This class is  used to  test PepForgotPassword class. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      10th June 2016           Upendra Kumar         
// ---------------------------------------------------------------------------------------------------------
@isTest
Public Class PepForgotPassword_tracker
{
    
   static testmethod void loaddata()
   {
   pepCmsPage__c objcmspage = pepCommonTrackerController.createPage('Landing page');
   pepCmsSection__c objcmssection = pepCommonTrackerController.createSection(objcmspage );
   pepCmsQuestion__c objcmsquestion = pepCommonTrackerController.createCmsQuestion(objcmspage,objcmssection);
   PepForgotPassword objforgotpass = new PepForgotPassword();
   objforgotpass.loadCmsData();
   objforgotpass.sendPassword();
   objforgotpass.userId='test525@test.com';
   objforgotpass.sendPassword();
   
    Account objAccount1= new Account();
    objAccount1.Name = 'Last';
        insert objAccount1;
    
   
   Contact objContact1 = new Contact(); 
    objContact1.LastName ='test';
    objContact1.accountId = objAccount1.id;
    insert objContact1;
        
   Profile objProfile = [Select id from Profile where name='Custom Customer Community Login user' limit 1];
      User u = new user();
      
    u.LastName = 'Test Code';
    u.Email = 'test@test.com';
    u.Alias = 'Tcode';
    u.Username = objforgotpass.userId;
    u.CommunityNickname = 'test12';
    u.LocaleSidKey = 'en_US';
    u.TimeZoneSidKey = 'GMT';
    u.ProfileID = objProfile.id;
    u.LanguageLocaleKey = 'en_US';
    u.EmailEncodingKey = 'UTF-8'; 
    u.contactid =objContact1.id;
       insert u;
   objforgotpass.sendPassword();
   objforgotpass.userId='test@test.com';
   objforgotpass.sendPassword();
   
   }
}
@isTest public class PepForgotSetPassword_Tracker{

  @isTest static void PepForgotSetPasswordTest(){
  
        String password ='test';
        String confirmPassword ='test';
    
        pepCommonTrackerController obj =new pepCommonTrackerController();
        pepCmsPage__c objPage = pepCommonTrackerController.createPage('Login Screen');
        pepCmsSection__c objSection = new pepCmsSection__c();
        objSection = pepCommonTrackerController.createSection(objPage);
        objSection.pepSectionUniqueName__c ='SectionFour(FSP)';
        System.debug(objSection);        
        pepCmsQuestion__c objQuestion = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objQuestion.pepType__c='Forgot Set Password';
        
        PepForgotSetPassword objForgotSetPassword = new PepForgotSetPassword();
        
        objForgotSetPassword.resetPassword();
        

  }
  
  @isTest static void PepForgotSetPasswordTest1(){
  
        
        
    
        pepCommonTrackerController obj =new pepCommonTrackerController();
        pepCmsPage__c objPage = pepCommonTrackerController.createPage('Login Screen');
        pepCmsSection__c objSection = new pepCmsSection__c();
        objSection = pepCommonTrackerController.createSection(objPage);
        objSection.pepSectionUniqueName__c ='SectionFour(FSP)';
        System.debug(objSection);        
        pepCmsQuestion__c objQuestion = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objQuestion.pepType__c='Forgot Set Password';
        
        PepForgotSetPassword objForgotSetPassword = new PepForgotSetPassword();
        objForgotSetPassword.password='test';
        objForgotSetPassword.confirmPassword='testdddd';
        
        objForgotSetPassword.resetPassword();
        
        

        


  }
  
  
  
  
}
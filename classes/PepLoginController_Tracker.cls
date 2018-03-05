@isTest 
public class PepLoginController_Tracker {
    
    @isTest static void PepLoginController_TrackerTest(){
        pepCommonTrackerController obj =new pepCommonTrackerController();
        pepCmsPage__c objPage = pepCommonTrackerController.createPage('Login Screen');
        pepCmsSection__c objSection = new pepCmsSection__c();
        objSection = pepCommonTrackerController.createSection(objPage);
        objSection.pepSectionUniqueName__c ='SectionThree(LS)';
        System.debug(objSection);
        
        pepCmsQuestion__c objQuestion = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objQuestion.pepType__c='Text';
    Test.StartTest();   
    
           pages_config__c objConfig = new pages_config__c();
           objConfig.Page_Label__c='loginpage';
           objConfig.Name='peploginpage';
           insert objConfig;
           
           pages_config__c objConfig1 = new pages_config__c();
           objConfig1.Page_Label__c='welcomepage';
           objConfig1.Name='pepwelcomepage';
           insert objConfig1;
           
           pages_config__c objConfig3 = new pages_config__c();
           objConfig3.Page_Label__c='forgotpassword';
           objConfig3.Name='pepforgotpassword';
           insert objConfig3;
           
           pages_config__c objConfig4 = new pages_config__c();
           objConfig4.Page_Label__c='Contract';
           objConfig4.Name='pepcontract';
           insert objConfig4;
    
         RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      
         genesis__Applications__c objApplication = new genesis__Applications__c();
         objApplication = genesis.TestHelper.createApplication();
         objApplication.Debit_Frequency__c ='bi-weekly';
         objApplication.Automated_Payment_Start_Date__c=System.Today();
         objApplication.genesis__Payment_Amount__c=2000;
         objApplication.RedirectToContract__c=True;
         update objApplication;
    
         Application__c objApp = new Application__c();
        objApp=pepCommonTrackerController.createApplication();
    
         Pagereference pd=Page.peploginpage;
         Test.setcurrentPagereference(pd);
     
         Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
         pd.setcookies(new cookie[]{Applicationid});
    Test.StopTest();    
         PepLoginController objLoginController = new PepLoginController();
        
        
        String userName ='test';
        String password ='password';
        objLoginController.loginUser();
        
        objLoginController.navigateToForgot();
        PepLoginController.checkCookieAndRedirect();
        
        objApplication.RedirectToContract__c=False;
        PepLoginController.checkCookieAndRedirect();
    }

}
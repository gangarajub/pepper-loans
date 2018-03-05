@isTest(SeeAllData=False) private class PepFinaliseRepayment_Tracker{
    
   @isTest static void PepFinaliseRepaymentTest(){
    pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Finalise Repayment');
     
     //Section Creation
    pepCmsSection__c objSection1 = new pepCmsSection__c();
    objSection1 = pepCommonTrackerController.createSection1(objPage1);
    objSection1.pepSectionUniqueName__c = 'LoanDetailsSection1';
    objSection1.pepSectionStory__c ='test story';
    update objSection1;
     
     
    pepCmsQuestion__c objQuestion1 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);
      
      
    pepCmsAnswer__c objAnswer1 = new pepCmsAnswer__c();
    objAnswer1 = pepCommonTrackerController.createCmsAnswer(objQuestion1);
         
    PepFinaliseRepayment.wrappperQusetion objWrapper = new PepFinaliseRepayment.wrappperQusetion(objQuestion1);   
   test.StartTest();   
   pages_config__c objConfig = new pages_config__c();
   objConfig.Page_Label__c='LoanSetupCreditPolicy';
   objConfig.Name='peploansetupcreditpolicy';
   insert objConfig;
    RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      
    genesis__Applications__c objApplication = new genesis__Applications__c();
    objApplication = genesis.TestHelper.createApplication();
    objApplication.Debit_Frequency__c ='bi-weekly';
    objApplication.Automated_Payment_Start_Date__c=System.Today();
    objApplication.genesis__Payment_Amount__c=2000;
    objApplication.Debit_Amount__c=2000;
    update objApplication;
    
    Application__c objApp = new Application__c();
    objApp=pepCommonTrackerController.createApplication();
    
    Pagereference pd=Page.pepFinaliseRepayment;
    Test.setcurrentPagereference(pd);
    
    Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
    pd.setcookies(new cookie[]{Applicationid});
  test.StopTest();   
    PepFinaliseRepayment objFinalise = new PepFinaliseRepayment();
    objFinalise.checkcookie();
    objFinalise.calculateRepaymentValue();
    objFinalise.saveForLater();
    Application__c objApp1 = new Application__c();
    objApp1=pepCommonTrackerController.createApplication();
    objApp1.Name='pepLoanSetupCreditPolicy';
    objApp1.Navigation_Status__c='LoanSetup-FinaliseRepayment';
    update objApp1;
    objFinalise.redirectToNextPage();
    objFinalise.selectedFrequency='weekly';
    objFinalise.calculateRepaymentValue();
    objFinalise.selectedFrequency='monthly';
    objFinalise.calculateRepaymentValue();
    objFinalise.selectedFrequency='abc';
    objFinalise.calculateRepaymentValue();
    
  
   }
}
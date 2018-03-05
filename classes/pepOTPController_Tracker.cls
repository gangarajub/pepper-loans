@isTest(SeeAllData=False)

private class pepOTPController_Tracker 
{
    @isTest static void pepOTPControllerTest0() 
    {
    
     Pagereference pd=Page.pepFinaliseRepayment;
          Test.setcurrentPagereference(pd);
            pages_config__c pg11 = new pages_config__c(Name='pepfinaliserepayment',Page_Label__c='FinaliseRepayment');
            insert pg11;
            pages_config__c pg1 = new pages_config__c(Name='pepcongratulations',Page_Label__c='Congratulations');
            insert pg1;
            pages_config__c pg = new pages_config__c(Name='pepotp',Page_Label__c='OTP');
            insert pg;
        pepCommonTrackerController obj =new pepCommonTrackerController();
        pepCommonTrackerController.createOTPTemplate();
        Account objAccount = pepCommonTrackerController.createAccount();
        objAccount.OTP__c = 'passwo';
        update objAccount;
        pepOTPController objClass = new pepOTPController(); 
        
        Application__c o = new Application__c();
        o.Name='pepCongratulations';
        o.Navigation_Status__c='LoanSetup-Offer';
        o.RedirectPage__c='pepCongratulations';
        insert o;
        
       test.startTest();
         
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
  
        genesis__Applications__c objApplication = new genesis__Applications__c();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__account__c=objAccount.id;//genesis.TestHelper.createAccount().id;
        objApplication.OTP__c = 'passwo';
        update objApplication;
        
        
        objClass.objApplication=objApplication;
       
       
          Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
          pd.setcookies(new cookie[]{Applicationid});
         test.stopTest();
          objClass.password = 'passwo';
          objClass.GetMyOffer();
          objClass.ResendNow();
          objClass.fetchApplication();
          objClass.checkcookie();
          objClass.errormessage = 'message';
    }
    
}
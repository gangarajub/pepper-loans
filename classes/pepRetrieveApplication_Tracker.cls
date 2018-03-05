@isTest(SeeAllData=False)
private class pepRetrieveApplication_Tracker
{
    static testMethod void pepRetrieveApplicationTestTest0()
    {
     pages_config__c pg1 = new pages_config__c(Name='pepincomepage',Page_Label__c='IncomePage');
            insert pg1;
        pepCommonTrackerController obj =new pepCommonTrackerController();
        Account acc= pepCommonTrackerController.createAccount();
        acc.PersonEmail = 'abc@abc.com';
        acc.PersonMobilePhone = '8924892749';
        update acc;
        
        Loan.TestHelper.createSeedDataForTesting();
        genesis.TestHelper test1 = new genesis.TestHelper();
        test1.createDefaultOrgParameters();
        loan.testhelper.createOffice();
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Ret_Code__c = 'testRe';
        objApplication.pepNavigation_Status__c = 'Income';
        objApplication.genesis__Account__c = acc.id;
        objApplication.genesis__Status__c ='APPROVED' ;
        update objApplication;
        Pagereference pd=Page.pepIncomePage;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        Application__c appSetting = pepCommonTrackerController.createApplication();
        appSetting.Name = 'pepIncomePage';
        appSetting.Navigation_Status__c = 'Income';
        appSetting.RedirectPage__c = 'pepIncomePage';
        update appSetting;
        
       
        
        
        RetrievalApplicationStatus__c retrivApp = pepCommonTrackerController.createRetrievApplication();
       
        RetrievalApplicationStatus__c retrivalApp = pepCommonTrackerController.createRetrievApplication();
        
        
        
        
        pepRetrieveApplication objClass = new pepRetrieveApplication();
        objClass.strRetrieveCode = 'testRe';
        objClass.retrievalError = 'showError';
        objClass.showBlankretrieval = false;
        objClass.flag = false;
        objClass.email = 'abc@abc.com';
        objClass.phone = '9497419913';
        objClass.isdisplayRetrieve = false;
        objClass.isdisplayPersonDetail = false;
        objClass.isRetrieveApp = false;
        objClass.strRetCodeFromOldApp = 'retCodeFrom';
        objClass.errorMsg = 'msgError';
        objClass.retrieveApplication();
        objClass.retrieveEmail = 'abc@abc.com';
        objClass.retrievePhone = '8924892749';
        objClass.inputvalue='email';
        objClass.resendCode();
        objClass.inputvalue='mobile';
        objClass.isError = true;
        objClass.resendCode();
    }
}
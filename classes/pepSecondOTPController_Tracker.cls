@isTest(SeeAllData=False)

private class pepSecondOTPController_Tracker 
{
    
    @isTest static void pepSecondOTPControllerTest0() {
        
        pepCommonTrackerController obj =new pepCommonTrackerController();
        pepCommonTrackerController.createOTPTemplate();
        Account acc = pepCommonTrackerController.createAccount();
        acc.Phone = '1849482948';
        update acc;
       test.startTest(); 
        List<genesis__Applications__c> lstApplication = new List<genesis__Applications__c>();
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__Account__c = acc.id;
        objApplication.OTP__c  = 'passwo';
        objApplication.Ret_Code__c = 'Ret Code';
        update objApplication; 
        lstApplication.add(objApplication);
        
        Pagereference pd=Page.pepReferredPage;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',(objApplication.id),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
       test.stopTest(); 
        pepSecondOTPController objClass = new pepSecondOTPController();
        objClass.errormessage = 'OTP does not match!';
        objClass.objApplication = objApplication;
        objClass.fetchApplication();
        objClass.password = 'passwo';
        objClass.GetMyOffer();
        objClass.ResendNow();
        objClass.lstSobject = lstApplication;
        objClass.fetchAndUpdateApplication(objApplication,lstApplication);
       
       
    }
    @isTest static void pepSecondOTPControllerTest1(){
         pepSecondOTPController objClass1 = new pepSecondOTPController();
         objClass1.boolEnable = false;
         objClass1.GetMyOffer();
    }
}
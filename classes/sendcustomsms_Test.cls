@isTest(SeeAllData=False)
Private class sendcustomsms_Test{
Public testmethod static void method1(){
        Account acc= pepCommonTrackerController.createAccount();
        acc.pepIsDummyAccount__c =  false;
        acc.LastName = 'Sharma';
        acc.Personmobilephone='0414136952';
        acc.PersonEmail='xyz@gmail.com';
        update acc;
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.genesis__Account__c=acc.id;
        update objApplication;
        Pagereference pg =Page.SendCustomSMSPage;
        pg.getparameters().put('applicationid',objApplication.id);
        Test.setcurrentPagereference(pg);
        Test.startTest();
        sendcustomsms sms = new sendcustomsms();
        sms.sendsms();
        sms.text='testing';
        sms.sendsms();
        sendcustomsms.sendemail(String.valueof(objApplication.id));
        sendcustomsms.sendwebservicesms(string.valueof(objApplication.id));
        Test.stopTest();
}

}
@isTest(SeeAllData=False)

private class pepCreditPolicyController_Tracker 
{
    
    @isTest static void pepCreditPolicyControllerTest0() {
    
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        update objApplication;
        
         Application__c o = new Application__c();
        o.Name='pepContract';
        o.Navigation_Status__c='LoanSetup-Contract';
        o.RedirectPage__c='pepContract';
        insert o;
        
        Application__c o1 = new Application__c();
        o1.Name='pepLoanSetupCreditPolicy';
        o1.Navigation_Status__c='LoanSetup-ReadCreditPolicy';
        o1.RedirectPage__c='pepLoanSetupCreditPolicy';
        insert o1;
        
          pages_config__c pg11 = new pages_config__c(Name='pepsession',Page_Label__c='Session');
            insert pg11;

        
        Pagereference pd=Page.pepPaymentSetup;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        Application__c app = new Application__c();
        app = pepCommonTrackerController.createApplication();
        app.Name= 'pepContract';
        app.Navigation_Status__c='LoanSetup-Contract';
        app.RedirectPage__c='pepContract';
        update app;
        
        Application__c app1 = new Application__c();
        app1 = pepCommonTrackerController.createApplication();
        app1.Name= 'pepLoanSetupCreditPolicy';
        app1.Navigation_Status__c='LoanSetup-ReadCreditPolicy';
        app1.RedirectPage__c='pepLoanSetupCreditPolicy';
        update app1;
        
        pepCreditPolicyController objClass = new pepCreditPolicyController();
        objClass.checkcookie();
        objClass.saveForLater();
        objClass.saveAndRedirect();
    }
}
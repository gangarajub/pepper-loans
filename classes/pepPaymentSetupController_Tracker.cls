@isTest(SeeAllData=False)

private class pepPaymentSetupController_Tracker 
{
    
    @isTest static void pepPaymentSetupControllerTest0() {
        
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
        pepCmsPage__c cmsPage = pepCommonTrackerController.createPage('Payment Setup');
        pepCmsSection__c cmsSection =  pepCommonTrackerController.createSection(cmsPage);
        pepCmsQuestion__c cmsQuestion =  pepCommonTrackerController.createCmsQuestion(cmsPage,cmsSection);
        Account acc = pepCommonTrackerController.createAccount();
        Account acc1 = pepCommonTrackerController.createAccount();
        
        clcommon__CL_Purpose__c commonPurpose = new clcommon__CL_Purpose__c();
        commonPurpose.Name = 'a debt consolidation loan';
        commonPurpose.Serial_No__c = 4;
        insert commonPurpose;
        
        pepBank_API_Details__c bankDetail = new pepBank_API_Details__c();
        bankDetail.pepBank_Name__c = 'HDFC';
        insert bankDetail;
       test.startTest(); 
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__Account__c = acc.id;
        objApplication.genesis__CL_Purpose__c = commonPurpose.id ;
        update objApplication;
        
        Pagereference pd=Page.pepPaymentSetup;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
       test.stopTest();
        Application__c app = new Application__c();
        app = pepCommonTrackerController.createApplication();
        app.Name= 'pepDebtConsolidation';
        app.Navigation_Status__c='LoanSetup-DebtConsolidation';
        app.RedirectPage__c='pepDebtConsolidation';
        update app;
        
        Application__c app1 = new Application__c();
        app1 = pepCommonTrackerController.createApplication();
        app1.Name= 'pepPaymentSetup';
        app1.Navigation_Status__c='LoanSetup-PaymentSetup';
        app1.RedirectPage__c='pepPaymentSetup';
        update app1;
        
        Application__c app11 = new Application__c();
        app11 = pepCommonTrackerController.createApplication();
        app11.Name= 'pepFinaliseRepayment';
        app11.Navigation_Status__c='LoanSetup-FinaliseRepayment';
        app11.RedirectPage__c='pepFinaliseRepayment';
        update app11;
        
        pages_config__c pg1 = new pages_config__c(Name='pepdebtconsolidation',Page_Label__c='DebtConsolidation');
            insert pg1;
             pages_config__c pg2 = new pages_config__c(Name='pepfinaliserepayment',Page_Label__c='FinaliseRepayment');
            insert pg2;
        
        List<loan__Bank_Account__c> LstBnkAccount = new List<loan__Bank_Account__c>();
        loan__Bank_Account__c bankAccount = pepCommonTrackerController.createLoanBankAccount(acc.id);
        LstBnkAccount.add(bankAccount);
        List<loan__Bank_Account__c> LstBnkAccount1 = new List<loan__Bank_Account__c>();
        loan__Bank_Account__c bankAccount1 = pepCommonTrackerController.createLoanBankAccount(acc1.id);
        LstBnkAccount1.add(bankAccount1);  
              
        pepPaymentSetupController objClass = new pepPaymentSetupController();
        objClass.getBankAPIDetails();
        objClass.LstBankAccounts = LstBnkAccount;
        objClass.CreateBankAccount();
        objClass.LstBankAccounts = LstBnkAccount1;
        objClass.CreateBankAccount();
        objClass.loadCMSContent();
        objClass.selectedAccount = 'Create New...';
        objClass.RetrieveBankAccountData();
        objClass.strselectedBankName ='test';
        objClass.CreateBankAccount();
        objClass.saveForLater();
        objClass.checkcookie();
        
    }
}
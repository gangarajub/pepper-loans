@isTest(SeeAllData=False)

private class pepUploadFinancialDocController_Tracker 
{
    @isTest static void pepUploadFinancialDocControllerTest0() 
    {
        pepCommonTrackerController obj =new pepCommonTrackerController();
        
        pages_config__c pg1 = new pages_config__c(Name='peppaymentsetup',Page_Label__c='PaymentSetup');
            insert pg1;
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        update objApplication;
        Pagereference pd=Page.pepUploadFinancialDoc;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat = pepCommonTrackerController.createApplicationDocCat();
        appDocCat.Name = 'Bank Statement' ;
        appDocCat.genesis__Application__c = objApplication.Id;
        update appDocCat;
        
        
        
        Application__c app = new Application__c();
        app = pepCommonTrackerController.createApplication();
        app.Name= 'pepUploadFinancialDoc';
        app.Navigation_Status__c='LoanSetup-BankStatements';
        app.RedirectPage__c='pepUploadFinancialDoc';
        update app;
        
        Application__c app1 = new Application__c();
        app1.Name= 'pepPaymentSetup';
        app1.Navigation_Status__c='LoanSetup-PaymentSetup';
        app1.RedirectPage__c='pepPaymentSetup';
        insert app1;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        attach.ContentType = 'image/jpeg';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        
        attach.body=bodyBlob;
        attach.parentId=appDocCat.id;
        insert attach;
        
        pepBank_Statement_Credential__c objBankStatement = new pepBank_Statement_Credential__c();
        objBankStatement.name = 'Credential';
        objBankStatement.pepEndPoint_Url__c = 'https://test.bankstatements.com.au/api/v1';
        objBankStatement.pepX_API_KEY__c = 'BKZYR9ACQMMUVYHVCLEN1B6AUOJLATYRXQO1PIKF'; 
        insert objBankStatement;
        
        pepUploadFinancialDocController objClass = new pepUploadFinancialDocController();
        objClass.attachDoc = attach;
        objClass.uploadFile();
      
        objClass.redirectToNextPage();
        objClass.getCookieData();
        objClass.saveForLater();
        objClass.checkcookie();
        
             
    }
}
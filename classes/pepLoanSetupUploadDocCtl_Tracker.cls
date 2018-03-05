@isTest(SeeAllData=False)

private class pepLoanSetupUploadDocCtl_Tracker 
{
    
    @isTest static void pepLoanSetupDocsCtlTest0() {
        
        Account accObj = pepCommonTrackerController.createAccount();
       test.startTest();
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__Account__c = accObj.id;
        objApplication.pepNavigation_Status__c = 'LoanSetup-PaymentSetup';
        update objApplication;
        
          pages_config__c pg1 = new pages_config__c(Name='pepbankinfodetails',Page_Label__c='bankinfodetails');
          insert pg1;
          
          Application__c application11 =  pepCommonTrackerController.createApplication();
          application11.Name = 'pepbankinfodetails';
          application11.Navigation_Status__c = 'LoanSetup-BankInformation';
          application11.RedirectPage__c = 'pepbankinfodetails';
          update application11;
          
        
        Pagereference pd=Page.pepPaymentSetup;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        test.stopTest();
        genesis__Application_Document_Category__c appDocCat = pepCommonTrackerController.createApplicationDocCat();
        appDocCat.Name = 'Bank Statement';
        appDocCat.genesis__Application__c = objApplication.Id;
        update appDocCat;
        
        //Attachment attach = new Attachment();
        Attachment attach = new Attachment();     
        attach.Name ='Unit Test Attachment';
        attach.ContentType = 'image/jpeg';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId=appDocCat.id;
        insert attach;
        
        
       // loan__Loan_Account__c loanAcc = pepCommonTrackerController.createLoanAccount();
        loan__Bank_Account__c bankAcc =  pepCommonTrackerController.createLoanBankAccount(accObj.id);
        
        Bank_Statement__c bankStatement = new Bank_Statement__c();
        bankStatement.Application__c = objApplication.id;
        bankStatement.Bank_Account__c = bankAcc.Id;
        bankStatement.Default__c = false;
        insert bankStatement;
        
        pages_config__c pageconfig = pepCommonTrackerController.createPagesConfig()[15];
        
        Application__c application =  pepCommonTrackerController.createApplication();
        application.Name = 'pepPaymentSetup';
        application.Navigation_Status__c = 'LoanSetup-PaymentSetup';
        application.RedirectPage__c = 'pepPaymentSetup';
        update application; 
        
        pepLoanSetupUploadedDocsController objClass = new pepLoanSetupUploadedDocsController();
        objClass.attachDoc = attach;
        objClass.IdAttachment = attach.id;
        objClass.uploadFile();
        objClass.redirectToNextPage();
        objClass.redirectToBankStmt();
        objClass.getAllAttachments();
        objClass.checkcookie();
        objClass.deleteAttachment();
        
       Application__c application1 =  pepCommonTrackerController.createApplication();
       application1.Name = 'pepLoanSetupUploadedDocs';
       application1.Navigation_Status__c = 'LoanSetup-BankStatementDocuments';
       application1.RedirectPage__c = 'pepLoanSetupUploadedDocs';
       update application1; 
       pepLoanSetupUploadedDocsController objClass1 = new pepLoanSetupUploadedDocsController();
       objClass1.saveForLater();
    }
    
    @isTest static void pepLoanSetupDocsCtlTest1() {
        
        genesis__Applications__c objApplication1 = new genesis__Applications__c();
       test.startTest(); 
        RetrieveCode__c objRetrieveCode1 = pepCommonTrackerController.createRetrieveCode();
        objApplication1 = genesis.TestHelper.createApplication();
        objApplication1.Debit_Frequency__c ='bi-weekly';
        objApplication1.pepNavigation_Status__c = 'LoanSetup-PaymentSetup';
        update objApplication1;
        
        Pagereference pd1=Page.pepPaymentSetup;
        Test.setcurrentPagereference(pd1);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication1.id)),'-1',null,false);
        pd1.setcookies(new cookie[]{Applicationid});
       test.stopTest(); 
        pepLoanSetupUploadedDocsController objClass2 = new pepLoanSetupUploadedDocsController();
        objClass2.uploadFile();
    }
}
@isTest(SeeAllData=False)

private class pepLoanSetupUpdAnotherImgCtrl_Tracker 
{
    @isTest static void pepLoanSetupUploadAnotherImageControllerTest0() 
    {
         pepCommonTrackerController obj =new pepCommonTrackerController();
         
         Account accObj = pepCommonTrackerController.createAccount();
         accObj.Jumio_Status__c ='Uploaded';
         update accObj;
         
          pages_config__c objConfig = new pages_config__c();
                   objConfig.Page_Label__c='UploadFinancialDoc';
                   objConfig.Name='pepuploadfinancialdoc';
                   insert objConfig;
         
         genesis__Applications__c objApplication = new genesis__Applications__c();
         RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
         objApplication = genesis.TestHelper.createApplication();
         objApplication.Debit_Frequency__c ='bi-weekly';
         objApplication.genesis__Account__c = accObj.id;
         update objApplication;
         Pagereference pd=Page.pepUploadFinancialDoc;
         Test.setcurrentPagereference(pd);
         Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
         pd.setcookies(new cookie[]{Applicationid});
        
         genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
         appDocCat = pepCommonTrackerController.createApplicationDocCat();
         appDocCat.Name = 'Jumio Identification';
         appDocCat.genesis__Application__c = objApplication.Id;
         update appDocCat;
         
         Attachment attach=new Attachment();     
         attach.Name='Unit Test Attachment';
         attach.ContentType = 'image/jpeg';
         Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
         attach.body=bodyBlob;
         attach.parentId=appDocCat.id;
         insert attach;
         
         Application__c app = new Application__c();
         app = pepCommonTrackerController.createApplication();
         app.Name= 'pepUploadFinancialDoc';
         app.Navigation_Status__c='LoanSetup-BankStatements';
         app.RedirectPage__c='pepUploadFinancialDoc';
         update app;
         
         pepLoanSetupUploadAnotherImageController objClass = new pepLoanSetupUploadAnotherImageController();
         objClass.objAttachment = attach;
         objClass.upload();
         objClass.continueToNextPage();
         objClass.checkcookie();
         objClass.deleteAttachment();
    }
}
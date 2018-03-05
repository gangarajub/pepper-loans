@isTest(SeeAllData=False)

private class PepDocumentInboxPagination_Tracker 
{
    
    @isTest static void PepDocumentInboxPaginationTest0() {
    
       test.StartTest();
        pepCommonTrackerController obj =new pepCommonTrackerController();
        Account accObj = pepCommonTrackerController.createAccount();
        
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
      test.stopTest();
        genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat = pepCommonTrackerController.createApplicationDocCat();
        appDocCat.Name = 'Jumio Identification';
        appDocCat.genesis__Application__c = objApplication.Id;
        update appDocCat;
        
        List<Attachment> lstAccWr = new List<Attachment>();
        Attachment attach = new Attachment();     
        attach.Name ='Unit Test Attachment';
        attach.ContentType = 'image/jpeg';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId=appDocCat.id;
        insert attach;
        lstAccWr.add(attach);
        
        Attachment attach1 = new Attachment();     
        attach1.Name ='Unit Test Attachment1';
        attach1.ContentType = 'image/jpeg';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body duplicate');
        attach1.body = bodyBlob1;
        attach1.parentId=accObj.id;
        insert attach1;
        lstAccWr.add(attach1);
        
        PepDocumentInboxPagination objClass = new PepDocumentInboxPagination(lstAccWr);
        objClass.InnerList = lstAccWr;
        objClass.setPageNumber = 2;
        objClass.setPageSize = 1;
        objClass.hasNext();
        objClass.hasPrevious();
        objClass.goToPage(2);
        objClass.next();
        objClass.previous();
    }
    
    @isTest static void PepDocumentInboxPaginationTest1() {
    
       test.StartTest();
        pepCommonTrackerController obj1 =new pepCommonTrackerController();
        Account accObj1 = pepCommonTrackerController.createAccount();
        
        genesis__Applications__c objApplication1 = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode1 = pepCommonTrackerController.createRetrieveCode();
        objApplication1 = genesis.TestHelper.createApplication();
        objApplication1.Debit_Frequency__c ='bi-weekly';
        objApplication1.genesis__Account__c = accObj1.id;
        update objApplication1;
        Pagereference pd1=Page.pepUploadFinancialDoc;
        Test.setcurrentPagereference(pd1);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication1.id)),'-1',null,false);
        pd1.setcookies(new cookie[]{Applicationid});
      test.stopTest();
        genesis__Application_Document_Category__c appDocCat1 = new genesis__Application_Document_Category__c();
        appDocCat1 = pepCommonTrackerController.createApplicationDocCat();
        appDocCat1.Name = 'Jumio Identification';
        appDocCat1.genesis__Application__c = objApplication1.Id;
        update appDocCat1;
        
        List<Attachment> lstAccWr1 = new List<Attachment>();
        Attachment attach1 = new Attachment();     
        attach1.Name ='Unit Test Attachment';
        attach1.ContentType = 'image/jpeg';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach1.body = bodyBlob2;
        attach1.parentId=appDocCat1.id;
        insert attach1;
        lstAccWr1.add(attach1);
       
        PepDocumentInboxPagination objClass1 = new PepDocumentInboxPagination(lstAccWr1);
        objClass1.InnerList = lstAccWr1;
        objClass1.setPageNumber = 2;
        objClass1.setPageSize = 1;
        objClass1.hasNext();
        objClass1.next();
      
    }
}
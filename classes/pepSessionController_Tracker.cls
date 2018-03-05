@isTest(SeeAllData=False)
private class pepSessionController_Tracker 
{
    
     @isTest static void pepSessionControllerTest0() {
           pepCommonTrackerController obj =new pepCommonTrackerController();
        
      test.startTest();  
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        //objApplication.pepNavigation_Status__c='';
        //objApplication.genesis__Account__c = acc.id;
        update objApplication; 
      test.stopTest();   
         
        Drawloop_User_Setting__c  drawloopCustomSetting = new Drawloop_User_Setting__c ();  
        drawloopCustomSetting.Name = 'DDP_User';
        drawloopCustomSetting.Password__c = 'saasforce$6';
        drawloopCustomSetting.Username__c = 'ddp_user@pepper.com';
        insert drawloopCustomSetting;
        
        pages_config__c pg1 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
            insert pg1;
         pages_config__c pg2 = new pages_config__c(Name='pepcontract',Page_Label__c='Contract');
            insert pg2;
        Pagereference pd=Page.pepSession;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
      
        pepSessionController objClass = new pepSessionController();
        objClass.redirect();
     }
     
    @isTest static void pepSessionControllerTest1() {
        
        pepCommonTrackerController obj =new pepCommonTrackerController();
        application__c apc =pepCommonTrackerController.createApplication();
        apc.Name='pepContract';
        apc.Navigation_Status__c='LoanSetup-Contract';
        apc.RedirectPage__c='pepsession';
        update apc;
        Test.startTest();    
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.pepNavigation_Status__c='LoanSetup-Contract';
        objApplication.PepDocusignenvelopeId__c ='abcde';
        //objApplication.genesis__Account__c = acc.id;
        update objApplication; 
     test.stopTest();       
        pages_config__c pg1 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
            insert pg1;
        pages_config__c pg2 = new pages_config__c(Name='pepcontract',Page_Label__c='Contract');
            insert pg2;
        
        Pagereference pd=Page.pepSession;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        Attachment attach = new Attachment();     
        attach.Name ='Application Contract.pdf';
        attach.ContentType = 'pdf';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId=objApplication.id;
        insert attach;
        
        pepSessionController objClass = new pepSessionController();
        objClass.redirect();
        objApplication.pepNavigation_Status__c=null;
        update objApplication;
        objClass.redirect();
    }
    
     @isTest static void pepSessionControllerTest2() {
           pepCommonTrackerController obj =new pepCommonTrackerController();
        
     test.startTest();    
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        //objApplication.genesis__Account__c = acc.id;
        update objApplication; 
        
        pages_config__c pg1 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
            insert pg1;
            
            pages_config__c pg2 = new pages_config__c(Name='pepcontract',Page_Label__c='Contract');
            insert pg2;
            
      test.stopTest();     
        Pagereference pd=Page.pepContract;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
      
        pepSessionController objClass = new pepSessionController();
        objClass.redirect();
     }
     
       @isTest static void pepSessionControllerTest3() {
           pepCommonTrackerController obj =new pepCommonTrackerController();
           
           pages_config__c pg1 = new pages_config__c(Name='pepcontract',Page_Label__c='Contract');
            insert pg1;
        
   test.startTest();     
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        //objApplication.genesis__Account__c = acc.id;
        update objApplication; 
     test.stopTest();  
         
        pepSessionController objClass = new pepSessionController();
        objClass.redirect();
     }
    
}
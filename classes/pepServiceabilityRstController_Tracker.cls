@isTest(SeeAllData=False)

private class pepServiceabilityRstController_Tracker 
{
    
    @isTest static void pepServiceabilityResultsControllerTest0() {
        
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
        pepCmsPage__c cmsPage = pepCommonTrackerController.createPage('Header');
        pepCmsSection__c cmsSection =  pepCommonTrackerController.createSection(cmsPage);
        cmsSection.pepType__c = 'Running Text';
        cmsSection.pepSectionUniqueName__c = 'Decline2';
        update cmsSection;
        cmsPage.pepPageName__c = 'Referred';
        update cmsPage;
        Account acc = pepCommonTrackerController.createAccount();
        test.startTest(); 
        genesis__Applications__c objApplication = new genesis__Applications__c();
        
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__Account__c = acc.id;
        update objApplication; 
        
        pages_config__c pg1 = new pages_config__c(Name='pepreferredpage',Page_Label__c='ReferredPage');
        insert pg1;
        pages_config__c pg2 = new pages_config__c(Name='peplandingpage',Page_Label__c='landingpage');
        insert pg2;
        
       test.stopTest(); 
        Pagereference pd=Page.pepReferredPage;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        pepServiceabilityResultsController objClass = new pepServiceabilityResultsController (sc);
        objClass.createTask();
        objClass.getRedirectToLandingPage();
        PageReference redirectPage = objClass.checkcookie();
        System.assertEquals(null, redirectPage);
    }
    
    @isTest static void pepServiceabilityResultsControllerTest1() {
        
        pepCommonTrackerController obj1 =new pepCommonTrackerController(); 
        pepCmsPage__c cmsPage1 = pepCommonTrackerController.createPage('Header');
        pepCmsSection__c cmsSection1 =  pepCommonTrackerController.createSection(cmsPage1);
        cmsSection1.pepType__c = 'Running Text';
        cmsSection1.pepSectionUniqueName__c = 'ThanksContent';
        cmsSection1.pepSectionBodyRich__c = '{!ACCOUNT_NAME}ErichBody';
        update cmsSection1;
        cmsPage1.pepPageName__c = 'Decline';
        update cmsPage1;
        
        Account acc1= pepCommonTrackerController.createAccount();
        genesis__Applications__c objApplication1 = new genesis__Applications__c();
       test.startTest(); 
        RetrieveCode__c objRetrieveCode1 = pepCommonTrackerController.createRetrieveCode();
       test.stopTest(); 
        objApplication1 = genesis.TestHelper.createApplication();
        objApplication1.genesis__Account__c = acc1.id;
        update objApplication1;
        
        pages_config__c pg1 = new pages_config__c(Name='pepserviceabilitydecline',Page_Label__c='serviceabilitydecline');
        insert pg1;
        
        Pagereference pd1=Page.pepServiceabilityDecline;
        Test.setcurrentPagereference(pd1);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication1.id)),'-1',null,false);
        pd1.setcookies(new cookie[]{Applicationid});
       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(acc1);
        pepServiceabilityResultsController objClass1 = new pepServiceabilityResultsController (sc1);
        System.assertEquals(true, objClass1.strThanksMsz.contains(acc1.firstname));
    }
    
    @isTest static void pepServiceabilityResultsControllerTest2() {
        
        pepCommonTrackerController obj2 =new pepCommonTrackerController(); 
        pepCmsPage__c cmsPage2 = pepCommonTrackerController.createPage('Header');
        pepCmsSection__c cmsSection2 =  pepCommonTrackerController.createSection(cmsPage2);
        cmsSection2.pepType__c = 'Running Text';
        cmsSection2.pepSectionUniqueName__c = 'ThanksContentDecline';
        cmsSection2.pepSectionBodyRich__c = '{!ACCOUNT_NAME}ErichBody1';
        update cmsSection2;
        cmsPage2.pepPageName__c = 'Decline';
        update cmsPage2;
        
        Account acc2= pepCommonTrackerController.createAccount();
        
        genesis__Applications__c objApplication2 = new genesis__Applications__c();
       test.startTest();
        RetrieveCode__c objRetrieveCode2 = pepCommonTrackerController.createRetrieveCode();
        objApplication2 = genesis.TestHelper.createApplication();
        objApplication2.genesis__Account__c = acc2.id;
        update objApplication2;
        
        pages_config__c pg1 = new pages_config__c(Name='pepserviceabilitydecline',Page_Label__c='serviceabilitydecline');
        insert pg1;
        
       test.stopTest(); 
        Pagereference pd2=Page.pepServiceabilityDecline;
        Test.setcurrentPagereference(pd2);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication2.id)),'-1',null,false);
        pd2.setcookies(new cookie[]{Applicationid});
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(acc2);
        pepServiceabilityResultsController objClass2 = new pepServiceabilityResultsController (sc2);
        System.assertEquals(true, objClass2.strThanksMsz.contains(acc2.firstname));
    }
    
}
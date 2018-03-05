@isTest(SeeAllData=False)

private class pepSideBarTemplateController_Tracker 
{
    
    @isTest static void pepSideBarTemplateControllerTest0() {
        
        pepCommonTrackerController obj =new pepCommonTrackerController();
        pepCmsPage__c cmsPage = pepCommonTrackerController.createPage('Header');
        pepCmsSection__c cmsSection =  pepCommonTrackerController.createSection(cmsPage);
        cmsSection.pepHeader__c = 'Test';
        cmsSection.pepSectionUniqueName__c = 'Need help';
        update cmsSection;
        pages_config__c pageConfig = pepCommonTrackerController.createPagesConfig()[13];
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        //objApplication.genesis__Account__c = acc.id;
        update objApplication; 
        
        Pagereference pd=Page.pepLoanSetupUploadedDocs;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        pepSideBarTemplateController objClass = new pepSideBarTemplateController();
    }
    
    @isTest static void pepSideBarTemplateControllerTest1() {
        
        pepCommonTrackerController obj1 =new pepCommonTrackerController();
        pepCmsPage__c cmsPage1 = pepCommonTrackerController.createPage('SideBarTemplate');
        pepCmsSection__c cmsSection1 =  pepCommonTrackerController.createSection(cmsPage1);
        cmsSection1.pepHeader__c = 'Test';
        update cmsSection1;
        pages_config__c pageConfig1 = pepCommonTrackerController.createPagesConfig()[4];
        
        genesis__Applications__c objApplication1 = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode1 = pepCommonTrackerController.createRetrieveCode();
        objApplication1 = genesis.TestHelper.createApplication();
       
        Pagereference pd1=Page.pepcontract;
        Test.setcurrentPagereference(pd1);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication1.id)),'-1',null,false);
        pd1.setcookies(new cookie[]{Applicationid});
        
        pepSideBarTemplateController objClass1 = new pepSideBarTemplateController();
    }
    
    @isTest static void pepSideBarTemplateControllerTest2() {
        
        pepCommonTrackerController obj2 =new pepCommonTrackerController();
        pepCmsPage__c cmsPage2 = pepCommonTrackerController.createPage('Header');
        pepCmsSection__c cmsSection1 =  pepCommonTrackerController.createSection(cmsPage2);
        cmsSection1.pepHeader__c = 'Test';
        cmsSection1.pepSectionUniqueName__c = 'Call';
        update cmsSection1;
        pages_config__c pageConfig2 = pepCommonTrackerController.createPagesConfig()[14];
        
        genesis__Applications__c objApplication2 = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode2 = pepCommonTrackerController.createRetrieveCode();
        objApplication2 = genesis.TestHelper.createApplication();
       
        Pagereference pd2=Page.peploanSetupverifyid;
        Test.setcurrentPagereference(pd2);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication2.id)),'-1',null,false);
        pd2.setcookies(new cookie[]{Applicationid});
        
        pepSideBarTemplateController objClass2 = new pepSideBarTemplateController();
        objClass2.call = 'testCall';
        objClass2.needHelp = 'testNeedHelp';
        objClass2.Step = 1;
    }
    
    @isTest static void pepSideBarTemplateControllerTest3() {
        
        pepCommonTrackerController obj3 =new pepCommonTrackerController();
        pepCmsPage__c cmsPage3 = pepCommonTrackerController.createPage('SideBarTemplate');
        pepCmsSection__c cmsSection3 =  pepCommonTrackerController.createSection(cmsPage3);
        cmsSection3.pepHeader__c = 'Test';
        cmsSection3.pepSectionUniqueName__c = 'Call';
        update cmsSection3;
        pages_config__c pageConfig3 = pepCommonTrackerController.createPagesConfig()[3];
        
        genesis__Applications__c objApplication3 = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode3 = pepCommonTrackerController.createRetrieveCode();
        objApplication3 = genesis.TestHelper.createApplication();
       
        Pagereference pd3=Page.pepCongratulations;
        Test.setcurrentPagereference(pd3);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication3.id)),'-1',null,false);
        pd3.setcookies(new cookie[]{Applicationid});
        
        pepSideBarTemplateController objClass3 = new pepSideBarTemplateController();
        objClass3.call = 'testCall';
        objClass3.needHelp = 'testNeedHelp';
        objClass3.Step = 1;
    }
}
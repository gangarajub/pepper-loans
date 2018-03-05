@isTest(SeeAllData=False)
private class pepOfferScreen_Tracker
{
    @istest static void pepServiceabilityControllerTest0()
    {
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
        pepCmsPage__c cmsPage = pepCommonTrackerController.createPage('Offer Screen');
        pepCmsSection__c cmsSection =  pepCommonTrackerController.createSection(cmsPage);
        cmsSection.pepSectionUniqueName__c  = 'OfferScreen4';
        cmsSection.pepSectionBodyRich__c = 'testBodyRich';
        update cmsSection;
        
        pepCommonTrackerController obj1 =new pepCommonTrackerController(); 
        pepCmsPage__c cmsPage11 = pepCommonTrackerController.createPage('Offer Screen');
        pepCmsSection__c cmsSection11 =  pepCommonTrackerController.createSection(cmsPage);
        cmsSection11.pepSectionUniqueName__c  = 'OfferScreen5';
        cmsSection11.pepSectionBodyRich__c = 'testBodyRich';
        update cmsSection11;
        
        Application__c objCustomsettings = new Application__c();
        objCustomsettings.name ='pepofferscreen';
        objCustomsettings.Navigation_Status__c ='OfferScreen'; 
        insert objCustomsettings;
        
        Application__c objCustomsettings11 = new Application__c();
        objCustomsettings11.name ='pepServiceabilityNegative2';
        objCustomsettings11.Navigation_Status__c ='ServiceabilityNegative2'; 
        insert objCustomsettings11;
        
        Application__c objCustomsettings12 = new Application__c();
        objCustomsettings12.name ='pepOTP';
        objCustomsettings12.Navigation_Status__c ='OTP'; 
        insert objCustomsettings12;
        
        Account acc = pepCommonTrackerController.createAccount();
        clcommon__CL_Product__c clProduct = pepCommonTrackerController.createClProduct();
        clcommon__CL_Purpose__c clPurpose =  pepCommonTrackerController.createClPurpose();
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__Account__c = acc.id;
        objApplication.genesis__CL_Product__c = clProduct.id;
        objApplication.genesis__CL_Purpose__c = clPurpose.id;
        objApplication.genesis__Loan_Amount__c = 200000;
        objApplication.genesis__Interest_Rate__c = 20;
        objApplication.pep_Loan_Type__c = 'fixed';
        objApplication.debit_amount__c = 100000;
        update objApplication; 
        
        Pagereference pd=Page.pepOfferScreen ;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        pages_config__c pageConf = pepCommonTrackerController.createPagesConfig()[19];
        User objUser = pepCommonTrackerController.createuser();
        
        pages_config__c pg = new pages_config__c(Name='pepofferscreen',Page_Label__c='OfferScreen');
        insert pg;
        pages_config__c pg1 = new pages_config__c(Name='pepotp',Page_Label__c='OTP');
        insert pg1;
        pages_config__c pg2 = new pages_config__c(Name='pepserviceabilitynegative2',Page_Label__c='ServiceabilityNegative2');
        insert pg2;
        
        pepCmsModelContainer objModelTest = new pepCmsModelContainer ();
        pepOfferScreen objClass = new pepOfferScreen ();
        objClass.Page_Name = 'pepofferscreen';
        objClass.Page_Label = 'pepofferscreen';
        objClass.RedirectToNegative();
        
        pepOfferScreen objClass1 = new pepOfferScreen ();
        objClass1.Page_Name = 'pepofferscreen';
        objClass1.Page_Label = 'pepofferscreen';
        objClass1.accountId = acc.id;
        objClass1.YesOrNo= 'yes';
        objClass1.RedirectToNegative();
       
      
    }
}
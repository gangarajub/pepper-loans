@isTest(SeeAllData=False)
private class pepServiceabilityController_Tracker
{
    @istest static void pepServiceabilityControllerTest0()
    {
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
        pepCmsPage__c cmsPage = pepCommonTrackerController.createPage('Serviceability');
        pepCmsSection__c cmsSection =  pepCommonTrackerController.createSection(cmsPage);
        cmsSection.pepSectionUniqueName__c  = 'Serviceability Section 2';
        cmsSection.pepSectionBodyRich__c = 'testBodyRich';
        update cmsSection;
        
        Application__c objCustomsettings = new Application__c();
        objCustomsettings.name ='pepPersonalDetails';
        objCustomsettings.Navigation_Status__c ='PersonalDetails'; 
        insert objCustomsettings;
        
        Account acc = pepCommonTrackerController.createAccount();
        clcommon__CL_Product__c clProduct = pepCommonTrackerController.createClProduct();
        clcommon__CL_Purpose__c clPurpose =  pepCommonTrackerController.createClPurpose();
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='BI-WEEKLY';
        objApplication.genesis__Account__c = acc.id;
        objApplication.genesis__CL_Product__c = clProduct.id;
        objApplication.genesis__CL_Purpose__c = clPurpose.id;
        objApplication.genesis__Loan_Amount__c = 200000;
        objApplication.genesis__Interest_Rate__c = 20;
        objApplication.pep_Loan_Type__c = 'fixed';
        objApplication.debit_amount__c = 100000;
        update objApplication; 
        
        Pagereference pd=Page.pepServiceabilityPositve;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        pages_config__c pageConf = pepCommonTrackerController.createPagesConfig()[19];
        User objUser = pepCommonTrackerController.createuser();
        
        pages_config__c pg = new pages_config__c(Name='pepserviceabilitynegative2',Page_Label__c='serviceabilitynegative2');
        insert pg;
        pages_config__c pg1 = new pages_config__c(Name='peppersonaldetails',Page_Label__c='personaldetails');
        insert pg1;
        pages_config__c pg2 = new pages_config__c(Name='peplandingpage',Page_Label__c='landingpage');
        insert pg2;
        pages_config__c pg3 = new pages_config__c(Name='pepserviceabilitypositve',Page_Label__c='serviceabilitypositive');
        insert pg3;
        pages_config__c pg4 = new pages_config__c(Name='pepserviceabilitynegative1',Page_Label__c='serviceabilitynegative1');
        insert pg4;
        Application__c objCustomsettings1 = new Application__c();
        objCustomsettings1.name ='pepServiceabilityPositve';
        objCustomsettings1.Navigation_Status__c ='ServiceabilityPositve'; 
        objCustomsettings1.RedirectPage__c='pepServiceabilityPositve';
        insert objCustomsettings1;
        
        
        ServiceabilityNegativeTask__c ServiceabilityNegativeTask = pepCommonTrackerController.createServiceabilityNegativeTask();
        ServiceabilityNegativeTask.User_Id__c = objUser.id;
        update ServiceabilityNegativeTask;
        
        pepCmsModelContainer objModelTest = new pepCmsModelContainer ();
        
        ApexPages.StandardController controller = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass = new pepServiceabilityController(controller);
        objClass.Page_Name = 'pepServiceabilityPositve';
        objClass.Page_Label = 'pepServiceabilityPositve';
        pepServiceabilityController.strMsz = 'strMszTest';
        objClass.objModel = objModelTest;
        objClass.getRedirect();
        objClass.getRedirectToLandingPage();
        objClass.RedirectToEnd();
        objClass.RedirectToLoanDetail();
        objClass.RedirectToNegative();
        objClass.setParam();
        objClass.accountId = acc.id;
        objClass.strFirstName = 'PapperTest';
        objClass.strThanksMsz = '{name}';
        objClass.createTask();
      //  objClass.checkcookie();
        
        
        pepCmsPage__c cmsPage1 = pepCommonTrackerController.createPage('Serviceability');
        pepCmsSection__c cmsSection1 =  pepCommonTrackerController.createSection(cmsPage1);
        cmsSection1.pepSectionUniqueName__c  = 'Serviceability Section 2a';
        cmsSection1.pepSectionBodyRich__c = 'testBodyRich {!genesis__Applications__c.Debit_Frequency__c}   {!genesis__Applications__c.Requested_Term__c}';
        update cmsSection1;
        ApexPages.StandardController controller1 = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass1 = new pepServiceabilityController(controller1);
        
        System.assertEquals(true, objCLass1.strSectionBody2.contains('fortnightly'));
        System.assertEquals(true, objCLass1.strSectionBody2.contains( string.valueOf(objApplication.genesis__Term__c/12)));
        
        pepCmsPage__c cmsPage2 = pepCommonTrackerController.createPage('Serviceability');
        pepCmsSection__c cmsSection2 =  pepCommonTrackerController.createSection(cmsPage2);
        cmsSection2.pepSectionUniqueName__c  = 'ThanksMsz';
        cmsSection2.pepSectionBodyRich__c = 'testBodyRich';
        update cmsSection2;
        ApexPages.StandardController controller2 = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass2 = new pepServiceabilityController(controller2);
        
        System.assertEquals(objClass2.strThanksMsz, 'testBodyRich');
        
        pepCmsPage__c cmsPage3 = pepCommonTrackerController.createPage('Serviceability');
        pepCmsSection__c cmsSection3 =  pepCommonTrackerController.createSection(cmsPage3);
        cmsSection3.pepSectionUniqueName__c  = 'Serviceabiltylast';
        cmsSection3.pepSectionBodyRich__c = 'testBodyRich  {!genesis__Applications__c.genesis__CL_Purpose__r.Name}';
        update cmsSection3;
        ApexPages.StandardController controller3 = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass3 = new pepServiceabilityController(controller3);
        
        genesis__Applications__c app = [select id, Name, genesis__CL_Purpose__c, genesis__CL_Purpose__r.Name from genesis__Applications__c where id=:objApplication.id];
        System.assertEquals(true, objClass3.strSectionBody3.contains(app.genesis__CL_Purpose__r.Name));
        
        pepCmsPage__c cmsPage4 = pepCommonTrackerController.createPage('Serviceability');
        pepCmsSection__c cmsSection4 =  pepCommonTrackerController.createSection(cmsPage4);
        cmsSection4.pepSectionUniqueName__c  = 'Greeting';
        cmsSection4.pepSectionBodyRich__c = 'testBodyRich';
        cmsSection4.pepHeader__c ='testHeader';
        update cmsSection4;
        ApexPages.StandardController controller4 = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass4 = new pepServiceabilityController(controller4);
        
        System.assertEquals(objClass4.strSectionHeader, cmsSection4.pepHeader__c);
        
        pepCmsPage__c cmsPage5 = pepCommonTrackerController.createPage('Serviceability');
        pepCmsSection__c cmsSection5 =  pepCommonTrackerController.createSection(cmsPage5);
        cmsSection5.pepSectionUniqueName__c  = 'Let See What we can do';
        cmsSection5.pepSectionBodyRich__c = 'testBodyRich';
        cmsSection5.pepHeader__c ='testHeader';
        update cmsSection5;
        ApexPages.StandardController controller5 = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass5 = new pepServiceabilityController(controller5);
        
        System.assertEquals(objClass4.strSectionHeader, cmsSection4.pepHeader__c);
        
        pepCmsPage__c cmsPage6 = pepCommonTrackerController.createPage('Serviceability');
        pepCmsSection__c cmsSection6 =  pepCommonTrackerController.createSection(cmsPage6);
        cmsSection6.pepSectionUniqueName__c  = 'AppNumber';
        cmsSection6.pepSectionBodyRich__c = 'testBodyRich  {!genesis__Applications__c.Name}';
        cmsSection6.pepHeader__c ='testHeader';
        update cmsSection6;
        ApexPages.StandardController controller6 = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass6 = new pepServiceabilityController(controller6);
        System.assertEquals(true, objClass6.strAppNumber.contains(app.Name));
        
        pepCmsPage__c cmsPage7 = pepCommonTrackerController.createPage('Header');
        pepCmsSection__c cmsSection7 =  pepCommonTrackerController.createSection(cmsPage7); 
        ApexPages.StandardController controller7 = new ApexPages.StandardController (acc);
        pepServiceabilityController objClass7 = new pepServiceabilityController(controller7);
        System.assertEquals(false, objClass7.isError);
    }
}
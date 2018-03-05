@isTest(SeeAllData=false) 
private class pepApplyNowController_tracker {
    
    @isTest 
    static void Test0() {
        
        pepCmsPage__c objPage1 =  new pepCmsPage__c();
        objPage1.pepPageName__c='Apply Page';
        insert objPage1;
        
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c='LandingPageSection1';
        objSection1.pepSectionStory__c='loanPurpose';
        update objSection1;
        
        pepCmsQuestion__c objQuestion1 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);
        
        pepCmsQuestion__c objQuestion2 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion2.pepFieldApiName__c='Requested_Loan_Amount__c';
        objQuestion2.pepType__c='Currency';
        update objQuestion2;
        
        pepCmsQuestion__c objQuestion3 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion3.pepFieldApiName__c='Requested_Term__c';
        objQuestion3.pepType__c='Picklist';
        update objQuestion3;
        
        pepCmsQuestion__c objQuestion4 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion4.pepFieldApiName__c='Debit_Frequency__c';
        objQuestion4.pepType__c='Picklist';
        update objQuestion4;
        
        pepCmsQuestion__c objQuestion5 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion5.pepFieldApiName__c='genesis__Credit_Rating__c';
        objQuestion5.pepType__c='Picklist';
        update objQuestion5;
        
        pepCmsQuestion__c objQuestion6 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion6.pepFieldApiName__c='genesis__CL_Product__c';
        objQuestion6.pepType__c='Picklist';
        update objQuestion6;
        
        pepCmsQuestion__c objQuestion7 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion7.pepFieldApiName__c='Existing_Customer__c';
        objQuestion7.pepType__c='Button';
        update objQuestion7;
        
        pepCmsAnswer__c objAnswer1 = new pepCmsAnswer__c();
        objAnswer1 = pepCommonTrackerController.createCmsAnswer(objQuestion1);
        pepCmsAnswer__c objAnswer2 = new pepCmsAnswer__c();
        objAnswer2 = pepCommonTrackerController.createCmsAnswer(objQuestion2);
        pepCmsAnswer__c objAnswer3 = new pepCmsAnswer__c();
        objAnswer3 = pepCommonTrackerController.createCmsAnswer(objQuestion3);
        pepCmsAnswer__c objAnswer4 = new pepCmsAnswer__c();
        objAnswer4 = pepCommonTrackerController.createCmsAnswer(objQuestion4);
        pepCmsAnswer__c objAnswer5 = new pepCmsAnswer__c();
        objAnswer5 = pepCommonTrackerController.createCmsAnswer(objQuestion5);
        pepCmsAnswer__c objAnswer6 = new pepCmsAnswer__c();
        objAnswer6 = pepCommonTrackerController.createCmsAnswer(objQuestion6);
        
        
        clcommon__CL_Purpose__c objClPurpose = new clcommon__CL_Purpose__c();
        objClPurpose.Name='a new car';
        objClPurpose.clcommon__Description__c='A loan for a new car.';
        objClPurpose.Serial_No__c=4;
        insert objClPurpose;
        
        pepDefaultCompany__c  objDefaultCompany = new pepDefaultCompany__c();
        objDefaultCompany = pepCommonTrackerController.createPageDefaultCompany();
        
        Application__c pepApplication =new Application__c();
        pepApplication.Name= 'pepIncomePage';
        pepApplication.Navigation_Status__c='Income';
        pepApplication.RedirectPage__c='pepIncomePage';
        insert pepApplication;
        
        Application__c pepApplication1 =new Application__c();
        pepApplication1.Name= 'pepLoanDetails';
        pepApplication1.Navigation_Status__c='LoanDetails';
        pepApplication1.RedirectPage__c='pepLoanDetails';
        insert pepApplication1;
        
        loan.testhelper.createSeedDataForTesting();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        genesis__Applications__c objApplication= genesis.TestHelper.createApplication();
        
        pages_config__c objPageConfig = new pages_config__c();
        objPageConfig.Page_Label__c='applynow';
        objPageConfig.name='pepapplynow';
        insert objPageConfig;
        
        pages_config__c objPageConfig1 = new pages_config__c();
        objPageConfig1.Page_Label__c='IncomePage';
        objPageConfig1.name='pepincomepage';
        insert objPageConfig1;
        
        pages_config__c objPageConfig2 = new pages_config__c();
        objPageConfig2.Page_Label__c='landingpage';
        objPageConfig2.name='peplandingpage';
        insert objPageConfig2;
        
        pages_config__c objPageConfig3 = new pages_config__c();
        objPageConfig3.Page_Label__c='retrieveapp';
        objPageConfig3.name='pepretrieveapp';
        insert objPageConfig3;
        
        pages_config__c objPageConfig4 = new pages_config__c();
        objPageConfig4.Page_Label__c='loandetails';
        objPageConfig4.name='peploandetails';
        insert objPageConfig4;
        
        PageReference pageRef = Page.pepapplynow;
        Test.setCurrentPagereference(pageRef);
        
        Cookie ApplicationId=new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        
        ApexPages.currentPage().getParameters().put('p1','hello');
        ApexPages.currentPage().getParameters().put('p2','bye');
        ApexPages.currentPage().getParameters().put('p3','hii');
        ApexPages.currentPage().getParameters().put('p4','yooo');
        ApexPages.currentPage().getParameters().put('rowIndex','1');
        ApexPages.currentPage().getParameters().put('text','yooo');
        ApexPages.currentPage().getParameters().put('existingcustomer','yes');
        pepapplynowcontroller controller = new pepapplynowcontroller();
        controller.ContinueApply();
        pageRef.setcookies(new cookie[]{ApplicationId});
        controller.ContinueApply();
        controller.BackOnLandingPage();
        controller.retrieveAppCode();
        controller.applynowQuery();
        controller.loadapplicationfromcookie();
        controller.fetchApplication();
        
        System.assertEquals(controller.objApplication.Id , objApplication.id);
        
        ApexPages.currentPage().getParameters().put('p1',null);
        ApexPages.currentPage().getParameters().put('p2',null);
        ApexPages.currentPage().getParameters().put('p3',null);
        ApexPages.currentPage().getParameters().put('p4',null);
        ApexPages.currentPage().getParameters().put('redirectFromPageNo','1');
        pepapplynowcontroller controller1 = new pepapplynowcontroller();
        System.assertEquals(pepDefaultCompany__c.getInstance('Company Id').pepBusinessAccount__c, controller1.idBusinessAccount);
    }
    
}
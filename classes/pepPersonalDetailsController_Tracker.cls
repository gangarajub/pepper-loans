@isTest(SeeAllData=False)

private class pepPersonalDetailsController_Tracker 
{
    
    @isTest static void pepPersonalDetailsControllerTest0() {
        
        pepCommonTrackerController obj =new pepCommonTrackerController();
        pages_config__c pg1 = new pages_config__c(Name='peppersonaldetails',Page_Label__c='PersonalDetails');
            insert pg1;
            pages_config__c pg11 = new pages_config__c(Name='pepexpensepage',Page_Label__c='ExpensePage');
            insert pg11;
            pages_config__c pg12 = new pages_config__c(Name='pepincomepage',Page_Label__c='IncomePage');
            insert pg12;
            pages_config__c pg13 = new pages_config__c(Name='peploandetails',Page_Label__c='loandetails');
            insert pg13;
            pages_config__c pg14 = new pages_config__c(Name='pepreferredpage',Page_Label__c='ReferredPage');
            insert pg14;
            pages_config__c pg15 = new pages_config__c(Name='pepreferredpage',Page_Label__c='ReferredPage');
            insert pg15;
            pages_config__c pg16 = new pages_config__c(Name='pepserviceabilitydecline',Page_Label__c='serviceabilitydecline');
            insert pg16;
            pages_config__c pg17 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
            insert pg17;
            pages_config__c pg18 = new pages_config__c(Name='pepotp',Page_Label__c='OTP');
            insert pg18;
            
            Application__c app1 = new Application__c(Name='pepOTP', RedirectPage__c='pepOTP', Navigation_Status__c='OTP');
            insert app1;
            
            
            Application__c app2 = new Application__c(Name='pepofferscreen', RedirectPage__c='pepofferscreen', Navigation_Status__c='OfferScreen');
            insert app2;
            pages_config__c pg19 = new pages_config__c(Name='pepofferscreen',Page_Label__c='OfferScreen');
            insert pg19;
        Captcha_Settings__c captchaSetting =  pepCommonTrackerController.createCaptchaSetting();
        Account acc= pepCommonTrackerController.createAccount();
        acc.pepIsDummyAccount__c =  false;
        acc.LastName = 'Sharma';
        update acc;
        
       test.startTest();
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        genesis.TestHelper.createApplication(); 
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__Account__c = acc.id;
        objApplication.Serviceability_Status__c = 'Approved';
        objApplication.pepLastSaved__c = system.now();
        update objApplication; 
       
        Pagereference pd=Page.pepLoanSetupUploadedDocs;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
     test.stopTest();   
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP','192.168.2.1');
        ApexPages.currentPage().getParameters().put('redirectFromPageNo','2');
        
        Residential_Address__c resAdd = pepCommonTrackerController.createResidential();
        resAdd.Application__c = objApplication.id;
        update resAdd;
        
        genesis__Employment_Information__c empInfo = pepCommonTrackerController.employmentInformation();
        empInfo.genesis__Application__c = objApplication.id;
        empInfo.Sequence__c = 5;
        update empInfo;
         
        pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('pepLoanSetupUploadedDocs');
        
        //Section Creation
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        
        //Question Creation       
        pepCmsQuestion__c objQuestion2 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion2.pepFieldApiName__c='Residential_Address__c';
        objQuestion2.pepRecordSequence__c=2;
        update objQuestion2;
        
        //update objModel;
        
        OTP_Template__c temp = pepCommonTrackerController.createOTPTemplate();
      
        pepCMSModelContainer_New newIncome = new pepCMSModelContainer_New();
        newIncome.objApplication = objApplication;
        newIncome.objAccount = acc;
        newIncome.objAccount.PersonEmail = acc.PersonEmail;
        newIncome.objAccount.PersonMobilePhone = acc.PersonMobilePhone;
        
        List<pepCMSModelContainer_New.wrapQuestion> lstWrapClass1 = new List<pepCMSModelContainer_New.wrapQuestion>();
        pepCMSModelContainer_New.wrapQuestion wrapClass1 = new pepCMSModelContainer_New.wrapQuestion();
        wrapClass1.objCmsQuestion = objQuestion2;
        lstWrapClass1.add(wrapClass1);
        
        List<pepCMSModelContainer_New.wrapSection> lstWrapClass = new List<pepCMSModelContainer_New.wrapSection>();
        pepCMSModelContainer_New.wrapSection wrapClass = new pepCMSModelContainer_New.wrapSection();
        wrapClass.lseQuestions = lstWrapClass1; 
        lstWrapClass.add(wrapClass);
        newIncome.lstSection = lstWrapClass;
        
        
        
        pepCmsModelContainer modelContainer = new pepCmsModelContainer();
        modelContainer.strPageName='Personal Details';
        modelContainer.strSectionName='PersonalDetailsSec1';
        modelContainer.objApplication = objApplication;
        modelContainer.objAccount = acc;
        
        pepCmsModelContainer modelContainer1 = new pepCmsModelContainer();
      
        modelContainer1.objApplication = objApplication;
        modelContainer1.objAccount = acc;
        
        pepPersonalDetailsController objClass = new pepPersonalDetailsController ();
        objClass.strDate = system.today();
        objClass.Page_Name = 'pepLoanSetupUploadedDocs';
        objClass.Page_Name = 'pepLoanSetupUploadedDocs';
        objClass.strPageName = 'Personal Details';
        objClass.objModelContainer=newIncome ;
        objClass.objModel = modelContainer;
        objClass.objModel3 = modelContainer1;
       
        objClass.SaveValues();
        objClass.saveCallFromHeader();
        objClass.saveData();
        acc.pepIsDummyAccount__c = true;
        acc.LastName = 'DUMMY';
        update acc;
        objClass.getpopulateValues();
        //Added By varun to increase the code coverage
        genesis__Applications__c applicationApproved = new genesis__Applications__c(id=objClass.Objmodelcontainer.objapplication.id,Serviceability_Status__c = 'Approved',genesis__Status__c='CONDITIONALLY APPROVED');
        update applicationApproved;
        objClass.checkVedaStausAndRedirect();
        genesis__Applications__c applicationDeclined = new genesis__Applications__c(id=objClass.Objmodelcontainer.objapplication.id,Serviceability_Status__c = 'Declined',genesis__Status__c='DECLINED');
        update applicationDeclined;
        objClass.checkVedaStausAndRedirect();
        genesis__Applications__c applicationReferred = new genesis__Applications__c(id=objClass.Objmodelcontainer.objapplication.id,Serviceability_Status__c = 'Referred',genesis__Status__c='REFERRED');
        update applicationReferred;
        objClass.checkVedaStausAndRedirect();
        objClass.saveDataFromExt();
        
        objClass.getCookieData();
        objClass.fetchResidentialAddress();
        objClass.doVerify();
        objClass.checkcookie();
    }
}
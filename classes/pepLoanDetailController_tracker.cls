@isTest(SeeAllData=False) private class pepLoanDetailController_tracker{
    
    @isTest static void loadData(){
        
        loan.testhelper.createSeedDataForTesting();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        genesis__Applications__c objApplication= genesis.TestHelper.createApplication();
        objApplication.Requested_Term__c =1;
        update objApplication;
        pepCmsPage__c objPage1 =  new pepCmsPage__c();
        objPage1.pepPageName__c='Landing Page';
        insert objPage1;
        
        pepCmsPage__c objPage11 =  new pepCmsPage__c();
        objPage11.pepPageName__c='Loan Details';
        // insert objPage11;
        
        //Section Creation
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c='LandingPageSection1';
        objSection1.pepSectionStory__c='loanPurpose';
        update objSection1;
        
        pepCmsSection__c objSection11 = new pepCmsSection__c();
        /// objSection11 = pepCommonTrackerController.createSection1(objPage11);
        objSection11.pepSectionUniqueName__c='LoanDetailsSection1';
        objSection11.pepSectionStory__c='loanPurpose';
        //   update objSection11;
        
        //Question Creation
        
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
        
        //Creating Answer
        
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
        
        pepDefaultCompany__c objDefaultCompany = new pepDefaultCompany__c();
        objDefaultCompany.name='Company Id';
        objDefaultCompany.pepBusinessAccount__c='0012800000n1snN';
        objDefaultCompany.pepDefault_Company_Id__c='a5a28000000PB19';
        insert objDefaultCompany;
        
        clcommon__CL_Purpose__c objClPurpose = new clcommon__CL_Purpose__c();
        objClPurpose.Name='a new car';
        objClPurpose.clcommon__Description__c='A loan for a new car.';
        objClPurpose.Serial_No__c=4;
        insert objClPurpose;
        
        clcommon__CL_Product__c objClProduct = new clcommon__CL_Product__c();
        objClProduct.clcommon__Product_Name__c='unsecured';
        objClProduct.Interest_Type__c = 'variable';
        objClProduct.PL_Product__c = 'unsecured';
        insert objClProduct;
        
        clcommon__CL_Product__c objClProduct1 = new clcommon__CL_Product__c();
        objClProduct1.clcommon__Product_Name__c='secured';
        objClProduct1.Interest_Type__c = 'variable';
        objClProduct1.PL_Product__c = 'secured';
        insert objClProduct1;
        
        
        CL_Product_Purpose_Junction__c objProductJunct = 
            new CL_Product_Purpose_Junction__c(
                CL_Product__c = objClProduct.Id,
                CL_Purpose__c = objClPurpose.id
            );
        
        CL_Product_Purpose_Junction__c objProductJunct1 = 
            new CL_Product_Purpose_Junction__c(
                CL_Product__c = objClProduct1.Id,
                CL_Purpose__c = objClPurpose.id);                                   
        
        insert objProductJunct;
        insert objProductJunct1;
        
        //WrapperAnswer
        
        pepLoanDetailsController.wrapperAnswer objWrapAns1 = new  pepLoanDetailsController.wrapperAnswer();
        objWrapAns1.objCmsAnswer=objAnswer1;
        pepLoanDetailsController.wrapperAnswer objWrapAns2 = new  pepLoanDetailsController.wrapperAnswer();
        objWrapAns2.objCmsAnswer=objAnswer2;
        pepLoanDetailsController.wrapperAnswer objWrapAns3 = new  pepLoanDetailsController.wrapperAnswer();
        objWrapAns3.objCmsAnswer=objAnswer3;
        pepLoanDetailsController.wrapperAnswer objWrapAns4 = new  pepLoanDetailsController.wrapperAnswer();
        objWrapAns4.objCmsAnswer=objAnswer4;
        pepLoanDetailsController.wrapperAnswer objWrapAns5 = new  pepLoanDetailsController.wrapperAnswer();
        objWrapAns5.objCmsAnswer=objAnswer5;     
        pepLoanDetailsController.wrapperAnswer objWrapAns6 = new  pepLoanDetailsController.wrapperAnswer();
        objWrapAns6.objCmsAnswer=objAnswer6;
        
        //WrapperApplication
        
        pepLoanDetailsController.wrapperApplication objWrapApp1 = new  pepLoanDetailsController.wrapperApplication();
        objWrapApp1.objQuestion= objQuestion1;
        objWrapApp1.stranswer=String.valueof(objClPurpose.id);
        objWrapApp1.lstExpectedAnswers=new List<pepLoanDetailsController.wrapperAnswer>();
        objWrapApp1.lstExpectedAnswers.add(objWrapAns1);
        
        pepLoanDetailsController.wrapperApplication objWrapApp2 = new  pepLoanDetailsController.wrapperApplication();
        objWrapApp2.objQuestion= objQuestion2;
        objWrapApp2.stranswer='12345';
        objWrapApp2.lstExpectedAnswers=new List<pepLoanDetailsController.wrapperAnswer>();
        objWrapApp2.lstExpectedAnswers.add(objWrapAns2);
        
        pepLoanDetailsController.wrapperApplication objWrapApp3 = new  pepLoanDetailsController.wrapperApplication();
        objWrapApp3.objQuestion= objQuestion3;
        objWrapApp3.stranswer='2';
        objWrapApp3.lstExpectedAnswers=new List<pepLoanDetailsController.wrapperAnswer>();
        objWrapApp3.lstExpectedAnswers.add(objWrapAns3);
        
        pepLoanDetailsController.wrapperApplication objWrapApp4 = new  pepLoanDetailsController.wrapperApplication();
        objWrapApp4.objQuestion= objQuestion4;
        objWrapApp4.stranswer='2';
        objWrapApp4.lstExpectedAnswers=new List<pepLoanDetailsController.wrapperAnswer>();
        objWrapApp4.lstExpectedAnswers.add(objWrapAns4);
        
        pepLoanDetailsController.wrapperApplication objWrapApp5 = new  pepLoanDetailsController.wrapperApplication();
        objWrapApp5.objQuestion= objQuestion5;
        objWrapApp5.stranswer='good';
        objWrapApp5.lstExpectedAnswers=new List<pepLoanDetailsController.wrapperAnswer>();
        objWrapApp5.lstExpectedAnswers.add(objWrapAns5);
        
        pepLoanDetailsController.wrapperApplication objWrapApp6 = new  pepLoanDetailsController.wrapperApplication();
        objWrapApp6.objQuestion= objQuestion6;
        objWrapApp6.stranswer=String.valueof(objClProduct.id);
        objWrapApp6.lstExpectedAnswers=new List<pepLoanDetailsController.wrapperAnswer>();
        objWrapApp6.lstExpectedAnswers.add(objWrapAns6);
        
        //WrapSection
        List<pepLoanDetailsController.wrapperSection> wrappersectionlist = new List<pepLoanDetailsController.wrapperSection>();
        pepLoanDetailsController.wrapperSection objWrapSection = new  pepLoanDetailsController.wrapperSection();
        objWrapSection.objSection= objSection1;
        objWrapSection.lstWrapperQuestion = new List<pepLoanDetailsController.wrapperApplication>();
        objWrapSection.lstWrapperQuestion.add(objWrapApp1);
        objWrapSection.lstWrapperQuestion.add(objWrapApp2);
        objWrapSection.lstWrapperQuestion.add(objWrapApp3);
        objWrapSection.lstWrapperQuestion.add(objWrapApp4);
        objWrapSection.lstWrapperQuestion.add(objWrapApp5);
        objWrapSection.lstWrapperQuestion.add(objWrapApp6);
        wrappersectionlist.add(objWrapSection);
        
        
        genesis__Company__c objCompany = new genesis__Company__c();
        objCompany.Name='TEST company';
        objCompany.genesis__Short_Name__c='test';
        insert objCompany;
        
        genesis__Credit_Rating_Matrix__c objRatingMatrix = new genesis__Credit_Rating_Matrix__c();
        objRatingMatrix.Name='good';
        objRatingMatrix.Serial_No__c = 1;
        insert objRatingMatrix;
        
        genesis__Rate_Card_Setup_Header__c objRateCardHeader = new genesis__Rate_Card_Setup_Header__c();
        objRateCardHeader.Name='a6IN0000000Aj0z';
        objRateCardHeader.genesis__CL_Product__c=objClProduct.id;
        objRateCardHeader.CL_Purpose__c=objClPurpose.id;
        objRateCardHeader.genesis__Transaction_Date__c =System.today();
        objRateCardHeader.genesis__Start_Date__c=System.today();
        objRateCardHeader.genesis__Company__c=objCompany.id;
        objRateCardHeader.Type__c = 'Pre Credit Check';
        insert objRateCardHeader;
        
        genesis__Rate_Card_Setup_Detail__c objRateCard = new genesis__Rate_Card_Setup_Detail__c();
        objRateCard.genesis__Rate_Card_Setup_Header__c = objRateCardHeader.id;
        objRateCard.genesis__Interest_Rate__c = 10;
        objRateCard.genesis__Minimum_Financed_Amount__c=20;
        objRateCard.genesis__Maximum_Financed_Amount__c= 2000000;
        objRateCard.genesis__Min_Term__c =2;
        objRateCard.genesis__Max_Term__c=1000;
        objRateCard.genesis__Payment_Frequency__c='monthly';
        objRateCard.genesis__Credit_Rating__c=objRatingMatrix.id;         
        insert objRateCard;
        
        Parameters_and_Interest_Mapping__c objParameter =new Parameters_and_Interest_Mapping__c();
        objParameter.Name='Staff Loan';
        objParameter.Active__c=True;
        objParameter.Interest_Rate__c=12;
        insert objParameter;
        
        pages_config__c objCOnfig = new pages_config__c();
        objConfig.name='pepapplynow';
        objConfig.Page_Label__c ='applynow';
        insert objConfig; 
        
        Portal_OwnerId__c objPortal = new Portal_OwnerId__c();
        objPortal.Owner_Id__c='00528000004LS0X';//00528000004LS0X'; (Production)
        objPortal.name='First';
        insert objPortal;
        
        
        
        pages_config__c objPageConfig = new pages_config__c();
        objPageConfig.Page_Label__c='loandetails';
        objPageConfig.name='peploandetails';
        insert objPageConfig;
        
        pages_config__c objPageConfig1 = new pages_config__c();
        objPageConfig1.Page_Label__c='retrieveapp';
        objPageConfig1.name='pepretrieveapp';
        insert objPageConfig1;
        
        pages_config__c objPageConfig11 = new pages_config__c();
        objPageConfig11.Page_Label__c='landingpage';
        objPageConfig11.name='peplandingpage';
        insert objPageConfig11;
        
        pages_config__c objPageConfig2 = new pages_config__c();
        objPageConfig2.Page_Label__c='Contract';
        objPageConfig2.name='pepcontract';
        insert objPageConfig2;
        
        pages_config__c objPageConfig3 = new pages_config__c();
        objPageConfig3.Page_Label__c='retrieveapp';
        objPageConfig3.name='pepretrieveapp';
        insert objPageConfig3;
        
        pages_config__c objPageConfig4 = new pages_config__c();
        objPageConfig4.Page_Label__c='applynow';
        objPageConfig4.name='pepapplynow';
        insert objPageConfig4;
        
        Application__c pepApplication =pepCommonTrackerController.createApplication();
        pepApplication.Name= 'pepIncomePage';
        pepApplication.Navigation_Status__c='Income';
        pepApplication.RedirectPage__c='pepIncomePage';
        Update pepApplication;
        
        PageReference pageRef = Page.pepLoanDetails;
        Test.setCurrentPagereference(pageRef);
        //apexpages.currentpage().getparameters().put('Ref',); 
        
        
        Cookie reqLoanAmount=new Cookie('Requested_Loan_Amount__c','30','-1',null,false);
        pageRef.setcookies(new cookie[]{reqLoanAmount});
        Cookie reqTerm=new Cookie('Requested_Term__c','3','-1',null,false);
        pageRef.setcookies(new cookie[]{reqTerm});
        Cookie debitFrequency=new Cookie('Debit_Frequency__c','weekly','-1',null,false);
        pageRef.setcookies(new cookie[]{debitFrequency});
        Cookie creditRating=new Cookie('genesis__Credit_Rating__c',String.valueof(objRatingMatrix.id),'-1',null,false);
        pageRef.setcookies(new cookie[]{creditRating});
        Cookie clPurpose=new Cookie('genesis__CL_Purpose__c',String.valueof(objClPurpose.id),'-1',null,false);
        pageRef.setcookies(new cookie[]{clPurpose});
        Cookie clProduct=new Cookie('genesis__CL_Product__c',String.valueof(objClProduct.id),'-1',null,false);
        pageRef.setcookies(new cookie[]{clProduct});
        Cookie param=new Cookie('param1','Staff Loan','-1',null,false);
        pageRef.setcookies(new cookie[]{param});
        
        ApexPages.currentPage().getParameters().put('param1','secured');
        ApexPages.currentPage().getParameters().put('param2','secured');
        ApexPages.currentPage().getParameters().put('param3','secured');
        ApexPages.currentPage().getParameters().put('param4','secured');
        
        
        pepLoanDetailsController objController = new pepLoanDetailsController();
        objController.sectionNumber=1;
        objController.lstWrapperSection=wrappersectionlist;
        //  objController.ContinueOnIncomePage();
        
        
        objController.CommonMethodForInsertingApplication();       
        objController.questionNo=0;   
        objController.querydata();
        
        objParameter.Active__c=false;
        update objParameter;
        objController.FetchRateCardandCalculateEMI();
        System.assertEquals(50, objController.calculatedEMI);
        PageReference pageRef1 = Page.peplandingpage;
        Test.setCurrentPagereference(pageRef1);
        
        Cookie reqLoanAmount1=new Cookie('Requested_Loan_Amount__c','30','-1',null,false);
        pageRef1.setcookies(new cookie[]{reqLoanAmount1});
        Cookie reqTerm1=new Cookie('Requested_Term__c','3','-1',null,false);
        pageRef.setcookies(new cookie[]{reqTerm1});
        Cookie debitFrequency1=new Cookie('Debit_Frequency__c','weekly','-1',null,false);
        pageRef1.setcookies(new cookie[]{debitFrequency1});
        Cookie creditRating1=new Cookie('genesis__Credit_Rating__c',String.valueof(objRatingMatrix.id),'-1',null,false);
        pageRef1.setcookies(new cookie[]{creditRating1});
        Cookie clPurpose1=new Cookie('genesis__CL_Purpose__c',String.valueof(objClPurpose.id),'-1',null,false);
        pageRef1.setcookies(new cookie[]{clPurpose1});
        Cookie clProduct1=new Cookie('genesis__CL_Product__c',String.valueof(objClProduct.id),'-1',null,false);
        pageRef1.setcookies(new cookie[]{clProduct1});
        Cookie param1=new Cookie('param1','Staff Loan','-1',null,false);
        pageRef1.setcookies(new cookie[]{param1});
        Cookie param2=new Cookie('genesisinterestrate','1','-1',null,false);
        pageRef1.setcookies(new cookie[]{param2});
        
        Cookie param21=new Cookie('genesisproducttype','type','-1',null,false);
        pageRef1.setcookies(new cookie[]{param21});
        Cookie param20=new Cookie('debitAmount','1','-1',null,false);
        pageRef1.setcookies(new cookie[]{param20});
        Cookie param22=new Cookie('existingcustomer','yes','-1',null,false);
        pageRef1.setcookies(new cookie[]{param22});
        
        Cookie param23=new Cookie('yearterm','1','-1',null,false);
        pageRef1.setcookies(new cookie[]{param23});
        
        
        pepLoanDetailsController objController1 = new pepLoanDetailsController();  
        objController1.questionNo=6; 
        objController1.FilterValues();  
        objController1.lstWrapperSection=wrappersectionlist; 
        objController1.questionNo=6;
        objController1.FilterValues();  
        objController1.questionNo=0;
        objController1.FilterValues();
        
        objPage1.pepPageName__c='Loan Details';
        update objPage1;
        objSection1.pepSectionUniqueName__c='LoanDetailsSection1'; 
        update objSection1;
        objController1.renderSectionStory();
        
        objController1.loadCMSContentForLoanDetails();
        
        Cookie ApplicationId=new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pageRef1.setcookies(new cookie[]{ApplicationId});
        Cookie genesisinterestrate =new Cookie('genesisinterestrate','14','-1',null,false);
        pageRef1.setcookies(new cookie[]{genesisinterestrate});
        Cookie debitAmount=new Cookie('debitAmount','1400','-1',null,false);
        pageRef1.setcookies(new cookie[]{debitAmount});
        Cookie yearterm=new Cookie('yearterm','1','-1',null,false);
        pageRef1.setcookies(new cookie[]{yearterm});
        Cookie existingcustomer=new Cookie('existingcustomer','yes','-1',null,false);
        pageRef1.setcookies(new cookie[]{existingcustomer});
        
        pepLoanDetailsController.checkCookieAndRedirect();
        objController1.retrieveAppCode();
        
        objController1.BackOnApplyPage();
        
        objController1.objApplication=objApplication;
        objController1.fetchApplication();
        objController1.getCookieData();
        objController1.clearValues();
        
        apexpages.currentpage().getparameters().put('Ref','testref');
        account a = new Account(name='test',Referred_By_Code__c='testref');
        insert a;
        
        objController1.createDummyAccount();   
        objController.objApplication = objApplication;
        //objController.ContinueOnIncomePage();
        objController1.querydata1();
        
        objController1.sectionValue = '1';
        objController1.strSelectedValue1 = true;
        objController1.strSelectedValue ='q';
        objController1.intRequestedTerm =1;
        objController1.IntcookiePageNo =2;
        //objController1.A = 'q';
        objController1.purposeName ='q';
        objController1.pageName ='q';
        objController1.sectionName ='q';
        objController1.intPreviousPageNumber =2;
        
        
        List<Cookie> lstCookie = new List<Cookie>();
        lstCookie.add(new Cookie('utm_source','utm_source',null,0,false));
        lstCookie.add(new Cookie('utm_medium','utm_medium',null,0,false));
        lstCookie.add(new Cookie('utm_campaign','utm_campaign',null,0,false));
        lstCookie.add(new Cookie('utm_content','utm_content',null,0,false));
        lstCookie.add(new Cookie('utm_term','utm_term',null,0,false));
        lstCookie.add(new Cookie('utm_referrer','utm_referrer',null,0,false));
        
        lstCookie.add(new Cookie('param1','a',null,0,false));
        lstCookie.add(new Cookie('param2','b',null,0,false));
        lstCookie.add(new Cookie('param3','c',null,0,false));
        lstCookie.add(new Cookie('param4','d',null,0,false));
        
        pages_config__c configObj = new pages_config__c();
        configObj.Name = 'pepincomepage';
        configObj.Page_Label__c = 'IncomePage';
        insert configObj;
        ApexPages.currentPage().setCookies(lstCookie);
        genesis__Applications__c objApplication1 = objController1.loadParametersFromCookies(new genesis__Applications__c());
        System.assertEquals(objApplication1.Web_Analytics_Campaign__c, 'utm_campaign');
        objController1.continueOnIncomePage();
    }
    
}
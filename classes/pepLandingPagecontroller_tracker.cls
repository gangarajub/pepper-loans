@isTest(SeeAllData=False) private class pepLandingPagecontroller_tracker{
    
    @isTest static void loadData()
    {
        loan.testhelper.createSeedDataForTesting();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        genesis__Applications__c objApplication= genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c = 'BI-WEEKLY';
        objApplication.Requested_Term__c = 3;
        update objApplication;
        pepCommonTrackerController obj1 =new pepCommonTrackerController();
        pepCmsPage__c objPage1 =  new pepCmsPage__c();
        objPage1.pepPageName__c='Landing Page';
        insert objPage1;
        pepCmsPage__c objPage11 =  new pepCmsPage__c();
        objPage11.pepPageName__c='Loan Details';
        insert objPage11;
        
        //Section Creation
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c='LandingPageSection1';
        objSection1.pepSectionStory__c='loanPurpose';
        update objSection1;
        
        pepCmsSection__c objSection11 = new pepCmsSection__c();
        objSection11 = pepCommonTrackerController.createSection1(objPage11);
        objSection11.pepSectionUniqueName__c='LoanDetailsSection1';
        objSection11.pepSectionStory__c='loanPurpose';
        update objSection11;
        
        
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
        
        
        //WrapperAnswer
        
        pepLandingPagecontroller.wrapperAnswer objWrapAns1 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns1.objCmsAnswer=objAnswer1;
        pepLandingPagecontroller.wrapperAnswer objWrapAns2 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns2.objCmsAnswer=objAnswer2;
        pepLandingPagecontroller.wrapperAnswer objWrapAns3 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns3.objCmsAnswer=objAnswer3;
        pepLandingPagecontroller.wrapperAnswer objWrapAns4 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns4.objCmsAnswer=objAnswer4;
        pepLandingPagecontroller.wrapperAnswer objWrapAns5 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns5.objCmsAnswer=objAnswer5;     
        pepLandingPagecontroller.wrapperAnswer objWrapAns6 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns6.objCmsAnswer=objAnswer6;
        
        //WrapperApplication
        
        pepLandingPagecontroller.wrapperApplication objWrapApp1 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp1.objQuestion= objQuestion1;
        objWrapApp1.stranswer=String.valueof(objClPurpose.id);
        objWrapApp1.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp1.lstExpectedAnswers.add(objWrapAns1);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp2 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp2.objQuestion= objQuestion2;
        objWrapApp2.stranswer='12345';
        objWrapApp2.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp2.lstExpectedAnswers.add(objWrapAns2);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp3 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp3.objQuestion= objQuestion3;
        objWrapApp3.stranswer='2';
        objWrapApp3.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp3.lstExpectedAnswers.add(objWrapAns3);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp4 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp4.objQuestion= objQuestion4;
        objWrapApp4.stranswer='2';
        objWrapApp4.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp4.lstExpectedAnswers.add(objWrapAns4);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp5 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp5.objQuestion= objQuestion5;
        objWrapApp5.stranswer='good';
        objWrapApp5.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp5.lstExpectedAnswers.add(objWrapAns5);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp6 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp6.objQuestion= objQuestion6;
        objWrapApp6.stranswer=String.valueof(objClProduct.id);
        objWrapApp6.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp6.lstExpectedAnswers.add(objWrapAns6);
        
        //WrapSection
        List<pepLandingPagecontroller.wrapperSection> wrappersectionlist = new List<pepLandingPagecontroller.wrapperSection>();
        pepLandingPagecontroller.wrapperSection objWrapSection = new  pepLandingPagecontroller.wrapperSection();
        objWrapSection.objSection= objSection1;
        objWrapSection.lstWrapperQuestion = new List<pepLandingPagecontroller.wrapperApplication>();
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
        objPortal.Owner_Id__c= '00528000004LS0X'; //'00528000004LS0X'; (Production)
        objPortal.name='First';
        insert objPortal;
        
        pages_config__c objPageConfig = new pages_config__c();
        objPageConfig.Page_Label__c='landingpage';
        objPageConfig.name='peplandingpage';
        insert objPageConfig;
        
        pages_config__c objPageConfig1 = new pages_config__c();
        objPageConfig1.Page_Label__c='retrieveapp';
        objPageConfig1.name='pepretrieveapp';
        insert objPageConfig1;
        
        PageReference pageRef = Page.peplandingpage;
        Test.setCurrentPagereference(pageRef);
        //apexpages.currentpage().getparameters().put('Ref',); 
        
        
        Cookie reqLoanAmount=new Cookie('Requested_Loan_Amount__c','3000','-1',null,false);
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
        
        
        
        pepLandingPagecontroller objController1 = new pepLandingPagecontroller();
        objController1.sectionNumber=1;  
        objController1.lstWrapperSection=wrappersectionlist;      
        objController1.CommonMethodForInsertingApplication();       
        objController1.questionNo=0;
        objController1.querydata();
        
        for(integer i=0; i < objController1.lstWrapperSection[0].lstWrapperQuestion.size(); i++)
        {
            if(objController1.lstWrapperSection[0].lstWrapperQuestion[i].objQuestion.pepFieldApiName__c =='Debit_Frequency__c')
            {
                System.assertEquals(null, objController1.lstWrapperSection[0].lstWrapperQuestion[i].strAnswer);
            }
        }
        
        ApexPages.currentPage().getParameters().put('p4','secured');
        ApexPages.currentPage().getParameters().put('p3','secured');
        ApexPages.currentPage().getParameters().put('p2','secured');
        ApexPages.currentPage().getParameters().put('p1','secured');
        String abc ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            +'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            +'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            +'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            +'aaaaaaaaaaaaaaaaaaaa';
        pepLandingPagecontroller objController = new pepLandingPagecontroller();
        //  objController.sectionNumber=1;
        // objController.renderSectionStory();
        objController.lstWrapperSection=wrappersectionlist;
        // objController.querydata();
        objController.questionNo=6;
        objController.strPurposeName=objClPurpose.name;
        objController.renderSectionStory();
        objController.ApplyNow();
        objController.FilterValues();
        objController.questionNo=0;
        objController.FilterValues();
        objController.fetchAllRateCard();
        
        objController.questionNo=1;
        objController.fetchAllRateCard();
        
        
        //objController.querydata();
        objController.questionNo=0;
        objController.retrieveAppCode();
        objController.FetchRateCardandCalculateEMI();
        
        System.assertEquals(500, objController.calculatedEMI);
        
        
        ApexPages.currentPage().getParameters().put('p4','secured');
        ApexPages.currentPage().getParameters().put('p3',abc);
        ApexPages.currentPage().getParameters().put('p2',abc);
        ApexPages.currentPage().getParameters().put('p1',abc);
        apexpages.currentpage().getparameters().put('Ref','testref');
        
        apexpages.currentpage().getparameters().put('redirectFromPageNo','2');
        account a = new Account(name='test',Referred_By_Code__c='testref');
        insert a;
        
        debitFrequency=new Cookie('Debit_Frequency__c','fortnightly','-1',null,false);
        pageRef.setcookies(new cookie[]{debitFrequency});
        
        pepLandingPagecontroller objController2 = new pepLandingPagecontroller();
        objController2.sectionNumber=1;  
        objController2.objApplication=objApplication;
        objController2.lstWrapperSection=wrappersectionlist; 
        objController2.decEMI = '200';    
        objController2.ApplyNow(); 
        objController2.decEMI = '200';
        objController2.CommonMethodForInsertingApplication();    
        Id accountId = objController2.createDummyAccount();   
        System.assertEquals(a.Id, accountId); 
        //  objController.CommonMethodForInsertingApplication();
        
        
        ApexPages.currentPage().getParameters().put('p4','secured');
        apexpages.currentpage().getparameters().put('redirectFromPageNo','2');
        
        Cookie clProduct1=new Cookie('genesis__CL_Product__c',null,'-1',null,false);
        pageRef.setcookies(new cookie[]{clProduct1});
        
        Cookie clPurpose1=new Cookie('genesis__CL_Purpose__c',String.valueof(objClPurpose.id),'-1',null,false);
        pageRef.setcookies(new cookie[]{clPurpose1});
        
        pepLandingPagecontroller objController3 = new pepLandingPagecontroller();
        objController3.loadClPurpose();
        
        
        objController3.lstWrapperSection=wrappersectionlist;
        // objController.querydata();
        objController3.questionNo=6;
        objController3.strPurposeName=objClPurpose.name;
        objController3.renderSectionStory();
        objController3.ApplyNow();
        objController3.FilterValues();
        objController3.questionNo=0;
        objController3.FilterValues();
        objController3.fetchAllRateCard();  
        objController3.renderSectionStory();
        objController3.querydata1();
        
        for(integer i=0; i < objController3.lstWrapperSection[0].lstWrapperQuestion.size(); i++)
        {
            if(objController1.lstWrapperSection[0].lstWrapperQuestion[i].objQuestion.pepFieldApiName__c =='Debit_Frequency__c')
            {
                System.assertEquals(null, objController3.lstWrapperSection[0].lstWrapperQuestion[i].strAnswer);
            }
        }
        //added by : sushant kumar
        ApexPages.currentPage().setCookies(new Cookie[]{new cookie('genesis__CL_Product__c',null,null,0,false)});
        objController3.fetchAllRateCard();
    }
    
    
    @isTest static void loadData1()
    {
        loan.testhelper.createSeedDataForTesting();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        genesis__Applications__c objApplication= genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c = 'BI-WEEKLY';
        objApplication.Requested_Term__c = 3;
        update objApplication;
        pepCommonTrackerController obj1 =new pepCommonTrackerController();
        pepCmsPage__c objPage1 =  new pepCmsPage__c();
        objPage1.pepPageName__c='Landing Page';
        insert objPage1;
        pepCmsPage__c objPage11 =  new pepCmsPage__c();
        objPage11.pepPageName__c='Loan Details';
        insert objPage11;
        
        //Section Creation
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c='LandingPageSection1';
        objSection1.pepSectionStory__c='loanPurpose';
        update objSection1;
        
        pepCmsSection__c objSection11 = new pepCmsSection__c();
        objSection11 = pepCommonTrackerController.createSection1(objPage11);
        objSection11.pepSectionUniqueName__c='LoanDetailsSection1';
        objSection11.pepSectionStory__c='loanPurpose';
        update objSection11;
        
        
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
        
        
        //WrapperAnswer
        
        pepLandingPagecontroller.wrapperAnswer objWrapAns1 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns1.objCmsAnswer=objAnswer1;
        pepLandingPagecontroller.wrapperAnswer objWrapAns2 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns2.objCmsAnswer=objAnswer2;
        pepLandingPagecontroller.wrapperAnswer objWrapAns3 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns3.objCmsAnswer=objAnswer3;
        pepLandingPagecontroller.wrapperAnswer objWrapAns4 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns4.objCmsAnswer=objAnswer4;
        pepLandingPagecontroller.wrapperAnswer objWrapAns5 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns5.objCmsAnswer=objAnswer5;     
        pepLandingPagecontroller.wrapperAnswer objWrapAns6 = new  pepLandingPagecontroller.wrapperAnswer();
        objWrapAns6.objCmsAnswer=objAnswer6;
        
        //WrapperApplication
        
        pepLandingPagecontroller.wrapperApplication objWrapApp1 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp1.objQuestion= objQuestion1;
        objWrapApp1.stranswer=String.valueof(objClPurpose.id);
        objWrapApp1.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp1.lstExpectedAnswers.add(objWrapAns1);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp2 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp2.objQuestion= objQuestion2;
        objWrapApp2.stranswer='12345';
        objWrapApp2.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp2.lstExpectedAnswers.add(objWrapAns2);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp3 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp3.objQuestion= objQuestion3;
        objWrapApp3.stranswer='2';
        objWrapApp3.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp3.lstExpectedAnswers.add(objWrapAns3);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp4 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp4.objQuestion= objQuestion4;
        objWrapApp4.stranswer='2';
        objWrapApp4.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp4.lstExpectedAnswers.add(objWrapAns4);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp5 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp5.objQuestion= objQuestion5;
        objWrapApp5.stranswer='good';
        objWrapApp5.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp5.lstExpectedAnswers.add(objWrapAns5);
        
        pepLandingPagecontroller.wrapperApplication objWrapApp6 = new  pepLandingPagecontroller.wrapperApplication();
        objWrapApp6.objQuestion= objQuestion6;
        objWrapApp6.stranswer=String.valueof(objClProduct.id);
        objWrapApp6.lstExpectedAnswers=new List<pepLandingPagecontroller.wrapperAnswer>();
        objWrapApp6.lstExpectedAnswers.add(objWrapAns6);
        
        //WrapSection
        List<pepLandingPagecontroller.wrapperSection> wrappersectionlist = new List<pepLandingPagecontroller.wrapperSection>();
        pepLandingPagecontroller.wrapperSection objWrapSection = new  pepLandingPagecontroller.wrapperSection();
        objWrapSection.objSection= objSection1;
        objWrapSection.lstWrapperQuestion = new List<pepLandingPagecontroller.wrapperApplication>();
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
        objPortal.Owner_Id__c= '00528000004LS0X'; //'00528000004LS0X'; (Production)
        objPortal.name='First';
        insert objPortal;
        
        pages_config__c objPageConfig = new pages_config__c();
        objPageConfig.Page_Label__c='landingpage';
        objPageConfig.name='peplandingpage';
        insert objPageConfig;
        
        pages_config__c objPageConfig1 = new pages_config__c();
        objPageConfig1.Page_Label__c='retrieveapp';
        objPageConfig1.name='pepretrieveapp';
        insert objPageConfig1;
        
        PageReference pageRef = Page.peplandingpage;
        Test.setCurrentPagereference(pageRef);
        //apexpages.currentpage().getparameters().put('Ref',); 
        
        
        Cookie reqLoanAmount=new Cookie('Requested_Loan_Amount__c','3000','-1',null,false);
        pageRef.setcookies(new cookie[]{reqLoanAmount});
        Cookie reqTerm=new Cookie('Requested_Term__c','3','-1',null,false);
        pageRef.setcookies(new cookie[]{reqTerm});
        Cookie debitFrequency=new Cookie('Debit_Frequency__c','weekly','-1',null,false);
        pageRef.setcookies(new cookie[]{debitFrequency});
        Cookie creditRating=new Cookie('genesis__Credit_Rating__c',String.valueof(objRatingMatrix.id),'-1',null,false);
        pageRef.setcookies(new cookie[]{creditRating});
        Cookie clPurpose=new Cookie('genesis__CL_Purpose__c',String.valueof(objClPurpose.id),'-1',null,false);
        pageRef.setcookies(new cookie[]{clPurpose});
        //Cookie clProduct=new Cookie('genesis__CL_Product__c',String.valueof(objClProduct.id),'-1',null,false);
        //pageRef.setcookies(new cookie[]{clProduct});
        Cookie param=new Cookie('param1','Staff Loan','-1',null,false);
        pageRef.setcookies(new cookie[]{param});
        
        pepLandingPagecontroller objController1 = new pepLandingPagecontroller();
        objController1.fetchAllRateCard();
        
        Cookie clPurpose2=new Cookie('genesis__CL_Purpose__c',null,'-1',null,false);
        pageRef.setcookies(new cookie[]{clPurpose2});
        objController1.fetchAllRateCard();
        System.assertEquals(1, objController1.lstRateTypeSelectOption.size());
    }
    
}
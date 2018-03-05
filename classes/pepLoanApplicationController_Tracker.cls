@isTest(SeeAllData=False) private class pepLoanApplicationController_Tracker
{
    @isTest static void pepLoanApplicationControllerTest0() 
    {
        test.starttest();
        loan.testhelper.createSeedDataForTesting();
        pepCommonTrackerController obj1 =new pepCommonTrackerController();
        loan.TestHelper.createOffice();
        RecordType rd=[Select id from Recordtype Limit 1];
        System.debug('======'+rd);
        //Creating User
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        User usr = new User();
        system.runas(usr1)
        {
            if(userinfo.getuserroleid() == null)
            {
                UserRole usrole = new UserRole(Name='Test Record');
                insert usrole;
                usr = new user(id=userinfo.getuserid(),userRoleId=usrole.id);
                update usr;
                usr1=pepCommonTrackerController.createUser();
            }
        }    
     
        //Custom Setting for portalUser
        Portal_OwnerId__c portalId = new Portal_OwnerId__c();
        portalId  = pepCommonTrackerController.createPortalOwnerID(usr);
        
        //Creating Purpose
        loan__Loan_Purpose__c objLoanPurpose = new loan__Loan_Purpose__c();
        objLoanPurpose.Name='New Car';
        objLoanPurpose.loan__Loan_Purpose_Code__c='VNC0001';
        objLoanPurpose.loan__Description__c='Vehicle New Car';
        insert objLoanPurpose;
        
        clcommon__CL_Purpose__c objClPurpose = new clcommon__CL_Purpose__c();
        objClPurpose.Name='a new car';
        objClPurpose.clcommon__Description__c='A loan for a new car.';
       // objClPurpose.Loan_Purpose__c=objLoanPurpose.id;
        objClPurpose.Serial_No__c=4;
        insert objClPurpose;
        
        loan__Loan_Purpose__c objLoanPurpose1 = new loan__Loan_Purpose__c();
        objLoanPurpose1.Name='Debt Consolidation';
        objLoanPurpose1.loan__Loan_Purpose_Code__c='DC0001';
        objLoanPurpose1.loan__Description__c='Debt Consolidation';
        insert objLoanPurpose1;
        
        clcommon__CL_Purpose__c objClPurpose1 = new clcommon__CL_Purpose__c();
        objClPurpose1.Name='consolidating debt';
        objClPurpose1.clcommon__Description__c='Debt consolidation';
       // objClPurpose1.Loan_Purpose__c=objLoanPurpose1.id;
        objClPurpose1.Serial_No__c=7;
        insert objClPurpose1;
        //------
        
        
        clcommon__CL_Product__c objClProduct = new clcommon__CL_Product__c();
        objClProduct.clcommon__Product_Name__c='fixed';
        insert objClProduct;
        
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
        pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Loan Details');
        
        //Section Creation
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c = 'LoanDetailsSection1';
        objSection1.pepSectionStory__c ='test story';
        
        update objSection1;
        
        
       
        
        
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
        
        pepCmsQuestion__c objQuestion8 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);   
        objQuestion8.pepFieldApiName__c='genesis__Payment_Frequency__c';
        objQuestion8.pepType__c='Picklist';
        update objQuestion8;
 
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
         pepCmsAnswer__c objAnswer7 = new pepCmsAnswer__c();
         objAnswer7 = pepCommonTrackerController.createCmsAnswer(objQuestion7);
         pepCmsAnswer__c objAnswer8 = new pepCmsAnswer__c();
         objAnswer8 = pepCommonTrackerController.createCmsAnswer(objQuestion8);
     
     //WrapperAnswer
     
         pepLoanApplicationController.wrapperAnswer objWrapAns1 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns1.objCmsAnswer=objAnswer1;
         pepLoanApplicationController.wrapperAnswer objWrapAns2 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns2.objCmsAnswer=objAnswer2;
         pepLoanApplicationController.wrapperAnswer objWrapAns3 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns3.objCmsAnswer=objAnswer3;
         pepLoanApplicationController.wrapperAnswer objWrapAns4 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns4.objCmsAnswer=objAnswer4;
         pepLoanApplicationController.wrapperAnswer objWrapAns5 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns5.objCmsAnswer=objAnswer5;     
         pepLoanApplicationController.wrapperAnswer objWrapAns6 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns6.objCmsAnswer=objAnswer6;
         pepLoanApplicationController.wrapperAnswer objWrapAns7 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns7.objCmsAnswer=objAnswer7;
         pepLoanApplicationController.wrapperAnswer objWrapAns8 = new  pepLoanApplicationController.wrapperAnswer();
         objWrapAns8.objCmsAnswer=objAnswer8;
     
     //WrapperApplication
     
     
        pepLoanApplicationController.wrapperApplication objWrapApp1 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp1.objQuestion= objQuestion1;
        objWrapApp1.stranswer=String.valueof(objClPurpose.id);
        objWrapApp1.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp1.lstExpectedAnswers.add(objWrapAns1);
        
        pepLoanApplicationController.wrapperApplication objWrapApp2 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp2.objQuestion= objQuestion2;
        objWrapApp2.stranswer='12345';
        objWrapApp2.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp2.lstExpectedAnswers.add(objWrapAns2);
        
        pepLoanApplicationController.wrapperApplication objWrapApp3 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp3.objQuestion= objQuestion3;
        objWrapApp3.stranswer='2';
        objWrapApp3.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp3.lstExpectedAnswers.add(objWrapAns3);
        
        pepLoanApplicationController.wrapperApplication objWrapApp4 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp4.objQuestion= objQuestion4;
        objWrapApp4.stranswer='fortnightly';
        objWrapApp4.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp4.lstExpectedAnswers.add(objWrapAns4);
        
        pepLoanApplicationController.wrapperApplication objWrapApp5 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp5.objQuestion= objQuestion5;
        objWrapApp5.stranswer=String.valueof(objRatingMatrix.id);
        objWrapApp5.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp5.lstExpectedAnswers.add(objWrapAns5);
        
        pepLoanApplicationController.wrapperApplication objWrapApp6 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp6.objQuestion= objQuestion6;
        objWrapApp6.stranswer=String.valueof(objClProduct.id);
        objWrapApp6.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp6.lstExpectedAnswers.add(objWrapAns6);
        
        pepLoanApplicationController.wrapperApplication objWrapApp7 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp7.objQuestion= objQuestion7;
        //objWrapApp7.stranswer=String.valueof(objClProduct.id);
        objWrapApp7.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp7.lstExpectedAnswers.add(objWrapAns7);
        
        pepLoanApplicationController.wrapperApplication objWrapApp8 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp8.objQuestion= objQuestion8;
        //objWrapApp7.stranswer=String.valueof(objClProduct.id);
        objWrapApp8.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp8.lstExpectedAnswers.add(objWrapAns8);
        
        //WrapSection
        List<pepLoanApplicationController.wrapperSection> wrappersectionlist = new List<pepLoanApplicationController.wrapperSection>();
        pepLoanApplicationController.wrapperSection objWrapSection = new  pepLoanApplicationController.wrapperSection();
        objWrapSection.objSection= objSection1;
        objWrapSection.lstWrapperQuestion = new List<pepLoanApplicationController.wrapperApplication>();
        
        objWrapSection.lstWrapperQuestion.add(objWrapApp1);
        objWrapSection.lstWrapperQuestion.add(objWrapApp2);
        objWrapSection.lstWrapperQuestion.add(objWrapApp6);
        objWrapSection.lstWrapperQuestion.add(objWrapApp3);
          objWrapSection.lstWrapperQuestion.add(objWrapApp4);
        
        objWrapSection.lstWrapperQuestion.add(objWrapApp5);
       
        objWrapSection.lstWrapperQuestion.add(objWrapApp8);
        objWrapSection.lstWrapperQuestion.add(objWrapApp7); 
 
        wrappersectionlist.add(objWrapSection);
        
        //pageReference
            PageReference pageRef = Page.pepLoanDetails;
            pageref.getParameters().put('rowIndex','1');
        //pageref.getParameters().get('text','8);
        
        Test.setCurrentPagereference(pageRef);
        pepCmsPage__c objPage2 =  new pepCmsPage__c();
        objPage2.pepPageName__c='Landing Page';
        insert objPage2 ;
        
        //Section Creation
        pepCmsSection__c objSection2= new pepCmsSection__c();
        objSection2= pepCommonTrackerController.createSection1(objPage2);
        objSection2.pepSectionUniqueName__c='LandingPageSection1';
       // objSection1.pepPage__c =objPage1.Id;
        update objSection2;
        pepCmsQuestion__c objQues1 = pepCommonTrackerController.createCmsQuestion(objPage2,objSection2);   
        pepCmsQuestion__c objQues2 = pepCommonTrackerController.createCmsQuestion(objPage2,objSection2);   
        pepCmsQuestion__c objQues3 = pepCommonTrackerController.createCmsQuestion(objPage2,objSection2);   
        pepCmsQuestion__c objQues4 = pepCommonTrackerController.createCmsQuestion(objPage2,objSection2);
        pepCmsQuestion__c objQues5 = pepCommonTrackerController.createCmsQuestion(objPage2,objSection2);   
        pepCmsQuestion__c objQue6 = pepCommonTrackerController.createCmsQuestion(objPage2,objSection2); 
       
        //CustomSetting
        
        List<pages_config__c> objpageConfig = new List<pages_config__c>();
        objpageConfig = pepCommonTrackerController.createPagesConfig();

        pepDefaultCompany__c  objDefaultCompany = new pepDefaultCompany__c();
        objDefaultCompany = pepCommonTrackerController.createPageDefaultCompany();

        //instanceLoanApplication
         genesis.TestHelper.createCompany();
         ApexPages.currentPage().getParameters().put('p1','test');
         ApexPages.currentPage().getParameters().put('p2','test');
         ApexPages.currentPage().getParameters().put('p3','test');
         ApexPages.currentPage().getParameters().put('p4','test');
         pepLoanApplicationController objPep =new pepLoanApplicationController();
         objPep.questionNo=20;
         objPep.lstWrapperSection=wrappersectionlist;
         objPep.sectionValue = '34543';
         objPep.strurl = 'pepLoanDetails';
         objPep.FilterValues();
         objPep.getCookieData();
         objPep.fetchApplication();
         //objPep.loadCMSContentForLoanDetails();
         objPep.questionNo=1;
         objPep.decMinLoanAmount=1;
         objPep.decMaxLoanAmount=1000000;
        // objPep.clearValues1();
         objPep.querydata();
         objPep.fetchAllRateCard();
         Application__c pepApplication =pepCommonTrackerController.createApplication();
        pepApplication.Name= 'pepLoanDetails';
        pepApplication.Navigation_Status__c='Income';
        pepApplication.RedirectPage__c='pepIncomePage';
        Update pepApplication;
         objPep.ContinueApply();
         test.stoptest();
    }

    @isTest static void pepLoanApplicationControllerTest1() 
    {
        test.starttest();
        loan.testhelper.createSeedDataForTesting();
        pepCommonTrackerController obj1 =new pepCommonTrackerController();
        
        loan.TestHelper.createOffice();
        
        //Creating User
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        User usr = new User();
        system.runas(usr1)
        {
            if(userinfo.getuserroleid() == null)
            {
                UserRole usrole = new UserRole(Name='Test Record');
                insert usrole;
                usr = new user(id=userinfo.getuserid(),userRoleId=usrole.id);
                update usr;
                usr1=pepCommonTrackerController.createUser();
            }
        }
        
        genesis__Credit_Rating_Matrix__c objRatingMatrix = new genesis__Credit_Rating_Matrix__c();
        objRatingMatrix.Name='good';
        objRatingMatrix.Serial_No__c = 1;
        insert objRatingMatrix;
        //Custom Setting for portalUser
        
        Portal_OwnerId__c portalId = new Portal_OwnerId__c();
        portalId  = pepCommonTrackerController.createPortalOwnerID(usr);
        //Creating Purpose
        
        loan__Loan_Purpose__c objLoanPurpose = new loan__Loan_Purpose__c();
        objLoanPurpose.Name='New Car';
        objLoanPurpose.loan__Loan_Purpose_Code__c='VNC0001';
        objLoanPurpose.loan__Description__c='Vehicle New Car';
        insert objLoanPurpose;
        
        clcommon__CL_Purpose__c objClPurpose = new clcommon__CL_Purpose__c();
        objClPurpose.Name='a new car';
        objClPurpose.clcommon__Description__c='A loan for a new car.';
      //  objClPurpose.Loan_Purpose__c=objLoanPurpose.id;
        objClPurpose.Serial_No__c=4;
        insert objClPurpose;
        
        loan__Loan_Purpose__c objLoanPurpose1 = new loan__Loan_Purpose__c();
        objLoanPurpose1.Name='Debt Consolidation';
        objLoanPurpose1.loan__Loan_Purpose_Code__c='DC0001';
        objLoanPurpose1.loan__Description__c='Debt Consolidation';
        insert objLoanPurpose1;
        
        clcommon__CL_Purpose__c objClPurpose1 = new clcommon__CL_Purpose__c();
        objClPurpose1.Name='consolidating debt';
        objClPurpose1.clcommon__Description__c='Debt consolidation';
       // objClPurpose1.Loan_Purpose__c=objLoanPurpose1.id;
        objClPurpose1.Serial_No__c=7;
        insert objClPurpose1;
        
        //------
        
        clcommon__CL_Product__c objClProduct = new clcommon__CL_Product__c();
        objClProduct.clcommon__Product_Name__c='fixed';
        insert objClProduct;
        
        genesis__Company__c objCompany = new genesis__Company__c();
        objCompany.Name='TEST company';
        objCompany.genesis__Short_Name__c='test';
        insert objCompany;
        
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
        objRateCard.genesis__Min_Term__c =20;
        objRateCard.genesis__Max_Term__c=100;
        objRateCard.genesis__Credit_Rating__c=objRatingMatrix .id;
        insert objRateCard;
        
        pepCmsPage__c objPage1 =  new pepCmsPage__c();
        objPage1.pepPageName__c='Landing Page';
        insert objPage1;
        
        //Section Creation
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c='LandingPageSection1';
       // objSection1.pepPage__c =objPage1.Id;
        update objSection1;
        
        
        
        pepCmsPage__c objPage11 = pepCommonTrackerController.createPage('Apply Page');
        
        //Section Creation
        pepCmsSection__c objSection11 = new pepCmsSection__c();
        objSection11 = pepCommonTrackerController.createSection1(objPage11);
        objSection11.pepSectionUniqueName__c='LandingPageSection11';
        update objSection11;
        
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
        
        pepLoanApplicationController.wrapperAnswer objWrapAns1 = new  pepLoanApplicationController.wrapperAnswer();
        objWrapAns1.objCmsAnswer=objAnswer1;
        pepLoanApplicationController.wrapperAnswer objWrapAns2 = new  pepLoanApplicationController.wrapperAnswer();
        objWrapAns2.objCmsAnswer=objAnswer2;
        pepLoanApplicationController.wrapperAnswer objWrapAns3 = new  pepLoanApplicationController.wrapperAnswer();
        objWrapAns3.objCmsAnswer=objAnswer3;
        pepLoanApplicationController.wrapperAnswer objWrapAns4 = new  pepLoanApplicationController.wrapperAnswer();
        objWrapAns4.objCmsAnswer=objAnswer4;
        pepLoanApplicationController.wrapperAnswer objWrapAns5 = new  pepLoanApplicationController.wrapperAnswer();
        objWrapAns5.objCmsAnswer=objAnswer5;     
        pepLoanApplicationController.wrapperAnswer objWrapAns6 = new  pepLoanApplicationController.wrapperAnswer();
        objWrapAns6.objCmsAnswer=objAnswer6;
        
        //WrapperApplication
        
        pepLoanApplicationController.wrapperApplication objWrapApp1 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp1.objQuestion= objQuestion1;
        objWrapApp1.stranswer=String.valueof(objClPurpose.id);
        objWrapApp1.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp1.lstExpectedAnswers.add(objWrapAns1);
        
        pepLoanApplicationController.wrapperApplication objWrapApp2 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp2.objQuestion= objQuestion2;
        objWrapApp2.stranswer='12345';
        objWrapApp2.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp2.lstExpectedAnswers.add(objWrapAns2);
        
        pepLoanApplicationController.wrapperApplication objWrapApp3 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp3.objQuestion= objQuestion3;
        objWrapApp3.stranswer='2';
        objWrapApp3.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp3.lstExpectedAnswers.add(objWrapAns3);
        
        pepLoanApplicationController.wrapperApplication objWrapApp4 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp4.objQuestion= objQuestion4;
        objWrapApp4.stranswer='WEEKLY';
        objWrapApp4.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp4.lstExpectedAnswers.add(objWrapAns4);
        
        pepLoanApplicationController.wrapperApplication objWrapApp5 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp5.objQuestion= objQuestion5;
        objWrapApp5.stranswer='good';
        objWrapApp5.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp5.lstExpectedAnswers.add(objWrapAns5);
        
        pepLoanApplicationController.wrapperApplication objWrapApp6 = new  pepLoanApplicationController.wrapperApplication();
        objWrapApp6.objQuestion= objQuestion6;
        objWrapApp6.stranswer=String.valueof(objClProduct.id);
        objWrapApp6.lstExpectedAnswers=new List<pepLoanApplicationController.wrapperAnswer>();
        objWrapApp6.lstExpectedAnswers.add(objWrapAns6);
        
        //WrapSection
        List<pepLoanApplicationController.wrapperSection> wrappersectionlist = new List<pepLoanApplicationController.wrapperSection>();
        pepLoanApplicationController.wrapperSection objWrapSection = new  pepLoanApplicationController.wrapperSection();
        objWrapSection.objSection= objSection1;
        objWrapSection.lstWrapperQuestion = new List<pepLoanApplicationController.wrapperApplication>();
        objWrapSection.lstWrapperQuestion.add(objWrapApp1);
        objWrapSection.lstWrapperQuestion.add(objWrapApp2);
        objWrapSection.lstWrapperQuestion.add(objWrapApp3);
        objWrapSection.lstWrapperQuestion.add(objWrapApp4);
        objWrapSection.lstWrapperQuestion.add(objWrapApp5);
        objWrapSection.lstWrapperQuestion.add(objWrapApp6);
        wrappersectionlist.add(objWrapSection);
        
        //pageReference
        
        PageReference pageRef = Page.peplandingpage;
        Test.setCurrentPagereference(pageRef);
        
        //CustomSetting
        
        List<pages_config__c> objpageConfig = new List<pages_config__c>();
        objpageConfig = pepCommonTrackerController.createPagesConfig();
        
        pepDefaultCompany__c  objDefaultCompany = new pepDefaultCompany__c();
        objDefaultCompany = pepCommonTrackerController.createPageDefaultCompany();
        
        //instanceLoanApplication
        genesis.TestHelper testobj = new genesis.TestHelper();
        testobj.createDefaultOrgParameters();
        
        Application__c pepApplication =pepCommonTrackerController.createApplication();
        pepApplication.Name= 'pepIncomePage';
        pepApplication.Navigation_Status__c='Income';
        pepApplication.RedirectPage__c='pepIncomePage';
        Update pepApplication;
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication.Requested_Term__c=12.10;
        objApplication.Debit_Frequency__c='BI-WEEKLY';
        objApplication = genesis.TestHelper.createApplication();
       
        Pagereference pd=Page.pepincomepage;
        Test.setcurrentPagereference(pd);
        Cookie ApplicationId=new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{ApplicationId});
        
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', 'test');
        apexpages.currentpage().getparameters().put('redirectFromPageNo' , '1');
        
        pepLoanApplicationController objPep =new pepLoanApplicationController();
        
        objPep.lstWrapperSection=wrappersectionlist;
        objPep.intRequestedTerm=12;
        objPep.IntcookiePageNo=9;
        objPep.A='Test';
        objPep.purposeName='Test';
        objPep.pageName='Apply Page';
        objPep.sectionName='Test';
        objPep.intPreviousPageNumber=1;
        pages_config__c objCOnfig = new pages_config__c();
        objConfig.name='pepretrieveapp';
        objConfig.Page_Label__c ='pepretrieveapp';
        insert objConfig; 
        //ApplyNow
        objPep.ApplyNow();
        objPep.FilterValues();
        objPep.fetchAllRateCard();
        objPep.decMinLoanAmount=11.20;
        objPep.decmaxLoanAmount=12.20;
        objPep.fetchAllRateCard();
        objPep.BackOnLandingPage();
        objPep.BackOnApplyPage();
        objPep.retrieveAppCode();
        objPep.getCookieData();
        objPep.objApplication = objApplication;
        objPep.ContinueOnIncomePage();
        pepLoanApplicationController.checkCookieAndRedirect();
        
        objPep.fetchApplication();
        objPep.decLoanAmount=12.10;
        objPep.strSectionStory='{loanAmount}';
        objPep.renderSectionStory();
        //objPep.ContinueApply();       
        //objPep.createDummyAccount();
        objPep.clearcookies();
        apexpages.currentpage().getparameters().put('text' , 'Help');
        apexpages.currentpage().getparameters().put('rowIndex' , '1');
        objPep.test();
        
        test.stoptest();
    }
}
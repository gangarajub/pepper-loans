@isTest(SeeAllData=False)
Public Class pepCMSModelContainer_New_Tracker{
    Static pepCmsSection__c Employmentsection;
    Static pepCmsPage__c objPage;
    
    public testmethod static void test1(){
        
        pepCMSModelContainer_New objContainer = new pepCMSModelContainer_New();
        pepCMSModelContainer_New.wrapSection objWrapSection = new pepCMSModelContainer_New.wrapSection();
        objWrapSection.objCmsSection.pepSectionBodyRich__c = 'abcd';
        objWrapSection.showError = false;
        objWrapSection.errorMessage = 'test Message';
        objWrapSection.strSectionStory = 'test';
        objWrapSection.isRenderSectionStory = true;
        String helpText = objWrapSection.getHelpText();
        
        //Test for WrapAnswer class
		pepCMSModelContainer_New.wrapAnswer objAns = new pepCMSModelContainer_New.wrapAnswer();
		pepCMSModelContainer_New.wrapAnswer objAns1 = new pepCMSModelContainer_New.wrapAnswer(new pepCmsAnswer__c());
        objContainer.Accountid = null;
        objContainer.strPageName = 'testPage';
        System.assertEquals('abcd', helpText);
    }
    
    public static testMethod void wrapQuestionTest() {
        //Test for wrapQuestion
        pepCMSModelContainer_New.wrapQuestion objQues =  new pepCMSModelContainer_New.wrapQuestion();
        
        pepCmsQuestion__c cmsQues = new pepCmsQuestion__c();
        cmsQues.pepLabelPriorQuestion__c = 'testQuestion';
        insert cmsQues;
        
        List<pepCmsAnswer__c> lstAnswers = new List<pepCmsAnswer__c>();
        pepCmsAnswer__c objCMSAns1 = new pepCmsAnswer__c(pepDisplayText__c='Choose one');
    	objCMSAns1.pepCmsQuestion__c = cmsQues.Id;
        pepCmsAnswer__c objCMSAns2 = new pepCmsAnswer__c(pepDisplayText__c='textvalue');
        objCMSAns2.pepCmsQuestion__c = cmsQues.Id;
        lstAnswers.add(objCMSAns1);
        lstAnswers.add(objCMSAns2);
        insert lstAnswers;
        
        List<pepCmsQuestion__c> lstQuestions 
            = [Select Name, pepLabelPriorQuestion__c, (Select Id, pepDisplayText__c, pepHasDependentQuestions__c
              from pepCmsAnswer__r) from pepCmsQuestion__c
              Where Id=:cmsQues.Id];
               
        pepCMSModelContainer_New.wrapQuestion objQues1 =  new pepCMSModelContainer_New.wrapQuestion(lstQuestions[0], null);
        objQues1.actualvalue = objCMSAns2.Id;
        System.debug(objQues1.actualvalue);
        System.debug(objQues1.handleRerender);
        objQues1.strGAPIAddress = '177:apv:ass:fg:as:3022';
        objQues1.handlererenderonButton = true;
        objQues1.checkboxHandler = false;
        System.assertEquals(false, objQues1.lstOptions.isEmpty());
    }
    
    public static testMethod void fetchDataToInputValueTest() {
        
        pepCMSModelContainer_New objContainer = new pepCMSModelContainer_New();
        objContainer.objAccount = new Account(Date_of_Death__c = System.today(), CRM_Mtg_Data_Synced__c = true);
        objContainer.objApplication = new genesis__Applications__c(genesis__Loan_Amount__c = 14000, pepCheckProvideDVSAuthorization__c = true);
        
        objContainer.lstIncome.add(new Income__c(Sequence__c=1, Gross_Income__c = 1000));
        objContainer.lstEmploymentInformation.add(new genesis__Employment_Information__c(Sequence__c=1, pepCompany_Address__c ='test address'));
        
        Residential_Address__c objResidential = pepCommonTrackerController.createResidential();
        Residential_Address__c objResidential1 = pepCommonTrackerController.createResidential();
        objResidential1.Unit_Number__c = '177';
        objResidential1.Current_Address__c = false;
        update objResidential1;
        objContainer.lstResidentialAddress.add(objResidential);
        objContainer.lstResidentialAddress.add(objResidential1);
        
        //Section 
        pepCMSModelContainer_New.wrapSection sectionObj = new pepCMSModelContainer_New.wrapSection();
        pepCMSModelContainer_New.wrapQuestion objQuesWrap = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap.objCmsQuestion.pepSObjectApiName__c = 'Income__c';
        objQuesWrap.objCmsQuestion.pepRecordSequence__c =1;
        objQuesWrap.objCmsQuestion.pepFieldApiName__c = 'Gross_Income__c';
        sectionObj.lseQuestions.add(objQuesWrap);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap1 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap1.objCmsQuestion.pepSObjectApiName__c = 'genesis__Applications__c';
        objQuesWrap1.objCmsQuestion.pepFieldApiName__c ='genesis__Loan_Amount__c';
        sectionObj.lseQuestions.add(objQuesWrap1);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap2 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap2.objCmsQuestion.pepSObjectApiName__c = 'Account';
        objQuesWrap2.objCmsQuestion.pepFieldApiName__c ='Date_of_Death__c';
        objQuesWrap2.objCmsQuestion.pepType__c = 'Date';
        sectionObj.lseQuestions.add(objQuesWrap2);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap3 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap3.objCmsQuestion.pepSObjectApiName__c = 'Account';
        objQuesWrap3.objCmsQuestion.pepFieldApiName__c ='CRM_Mtg_Data_Synced__c';
        objQuesWrap3.objCmsQuestion.pepType__c = 'Checkbox';
         objQuesWrap3.objCmsQuestion.pepRecordSequence__c = 1;
        sectionObj.lseQuestions.add(objQuesWrap3);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap4 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap4.objCmsQuestion.pepSObjectApiName__c = 'genesis__Employment_Information__c';
        objQuesWrap4.objCmsQuestion.pepFieldApiName__c ='pepCompany_Address__c';
        objQuesWrap4.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap4.objCmsQuestion.pepRecordSequence__c = 1;
        sectionObj.lseQuestions.add(objQuesWrap4);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap5 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap5.objCmsQuestion.pepSObjectApiName__c = 'Residential_Address__c';
        objQuesWrap5.objCmsQuestion.pepFieldApiName__c ='Address__c';
        objQuesWrap5.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap5.objCmsQuestion.pepRecordSequence__c = 1;
        sectionObj.lseQuestions.add(objQuesWrap5);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap6 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap6.objCmsQuestion.pepSObjectApiName__c = 'Residential_Address__c';
        objQuesWrap6.objCmsQuestion.pepFieldApiName__c ='Address__c';
        objQuesWrap6.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap6.objCmsQuestion.pepRecordSequence__c = 2;
        sectionObj.lseQuestions.add(objQuesWrap6);
		
		pepCMSModelContainer_New.wrapQuestion objQuesWrap7 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap7.objCmsQuestion.pepSObjectApiName__c = 'Residential_Address__c';
        objQuesWrap7.objCmsQuestion.pepFieldApiName__c ='Unit_Number__c';
        objQuesWrap7.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap7.objCmsQuestion.pepRecordSequence__c = 2;
        sectionObj.lseQuestions.add(objQuesWrap7);  
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap8 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap8.objCmsQuestion.pepType__c = 'Button';
        objQuesWrap8.objCmsQuestion.pepRecordSequence__c = 1;
        objQuesWrap8.lstExpectedAnswers.add(new pepCMSModelContainer_New.wrapAnswer());
        sectionObj.lseQuestions.add(objQuesWrap8);
        
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap1_1 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap1_1.objCmsQuestion.pepSObjectApiName__c = 'genesis__Applications__c';
        objQuesWrap1_1.objCmsQuestion.pepFieldApiName__c ='pepCheckProvideDVSAuthorization__c';
        objQuesWrap1_1.objCmsQuestion.pepRecordSequence__c = 1;
            
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap7);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap6);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap5);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap4);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap3);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap2);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap1_1);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap8);
				
        
		objContainer.lstSection.add(sectionObj);        
        objContainer.fetchDataToInputValue();
        System.assertEquals('testArea', objQuesWrap5.objInputValue);
    }
    
    public static testMethod void saveInputValuesToFieldsTest() {
        
        pepCMSModelContainer_New objContainer = new pepCMSModelContainer_New();
        
        //Section 
        pepCMSModelContainer_New.wrapSection sectionObj = new pepCMSModelContainer_New.wrapSection();
        pepCMSModelContainer_New.wrapQuestion objQuesWrap = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap.objCmsQuestion.pepSObjectApiName__c = 'Income__c';
        objQuesWrap.objCmsQuestion.pepRecordSequence__c =1;
        objQuesWrap.objCmsQuestion.pepFieldApiName__c = 'Gross_Income__c';
        sectionObj.lseQuestions.add(objQuesWrap);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap_1 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap_1.objCmsQuestion.pepSObjectApiName__c = 'Income__c';
        objQuesWrap_1.objCmsQuestion.pepRecordSequence__c =5;
        objQuesWrap_1.objCmsQuestion.pepFieldApiName__c = 'Gross_Income__c';
        sectionObj.lseQuestions.add(objQuesWrap_1);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap1 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap1.objCmsQuestion.pepSObjectApiName__c = 'genesis__Applications__c';
        objQuesWrap1.objCmsQuestion.pepFieldApiName__c ='genesis__Loan_Amount__c';
        sectionObj.lseQuestions.add(objQuesWrap1);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap2 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap2.objCmsQuestion.pepSObjectApiName__c = 'Account';
        objQuesWrap2.objCmsQuestion.pepFieldApiName__c ='Date_of_Death__c';
        objQuesWrap2.objCmsQuestion.pepType__c = 'Date';
        sectionObj.lseQuestions.add(objQuesWrap2);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap3 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap3.objCmsQuestion.pepSObjectApiName__c = 'Account';
        objQuesWrap3.objCmsQuestion.pepFieldApiName__c ='CRM_Mtg_Data_Synced__c';
        objQuesWrap3.objCmsQuestion.pepType__c = 'Checkbox';
         objQuesWrap3.objCmsQuestion.pepRecordSequence__c = 1;
        sectionObj.lseQuestions.add(objQuesWrap3);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap4 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap4.objCmsQuestion.pepSObjectApiName__c = 'genesis__Employment_Information__c';
        objQuesWrap4.objCmsQuestion.pepFieldApiName__c ='pepCompany_Address__c';
        objQuesWrap4.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap4.objCmsQuestion.pepRecordSequence__c = 1;
        sectionObj.lseQuestions.add(objQuesWrap4);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap4_1 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap4_1.objCmsQuestion.pepSObjectApiName__c = 'genesis__Employment_Information__c';
        objQuesWrap4_1.objCmsQuestion.pepFieldApiName__c ='Employment_Status__c';
        objQuesWrap4_1.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap4_1.objCmsQuestion.pepRecordSequence__c = 1;
        sectionObj.lseQuestions.add(objQuesWrap4_1);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap5 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap5.objCmsQuestion.pepSObjectApiName__c = 'Residential_Address__c';
        objQuesWrap5.objCmsQuestion.pepFieldApiName__c ='Address__c';
        objQuesWrap5.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap5.objCmsQuestion.pepRecordSequence__c = 1;
        objQuesWrap5.objInputValue = '1:177:Pacific:Hwy:MACLEAN:NSW:Australia:2463';
        objQuesWrap5.strGAPIAddress = '1:177:Pacific:Hwy:MACLEAN:NSW:Australia:2463';
        sectionObj.lseQuestions.add(objQuesWrap5);
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap6 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap6.objCmsQuestion.pepSObjectApiName__c = 'Residential_Address__c';
        objQuesWrap6.objCmsQuestion.pepFieldApiName__c ='Address__c';
        objQuesWrap6.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap6.objCmsQuestion.pepRecordSequence__c = 2;
        sectionObj.lseQuestions.add(objQuesWrap6);
		
		pepCMSModelContainer_New.wrapQuestion objQuesWrap7 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap7.objCmsQuestion.pepSObjectApiName__c = 'Residential_Address__c';
        objQuesWrap7.objCmsQuestion.pepFieldApiName__c ='Unit_Number__c';
        objQuesWrap7.objCmsQuestion.pepType__c = 'Text';
        objQuesWrap7.objCmsQuestion.pepRecordSequence__c = 2;
        sectionObj.lseQuestions.add(objQuesWrap7);  
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap8 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap8.objCmsQuestion.pepType__c = 'Button';
        objQuesWrap8.objCmsQuestion.pepRecordSequence__c = 1;
        objQuesWrap8.lstExpectedAnswers.add(new pepCMSModelContainer_New.wrapAnswer());
        sectionObj.lseQuestions.add(objQuesWrap8);
        
        
        pepCMSModelContainer_New.wrapQuestion objQuesWrap1_1 = new pepCMSModelContainer_New.wrapQuestion();
        objQuesWrap1_1.objCmsQuestion.pepSObjectApiName__c = 'genesis__Applications__c';
        objQuesWrap1_1.objCmsQuestion.pepFieldApiName__c ='pepCheckProvideDVSAuthorization__c';
        objQuesWrap1_1.objCmsQuestion.pepRecordSequence__c = 1;
            
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap7);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap6);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap5);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap4);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap3);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap2);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap1_1);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap);
        objQuesWrap8.lstSiblingQuestions.add(objQuesWrap8);
        
		objContainer.lstSection.add(sectionObj); 
        //first call without account, residentail address, and employment information
        objContainer.objApplication = null;
        objContainer.objAccount = null;
        objContainer.saveInputValuesToFields();
        
        Account objAccount= pepCommonTrackerController.createAccount();
        objAccount.CRM_Mtg_Data_Synced__c = true;
        objAccount.Date_of_Death__c = System.today().addMonths(20);
        update objAccount;
        pepCMSModelContainer_New.lstAppAccount = null;
        objContainer.objAccount =objAccount;
        objContainer.objApplication = new genesis__Applications__c(genesis__Loan_Amount__c = 14000, pepCheckProvideDVSAuthorization__c = true, genesis__Account__c=objAccount.Id);
        
        objContainer.lstIncome.add(new Income__c(Sequence__c=1, Gross_Income__c = 1000));
        objContainer.lstEmploymentInformation.add(new genesis__Employment_Information__c(Sequence__c=1, pepCompany_Address__c ='test address', Employment_Status__c = 'Self Employed'));
        
        Residential_Address__c objResidential = pepCommonTrackerController.createResidential();
        Residential_Address__c objResidential1 = pepCommonTrackerController.createResidential();
        objResidential1.Unit_Number__c = '177';
        objResidential1.Current_Address__c = false;
        update objResidential1;
        
        objContainer.lstResidentialAddress.add(objResidential);
        objContainer.lstResidentialAddress.add(objResidential1);
        
        //calling with instance of Account, genessis Application, residential Address and Employment Information
        objContainer.saveInputValuesToFields();
        objResidential.Account__c = objAccount.Id;
        update objResidential;
        objContainer.checkAccount(objAccount.Id);
        
        System.assertEquals('1 177 Pacific Hwy MACLEAN,NSW,Australia,2463', objQuesWrap5.objInputValue);
    }

    public static testMethod void updateIncomeTest() {
        
        pepCMSModelContainer_New objContainer = new pepCMSModelContainer_New();
        
        pepCMSModelContainer_New.wrapQuestion objWrapQ = new pepCMSModelContainer_New.wrapQuestion();
        objWrapQ.objCmsQuestion.pepType__c = 'Currency';
        objWrapQ.objInputValue = '22,23.00';
        objWrapQ.objCmsQuestion.pepFieldApiName__c = 'Total_Monthly_Expense_Exc_Mortgage__c';
        genesis__Applications__c objApplication = new genesis__Applications__c();
        
        objContainer.updateIncome(objWrapQ, objApplication);
        
        pepCmsAnswer__c objAns = new pepCmsAnswer__c(Name='testAnswer', pepActualValue__c='2');
        insert objAns;
        pepCmsAnswer__c objAns1 = new pepCmsAnswer__c(Name='testAnswer1', pepActualValue__c='2');
        insert objAns1;
        
        pepCMSModelContainer_New.wrapQuestion objWrapQ1 = new pepCMSModelContainer_New.wrapQuestion();
        objWrapQ1.objCmsQuestion.pepType__c = 'Picklist';
        objWrapQ1.lstExpectedAnswers.add(new pepCMSModelContainer_New.wrapAnswer(objAns));
        objWrapQ1.objInputValue = objAns.Id;
        objWrapQ1.objCmsQuestion.pepFieldApiName__c = 'Number_of_Dependants__c';
        
        pepCMSModelContainer_New.wrapQuestion objWrapQ2 = new pepCMSModelContainer_New.wrapQuestion();
        objWrapQ2.objCmsQuestion.pepType__c = 'Picklist';
        objWrapQ2.lstExpectedAnswers.add(new pepCMSModelContainer_New.wrapAnswer(objAns1));
        objWrapQ2.objInputValue = objAns1.Id;
        objWrapQ2.objCmsQuestion.pepFieldApiName__c = 'CRM_Mtg_Accreditation_Status__c';
        
        pepCMSModelContainer_New.wrapQuestion objWrapQ3 = new pepCMSModelContainer_New.wrapQuestion();
        objWrapQ3.objCmsQuestion.pepType__c = 'Date';
        objWrapQ3.objInputValue = '10/10/2017';
        objWrapQ3.objCmsQuestion.pepFieldApiName__c = 'CRM_Aggregator_Introducer_Relation_Date__c';
        
        pepCMSModelContainer_New.wrapQuestion objWrapQ4 = new pepCMSModelContainer_New.wrapQuestion();
        objWrapQ4.objCmsQuestion.pepType__c = 'Date';
        objWrapQ4.objInputValue = '10-10-2017';
        objWrapQ4.objCmsQuestion.pepFieldApiName__c = 'CRM_Aggregator_Introducer_Relation_Date__c';
        
        pepCMSModelContainer_New.wrapQuestion objWrapQ5 = new pepCMSModelContainer_New.wrapQuestion();
        objWrapQ5.objCmsQuestion.pepType__c = 'Text';
        objWrapQ5.objInputValue = '';
        objWrapQ5.objCmsQuestion.pepFieldApiName__c = 'PersonHomePhone';
        
                
        pepCMSModelContainer_New.wrapQuestion objWrapQ7 = new pepCMSModelContainer_New.wrapQuestion();
        objWrapQ7.checkboxHandler = true;
        objWrapQ7.objCmsQuestion.pepFieldApiName__c = 'pepCheckProvideDVSAuthorization__c';
        
        Account objAccount = new Account();
        objContainer.updateIncome(objWrapQ1, objAccount);
        objContainer.updateIncome(objWrapQ2, objAccount);
        objContainer.updateIncome(objWrapQ3, objAccount);
        objContainer.updateIncome(objWrapQ4, objAccount);
        objContainer.updateIncome(objWrapQ5, objAccount);
        objContainer.retrieveAppChecker = false;

        objApplication = (genesis__Applications__c)objContainer.updateIncome(objWrapQ7, objApplication);
        System.assertEquals(true, objApplication.pepCheckProvideDVSAuthorization__c);
        
    }
    
}
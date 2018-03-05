@isTest(SeeAllData=false)
Private class pepCmsModelContainerTracker
{

    private static pepCmsPage__c objPage;
    private Static pepCmsSection__c objCmsSection;
    static pepCmsQuestion__c objQuestion;
    static pepCmsQuestion__c objSibQuestion;
    static pepCmsAnswer__c objAnswer; 
    static genesis__Applications__c objApplication;
    static Income__c objIncome;
    static Expense_and_Debt__c objExpense;
    
    
    
     private static void createExpense()
     {
         objExpense = new Expense_and_Debt__c ();
         objExpense.Application__c =objApplication.id;
         objExpense.Expense_Debt_Value__c =7000;
         //objExpense.Frequency__c = 'weekly';
         insert objExpense;
     }    
    
    static void createPage()
    {
        objPage = pepCommonTrackerController.createPage('Income Details');
    }
    
    static void createSection()
    {
        objCmsSection = new pepCmsSection__c();
        objCmsSection.pepPage__c = objPage.id;
        objCmsSection.pepSectionUniqueName__c = 'Income Details';
        objCmsSection.pepType__c='Form';
        objCmsSection.pepSequence__c=1;
        insert objCmsSection;
    
    }
    
    static void createQuestion()
    {
        objQuestion= new pepCmsQuestion__c();
        objQuestion.pepSection__c = objCmsSection.id;
        objQuestion.pepPage__c=objPage.id;
        objQuestion.pepLabelPriorQuestion__c='Do you earn other income?';     
        insert objQuestion;
        
    }
    static void createSiblingQuestion()
    {
        objSibQuestion= new pepCmsQuestion__c();
        objSibQuestion.pepSection__c = objCmsSection.id;
        objSibQuestion.pepPage__c=objPage.id;
        objSibQuestion.pepQuestion__c =objQuestion.id;
        objSibQuestion.pepLabelPriorQuestion__c='Do you earn other income?';     
        insert objSibQuestion;
        
    }
    
    Static void createAnswer()
    {
        objAnswer= new pepCmsAnswer__c ();   
        objAnswer.Name='No';
        objAnswer.pepCmsQuestion__c=objQuestion.id;
        objAnswer.pepActualValue__c='No';
        objAnswer.pepDisplayText__c='No';
        insert objAnswer;
    }

    static void createApplication()
    {
         RetrieveCode__c objRetrieveCode1 = pepCommonTrackerController.createRetrieveCode();
         objApplication = genesis.TestHelper.createApplication();
    } 
    
    static void createIncome()
    {
        objIncome = new Income__c();
        objIncome.Application__c=objApplication.id;
        objIncome.Gross_Income__c=123456;
        objincome.Frequency__c='weekly';
        objincome.Sequence__c=1;
        insert objincome;
    }
    static void loadData()
    {
        createPage();
        createSection();
        createQuestion();
        createSiblingQuestion();
        createAnswer();
        createApplication();
        createIncome();
        createExpense();
        
        
    }
    static testmethod void unitTest1()
    {
        loadData();
       
        pepCmsModelContainer objModelContainer = new pepCmsModelContainer();
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion = new pepCmsModelContainer.wrapperQuestion();
        pepCmsModelContainer.wrapperAnswer objWrapAnswer = new pepCmsModelContainer.wrapperAnswer(objAnswer);        
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion1 = new pepCmsModelContainer.wrapperQuestion(objQuestion,'no');
        objWrapperQuestion1.lstSiblingQuestion = new List<pepCmsModelContainer.wrapperQuestion>();
        objWrapperQuestion1.lstSiblingQuestion.add(objWrapperQuestion1 );
        objModelContainer.strPageName ='Income Details';
        objModelContainer.strSectionName ='Income Details';
        objModelContainer.lstWrapperQuestion  = new List<pepCmsModelContainer.wrapperQuestion >();
        objModelContainer.lstWrapperQuestion.add(objWrapperQuestion1);
         
        objWrapperQuestion1.lstAnswersQuestions = new List<pepCmsModelContainer.wrapperQuestion>();        
        objWrapperQuestion1.lstAnswersQuestions.add(objWrapperQuestion1);
        objModelContainer.ReadControlValue();
    }
    static testmethod void unitTest2()
    {
        loadData();
        objQuestion.pepSObjectApiName__c ='genesis__Applications__c';
        objQuestion.pepFieldApiName__c ='genesis__Status__c';
        update objQuestion;
        pepCmsModelContainer objModelContainer = new pepCmsModelContainer();
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion = new pepCmsModelContainer.wrapperQuestion();
        pepCmsModelContainer.wrapperAnswer objWrapAnswer = new pepCmsModelContainer.wrapperAnswer(objAnswer);
        
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion1 = new pepCmsModelContainer.wrapperQuestion(objQuestion,'no');
        objWrapperQuestion1.lstSiblingQuestion = new List<pepCmsModelContainer.wrapperQuestion>();
        objWrapperQuestion1.lstSiblingQuestion.add(objWrapperQuestion1 );
        objModelContainer.strPageName ='Income Details1';
        objModelContainer.strSectionName ='Income Details';
        objModelContainer.lstWrapperQuestion  = new List<pepCmsModelContainer.wrapperQuestion >();
        objModelContainer.lstWrapperQuestion.add(objWrapperQuestion1);
        objModelContainer.ReadControlValue();
    }
    
    static testmethod void unitTest3()
    {
        loadData();
        objQuestion.pepSObjectApiName__c ='Account';
        objQuestion.pepFieldApiName__c ='Name';
       // objQuestion.pepType__c ='Picklist';
        update objQuestion;
        pepCmsModelContainer objModelContainer = new pepCmsModelContainer();
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion = new pepCmsModelContainer.wrapperQuestion();
        pepCmsModelContainer.wrapperAnswer objWrapAnswer = new pepCmsModelContainer.wrapperAnswer(objAnswer);
        
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion1 = new pepCmsModelContainer.wrapperQuestion(objQuestion,'no');
        pepCmsModelContainer.wrapperQuestion objWrapperSibQuestion = new pepCmsModelContainer.wrapperQuestion(objSibQuestion,'no');
        objWrapperQuestion1.lstSiblingQuestion = new List<pepCmsModelContainer.wrapperQuestion>();
        objWrapperQuestion1.lstSiblingQuestion.add(objWrapperSibQuestion);
        objWrapperQuestion1 .objInputValue ='89';
        objModelContainer.strPageName ='Income Details1';
        objModelContainer.strSectionName ='Income Details';
        objModelContainer.lstWrapperQuestion  = new List<pepCmsModelContainer.wrapperQuestion >();
        objModelContainer.lstWrapperQuestion.add(objWrapperQuestion1);
        objModelContainer.ReadControlValue();
        objModelContainer.lstExpenses = new List<Expense_and_Debt__c>();
        objModelContainer.lstExpenses.add(objExpense);
        Residential_Address__c rdd = pepCommonTrackerController.createResidential();
        genesis__Employment_Information__c  objEMP = pepCommonTrackerController.employmentInformation();
        objModelContainer.lstEmploymentInformation = new List<genesis__Employment_Information__c>();
        objModelContainer.lstEmploymentInformation.add(objEMP );
        objQuestion.pepType__c ='currency';
        update objQuestion;
        
        objModelContainer.lstResidentialAddress.add(rdd);
        objModelContainer.functionToReadValueForObjects();
        
        objModelContainer.lstResidentialAddress= null;
        objModelContainer.functionToReadValueForObjects();
        
    }
    
    static testmethod void unitTest4()
    {
        loadData();
        objQuestion.pepSObjectApiName__c ='Account';
        objQuestion.pepFieldApiName__c ='Name';
        //objQuestion.pepType__c ='Picklist';
       // update objQuestion;
        pepCmsModelContainer objModelContainer = new pepCmsModelContainer();
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion = new pepCmsModelContainer.wrapperQuestion();
        pepCmsModelContainer.wrapperAnswer objWrapAnswer = new pepCmsModelContainer.wrapperAnswer(objAnswer);
        
        pepCmsModelContainer.wrapperQuestion objWrapperQuestion1 = new pepCmsModelContainer.wrapperQuestion(objQuestion,'no');
        objSibQuestion.pepType__c='currency';
        update objSibQuestion;
        pepCmsModelContainer.wrapperQuestion objWrapperSibQuestion = new pepCmsModelContainer.wrapperQuestion(objSibQuestion,'no');
        objSibQuestion.pepFieldApiName__c ='frequency__c';
        update objSibQuestion;
        objWrapperQuestion1.lstSiblingQuestion = new List<pepCmsModelContainer.wrapperQuestion>();
        objWrapperQuestion1.lstAnswersQuestions = new List<pepCmsModelContainer.wrapperQuestion>();
        objWrapperSibQuestion.objInputValue ='90';
        objWrapperQuestion1.lstSiblingQuestion.add(objWrapperSibQuestion);
        objWrapperQuestion1.lstAnswersQuestions.add(objWrapperSibQuestion);
        
        objWrapperQuestion1 .objInputValue ='89';
        objModelContainer.strPageName ='Income Details1';
        objModelContainer.strSectionName ='Income Details';
        objModelContainer.lstWrapperQuestion  = new List<pepCmsModelContainer.wrapperQuestion >();
        objModelContainer.lstWrapperQuestion.add(objWrapperQuestion1);
        objModelContainer.ReadControlValue();
        objModelContainer.lstExpenses = new List<Expense_and_Debt__c>();
        objModelContainer.lstExpenses.add(objExpense);
        Residential_Address__c rdd = pepCommonTrackerController.createResidential();        
        
        objModelContainer.lstResidentialAddress.add(rdd);
        objModelContainer.functionToReadValueForObjects();
        
    }
    
    

}
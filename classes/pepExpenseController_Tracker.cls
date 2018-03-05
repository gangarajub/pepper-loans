@isTest
private class pepExpenseController_Tracker 
{
    
    private static genesis__Applications__c objApplication;
    private static pages_config__c objConfig;
    private Static Income__c objIncome;
    private Static Expense_and_Debt__c objExpense;
    private static pepCmsPage__c objPage;
    private static pepCmsSection__c objSection;
    private static pepCmsQuestion__c objQues;
    private static pepCmsQuestion__c objSiblingQues;
    private static pepCmsQuestion__c objAnsQues;
    private static pepCmsAnswer__c objAnswer;
    
    private static pepCmsAnswer__c objSiblingAns;
    private static Application__c objNavigationCustomSettings;
    private static Affordability_Configuration__c objAffordabiltyConfiguration;
    private static pepCmsQuestion__c objQues1;
    private static pepCmsAnswer__c objAnswer1;
    private static pepCmsAnswer__c objAnswer11;
    private Static Expense_and_Debt__c objExpense111;
    
    private static void createPage()
    {
        objPage = new pepCmsPage__c();
        objPage =pepCommonTrackerController.createPage('Expenses');
        
    }
    
    private static void createNavigationStatus()
    {
        objNavigationCustomSettings = new Application__c ();
        objNavigationCustomSettings.name='pepExpensePage';
        objNavigationCustomSettings.Navigation_Status__c ='pepExpensePage';
        insert objNavigationCustomSettings;
        
    }
    
    private static void createAffordabiltyConfiguration()
    {
        objAffordabiltyConfiguration = new Affordability_Configuration__c ();
        objAffordabiltyConfiguration.name='Default';
        objAffordabiltyConfiguration.Revolving_Credit_Percent_As_Expense__c=0.03;
        objAffordabiltyConfiguration.DTI_Threshold__c=0.95;
        objAffordabiltyConfiguration.Rate_Buffer__c=100;
        objAffordabiltyConfiguration.Decrease_Loan_Amount_By__c=500;
        objAffordabiltyConfiguration.Active__c=true;
        objAffordabiltyConfiguration.Min_Loan_Amount_Percent__c=80;
        insert objAffordabiltyConfiguration;
    }
    private static  void createSection()
    {
        objSection = pepCommonTrackerController.createSection(objPage);
        objSection.pepSectionUniqueName__c='Your share of living expenses';
        objSection.pepSectionStory__c ='test';
        update objSection;
    }
    
    private static void createQuestion()
    {
        objQues = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objQues.pepFieldApiName__c ='Expense_Debt_Value__c';
        objQues.pepPage__c = objPage.id;
        objQues.pepType__c ='Currency';
        objQues.pepCMSAnswer__c = objAnswer11.id;
        update objques;
    }
    private static void createQuestion1()
    {
        objQues1 = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objQues1.pepFieldApiName__c ='Expense_Debt_Value__c';
        objQues1.pepPage__c = objPage.id;
        objQues1.pepType__c ='Currency';
        update objques1;
    }
    private static void createAnswer11()
    {
        objAnswer11 = new pepCmsAnswer__c ();
        objAnswer11.pepCmsQuestion__c =objQues1.id;         
        objAnswer11.pepDisplayText__c ='test';
        objAnswer11.Name ='test';         
        insert objAnswer11;
    }
    private static void createAnsQuestion()
    {
        objAnsQues = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objAnsQues.pepFieldApiName__c ='Expense_Debt_Value__c';
        objAnsQues.pepSObjectApiName__c ='Expense_and_Debt__c';
        objAnsQues.pepPage__c = objPage.id;
        objAnsQues.pepType__c ='Currency';
        objAnsQues.pepCMSAnswer__c = objAnswer.id;
        update objAnsQues ;
    }
    private static void createSiblingQuestion()
    {
        objSiblingQues = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objSiblingQues.pepFieldApiName__c ='Expense_Debt_Value__c';
        objSiblingQues.pepPage__c = objPage.id;
        objSiblingQues.pepType__c ='Currency';
        // objSiblingQues.pepSObjectApiName__c
        objSiblingQues.pepQuestion__c = objQues.id;
        update objSiblingQues ;
        
    }
    private static void createAnswer()
    {
        objAnswer = new pepCmsAnswer__c ();
        objAnswer.pepCmsQuestion__c =objQues.id;         
        objAnswer.pepDisplayText__c ='test';
        objAnswer.Name ='test';         
        insert objAnswer;
    }
    private static void createAnswer1()
    {
        objAnswer1 = new pepCmsAnswer__c ();
        objAnswer1.pepCmsQuestion__c =objQues.id;         
        objAnswer1.pepDisplayText__c ='test';
        objAnswer.Name ='test';         
        insert objAnswer;
    }
    
    private static void createSiblingAns()
    {
        objSiblingAns= new pepCmsAnswer__c ();
        objSiblingAns.pepCmsQuestion__c =objSiblingQues.id;         
        objSiblingAns.pepDisplayText__c ='test';
        objSiblingAns.Name ='test';         
        insert objSiblingAns;
    }
    
    private static void createApplication()
    {
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();      
        objApplication =genesis.TestHelper.createApplication();
        
    }
    
    private static void createPageConfig()
    {
        objConfig = new pages_config__c();
        objConfig.name='pepexpensepage';
        objConfig.page_label__c ='pepexpensepage';
        insert objConfig;
        
    }
    
    private static void createIncome()
    {
        
        objIncome = new Income__c();
        objIncome.Application__c = objApplication.id;
        objIncome.Frequency__c = 'weekly';
        objIncome.Gross_Income__c= 50000;
        insert objIncome;
    }
    
    private static void createExpense()
    {
        objExpense = new Expense_and_Debt__c ();
        objExpense.Application__c =objApplication.id;
        objExpense.Expense_Debt_Value__c =7000;
        //objExpense.Frequency__c = 'weekly';
        insert objExpense;
    }
    private static void createExpense111()
    {
        objExpense111 = new Expense_and_Debt__c ();
        objExpense111.Application__c =objApplication.id;
        objExpense111.Expense_Debt_Value__c =7000;
        //objExpense.Frequency__c = 'weekly';
        insert objExpense111;
    }
    
    static void loadData()
    {
        createPage();
        createSection();
        createQuestion1();
        createAnswer11();
        createQuestion();
        createSiblingQuestion();
        createAnswer();
        createAnsQuestion();
        // createSiblingAns();
        createApplication();
        createPageConfig();
        createIncome();
        createExpense();
        createNavigationStatus();
        createAffordabiltyConfiguration();
    }
    
    static testmethod void validateLivingExpense()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objExpense.Type__c ='Mortgage Expense';
        objExpense.Type_of_Expense_Debt__c='Living';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='Living';
        update objQues;
        
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController objController = new pepExpenseController();
        // objController.saveCallFromHeader();
        objController.createExpenseList();      
        objController.renderSectionStory1();
        objController.updateTotalmonthlyExpense();
        objController.saveCallFromHeader();
        try{
            objController.continueApplication();
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        
        objQues.pepFieldApiName__c = 'genesis__Applications__c';
        objQues.pepFieldApiName__c ='Total_Monthly_Expense__c';
        objQues.pepType__c='Percent';
        update objQues;
        objAnsQues.pepFieldApiName__c = 'genesis__Applications__c';
        objAnsQues.pepFieldApiName__c ='Total_Monthly_Expense__c';
        objAnsQues.pepType__c='Percent';
        update objQues;
        pepExpenseController objController1 = new pepExpenseController();
        objController1.createExpenseList();
        objController1.checkvalidation();
        objController1.renderSectionStory1();
        objController1.updateTotalmonthlyExpense();
        objController1.saveCallFromHeader();
        try{
            objController1.continueApplication();
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        System.assertEquals(null, objController.checkvalidation());
    }
    static testmethod void validateWhatYouowe()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objSection.pepSectionUniqueName__c='What you owe (debts)';
        update objSection;
        
        objExpense.Type__c ='Debt';
        objExpense.Type_of_Expense_Debt__c='test';
        update objExpense;
        objques.pepLabelPriorQuestion__c =null;
        update objQues;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        
        pepExpenseController objController = new pepExpenseController();
        try {
            objController.createExpenseList();
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        objController.SaveData =true;
        objController.isConsolidatingDebt = true;
        objController.checkvalidation();
        System.assertEquals(true, objController.basicvalidations());
        objController.renderSectionStory2();
        apexpages.currentpage().getparameters().put('text','hhh');
        apexpages.currentpage().getparameters().put('rowIndex','1');
        apexpages.currentpage().getparameters().put('QuesAnsrowIndex','1');
        objController.addRow();
        try {
            objController.callRelatedQuestionOfAnswers();
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        
    }
    
    static testmethod void validateWhatYouowe1()
    {
        pages_config__c objConfig = new pages_config__c();
        objConfig.Name = 'pepTechnicalException';
        objConfig.Page_Label__c = 'TechnicalException';
        insert objConfig;
        
        PageReference pageRef = Page.pepExpensePage;
        pageRef.getHeaders().put('X-Salesforce-SIP','1');
        pageRef.getParameters().put('redirectFromPageNo','1');
        Test.setCurrentPagereference(pageRef);
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objSection.pepSectionUniqueName__c='What you owe (debts)';
        update objSection;
        
        objExpense.Type__c ='Debt';
        objExpense.Type_of_Expense_Debt__c='Debt';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='Debt';
        
        update objQues;
        objApplication.pepCurrent_Page__c = 3;
        update objApplication;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter}); 
        createExpense111();        
        pepExpenseController objController = new pepExpenseController(); 
        objController.lstExpenseToDelete = new List<Expense_and_Debt__c>();
        objController.lstExpenseToDelete.add(objExpense111);
        objController.loadCMSDataForSection2();
        objController.addRow();  
        objController.removeRow();   
        objController.createExpenseList();
        objController.SaveData =true;
        objController.isConsolidatingDebt = true;
        try {
            objController.checkvalidation();
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        objController.basicvalidations();
        objController.renderSectionStory2();
        apexpages.currentpage().getparameters().put('text','hhh');
        apexpages.currentpage().getparameters().put('rowIndex','1');
        apexpages.currentpage().getparameters().put('QuesAnsrowIndex','1');
        objController.continueApplication();
        objController.addRow();
        objController.DebtRecordsNo =0;
        objController.callRelatedQuestionOfAnswers();
        System.assertEquals(null, objController.checkcookie());
        
    }
    
    static testmethod void validateHousehold()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objExpense.Type__c ='Household Expense';
        objExpense.Type_of_Expense_Debt__c='test';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='test';
        update objQues;
        objSection.pepSectionUniqueName__c='Household';
        update objSection;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController objController = new pepExpenseController();
        // objController.saveCallFromHeader();
        objController.createExpenseList();
        objController.checkvalidation();
        System.assertEquals(true, objController.isEdit);
        
    }
    
    static testmethod void validateFoodAndLiving()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objExpense.Type__c ='Food and Living Expense';
        objExpense.Type_of_Expense_Debt__c='test';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='test';
        update objQues;
        objSection.pepSectionUniqueName__c='Food and living';
        update objSection;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController objController = new pepExpenseController();
        //objController.saveCallFromHeader();
        objController.createExpenseList();
        objController.checkvalidation();
        System.assertEquals(true, objController.SaveData); 
    }
    
    static testmethod void validateEntertainment()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objExpense.Type__c ='Entertainment and Services Expense';
        objExpense.Type_of_Expense_Debt__c='test';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='test';
        update objQues;
        objSection.pepSectionUniqueName__c='Entertainment and services';
        update objSection;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController objController = new pepExpenseController();
        objController.saveCallFromHeader();
        objController.createExpenseList();
        objController.checkvalidation();
        System.assertEquals(true, objController.SaveData);
    }
    
    
    static testmethod void validateEducation()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objExpense.Type__c ='Education Expense';
        objExpense.Type_of_Expense_Debt__c='test';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='test';
        update objQues;
        objSection.pepSectionUniqueName__c='Education';
        update objSection;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController objController = new pepExpenseController();
        objController.saveCallFromHeader();
        objController.createExpenseList();
        objController.checkvalidation();
        System.assertEquals(true, objController.SaveData);
    }
    
    static testmethod void validateTransport()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        objExpense.Type__c ='Vehicle and Transport Expense';
        objExpense.Type_of_Expense_Debt__c='test';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='test';
        update objQues;
        objSection.pepSectionUniqueName__c='Vehicle and Transport';
        update objSection;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController objController = new pepExpenseController();
        // objController.saveCallFromHeader();
        objController.createExpenseList();
        objController.checkvalidation();
        System.assertEquals(true, objController.SaveData);
    }
    
    static testmethod void validateInsurance()
    {
        loan.testhelper.createSeedDataForTesting();
        loadData();
        Expense_and_Debt__c  objExpense1 = new Expense_and_Debt__c ();
        objExpense1.Application__c =objApplication.id;
        objExpense1.Expense_Debt_Value__c =7000;
        //objExpense.Frequency__c = 'weekly';
        insert objExpense1;
        objExpense.Type__c ='Insurance Expense';
        objExpense.Type_of_Expense_Debt__c='test';
        update objExpense;
        objques.pepLabelPriorQuestion__c ='test';
        update objQues;
        objSection.pepSectionUniqueName__c='Insurance';
        update objSection;
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController objController = new pepExpenseController();
        objController.saveCallFromHeader();
        objController.createExpenseList();
        objController.checkvalidation();
        objController.AssignOriginalValue();
        
        list<Expense_and_Debt__c> lst = new List<Expense_and_Debt__c>();
        lst.add(objExpense1);
        objController.lstExpenseToDelete=lst;
        // objController.continueApplication();
        System.assertEquals(true, objController.SaveData);
    }  
    static testmethod void test0(){
        loan.testhelper.createSeedDataForTesting();
        loadData(); 
        objQues.pepSObjectApiName__c='genesis__Applications__c';
        objQues.pepFieldApiName__c='Total_Monthly_Expense__c';      
        clcommon__CL_Purpose__c obj = pepCommonTrackerController.createClPurpose();
        obj.Is_Debt_Con__c=true;
        obj.Number_of_Debts__c=1;
        update obj;
        objApplication.genesis__CL_Purpose__c=obj.id;
        objApplication.Total_Monthly_Expense_Exc_Mortgage__c=400;
        update objApplication;
        list<Expense_and_Debt__c> lst = new List<Expense_and_Debt__c>();
        lst.add(objExpense);
        
        
        pages_config__c objConfig1 = new pages_config__c();
        objConfig1.name='peploandetails';
        objConfig1.page_label__c ='loandetails';
        insert objConfig1;
        
        pages_config__c objConfig11 = new pages_config__c();
        objConfig11.name='pepincomepage';
        objConfig11.page_label__c ='incomepage';
        insert objConfig11;
        
        Application__c objAppNav1 = new Application__c();
        objAppNav1.Name='pepLoanDetails';
        objAppNav1.Navigation_Status__c='LoanDetails';
        objAppNav1.RedirectPage__c='pepLoanDetails';
        insert objAppNav1;
        
        Application__c objAppNav = new Application__c();
        objAppNav.Name='pepIncomePage';
        objAppNav.Navigation_Status__c='Income';
        objAppNav.RedirectPage__c='pepIncomePage';
        insert objAppNav;
        
        Cookie counter = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        pepExpenseController o = new pepExpenseController();
        o.lstExpenseToDelete=lst;
        o.fetchApplication();
        o.createExpenseList();
        o.updateExpenseData();
        
        Expense_and_Debt__c  objExpense1 = new Expense_and_Debt__c ();
        objExpense1.Application__c =objApplication.id;
        objExpense1.Expense_Debt_Value__c =7000;
        objExpense.Frequency__c = 'weekly';
        insert objExpense1;
        list<Expense_and_Debt__c> lst1 = new List<Expense_and_Debt__c>();
        lst1.add(objExpense1);
        pepExpenseController o1 = new pepExpenseController();
        o1.lstExpenseToDelete=lst1;
        o1.pagetoredirect='1';
        o1.saveCallFromHeader();
        
        Expense_and_Debt__c  objExpense11 = new Expense_and_Debt__c ();
        objExpense11.Application__c =objApplication.id;
        objExpense11.Expense_Debt_Value__c =7000;
        objExpense.Frequency__c = 'weekly';
        insert objExpense11;
        list<Expense_and_Debt__c> lst11 = new List<Expense_and_Debt__c>();
        lst11.add(objExpense11);
        pepExpenseController o11 = new pepExpenseController();
        o11.lstExpenseToDelete=lst11;
        
        o11.pagetoredirect='2';
        PageReference nextPage = o11.saveCallFromHeader();
        
        
        objQues.pepFieldApiName__c = 'genesis__Applications__c';
        objQues.pepFieldApiName__c ='Total_Monthly_Expense__c';
        update objQues;
        o11.loadCMSDataForSection1();
        
        
        objQues.pepFieldApiName__c ='Percentage_of_Expense_Contribution__c';
        update objQues;
        o11.loadCMSDataForSection1();
        o11.str1 = 'hi';
        o11.amountAfterDebt = 22;
        o11.initialAmount = 2;
        o11.isdisplayServPositive =true;
        o11.isdisplayServNegative=true;
        System.assertEquals('/incomepage', nextPage.getUrl());
    }
    
    /**
    * @Created By : Sushant Kumar
    * @Date : 28/08/2016
    * @Description : This method is created for validation and increasing code coverage of 
    *                  basicValidation() method of pepExpenseController
    **/
    static testMethod void testBasicValidations() {
        
        pepExpenseController objController1 = new pepExpenseController('test');
        objController1.lstWrapperQuestionSection2 = new List<pepExpenseController.wrapperQuestion>();
        
        pepExpenseController objController2 = new pepExpenseController('test2');
        objController2.lstWrapperQuestionSection2 = new List<pepExpenseController.wrapperQuestion>();
        
        pepExpenseController.wrapperQuestion masterQuestion1 = new pepExpenseController.wrapperQuestion();
        masterQuestion1.lstAnswersQuestions = new List<pepExpenseController.wrapperQuestion>();
        
        pepExpenseController.wrapperQuestion masterQuestion2 = new pepExpenseController.wrapperQuestion();
        masterQuestion2.lstAnswersQuestions = new List<pepExpenseController.wrapperQuestion>();
        
        pepExpenseController.wrapperQuestion answerQuestion1 = new pepExpenseController.wrapperQuestion();
        pepCmsQuestion__c cmsQuesObj1 = new pepCmsQuestion__c();
        cmsQuesObj1.pepType__c = 'Text';
        cmsQuesObj1.pepFieldApiName__c = 'Amount_Remaining_as_Debt__c';
        answerQuestion1.objCmsQuestion = cmsQuesObj1;
        answerQuestion1.objinputValue = '123';
        
        pepExpenseController.wrapperQuestion answerQuestion11 = new pepExpenseController.wrapperQuestion();
        pepCmsQuestion__c cmsQuesObj11 = new pepCmsQuestion__c();
        cmsQuesObj11.pepType__c = 'Text';
        cmsQuesObj11.pepFieldApiName__c = 'Amount_Remaining_as_Debt__c';
        answerQuestion11.objCmsQuestion = cmsQuesObj11;
        answerQuestion11.objinputValue = '-12';
        
        pepExpenseController.wrapperQuestion answerQuestion2 = new pepExpenseController.wrapperQuestion();
        pepCmsQuestion__c cmsQuesObj2 = new pepCmsQuestion__c();
        cmsQuesObj2.pepType__c = 'Text';
        cmsQuesObj2.pepFieldApiName__c = 'Credit_Limit__c';
        answerQuestion2.objCmsQuestion = cmsQuesObj2;
        answerQuestion2.objinputValue = '123';
        
        pepExpenseController.wrapperQuestion answerQuestion21 = new pepExpenseController.wrapperQuestion();
        pepCmsQuestion__c cmsQuesObj21 = new pepCmsQuestion__c();
        cmsQuesObj21.pepType__c = 'Text';
        cmsQuesObj21.pepFieldApiName__c = 'Credit_Limit__c';
        answerQuestion21.objCmsQuestion = cmsQuesObj21;
        answerQuestion21.objinputValue = '-12';
        
        
        masterQuestion1.lstAnswersQuestions.add(answerQuestion1);
        masterQuestion1.lstAnswersQuestions.add(answerQuestion11);
        masterQuestion2.lstAnswersQuestions.add(answerQuestion2);
        masterQuestion2.lstAnswersQuestions.add(answerQuestion21);
        
        objController1.lstWrapperQuestionSection2.add(masterQuestion1);
        objController2.lstWrapperQuestionSection2.add(masterQuestion2);
        System.assertEquals(false, objController1.basicvalidations());
        System.assertEquals(false, objController2.basicvalidations());
    }
    
    public static testMethod void handleYesOrNoTest() {
        
        System.assertEquals('true', handleYesOrNoTestCase('yes'));
        System.assertEquals('false', handleYesOrNoTestCase('no'));
    }
    public static String handleYesOrNoTestCase(String text) {
        PageReference expensePage = new PageReference('apex/pepExpensePage');
        Test.setCurrentPage(expensePage);
        System.currentPageReference().getParameters().put('text', text);
        System.currentPageReference().getParameters().put('rowIndex','1');
        System.currentPageReference().getParameters().put('QuesAnsrowIndex', '1');
        pepExpenseController controllerObj = new pepExpenseController('test');
     	controllerObj.lstWrapperQuestionSection2 = new List<pepExpenseController.wrapperQuestion>();
        
        pepExpenseController.wrapperQuestion wrapperQuesObj = new pepExpenseController.wrapperQuestion();
        wrapperQuesObj.lstAnswersQuestions = new List<pepExpenseController.wrapperQuestion>();
        wrapperQuesObj.objCmsQuestion = new pepCmsQuestion__c();
        
        pepExpenseController.wrapperQuestion childwrapperQuesObj = new pepExpenseController.wrapperQuestion();
        childwrapperQuesObj.objCmsQuestion = new pepCmsQuestion__c();
        wrapperQuesObj.lstAnswersQuestions.add(childwrapperQuesObj);
        controllerObj.lstWrapperQuestionSection2.add(wrapperQuesObj);
        controllerObj.handleYesNoButton();
        return childwrapperQuesObj.objInputValue;
    }
}
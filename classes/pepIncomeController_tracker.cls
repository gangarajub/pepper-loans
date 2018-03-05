@isTest(seeAlldata=False)
public class pepIncomeController_tracker {
    
    static testMethod void loadData()
    {
      //-------------pepLoanDetails Page----------------------------------------------------------- 
       loan.testhelper.createSeedDataForTesting();
        pepCmsPage__c objcmspage = pepCommonTrackerController.createPage('Income Details');
        pepCmsSection__c objcmssection = pepCommonTrackerController.createSection(objcmspage);
        pepCmsQuestion__c objcmsquestion = pepCommonTrackerController.createCmsQuestion(objcmspage,objcmssection);
       
        pages_config__c pg = new pages_config__c(Name='pepincomepage',Page_Label__c='IncomePage');
        insert pg;
        
        pages_config__c pg1 = new pages_config__c(Name='pepexpensepage',Page_Label__c='ExpensePage');
        insert pg1;
        
        pages_config__c pg11 = new pages_config__c(Name='peploandetails',Page_Label__c='loandetails');
        insert pg11;
        
        Application__c objAppNav = new Application__c();
       objAppNav.Name='pepIncomePage';
       objAppNav.Navigation_Status__c='Income';
       objAppNav.RedirectPage__c='pepIncomePage';
       insert objAppNav;
       
       Application__c objAppNav1 = new Application__c();
       objAppNav1.Name='pepLoanDetails';
       objAppNav1.Navigation_Status__c='LoanDetails';
       objAppNav1.RedirectPage__c='pepLoanDetails';
       insert objAppNav1;
        
  Test.StartTest();      
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Automated_Payment_Start_Date__c=System.Today();
        objApplication.genesis__Payment_Amount__c=2000;
        objApplication.Debit_Amount__c=2000;
        objApplication.pepCurrent_Page__c=1;
        update objApplication;
        
      /*  Application__c objApp = new Application__c(Name='pepIncomePage',Navigation_Status__c='Income',RedirectPage__c='pepIncomePage');
        insert objApp; */
        Application__c objApp1 = new Application__c(Name='pepExpensePage',Navigation_Status__c='Expense',RedirectPage__c='pepExpensePage');
        insert objApp1;
        
        Income__c objIncome = new Income__c();
        objIncome.Application__c=objApplication.id;
        objIncome.Other_Income__c='No';
        insert objIncome;
        List<Income__c> lstInc = new List<Income__c>();
        lstInc.add(objIncome);
        
        
        PageReference pageRef = Page.pepIncomePage;
        pageRef.getHeaders().put('X-Salesforce-SIP','1');
        pageRef.getParameters().put('redirectFromPageNo','1');
        Test.setCurrentPagereference(pageRef);
        
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pageRef.setcookies(new cookie[]{Applicationid});
        
  		Test.StopTest();
        pepIncomeController objIncomeController = new pepIncomeController();
        objIncomeController.objModelContainer.lstIncome=lstInc;
        objIncomeController.objModelContainer.objApplication=objApplication;
        objIncomeController.pagetoredirect='1';
        objIncomeController.parsedSectionStory();
        objIncomeController.continueLoanApp();
        objIncomeController.saveData();
        objIncomeController.saveCallFromHeader();
        objIncomeController.pagetoredirect='2';
        objIncomeController.saveCallFromHeader();
        objIncomeController.pagetoredirect='3';
        objIncomeController.saveCallFromHeader();
        PageReference resultPage = objIncomeController.onLoading();
       	System.assertEquals('/ExpensePage', resultPage.getURL());
       
    }
}
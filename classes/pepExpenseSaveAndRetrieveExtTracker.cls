//  ----------------------------------------------------------------------------------------------
//   Description: This Class is  Tracker of pepExpenseSaveAndRetrieveExt class.
//  ----------------------------------------------------------------------------------------------
//        Author                   createdDate
//  ----------------------------------------------------------------------------------------------
//      AMIT KR                    5-jul-2016
//  ----------------------------------------------------------------------------------------------


@isTest(SeeAllData=False)


public class pepExpenseSaveAndRetrieveExtTracker
{
     private static  Account objAccount;
     private static genesis__Applications__c objApplication;
     private static genesis__Applications__c objApplication1;
     private static pages_config__c objpageConfig;
     private static RetrievalApplicationStatus__c objStatus;
     

      private static  void loadData()
      {
           
           createAccount();
           createApplication();          
           createPageConfig(); 
           createApplicationStatus();   
      }
      //This creates page config custom settings
      private static void createPageConfig()
      {
        objpageConfig = new pages_config__c();
        objpageConfig = pepCommonTrackerController.createPagesConfig()[0];
        objpageConfig.Page_Label__c='pepexpensepage';
        objpageConfig.Name='pepexpensepage';
        update objpageConfig;
      }
      
      //This creates RetrievalApplicationStatus custom settings
      private static void createApplicationStatus()
      {
          objStatus = new RetrievalApplicationStatus__c();
          objStatus.name ='Retrieval Status';
          objStatus.Retrieval_Status__c ='APPROVED - DOCUMENT SIGNED,APPROVED - CONVERTED TO CONTRACT,REJECTED,DECLINED';
          insert objStatus;
          
      }
      
      //This method creates account
       private static void createAccount()
       {     
         objAccount=  pepCommonTrackerController.createAccount();
        
              
           
       }
       //This method creates Application
       private static void createApplication()
       {
           RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();      
           objApplication =genesis.TestHelper.createApplication();
           objApplication.genesis__Account__c= objAccount.Id;
           objApplication.genesis__Status__c ='Closed';  
           objApplication.Ret_Code__c ='6757';        
           update objApplication;
           
       }
       private static void createApplication1()
       {
          // RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();      
           objApplication1 =genesis.TestHelper.createApplication();
           objApplication1.genesis__Account__c= objAccount.Id;
           update objApplication1;
           
       }
       
       private static testmethod void unitTest1()
       {
          loan.testhelper.createSeedDataForTesting();
          test.startTest();
          loadData();
           createApplication1();            
           pepExpenseController  objController = new pepExpenseController ();
           objController.objApplication = objApplication;
           pepExpenseSaveAndRetrieveExt objExtController = new pepExpenseSaveAndRetrieveExt(objController );
           objExtController.inputvalue='mobile';          
           objExtController.email ='test@email.com';
           objExtController.phone='0434567890';
           objExtController.strRetrieveCode ='6757';
           objExtController.idAccount  = objAccount.id;         
           objExtController.isError = false;
           objExtController.resendCode();
           objExtController.save();
           objExtController.retrieveYes();
           objExtController.retrieveApplication();
           objExtController.retrieveNo();
         test.stoptest();
           
       
       }
       
       private static testmethod void unitTest2()
       {
         loan.testhelper.createSeedDataForTesting();
         test.startTest();
           loadData(); 
           objAccount.personemail ='test@email.com';
           update objAccount; 
                    
           pepExpenseController  objController = new pepExpenseController ();
           objController.objApplication = objApplication;
           pepExpenseSaveAndRetrieveExt objExtController = new pepExpenseSaveAndRetrieveExt(objController );
           objExtController.inputvalue='email';
           objExtController.retrieveEmail='test@email.com';
           objExtController.email ='test@email.com';
           objExtController.phone='0034567890';           
           objExtController.strRetrieveCode ='6757';
           objExtController.idAccount  = objAccount.id;         
           objExtController.isError = false;
           objExtController.resendCode();
           objExtController.save();
           objExtController.retrieveYes();
           objExtController.retrieveApplication();
           objExtController.retrieveNo();
         test.stoptest();           
       
       }
       
       private static testmethod void unitTest3()
       {
            loan.testhelper.createSeedDataForTesting();
            test.startTest();
                loadData(); 
                objApplication.genesis__Status__c ='Closed';
                update objApplication;         
                pepExpenseController  objController = new pepExpenseController ();
                objController.objApplication = objApplication;
                pepExpenseSaveAndRetrieveExt objExtController = new pepExpenseSaveAndRetrieveExt(objController );
                objExtController.inputvalue='email';
                objExtController.retrieveEmail='test@email.com';
                objExtController.email ='tst@email.com';
                objExtController.phone='0034567890';
                objExtController.strRetrieveCode ='6757';
                objExtController.idAccount  = objAccount.id;         
                objExtController.isError = false;
                objExtController.resendCode();
                objExtController.save();
                objExtController.retrieveYes();
                objExtController.retrieveApplication();
                objExtController.retrieveNo();
            test.stoptest();
           
       
       }
       
       private static testmethod void unitTest5()
       {
          loan.testhelper.createSeedDataForTesting();
          test.startTest();
          loadData();
          createApplication1();            
           pepExpenseController  objController = new pepExpenseController ();
           objController.objApplication = objApplication;
           pepExpenseSaveAndRetrieveExt objExtController = new pepExpenseSaveAndRetrieveExt(objController );
           objExtController.strFlag = true;
           objExtController.isError= false;
           objExtController.inputvalue='mobile';          
           objExtController.email ='test@email.com';
           objExtController.phone='0434567890';
           objExtController.strRetrieveCode ='6757';
           objExtController.idAccount  = objAccount.id;         
           objExtController.isError = false;
           objExtController.resendCode();
           objExtController.save();
           objExtController.retrieveYes();
           objExtController.retrieveApplication();
           objExtController.retrieveNo();
         test.stoptest();
           
       
       }
       
       
       
       
       
       
       
       
       


}
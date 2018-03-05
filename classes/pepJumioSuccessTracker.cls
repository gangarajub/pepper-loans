@isTest

public class pepJumioSuccessTracker
{

   private static  Account objAccount;
   private static genesis__Applications__c objApplication; 
   private static Application__c objNav; 
   private static  void loadData()
   {
       createApplication();
       createAccount();  
       createApplicationNavigationStatus();
   }
   
   //This method creates account
   private static void createAccount()
   {     
     objAccount=  pepCommonTrackerController.createAccount();
     objAccount.Current_Application_Id__c = objApplication.id;
     objAccount.Tracking_Id__c  ='1234';
     update objAccount;     
       
   }
   //This method creates Application
   private static void createApplication()
   {
       RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();      
       objApplication =genesis.TestHelper.createApplication();
       
   }
   
   private static void createApplicationNavigationStatus()
   {
       objNav = new Application__c();
       objNav.name ='pepUploadFinancialDoc';
       objNav.Navigation_Status__c ='pepUploadFinancialDoc';
       insert objNav;
       
        pages_config__c objConfig = new pages_config__c();
                   objConfig.Page_Label__c='UploadFinancialDoc';
                   objConfig.Name='pepuploadfinancialdoc';
                   insert objConfig;
   
   
   }
   
   static testmethod void unitTest1()
   {
       Test.startTest();
       loadData();
       ApexPages.Currentpage().getParameters().put('jumioIdScanReference','1234');
       pepJumioSuccessController  objController = new pepJumioSuccessController();
       objController.redirect();
       Test.stopTest();
       
      
   }



}
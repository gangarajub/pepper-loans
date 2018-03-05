@isTest

public class pepJumioFailureControllerTracker
{

   private static  Account objAccount;
   private static genesis__Applications__c objApplication;  
   private static  void loadData()
   {
       createApplication();
       createAccount();  
       
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
       
        pages_config__c objConfig = new pages_config__c();
                   objConfig.Page_Label__c='loanSetupManualUpload';
                   objConfig.Name='peploansetupmanualupload';
                   insert objConfig;
       
   }
   
   static testmethod void unitTest1()
   {
       Test.startTest();
       loadData();
       ApexPages.Currentpage().getParameters().put('jumioIdScanReference','1234');
       pepJumioFailureController  objController = new pepJumioFailureController();
       objController.redirect();
       Test.stopTest();
   }



}
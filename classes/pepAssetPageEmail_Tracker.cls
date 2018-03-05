// ---------------------------------------------------------------------------------------------------------
// This Tracker class is used to cover pepAssetPageEmail class. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      3rd March 2017          Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
@isTest(seeAllData= false)
Public Class pepAssetPageEmail_Tracker
{
   private Static  Account objAccount;
   private Static  genesis__Applications__c objGenesisApp; 
  
  static testMethod void testpepAssetPageEmail() 
  {
      test.starttest();
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      update objGenesisApp;
      genesis__Application_Pricing_Detail__c objPricing = new genesis__Application_Pricing_Detail__c();
      objPricing.genesis__Application__c = objGenesisApp.id;
      insert objPricing ;
      pepAssetPageEmail.sendEmail(objPricing.id);
       test.stoptest();
   }
 }
@isTest(SeeAllData=False) private class pepMonthlyBudget_Tracker{
    
    @isTest static void pepMonthlyBudgetTest(){
        
         RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
         genesis__Applications__c objGenesisApp = genesis.TestHelper.createApplication();
         
         genesis__Application_Status_History__c obj = new genesis__Application_Status_History__c();
         obj.genesis__New_Value__c='APPROVED - CONVERTED TO CONTRACT';
         obj.genesis__Application__c=objGenesisApp.id;
         insert obj;
         
         Monthly_Budget__c objMonthlybudget = new Monthly_Budget__c();
         objMonthlybudget.Date__c=System.Today();
         objMonthlybudget.Amount__c=2000000;
         insert objMonthlybudget;
         
         Test.StartTest();
         
         pepMonthlyBudget objMonthlyBudgetBatch = new pepMonthlyBudget();
         ID MonthlyBudget = Database.ExecuteBatch(objMonthlyBudgetBatch);
         
         Test.Stoptest();
        
        
    }
    
    
}
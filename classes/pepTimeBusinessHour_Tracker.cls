@isTest(SeeAllData=False) private class pepTimeBusinessHour_Tracker{
    
    @isTest static void pepTimeBusinessHourTest(){
        
         RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
         genesis__Applications__c objGenesisApp = genesis.TestHelper.createApplication();
         
         genesis__Application_Status_History__c objstatusHistory = new genesis__Application_Status_History__c();
         objstatusHistory.genesis__Application__c = objGenesisApp.id;
         insert objstatusHistory;
         
         Test.StartTest();
         
         pepTimeBusinessHour  objTime = new pepTimeBusinessHour();
         ID MonthlyBudget = Database.ExecuteBatch(objTime);
         
         Test.Stoptest();
        
        
    }
    
    
}
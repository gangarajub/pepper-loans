@isTest(SeeAllData=False) private class pepTotalTimeStatusChange_Tracker{
    
    @isTest static void pepTotalTimeStatusChangeTest(){
        
         RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
         genesis__Applications__c objGenesisApp = genesis.TestHelper.createApplication();
         
         
         genesis__Application_Status_History__c objstatusHistory = new genesis__Application_Status_History__c();
         objstatusHistory.genesis__Application__c = objGenesisApp.id;
         objstatusHistory.genesis__New_Value__c ='NEW - CREDIT PULLED';
         insert objstatusHistory;
         
         genesis__Application_Status_History__c objstatusHistory1 = new genesis__Application_Status_History__c();
         objstatusHistory1.genesis__Application__c = objGenesisApp.id;
         objstatusHistory1.genesis__New_Value__c ='APPROVED - CONVERTED TO CONTRACT';
         insert objstatusHistory1;
         
         
         Test.StartTest();
         
         pepTotalTimeStatusChange  objTimeStatusChange = new pepTotalTimeStatusChange();
         ID MonthlyBudget = Database.ExecuteBatch(objTimeStatusChange);
         
         Test.Stoptest();
        
        
    }
    
    
}
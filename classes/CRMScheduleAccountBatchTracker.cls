@istest(SeeAllData=False)Public class CRMScheduleAccountBatchTracker{

    @isTest static void test0(){
    
        Account acc = new Account();
        acc.Name = 'testRecord';
        acc.CRM_Achieved_MTD__c = 1111;
        acc.CRM_Target_MTD__c  = 1111;
        insert acc;
        
        CRM_Forecast__c objForecast = new CRM_Forecast__c();
        objForecast.Name='testForecast';
        objForecast.CRM_Forecast_Year__c = '2017';
        objForecast.CRM_Business_Unit__c = 'PAF';
        objForecast.CRM_Introducer__c = acc.id;
        objForecast.CRM_Target_January__c = 1;
        objForecast.CRM_Target_February__c = 1;
        objForecast.CRM_Target_March__c = 1;
        objForecast.CRM_Target_April__c = 1;
        objForecast.CRM_Target_May__c = 1;
        objForecast.CRM_Target_June__c = 1;
        objForecast.CRM_Target_July__c = 1;
        objForecast.CRM_Target_August__c = 1;
        objForecast.CRM_Target_September__c = 1;
        objForecast.CRM_Target_October__c = 1;
        objForecast.CRM_Target_November__c = 1;
        objForecast.CRM_Target_December__c = 1;
        
        insert objForecast;
        
        CRMScheduleAccountBatch o = new CRMScheduleAccountBatch();
        o.execute(null);
    
    }

}
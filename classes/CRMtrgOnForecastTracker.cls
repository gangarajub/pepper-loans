@isTest(SeeAllData = False) Public class CRMtrgOnForecastTracker{
    
    @isTest static void test0(){
        
        Account objAccount = new Account();
        objAccount.Name = 'testingAccount';
        insert objAccount;
        
        List<CRM_Application__c> lstApp = new List<CRM_Application__c>();
        for(integer i=1;i<=12;i++){
            CRM_Application__c objApplication = new CRM_Application__c();
            objApplication.CRM_Primary_Introducer__c = objAccount.id;
            objApplication.CRM_Net_Amount_Financed_Amount__c = 20000;
            objApplication.CRM_Settlement_Date__c = Date.newInstance(2017,i,1);
            objApplication.Name = 'rec 2017 '+i;
            lstApp.add(objApplication);
        }
        for(integer i=1;i<=12;i++){
            CRM_Application__c objApplication = new CRM_Application__c();
            objApplication.CRM_Primary_Introducer__c = objAccount.id;
            objApplication.CRM_Net_Amount_Financed_Amount__c = 20000;
            objApplication.CRM_Settlement_Date__c = Date.newInstance(2016,i,1);
            objApplication.Name = 'rec 2016 '+i;
            lstApp.add(objApplication);
        }
        for(integer i=1;i<=12;i++){
            CRM_Application__c objApplication = new CRM_Application__c();
            objApplication.CRM_Primary_Introducer__c = objAccount.id;
            objApplication.CRM_Net_Amount_Financed_Amount__c = null;
            objApplication.CRM_Settlement_Date__c = Date.newInstance(2017,i,1);
            objApplication.Name = 'rec 2016 '+i;
            lstApp.add(objApplication);
        }
        insert lstApp;
        
        
        CRM_Forecast__c objForecast = new CRM_Forecast__c();
        objForecast.Name='hah';
        objForecast.CRM_Forecast_Year__c = '2017';
        objForecast.CRM_Business_Unit__c = 'PAF';
        objForecast.CRM_Introducer__c = objAccount.id;
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
        
        objForecast.CRM_Target_January__c = 0;
        objForecast.CRM_Target_February__c = 0;
        objForecast.CRM_Target_March__c = 0;
        objForecast.CRM_Target_April__c = 0;
        objForecast.CRM_Target_May__c = 0;
        objForecast.CRM_Target_June__c = 0;
        objForecast.CRM_Target_July__c = 0;
        objForecast.CRM_Target_August__c = 0;
        objForecast.CRM_Target_September__c = 0;
        objForecast.CRM_Target_October__c = 0;
        objForecast.CRM_Target_November__c = 0;
        objForecast.CRM_Target_December__c = 0;
        update objForecast;

    }
    
}
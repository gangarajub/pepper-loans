@isTest(SeeAllData = False) Public class CRMTrgOnApplicationTracker{
    
    @isTest static void test0(){
        
        Account objAccount = new Account();
        objAccount.Name = 'testingAccount';
        insert objAccount;
        
        CRM_Forecast__c objForecast = new CRM_Forecast__c();
        objForecast.Name='hah';
        objForecast.CRM_Forecast_Year__c = '2017';
        objForecast.CRM_Business_Unit__c = 'PAF';
        objForecast.CRM_Introducer__c = objAccount.id;
        insert objForecast;
        CRM_Application__c objApplication1 = new CRM_Application__c();
        objApplication1.CRM_Primary_Introducer__c = objAccount.id;
        objApplication1.CRM_Net_Amount_Financed_Amount__c = 20000;
        objApplication1.CRM_Settlement_Date__c = Date.newInstance(2017,1,1);
        objApplication1.Name = 'rec 2017';
        insert objApplication1;
        
        objApplication1.CRM_Settlement_Date__c = Date.newInstance(2017,2,1);
        update objApplication1;
        
            
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
            objApplication.CRM_Settlement_Date__c = Date.newInstance(2017,i,1);
            objApplication.Name = 'rec1 2017 '+i;
            lstApp.add(objApplication);
        }
        for(integer i=1;i<=12;i++){
            CRM_Application__c objApplication = new CRM_Application__c();
            objApplication.CRM_Primary_Introducer__c = objAccount.id;
            
            objApplication.CRM_Settlement_Date__c = Date.newInstance(2017,i,1);
            objApplication.Name = 'rec1 2017 '+i;
            lstApp.add(objApplication);
        }
        insert lstApp;
        
        
        

    }
    
}
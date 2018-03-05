@isTest(SeeAllData=False)Public class CRMScheduleApplicationBatchTracker{

    @isTest static void test0(){
    
        Account acc = new Account();
        acc.Name = 'test record';
        acc.CRM_CMS_Unique_ID__c  = 100000;
        insert acc;
        
        CRM_Application__c objApp = new CRM_Application__c();
        objApp.Name = 'application test';
        objApp.CRM_Secondary_Introducer_Code__c =100000;
        insert objApp;
        
        CRMScheduleApplicationBatch o = new CRMScheduleApplicationBatch();
        o.execute(null);
    
    }


}
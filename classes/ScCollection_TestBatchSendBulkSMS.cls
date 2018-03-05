@isTest(SeeAllData=False)public class ScCollection_TestBatchSendBulkSMS{


    @isTest static void test0(){
        
        cnotify__Template_Configuration__c objTemplateConfig = new cnotify__Template_Configuration__c();
        objTemplateConfig.Name='temp';
        objTemplateConfig.cnotify__Template_Type__c='Message';
        insert objTemplateConfig;
        
        Sms_Magic__c objCust = new Sms_Magic__c();
        objCust.Name = 'CollectionSenderId';
        objCust.senderId__c = 'PepperMoneyDev';
        insert objCust;
        
        cnotify__Delivery_Detail__c obj = new cnotify__Delivery_Detail__c ();
        obj.Name = 'testing';
        obj.cnotify__Template_Configuration__c= objTemplateConfig.id;
        insert obj;
        ScCollection_BatchSendBulkSMS o = new ScCollection_BatchSendBulkSMS ();
        database.executeBatch(o);
        
        ScCollection_ScheduleBatchSendBulkSMS objSchedule = new ScCollection_ScheduleBatchSendBulkSMS();
        objSchedule.execute(null);
    }

}
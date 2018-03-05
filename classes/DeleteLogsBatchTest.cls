@isTest
private class DeleteLogsBatchTest
{
    static List<mfiflexUtil__Log__c> createLogRecords()
    {
        List<mfiflexUtil__Log__c> listFlexLogs = new List<mfiflexUtil__Log__c>();
        mfiflexUtil__Log__c flexLog;
        for(integer i=0; i<100; i++)
        {
            flexLog = new mfiflexUtil__Log__c();
            flexLog.mfiflexUtil__Message__c  ='Test Message '+i;
            flexLog.mfiflexUtil__Time__c = system.now();
            flexLog.mfiflexUtil__Module_Acronym__c = 'Collections';
            flexLog.mfiflexUtil__Type__c = 'Exception';
            listFlexLogs.add(flexLog);
        }
        
        insert listFlexLogs;
        
        return listFlexLogs;
    }
    
    static testMethod void deleteLogsTest()
    {
        List<mfiflexUtil__Log__c> listFlexLogs = createLogRecords();
        test.startTest();
        DeleteLogsBatch delLogsBatch = new DeleteLogsBatch();
        DataBase.executeBatch(delLogsBatch); 
        test.stopTest();
        
        List<mfiflexUtil__Log__c> listLogs = [Select Id from mfiflexUtil__Log__c where id in: listFlexLogs];
        system.assertEquals(0, listLogs.size());
    }
}
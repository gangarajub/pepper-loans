trigger ScCollection_TrgOnSyncStatistics on collect__Sync_Statistics__c (after insert) {
    
    if(trigger.IsAfter && trigger.isInsert){
    
        ScCollection_TrgOnSyncStatisticsHandler.StagingActualSyncProcess(trigger.new);
    }
}
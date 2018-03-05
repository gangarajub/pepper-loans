// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on collect__Promise_To_Pay__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 09-JUNE-2016        Created By: Deepak Dhingra      Email: deepak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestPromiseTopayHandler
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_PromiseToPayTrigger on collect__Promise_To_Pay__c (after insert, after undelete, after update, before insert, before update, before delete, after delete) 
{
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_PromiseToPayTrigger')) return;
    
    ScCollection_PromiseTopayHandler reference = new ScCollection_PromiseTopayHandler();
    
    if(Trigger.isAfter)
    {
        if(Trigger.isUpdate)
        {
            reference.onAfterUpdate(Trigger.New);
        }
        if(Trigger.isInsert)
        {
            reference.onAfterInsert(Trigger.New);
        }
        if(Trigger.isDelete)
        {
            reference.onAfterDelete(Trigger.old);
        }
    }
    if(Trigger.isBefore)
    {
        
    }
}
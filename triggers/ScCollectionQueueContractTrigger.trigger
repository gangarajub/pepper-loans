// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on collect__Queue_Contract__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 29-JULY-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestQueueContractTrigger
// --------------------------------------------------------------------------------------------------------   
trigger ScCollectionQueueContractTrigger on collect__Queue_Contract__c (before insert, after insert, before update, after update) 
{
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollectionQueueContractTrigger')) return;
        
    ScCollection_QueueContractHandler obj = new ScCollection_QueueContractHandler();

    if(Trigger.isBefore) 
    {
        if(Trigger.isInsert)
        {
            obj.onBeforeInsert(Trigger.New);    
        }
        else if(Trigger.isUpdate)
        {
            
        }
    }
    
    if(Trigger.isAfter) 
    {
        if(Trigger.isInsert)
        {
            obj.onAfterInsert(Trigger.New);    
        }
        else if(Trigger.isUpdate)
        {
            obj.onAfterUpdate(Trigger.oldMap,Trigger.New);    
        }
    }
}
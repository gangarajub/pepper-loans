// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on collect__Contract_Status__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 27-JULY-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestContractStatusHandler
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_ContractStatusTrigger on collect__Contract_Status__c (after insert, after update, before insert, before update) 
{
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_ContractStatusTrigger')) return;
    
    ScCollection_ContractStatusHandler tempReference = new ScCollection_ContractStatusHandler();
    
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            tempReference.onAftereUpdate(Trigger.new,Trigger.NewMap,Trigger.Oldmap);
            tempReference.updateContractPriority(trigger.new,Trigger.Oldmap);
        }
    }

    if(trigger.isBefore)
    {   
        if(trigger.isUpdate)
        {
            tempReference.onBeforeUpdate(Trigger.new,Trigger.NewMap,Trigger.Oldmap);    
        }
    }
}
// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on ScCollection_ContractSettings__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 09-JUNE-2016        Created By: Deepak Dhingra        Email: deepak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestContractSettingFacade 
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_ContractSettingTrigger on ScCollection_ContractSettings__c (after insert, after update, before insert, before update) 
{
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_ContractSettingTrigger')) return;
    
    //handling after update
    if(trigger.isUpdate || trigger.isInsert)
    {
        if(trigger.isbefore)
        {
            //update the queue contract if we have crossed the users limit
            ScCollection_ContractSettingFacade.updateQueueContract(trigger.New);
        } 
    }
    if(trigger.isUpdate)
    {
        if(trigger.isAfter)
        {
            // Update Hardship priority and manage escalation on the basis of the congured Settings.
            //ScCollection_ContractSettingFacade.updateContractPriority(trigger.new);
        }
    }
}
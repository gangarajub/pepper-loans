// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on Party Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestPartyHandler
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_PartyTrigger on clcommon__Party__c (before insert, after insert, before update,  after update) 
{
    if(!Test.isRunningTest())
        if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_PartyTrigger')) return;
    
    ScCollection_PartyHandler obj = new ScCollection_PartyHandler();
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        obj.onBeforeInsert(Trigger.New);
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        obj.onAfterInsert(Trigger.New);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        obj.onBeforeUpdate(Trigger.New, Trigger.oldMap); 
    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        obj.onAfterUpdate(Trigger.New, Trigger.oldMap); 
    }
}
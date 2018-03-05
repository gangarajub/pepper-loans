// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on Account Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 25-APRIL-2017         Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : CRM_Mtg_TestAccountTriggerHandler
// --------------------------------------------------------------------------------------------------------   
trigger CRM_Mtg_AccountTrigger on Account(before insert, after insert, before update, after update) 
{
    // check for active or inactive in setting
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('CRM_Mtg_AccountTrigger')) return;

    CRM_Mtg_AccountTriggerHandler ref = new CRM_Mtg_AccountTriggerHandler();
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            ref.onBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate)
        {
            ref.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            ref.onAfterInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate)
        {
            ref.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
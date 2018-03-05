// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on User Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 27-JULY-2016         Created By: Deepak Dhingra        Email: depak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestUserTriggerHandler
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_UserTrigger on User (before insert, after insert, before update, after update) 
{
    // check for active or inactive in setting
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_UserTrigger')) return;

    ScCollection_UserTriggerHandler ref = new ScCollection_UserTriggerHandler();
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            ref.onBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate)
        {
            ref.onBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
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
            ref.onAfterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
        }
    }
}
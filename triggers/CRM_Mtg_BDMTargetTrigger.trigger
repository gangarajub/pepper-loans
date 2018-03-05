// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on BDM Target Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 16-JAN-2017   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : CRM_Mtg_BDMTargetHandlerTracker
// --------------------------------------------------------------------------------------------------------   
trigger CRM_Mtg_BDMTargetTrigger on CRM_Mtg_BDM_Target__c (before insert, after insert, before update,  after update) 
{
    // check for active or inactive in setting
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('CRM_Mtg_BDMTargetTrigger')) return;
    
    CRM_Mtg_BDMTargetHandler obj = new CRM_Mtg_BDMTargetHandler();
    
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
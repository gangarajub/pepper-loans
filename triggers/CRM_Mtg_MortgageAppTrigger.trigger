// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on Mortgage Application Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 16-JAN-2017         Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : CRM_Mtg_MortgageAppHandlerTracker
// --------------------------------------------------------------------------------------------------------   
trigger CRM_Mtg_MortgageAppTrigger on CRM_Mortgage_Application_Data__c (before Insert, before update, after Insert, after Update) 
{
    // check for active or inactive in setting
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('CRM_Mtg_MortgageAppTrigger')) return;
    
    CRM_Mtg_MortgageAppHandler obj = new CRM_Mtg_MortgageAppHandler();
    
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
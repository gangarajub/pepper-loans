// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on Party Object for Self Service Project
// --------------------------------------------------------------------------------------------------------
// Created Date : 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : pafss_TestPartyHandler
// --------------------------------------------------------------------------------------------------------   
trigger pafss_PartyTrigger on clcommon__Party__c (before insert, after insert, before update,  after update) 
{
    
    if(!Trigger_Bypass__c.getInstance().clcommonPartyTrigger__c)return;
    
    pafss_PartyHandler obj = new pafss_PartyHandler();
    
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
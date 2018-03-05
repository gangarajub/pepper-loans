// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on loan__Loan_Account__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 26-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestPersonalContractHanler
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_PersonalContractTrigger on loan__Loan_Account__c (after insert, after update, before insert, before update) 
{
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_PersonalContractTrigger')) return;
    
    ScCollection_PersonalContractHanler reference = new ScCollection_PersonalContractHanler();
    
    if(trigger.isbefore)
    {    
        if(trigger.isInsert)
        {
            // call the before insert handler
            reference.onBeforeInsert(Trigger.New);
        }
        
        if(trigger.isUpdate)
        {
            
        }
    }
    
    if(trigger.isAfter)
    {    
        if(trigger.isInsert)
        {
            
        }
        
        if(trigger.isUpdate)
        {
            // call the after update handler
            reference.onAfterUpdate(Trigger.New,Trigger.OldMap);
        }
    }
}
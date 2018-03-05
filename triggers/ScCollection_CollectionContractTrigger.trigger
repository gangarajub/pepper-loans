// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on collect__Loan_Account__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 09-JUN-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestCollectionContractHan
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_CollectionContractTrigger on collect__Loan_Account__c (before insert, before update, after insert, after update) 
{
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_CollectionContractTrigger')) return;
    
    ScCollection_CollectionContractHanler reference = new ScCollection_CollectionContractHanler();
    
    if(trigger.isbefore)
    {    
        if(trigger.isInsert)
        {
            // call the before insert handler
            reference.onbeforeInsert(Trigger.New);
        }
        
        if(trigger.isUpdate)
        {
            // call the before update handler
            reference.onbeforeUpdate(Trigger.NewMap,Trigger.OldMap);
        }
    }
    
    if(trigger.isAfter)
    {    
        if(trigger.isInsert)
        {
            //call the after insert handler
            reference.onAfterInsert(Trigger.New);
        }
        
        if(trigger.isUpdate)
        {
            // call the after update handler
            reference.onafterUpdate(Trigger.New,Trigger.OldMap);
        }
    }
}
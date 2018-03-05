// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on Contact Preference Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 06-OCT-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestPreferenceHandler
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_PreferenceTrigger on collect__Contact_Preference__c (after insert, after update) 
{
    if(!Test.isRunningTest())
        if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_PreferenceTrigger')) return;
    
    ScCollection_PreferenceHandler obj = new ScCollection_PreferenceHandler();
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        obj.onAfterInsert(Trigger.New);
    }

    if(Trigger.isAfter && Trigger.isUpdate)
    {
        obj.onAfterUpdate(Trigger.New, Trigger.oldMap); 
    }
}
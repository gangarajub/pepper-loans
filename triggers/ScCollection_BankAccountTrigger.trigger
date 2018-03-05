// --------------------------------------------------------------------------------------------------------
// This trigger handles all the automations to be done on collect__Bank_Account__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 27-JULY-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestBankAccountHandler
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_BankAccountTrigger on collect__Bank_Account__c (after insert) 
{
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_BankAccountTrigger')) return;
    
    ScCollection_BankAccountHandler obj = new ScCollection_BankAccountHandler();
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        obj.onAfterInsert(Trigger.New);
    }
}
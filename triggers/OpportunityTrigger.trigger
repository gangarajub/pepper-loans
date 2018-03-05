/*
 * AH 31/03/2017 Single Opportunity Trigger that calls helper class/methods
 		replaces CRMtrgToUpdateApplication - which is badly named, badly written and doesnt work properly!!


	AH 3/11/17 OpportunityTriggerHandler.linkMortgageApplicationData is now obsolete with the new feed from DES

 */
trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update)
{
    if(Trigger.isBefore && Trigger.isInsert){
   
    }
    if(Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.updateDailyAchievement(Trigger.New, null);       
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
    
    }

    if(Trigger.isAfter && Trigger.isUpdate){
    	OpportunityTriggerHandler.linkMortgageApplicationData(Trigger.New, Trigger.oldMap);    
        OpportunityTriggerHandler.updateDailyAchievement(Trigger.New, Trigger.oldMap);
    }
   
}
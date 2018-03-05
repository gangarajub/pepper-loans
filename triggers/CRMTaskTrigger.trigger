/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          CRMTaskTrigger 
Company:       Saasfocus
Description:   This trigger is use to update the Opportunity status
History
Date    :  24/09/2017     
------------------------------------------------------------*/
trigger CRMTaskTrigger on Task (after Insert,after update) {
    
    if(Trigger.IsAfter && (Trigger.IsInsert || Trigger.IsUpdate)){
        CRMTaskTriggerHandler.updateStageNameOnOpportunity(Trigger.New,Trigger.oldMap);
    }
}
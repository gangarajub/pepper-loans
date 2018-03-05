//-----------------------------------------------------------------------------------------------------
// Date        : 30/11/2016
// Description : This trigger is to update case status
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------

trigger CRMtriggerOnChecklist on CRM_Checklist__c (before insert,before update) {

    if(Trigger.isInsert && trigger.isBefore){
    
        CRMtriggerOnChecklistHandler.updateCaseStatus(trigger.new,null);
    
    }
    
    if(trigger.isupdate && trigger.isBefore){
        
        CRMtriggerOnChecklistHandler.updateCaseStatus(trigger.new,trigger.oldMap);
    
    }

}
//-----------------------------------------------------------------------------------------------------
// Date        : 30/11/2016
// Description : This trigger on case to create checklist
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------

trigger CRMTriggerOnCase on Case(After Insert,After Update,Before Update){
    
    //to insert checklist 
    if(trigger.isInsert && trigger.isAfter){
    
        CRMTriggerOnCaseHandler.insertChecklist(trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
    if(SwitchoffCoC__c.getOrgDefaults().Switch__c!=null && SwitchoffCoC__c.getOrgDefaults().Switch__c==True){
    InsuranceEmailToCaseManagement.handleassignment(Trigger.newMap,Trigger.oldMap);
    }
    }
    if(Trigger.isBefore && Trigger.isUpdate){
    if(SwitchoffCoC__c.getOrgDefaults().Switch__c!=null && SwitchoffCoC__c.getOrgDefaults().Switch__c==True){
    InsuranceEmailToCaseManagement.updateowner(Trigger.newMap,Trigger.oldMap);
    }
    pepenforcementprevention.preventassignment(Trigger.oldMap,Trigger.newMap);
    }
}
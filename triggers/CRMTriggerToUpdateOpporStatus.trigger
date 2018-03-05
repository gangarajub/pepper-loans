trigger CRMTriggerToUpdateOpporStatus on EmailMessage (after insert,Before Insert,Before Delete) {
   
    if(Trigger.isBefore && Trigger.isInsert){
    if(SwitchoffCoC__c.getOrgDefaults().Switch__c!=null && SwitchoffCoC__c.getOrgDefaults().Switch__c==True){
        //AH 13-12-17 disabled this feature because its creating duplicate and spam accounts in production.
        //PLCaseManagement.manageCase(Trigger.new);
    }
    }
    if(Trigger.isAfter && Trigger.isInsert){
        CRMTriggerToUpdateOpporStatusHandler.changeOpportunityStatus(Trigger.New);
    }
    if(Trigger.isBefore && Trigger.isDelete){
    pepEnforcementprevention.preventdeletion(Trigger.old);
    }
}
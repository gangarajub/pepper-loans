trigger CRMtrgPAFtoOpportunityLookup on Application_Data__c (before insert,After update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
    
      //  CRMtrgPAFtoOpportunityLookupHandler.CreateOpportunityLookup(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
    
        CRMtrgPAFtoOpportunityLookupHandler.UpdateOpportunityStatus(Trigger.new,Trigger.oldMap);
    
    }

}
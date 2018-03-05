trigger CRMtrgMortageToOpportunityLookup  on Pepper_Data__c (before insert, After Update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
    //    CRMtrgMortageToOpportunityLookupHandler.CreateOpportunityLookup(Trigger.New);
        //AH 31/3/17 - new method for SFC-96 - updates new Pepper_Data__c records with the Opty Id, and updates the Opty with the Stage, Amount and Product Class.
        //AH 1/11/17 - OBSOLETE and replaced by DES Data FEed >> CRM_Mtg_MortgageAppTrigger
        //CRMtrgMortageToOpportunityLookupHandler.syncOpportunity(Trigger.New);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
    	//AH 31/3/17 This method is now OBSOLETE
        //CRMtrgMortageToOpportunityLookupHandler.UpdateOpportunityStatus(Trigger.new,Trigger.oldMap);
    
    }    
    
}
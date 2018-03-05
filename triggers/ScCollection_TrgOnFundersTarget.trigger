trigger ScCollection_TrgOnFundersTarget on ScCollection_Funders_Target__c (After Insert) {
    
    
    if(Trigger.IsAfter){
    
        if(Trigger.IsInsert){
            
            ScCollection_TrgOnFundersTargetHandler.CreateContractSummary(Trigger.New);
        }
    
    }
}
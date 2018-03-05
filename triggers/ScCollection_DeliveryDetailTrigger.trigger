// --------------------------------------------------------------------------------------------------------
// This trigger is use to fill look up on CL Contract and PL contract 
// --------------------------------------------------------------------------------------------------------
// Created Date : 31-JAN-2017   Created By: sandip bijlwan  Email: sandip.bijlwan@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : 
// --------------------------------------------------------------------------------------------------------   
trigger ScCollection_DeliveryDetailTrigger  on cnotify__Delivery_Detail__c (before insert , before update) {

    if(trigger.isbefore)
    { 
        if(trigger.isInsert){
            
            ScCollection_DeliveryDetailTrgHandler.UpdateContractLookup(Trigger.New);
        }
        if(trigger.isUpdate){
        
            ScCollection_DeliveryDetailTrgHandler.UpdateContractLookup(Trigger.New);
        }
    }

}
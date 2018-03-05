trigger ChargeTrigger on loan__Charge__c (before insert, before update, before delete) {
    
    if ((!loan.CustomSettingsUtil.getTriggerParameters().Disable_Custom_Charge_Trigger__c)
        &&(!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c)){
            
            if((trigger.isBefore) && (trigger.isDelete)) {
                if(loan.CustomSettingsUtil.getOrgParameters().loan__Production__c){
                    System.debug(LoggingLEvel.ERROR,'Before Delete Started ');
                    for(loan__Charge__c charge : trigger.old) {
                        charge.addError('You cannot delete this record. Delete operations are not permitted with Production active.');                
                    }
                }
            }
           
            
            if (trigger.isBefore) {
                if (trigger.isUpdate) {
                    ChargeTriggerHandler handler = new ChargeTriggerHandler(trigger.new, trigger.oldMap);
                    handler.beforeUpdateHandler();
                }
                if (trigger.isInsert) {
                     ChargeTriggerHandler handler = new ChargeTriggerHandler(trigger.new, trigger.oldMap);
                    handler.beforeInsertHandler();
                }
            }
        }
}
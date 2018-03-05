trigger sendnoteToJackson on Diary_Notes__c (Before Insert,After Insert,Before Update){
 if(SwitchoffCoC__c.getOrgDefaults().Switch__c!=null && SwitchoffCoC__c.getOrgDefaults().Switch__c==True){
    If(Trigger.isBefore && trigger.isInsert){
        PropertyInsuranceHandling.loanContractAssignment(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert){
       PropertyInsuranceHandling.writebackTojackson(Trigger.newmap.keyset());
    }
    if(Trigger.isBefore && Trigger.isUpdate){
      PropertyInsuranceHandling.preventUpdate(Trigger.oldMap,Trigger.newMap);
    }
  }  
}
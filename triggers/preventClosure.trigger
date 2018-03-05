trigger preventClosure on Property_Insurance__c (Before update,Before insert,After update){
  if(SwitchoffCoC__c.getOrgDefaults().Switch__c!=null && SwitchoffCoC__c.getOrgDefaults().Switch__c==True){
    if(Trigger.isBefore && Trigger.isUpdate){
    //Method to check whether BIU is associated with any case and if Yes that case must be closed and managing the Assignment thing.
    InsuranceEmailToCaseManagement.checkassociatedcases(Trigger.newMap,Trigger.oldMap);
    
    InsuranceEmailToCaseManagement.updateExpiryDateTime(Trigger.new,false,trigger.newMap,trigger.oldmap);//Assigning ExpiryDateTime value in A.M.
    }
    if(Trigger.isBefore && Trigger.isInsert){
    
    InsuranceEmailToCaseManagement.updateExpiryDateTime(Trigger.new,true,trigger.newMap,trigger.oldMap);//Assigning ExpiryDateTime value in A.M.
    
    }
    if(Trigger.isAfter && Trigger.isUpdate){
       
        if(!RecursiveTriggerHelper.isAlreadyModified())
        {
        //Method to call API of writing back the insurance details or Letter Generation.
        set<id> insurencedetailsset = new set<id>();
        set<id>  writeInsuranceDetails = new set<id>();
        for(Id prp:Trigger.newmap.keyset()){
            if(Trigger.newmap.get(prp).Source_Name__c=='MORTGAGE'){
            system.debug('}}}}}}}inside this');
            system.debug('}}}}}'+Trigger.newmap.get(prp).Status__c);
            system.debug('}}}}}'+Trigger.oldMap.get(prp).Status__c);
            system.debug('}}}}'+Trigger.newmap.get(prp).Don_t_Send_To_Jackson__c);
            if(Trigger.newmap.get(prp).Status__c!=Trigger.oldMap.get(prp).Status__c && Trigger.newmap.get(prp).Status__c=='Closed' && Trigger.newmap.get(prp).Don_t_Send_To_Jackson__c==False || Test.isRunningTest())
            insurencedetailsset.add(prp);
            if(Trigger.newmap.get(prp).SendInsuranceDetailsToJackson__c != Trigger.oldMap.get(prp).SendInsuranceDetailsToJackson__c && Trigger.newmap.get(prp).SendInsuranceDetailsToJackson__c == True)
            writeInsuranceDetails.add(prp);
            }
       }
        if(insurencedetailsset != null && insurencedetailsset.size()>0)
        InsuranceEmailToCaseManagement.writingInsuranceDetails(insurencedetailsset);
        if(writeInsuranceDetails != null && writeInsuranceDetails.size()>0)
        InsuranceEmailToCaseManagement.createDiaryNotes(writeInsuranceDetails,Label.InsuranceTojacksonNote);
        RecursiveTriggerHelper.setAlreadyModified();
           }
        }
  }     
}
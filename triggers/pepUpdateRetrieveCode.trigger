trigger pepUpdateRetrieveCode on genesis__Applications__c (after insert, after update) {
//this trigger update custom setting related to retrieveal code
    
    if(trigger.isAfter  && trigger.isInsert)
    {
        List<genesis__Applications__c> lstApp=new List<genesis__Applications__c>();
        RetrieveCode__c mc = RetrieveCode__c.getOrgDefaults();
            
        for(genesis__Applications__c app:Trigger.New)
        {
            system.debug(mc.code__c);
            genesis__Applications__c ap=new genesis__Applications__c(id=app.id);
            ap.Ret_Code__c=pepUtilityClass.createRetrievalCode(mc.code__c);
            lstApp.add(ap);
            mc.code__c=ap.Ret_Code__c;
        }
        update lstApp;
        update mc;
        
    }
    if(trigger.isAfter && trigger.isUpdate){
        et4ae5.triggerUtility.automate('genesis__Applications__c');
    }
}
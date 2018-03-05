trigger EmploymentInformationTrigger on genesis__Employment_Information__c (after Insert,after Update) {
    Set<Id> appIds = new Set<Id>();
    for(genesis__Employment_Information__c empInfo : Trigger.new){
       if(empInfo.genesis__Application__c!=null){
           appIds.add(empInfo.genesis__Application__c);
       }
    }
    
    List<genesis__Applications__c> apps = [select Id,Current_Employment_Status__c,Current_Occupation__c,
                                        Current_Residential_Status__c,How_long_have_you_worked__c,
                                        How_long_you_have_lived_here__c from genesis__Applications__c 
                                        where Id in:appIds];
    Map<Id,genesis__Applications__c> appMap = new Map<Id,genesis__Applications__C>();
    for(genesis__Applications__c app:apps){
        appMap.put(app.id,app);
    }
    apps = new List<genesis__Applications__c>();
    for(genesis__Employment_Information__c empInfo : Trigger.new){
       if(empInfo.genesis__Application__c!=null && empInfo.sequence__c == 1){
           genesis__Applications__c app = appMap.get(empInfo.genesis__Application__c);
           app.Current_Employment_Status__c = empInfo.Employment_Status__c;
           app.Current_Occupation__c = empInfo.Current_Occupation__c;
           app.How_long_have_you_worked__c = empInfo.How_Long_have_you_worked__c;
           apps.add(app);
       }
    }
   
    update apps;
}
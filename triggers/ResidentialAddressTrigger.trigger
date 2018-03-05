trigger ResidentialAddressTrigger on Residential_Address__c (after Insert,after Update) {
    Set<Id> appIds = new Set<Id>();
    for(Residential_Address__c add : Trigger.new){
       if(add.Application__c!=null){
           appIds.add(add.Application__c);
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
    for(Residential_Address__c add : Trigger.new){
       if(add.Application__c!=null && add.Current_Address__c == true){
           genesis__Applications__c app = appMap.get(add.Application__c);
           app.How_long_you_have_lived_here__c = add.How_Long_have_you_lived_here__c;
           app.Current_Residential_Status__c = add.What_is_Your_Residential_Status__c;
           apps.add(app);
       }
    }
    update apps;
    
}
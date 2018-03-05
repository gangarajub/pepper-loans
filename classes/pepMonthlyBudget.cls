global class pepMonthlyBudget implements Database.Batchable<sObject>,Database.Stateful{
    
    global Database.queryLocator start(Database.BatchableContext BC){
        
         return Database.getQueryLocator('select id,CreatedDate,genesis__New_Value__c,Current_Status__c,genesis__Application__c from genesis__Application_Status_History__c where genesis__New_Value__c=\'APPROVED - CONVERTED TO CONTRACT\' And genesis__Application__r.Monthly_Budget__c = null order by CreatedDate asc');
    }
    
    global void execute(Database.BatchableContext BC,List<sObject> scope){
        
         List<genesis__Application_Status_History__c> listOfApplicationStatus= (List<genesis__Application_Status_History__c>)scope;
         System.debug(listOfApplicationStatus);
         List<Monthly_Budget__c> lstMonthlyBudget = new List<Monthly_Budget__c>();
         List<genesis__Applications__c> lstAppln = new List<genesis__Applications__c>();
         lstMonthlyBudget =  [Select id,Date__c from Monthly_Budget__c];
         Set<id> setID = new Set<id>();
         Map<id,DateTime> mapID = new Map<Id,DateTime>();
         Map<String,id> mapMonthlyID = new Map<String,id>();
         for(monthly_Budget__c objMonth : lstMonthlyBudget){
             
             mapMonthlyID.put(String.ValueOf(objMonth.Date__c.Month() + objMonth.Date__c.Year()),objMonth.id);
             
         }
         
         
         for(genesis__Application_Status_History__c objApplicationStatus : listOfApplicationStatus){
              
               if(objApplicationStatus.genesis__Application__c !=null){
                
                  setID.add(objApplicationStatus.genesis__Application__c); 
                  mapID.put(objApplicationStatus.genesis__Application__c,objApplicationStatus.CreatedDate);               
               }
         }
        
          
         list<genesis__Applications__c> lstApplictions= [select id,CreatedDate,Monthly_Budget__c,pepSettled_Date__c  from genesis__Applications__c where id in:setID];
         if(lstApplictions.size()>0 && lstApplictions.size()!=null){
            for(genesis__Applications__c objApp : lstApplictions){
            
                  objApp.Monthly_Budget__c = mapMonthlyID.get(String.valueOf(mapID.get(objApp.id).Month() + mapID.get(objApp.id).Year()));
                  objApp.pepSettled_Date__c = mapID.get(objApp.id);
                  lstAppln.add(objApp);
            
            }
         }
         
         
         if(lstAppln.Size()>0 && lstAppln.Size()!=null){
            update lstAppln;
         }
       
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
   
}
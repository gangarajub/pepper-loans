//-----------------------------------------------------------------------------------------------------
// Date        : 16/12/2016
// Description : This Batch class is to create Task related to Account if Meeting Notes are not 
// filled in event record . This batch runs on 1pm and 5pm
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
global class CRMBatchClassToCreateTask implements Database.Batchable<sObject>{
    
    global final String Query;
    global final datetime now;

    global CRMBatchClassToCreateTask(){
        now = system.now();
        Query = 'select id,CRM_Meeting_Notes__c,whatId,WhoId from event where whatId != null and CRM_Meeting_Notes__c = null and EndDateTime < : now';
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
     
       return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject>scope){
       
       List<Event> lstEvent = (List<Event>)scope;
       
       set<Id> setId = new set<Id>();
        if(lstEvent != null && lstEvent.size()>0){
            for(Event eve : lstEvent){
                if(eve.WhatID != null){
                   
                    if(String.valueOf(eve.WhatID).subString(0,3) == Account.sobjectType.getDescribe().getKeyPrefix()){
                        if(eve.CRM_Meeting_Notes__c == null){
                           setId.add(eve.WhatID);
                           
                        }
                    }              
                }
            }
        }
        
        List<Account> lstAccount = [select id,Name,CRM_PAF_BDM__c from account where id in : setId];
        
        List<task> lstTask = [select id,subject,WhatId,what.Name,status from task where whatId in : setId and Status = 'Open'];
        //map to check if already a task is created
        Map<id,Boolean> mapAccIdToTskBoolean = new Map<Id,Boolean>();
        if(lstTask != null && lstTask.Size()>0){
            
            for(Task tsk :lstTask){
                
                if(tsk.Subject == tsk.what.Name+' meeting notes and follow up'){
                    if(mapAccIdToTskBoolean.get(tsk.whatId) == null){
                        mapAccIdToTskBoolean.put(tsk.whatId,true);
                    }
                }
            }
            
        }
        //creating a task related to Account
        List<Task> lstTaskToInsert = new List<Task>();
        if(lstAccount != null && lstAccount.size()>0){
            
            for(Account acc : lstAccount){
            
                if(!mapAccIdToTskBoolean.containsKey(acc.id) && acc.CRM_PAF_BDM__c != null){
                    task tsk = new task();
                    tsk.Subject = acc.name+' meeting notes and follow up';
                    tsk.OwnerId = acc.CRM_PAF_BDM__c;
                    tsk.Priority = 'Normal';
                    tsk.Status = 'Open';
                    tsk.ActivityDate = system.today()+1;
                    tsk.whatId = acc.id;
                    lstTaskToInsert.add(tsk);
                }
            }
        }
       
        
        if(lstTaskToInsert != null && lstTaskToInsert.size() >0){
         system.debug(lstTaskToInsert );
            insert lstTaskToInsert;
        }
    }
    global void finish(Database.BatchableContext BC){
            
    }

}
//-----------------------------------------------------------------------------------------------------
// Date        : 19/12/2016
// Description : This Batch class is to update Account Lookup based on Primary Introducer code 
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
global class CRMBatchToUpdateAccLookupOnApplication implements Database.Batchable<sObject>{
    
    global final String Query;

    global CRMBatchToUpdateAccLookupOnApplication(){
    
        Query = 'select id,CRM_Primary_Introducer__c,CRM_Secondary_Introducer_Code__c from CRM_Application__c where CRM_Primary_Introducer__c = null and CRM_Secondary_Introducer_Code__c != null';
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
     
       return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject>scope){
       //set of PrimaryIntroducer code which is prestnt in Account named CMS_Unique_ID__c 
        List<CRM_Application__c> lstApplication = (List<CRM_Application__c>)scope;
        set<integer> setPrimaryInroCode = new set<integer>();
        if(lstApplication != null && lstApplication.size()>0){
            for(CRM_Application__c objApplication : lstApplication){
                
                if(objApplication.CRM_Secondary_Introducer_Code__c != null && objApplication.CRM_Primary_Introducer__c == null){
                    setPrimaryInroCode.add(integer.valueOf(objApplication.CRM_Secondary_Introducer_Code__c));
                }
            }
        }
        system.debug(setPrimaryInroCode);
        
        List<Account> lstAccount = [select id,CRM_CMS_Unique_ID__c from Account where CRM_CMS_Unique_ID__c in : setPrimaryInroCode];
        system.debug(lstAccount );
        Map<integer,Account> mapUniqueIdToAccount = new map<integer,Account>();
        if(lstAccount != null && lstAccount.size()>0){
            
            for(Account acc : lstAccount){
                //map of UniqueID to Account
                if(acc.CRM_CMS_Unique_ID__c != null){
                    mapUniqueIdToAccount.put(integer.valueOf(acc.CRM_CMS_Unique_ID__c),acc);
                }
            }
        
        }
        //update the Lookup on Application
        List<CRM_Application__c> lstApplicationToUpdate = new List<CRM_Application__c>();
        if(lstApplication != null && lstApplication.size()>0){
            for(CRM_Application__c objApplication : lstApplication){
                
                if(objApplication.CRM_Secondary_Introducer_Code__c != null && objApplication.CRM_Primary_Introducer__c == null){
                    if(mapUniqueIdToAccount.containsKey(integer.valueOf(objApplication.CRM_Secondary_Introducer_Code__c)) && 
                        mapUniqueIdToAccount.get(integer.valueOf(objApplication.CRM_Secondary_Introducer_Code__c)) != null){
                    
                        objApplication.CRM_Primary_Introducer__c = mapUniqueIdToAccount.get(integer.valueOf(objApplication.CRM_Secondary_Introducer_Code__c)).id;
                        lstApplicationToUpdate.add(objApplication);
                    }
                }
            }
        }
        
        if(lstApplicationToUpdate != null && lstApplicationToUpdate.size()>0){
            update lstApplicationToUpdate;
        }
        
            
       
       
    }
    global void finish(Database.BatchableContext BC){
            
    }

}
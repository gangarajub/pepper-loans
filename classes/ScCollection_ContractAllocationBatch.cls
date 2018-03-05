//  -------------------------------------------------------------------------------------------------------
//  This class would populate data to be used in report for contract allocation
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 29-SEP-2016   Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestContractAllocationBatch
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_ContractAllocationBatch implements Database.Batchable<sObject> 
{
    String query;
    
    global ScCollection_ContractAllocationBatch() 
    {
        query = 'select Id, ScCollection_Dev_Contract__c, ScCollection_CL_Contract__c from collect__Queue_Contract__c where collect__Status__c = \'open\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        List<collect__Queue_Contract__c> lstQC = (List<collect__Queue_Contract__c>)scope;
        List<ScCollection_Contract_Allocation__c> lstUpdateData = new List<ScCollection_Contract_Allocation__c>();
        Set<Id> setClContractId = new Set<Id>();
        Set<Id> setPlContractId = new Set<Id>();
        Map<Id,Id> mapContractIdToLogId = new Map<Id,Id>();
        
        if(ScCollection_UtilityHandler.isNotNull(lstQC))
        {
            for(collect__Queue_Contract__c objqc : lstQC)
            {
                if(objqc.ScCollection_Dev_Contract__c != Null)
                {
                    setClContractId.add(objqc.ScCollection_Dev_Contract__c);
                }
                else if(objqc.ScCollection_CL_Contract__c != Null)
                {
                    setPlContractId.add(objqc.ScCollection_CL_Contract__c);
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(setClContractId))
            {
                for(collect__Loan_Account__c objcl : [select Id, (select Id from collect__Interaction_Logs__r where collect__Action__r.ScCollection_Head_Status__c != 'CollectionLetterCountActivity' ORDER BY CreatedDate desc limit 1) from collect__Loan_Account__c where Id IN : setClContractId])
                {
                    if(objcl.collect__Interaction_Logs__r != Null && objcl.collect__Interaction_Logs__r.size() > 0)
                    {
                        mapContractIdToLogId.put(objcl.Id,objcl.collect__Interaction_Logs__r[0].Id);
                    }
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(setPlContractId))
            {
                for(loan__Loan_Account__c objpl : [select Id, (select Id from Interaction_Logs__r where collect__Action__r.ScCollection_Head_Status__c != 'CollectionLetterCountActivity' ORDER BY CreatedDate desc limit 1) from loan__Loan_Account__c where Id IN : setPlContractId])
                {
                    if(objpl.Interaction_Logs__r != Null && objpl.Interaction_Logs__r.size() > 0)
                    {
                        mapContractIdToLogId.put(objpl.Id,objpl.Interaction_Logs__r[0].Id);
                    }
                }
            }
            
            for(collect__Queue_Contract__c objqc : lstQC)
            {
                ScCollection_Contract_Allocation__c obj = new ScCollection_Contract_Allocation__c();
                
                obj.ScCollection_Queue_Contract__c = objqc.Id;
                
                if(objqc.ScCollection_Dev_Contract__c != Null)
                {
                    obj.ScCollection_Contract__c = objqc.ScCollection_Dev_Contract__c;
                    obj.ScCollection_External_ID__c = objqc.Id + '-' + objqc.ScCollection_Dev_Contract__c;
                    
                    if(mapContractIdToLogId.containsKey(objqc.ScCollection_Dev_Contract__c) && mapContractIdToLogId.get(objqc.ScCollection_Dev_Contract__c) != Null)
                    {
                        obj.ScCollection_Interaction_Log__c = mapContractIdToLogId.get(objqc.ScCollection_Dev_Contract__c);
                    }
                }
                else if(objqc.ScCollection_CL_Contract__c != Null)
                {
                    obj.ScCollection_CL_Contract__c = objqc.ScCollection_CL_Contract__c;
                    obj.ScCollection_External_ID__c = objqc.Id + '-' + objqc.ScCollection_CL_Contract__c;
                    
                    if(mapContractIdToLogId.containsKey(objqc.ScCollection_CL_Contract__c) && mapContractIdToLogId.get(objqc.ScCollection_CL_Contract__c) != Null)
                    {
                        obj.ScCollection_Interaction_Log__c = mapContractIdToLogId.get(objqc.ScCollection_CL_Contract__c);
                    }
                }
                
                lstUpdateData.add(obj);
            }
            
            if(ScCollection_UtilityHandler.isNotNull(lstUpdateData))
            {
                try
                {
                    upsert lstUpdateData ScCollection_External_ID__c;
                }
                catch(DmlException e) 
                {
                    System.debug(e.getMessage());
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) 
    {
        
    }
}
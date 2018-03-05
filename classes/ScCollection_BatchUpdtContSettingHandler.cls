//  -------------------------------------------------------------------------------------------------------
//  This batch class would update/create the contract setting on basis of fact that whether or not they had interaction logs for the day
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 11-JUNE-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  User Story : Global Settings: Hold days count - Batch class to find out No Action Contract and increase the Hold Days Count on
//  Contract Settings object aginst particular contract.
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestBatchUpdtContSettingHan
//  -------------------------------------------------------------------------------------------------------
Global  class ScCollection_BatchUpdtContSettingHandler implements Database.Batchable<sObject>,Database.Stateful
{
    // string query that will be set from the parent batch
    String QUERY;
    global set<id> setContractswithActivitiesCollection = new set<id>();
    global set<id> setContractswithActivitiesPersonal = new set<id>();
    
    public ScCollection_BatchUpdtContSettingHandler(String query,String typeOfContract,set<id> setContracts)
    {    
        this.QUERY = query;
        
        if(typeOfContract == 'Collection')
        {
            this.setContractswithActivitiesCollection = setContracts;
        }
        else
        {
            this.setContractswithActivitiesPersonal = setContracts;
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method will query the sobject as per string passed by the constructor
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 11-June-2015   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would be used to query the sobject           
    // ----------------------------------------------------------------------------------------------------
    Global Database.QueryLocator start(Database.BatchableContext BC)
    {    
        return Database.getQueryLocator(QUERY);
    }
     
    // ----------------------------------------------------------------------------------------------------
    // This method will process the contract records in batches
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 11-June-2015   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would just look for the contracts,scrutinize them and process them furthur
    // ----------------------------------------------------------------------------------------------------
    global void execute(Database.BatchableContext info, List<Sobject> scope)
    {     
        // handlle the contracts as per the object type
        List<Sobject> lstContract ;
    
        if(scope[0].getsobjectType() == collect__Loan_Account__c.sObjectType)
        {
            lstContract = (List<collect__Loan_Account__c>)scope;
            processCLContarcts(scope);
        }
        else if(scope[0].getsobjectType() == loan__Loan_Account__c.sObjectType)
        {
            lstContract = (List<loan__Loan_Account__c>)scope;
            processPLContarcts(scope);
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method will call another batch to process the reocords
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 10-June-2015   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would just look fot the interaction logs that have tagged activity for the day
    // ----------------------------------------------------------------------------------------------------
    global void finish(Database.BatchableContext BC)
    {
        
    }
     
    private void processCLContarcts(List<collect__Loan_Account__c> lstCLContracts)
    {
        Set<id> setdevContracts = new Set<id>();
        
        // look for the user in contract queue against the contract
        for(collect__Loan_Account__c    temp:lstCLContracts)
        {
            setdevContracts.add(temp.id);
        }
    }
     
    private void processPLContarcts(List<loan__Loan_Account__c> lstPLContracts)
    {   
        // returning Contract Setting instance
        
        List<ScCollection_ContractSettings__c> lstContractSettingtoInsert       =   new List<ScCollection_ContractSettings__c>();
        
        // create a set of name
        set<string> setPLid = new set<string>();
        
        for(loan__Loan_Account__c tempCon:lstPLContracts)
        {
            setPLid.add(tempCon.id);
        }
        
        // query the contract Queue
        List<collect__Queue_Contract__c> lstQueue = [select id,
                                                            collect__User__c,
                                                            collect__Loan_Account_Id__c 
                                                            from collect__Queue_Contract__c 
                                                            where collect__Loan_Account_Id__c in : setPLid];
        
        // make a map for contract against user
        if(lstQueue.size() > 0)
        {
            // if we have some queue with the required combination  
            Map<id,id> mapUserToPLcContracts = new Map<id,id>();
            
            for(collect__Queue_Contract__c  tempQueue:lstQueue)
            {    
                mapUserToPLcContracts.put(tempQueue.collect__Loan_Account_Id__c,tempQueue.collect__User__c);
            }
            
            // look for contract setting with the desired combination
            List<ScCollection_ContractSettings__c> lstContractSetting = new List<ScCollection_ContractSettings__c>();
            Map<id,ScCollection_ContractSettings__c> mapContractIdtoSetting = new Map<id,ScCollection_ContractSettings__c>();
            
            lstContractSetting = [select id,
                                         ScCollection_CLContract__c,
                                         ScCollection_UserLookup__c,
                                         ScCollection_HoldDaysCount__c 
                                         from ScCollection_ContractSettings__c
                                         where ScCollection_CLContract__c in : mapUserToPLcContracts.keyset() AND
                                         ScCollection_UserLookup__c in : mapUserToPLcContracts.values()];
                                                                                         
            if(lstContractSetting.size() > 0)
            {
                for(ScCollection_ContractSettings__c tempSetting:lstContractSetting)
                {
                    mapContractIdtoSetting.put(tempSetting.ScCollection_CLContract__c,tempSetting);
                }
                
                for(Id tempId:mapUserToPLcContracts.keyset())
                {
                    if(mapContractIdtoSetting.containskey(tempId))
                    {
                        ScCollection_ContractSettings__c tempSetting = mapContractIdtoSetting.get(tempId);
                        if(tempSetting.ScCollection_HoldDaysCount__c == 0 || tempSetting.ScCollection_HoldDaysCount__c == Null)
                        {
                            tempSetting.ScCollection_HoldDaysCount__c = 1;
                        }
                        else
                        {
                            tempSetting.ScCollection_HoldDaysCount__c = tempSetting.ScCollection_HoldDaysCount__c + 1;
                        }
                        
                        lstContractSettingtoInsert.add(tempSetting);
                    }
                    else
                    {
                        // create a new setting
                        ScCollection_ContractSettings__c newSetting = new ScCollection_ContractSettings__c();
                        newSetting.ScCollection_CLContract__c = tempId;
                        newSetting.ScCollection_UserLookup__c = mapUserToPLcContracts.get(tempId);
                        newSetting.ScCollection_HoldDaysCount__c = 1;
                        lstContractSettingtoInsert.add(newSetting);
                    }
                }
            }                                                                                           
        }
                
        // insert the settings
        if(lstContractSettingtoInsert.size() > 0)
        {
            upsert lstContractSettingtoInsert;
        }
     }
}
// this class would perform all contract related settings action and would be reffered by all the other classes.
// ----------------------------------------------------------------------------------------------------
// Created Date: 09-JUNE-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// User Story : 
// a. Global Settings: No Answer count - Trigger on Contract Setting object to escalate to supervisor basis on No Ans Count fields on Contract settings
// b.Global Settings: Hold days count - Modified Trigger on Contract Setting object to escalate to supervisor basis on No Commitment Count fields on Contract settings.
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestContractSettingFacade
// ----------------------------------------------------------------------------------------------------
public  class ScCollection_ContractSettingFacade 
{    
    //This method would look for the contract that have crossed the limit and set in global setting and update them(owner field) in the queue contract object 
    public static void updateQueueContract(List<ScCollection_ContractSettings__c> lstCollection)
    {
        // look for the logged in user
        Id userId = UserInfo.getUserId();
        
        // get the custom settng for the user
        ScCollection_Settings__c globalSetting = ScCollection_Settings__c.getInstance(userId);
                
        // iterate over the limits and seperate the contract settigns 
        Set<Id> setPlContracts = new Set<Id>();
        Set<Id> setClContracts = new Set<Id>();
        Set<Id> setAll = new Set<Id>();
        Set<Id> updatedContracts = new Set<Id>();
         
        for(ScCollection_ContractSettings__c setting : lstCollection)
        {
            // look for no answer count
            if(setting.ScCollection_NoAnswerCount__c >= globalSetting.ScCollection_NoAnswerCount__c)
            {
                If(setting.ScCollection_CLContract__c != Null)
                {
                    setPlContracts.add(setting.ScCollection_CLContract__c);
                }
                else if(setting.ScCollection_DevContract__c != Null)
                {
                    setClContracts.add(setting.ScCollection_DevContract__c);
                }
                
                setting.ScCollection_NoAnswerCount__c = 0;
            }
            
            // look for broken promise count
            if(setting.ScCollection_BrokenPromiseCount__c >= globalSetting.ScCollection_BrokenPromiseCount__c)
            {
                If(setting.ScCollection_CLContract__c != Null)
                {
                    setPlContracts.add(setting.ScCollection_CLContract__c);
                }
                else if(setting.ScCollection_DevContract__c != Null)
                {
                    setClContracts.add(setting.ScCollection_DevContract__c );
                }
                
                setting.ScCollection_BrokenPromiseCount__c = 0; 
            }
                        
            // look for No Commitment count
            if(setting.ScCollection_NoCommitmentCount__c >= globalSetting.ScCollection_NoCommitmentCount__c)
            {
                If(setting.ScCollection_CLContract__c != Null)
                {
                    setPlContracts.add(setting.ScCollection_CLContract__c);
                }
                else if(setting.ScCollection_DevContract__c != Null)
                {
                    setClContracts.add(setting.ScCollection_DevContract__c);
                }
                
                setting.ScCollection_NoCommitmentCount__c = 0;
            }
            
            // look for Hold Days  count
            if(setting.ScCollection_HoldDaysCount__c >= globalSetting.ScCollection_HoldDaysCount__c)
            {
                If(setting.ScCollection_CLContract__c != Null)
                {
                    setPlContracts.add(setting.ScCollection_CLContract__c);
                }
                else if(setting.ScCollection_DevContract__c != Null)
                {
                    setClContracts.add(setting.ScCollection_DevContract__c);                    
                }
                
                setting.ScCollection_HoldDaysCount__c = 0;
            }
        }
         
        // look if we have any contracts in CL or Pl
        if(setPlContracts.size() > 0 || setClContracts.size() > 0)
        {
            List<collect__Contract_Status__c> lstStatus = new List<collect__Contract_Status__c>();
            setAll.addAll(setPlContracts);
            setAll.addAll(setClContracts);
            
            // look for the logged in User's immidiate Superior
            User manager = [select managerid from user where id =: userId];
             
            if(manager.managerid != Null)
            {
                List<collect__Queue_Contract__c> lstQueueContract = new List<collect__Queue_Contract__c>();
                // query the contract queue
                lstQueueContract = [select Id,
                                           collect__User__c,
                                           collect__Lease_Account_Id__c,
                                           collect__Loan_Account_Id__c
                                           from collect__Queue_Contract__c
                                           where(collect__Loan_Account_Id__c IN :setAll AND 
                                                 collect__User__c =: userId)];
                                                                                
                if(lstQueueContract.size() > 0)
                {
                    for(collect__Queue_Contract__c tempContract:lstQueueContract)
                    {
                        tempContract.collect__User__c = manager.managerid;
                        updatedContracts.add(tempContract.collect__Loan_Account_Id__c);
                    }
                
                    update lstQueueContract;
                }
               
                // update contract status of cl and pl
                if(lstQueueContract.size() > 0)
                {
                    // update the cl accounts
                    List<collect__Loan_Account__c> lstCLAccounts = new List<collect__Loan_Account__c>();
                    lstCLAccounts = [select Id, 
                                            collect__Collection_Status__c,
                                            collect__Collection_Status__r.ScCollection_IsRefered__c 
                                            from collect__Loan_Account__c 
                                            where Id IN : updatedContracts];
                    
                    if(lstCLAccounts.size() > 0)
                    {
                        for(collect__Loan_Account__c tempAccount : lstCLAccounts)
                        {
                            if(tempAccount.collect__Collection_Status__c != Null && tempAccount.collect__Collection_Status__r.ScCollection_IsRefered__c == false)
                            {
                                collect__Contract_Status__c tempStatus = new collect__Contract_Status__c(id=tempAccount.collect__Collection_Status__c);
                                tempStatus.ScCollection_IsRefered__c = true;
                                lstStatus.add(tempStatus);
                            }
                        }  
                    }
                
                    //update the pl contracts
                    List<loan__Loan_Account__c> lstPLAccounts = new List<loan__Loan_Account__c>();
                    lstPLAccounts = [select Id,
                                            ScCollection_Collection_Status__c,
                                            ScCollection_Collection_Status__r.ScCollection_IsRefered__c 
                                            from loan__Loan_Account__c 
                                            where Id IN : updatedContracts];
                
                    if(lstPLAccounts.size() > 0)
                    {
                        for(loan__Loan_Account__c tempAccount : lstPLAccounts)
                        {
                            if(tempAccount.ScCollection_Collection_Status__c != Null && tempAccount.ScCollection_Collection_Status__r.ScCollection_IsRefered__c == false )
                            {
                                collect__Contract_Status__c tempStatus = new collect__Contract_Status__c(id=tempAccount.ScCollection_Collection_Status__c);
                                tempStatus.ScCollection_IsRefered__c = true;
                                lstStatus.add(tempStatus);
                            }
                        } 
                    }
                }
                
                if(lstStatus.size() > 0)
                {
                    update lstStatus;
                }
            }
        } 
    }
    
    //This method would take the map of id of contract and the new owner against it would return the queue contract against the contract with new owner set
    public static List<collect__Queue_Contract__c> updateContractOwners(Map<id,id> mapContractToOwner)
    {    
        Map<Id,Id> mapPlContracts = new Map<Id,Id>();
        Map<Id,Id> mapClContracts = new Map<Id,Id>();
        
        // seperate the contracts
        for(Id contractId:mapContractToOwner.keyset())
        {
            If(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'collect__Loan_Account__c')
            {
                mapClContracts.put(contractId,mapContractToOwner.get(contractId));
            }
            else if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'loan__Loan_Account__c')
            {
                mapPlContracts.put(contractId,mapContractToOwner.get(contractId));
            }
        }
        
        List<collect__Queue_Contract__c> lstQueueContract = new List<collect__Queue_Contract__c> ();
        
        if(mapClContracts.size() > 0 || mapPlContracts.size() > 0)
        {
            // look for queue contracts
            lstQueueContract = [select Id,
                                       ScCollection_CL_Contract__c,
                                       ScCollection_Dev_Contract__c,
                                       collect__User__c   
                                       from 
                                       collect__Queue_Contract__c
                                       where 
                                       ScCollection_CL_Contract__c IN :mapPlContracts.keySet() OR
                                       ScCollection_Dev_Contract__c IN :mapClContracts.keySet()];
            
            if(lstQueueContract.size() > 0)
            {
                //set the owner
                for(collect__Queue_Contract__c tempQueue:lstQueueContract)
                {
                    if(mapClContracts.containskey(tempQueue.ScCollection_Dev_Contract__c))
                    {
                        tempQueue.collect__User__c = mapClContracts.get(tempQueue.ScCollection_Dev_Contract__c);
                    }
                    else if(mapPlContracts.containskey(tempQueue.ScCollection_CL_Contract__c))
                    {
                        tempQueue.collect__User__c = mapPlContracts.get(tempQueue.ScCollection_CL_Contract__c);
                    }
                }
                
                return lstQueueContract;
            }
        }
        return null;
    }
}
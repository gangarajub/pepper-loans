// --------------------------------------------------------------------------------------------------------
// This class handles all the trigger events on collect__Queue_Contract__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 29-July-2016        Created By: Pawan Mudgal           Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestQueueContractTrigger
// --------------------------------------------------------------------------------------------------------
public class ScCollection_QueueContractHandler 
{
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the Before insert events on Queue Contract Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 29-July-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeInsert(List<collect__Queue_Contract__c> lstNew)
    {
        updateContractLookup(lstNew);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after insert events on Queue Contract Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 17-Nov-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<collect__Queue_Contract__c> lstNew)
    {
        
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on Queue Contract Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 17-Nov-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(Map<Id,collect__Queue_Contract__c> mapOld, List<collect__Queue_Contract__c> lstNew)
    {
       
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method updates the lookup field on queue contract on the basis of contract id in queue contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 29-July-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    // Modified Date: 8-August-2016   Modified By: Pawan Mudgal  Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void updateContractLookup(List<collect__Queue_Contract__c> lstQC)
    {
        if(ScCollection_UtilityHandler.isNotNull(lstQC))
        {
            // create list of account Id's
            List<Id> lstId = new List<id>();
            
            for(collect__Queue_Contract__c objqc : lstQC)
            {
                lstId.add(objqc.collect__Loan_Account_Id__c);
            }
            
            if(lstId.size() > 0)
            { 
                Map<Id,String> MapAccIdToObjectName = new Map<Id,String>();
                MapAccIdToObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(lstId);
                    
                if(MapAccIdToObjectName.keyset().size() > 0)
                {
                    for(collect__Queue_Contract__c objqc : lstQC)
                    {
                        if(ScCollection_UtilityHandler.isNotNull(objqc.collect__Loan_Account_Id__c) && MapAccIdToObjectName.containskey(objqc.collect__Loan_Account_Id__c))
                        {
                            String objectType = MapAccIdToObjectName.get(objqc.collect__Loan_Account_Id__c);

                            if(objectType == 'loan__Loan_Account__c')
                            {
                                objqc.ScCollection_CL_Contract__c = objqc.collect__Loan_Account_Id__c;
                            }
                            else if(objectType == 'collect__Loan_Account__c')
                            {
                                objqc.ScCollection_Dev_Contract__c = objqc.collect__Loan_Account_Id__c;
                            }
                        }
                    }
                }
            }
        }
    }
}
//  -------------------------------------------------------------------------------------------------------
//  This class handles all the trigger events on collect__Bank_Account__c Object
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 27-JULY-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestBankAccountHandler
//  -------------------------------------------------------------------------------------------------------
// Description : 1. For Mortgage Source System, We are tagging the Banks with Contract with the help of Contract External Id on Bank Account Record.
//               2. For PAF Source System, First,we are finding the associated Account/Contact and then basis on those Account/Contact we are getting the contract and tagging over the contract.
public class ScCollection_BankAccountHandler
{
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the After insert events on Promise to pay Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 27-JULY-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<collect__Bank_Account__c> lstNew)
    {
        updateBankAccountOnContract(lstNew);
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to update bank account lookup on contract object
    // ---------------------------------------------------------------------------------------------------
    // created Date : 27-July-2016   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void updateBankAccountOnContract(List<collect__Bank_Account__c> lstNew)
    {
        Map<String,collect__Bank_Account__c> mapExternalIdToBankAccountRecord = new Map<String,collect__Bank_Account__c>();
        Map<Id,collect__Bank_Account__c> mapBorrowerIdToBankAccountRecord = new Map<Id,collect__Bank_Account__c>();
        List<collect__Loan_Account__c> lstUpdateContracts = new List<collect__Loan_Account__c>();

        for(collect__Bank_Account__c obj : lstNew)
        {
            if(obj.collect__Source_System__c != Null)
            {
                if(obj.ScCollection_Source_System_Name__c != null && ScCollection_UtilityHandler.getPlainString(String.valueOf(obj.ScCollection_Source_System_Name__c)) == ScCollection_UtilityHandler.getPlainString('MORTGAGE'))
                {
                    if(obj.collect__External_ID__c != Null)
                    {
                        mapExternalIdToBankAccountRecord.put(obj.collect__External_ID__c, obj);
                    }
                }
                else if(obj.ScCollection_Source_System_Name__c != null && ScCollection_UtilityHandler.getPlainString(String.valueOf(obj.ScCollection_Source_System_Name__c)) == ScCollection_UtilityHandler.getPlainString('PAF'))
                {
                    if(obj.collect__Account__c != Null)
                    {
                        mapBorrowerIdToBankAccountRecord.put(obj.collect__Account__c, obj); 
                    }
                }
            }
        }
        
        if(mapExternalIdToBankAccountRecord != Null && mapExternalIdToBankAccountRecord.size() > 0)
        {
            List<collect__Loan_Account__c> lstContracts = [select Id,
                                                                    collect__External_ID__c,
                                                                    ScCollection_Bank_Account__c,
                                                                    ScCollection_Account_Number__c
                                                                    from collect__Loan_Account__c
                                                                    where collect__External_ID__c IN : mapExternalIdToBankAccountRecord.keySet()];

            if(ScCollection_UtilityHandler.isNotNull(lstContracts))
            {
                for(collect__Loan_Account__c objcon : lstContracts)
                {
                    if(mapExternalIdToBankAccountRecord.containsKey(objcon.collect__External_ID__c) && mapExternalIdToBankAccountRecord.get(objcon.collect__External_ID__c) != Null)
                    {
                        objcon.ScCollection_Bank_Account__c = mapExternalIdToBankAccountRecord.get(objcon.collect__External_ID__c).Id;
                        objcon.ScCollection_Account_Number__c = mapExternalIdToBankAccountRecord.get(objcon.collect__External_ID__c).collect__Bank_Account_Number__c;
                        lstUpdateContracts.add(objcon);
                    }
                }
            }
        }

        if(mapBorrowerIdToBankAccountRecord != Null && mapBorrowerIdToBankAccountRecord.size() > 0)
        {
            for(clcommon__Party__c objParty : [select Id,
                                                      collect__CL_Contract__c,
                                                      clcommon__Account__c
                                                      from clcommon__Party__c
                                                      where collect__CL_Contract__c != Null AND
                                                      clcommon__Type__r.Name = 'Primary Borrower' AND
                                                      clcommon__Account__c IN : mapBorrowerIdToBankAccountRecord.keySet()])
            {
                collect__Loan_Account__c objcon = new collect__Loan_Account__c(Id = objParty.collect__CL_Contract__c);
                
                if(mapBorrowerIdToBankAccountRecord.containsKey(objParty.clcommon__Account__c) && mapBorrowerIdToBankAccountRecord.get(objParty.clcommon__Account__c) != Null)
                {
                    objcon.ScCollection_Bank_Account__c = mapBorrowerIdToBankAccountRecord.get(objParty.clcommon__Account__c).Id;
                    objcon.ScCollection_Account_Number__c = mapBorrowerIdToBankAccountRecord.get(objParty.clcommon__Account__c).collect__Bank_Account_Number__c;
                    lstUpdateContracts.add(objcon);
                }
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(lstUpdateContracts))
        {
            try
            {
                update lstUpdateContracts;
            }
            catch(DmlException e)
            {
                system.debug(e.getMessage());
            }
        }
    }
}
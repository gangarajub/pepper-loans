// --------------------------------------------------------------------------------------------------------
// This class handles all the trigger events on loan__loan_account__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 26-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestPersonalContractHanler
// --------------------------------------------------------------------------------------------------------
public class ScCollection_PersonalContractHanler 
{
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before insert events on Pl Contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 25-SEP-2016          Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeInsert(List<loan__Loan_Account__c> lstNew) 
    {
        //create new contract status and tag it to the contract
        CreateContractStatus(lstNew);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on Pl Contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 25-SEP-2016          Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(List<loan__Loan_Account__c> lstNew, Map<Id,loan__Loan_Account__c> oldMap) 
    {
        //populate the status on contract status
        UpdateContractStatus(lstNew,oldMap);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method will insert new contract status against the contract when a contract is created
    // ----------------------------------------------------------------------------------------------------
    // Created Date:   26-SEP-2016     Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void CreateContractStatus(List<loan__Loan_Account__c> lstNew)
    {
        List<wrapperForMapping> lstWrapp = new List<wrapperForMapping>();
        List<collect__Contract_Status__c> tempListtoInsert = new List<collect__Contract_Status__c>();
         
        // create new contract status for each contract
        for(loan__Loan_Account__c tempLoanAccount : lstNew)
        {   
            collect__Contract_Status__c tempStatus  = new collect__Contract_Status__c();
            tempStatus.ScCollection_LOB_Identifier__c = 'CL Loan';
            tempStatus.ScCollection_Contract_Name__c = tempLoanAccount.Name;
            tempListtoInsert.add(tempStatus);
            lstWrapp.add(new wrapperForMapping(tempStatus,tempLoanAccount));    
        }
        
        if(tempListtoInsert.size() > 0)
        {
            insert tempListtoInsert;
        }
        
        for(wrapperForMapping tempLoanAccount : lstWrapp)
        {
            tempLoanAccount.contract.ScCollection_Collection_Status__c = tempLoanAccount.status.id;
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method will update contract status against the contract when a contact is updated
    // ----------------------------------------------------------------------------------------------------
    // Created Date:   26-Sep-2016     Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void UpdateContractStatus(List<loan__Loan_Account__c> lstNew, Map<Id,loan__Loan_Account__c> oldMap)
    {
        Set<Id> setStatusIds = new Set<Id>();
        List<collect__Contract_Status__c> lstUpdateStatus = new List<collect__Contract_Status__c>();
        Map<Id,collect__Contract_Status__c> MapContractStatus = new Map<Id,collect__Contract_Status__c>();
        
        for(loan__Loan_Account__c obj : lstNew)
        {
            if((obj.loan__Loan_Status__c != Null && obj.loan__Loan_Status__c != oldMap.get(obj.Id).loan__Loan_Status__c) || (obj.FirstLPTRejected__c && oldMap.get(obj.Id).FirstLPTRejected__c != true))
            {
                if(obj.ScCollection_Collection_Status__c != Null)
                {
                    setStatusIds.add(obj.ScCollection_Collection_Status__c);
                }
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(setStatusIds))
        {
            for(collect__Contract_Status__c objstat : [select Id from collect__Contract_Status__c where Id IN : setStatusIds])
            {
                MapContractStatus.put(objstat.Id, objstat);
            }
        }
        
        for(loan__Loan_Account__c obj : lstNew)
        {
            if(obj.ScCollection_Collection_Status__c != Null)
            {
                if(MapContractStatus.containsKey(obj.ScCollection_Collection_Status__c) && MapContractStatus.get(obj.ScCollection_Collection_Status__c) != Null)
                {
                    collect__Contract_Status__c objstatus = MapContractStatus.get(obj.ScCollection_Collection_Status__c);
                    
                    if(obj.loan__Loan_Status__c != Null && obj.loan__Loan_Status__c != oldMap.get(obj.Id).loan__Loan_Status__c)
                    {
                        if(ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Active - Bad Standing'))
                        {
                            objstatus.ScCollection_Arrears__c = 'Overdue';
                            lstUpdateStatus.add(objstatus);
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Active - Good Standing') || ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Approved'))
                        {
                            objstatus.Main_Status__c = 'Current';
                            lstUpdateStatus.add(objstatus);
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Active - Matured') || ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Written Off'))
                        {
                            objstatus.ScCollection_Loss_Recoveries__c = 'Loss Recoveries';
                            lstUpdateStatus.add(objstatus);
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Obligations Met'))
                        {
                            objstatus.ScCollection_Misc_Status__c = 'Closed - Maturity';
                            lstUpdateStatus.add(objstatus);
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Premature') || ScCollection_UtilityHandler.getPlainString(obj.loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Refinanced'))
                        {
                            objstatus.ScCollection_Misc_Status__c = 'Closed Early Payout';
                            lstUpdateStatus.add(objstatus);
                        }
                    }
                    
                    if(obj.FirstLPTRejected__c && oldMap.get(obj.Id).FirstLPTRejected__c != true)
                    {
                        objstatus.ScCollection_Arrears__c = 'First Payment Default';
                        objstatus.ScCollection_First_Payment_Default_Date__c = System.Today();
                        lstUpdateStatus.add(objstatus);
                    }
                }
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdateStatus))
        {
            try
            {
                update lstUpdateStatus;
            }
            catch(Exception e)
            {
                system.debug('contract status update error : ' + e.getMessage());
            }
        }        
    }
    
    public class wrapperForMapping
    {
        public collect__Contract_Status__c status;
        public loan__Loan_Account__c contract;
        
        public wrapperForMapping(collect__Contract_Status__c status, loan__Loan_Account__c contract)
        {
            this.status = status;
            this.contract = contract;
        }
    }
}
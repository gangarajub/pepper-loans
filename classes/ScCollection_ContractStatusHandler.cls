// --------------------------------------------------------------------------------------------------------
// This class handles all the trigger events on collect__Contract_Status__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 30-June-2016  Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestContractStatusHandler
// --------------------------------------------------------------------------------------------------------
// Modified Date : 03-Oct-2016  Modified By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
// Modification : Added counter reset for hardship declined status
// --------------------------------------------------------------------------------------------------------
public class ScCollection_ContractStatusHandler 
{    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before update events on Contract Status
    // ----------------------------------------------------------------------------------------------------
    // Created Date :  July-5-2016     Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    // Description  :  this method would perform all before update
    public void onBeforeUpdate(list<collect__Contract_Status__c> lstNew,Map<id,collect__Contract_Status__c> newMap,Map<id,collect__Contract_Status__c> oldMap) 
    {
        // set hardship days flag false
        setContractStatus(lstNew,newMap,oldMap);
        // reset the counters
        updateContractSetting(lstNew,newMap,oldMap);
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on Contract Status
    // ----------------------------------------------------------------------------------------------------
    // Created Date :  30-June-2015     Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    // Description  :  this method would perform all after update
    public void onAftereUpdate(list<collect__Contract_Status__c> lstNew,Map<id,collect__Contract_Status__c> newMap,Map<id,collect__Contract_Status__c> oldMap) 
    {
        
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before update events on Contract Status
    // ----------------------------------------------------------------------------------------------------
    // Created Date :  July-5-2016     Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    // Description  :  this method would look  for hardhip status and set the checkbox the hardship days to false
    private void setContractStatus(list<collect__Contract_Status__c> lstNew,Map<id,collect__Contract_Status__c> newMap,Map<id,collect__Contract_Status__c> oldMap)
    {
        for(collect__Contract_Status__c tempStatus : lstNew)
        {
            if(tempStatus.ScCollection_HardshipAllDocumentReceived__c && tempStatus.ScCollection_Hardship__c != 'Hardship Requested' && tempStatus.ScCollection_Hardship__c != 'Hardship Entered')
            {
                if(newmap.get(tempStatus.id).ScCollection_Hardship__c !=  oldmap.get(tempStatus.id).ScCollection_Hardship__c)
                {
                    tempStatus.ScCollection_HardshipAllDocumentReceived__c = false;
                }
            }

            if(Label.ScCollection_EscalationToSupervisorDaysHardship != Null)
            {
                if(tempStatus.ScCollection_DayssinceHardshipRequested__c == decimal.valueOf(Label.ScCollection_EscalationToSupervisorDaysHardship))
                {
                    tempStatus.ScCollection_IsRefered__c = true;
                }
            }
        }   
    }
    
    private void updateContractSetting(list<collect__Contract_Status__c> lstNew,Map<id,collect__Contract_Status__c> newMap,Map<id,collect__Contract_Status__c> oldMap)
    {
        // look for the contract status whose remarkting has changed
        for(collect__Contract_Status__c tempStatus : lstNew)
        {
        /*
            if(tempStatus.ScCollection_Remarketing__c != Null && ScCollection_UtilityHandler.getPlainString(String.valueOf(tempStatus.ScCollection_Remarketing__c)) == ScCollection_UtilityHandler.getPlainString('Out with Agent') && ScCollection_UtilityHandler.getPlainString(String.valueOf(oldMap.get(tempStatus.id).ScCollection_Remarketing__c)) != ScCollection_UtilityHandler.getPlainString('Out with Agent'))
            {
                tempStatus.ScCollection_RemarketingStatus__c = 0;
            }
            
            if(tempStatus.ScCollection_Remarketing__c != Null && ScCollection_UtilityHandler.getPlainString(String.valueOf(tempStatus.ScCollection_Remarketing__c)) == ScCollection_UtilityHandler.getPlainString('Repossessed') && ScCollection_UtilityHandler.getPlainString(String.valueOf(oldMap.get(tempStatus.id).ScCollection_Remarketing__c)) != ScCollection_UtilityHandler.getPlainString('Repossessed'))
            {
                tempStatus.ScCollection_RepossesionCount__c = 0;
            }
            
            if(tempStatus.ScCollection_Remarketing__c != Null && ScCollection_UtilityHandler.getPlainString(String.valueOf(tempStatus.ScCollection_Remarketing__c)) == ScCollection_UtilityHandler.getPlainString('Form-14 Issued') && ScCollection_UtilityHandler.getPlainString(String.valueOf(oldMap.get(tempStatus.id).ScCollection_Remarketing__c)) != ScCollection_UtilityHandler.getPlainString('Form-14 Issued'))
            {
               tempStatus.ScCollection_Dayssinceform14issued__c = 0;
            }
           */ 
            if(tempStatus.ScCollection_Hardship__c != Null && ScCollection_UtilityHandler.getPlainString(String.valueOf(tempStatus.ScCollection_Hardship__c)) == ScCollection_UtilityHandler.getPlainString('Hardship Requested') && ScCollection_UtilityHandler.getPlainString(String.valueOf(oldMap.get(tempStatus.id).ScCollection_Hardship__c)) != ScCollection_UtilityHandler.getPlainString('Hardship Requested')) 
            {
                tempStatus.ScCollection_DayssinceHardshipRequested__c = 0;
            }
            
           // code added on 3rd of october by deepak dhingra
           // to maintain the hardship declied days
           if(tempStatus.ScCollection_Hardship__c != Null && ScCollection_UtilityHandler.getPlainString(String.valueOf(tempStatus.ScCollection_Hardship__c)) == ScCollection_UtilityHandler.getPlainString('Hardship Declined') && ScCollection_UtilityHandler.getPlainString(String.valueOf(oldMap.get(tempStatus.id).ScCollection_Hardship__c)) != ScCollection_UtilityHandler.getPlainString('Hardship Declined')) 
            {
                tempStatus.ScCollection_DaysSince_Hardship_Declined__c = 0;
            }

            if(tempStatus.ScCollection_HardshipAllDocumentReceived__c == true && oldMap.get(tempStatus.id).ScCollection_HardshipAllDocumentReceived__c == false) 
            {
                tempStatus.ScCollection_DayssinceHardshipRequested__c = 0;
            }
            
            if(tempStatus.ScCollection_Arrears__c != Null && oldMap.get(tempStatus.id).ScCollection_Arrears__c == Null) 
            {
                tempStatus.scCollection_ArrearsDaysCount__c = 0;
            }
            
            if(tempStatus.ScCollection_Complaint__c != Null && oldMap.get(tempStatus.id).ScCollection_Complaint__c == Null) 
            {
                tempStatus.ScCollection_ComplaintDays__c = 0;
            }
            
            if(tempStatus.ScCollection_Hardship__c != Null && oldMap.get(tempStatus.id).ScCollection_Hardship__c == Null) 
            {
                tempStatus.ScCollection_HardshipDays__c = 0;
            }
        }
    }

    //This method is created for the updating Hardship status on the Contract Status when the Hardship is
    //Requested, Hardship is declined, Harship is approved and Hardship Days count is high for contract
    // Created Date: 13-July-2016   Created By: Kripa Sindhu Singh  Email: kripa.sindhu@saasfocus.com
    public void updateContractPriority(list<collect__Contract_Status__c> lstContractStatus,Map<id,collect__Contract_Status__c> oldMap)
    {
        // Sets used for the setting up high Priority in Contract Status
        // Set Of Contract Settins which are coming in the Trigger
        set<ID> setCSPriority = new set<Id>();
        set<Id> setSCEscalate = new set<Id>();

        // list to bind Cl accounts
        list<collect__loan_Account__c> lstClAccount = new list<collect__loan_Account__c>();
        // list to bind the PL contracts
        list<loan__loan_Account__c> lstPLAccount = new list<loan__loan_Account__c>();
       
        // List of Update on the contract object with the High priority
        list<collect__Loan_Account__c> lstCLupdate = new list<collect__Loan_Account__c>();
        // List for Pl Account Update
        list<loan__loan_Account__c> lstPLUpdate = new list<Loan__loan_Account__c>();
        
        if(lstContractStatus != null && lstContractStatus.size() >0 )
        {
            for(collect__Contract_Status__c objCS : lstContractStatus)
            {
                if(Label.ScCollection_MarkAsPriorityDaysHardship != Null)
                {
                    if(objCS.ScCollection_DayssinceHardshipRequested__c == decimal.valueOf(Label.ScCollection_MarkAsPriorityDaysHardship))
                    {
                        setCSPriority.add(objCS.ID);
                    }
                }
                else
                {
                    objCS.addError('There is no value defined for MarkAsPriorityDaysHardship custom label.');                        
                }
                
                if(Label.ScCollection_EscalationToSupervisorDaysHardship != Null)
                {
                    if(objCS.ScCollection_DayssinceHardshipRequested__c == decimal.valueOf(Label.ScCollection_EscalationToSupervisorDaysHardship) && objCS.ScCollection_DayssinceHardshipRequested__c != oldMap.get(objCS.Id).ScCollection_DayssinceHardshipRequested__c)
                    {
                        setSCEscalate.add(objCS.ID);
                    }
                }
                else
                {
                    objCS.addError('There is no value defined for EscalationToSupervisorDaysHardship custom label.');                        
                }
            }
        }

        if(setCSPriority.size() > 0)
        {
            lstClAccount = [Select Id, collect__Collection_Status__c, ScCollection_Priority__c from collect__loan_Account__c where collect__Collection_Status__c IN : setCSPriority];
            lstPLAccount = [Select Id, ScCollection_Collection_Status__c, ScCollection_ContractPriority__c from loan__loan_Account__c where ScCollection_Collection_Status__c IN: SetCSPriority];
        }

        if(ScCollection_UtilityHandler.isNotNull(lstClAccount))
        {
            for(collect__Loan_Account__c objClAccount : lstClAccount)
            {
                objClAccount.ScCollection_Priority__c = 'High';
                lstClUpdate.add(objClAccount);
            }

            if(ScCollection_UtilityHandler.isNotNull(lstClUpdate))
            {
                try
                {
                    update lstCLUpdate;
                }
                catch(Exception e)
                {
                    system.debug('Update on Collect Contract Failed Due to following error : ' + e.getMessage());
                }
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(lstPlAccount))
        {
            for(loan__Loan_Account__c objPlAccount : lstPLAccount)
            {
                objPLAccount.ScCollection_ContractPriority__c = 'High';
                lstPLUpdate.add(objPLAccount);
            }

            if(ScCollection_UtilityHandler.isNotNull(lstPlUpdate))
            {
                try
                {
                    update lstPLUpdate;
                }
                catch(Exception e)
                {
                    system.debug('Update On CL Contract Failed due to following error : ' + e.getMessage());
                }
            }
        }
        
        // Contract setting which are going to escalate to there Supervisors 
        if(setSCEscalate != null && setSCEscalate.size() > 0)
        {
            // List of contract to be updated with escalation to thier manager
            list<collect__loan_Account__c> lstECLAccount = new list<collect__loan_Account__c>();
            list<loan__Loan_Account__c> lstEPLAccount = new list<loan__Loan_Account__c>();
            set<Id> setContractId = new set<ID>();
            list<collect__Queue_Contract__c> lstQueueContract = new list<collect__Queue_Contract__c>();
            
            lstECLAccount = [Select Id, Name From collect__loan_Account__c where collect__Collection_Status__c IN: setSCEscalate];
            lstEPLAccount = [Select Id, Name From loan__loan_Account__c where ScCollection_Collection_Status__c IN : setSCEscalate];
            
            if(lstECLAccount != null && lstECLAccount.size() > 0)
            {
                for(collect__loan_Account__c objCl : lstECLAccount)
                {
                    setContractId.add(objCL.ID);
                }
            }
            if(lstEPLAccount != null && lstEPLAccount.size() > 0)
            {
                for(loan__loan_Account__c objPL : lstEPLAccount)
                {
                    setContractId.add(objPL.Id);
                }
            }

            if(setContractId != null && setContractID.size() > 0)
            {
                lstQueueContract = [select Id, collect__Loan_Account_Id__c, collect__User__c, collect__User__r.ManagerId from collect__Queue_Contract__c where collect__Loan_Account_Id__c IN : setContractId];
            }
            
            if(lstQueueContract != null && lstQueueContract.size() > 0)
            {
                map<Id,set<Id>> mapUserIdToListOfContract = new map<Id,set<Id>>();
                
                String queueId ='';
                List<collect__Queue__c> lstQueue = [Select Id from collect__Queue__c where collect__Permanent__c = true and collect__Enabled__c = true limit 1];
                if(lstQueue != null && lstQueue.size()>0){
                    queueId = lstQueue[0].Id;
                }
                for(collect__Queue_Contract__c objQC : lstQueueContract){
                    if(objQC.collect__User__c != null && objQC.collect__User__r.ManagerId != null){
                        if(mapUserIdToListOfContract.get(objQC.collect__User__r.ManagerId) == null){
                            mapUserIdToListOfContract.put(objQC.collect__User__r.ManagerId,new set<Id>());
                        }
                        mapUserIdToListOfContract.get(objQC.collect__User__r.ManagerId).add(objQC.collect__Loan_Account_Id__c);
                    }
                }
                
                if(mapUserIdToListOfContract != null && mapUserIdToListOfContract.Size() > 0){
                    for(Id usrId : mapUserIdToListOfContract.KeySet()){
                        
                        if(mapUserIdToListOfContract.get(usrId) != null){
                            set<Id> setContracts = mapUserIdToListOfContract.get(usrId);
                        
                            try{
                                if(queueId !=''){
                                    collect.API4 api = collect.APIFactory.getAPI4();
                                    collect.Result res = api.userAssignment(setContracts, usrId, queueId, 'Permanent', null, null);
                                    system.debug(res );
                                 }     
                            }
                            catch(Exception ex){
                                system.debug(ex.getMessage());
                            } 
                        }
                    }
                }
            }
        }
    } 
}
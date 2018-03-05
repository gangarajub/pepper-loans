//  ------------------------------------------------------------------------------------------------------------------
//  This Class is used to assign Users for the contract using Queue Contracts from page layout Custom button Action
//  ------------------------------------------------------------------------------------------------------------------
//  Created Date: 4-July-2016       Created By: Kripa Sindhu Singh          Email: kripa.sindhu@saasfocus.com
//  ------------------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestUserAssignController
//  ------------------------------------------------------------------------------------------------------------------
//  Modified Date: 27-July-2016      Modified By: Kashish Dwivedi
//  1. Modified the functionality as it's not correctly implemented.
//  It will first find out the Queues based on Logged-In User and his/her Suervisor and then find out the queue contracts based 
//  on current contract and above queue ids and then change the users on those queue contracts.
//  2. Implement certain checks like Global Limit is set for user, Manager is assigned to the user and Logged-In
//  user and his/her manager both are in same queues or not.
//  3. Update the Refer to Supervisor checkbox on associated status record of current contract.
//  4. Update the 'Daily Refer Count' for Logged-In user if it's successfully reffered to the supervisor.
//  ------------------------------------------------------------------------------------------------------------------
global class ScCollection_ConUserAssignController 
{
    //  --------------------------------------------------------------------------------------------------------------
    //  This method is created to refer the Contract to the supervisor of the User who is assigned with the cotract.
    //  --------------------------------------------------------------------------------------------------------------
    //  Created Date: 04-July-2016      Created by: Kripa Sindhu Singh      Email: kripa.sindhu@saasfocus.com
    //  --------------------------------------------------------------------------------------------------------------
    webservice static String referToSupervisior(Id cId)
    {
        //initialise cls collect api to be used in class
        collect.API4 api = collect.APIFactory.getAPI4();
        
        String contractId = string.valueOf(cId);
    
        // List for the PLACCOUNT
        List<loan__Loan_Account__c> lstPLContract = new List<loan__Loan_Account__c>();
        // List to bind the Contract in the queue Contract
        // List for Contract Stauts Which has to be updated
        List<collect__Contract_Status__c> lstCS = new List<collect__Contract_Status__c>();
        String SourceSystem = '';
        // map of Queue Contract object to User Id
        Map<collect__Queue_Contract__c, String> mapQUtoUser = new Map<Collect__Queue_Contract__c, String>();
        
        List<collect__Queue_Contract__c> LstQueueContract = new list<collect__Queue_Contract__c>();
        List<collect__Queue_Contract__c> LstQCUpdate = new list<collect__Queue_Contract__c>();
        
        List<User> lstUser = new List<User>([Select Id, ManagerId,Manager.Name,
                                            ScCollection_Daily_Refer_Count__c, 
                                            ScCollection_Daily_Refer_Counter_Date__c 
                                            from User 
                                            where isActive = true AND Id =: UserInfo.getUserId()]);
        
        decimal ReferCount = lstUser[0].ScCollection_Daily_Refer_Count__c;
        Date ReferCountDate = lstUser[0].ScCollection_Daily_Refer_Counter_Date__c;
        Id currentUserMgr = lstUser[0].ManagerId;
        
        if(currentUserMgr == null)
        {
            return('There is no supervisor assigned to you. Kindly request your administrator to set your supervisor.');    
        }
        
        ScCollection_Settings__c globalSetting = ScCollection_Settings__c.getInstance(UserInfo.getUserId());
        
        if(globalSetting.ScCollection_DailyReferCap__c == null)
        {
            return('Daily Refer Cap cap limit is not set for you. Kindly request your administrator to set the limit.');
        }
               
        if(contractId != Null)
        {
            set<Id> setConIds = new set<Id>();
            setConIds.add(contractId);
            
            // fetch the permanent queue 
            List<collect__Queue__c> lstQueue = [Select Id from collect__Queue__c where collect__Permanent__c = true limit 1];
            Id queueId;
            if(lstQueue != null && lstQueue.size() > 0)
            {
                queueId = lstQueue[0].Id;
            }
            else
            {
                return('There is no permanent queue exist. Kindly set atleast one queue with permanent checkbox as true.');
            }
            
            
            // mark the related collection status record as referred
            collect__Contract_Status__c objCS = new collect__Contract_Status__c();
            objCS.ScCollection_IsRefered__c = true;
            objCS.ScCollection_Supervisor_Name__c = lstUser[0].Manager.Name;
            if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'collect__Loan_Account__c')
            {
                List<collect__loan_Account__c> lstContract = [Select Id, 
                                                               Name, 
                                                               collect__Source_System__r.Name, 
                                                               collect__Collection_Status__c, 
                                                               collect__Collection_Status__r.ScCollection_IsRefered__c 
                                                               from collect__Loan_Account__c 
                                                               where Id = : contractId];
                               
                SourceSystem = string.valueOf(lstContract[0].collect__Source_System__r.Name);
                objCS.id = lstContract[0].collect__Collection_Status__c;
            }
            else if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'loan__Loan_Account__c')
            {
                SourceSystem = 'CL Loan';
                List<loan__Loan_Account__c> lstPLContact = [Select Id, ScCollection_Collection_Status__c 
                                                                from loan__Loan_Account__c 
                                                                where id =: contractId];
                objCS.id = lstPLContact[0].ScCollection_Collection_Status__c;
            }
            lstCS.add(objCS);
            
            try
            {
                collect.Result res = api.userAssignment(setConIds, currentUserMgr, queueId, 'Permanent', null, null);
                system.debug('@@@@result'+res);
                if(res.getPassedRecords() != null && res.getPassedRecords().size() > 0)
                {
                    try
                    {
                        If(lstCS != null && lstCS.size() > 0)
                        {
                            update lstCS;
                        }
                        else
                        {
                            return('There is no status record defined against contract.');
                        }
                    }
                    catch(Exception e)
                    {
                        return e.getMessage();
                    }
                    
                    set<Id> setUserIds = new set<Id>();
                    setUserIds.add(UserInfo.getUserId());
                    ScCollection_CommonCodeHandler.updateUserReferCount(setUserIds);
                    
                    return('Contract is succesfully assigned to your supervisor.');
                }
                else
                {
                    return('Something went wrong during this process. Please contact your Administrator for further processing.');
                }
            }
            catch(Exception e)
            {
                system.debug('Refer to supervisor process has failed due to this error : '+e.getMessage()+' '+e.getCause()+' '+e.getLineNumber()+' '+e.getTypeName()+' '+e.getStackTraceString()+' '+e.getLineNumber());
                return('Something went wrong during this process. Please contact your administrator: '+e.getMessage()+' '+e.getCause()+' '+e.getLineNumber()+' '+e.getTypeName()+' '+e.getStackTraceString()+' '+e.getLineNumber());
            }
                      
        }
        else
        {
            return('Please select atleast one contract for assignment.');           
        }
    }
}
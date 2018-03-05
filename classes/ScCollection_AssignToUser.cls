//  -------------------------------------------------------------------------------------------------------
//  This class is used for assigning a user on the contract within the same queue by another working agent
//  -------------------------------------------------------------------------------------------------------
//  Created Date: 20-July-2016              Created By: Deepak Dhingra              Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestAssignToUser
//  -------------------------------------------------------------------------------------------------------
public with sharing class ScCollection_AssignToUser 
{
    public String QueueID {Get; Set;}
    public String contractID {Get; Set;}
    public String UserId {get; set;}
    //public String SourceSystem {get; set;}  
    public list<collect__Queue_User__c> lstQueueUsers;
    public map<id, List<collect__Queue_User__c>> mapUserToListOfQueue {get; set;}
    public list<collect__Contract_Status__c> lstConStatus {get; set;}
    public boolean showAssignment{get;set;}
    public String strTabId {get;set;}
    public String strRefresh {get;set;}
    public collect__Loan_Account__c objCon {get; set;}
    Id conId;
    
    // method to get the Map of the queue and the User
    public void createMapQueueToUserlist()
    {
        showAssignment= true;
        objCon = new collect__Loan_Account__c();
        lstConStatus = new list<collect__Contract_Status__c>();
        mapUserToListOfQueue = new map<Id, List<collect__Queue_User__c>>();
        
        list<collect__Queue_Contract__c> lstQueueContract = new list<collect__Queue_Contract__c>();
        contractID = ApexPages.currentPage().getParameters().get('Id');
        
        if(ScCollection_UtilityHandler.isNotNull(contractID))
        {
            //get the parent tab id for console refresh functionality
            if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('tabid')))
            {
                strTabId = ApexPages.currentPage().getParameters().get('tabid');
            }
            
            if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('refresh')))
            {
                strRefresh = ApexPages.currentPage().getParameters().get('refresh');
            }
           
            conId = contractID;

            lstQueueUsers = [Select Id, collect__Queue__c, collect__Queue__r.Name, collect__User__c, collect__User__r.Name, 
                                collect__User__r.ScCollection_UserType__c
                                from collect__Queue_User__c
                                where collect__Assignable__c = true AND collect__Queue__r.collect__Enabled__c = true
                                order by Name];
            
            if(ScCollection_UtilityHandler.isNotNull(lstQueueUsers))
            {
                for(collect__Queue_User__c eachQueueUser : lstQueueUsers)
                {
                    if(mapUserToListOfQueue.get(eachQueueUser.collect__User__c) == null)
                    {
                        mapUserToListOfQueue.put(eachQueueUser.collect__User__c, new List<collect__Queue_User__c>());
                    }
                    mapUserToListOfQueue.get(eachQueueUser.collect__User__c).add(eachQueueUser);
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There is no active queue or no active user is available. Kindly setup atleast one active queue and assign member to it.'));
            }
        }   
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please select contract which you want to assign to the user.'));   
        }
    }
    
    public list<SelectOption> getUsers()
    {
        list<SelectOption> options = new list<SelectOption>();
        
        options.add(new SelectOption('', '-- Select User -- '));
        
        if(!lstQueueUsers.isEmpty())
        {
            set<Id> setUniqueUsers = new set<Id>();
            for(collect__Queue_User__c objQueueUser : lstQueueUsers)
            {
                if(!setUniqueUsers.contains(objQueueUser.collect__User__c)){
                    String userType = '';
                    if(objQueueUser.collect__User__r.ScCollection_UserType__c != null && objQueueUser.collect__User__r.ScCollection_UserType__c != '')
                    {
                        userType = ' - ' + objQueueUser.collect__User__r.ScCollection_UserType__c;
                    }
                    options.add(new SelectOption(objQueueUser.collect__User__c, objQueueUser.collect__User__r.Name + userType));
                }
                setUniqueUsers.add(objQueueUser.collect__User__c);
            }
        }
        return options;
    }
    
    public list<SelectOption> getQueue()
    {
        If(UserId != '' && UserId != null){
            if(mapUserToListOfQueue != null && mapUserToListOfQueue.get(UserId) != null && mapUserToListOfQueue.get(UserId).size() > 0){
                list<SelectOption> options = new list<SelectOption>();
                options.add(new SelectOption('', '-- Select Queue-- '));
                set<Id> setQueueIds = new set<Id>();
                for(collect__Queue_User__c eachQU : mapUserToListOfQueue.get(UserId)){
                    if(!setQueueIds.contains(eachQU.collect__Queue__c))
                    {   
                        options.add(new SelectOption(eachQU.collect__Queue__c, eachQU.collect__Queue__r.Name));
                    }
                    setQueueIds.add(eachQU.collect__Queue__c);
                }
                return options;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Some issue occured in this process. Please try one more time.'));
                return null;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please select atleast one user to showcase related queues.'));
            return null;
        }
    }
    
    

    // Assignment action for the User which is Selected from the user
    public PageReference UserAssignment()
    {
        // initialization of the Manager Users
        list<collect__Loan_Account__c> lstContract = new list<collect__Loan_Account__c>();
        list<loan__loan_Account__c> lstPLContract = new list<loan__Loan_Account__c>();
        
        if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'collect__Loan_Account__c')
        {
            lstContract = [Select Id, 
                                  Name, 
                                  collect__Source_System__r.Name, 
                                  collect__Collection_Status__c, 
                                  collect__Collection_Status__r.ScCollection_IsRefered__c,
                                    (Select Id from Queue_Contracts__r where collect__Status__c ='Open')
                                  from collect__Loan_Account__c where ID = : contractID ];
                                  
           //SourceSystem = string.valueOf(lstContract[0].collect__Source_System__r.Name);                     
        }
        else if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'loan__Loan_Account__c')
        {
            lstPLContract = [Select Id, 
                                    ScCollection_Collection_Status__c, 
                                    ScCollection_Collection_Status__r.ScCollection_IsRefered__c ,
                                    (Select Id from Queue_Contracts__r where collect__Status__c ='Open')
                                    from loan__Loan_Account__c 
                                    where ID =: contractID];
                                    
            //SourceSystem = 'CL Loan';
        }
        if(lstContract != null && lstContract.Size()>0){
            if(lstContract[0].Queue_Contracts__r == null ||(lstContract[0].Queue_Contracts__r != null && lstContract[0].Queue_Contracts__r.Size()==0)){
                System.debug('This is not a part of contract cycle');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Sorry!! You can\'t perform this operation because it is available only for contracts which are in collection process.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        else if(lstPLContract != null && lstPLContract.Size()>0){
            if(lstPLContract[0].Queue_Contracts__r == null ||(lstPLContract[0].Queue_Contracts__r != null && lstPLContract[0].Queue_Contracts__r.Size()==0)){
                System.debug('This is not a part of contract cycle');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Sorry!! You can\'t perform this operation because it is available only for contracts which are in collection process.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        if(UserId != '' && UserId != null && QueueID != null && QueueID != '')
        {
            //add select contract id in set for api parameters
            set<Id> setConId = new set<Id>();
            setConId.add(contractID);
            
            // Creation of list to insert new Contract setting for the User
            list<User> LstU = new list<User>();
            lstU = [select Id, Name, ScCollection_UserType__c from User Where ID =: UserID];
            
            if(lstU != null && lstU.Size() > 0 && lstU[0].ScCollection_UserType__c == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Sorry, you can\'t perform this operation because selected user doesn\'t have user type value on its detail record. Kindly contact admin to update the this user record with appropriate value in user type field.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            if(lstContract != null && lstContract.size() > 0)
            {
                if(lstU[0].ScCollection_UserType__c == 'CO')
                {
                    collect__Contract_Status__c objCS = new collect__Contract_Status__c();
                    objCS.ID = lstContract[0].collect__Collection_Status__c;
                    objCS.ScCollection_IsRefered__c = false;
                    lstConStatus.add(objCS);
                }
            }
            else if(lstPLContract != null && lstPLContract.size() > 0)
            {
                if(lstU[0].ScCollection_UserType__c == 'CO')
                {
                    collect__Contract_Status__c objCS = new collect__Contract_Status__c();
                    objCS.ID = lstPLContract[0].ScCollection_Collection_Status__c;
                    objCS.ScCollection_IsRefered__c = false;
                    lstConStatus.add(objCS);
                }
            }
            
            // Inserting record of contract setting..
            ScCollection_ContractSettings__c objCons = new ScCollection_ContractSettings__c();
            objCons = ScCollection_CommonCodeHandler.retriveContractSettingsData(contractId, UserID);
            
            // perform the assignment
            //initialise cls collect api to be used in class
            collect.API4 api = collect.APIFactory.getAPI4();
            
            try
            {
                //collect.Result res = API.queueContractReassignment(mapQUtoUser, SourceSystem, true);
                Date startDt = system.today();
                Date endDt = objCon.ScCollection_Movement_Date__c;
                
                collect.Result res = api.userAssignment(setConId, UserId, QueueID, 'Temporary', startDt, endDt);
                system.debug('@@@@result'+res);
                
                if(res.getPassedRecords() != null && res.getPassedRecords().size() > 0)
                {
                    if(lstConStatus != null && lstConStatus.size() > 0)
                    {
                        update lstConStatus;
                    }
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Contract has succesfully assigned to the selected user.');
                    ApexPages.addMessage(myMsg);
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Something went wrong in assignment process.');
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                
            }
            catch(Exception e)
            {
                system.debug(e.getMessage()+' '+e.getCause()+' '+e.getLineNumber()+' '+e.getTypeName()+' '+e.getStackTraceString()+' '+e.getLineNumber());
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reassignment on the contract for the supervisor has failed due to this error : '+e.getMessage()+' '+e.getCause()+' '+e.getLineNumber()+' '+e.getTypeName()+' '+e.getStackTraceString()+' '+e.getLineNumber());
                ApexPages.addMessage(myMsg);
                return null;
            }
            
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select a Queue/User from the list which you want to assign to the contract');
            ApexPages.addMessage(MyMsg);
            return null;
        }
        
        PageReference pr = new PageReference('/apex/ScCollection_AssignToUser?Id=' + contractID + '&tabid=' + strTabId + '&refresh=0');
        pr.setRedirect(true);
        return pr;
    }

    public void enableUserSelection()
    {
        
    }
}
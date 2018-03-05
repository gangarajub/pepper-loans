// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ContractListHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestContractListHandler 
{  
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static loan__Loan_Account__c objplcontract;
    
    static testMethod void myUnitTest() 
    {  
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
                
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        //Insert object of collect__Queue__c
        collect__Queue__c objQue =  ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
        
        //Insert object of collect__Queue__c
        collect__Queue__c objQue1 =  ScCollection_CommonTrackerClass.createTestQueue('0-30 DPD');
         
        //Insert Queue User
        collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQue.Id, UserInfo.getUserId());
        
        //Insert Queue User
        collect__Queue_User__c objUser1 = ScCollection_CommonTrackerClass.createTestQueueUser(objQue1.Id, UserInfo.getUserId());
         
        //Insert Account
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        objAccount.PersonMailingStreet = 'dfb';
        objAccount.PersonMailingCity = 'sv';
        objAccount.PersonMailingState = 'sfb';
        objAccount.PersonMailingPostalCode = 'sfv';
        update objAccount;
          
        Blob b = Blob.valueOf('Test Data');  
        Attachment attachment = new Attachment();  
        attachment.ParentId = objAccount.id;  
        attachment.Name = 'Profile Pic';  
        attachment.Body = b;  
        insert(attachment);  
        
        // insert collection status
        collect__Contract_Status__c objstatus = new collect__Contract_Status__c();
        objstatus.ScCollection_Account__c = objAccount.Id;
        objstatus.ScCollection_Arrears__c = 'New Work';
        insert objstatus;
        
        objContract.collect__Collection_Status__c = objstatus.Id;
        objContract.collect__Amount_to_Current__c = 100;
        objContract.ScCollection_Current_Principal__c = 100;
        objContract.ScCollection_Next_Installment_Date__c = System.Today().addDays(10);
        objContract.ScCollection_Bucket__c = 0;
        update objContract;
        
        //Insert Collection Activity
        collect__Collection_Activity__c objCollectionActivity = new collect__Collection_Activity__c();
        objCollectionActivity.collect__Activity_Date__c = System.Now().addDays(-1);
        objCollectionActivity.collect__Action__c = 'Follow Up' ;
        objCollectionActivity.collect__Completed__c = false ;
        objCollectionActivity.collect__Account__c = objAccount.id;
        objCollectionActivity.collect__Dev_Contract__c = objContract.id ;
        insert objCollectionActivity;
         
        // Insert Interaction Log
        collect__Interaction_Log__c objInteractionLog = new collect__Interaction_Log__c();
        objInteractionLog.collect__Collection_Activity__c = objCollectionActivity.id;
        objInteractionLog.collect__Loan_Account_Id__c = objContract.id ;
        objInteractionLog.collect__Dev_Contract__c = objContract.id ;
        objInteractionLog.collect__Follow_Up_Date_Time__c = System.Now().addDays(-1);
        objInteractionLog.collect__Collector__c = UserInfo.getUserId();
        insert objInteractionLog;
         
        //Insert Object of collect__Queue_Contract__c with Contract
        collect__Queue_Contract__c objQueueContract = new collect__Queue_Contract__c();
        objQueueContract.Name = 'QC1';
        objQueueContract.collect__Queue__c = objQue.id;
        objQueueContract.collect__Loan_Account_Id__c = objContract.id ;
        objQueueContract.collect__Status__c ='Open';
        objQueueContract.collect__User__c = UserInfo.getUserId();
        objQueueContract.collect__Follow_Up_Date__c = System.Today();
        insert objQueueContract;
        
        ScCollection_ContractListHandler obj = new ScCollection_ContractListHandler();
        obj.getQueueName();
        obj.getUserName();
        obj.strActivityIndex = System.Now().addDays(-1).format('dd/MM/yyyy') + '-0';
        obj.CompleteActivity();
        
        ScCollection_ContractListHandler.getSearchResults('ContractNo',objContract.Name,'','');
        
        //Insert Object of collect__Queue_Contract__c with Contract
        collect__Queue_Contract__c objQueueContract1 = new collect__Queue_Contract__c();
        objQueueContract1.Name = 'QC2';
        objQueueContract1.collect__Queue__c = objQue1.id;
        objQueueContract1.collect__Loan_Account_Id__c = objContract.id ;
        objQueueContract1.collect__Status__c ='Open';
        objQueueContract1.collect__User__c = UserInfo.getUserId();
        objQueueContract1.collect__Follow_Up_Date__c = System.Today();
        insert objQueueContract1;
        
        ScCollection_ContractListHandler.getSearchResults('ContractNo',objContract.Name,'','');
        ScCollection_ContractListHandler.getSearchResults('CustomerName','Test Accnt','','');
        ScCollection_ContractListHandler.getSearchResults('CustomerState','Test','','');
        ScCollection_ContractListHandler.getSearchResults('DueDate','10/10/2016','','');
        ScCollection_ContractListHandler.getSearchResults('ArrearAmount','','1','100');
        ScCollection_ContractListHandler.getSearchResults('BalanceAmount','','1','100');
        ScCollection_ContractListHandler.getSearchResults('Bucket','0','','');
        ScCollection_ContractListHandler.getSearchResults('ContractStatus','Test','','');
        ScCollection_ContractListHandler.getSearchResults('AssignedDate','10/10/2016','','');
        ScCollection_ContractListHandler.getSearchResults('ReviewDate','10/10/2016','','');
        ScCollection_ContractListHandler.getSearchResults('Assignee',UserInfo.getUserId(),'','');
        
        ScCollection_ContractListHandler.getListOfContracts('All');
        ScCollection_ContractListHandler.getListOfContracts('Today');
        ScCollection_ContractListHandler.getListOfContracts(objQue.Id);
    }
    
    static testMethod void myUnitTest1() 
    {  
        //insert pl contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
        
        String strContractId = [select Name from loan__Loan_Account__c where Id =: objplcontract.Id].Name;
        
        //Insert object of collect__Queue__c
        collect__Queue__c objQue =  ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
        
        //Insert object of collect__Queue__c
        collect__Queue__c objQue1 =  ScCollection_CommonTrackerClass.createTestQueue('0-30 DPD');
         
        //Insert Queue User
        collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQue.Id, UserInfo.getUserId());
        
        //Insert Queue User
        collect__Queue_User__c objUser1 = ScCollection_CommonTrackerClass.createTestQueueUser(objQue1.Id, UserInfo.getUserId());
         
        //Insert Account
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        objAccount.PersonMailingStreet = 'dfb';
        objAccount.PersonMailingCity = 'sv';
        objAccount.PersonMailingState = 'sfb';
        objAccount.PersonMailingPostalCode = 'sfv';
        update objAccount;
          
        Blob b = Blob.valueOf('Test Data');  
        Attachment attachment = new Attachment();  
        attachment.ParentId = objAccount.id;  
        attachment.Name = 'Profile Pic';  
        attachment.Body = b;  
        insert(attachment);  
        
        // insert collection status
        collect__Contract_Status__c objstatus = new collect__Contract_Status__c();
        objstatus.ScCollection_Account__c = objAccount.Id;
        objstatus.ScCollection_Arrears__c = 'New Work';
        insert objstatus;
        
        objplcontract.ScCollection_Collection_Status__c = objstatus.Id;
        objplcontract.loan__Loan_Balance__c = 100;
        objplcontract.loan__Next_Installment_Date__c = System.Today().addDays(10);
        update objplcontract;
        
        //Insert Collection Activity
        collect__Collection_Activity__c objCollectionActivity = new collect__Collection_Activity__c();
        objCollectionActivity.collect__Activity_Date__c = System.Now().addDays(-1);
        objCollectionActivity.collect__Action__c = 'Follow Up' ;
        objCollectionActivity.collect__Completed__c = false ;
        objCollectionActivity.collect__Account__c = objAccount.id;
        insert objCollectionActivity;
         
        collect__Interaction_Log__c objInteractionLog = new collect__Interaction_Log__c();
        objInteractionLog.collect__Collection_Activity__c = objCollectionActivity.id;
        objInteractionLog.collect__Loan_Account_Id__c = objplcontract.id ;
        objInteractionLog.ScCollection_CL_Contract__c = objplcontract.id ;
        objInteractionLog.collect__Follow_Up_Date_Time__c = System.Now().addDays(-1);
        objInteractionLog.collect__Collector__c = UserInfo.getUserId();
        insert objInteractionLog;
        
        //Insert Object of collect__Queue_Contract__c with Contract
        collect__Queue_Contract__c objQueueContract = new collect__Queue_Contract__c();
        objQueueContract.Name = 'QC1';
        objQueueContract.collect__Queue__c = objQue.id;
        objQueueContract.collect__Loan_Account_Id__c = objplcontract.id ;
        objQueueContract.collect__Status__c ='Open';
        objQueueContract.collect__User__c = UserInfo.getUserId();
        objQueueContract.collect__Follow_Up_Date__c = System.Today();
        insert objQueueContract;
          
        ScCollection_ContractListHandler obj = new ScCollection_ContractListHandler();
        ScCollection_ContractListHandler.getSearchResults('ContractNo',strContractId,'','');
        
        //Insert Object of collect__Queue_Contract__c with Contract
        collect__Queue_Contract__c objQueueContract1 = new collect__Queue_Contract__c();
        objQueueContract1.Name = 'QC2';
        objQueueContract1.collect__Queue__c = objQue1.id;
        objQueueContract1.collect__Loan_Account_Id__c = objplcontract.id ;
        objQueueContract1.collect__Status__c ='Open';
        objQueueContract1.collect__User__c = UserInfo.getUserId();
        objQueueContract1.collect__Follow_Up_Date__c = System.Today();
        insert objQueueContract1;
        
        ScCollection_ContractListHandler.getSearchResults('ContractNo',strContractId,'','');
    }
}
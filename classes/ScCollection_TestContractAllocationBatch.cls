// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ContractAllocationBatch class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData=false)
public class ScCollection_TestContractAllocationBatch
{
    public static collect__Source_System__c objsourcesystem;
    public static collect__Queue__c objQueue;
    public static collect__Queue_User__c objQueueUser;
    public static collect__Loan_Account__c objcontract;
    public static loan__Loan_Account__c objplcontract;
    public static collect__Queue_Contract__c objqueuecontract;
    public static collect__Interaction_Log__c objlog;
    
    static testMethod void myUnitTest() 
    {
        objsourcesystem = new collect__Source_System__c();
        objsourcesystem.Name = 'Mortgage';
        insert objsourcesystem;
        
        objQueue = new collect__Queue__c();
        objQueue.Name = 'Test Queue';
        insert objQueue;
        
        objQueueUser = new collect__Queue_User__c();
        objQueueUser.Name = 'Test User';
        objQueueUser.collect__Queue__c = objQueue.Id;
        objQueueUser.collect__User__c = UserInfo.getUserId();
        insert objQueueUser;
        
        objcontract = new collect__Loan_Account__c();
        objcontract.Name = 'Contract-001';
        objcontract.collect__Source_System__c = objsourcesystem.Id;
        objcontract.collect__Delinquent_Amount__c = 8000;
        insert objcontract;
        
        objqueuecontract = new collect__Queue_Contract__c();
        objqueuecontract.Name = 'sampleQueConttTest';
        objqueuecontract.collect__Queue__c = objQueue.Id;
        objqueuecontract.collect__Loan_Account_Id__c = objcontract.Id;
        objqueuecontract.collect__Status__c = 'Open';
        objqueuecontract.collect__User__c = UserInfo.getUserId();
        insert objqueuecontract;
        
        objlog = new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.id;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        insert objlog;
        
        ScCollection_ContractAllocationBatch objBatch = new ScCollection_ContractAllocationBatch();
        Database.executeBatch(objBatch);
    }
    
    static testMethod void myUnitTest1() 
    {
        objQueue = new collect__Queue__c();
        objQueue.Name = 'Test Queue';
        insert objQueue;
        
        objQueueUser = new collect__Queue_User__c();
        objQueueUser.Name = 'Test User';
        objQueueUser.collect__Queue__c = objQueue.Id;
        objQueueUser.collect__User__c = UserInfo.getUserId();
        insert objQueueUser;
        
        objplcontract = pepCommonTrackerController.createLoanAccount();
        
        objqueuecontract = new collect__Queue_Contract__c();
        objqueuecontract.Name = 'sampleQueConttTest';
        objqueuecontract.collect__Queue__c = objQueue.Id;
        objqueuecontract.collect__Loan_Account_Id__c = objplcontract.Id;
        objqueuecontract.collect__Status__c = 'Open';
        objqueuecontract.collect__User__c = UserInfo.getUserId();
        insert objqueuecontract;
        
        objlog = new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objplcontract.id;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        insert objlog;
        
        ScCollection_ContractAllocationBatch objBatch = new ScCollection_ContractAllocationBatch();
        Database.executeBatch(objBatch);
    }
}
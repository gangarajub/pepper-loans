// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_QueueContractHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData=false)
public class ScCollection_TestQueueContractTrigger 
{
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    
    static testMethod void myUnitTest()
    {   
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        //Insert object of collect__Queue__c
        collect__Queue__c objQueue =  ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
                
        collect__Queue_Contract__c  objQueueContract = new collect__Queue_Contract__c ();
        objQueueContract.collect__Queue__c = objQueue.id;
        objQueueContract.Name = 'Test';
        objQueueContract.collect__Loan_Account_Id__c = objContract.Id;
        insert objQueueContract;
        
        String statusId = [select collect__Collection_Status__c from collect__Loan_Account__c where Id =: objContract.Id].collect__Collection_Status__c;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u = new User(FirstName = 'Shobhit',Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Gupta', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusettr@testorg.com'); 
        
        insert u;
        
        collect__Contract_Status__c objContractStatus = new collect__Contract_Status__c();
        objContractStatus.ScCollection_IsRefered__c = true;
        insert objContractStatus;
        
        objContract.collect__Collection_Status__c = objContractStatus.id;
        update objContract;
        objQueueContract.collect__User__c = u.id;
        update objQueueContract;       
    }
}
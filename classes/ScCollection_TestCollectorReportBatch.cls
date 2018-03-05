// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CollectorReportBatch class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData=false)
public class ScCollection_TestCollectorReportBatch
{
    static testMethod void myUnitTest() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System administrator']; 
        User u = new User(FirstName = 'Shobhit',Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Gupta', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusettr@testorg.com'); 
        
        insert u;
        
        User u1 = new User(FirstName = 'Shobhit1',Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Gupta1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusettr1@testorg.com'); 
        
        insert u1;
        
        collect__Contract_Status__c objContractStatus = new collect__Contract_Status__c();
        objContractStatus.ScCollection_Follow_Up_Date_Time__c = system.now()-2;
        insert objContractStatus;
        
        loan__Loan_Account__c objLoanAcc = pepcommontrackerController.createLoanAccount();
        objLoanAcc.ScCollection_Collection_Status__c = objContractStatus.id;
        update objLoanAcc;
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.collect__Collection_Status__c = objContractStatus.id;
        update objContract;
        
        collect__Loan_Account__c objContract1 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract1.collect__Collection_Status__c = objContractStatus.id;
        update objContract1;
        
        //Insert object of collect__Queue__c
        collect__Queue__c objQueue =  ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
                
        collect__Queue_Contract__c  objQueueContract = new collect__Queue_Contract__c ();
        objQueueContract.collect__Queue__c = objQueue.id;
        objQueueContract.Name = 'Test';
        objQueueContract.collect__Loan_Account_Id__c = objContract.Id;
        objQueueContract.collect__Status__c = 'Open';
        objQueueContract.collect__User__c = u.id;
        objQueueContract.ScCollection_Dev_Contract__c = objContract.id;
        insert objQueueContract;
        
        collect__Queue_Contract__c  objQueueContract1 = new collect__Queue_Contract__c ();
        objQueueContract1.collect__Queue__c = objQueue.id;
        objQueueContract1.Name = 'Test';
        objQueueContract1.collect__Loan_Account_Id__c = objContract1.Id;
        objQueueContract1.collect__Status__c = 'Open';
        objQueueContract1.collect__User__c = u1.id;
        objQueueContract1.ScCollection_Dev_Contract__c = objContract1.id;
        
        insert objQueueContract1;
        
        collect__Queue_Contract__c  objQueueContract2 = new collect__Queue_Contract__c ();
        objQueueContract2.collect__Queue__c = objQueue.id;
        objQueueContract2.Name = 'Test';
        objQueueContract2.collect__Loan_Account_Id__c = objContract1.Id;
        objQueueContract2.collect__Status__c = 'Open';
        objQueueContract2.collect__User__c = u.id;
        objQueueContract2.ScCollection_Dev_Contract__c = objContract1.id;
        insert objQueueContract2;
        
        collect__Queue_Contract__c  objQueueContract3 = new collect__Queue_Contract__c ();
        objQueueContract3.collect__Queue__c = objQueue.id;
        objQueueContract3.Name = 'Test';
        objQueueContract3.collect__Loan_Account_Id__c = objLoanAcc.Id;
        objQueueContract3.collect__Status__c = 'Open';
        objQueueContract3.collect__User__c = u.id;
        objQueueContract3.ScCollection_CL_Contract__c= objLoanAcc.id;
        insert objQueueContract3;
                
        ScCollection_User_Assignment__c objAssignment = new ScCollection_User_Assignment__c();
        objAssignment.ScCollection_Review_Date__c = System.today();
        objAssignment.ScCollection_User__c = u1.id;
        insert objAssignment;
        
        ScCollection_System_Email_Settings__c objCust = new ScCollection_System_Email_Settings__c();
        objCust.name='Collector Report Batch';
        objCust.ScCollection_Email_Addressess__c = 'sandip.bijlwan@saasfocus.com,san@bij.com';
        insert objCust;
        
        ScCollection_System_Email_Settings__c objCust1 = new ScCollection_System_Email_Settings__c();
        objCust1.name='Collector Report Batch';
        objCust.ScCollection_Email_Addressess__c = '';
        
        Test.StartTest();
            ScCollection_ScheduleCollReportBatch obj = new ScCollection_ScheduleCollReportBatch();      
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, obj);
        Test.stopTest();  
    }
}
// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_RollRateReportBatch class
// ----------------------------------------------------------------------------------------------------
// Created Date: 09-JAN-2017    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData=false)
public class ScCollection_TestRollRateReportBatch
{
    static testMethod void myUnitTest() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System administrator']; 
        User u = new User(FirstName = 'Shobhit',Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Gupta', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusettr1@testorg.com'); 
        
        insert u;
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.ScCollection_Bucket__c = 1;
        objContract.ScCollection_Current_Principal__c = 100;
        update objContract;
        
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
        
        ScCollection_Roll_Rate_Batch_Settings__c objCust = new ScCollection_Roll_Rate_Batch_Settings__c();
        objCust.name='Roll Rate Start Day';
        objCust.ScCollection_Initial_Start_Date__c = System.Today().day();
        insert objCust;
        
        Test.StartTest();
            ScCollection_ScheduleRollRateReportBatch obj = new ScCollection_ScheduleRollRateReportBatch();      
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, obj);
        Test.stopTest();  
    }
    
    static testMethod void myUnitTest1() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System administrator']; 
        User u = new User(FirstName = 'Shobhit',Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Gupta', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusettr1@testorg.com'); 
        
        insert u;
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.ScCollection_Bucket__c = 2;
        objContract.ScCollection_Current_Principal__c = 100;
        update objContract;
        
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
        
        ScCollection_Roll_Rate_Batch_Settings__c objCust = new ScCollection_Roll_Rate_Batch_Settings__c();
        objCust.name='Roll Rate Start Day';
        objCust.ScCollection_Initial_Start_Date__c = System.Today().day();
        insert objCust;
        
        Test.StartTest();
            ScCollection_ScheduleRollRateReportBatch obj = new ScCollection_ScheduleRollRateReportBatch();      
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, obj);
        Test.stopTest();  
    }
    
    static testMethod void myUnitTest2() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System administrator']; 
        User u = new User(FirstName = 'Shobhit',Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Gupta', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusettr1@testorg.com'); 
        
        insert u;
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.ScCollection_Bucket__c = 1;
        objContract.ScCollection_Current_Principal__c = 100;
        update objContract;
        
        collect__Loan_Account__c objContract1 = new collect__Loan_Account__c();
        objContract1.ScCollection_Bucket__c = 2;
        objContract1.ScCollection_Current_Principal__c = 100;
        insert objContract1;
        
        collect__Loan_Account__c objContract2 = new collect__Loan_Account__c();
        objContract2.ScCollection_Bucket__c = 1;
        objContract2.ScCollection_Current_Principal__c = 100;
        insert objContract2;
        
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
        
        ScCollection_Roll_Rate_Batch_Settings__c objCust = new ScCollection_Roll_Rate_Batch_Settings__c();
        objCust.name='Roll Rate Start Day';
        objCust.ScCollection_Initial_Start_Date__c = System.Today().day() - 1;
        insert objCust;
        
        ScCollection_Bucket_Movement_Data__c objdata = new ScCollection_Bucket_Movement_Data__c();
        objdata.ScCollection_Collector__c = u.id;
        objdata.ScCollection_Movement_Date__c = System.Today().addDays(-1);
        objdata.ScCollection_Bucket_1_Count__c = 1;
        objdata.ScCollection_30_Count__c = 1;
        objdata.ScCollection_Bucket_1_Contract_Ids__c = objContract1.Id;
        objdata.ScCollection_30_Contract_Ids__c = objContract2.Id;
        objdata.ScCollection_No_Movement_Balance__c = 0.00;
        objdata.ScCollection_No_Movement_Count__c = 0;
        objdata.ScCollection_Rolled_Down_Balance__c = 0.00;
        objdata.ScCollection_Rolled_Down_Count__c = 0;
        objdata.ScCollection_Rolled_Up_Balance__c = 0.00;
        objdata.ScCollection_Rolled_Up_Count__c = 0;
        objdata.ScCollection_Total_Balance__c = 100;
        
        Test.StartTest();
            ScCollection_ScheduleRollRateReportBatch obj = new ScCollection_ScheduleRollRateReportBatch();      
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, obj);
        Test.stopTest();  
    }
    
    static testMethod void myUnitTest3() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System administrator']; 
        User u = new User(FirstName = 'Shobhit',Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Gupta', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusettr1@testorg.com'); 
        
        insert u;
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.ScCollection_Bucket__c = 2;
        objContract.ScCollection_Current_Principal__c = 100;
        update objContract;
        
        collect__Loan_Account__c objContract1 = new collect__Loan_Account__c();
        objContract1.ScCollection_Bucket__c = 2;
        objContract1.ScCollection_Current_Principal__c = 100;
        insert objContract1;
        
        collect__Loan_Account__c objContract2 = new collect__Loan_Account__c();
        objContract2.ScCollection_Bucket__c = 1;
        objContract2.ScCollection_Current_Principal__c = 100;
        insert objContract2;
        
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
        
        ScCollection_Roll_Rate_Batch_Settings__c objCust = new ScCollection_Roll_Rate_Batch_Settings__c();
        objCust.name='Roll Rate Start Day';
        objCust.ScCollection_Initial_Start_Date__c = System.Today().day() - 1;
        insert objCust;
        
        ScCollection_Bucket_Movement_Data__c objdata = new ScCollection_Bucket_Movement_Data__c();
        objdata.ScCollection_Collector__c = u.id;
        objdata.ScCollection_Movement_Date__c = System.Today().addDays(-1);
        objdata.ScCollection_Bucket_1_Count__c = 1;
        objdata.ScCollection_30_Count__c = 1;
        objdata.ScCollection_Bucket_1_Contract_Ids__c = objContract1.Id;
        objdata.ScCollection_30_Contract_Ids__c = objContract2.Id;
        objdata.ScCollection_No_Movement_Balance__c = 0.00;
        objdata.ScCollection_No_Movement_Count__c = 0;
        objdata.ScCollection_Rolled_Down_Balance__c = 0.00;
        objdata.ScCollection_Rolled_Down_Count__c = 0;
        objdata.ScCollection_Rolled_Up_Balance__c = 0.00;
        objdata.ScCollection_Rolled_Up_Count__c = 0;
        objdata.ScCollection_Total_Balance__c = 100;
        
        insert objdata;
        
        Test.StartTest();
            ScCollection_ScheduleRollRateReportBatch obj = new ScCollection_ScheduleRollRateReportBatch();      
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, obj);
        Test.stopTest();  
    }
}
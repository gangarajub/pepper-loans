// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_BatchDailyContractSummary and ScCollection_ScheduleDailySummary class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(SeeAllData=false) 
public class ScCollection_testScheduleDailySummary
{
    @isTest static void UnitTest()
    {      
        /*ScCollection_BatchDailyContractSummary obj12 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 12, 1));
        database.executebatch(obj12);*/
        
        Test.StartTest();
        ScCollection_ScheduleDailySummary obj = new ScCollection_ScheduleDailySummary();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, obj);
        Test.stopTest();
        
        /*
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('CL Loan');
        
        ScCollection_Bucket_Configuration__c objBucketCustomSetting = ScCollection_CommonTrackerClass.createTestBucketConfig();
        
        ScCollection_Targer_Arrears_Index__c objTargetCustomSetting = ScCollection_CommonTrackerClass.createTestTargetIndex();
        
        collect__Contract_Status__c objCollectionStatus = new collect__Contract_Status__c();
        objCollectionStatus.ScCollection_Arrears__c = 'New Work';
        insert objCollectionStatus ;
        
        collect__Loan_Account__c objContractupdate = new collect__Loan_Account__c();
        objContractupdate.Name = 'Contract-002';
        objContractupdate.ScCollection_Next_Installment_Date__c = date.today().addDays(5);
        objContractupdate.collect__Collection_Status__c = objCollectionStatus.id;
        objContractupdate.collect__Delinquent_Amount__c = 80;
        objContractupdate.ScCollection_Bucket__c = 1;
        objContractupdate.collect__Source_System__c = objSourceSystem.id;
        objContractupdate.ScCollection_Current_Principal__c = 2000;
        insert objContractupdate;
        
        ScCollection_Contract_Summary__c objContractSummary = new ScCollection_Contract_Summary__c();
        objcontractSummary.ScCollection_SourceName__c = 'CL Loan';
        objcontractSummary.ScCollection_Process_Date__c = System.Today()-1;
        insert objContractSummary;
        
        ScCollection_Contract_Summary__c objContractSummary1 = new ScCollection_Contract_Summary__c();
        objcontractSummary1.ScCollection_SourceName__c = 'CL Loan';
        objcontractSummary1.ScCollection_Process_Date__c = System.Today()-25;
        insert objContractSummary1;
        
        ScCollection_Bucket_Summary__c objBucketSummary = new ScCollection_Bucket_Summary__c();
        objBucketSummary.ScCollection_BucketName__c = 1;
        objBucketSummary.ScCollection_Contract_Summary__c = objcontractSummary.id;
        insert objBucketSummary;
        
        Test.StartTest();
        
        ScCollection_ScheduleDailySummary objSchedule = new ScCollection_ScheduleDailySummary();
        objSchedule.execute(null);
        
        ScCollection_BatchDailyContractSummary obj = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 1, 1));
        database.executebatch(obj);

        ScCollection_BatchDailyContractSummary obj2 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 2, 1));
        database.executebatch(obj2);
        
        ScCollection_BatchDailyContractSummary obj3 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 3, 1));
        database.executebatch(obj3);
        
        ScCollection_BatchDailyContractSummary obj4 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 4, 1));
        database.executebatch(obj4);
        
        ScCollection_BatchDailyContractSummary obj5 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 5, 1));
        database.executebatch(obj5);
        
        ScCollection_BatchDailyContractSummary obj6 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 6, 1));
        database.executebatch(obj6);
        
        ScCollection_BatchDailyContractSummary obj7 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 7, 1));
        database.executebatch(obj7);
        
        ScCollection_BatchDailyContractSummary obj9 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 9, 1));
        database.executebatch(obj9);
        
        ScCollection_BatchDailyContractSummary obj10 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 10, 1));
        database.executebatch(obj10);
        
        ScCollection_BatchDailyContractSummary obj11 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 11, 1));
        database.executebatch(obj11);
        
        ScCollection_BatchDailyContractSummary obj12 = new ScCollection_BatchDailyContractSummary(Date.newInstance(2015, 12, 1));
        database.executebatch(obj12);
        
        Test.StopTest();
        */
    }
}
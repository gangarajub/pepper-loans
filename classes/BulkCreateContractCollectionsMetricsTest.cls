// ----------------------------------------------------------------------------------------------------
// Test Class for BulkCreateContractCollectionsMetrics
// ----------------------------------------------------------------------------------------------------
// Created Date: 2017-12-18    Created By: Alex Humby
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class BulkCreateContractCollectionsMetricsTest {

    static testMethod void createContractMetrics(){
     
        //insert the Contract Record first so that the Metric Settings dont exist yet and the trigger cant create the them!
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Source_System__c objSourceSystemMortgage = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        List<collect__Loan_Account__c> lst = new List<collect__Loan_Account__c>();
        collect__Loan_Account__c  objcontract = new collect__Loan_Account__c();
        objcontract.Name = '1234';
        objcontract.collect__External_ID__c = 'PAF:123';
        objcontract.collect__Source_System__c = objSourceSystem.Id;
        objcontract.collect__Delinquent_Amount__c = 1;
        objcontract.ScCollection_Daily_Contact_Counter__c =1;
        objcontract.ScCollection_Counter_Processed_Date__c = System.today();
        lst.add(objcontract);
        collect__Loan_Account__c  objcontract1 = new collect__Loan_Account__c();
        objcontract1.Name = '12_0';
        objcontract1.collect__External_ID__c = 'MORTGAGE:12';
        objcontract1.collect__Source_System__c = objSourceSystemMortgage.Id;
        objcontract1.collect__Delinquent_Amount__c = 1;
        objcontract1.ScCollection_Daily_Contact_Counter__c =1;
        objcontract1.ScCollection_Counter_Processed_Date__c = System.today();
        lst.add(objcontract1);
        
        insert lst;
        
        //now insert the metric settings
        List<collect__Collections_Metrics_Settings__c> thresholds = new List<collect__Collections_Metrics_Settings__c>();
        collect__Collections_Metrics_Settings__c t1 = new collect__Collections_Metrics_Settings__c(
        	Name = 'Weekly',
            collect__Contact_Count_Threshold__c = 10,
            collect__Threshold_Days__c = 7            
        );
        thresholds.add(t1);
        collect__Collections_Metrics_Settings__c t2 = new collect__Collections_Metrics_Settings__c(
        	Name = 'Monthly',
            collect__Contact_Count_Threshold__c = 30,
            collect__Threshold_Days__c = 30            
        );
        thresholds.add(t2);
		insert thresholds;           
        
        Test.startTest();
		BulkCreateContractCollectionsMetrics batchJob = new BulkCreateContractCollectionsMetrics();
        Database.executeBatch(batchJob);
        
        Test.stopTest();
        
        Integer newMetrics = [select Id from collect__Contract_Collections_Metrics__c where collect__Dev_Contract__c in :lst].size();
        //Integer newMetrics = [select Id from collect__Contract_Collections_Metrics__c ].size();
        System.debug('newMetrics: ' + newMetrics);
        System.assertEquals(4, newMetrics);
        
    }
    
    
}
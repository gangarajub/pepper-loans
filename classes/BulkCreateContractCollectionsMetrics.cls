// -------------------------------------------------------------------------------------------------------- 
// This class provides a Batchable method to create Contract Collections Metrics records in bulk
// --------------------------------------------------------------------------------------------------------
// Created Date : 2017-12-18  Created By: Alex Humby
// Revisions:
//
// --------------------------------------------------------------------------------------------------------
// Test Class : BulkCreateContractCollectionsMetrics_Test
// --------------------------------------------------------------------------------------------------------

public class BulkCreateContractCollectionsMetrics  implements Database.Batchable<sObject>{

    
    public Database.QueryLocator start(Database.BatchableContext BC){

        String Query = 'select id, name from collect__Loan_Account__c where Id not in(select collect__Dev_Contract__c from collect__Contract_Collections_Metrics__c)';
         
        return Database.getQueryLocator(Query);
    }

    public void execute(Database.BatchableContext BC, List<sObject>scope){
        
        List<collect__Loan_Account__c> lstContractsWithoutMetrics = (List<collect__Loan_Account__c>)scope;
        
        ScCollection_CollectionContractHanler.createContractCollectionsMetrics(lstContractsWithoutMetrics);
    }
    
    public void finish(Database.BatchableContext BC){
            
    }    
}
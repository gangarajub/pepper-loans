/*------------------------------------------------------------
Author:         Vincent Vuong
Company:        SaaSfocus
Description:    Batch job to autogenerate 8-10 digits CIS existing accounts if not generated
                To run batch:

                SCV_CustomerNumberGeneration_Batch runBatch = new SCV_CustomerNumberGeneration_Batch();
                ID batchprocessid = Database.executeBatch(runBatch);
            
Test Class:     SCV_CustomerNumberGeneration_Batch_Test
History
<Date>      <Authors Name>      <Brief Description of Change>
01-Nov-17   Vincent Vuong       Created
------------------------------------------------------------*/
global without sharing class SCV_CustomerNumberGeneration_Batch implements Database.Batchable<SObject>, Database.Stateful {

    //Instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Integer recordsFailure = 0;
    global Integer recordsSuccess = 0;

    //Constructor
    global SCV_CustomerNumberGeneration_Batch () {
    }

    //The batch job starts
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String ignoreDummy = 'DUMMY';
        String query = 'SELECT Id, PersonBirthdate, Customer_Id__c, SCV_Person_Birthdate_Timestamp__c ' +
                    ' FROM Account ' + 
                    ' WHERE Name != :ignoreDummy' +
                    ' AND (Customer_Id__c = null OR (PersonBirthdate != null AND SCV_Person_Birthdate_Timestamp__c = null)) '
                    ;

        System.debug('@Start query: ' + query);
        return Database.getQueryLocator(query);
    }

    //The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        System.debug('@Execute ' + scope.size());

        try {
            // process each batch of records
            List<Account> accountsToUpdate = new List<Account>();
            Boolean needUpdate = false;
            for (Account acc : scope) {
            	
                if (acc.Customer_Id__c == null) {
                    acc.Customer_Id__c = SCV_Utility.generateCustomerNumber(acc.Id);
                    needUpdate = true;
                }
                if (acc.PersonBirthdate != null) {
                    acc.SCV_Person_Birthdate_Timestamp__c = String.valueOf(acc.PersonBirthdate);
                    needUpdate = true;
                }

                if (needUpdate) {
                    accountsToUpdate.add(acc);
                    // increment the instance member counter
                    recordsProcessed++;
                }
            }

            if (!accountsToUpdate.isEmpty()) {
                //update casesToUpdate;
                Database.SaveResult[] srList = Database.update(accountsToUpdate, false);

                // Iterate through each returned result
                for (Integer i = 0; i < srList.size(); i++) {
                    Database.SaveResult sr = srList[i];
                    if (!sr.isSuccess()) {
                        recordsFailure++;
                        
                        // Operation failed, so get all errors                
                        for (Database.Error err : sr.getErrors()) {
                            System.debug('Account ID = ' + accountsToUpdate[i].Id + ' - Error: ' + err.getMessage() + ' - Error fields:' + err.getFields());
                        }
                    }
                    else {
                        recordsSuccess++;
                    }

                }
            }
        }
        catch(Exception ex) {
        }

        System.debug('Execute - END');
    }

    //The batch job finishes
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('@Finish ' + job.Status);

        System.debug('Total Processed = ' + recordsProcessed);
        System.debug('Total Failure = ' + recordsFailure);
        System.debug('Total Success = ' + recordsSuccess);
    }

}
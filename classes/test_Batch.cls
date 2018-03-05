global class test_Batch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, ExtendedStatus, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob order by CreatedDate desc limit 10';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<AsyncApexJob> scope)
    {
        for (AsyncApexJob a : scope)
        {
           System.debug('AsyncApexJob: ' + a.ApexClass.Name);
        }
        
    }  
    
    global void finish(Database.BatchableContext BC)
    {
    }
}
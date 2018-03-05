global class PepperSyncJobMonitor implements Schedulable{
    
    global void execute(SchedulableContext sc){
        DateTime sysTime = System.now().dateGMT();
        
        List<AsyncApexJob> todaysApexJobs = [select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, ExtendedStatus, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name 
                                                 From AsyncApexJob 
                                                 WHERE JobType='BatchApex' and ApexClass.Name = 'SyncJob2' and CreatedDate >: sysTime order by CreatedDate desc limit 10];
        System.debug('todaysApexJobs: ' + todaysApexJobs.size());
        if(todaysApexJobs == null || todaysApexJobs.size()==0){
        	Exception__c e = new Exception__c(
            	Name = 'Collections Sync Job Failure',
                Integration_Type__c = 'ESB to Salesforce',
                Exception_Reason__c = 'The Daily SyncJob2 process that is triggered by Mulesoft hasnt started'
            );    
            insert e;
        }


    }
}
/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          BulkSMSScheduler 
Company:       Saasfocus
Description:   This schedular is to schedule BulkSMSBatch.
History
Date    :  22/09/2017     
------------------------------------------------------------*/
global class BulkSMSScheduler implements Schedulable {
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          execute
    Company:       Saasfocus
    Description:   This method is used to schedule batch class which further sends the SMS.
    Inputs:        SchedulableContext
    Returns:       void
    -----------------------------------------------------------------------------------*/
    global void execute(SchedulableContext sc) {
        String jobId = String.ValueOf((sc.getTriggerId())).substring(0,15);
        BulkSMSBatch objBatch = new BulkSMSBatch(jobId );
        Database.executeBatch(objBatch);
    }
}
global class ResultMulesoftSQL2SFDC implements Schedulable,  Database.AllowsCallouts 
{
    global void execute(SchedulableContext sc) 
    {
        List<Mulesoft_Configuration__c> lstMulesoftConfig = Mulesoft_Configuration__c.getAll().values();
        if(lstMulesoftConfig != null && lstMulesoftConfig.size() > 0) if(lstMulesoftConfig[0].Result_Batch_Class_Id__c != null)
        {
            List<AsyncApexJob> runningJobs = [select id from AsyncApexJob 
                                                    where 
                                                    (
                                                        status = 'Processing' Or
                                                        status = 'Queued' Or
                                                        status = 'Preparing' Or
                                                        status = 'Holding' 
                                                    ) 
                                                    AND ApexClassId =: lstMulesoftConfig[0].Result_Batch_Class_Id__c 
                                                    AND JobType = 'BatchApex'];
            if(!(runningJobs != null && runningJobs.size() > 0)) Database.executeBatch(new MulesoftBatchJobResult(), 1);
        }
    }
}
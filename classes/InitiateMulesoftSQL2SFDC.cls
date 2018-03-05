global class InitiateMulesoftSQL2SFDC implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        startMuleProcess();
    }

	@future(Callout=true)
	public static void startMuleProcess()
	{
		MulesoftBatchJobHandler objMulesoftBatchJobHandler = new MulesoftBatchJobHandler();
        objMulesoftBatchJobHandler.initMulesoftProcess();
	}
}
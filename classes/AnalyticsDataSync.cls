global class AnalyticsDataSync implements Schedulable
{ 
	global void execute(SchedulableContext sc) 
    {
        Database.executeBatch(new Mortgage_Analytics_Batch(), 200);
		Database.executeBatch(new PAF_Analytics_Batch(), 200);
    }
}
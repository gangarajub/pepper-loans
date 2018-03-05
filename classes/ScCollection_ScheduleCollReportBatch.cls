//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch class ScCollection_CollectorReportBatch
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 29-SEP-2016         Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestCollectorReportBatch
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_ScheduleCollReportBatch implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        ScCollection_CollectorReportBatch b = new ScCollection_CollectorReportBatch(); 
        database.executebatch(b);
    }
}
//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch class ScCollection_BatchSendBulkSMS
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 19-Jan-2017         Created By: Kashish Dwivedi         Email: kashish.dwivedi@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : 
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_ScheduleBatchSendBulkSMS implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        ScCollection_BatchSendBulkSMS b = new ScCollection_BatchSendBulkSMS(); 
        database.executebatch(b);
    }
}
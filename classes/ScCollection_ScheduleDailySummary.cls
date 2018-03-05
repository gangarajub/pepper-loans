//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch that would update the daily contract summary on contract summary object
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 16-AUG-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_testScheduleDailySummary
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_ScheduleDailySummary implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        ScCollection_BatchDailyContractSummary b = new ScCollection_BatchDailyContractSummary(System.today()); 
        database.executebatch(b);
    }
}
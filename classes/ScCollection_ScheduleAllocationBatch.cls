//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch class ScCollection_ContractAllocationBatch
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 29-SEP-2016         Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestScheduleAllocationBatch
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_ScheduleAllocationBatch implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        ScCollection_ContractAllocationBatch b = new ScCollection_ContractAllocationBatch(); 
        database.executebatch(b);
    }
}
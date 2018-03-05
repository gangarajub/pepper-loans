//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch class ScCollection_BatchUpdtCrctSettingfrmStat
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 21-JULY-2016         Created By: Deepak Dhingra         Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestScheduleContractSetting
//  -------------------------------------------------------------------------------------------------------
global  class ScCollection_ScheduleContractSettingCntr implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        ScCollection_BatchUpdtCrctSettingfrmStat b = new ScCollection_BatchUpdtCrctSettingfrmStat(); 
        database.executebatch(b);
    }
}
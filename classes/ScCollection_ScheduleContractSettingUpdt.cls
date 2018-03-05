//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch class ScCollection_BatchUpdateContSetting
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 21-JULY-2016         Created By: Deepak Dhingra         Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestSchduleContractSetting
//  -------------------------------------------------------------------------------------------------------
global  class ScCollection_ScheduleContractSettingUpdt implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        ScCollection_BatchUpdateContSetting b = new ScCollection_BatchUpdateContSetting(); 
        database.executebatch(b);
    }
}
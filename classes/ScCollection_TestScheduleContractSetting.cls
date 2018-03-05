// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ScheduleContractSettingCntr class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestScheduleContractSetting  
{
    public static testMethod void testschedule()
    {
        Test.StartTest();
        ScCollection_ScheduleContractSettingCntr sh1 = new ScCollection_ScheduleContractSettingCntr();      
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
}
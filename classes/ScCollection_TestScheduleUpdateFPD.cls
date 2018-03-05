// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ScheduleUpdateFPD class
// ----------------------------------------------------------------------------------------------------
// Created Date: 4-NOV-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest
private class ScCollection_TestScheduleUpdateFPD 
{    
    @isTest static void test_method_one() 
    {
        Test.StartTest();
            ScCollection_ScheduleUpdateFPD sh1 = new ScCollection_ScheduleUpdateFPD();      
            String sch = '0  00 1 3 * ?';
            system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
}
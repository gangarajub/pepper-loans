// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ScheduleAllocationBatch class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData=false)
public class ScCollection_TestScheduleAllocationBatch
{
    static testMethod void myUnitTest() 
    {
        Test.StartTest();
        ScCollection_ScheduleAllocationBatch obj = new ScCollection_ScheduleAllocationBatch();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, obj);
        Test.stopTest();        
    }
}
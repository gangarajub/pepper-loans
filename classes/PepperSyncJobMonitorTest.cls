@isTest
public class PepperSyncJobMonitorTest {
   @isTest Static Void testschedule(){
       
       test.startTest();
       system.schedule('testschedule', '0 56 11 * * ?', new PepperSyncJobMonitor());
       test.stopTest();
    }
}
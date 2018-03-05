@isTest
public class TestAnalyticsDataSync
{
    public static testMethod void testschedule() 
    {
        Test.startTest();
        AnalyticsDataSync sh1 = new AnalyticsDataSync();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        
        Test.stopTest();
    }


}
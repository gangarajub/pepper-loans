@isTest(SeeAllData=False) 
private class pepOBSReportingSchedule_tracker{

     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
          @isTest static void testMethod1(){
         
         Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new pepOBSReportingSchedule());
          Test.stopTest();               
        }
   }
@isTest(SeeAllData=True)
Private class MondayExpiredInsuranceReport_Test{
Public Testmethod  static void test1(){
 
        Test.startTest();
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 1); 
        String ss = String.valueOf(Datetime.now().second());
        String year=String.valueof(System.today().year());
        string day=string.valueof(System.today().day());
        string month=String.valueof(System.Today().month());
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+day+' '+month+' '+'?'+' '+year;
         ModayExpoiredInsuranceScheduler s = new ModayExpoiredInsuranceScheduler(); 
        String jobId=System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);
           CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,

         NextFireTime

         FROM CronTrigger WHERE id = :jobId];

 

      // Verify the expressions are the same

      System.assertEquals(nextFireTime,

         ct.CronExpression);

 

      // Verify the job has not run

      System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
        System.assert([Select id from Emailmessage where Incoming=false].size()>0,'Assertion Test');
        }
}
@IsTest(SeeAllData='true')
Private class ExportCapaignReportAsExcel_Tracker{
Public static testmethod void Reportchecker(){
Test.startTest();
ExportCapaignReportAsExcel  exp = new ExportCapaignReportAsExcel();
String hour = String.valueOf(Datetime.now().hour());
String min = String.valueOf(Datetime.now().minute() + 1); 
String ss = String.valueOf(Datetime.now().second());

//parse to cron expression
String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

ExportCapaignReportAsExcel s = new ExportCapaignReportAsExcel(); 
System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);
Test.stopTest();
      
}
}
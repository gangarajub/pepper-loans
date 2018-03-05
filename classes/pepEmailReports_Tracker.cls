@isTest(SeeAllData=True) private class pepEmailReports_Tracker{
    
    
    @isTest static void pepEmailReportCsvTest(){
        
        pepDailyEmailReportCsv objDaily = new pepDailyEmailReportCsv();
        objDaily.Execute(null);
       
        pepWeeklyEmailReportCsv objWeekly = new pepWeeklyEmailReportCsv();
        objWeekly.Execute(null);
        
        pepMonthlyEmailReportCsv objMonthly = new pepMonthlyEmailReportCsv();
        objMonthly.Execute(null);
        
    }



}
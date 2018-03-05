/*-------------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          BulkSMSContractListHandler 
Company:       Saasfocus
Description:   This Class is called from Java Script Detail Button 
               from Classic view and Global Action on Lightning Record 
               View to schedule the SMS again if the Error occured in 
               the Schedule Batch.
History
Date    :  28/09/2017     
--------------------------------------------------------------------*/
global class ScheduleBulkSMSIfError{
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ScheduleSMS
    Company:       Saasfocus
    Description:   This method is take Record Id as input and Schedule the Scheduled 
                   Apex Class after 1 min the current time and update the job Id 
                   in the Record. 
    Inputs:        Id
    Returns:       String
    -----------------------------------------------------------------------------------*/
    
    @AuraEnabled
    webservice static String ScheduleSMS(Id recordId){
        
        try{
            DateTime dateNow = System.Now();
            String strSec = '0';
            String strMin = String.valueOf(dateNow.minute()+1);
            String strHour = String.valueOf(dateNow.hour());
            String strDay = String.valueOf(dateNow.day());
            String strMonth = String.valueOf(dateNow.month());
            String strDayOfWeek = '?';
            String strYear = String.valueOf(dateNow.year());
            
            String sch = strSec + ' ' + strMin + ' ' + strHour + ' ' + strDay + ' ' + strMonth + ' ' + strDayOfWeek + ' ' + strYear ;
                        
            String strScheduleName = 'Scheduled ' + recordId + ' ' + System.Now();
            String strSchName = 'Scheduled ' + recordId + System.Now().format();
            BulkSMSScheduler  objScheduler = new BulkSMSScheduler();
            String jobID = system.schedule(strScheduleName, sch, objScheduler);
            
            ScCollection_Bulk_Scheduled_SMS__c objScheduleSMS = new ScCollection_Bulk_Scheduled_SMS__c();
            objScheduleSMS.Id = recordId;
            objScheduleSMS.ScCollection_Job_Id__c = jobID;
            objScheduleSMS.ScCollection_Error_Message__c = '';
            objScheduleSMS.ScCollection_Scheduler_Name__c = strSchName ;
            objScheduleSMS.ScCollection_IsSuccess__c = true;
            update objScheduleSMS;
            
            return 'SUCCESS-Job Schedule Successfully. Job Name is '+ strScheduleName;
        }
        catch(exception ex){
            return 'ERROR- '+ ex.getMessage();
        }    
    }
    
}
/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          BulkSMSBatchTest 
Company:       Saasfocus
Description:   This class is use to test BulkSMSBatch class.
History
Date    :  24/09/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
public class BulkSMSBatchTest{
    
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static collect__Action_Code__c objActioncode;
    public static loan__Loan_Account__c  objPLContract;
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testingBatchForClContract
    Company:       Saasfocus
    Description:   This method is use to test batch for CL Contract.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    public static void testingBatchForClContract(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        Sms_Magic__c objCustomSetting = new Sms_Magic__c();
        objCustomSetting.senderId__c ='PepperMoney';
        objCustomSetting.Name = 'CollectionSenderId';
        insert objCustomSetting;
        
        objActioncode = new collect__Action_Code__c(
                                            Name = 'Other',
                                            ScCollection_Is_Inbound_Action__c = false,
                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
        insert objActioncode;
        ScCollection_Bulk_Scheduled_SMS__c objBulkSMS = new ScCollection_Bulk_Scheduled_SMS__c(
                                                                        ScCollection_Contract_Id_s__c = objContract.Id,
                                                                        ScCollection_Job_Id__c = 'testing',
                                                                        ScCollection_Review_Date__c = DateTime.newInstance(2017,9,27,14,840,50400),
                                                                        ScCollection_Action_Code_Id__c = objActioncode.Id,
                                                                        ScCollection_SMS_Text__c = 'Reminder: Your ');
        insert objBulkSMS;
        
        Test.StartTest();
            BulkSMSBatch objBatch = new BulkSMSBatch(objBulkSMS.ScCollection_Job_Id__c);
            database.executeBatch(objBatch);
        Test.Stoptest();
        List<cnotify__Delivery_Detail__c> lstDD = [Select Id From cnotify__Delivery_Detail__c  where cnotify__Contract_Id__c =: objContract.Id];
        System.assert(lstDD.Size() == 1 ,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testingBatchForPlContract
    Company:       Saasfocus
    Description:   This method is use to test batch for PL Contract.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void testingBatchForPlContract(){
        
        objPLContract = pepCommonTrackerController.createLoanAccount();
        
        Sms_Magic__c objCustomSetting = new Sms_Magic__c();
        objCustomSetting.senderId__c ='PepperMoney';
        objCustomSetting.Name = 'CollectionSenderId';
        insert objCustomSetting;
        
        objActioncode = new collect__Action_Code__c(
                                            Name = 'Other',
                                            ScCollection_Is_Inbound_Action__c = false,
                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
        insert objActioncode;
        ScCollection_Bulk_Scheduled_SMS__c objBulkSMS = new ScCollection_Bulk_Scheduled_SMS__c(
                                                                        ScCollection_Contract_Id_s__c = objPLContract.Id,
                                                                        ScCollection_Job_Id__c = 'testing',
                                                                        ScCollection_Review_Date__c = DateTime.newInstance(2017,9,27,14,840,50400),
                                                                        ScCollection_Action_Code_Id__c = objActioncode.Id,
                                                                        ScCollection_SMS_Text__c = 'Reminder: Your ');
        insert objBulkSMS;
        
        Test.StartTest();
            BulkSMSBatch objBatch = new BulkSMSBatch(objBulkSMS.ScCollection_Job_Id__c);
            database.executeBatch(objBatch);
            
            DateTime dateNow= System.Now();
            String strSec = '0';
            String strMin = String.valueOf(dateNow.minute()+2);
            String strHour = String.valueOf(dateNow.hour());
            String strDay = String.valueOf(dateNow.day());
            String strMonth = String.valueOf(dateNow.month());
            String strDayOfWeek = '?';
            String strYear = String.valueOf(dateNow.year());
            
            String sch = strSec + ' ' + strMin + ' ' + strHour + ' ' + strDay + ' ' + strMonth + ' ' + strDayOfWeek + ' ' + strYear ;
            BulkSMSScheduler objSchedule = new BulkSMSScheduler ();
            
            String jobID = system.schedule('test', sch, objSchedule);
        Test.Stoptest();
        List<cnotify__Delivery_Detail__c> lstDD = [Select Id From cnotify__Delivery_Detail__c  where cnotify__Contract_Id__c =: objPLContract.Id];
        System.assert(lstDD.Size() == 1 ,'worked');
    }
}
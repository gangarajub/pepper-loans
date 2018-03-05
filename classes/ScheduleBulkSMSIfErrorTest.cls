/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScheduleBulkSMSIfErrorTest 
Company:       Saasfocus
Description:   This class is use to test ScheduleBulkSMSIfError class.
History
Date    :  24/09/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
public class ScheduleBulkSMSIfErrorTest{
    
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static collect__Action_Code__c objActioncode;
    public static loan__Loan_Account__c  objPLContract;
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ScheduleSMSTest
    Company:       Saasfocus
    Description:   This method is use to test the apex method ScheduleSMS.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    public static void ScheduleSMSTest(){
        
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
            String strResponse = ScheduleBulkSMSIfError.ScheduleSMS(objBulkSMS.Id);
        Test.Stoptest();
        String str = strResponse.split('\\-')[0];
        System.assert(str == 'SUCCESS' ,'worked');
    }
    
}
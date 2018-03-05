/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_TestTrgOnSyncStatHandler
Company:       Saasfocus
Description:   This class is use to test the trigger behavious.
History
2/08/2017      Sandip Bijlwan     
------------------------------------------------------------*/
@isTest(SeeAllData=False) Public Class ScCollection_TestTrgOnSyncStatHandler{
    
    /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          test0
        Company:       Saasfocus
        Description:   This method is used to test send sms and email notification.
        Inputs:        no input.
        Returns:       void
        ------------------------------------------------------------*/
    @istest static void test0(){
        
        Collections_Sync_Job_Settings__c objErr = new Collections_Sync_Job_Settings__c();

        objErr.EmailESBStagingSyncProcess__c = 'ahumby@pepper.com.au';
        objErr.EmailStagingActualSyncProcess__c = 'ahumby@pepper.com.au';
        objErr.EmailsToGetFilesMissingAlert__c = 'ahumby@pepper.com.au';
        objErr.Enable_Email_Alerts__c = true;
        objErr.Check_Sync_Job_Data_Exists__c = true;
        objErr.SMS_Recipients_For_Sync_Data_Failures__c = '1234567890';
        objErr.SMS_Template_AllFilesReceivedProcess__c = 'SMS Template text';
        objErr.Processes_Names_Mortgage__c = 'Contracts,Transactions,Bank-Accounts,Party';
        objErr.Processes_Names_PAF__c = 'Contracts,Transactions,Bank-Accounts,Party';
        objErr.Enable_SMS_Alerts__c = true;
        objErr.Override_Sync_Job_API_Settings__c = true;
        objErr.Sync_Job_Batch_Size__c = 1000;
        objErr.Sync_Job_Invokes_Create_Activity_Job__c = true;
        objErr.Sync_Job_Submit_Next_Job__c = true;
        objErr.Sync_Job_Parent_Table__c = 'staging__Interface_Bank_Account__c';
        insert objErr;
        
        Sms_Magic__c objMagic = new Sms_Magic__c();
        objMagic.Name='CollectionSenderId';
        objMagic.senderId__c='PepperMoney';
        insert objMagic;
        
        collect__Sync_Statistics__c objStats = new collect__Sync_Statistics__c(
                                                            collect__Batch_Id__c = '707p000000DUM5IAAX',
                                                            collect__Num_Errors__c = 1,
                                                            collect__Parent_Batch_Id__c = '707p000000DUM5IAAX',
                                                            collect__Records_Deleted__c = 0.0,
                                                            collect__Records_Inserted__c = 20.0,
                                                            collect__Records_Processed__c = 20.0,
                                                            collect__Records_Read__c = 20.0,
                                                            collect__Records_Updated__c = 0.0,
                                                            collect__Source_Table__c = 'staging__interface_bank_account__c',
                                                            collect__Target_Table__c = 'collect__bank_account__c');
        test.StartTest();
        insert objStats;
        test.StopTest();
        
        smagicinteract__smsMagic__c objsmsmagic = [Select id,smagicinteract__PhoneNumber__c  from smagicinteract__smsMagic__c limit 1];
        system.assert(objsmsmagic.smagicinteract__PhoneNumber__c =='1234567890','worked');
    }

}
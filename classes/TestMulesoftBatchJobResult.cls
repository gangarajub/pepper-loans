@isTest
public class TestMulesoftBatchJobResult
{
     static testMethod void MulesoftBatchJobResult() 
    { 
        Database.BatchableContext BC;
        Mulesoft_Configuration__c Mule =New Mulesoft_Configuration__c();
            Mule.Name='Mulesoft';
            Mule.API_ver__c='34.0';
            Mule.Client_Id__c='3MVG9Se4BnchkASmwj33vhYPd_QE9LxUiHnGD_sa93eiXJ9kqKzcjzoPtAN_b5kSvTq0Soxp9xHBx.xMZaD_J';
            Mule.Client_Secret__c='7150987666493593516';
            Mule.Error_Handling_URL__c='https://c.cs31.visual.force.com/apex/MulesoftBatchJobHandler';
            Mule.Error_Recipient__c='sumit.banarji@saasfocus.com ';
            Mule.Mulesoft_Job_Url__c='sumit.banarji@saasfocus.com ';
            Mule.Mulesoft_Password__c='P3pp3rPa55';
            Mule.Mulesoft_User_Name__c='pepper';
            Mule.Salesforce_Instance_URL__c='https://cs31.salesforce.com/home/home.jsp?sdtd=1';
            Mule.SF_Password__c='saasfocus@2016';
            Mule.SF_Token_Endpoint__c='https://test.salesforce.com/services/oauth2/token';
            Mule.SF_User_Name__c='siddharth.malhotra@pepper.com.au.clevel';
            Mule.Success_Recipients__c='sumit.banarji@saasfocus.com ';
            Mule.Mortgage_Last_Sync_Time__c=System.today()-3;
            Insert Mule;
        Mule_Batch_Job__c objMBJ = new Mule_Batch_Job__c();
            objMBJ.Batch_Id__c = 'B1';
            objMBJ.Job_Id__c = 'J1';
            insert objMBJ;
        Test.startTest();
        MulesoftBatchJobResult JobResult =New MulesoftBatchJobResult();
        Database.executebatch(JobResult);
         JobResult.start(BC);
        JobResult.finish(BC);
        Test.stopTest();
    }
}
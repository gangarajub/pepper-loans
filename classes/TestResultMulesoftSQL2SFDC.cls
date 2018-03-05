@isTest
public class TestResultMulesoftSQL2SFDC 
{
    public static testMethod void Test1() 
    {
        Mulesoft_Configuration__c obj = new Mulesoft_Configuration__c();
            obj.Name = 'Mulesoft';
            obj.API_ver__c = '34.0';
            obj.Client_Id__c = '3MVG9Se4BnchkASmwj33vhYPd_QE9LxUiHnGD_sa93eiXJ9kqKzcjzoPtAN_b5kSvTq0Soxp9xHBx.xMZaD_J';
            obj.Client_Secret__c = '7150987666493593516';
            obj.Error_Handling_URL__c = 'https://cs31.salesforce.com/apex/MulesoftBatchJobHandler';
            obj.Error_Recipient__c = 'sumit.banarji@saasfocus.com\nrachit.rastogi@saasfocus.com';
            obj.Mulesoft_Job_Url__c = 'https://c-suite-sandbox-v1.au.cloudhub.io/CSuite/feed/v1';
            obj.Mulesoft_Password__c = 'P3pp3rPa55';
            obj.Mulesoft_User_Name__c = 'pepper';
            obj.Salesforce_Instance_URL__c = 'https://cs31.salesforce.com';
            obj.SF_Password__c = 'saasfocus@2016';
            obj.SF_Token_Endpoint__c = 'https://test.salesforce.com/services/oauth2/token';
            obj.SF_User_Name__c = 'siddharth.malhotra@pepper.com.au.clevel';
            obj.Success_Recipients__c = 'sumit.banarji@saasfocus.com\nrachit.rastogi@saasfocus.com';
            obj.Result_Batch_Class_Id__c='01pp00000009DYWAA2';
            insert obj;
       
        Test.startTest();
        ResultMulesoftSQL2SFDC Result =New ResultMulesoftSQL2SFDC();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, Result);
        
        Test.stopTest();
    }

}
@isTest
public class TestMortgageAnalyticsBatch 
{
    static testMethod void MortgageAnalyticsBatch() 
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
        Pepper_Data__c Pepper =New Pepper_Data__c();
           Pepper.Application_Date__c=system.today();
           Pepper.Amount__c=84843;
           Pepper.Status__c='Application';
           Pepper.ApplicationID__c='6282';
           Pepper.Channel__c='Direct';
           Pepper.Product_class_name__c='Near Prime';
           Pepper.Status_Detail__c='Application';
           Pepper.Borrower_State__c='NSW';
           Insert Pepper;
        Pepper_Analytical_Snapshot__c PepperAnalytical =New Pepper_Analytical_Snapshot__c();
           PepperAnalytical.Amount_as__c=84843;
           PepperAnalytical.Application_Date_as__c=system.today();
           PepperAnalytical.ApplicationID_as__c='6282';
           PepperAnalytical.Channel_as__c='Direct';
           PepperAnalytical.Product_class_name_as__c='Near Prime';
           PepperAnalytical.Status_Detail__c='Application';
           PepperAnalytical.Borrower_State_as__c='NSW';
           Insert  PepperAnalytical;
          Test.startTest();
          Mortgage_Analytics_Batch Mort =New Mortgage_Analytics_Batch();
          Database.executebatch(Mort);
          Mort.start(BC);
          Test.stopTest();
           

           
           
        
       
           
    }

}
@isTest
public class TestPAFAnalyticsBatch 
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
            Mule.PAF_Last_Sync_Time__c=System.today()-3;
            Mule.Mortgage_User_Group__c = 'me';
            Mule.PAF_User_Groups__c = 'me';
            Mule.Chatter_Notification_Body__c ='testBody';
            Insert Mule;
        Application_Data__c Application =New Application_Data__c();
          
           Application.ApplicationDate__c=system.today();
           Application.NetFinancedAmount__c=84843;
           Application.MileStone__c='Application';
           Application.ApplicationNumber__c='P-20160521000602';
           Application.Channel__c='PAF - Auto Broker';
           Application.AssetType__c='Caravan';
           Application.Sub_Status__c='Approved';
           Application.ApplicationState__c='ACT ';
           Application.TotalFinancedAmount__c=2333344;
           Insert Application;
        PFA_Analytical_Snapshot__c PFAAnalytical =New PFA_Analytical_Snapshot__c();
           PFAAnalytical.ApplicationDate__c=system.today();
           PFAAnalytical.NetFinancedAmount__c=84843;
           PFAAnalytical.MileStone__c='Application';
           PFAAnalytical.ApplicationNumber__c='P-20160521000602';
           PFAAnalytical.Channel__c='PAF - Auto Broker';
           PFAAnalytical.AssetType__c='Caravan';
           PFAAnalytical.Sub_Status__c='Approved';
           PFAAnalytical.ApplicationState__c='ACT   ';
           PFAAnalytical.TotalFinancedAmount__c=2333344;
           Insert PFAAnalytical;
          Test.startTest();
          PAF_Analytics_Batch PAF =New PAF_Analytics_Batch();
          Database.executebatch(PAF);
           PAF.start(BC);
          Test.stopTest();
        
    }
}
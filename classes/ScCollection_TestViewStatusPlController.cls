// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ViewStatusPlController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 22-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestViewStatusPlController 
{
    static testMethod void myUnitTest() 
    {
        loan__Loan_Account__c lon = new loan__Loan_Account__c();
        lon = pepCommonTrackerController.createLoanAccount(); 
        
        collect__Contract_Status__c colectContrct = new collect__Contract_Status__c();
        colectContrct.ScCollection_Arrears__c='Overdue';
        insert colectContrct;       
   
        collect__Source_System__c collSo = new collect__Source_System__c();
        collSo.Name = 'CL Loan';
        insert collSo;
       
        collect__Status_Config__c collSt = new collect__Status_Config__c();
        collSt.collect__Source_System__c = collSo.Id;
        collSt.collect__Status__c = 'TestStatus';
        collSt.collect__Status_API_Name__c = 'ScCollection_Arrears__c';
        insert collSt;
        
        List<collect__Status_Config__c> lstCollSt = new List<collect__Status_Config__c> ();
        lstCollSt.add(collSt);
        
        //Insert Object of Contract
        collect__Loan_Account__c objcontract1 = new collect__Loan_Account__c();
        objcontract1.Name = 'Contract-001';
        objcontract1.collect__Source_System__c = collSo.Id;
        objcontract1.collect__Delinquent_Amount__c = 8000;
        objcontract1.collect__External_ID__c = lon.Id;
        insert objcontract1;
        
        List<collect__Collections_Metrics_Settings__c> lstCMS = new List<collect__Collections_Metrics_Settings__c>();
        collect__Collections_Metrics_Settings__c objCMS1 = new collect__Collections_Metrics_Settings__c();
        objCMS1.Name = 'Monthly';
        objCMS1.collect__Contact_Count_Threshold__c = 30;
        objCMS1.collect__Threshold_Days__c = 30;
        lstCMS.add(objCMS1);
        
        collect__Collections_Metrics_Settings__c objCMS2 = new collect__Collections_Metrics_Settings__c();
        objCMS2.Name = 'Weekly';
        objCMS2.collect__Contact_Count_Threshold__c = 7;
        objCMS2.collect__Threshold_Days__c = 7;
        lstCMS.add(objCMS2);
        
        insert lstCMS;
        
        List<collect__Contract_Collections_Metrics__c> lstCCM = new List<collect__Contract_Collections_Metrics__c>();
        collect__Contract_Collections_Metrics__c objCCM1 = new collect__Contract_Collections_Metrics__c();
        objCCM1.Name = 'Monthly:'+ objcontract1.Name;
        objCCM1.collect__Dev_Contract__c = objcontract1.Id;
        objCCM1.collect__Contact_Count__c = 2;
        objCCM1.collect__Threshold_Days__c = 20;
       
        lstCCM.add(objCCM1);
        
        collect__Contract_Collections_Metrics__c objCCM2 = new collect__Contract_Collections_Metrics__c();
        objCCM2.Name = 'Weekly:'+ objcontract1.Name;
        objCCM2.collect__Dev_Contract__c = objcontract1.Id;
        objCCM2.collect__Contact_Count__c = 1;
        objCCM2.collect__Threshold_Days__c = 20;
        
        lstCCM.add(objCCM2);
        
        insert lstCCM;
        
        List<ScCollection_ContactCounterSetting__c> lstCCS = new List<ScCollection_ContactCounterSetting__c>();
        ScCollection_ContactCounterSetting__c objCCS1 = new ScCollection_ContactCounterSetting__c();
        objCCS1.Name = 'Monthly';
        objCCS1.ScCollection_MinRange__c = 1;
        objCCS1.ScCollection_MaxRange__c = 2;
        objCCS1.ScCollection_Color_Code__c = 'test';
        objCCS1.ScCollection_Counter_Type__c = 'Monthly';
        lstCCS.add(objCCS1);
        
        ScCollection_ContactCounterSetting__c objCCS2 = new ScCollection_ContactCounterSetting__c();
        objCCS2.Name = 'Weekly';
        objCCS2.ScCollection_MinRange__c = 0;
        objCCS2.ScCollection_MaxRange__c = 1;
        objCCS2.ScCollection_Color_Code__c = 'test';
        objCCS2.ScCollection_Counter_Type__c = 'Weekly';
        lstCCS.add(objCCS2);
        insert lstCCS;
        
        ScCollection_ViewStatusPlController scColl = new ScCollection_ViewStatusPlController(new ApexPages.StandardController(lon)); 
        scColl.objStatus = colectContrct;
        scColl.lookforRelateEntities(); 
       
        colectContrct.ScCollection_Arrears__c = null;
        update colectContrct;
       
        scColl.objStatus = colectContrct;
        
        scColl.PopulateContractStatus();
        scColl.UpdateStatus();
    }
}
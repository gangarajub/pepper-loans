// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ESB_To_SF_ErrorHandling class
// ----------------------------------------------------------------------------------------------------
// Created Date: 22-APR-2017          Created By: Sandip Bijlwan        
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class TestESB_To_SF_ErrorHandling
{
    static testMethod void myUnitTest1() 
    {  
         User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            CRM_Mtg_Unique_Id__c =111245
            );   
            
        insert u; 
        
        system.runAs(u)
        {   
            ESB_To_SF_ErrorHandling.PostRequest objPostReq = new ESB_To_SF_ErrorHandling.PostRequest ();
            objPostReq.ServiceType = 'DES_Extract';
        
            ESB_Batch_Load_Stat__c objBatchLoadStat = new ESB_Batch_Load_Stat__c(
                                                            Batch_Job_Instance_Id__c = '76f7b3f0-2f7a-11e7-a3d8-06200eacffd7',
                                                            Country_Code__c = 'AU',
                                                            Elapsed_Time_In_Millis__c = 3419.0,
                                                            Entity__c = 'application',
                                                            Failed_On_Input_Phase__c = false,
                                                            Failed_On_Loading_Phase__c = false,
                                                            Failed_Records__c = 0.0,
                                                            Loaded_Records__c = 509.0,
                                                            Processed_Records__c = 509.0,
                                                            Successful_Records__c = 509.0,
                                                            Total_Records__c = 509.0,
                                                            failedOnCompletePhase__c = false,
                                                            LOB__c = 'Mortgage');
            insert objBatchLoadStat;
            ESB_Batch_Load_Stat__c objBatchLoadStat1 = new ESB_Batch_Load_Stat__c(
                                                            Batch_Job_Instance_Id__c = '76f7b3f0-2f7a-11e7-a3d8-06200eacffd7',
                                                            Country_Code__c = 'AU',
                                                            Elapsed_Time_In_Millis__c = 3419.0,
                                                            Entity__c = 'loansplit',
                                                            Failed_On_Input_Phase__c = false,
                                                            Failed_On_Loading_Phase__c = false,
                                                            Failed_Records__c = 0.0,
                                                            Loaded_Records__c = 509.0,
                                                            Processed_Records__c = 509.0,
                                                            Successful_Records__c = 509.0,
                                                            Total_Records__c = 509.0,
                                                            failedOnCompletePhase__c = false,
                                                            LOB__c = 'Mortgage');
            insert objBatchLoadStat1;
            
            ESB_Batch_Load_Stat__c objBatchLoadStat2 = new ESB_Batch_Load_Stat__c(
                                                            Batch_Job_Instance_Id__c = '76f7b3f0-2f7a-11e7-a3d8-06200eacffd7',
                                                            Country_Code__c = 'AU',
                                                            Elapsed_Time_In_Millis__c = 3419.0,
                                                            Entity__c = 'party',
                                                            Failed_On_Input_Phase__c = false,
                                                            Failed_On_Loading_Phase__c = false,
                                                            Failed_Records__c = 0.0,
                                                            Loaded_Records__c = 509.0,
                                                            Processed_Records__c = 509.0,
                                                            Successful_Records__c = 509.0,
                                                            Total_Records__c = 509.0,
                                                            failedOnCompletePhase__c = false,
                                                            LOB__c = 'Mortgage');
            insert objBatchLoadStat2;
            
            ESB_Batch_Load_Stat__c objBatchLoadStat3 = new ESB_Batch_Load_Stat__c(
                                                            Batch_Job_Instance_Id__c = '76f7b3f0-2f7a-11e7-a3d8-06200eacffd7',
                                                            Country_Code__c = 'AU',
                                                            Elapsed_Time_In_Millis__c = 3419.0,
                                                            Entity__c = 'security',
                                                            Failed_On_Input_Phase__c = false,
                                                            Failed_On_Loading_Phase__c = false,
                                                            Failed_Records__c = 0.0,
                                                            Loaded_Records__c = 509.0,
                                                            Processed_Records__c = 509.0,
                                                            Successful_Records__c = 509.0,
                                                            Total_Records__c = 509.0,
                                                            failedOnCompletePhase__c = false,
                                                            LOB__c = 'Mortgage');
            insert objBatchLoadStat3;
            ESB_Batch_Load_Stat__c objBatchLoadStat4 = new ESB_Batch_Load_Stat__c(
                                                            Batch_Job_Instance_Id__c = '76f7b3f0-2f7a-11e7-a3d8-06200eacffd7',
                                                            Country_Code__c = 'AU',
                                                            Elapsed_Time_In_Millis__c = 3419.0,
                                                            Entity__c = 'fees',
                                                            Failed_On_Input_Phase__c = false,
                                                            Failed_On_Loading_Phase__c = false,
                                                            Failed_Records__c = 0.0,
                                                            Loaded_Records__c = 509.0,
                                                            Processed_Records__c = 509.0,
                                                            Successful_Records__c = 509.0,
                                                            Total_Records__c = 509.0,
                                                            failedOnCompletePhase__c = false,
                                                            LOB__c = 'Mortgage');
            insert objBatchLoadStat4;
            
            ESB_Batch_Load_Stat__c objBatchLoadStat5 = new ESB_Batch_Load_Stat__c(
                                                            Batch_Job_Instance_Id__c = '76f7b3f0-2f7a-11e7-a3d8-06200eacffd7',
                                                            Country_Code__c = 'AU',
                                                            Elapsed_Time_In_Millis__c = 3419.0,
                                                            Entity__c = 'account',
                                                            Failed_On_Input_Phase__c = false,
                                                            Failed_On_Loading_Phase__c = false,
                                                            Failed_Records__c = 0.0,
                                                            Loaded_Records__c = 509.0,
                                                            Processed_Records__c = 509.0,
                                                            Successful_Records__c = 509.0,
                                                            Total_Records__c = 509.0,
                                                            failedOnCompletePhase__c = false,
                                                            LOB__c = 'Mortgage');
            insert objBatchLoadStat5;
            
            Date dt = System.Today();
            
            CRM_Mtg_BDM_Target__c objBdmTarget = 
            new CRM_Mtg_BDM_Target__c(
            Name = '123456-Mar-2017',
            CRM_Mtg_BDM_Unique_Id__c = 111245,
            CRM_Mtg_Month__c = 'Mar',
            CRM_Mtg_Year__c = String.valueOf(System.Today().Year()),
            CRM_Mtg_Default_Record__c = true);
            
            insert objBdmTarget;
            
            CRM_Mtg_Application_Target__c objAppTarget = 
            new CRM_Mtg_Application_Target__c(
            CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
            CRM_Mtg_Channel__c = 'White Label',
            CRM_Mtg_Product__c = 'Prime',
            CRM_Mtg_Target_Applications_Amt__c = 0.0,
            CRM_Mtg_Target_Applications__c = 0.0,
            CRM_Mtg_Unique_Identifier__c = '123111');
            insert objAppTarget;
            
            CRM_Mtg_Settlement_Target__c objSettTarget = 
            new CRM_Mtg_Settlement_Target__c(
            CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
            CRM_Mtg_Channel__c = 'White Label',
            CRM_Mtg_Product__c = 'Prime',
            CRM_Mtg_Target_Settlements_Amt__c = 0.0,
            CRM_Mtg_Target_Settlements__c = 0.0);
            insert objSettTarget;
            
            CRM_Mortgage_Application_Data__c objMortData = 
                new CRM_Mortgage_Application_Data__c(
                Name = '600040',
                CRM_Mtg_Doc_Header_Id__c = '123549',
                CRM_Mtg_Application_Target__c = objAppTarget.Id,
                CRM_Mtg_Settlement_Target__c = objSettTarget.Id,
                CRM_Mtg_Aggregator_Id__c = '1211',
                CRM_Mtg_Application_Date__c = Date.newInstance(dt.Year(),dt.Month(),dt.Day()-10),
                CRM_Mtg_Application_Id__c = '1211',
                CRM_Mtg_Broker_Id__c = '1213',
                CRM_Mtg_Total_Loan_Amount__c = 1141000.0,
                CRM_Mtg_Channel__c = 'Retail',
                CRM_Mtg_Product__c = 'product');

            insert objMortData;
            
            CRM_Mortgage_Applicant_Data__c mtgApplicant = new CRM_Mortgage_Applicant_Data__c(
                    CRM_Mtg_Applicant_Role__c = 'Applicant',
                    CRM_Mtg_First_Name__c = 'Roger',
                    CRM_Mtg_Last_Name__c = 'Hani',
                    CRM_Mtg_Salutation__c = 'Mr',
                    CRM_Mtg_Applicant_Type__c = 'Primary',
                    CRM_Mtg_Applicant_Id__c = objMortData.Id,
                    CRM_Mtg_Doc_Header_Id__c = '155628',
                    CRM_Mtg_Unique_Id__c = '155628~001d000000XnUqzAAF',
                    CRM_Mtg_Mortgage_Application__c = objMortData.Id);
            insert mtgApplicant;
            
            CRM_Mortgage_Fees_Data__c mtgFee = new CRM_Mortgage_Fees_Data__c(
                    CRM_Mtg_Fee_Amount__c = 2762.5,
                    CRM_Mtg_Fee_Type__c = 'MortgageRiskFee',
                    CRM_Mtg_Fees_Id__c = 'MortgageRiskFee-IDA3DBCJ',
                    CRM_Mtg_Doc_Header_Id__c = '147499',
                    CRM_Mtg_Unique_Id__c = '147499~MortgageRiskFee-IDA3DBCJ',
                    CRM_Mtg_Mortgage_Application__c = objMortData.Id);
            insert mtgFee;
            
            CRM_Mortgage_Securities_Data__c mtgSecurity = new CRM_Mortgage_Securities_Data__c(
                        CRM_Mtg_Security_Id__c = '1102034863224',
                        CRM_Mtg_Unique_Id__c = '156613~1102034863224',
                        CRM_Mtg_Doc_Header_Id__c = '156613',
                        CRM_Mtg_Mortgage_Application__c = objMortData.Id);
            insert mtgSecurity;
            
            CRM_Mortgage_Loan_Split_Data__c mtgSplitData = new CRM_Mortgage_Loan_Split_Data__c(
                    CRM_Mtg_ABS_Purpose__c = '131,133',
                    CRM_Mtg_Interest_Rate__c = 7.94,
                    CRM_Mtg_Loan_Amount__c = 235000.0,
                    CRM_Mtg_Loan_Purpose__c = 'OwnerOccupied',
                    CRM_Mtg_Loan_Term__c = 30.0,
                    CRM_Mtg_Payment_Type__c = 'PrincipleAndInterest',
                    CRM_Mtg_Product_Name__c = 'Homeloans Accelerate Lo Doc 65%',
                    CRM_Mtg_Repayment_Frequency__c = 'Monthly',
                    CRM_Mtg_Loan_Id__c = '1102034853000-LP1',
                    CRM_Mtg_Doc_Header_Id__c = '153249',
                    CRM_Mtg_Unique_Id__c = '153249~1102034853000-LP1',
                    CRM_Mtg_Mortgage_Application__c = objMortData.Id);
            insert mtgSplitData;
            
            
            Test.startTest();
                String jsonData;
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                
                
                jsonData = '{\"objectName\":"User", \"recordID\":u.Id ,\"message\":"fail"}';
                req.requestBody = Blob.valueof(jsonData);
                RestContext.request = req;
                ESB_To_SF_ErrorHandling.UpdateRecordPostMethod();
                
                req.requestURI = '/ESBReconciliationService';
                req.httpMethod = 'POST';
                jsonData = JSON.serialize(objPostReq);
                req.requestBody = Blob.valueof(jsonData);
                RestContext.request = req;
                
                ESB_To_SF_ErrorHandling.UpdateRecordPostMethod();
                
                
            Test.StopTest();
        }
    }       
    
       
}
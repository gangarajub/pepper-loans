/*
 * Copyright: 2016, Cloud Lending Solutions
 * 
 * class: CLCollectionsSyncServiceTest
 * 
 * description: Test for CLCollectionsSyncService
 */
@isTest
public with sharing class CLCollectionsWebServicesTest {
    /**
     * Method: testPostServices
     * 
     * Description: Test SyncJob post web service
     */

    Static String jsonData;
    Static CLCollectionsWebServices.PostResponse results;
    Static RestRequest req = new RestRequest(); 
    Static RestResponse res = new RestResponse();
     
    private static void setupService(){
        req.requestURI = '/SyncJobService';
        req.httpMethod = 'POST';
        
    }
    
    testMethod static void testInvalidBatchSize() {
		setupService();        
        Test.startTest();
     
        // Test 1
        jsonData = '{\"batchSize\":\"test\"}';
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
		
        System.debug('1: jsonData: ' + jsonData);
        results = CLCollectionsWebServices.startBatch();
		Test.stopTest();
        system.assertEquals('INVALID_INPUT', results.errorCode, 'Invalid input test failed');
    }

    testMethod static void testTooLargeBatchSize() {
		setupService();        
        Test.startTest();
    
        // Test 2
        jsonData = '{\"batchSize\":5000}';
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;

        System.debug('2: jsonData: ' + jsonData);
        results = CLCollectionsWebServices.startBatch();
		Test.stopTest();
        system.assertEquals('INVALID_INPUT', results.errorCode, 'Invalid input test failed');
    }	
    
    testMethod static void testInvalidSubmitNextJob() {
		setupService();        
        Test.startTest();
        // Test 3
        jsonData = '{\"submitNextJob\":\"a\"}';
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;

        System.debug('3: jsonData: ' + jsonData);
        results = CLCollectionsWebServices.startBatch();
		Test.stopTest();
        system.assertEquals('INVALID_INPUT', results.errorCode, 'Invalid input test failed');
    }

    
        
    testMethod static void testInvalidCreateActivity() {
		setupService();        
        Test.startTest();
        // Test 4
        jsonData = '{\"CreateActivity\":\"a\"}';
        System.debug('5: jsonData: ' + jsonData);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;

        results = CLCollectionsWebServices.startBatch();
		Test.stopTest();
        system.assertEquals('INVALID_INPUT', results.errorCode, 'Invalid input test failed');
    }

    testMethod static void testInvalidCreateActy2() {
		setupService();        
        Test.startTest();
    // Test 5
        jsonData = '{\"CreateActivity\":a}';
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;

        System.debug('6: jsonData: ' + jsonData);
        results = CLCollectionsWebServices.startBatch();

        system.assertEquals('INVALID_INPUT', results.errorCode, 'Invalid input test failed');
        
        Test.stopTest();        
    }

    testMethod static void testValidInput(){
        setupService();
        Test.startTest();
        
        jsonData = '{\"batchSize\":100,\"CreateActivity\":false,\"submitNextJob\":false,\"checkDataExists\":true,\"parentTable\":\"staging__Interface_Contract__c\"}';
        
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;

        System.debug('7: jsonData  >>>>> : ' + jsonData);
        results = CLCollectionsWebServices.startBatch();
		System.debug('results.status: >>>>>...' + results.status);
        System.assertEquals('FILES ARE MISSING IN SALESFORCE', results.status);
        
    }

    /**
     * Method: testGetServices
     * 
     * Description: Test SyncJob get web service
     */
    testMethod static void testGetServices() {
        CLCollectionsWebServices.GetResponse results;
        
        Test.startTest();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'GET';
        
        // Test 1
        req.requestURI = '/SyncJobService/1234567890';
        RestContext.request = req;

        results = CLCollectionsWebServices.getBatchStatus();

        system.assertEquals('INVALID_INPUT', results.errorCode, 'Invalid input test failed');

        // Test 2
        req.requestURI = '/SyncJobService/01p3600000HqE2GAAV';
        RestContext.request = req;

        results = CLCollectionsWebServices.getBatchStatus();

        system.assertEquals('INVALID_INPUT', results.errorCode, 'Invalid input test failed');

        // Test 3
        collect__Sync_Statistics__c ss1 = new collect__Sync_Statistics__c(collect__Parent_Batch_Id__c = '01p3600000HqE2GAAV',
                                                                          collect__Records_Read__c = 0,
                                                                          collect__Records_Processed__c = 0,
                                                                          collect__Records_Inserted__c = 0,
                                                                          collect__Records_Updated__c = 0,
                                                                          collect__Records_Deleted__c = 0,
                                                                          collect__Num_Errors__c = 0);
        
        insert ss1;
        
        req.requestURI = '/SyncJobService/01p3600000HqE2GAAV';
        RestContext.request = req;

        results = CLCollectionsWebServices.getBatchStatus();

        system.assertEquals('NO_ERROR', results.errorCode, 'Invalid input test failed');

        // Test 4
        collect__Sync_Statistics__c ss2 = new collect__Sync_Statistics__c(collect__Parent_Batch_Id__c = '01p3600000HqE2GAAV',
                                                                          collect__Batch_Id__c = '01p3600000HqE2GAAV',
                                                                          collect__Records_Read__c = 0,
                                                                          collect__Records_Processed__c = 0,
                                                                          collect__Records_Inserted__c = 0,
                                                                          collect__Records_Updated__c = 0,
                                                                          collect__Records_Deleted__c = 0,
                                                                          collect__Num_Errors__c = 0);
        
        insert ss2;
        
        req.requestURI = '/SyncJobService/01p3600000HqE2GAAV';
        RestContext.request = req;

        results = CLCollectionsWebServices.getBatchStatus();

        system.assertEquals('BATCH_STATUS_NOT_AVAILABLE', results.errorCode, 'Invalid input test failed');

        Test.stopTest();        
    }
    
    public 
    
    @isTest Static void SendEmailandSMSTest(){
        
        
        //Custom setting-----
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
        objErr.Override_Sync_Job_API_Settings__c = false;
        objErr.Sync_Job_Batch_Size__c = 1000;
        objErr.Sync_Job_Invokes_Create_Activity_Job__c = true;
        objErr.Sync_Job_Submit_Next_Job__c = true;
        objErr.Sync_Job_Parent_Table__c = 'staging__Interface_Bank_Account__c';
        insert objErr;
        
        Sms_Magic__c objMagic = new Sms_Magic__c();
        objMagic.Name='CollectionSenderId';
        objMagic.senderId__c='PepperMoney';
        insert objMagic;
        
        String strEntityName = 'Party,Transactions-Dishonour,Bank-Accounts,Contracts,Customers-Contacts,Customers,Property,Property-LoanSurrogates,Property-Valuation,Property-Insurance,Property-Insurer';
        
        List<String> lstEntityName = strEntityName.Split(',');
        
        List<String> lstLobName = new List<String>();
        lstLobName.add('Mortgage');
        lstLobName.add('PAF');
        List<ESB_Batch_Load_Stat__c> lstBatchLoadStat = new List<ESB_Batch_Load_Stat__c>();
        for(String strLob : lstLobName){
            for(String strEntity : lstEntityName){
                ESB_Batch_Load_Stat__c objStatParty = new ESB_Batch_Load_Stat__c(
                                                            Country_Code__c = 'AU',
                                                            Entity__c = strEntity,
                                                            Failed_On_Input_Phase__c = false,
                                                            Failed_On_Loading_Phase__c = false,
                                                            Failed_Records__c = 1,
                                                            Loaded_Records__c = 1,
                                                            Processed_Records__c = 1,
                                                            Run_Number__c = 'NA',
                                                            Successful_Records__c = 1,
                                                            Total_Records__c = 1,
                                                            failedOnCompletePhase__c = false,
                                                            LOB__c = strLob);
                lstBatchLoadStat.add(objStatParty);
            }
        }
        
        insert lstBatchLoadStat;
        
        
        staging__Interface_Payment_Transaction__c objPaymentTransaction = new staging__Interface_Payment_Transaction__c(
                                                                                                Name = 'aBgp00000008vhr',
                                                                                                staging__Cleared__c = true,
                                                                                                staging__Contract_External_ID__c = '78174',
                                                                                                staging__External_ID__c = '78174:22',
                                                                                                staging__Principal__c = 7835.55,
                                                                                                staging__Reversed__c = false,
                                                                                                staging__Source_ID__c = '22',
                                                                                                staging__Source_Name__c = 'PAF',
                                                                                                staging__Sync_Processed__c = false,
                                                                                                staging__Transaction_Amount__c = 196.64,
                                                                                                staging__Transaction_Date__c = Date.newInstance(2017,03,09),
                                                                                                ScCollection_Country_Code__c = 'AU',
                                                                                                ScCollection_Transaction_Applied_Date__c = Date.newInstance(2017,03,09),
                                                                                                ScCollection_Transaction_Type__c = 'PAY',
                                                                                                ScCollection_External_Id__c = '78174:22',
                                                                                                ScCollection_Transaction_Type_Desc__c = 'Direct Debit Received');

        
        insert objPaymentTransaction;
        
        staging__Interface_Bank_Account__c objBankAccount = new staging__Interface_Bank_Account__c(
                                                                                Name = 'Wenran Lu',
                                                                                staging__Account_External_ID__c = '157657',
                                                                                staging__Active__c = true,
                                                                                staging__Bank_Name__c = 'ANZ',
                                                                                staging__Contact_External_ID__c = '157657',
                                                                                staging__Employee_Account__c = false,
                                                                                staging__Routing_Number__c = '012-084',
                                                                                staging__Source_Name__c = 'PAF',
                                                                                staging__Sync_Processed__c = true,
                                                                                ScCollection_Account_Name__c = 'Wenran Lu',
                                                                                ScCollection_BSB_Code__c = '012-084',
                                                                                ScCollection_Branch_Address__c = 'ANZ, Canberra Centre',
                                                                                ScCollection_Branch_Name__c = 'Canberra Centre');
        insert objBankAccount;
        
        staging__Interface_Contract__c objContract = new staging__Interface_Contract__c(
                                                                            Name = '15335',
                                                                            staging__ACH_On__c = false,
                                                                            staging__Days_Past_Due__c = 0.0,
                                                                            staging__Employee_Account__c = false,
                                                                            staging__External_ID__c = '5087',
                                                                            staging__Invalid_Data__c = false,
                                                                            staging__Last_Payment_Amount__c = 2661.49,
                                                                            staging__Loan_Status__c = 'Current',
                                                                            staging__Maturity_Date__c = Date.newInstance(2020,03,17),
                                                                            staging__Non_Accural__c = false,
                                                                            staging__Source_Name__c = 'PAF',
                                                                            staging__Sync_Processed__c = false,
                                                                            staging__TDR__c = false,
                                                                            ScCollection_Bucket__c = 0.0,
                                                                            ScCollection_Country_Code__c = 'AU',
                                                                            ScCollection_Current_Principal__c = 98253.13,
                                                                            ScCollection_Initial_Principal__c = 133312.25,
                                                                            ScCollection_Introducer__c = 'Credit One Equipment Finance',
                                                                            ScCollection_Lender_Record__c = 'NAB 2014-1',
                                                                            ScCollection_Loan_Status_Description__c = 'Misc Status',
                                                                            ScCollection_Loan_Sub_status_description__c = 'Current',
                                                                            ScCollection_Minimum_Monthly_Installment__c = 2661.49,
                                                                            ScCollection_Next_Installment_Date__c = Date.newInstance(2017,03,17),
                                                                            ScCollection_Product_ID__c = '23',
                                                                            ScCollection_Product__c = 'Commercial Loan & Mortgage CB v1',
                                                                            ScCollection_Repay_Frequency__c = 'M',
                                                                            ScCollection_Risk_Segment__c = 'A',
                                                                            ScCollection_Settled_Date__c = Date.newInstance(2015,03,17),
                                                                            ScCollection_Interest_Rate__c = 7.25,
                                                                            ScCollection_Account_Keeping_Fees__c = 6.0,
                                                                            ScCollection_All_Cash_Received__c = 61214.27,
                                                                            ScCollection_Aus_Post_No__c = '8444793000000000001533578',
                                                                            ScCollection_BPAY_Number__c = '100153352',
                                                                            ScCollection_CCI_rebate_ind__c = false,
                                                                            ScCollection_Contract_Receivable_Amount__c = 159329.4,
                                                                            ScCollection_Dues_till_now__c = 61214.27,
                                                                            ScCollection_FP_Group_ID__c = '4',
                                                                            ScCollection_FP_Group_Name__c = 'Chattel Mortgage',
                                                                            ScCollection_First_Payment_Due_Amount__c = 2655.49,
                                                                            ScCollection_First_Payment_Due_Date__c = Date.newInstance(2015,04,17),
                                                                            ScCollection_Instalment_Days_in_Arrear__c = 0.0,
                                                                            ScCollection_Overdue_Interest_Rate__c = 11.25,
                                                                            ScCollection_Payment_Description__c = 'Direct Debit',
                                                                            ScCollection_Rental_Amount__c = 2655.49,
                                                                            ScCollection_Rental_Mode_Type__c = 'ARR',
                                                                            ScCollection_Residual_Amount__c = 0.0,
                                                                            ScCollection_Structured_Rental_Ind__c = 'F',
                                                                            ScCollection_Write_off_Amount__c = 0.0,
                                                                            ScCollection_Loan_Term_Months__c = 60.0,
                                                                            ScCollection_Contract_End_Date__c = Date.newInstance(2020,03,17));

        insert objContract;
        
        Account objAccount = new Account();
        objAccount.Name = 'test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.LastName = 'testing';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        staging__Interface_Party__c objInterfaceParty = new staging__Interface_Party__c(
                                                                    Name = '5427:300',
                                                                    staging__Account_External_ID__c = '300',
                                                                    staging__Contact_External_ID__c = '300',
                                                                    staging__Contract_External_ID__c = '542',
                                                                    staging__External_ID__c = '5427:300',
                                                                    staging__Source_Name__c = 'PAF',
                                                                    staging__Sync_Processed__c = true,
                                                                    staging__Type__c = 'Guarantor',
                                                                    staging__isPrimary__c = false,
                                                                    ScCollection_Created_from_ESB__c = true);

        insert objInterfaceParty;
        
        Staging_Property__c objProperty = new Staging_Property__c(
                                                                        Name = '0083479',
                                                                        Source_Name__c = 'MORTGAGE',
                                                                        Title_Description__c = 'Torren',
                                                                        Valuation_Amount__c = 600000.0);
        insert objProperty;
        
        
        test.StartTest();
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestURI = '/SyncJobService';
            req.httpMethod = 'POST';
            
            // Test 1
            String jsonData = '{\"batchSize\":10}';
            req.requestBody = Blob.valueof(jsonData);
            RestContext.request = req;

            CLCollectionsWebServices.startBatch();
        
            CLCollectionsWebServices.CheckTodaysFiles();
            //CLCollectionsWebServices.CheckESBSalesforceRecordCountMismatch();
            List<String> lstEmail = new List<String>();
            lstEmail.add('sandip.bijlwan@gmail.com');
            List<String> lstPhone = new List<String>();
            lstPhone.add('0909090909');
            
            CLCollectionsWebServices.SendExceptionNotification(lstEmail,lstPhone,'test',true);
        test.StopTest();
    }
}
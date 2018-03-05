// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CreateLogController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestCreateLogController 
{
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          myUniTest
    Company:       Saasfocus
    Description:   This method is used to test functionality of interaction log creation.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    static testMethod void myUniTest() 
    {  
        //insert trigger setting
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        
        //insert queue
        collect__Queue__c objQueue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
        
        //Insert Queue User
        collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQueue.id, UserInfo.getUserId());
         
        //insert source system
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        //insert queue contract
        collect__Queue_Contract__c objqueuecontract = ScCollection_CommonTrackerClass.createTestQueueContract(objQueue.Id, objcontract.Id, UserInfo.getUserId());
        
        //insert action code
        collect__Action_Code__c objcode1 = ScCollection_CommonTrackerClass.createTestActionCode('INBOUND - PTP - One-off');
        collect__Action_Code__c objcode2 = ScCollection_CommonTrackerClass.createTestActionCode('Test Action');
        
        //insert action code config
        collect__Action_Code_Config__c objcodeconfig = ScCollection_CommonTrackerClass.createTestCodeConfig(objcode1.id,objsourcesystem.id);
        
        //insert status config
        collect__Status_Config__c objstatusconfig = ScCollection_CommonTrackerClass.createTestStatusConfig(objsourcesystem.id);
         
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        obj.getActionName();
        obj.isSubmit = false;
        obj.SubmitData();
        
        obj.strSelectedAction = objcode1.Id;
        obj.objLog.collect__Follow_Up_Date_Time__c = System.Now().addMinutes(-60);
        obj.objLog.collect__Description__c = 'Test comments';
        obj.isSubmit = false;
        obj.submitData();
        
        obj.objLog.collect__Follow_Up_Date_Time__c = System.Now().addDays(10);
        obj.isSubmit = false;
        obj.submitData();
        
        //insert status counter settings
        ScCollection_Status_Counter_Settings__c objstatussetting = ScCollection_CommonTrackerClass.createTestCustomSettings();
        obj.isSubmit = false;
        obj.submitData();
        
        //insert settings
        ScCollection_Settings__c objsetting = ScCollection_CommonTrackerClass.createTestSettings();
        obj.isSubmit = false;
        obj.submitData();
        
        obj.objLog.collect__Follow_Up_Date_Time__c = System.Now().addDays(2);
        obj.isSubmit = false;
        obj.submitData();
        
        //insert status counter settings
        ScCollection_Status_Counter_Settings__c objcustomsettings = ScCollection_CommonTrackerClass.createTestCustomSettings();
        objcustomsettings.ScCollection_Include__c = false;
        objcustomsettings.scCollection_Object_Api_Name__c = 'ScCollection_ContractSettings__c';
        objcustomsettings.ScCollection_Date_Field_Api_Name__c = 'NA';
        objcustomsettings.ScCollection_Counter_Field_Api_Name__c = 'ScCollection_NoAnswerCount__c';
        objcustomsettings.ScCollection_Values__c = 'INBOUND - PTP';
        objcustomsettings.Name = '1';
        update objcustomsettings;
        
        ScCollection_Status_Counter_Settings__c objcustomsettings1 = ScCollection_CommonTrackerClass.createTestCustomSettings();
        objcustomsettings1.ScCollection_Include__c = false;
        objcustomsettings1.scCollection_Object_Api_Name__c = 'collect__Contract_Status__c';
        objcustomsettings1.ScCollection_Date_Field_Api_Name__c = 'NA';
        objcustomsettings1.ScCollection_Counter_Field_Api_Name__c = 'scCollection_ArrearsDaysCount__c';
        objcustomsettings1.ScCollection_Values__c = 'INBOUND - PTP';
        objcustomsettings1.Name = '2';
        update objcustomsettings1;
        obj.isSubmit = false;
        obj.submitData();
        
        objcustomsettings.ScCollection_Date_Field_Api_Name__c = 'Zero';
        objcustomsettings1.ScCollection_Date_Field_Api_Name__c = 'Zero';
        update objcustomsettings;
        update objcustomsettings1;
        obj.isSubmit = false;
        obj.submitData();
        
        objcustomsettings1.ScCollection_Checkbox_Field_Api_Name__c = 'ScCollection_HardshipAllDocumentReceived__c';
        objcustomsettings1.ScCollection_Date_Field_Api_Name__c = 'true';
        update objcustomsettings1;
        obj.isSubmit = false;
        obj.submitData();
        
        objcustomsettings1.ScCollection_Date_Field_Api_Name__c = 'false';
        update objcustomsettings1;
        obj.isSubmit = false;
        obj.submitData();
        
        objcustomsettings.ScCollection_Date_Field_Api_Name__c = 'ScCollection_NoAnsCounterDate__c';
        objcustomsettings1.ScCollection_Date_Field_Api_Name__c = 'ScCollection_default_Notice_Issue_Date__c';
        update objcustomsettings;
        update objcustomsettings1;
        
        objcode1.ScCollection_Status_Field_Values__c = 'First Payment Default';
        update objcode1;
        
        obj.objLog.ScCollection_Reason_For_Default__c = 'Maternal';
        obj.editStatus = true;
        obj.isSubmit = false;
        obj.submitData();
        obj.changeAction();
        
        
        obj.changeStatus();
        
        collect__Contract_Status__c objStatusForAssert = [select Id,ScCollection_Reason_For_Default__c from collect__Contract_Status__c where Id In(Select collect__Collection_Status__c from collect__Loan_Account__c where Id = :objcontract.Id) Limit 1];
        system.assert(objStatusForAssert.ScCollection_Reason_For_Default__c == 'Maternal','woked');
        
       
    }
      
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          successMortgageInteractionLogTest
    Company:       Saasfocus
    Description:   This method is used to test Success response in mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest Static void successMortgageInteractionLogTest(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        update objtriggersetting;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='InteractionLogSyncMortgage';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='GetErrorLog';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        collect__Collection_Activity__c objactivity = ScCollection_CommonTrackerClass.createTestActivity(objcontract.id);
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.Id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        objlog.ScCollection_Requested_by__c = '1';
        objlog.ScCollection_Requested_Via__c ='1';
        objlog.ScCollection_Date_all_documents_received__c = System.today();
        insert objlog;
        
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        
        obj.objLog = objlog;
        
        test.StartTest();
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
            
            ScCollection_CreateLogController.SyncInteractionLog('ActionCode','comments','MORTGAGE','123_0',objLog.Id,objlog.ScCollection_Requested_by__c,objlog.ScCollection_Requested_Via__c,objlog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
            obj.SyncData();
        test.stopTest();
        collect__Interaction_Log__c objLogForAssert = [Select id,ScCollection_Synced__c,ScCollection_Error_Message_Exist__c,ScCollection_Error_Message__c
                                                        From collect__Interaction_Log__c where Id = :objlog.Id];
        system.assert(objLogForAssert.ScCollection_Synced__c == true,'woked');                                              
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ErrorWithHttpSuccessMortgageInteractionLogTest
    Company:       Saasfocus
    Description:   This method is used to test Error with success response in mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest Static void ErrorWithHttpSuccessMortgageInteractionLogTest(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        update objtriggersetting;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='InteractionLogSyncMortgage';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='GetErrorLog';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        collect__Collection_Activity__c objactivity = ScCollection_CommonTrackerClass.createTestActivity(objcontract.id);
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.Id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        objlog.ScCollection_Requested_by__c = '1';
        objlog.ScCollection_Requested_Via__c ='1';
        objlog.ScCollection_Date_all_documents_received__c = System.today();
        insert objlog;
        
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        
        obj.objLog = objlog;
        
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest1 = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "100","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest1);
            ScCollection_CreateLogController.SyncInteractionLog('ActionCode','comments','MORTGAGE','123_0',objLog.Id,objlog.ScCollection_Requested_by__c,objlog.ScCollection_Requested_Via__c,objlog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
            obj.SyncData();
        test.stopTest();
        collect__Interaction_Log__c objLogForAssert = [Select id,ScCollection_Synced__c,ScCollection_Error_Message_Exist__c,ScCollection_Error_Message__c
                                                        From collect__Interaction_Log__c where Id = :objlog.Id];
        system.assert(objLogForAssert.ScCollection_Error_Message_Exist__c == true,'woked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ErrorMortgageInteractionLogTest
    Company:       Saasfocus
    Description:   This method is used to test Error in mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest Static void ErrorMortgageInteractionLogTest(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        update objtriggersetting;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='InteractionLogSyncMortgage';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='GetErrorLog';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        collect__Collection_Activity__c objactivity = ScCollection_CommonTrackerClass.createTestActivity(objcontract.id);
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.Id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        objlog.ScCollection_Requested_by__c = '1';
        objlog.ScCollection_Requested_Via__c ='1';
        objlog.ScCollection_Date_all_documents_received__c = System.today();
        insert objlog;
        
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        
        obj.objLog = objlog;
        
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest1 = new ScCollection_CollectionContractMock (500,'complete','{"APIStatus": {"APICode": "500","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest1);
            ScCollection_CreateLogController.SyncInteractionLog('ActionCode','comments','MORTGAGE','123_0',objLog.Id,objlog.ScCollection_Requested_by__c,objlog.ScCollection_Requested_Via__c,objlog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
            obj.SyncData();
        test.stopTest();
        collect__Interaction_Log__c objLogForAssert = [Select id,ScCollection_Synced__c,ScCollection_Error_Message_Exist__c,ScCollection_Error_Message__c
                                                        From collect__Interaction_Log__c where Id = :objlog.Id];
        system.assert(objLogForAssert.ScCollection_Error_Message_Exist__c == true,'woked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          UnKnownErrorMortgageInteractionLogTest
    Company:       Saasfocus
    Description:   This method is used to test unknown response in mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest Static void UnKnownErrorMortgageInteractionLogTest(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        update objtriggersetting;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='InteractionLogSyncMortgage';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='GetErrorLog';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        collect__Collection_Activity__c objactivity = ScCollection_CommonTrackerClass.createTestActivity(objcontract.id);
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.Id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        objlog.ScCollection_Requested_by__c = '1';
        objlog.ScCollection_Requested_Via__c ='1';
        objlog.ScCollection_Date_all_documents_received__c = System.today();
        insert objlog;
        
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        
        obj.objLog = objlog;
        obj.SyncData();
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest1 = new ScCollection_CollectionContractMock (401,'complete','{"APIStatus": {"APICode": "401","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest1);
            ScCollection_CreateLogController.SyncInteractionLog('ActionCode','comments','MORTGAGE','123_0',objLog.Id,objlog.ScCollection_Requested_by__c,objlog.ScCollection_Requested_Via__c,objlog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
            obj.SyncData();
        test.stopTest();
        collect__Interaction_Log__c objLogForAssert = [Select id,ScCollection_Synced__c,ScCollection_Error_Message_Exist__c,ScCollection_Error_Message__c
                                                        From collect__Interaction_Log__c where Id = :objlog.Id];
        system.assert(objLogForAssert.ScCollection_Error_Message_Exist__c == true,'woked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ExceptionMortgageInteractionLogTest
    Company:       Saasfocus
    Description:   This method is used to test Exception in mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest Static void ExceptionMortgageInteractionLogTest(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        update objtriggersetting;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='InteractionLogSyncMortgage';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='GetErrorLog';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        collect__Collection_Activity__c objactivity = ScCollection_CommonTrackerClass.createTestActivity(objcontract.id);
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.Id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        objlog.ScCollection_Requested_by__c = '1';
        objlog.ScCollection_Requested_Via__c ='1';
        objlog.ScCollection_Date_all_documents_received__c = System.today();
        insert objlog;
        
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        
        obj.objLog = objlog;
        
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest1 = new ScCollection_CollectionContractMock (300,'complete','{"APIStatus": {"APICode": "401","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest1);
            ScCollection_CreateLogController.SyncInteractionLog('ActionCode','comments','MORTGAGE','123_0',objLog.Id,objlog.ScCollection_Requested_by__c,objlog.ScCollection_Requested_Via__c,objlog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
            obj.SyncData();
        test.stopTest();
        collect__Interaction_Log__c objLogForAssert = [Select id,ScCollection_Synced__c,ScCollection_Error_Message_Exist__c,ScCollection_Error_Message__c
                                                        From collect__Interaction_Log__c where Id = :objlog.Id];
        system.assert(objLogForAssert.ScCollection_Error_Message_Exist__c == true,'woked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SuccessPAFInteractionLogTest
    Company:       Saasfocus
    Description:   This method is used to test Success in PAF integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest Static void SuccessPAFInteractionLogTest(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        update objtriggersetting;
        
        ScCollection_PaymentAPIParameters__c objcred3 = new ScCollection_PaymentAPIParameters__c();
        objcred3.Name='InteractionLogSyncPAF';
        objcred3.Endpoint__c='www.google.com';
        objcred3.Username__c='sandip';
        objcred3.Password__c='sandip';
        objcred3.ScCollection_CMS_User_Id__c ='0';
        objcred3.ScCollection_CMS_Auth_Key__c ='1';
        insert objcred3;
        
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        collect__Collection_Activity__c objactivity = ScCollection_CommonTrackerClass.createTestActivity(objcontract.id);
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.Id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        objlog.ScCollection_Requested_by__c = '1';
        objlog.ScCollection_Requested_Via__c ='1';
        objlog.ScCollection_Date_all_documents_received__c = System.today();
        insert objlog;
        
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        
        obj.objLog = objlog;
        test.StartTest();
            ScCollection_CollectionContractMock  successMortgageTest1 = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "401","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest1);
            ScCollection_CreateLogController.SyncInteractionLog('ActionCode','comments','PAF','123',objLog.Id,objlog.ScCollection_Requested_by__c,objlog.ScCollection_Requested_Via__c,objlog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
            obj.SyncData();
        test.stopTest();
        collect__Interaction_Log__c objLogForAssert = [Select id,ScCollection_Synced__c,ScCollection_Error_Message_Exist__c,ScCollection_Error_Message__c
                                                        From collect__Interaction_Log__c where Id = :objlog.Id];
        system.assert(objLogForAssert.ScCollection_Synced__c == true,'woked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ErrorPAFInteractionLogTest
    Company:       Saasfocus
    Description:   This method is used to test Error in PAF integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest Static void ErrorPAFInteractionLogTest(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        update objtriggersetting;
        
        ScCollection_PaymentAPIParameters__c objcred3 = new ScCollection_PaymentAPIParameters__c();
        objcred3.Name='InteractionLogSyncPAF';
        objcred3.Endpoint__c='www.google.com';
        objcred3.Username__c='sandip';
        objcred3.Password__c='sandip';
        objcred3.ScCollection_CMS_User_Id__c ='0';
        objcred3.ScCollection_CMS_Auth_Key__c ='1';
        insert objcred3;
        
        collect__Source_System__c objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //insert contract
        collect__Loan_Account__c objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        collect__Collection_Activity__c objactivity = ScCollection_CommonTrackerClass.createTestActivity(objcontract.id);
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objcontract.Id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        objlog.ScCollection_Requested_by__c = '1';
        objlog.ScCollection_Requested_Via__c ='1';
        objlog.ScCollection_Date_all_documents_received__c = System.today();
        insert objlog;
        
        ApexPages.currentPage().getParameters().put('Id', objcontract.id);
        ScCollection_CreateLogController obj = new ScCollection_CreateLogController();
        
        obj.objLog = objlog;
        test.StartTest();
            ScCollection_CollectionContractMock  successMortgageTest1 = new ScCollection_CollectionContractMock (300,'complete','{"APIStatus": {"APICode": "401","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest1);
            ScCollection_CreateLogController.SyncInteractionLog('ActionCode','comments','PAF','123',objLog.Id,objlog.ScCollection_Requested_by__c,objlog.ScCollection_Requested_Via__c,objlog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
            obj.SyncData();
        test.stopTest();
        collect__Interaction_Log__c objLogForAssert = [Select id,ScCollection_Synced__c,ScCollection_Error_Message_Exist__c,ScCollection_Error_Message__c
                                                        From collect__Interaction_Log__c where Id = :objlog.Id];
        system.assert(objLogForAssert.ScCollection_Error_Message_Exist__c == true,'woked');
    }
    
}
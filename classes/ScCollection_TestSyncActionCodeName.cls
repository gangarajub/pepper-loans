@isTest(SeeAllData =False) public Class ScCollection_TestSyncActionCodeName{

    /*------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SuccessActionCode
    Company:       Saasfocus
    Description:   This method is used to test Success in action code integration.
    Inputs:        no input
    Returns:       void
    ------------------------------------------------------------*/
    @isTest Static void SuccessActionCode(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = new ScCollection_TriggerExecutionSettings__c();
        objtriggersetting.Name='All Trigger Execution';
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        insert objtriggersetting;
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
                                                    
        insert objActioncode ;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='ActivitySyncCode';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        
        test.startTest();
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
            
            ScCollection_SyncActionCodeName.SyncActionCodeNameToJackson(objActioncode.Name,objActioncode.ScCollection_Action_Code_Old_Value__c,objActioncode.Id);
        test.stopTest();
        collect__Action_Code__c objActionForAssert = [Select id,ScCollection_Error_Message__c 
                                                        From collect__Action_Code__c where Id = :objActioncode.Id];
        system.assert(objActionForAssert.ScCollection_Error_Message__c  == null,'worked');
    }
    
    /*------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SuccessWithErrorApiCodeActionCode
    Company:       Saasfocus
    Description:   This method is used to test Success with error api code in action code integration.
    Inputs:        no input
    Returns:       void
    ------------------------------------------------------------*/
    @isTest Static void SuccessWithErrorApiCodeActionCode(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = new ScCollection_TriggerExecutionSettings__c();
        objtriggersetting.Name='All Trigger Execution';
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        insert objtriggersetting;
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
                                                    
        insert objActioncode ;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='ActivitySyncCode';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        
        test.startTest();
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "100","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "ERROR."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
            
            ScCollection_SyncActionCodeName.SyncActionCodeNameToJackson(objActioncode.Name,objActioncode.ScCollection_Action_Code_Old_Value__c,objActioncode.Id);
        test.stopTest();
        collect__Action_Code__c objActionForAssert = [Select id,ScCollection_Error_Message__c 
                                                        From collect__Action_Code__c where Id = :objActioncode.Id];
        system.assert(objActionForAssert.ScCollection_Error_Message__c  == 'ERROR.','worked');
    }
    
    /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          ErrorActionCode
        Company:       Saasfocus
        Description:   This method is used to test Error in action code integration.
        Inputs:        no input
        Returns:       void
        ------------------------------------------------------------*/
    @isTest Static void ErrorActionCode(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = new ScCollection_TriggerExecutionSettings__c();
        objtriggersetting.Name='All Trigger Execution';
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        insert objtriggersetting;
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
                                                    
        insert objActioncode ;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='ActivitySyncCode';
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
        
        
        test.startTest();
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (500,'complete','{"APIStatus": {"APICode": "500","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
            
            ScCollection_SyncActionCodeName.SyncActionCodeNameToJackson(objActioncode.Name,objActioncode.ScCollection_Action_Code_Old_Value__c,objActioncode.Id);
        test.stopTest();
        collect__Action_Code__c objActionForAssert = [Select id,ScCollection_Error_Message__c 
                                                        From collect__Action_Code__c where Id = :objActioncode.Id];
        system.assert(objActionForAssert.ScCollection_Error_Message__c  != null,'worked');
    }
    
    /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          HttpFaliureActionCode
        Company:       Saasfocus
        Description:   This method is used to test faliure http in action code integration.
        Inputs:        no input
        Returns:       void
        ------------------------------------------------------------*/
    @isTest Static void HttpFaliureActionCode(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = new ScCollection_TriggerExecutionSettings__c();
        objtriggersetting.Name='All Trigger Execution';
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        insert objtriggersetting;
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
                                                    
        insert objActioncode ;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='ActivitySyncCode';
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
        
        
        test.startTest();
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (401,'complete','{"APIStatus": {"APICode": "401","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
            
            ScCollection_SyncActionCodeName.SyncActionCodeNameToJackson(objActioncode.Name,objActioncode.ScCollection_Action_Code_Old_Value__c,objActioncode.Id);
        test.stopTest();
        collect__Action_Code__c objActionForAssert = [Select id,ScCollection_Error_Message__c 
                                                        From collect__Action_Code__c where Id = :objActioncode.Id];
        system.assert(objActionForAssert.ScCollection_Error_Message__c  != null,'worked');
    }
    
    /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          UnKnownActionCode
        Company:       Saasfocus
        Description:   This method is used to test un known response in action code integration.
        Inputs:        no input
        Returns:       void
        ------------------------------------------------------------*/
    @isTest Static void UnKnownActionCode(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = new ScCollection_TriggerExecutionSettings__c();
        objtriggersetting.Name='All Trigger Execution';
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        insert objtriggersetting;
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
                                                    
        insert objActioncode ;
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='ActivitySyncCode';
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
        
        
        test.startTest();
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (100,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "ERROR."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
            
            ScCollection_SyncActionCodeName.SyncActionCodeNameToJackson(objActioncode.Name,objActioncode.ScCollection_Action_Code_Old_Value__c,objActioncode.Id);
        test.stopTest();
        collect__Action_Code__c objActionForAssert = [Select id,ScCollection_Error_Message__c 
                                                        From collect__Action_Code__c where Id = :objActioncode.Id];
        system.assert(objActionForAssert.ScCollection_Error_Message__c  == 'ERROR.','worked');
    }
    
    /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          ExceptionActionCode
        Company:       Saasfocus
        Description:   This method is used to test Exception in action code integration.
        Inputs:        no input
        Returns:       void
        ------------------------------------------------------------*/
    @isTest Static void ExceptionActionCode(){
        ScCollection_TriggerExecutionSettings__c objtriggersetting = new ScCollection_TriggerExecutionSettings__c();
        objtriggersetting.Name='All Trigger Execution';
        objtriggersetting.ScCollection_SyncActionCodeName__c = true;
        objtriggersetting.ScCollection_Sync_Interaction_Log__c = true;
        insert objtriggersetting;
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1');
                                                    
        insert objActioncode ;
        
        test.startTest();
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (100,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
            
            ScCollection_SyncActionCodeName.SyncActionCodeNameToJackson(objActioncode.Name,objActioncode.ScCollection_Action_Code_Old_Value__c,objActioncode.Id);
        test.stopTest();
        collect__Action_Code__c objActionForAssert = [Select id,ScCollection_Error_Message__c 
                                                        From collect__Action_Code__c where Id = :objActioncode.Id];
        system.assert(objActionForAssert.ScCollection_Error_Message__c  != null,'worked');
    }
}
// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ViewStatusClController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 22-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestViewStatusClController
{ 
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static collect__Status_Config__c objstatusconfig;
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          myUnittest
    Company:       Saasfocus
    Description:   This method is used to test working of status cl page for PL and CL contract.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static testMethod void myUnittest()
    {  test.startTest();
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
         
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objContract;
        
        //insert status config
        objstatusconfig = ScCollection_CommonTrackerClass.createTestStatusConfig(objSourceSystem.Id);
          
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        objViewStatusClController.strSourceSystem = 'MORTGAGE';
        ScCollection_ViewStatusClController.wrapperForStatusFields ObjWrapperCls = new ScCollection_ViewStatusClController.wrapperForStatusFields();
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Dis Pending';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Discharged';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
         test.stopTest();
        
        collect__Contract_Status__c objstatusForAssert = [Select Id,ScCollection_Misc_Status__c From collect__Contract_Status__c where Id In  (Select collect__Collection_Status__c from collect__Loan_Account__c Where Id = :objContract.ID)];
        System.Assert(objstatusForAssert.ScCollection_Misc_Status__c == 'Discharged','worked');
        
    }
   
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          myUnittest1
    Company:       Saasfocus
    Description:   This method is used to test working of status cl page for PL and CL contract.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    public static testMethod void myUnittest1()
    { test.startTest();
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
         
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.ScCollection_Loan_Status_Description__c = 'Arrears';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Overdue';
        update objContract;
        
        //insert status config
        objstatusconfig = ScCollection_CommonTrackerClass.createTestStatusConfig(objSourceSystem.Id);
          
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        objViewStatusClController.strSourceSystem = 'PAF';
        ScCollection_ViewStatusClController.wrapperForStatusFields ObjWrapperCls = new ScCollection_ViewStatusClController.wrapperForStatusFields();
        objViewStatusClController.lookforRelateEntities();
      
        objContract.ScCollection_Loan_Sub_status_description__c = 'Default-Collection Officer';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Status_Description__c = 'Remarketing';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Default-External Agent';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
     test.stopTest();   
        objContract.ScCollection_Loan_Sub_status_description__c = 'Repossessed';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Redemption Expired';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Early Payout-Sale of Asset';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Current';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Closed - Early Payout';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Closed - Maturity';
        update objContract;
        objViewStatusClController.lookforRelateEntities();
        
        collect__Contract_Status__c objstatusForAssert = [Select Id,ScCollection_Misc_Status__c From collect__Contract_Status__c where Id In  (Select collect__Collection_Status__c from collect__Loan_Account__c Where Id = :objContract.ID)];
        System.Assert(objstatusForAssert.ScCollection_Misc_Status__c == 'Closed - Maturity','worked');
    }
     
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          myUnittest2
    Company:       Saasfocus
    Description:   This method is used to test working of status cl page for PL and CL contract.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    public static testMethod void myUnittest2()
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
         
        //Insert Object of Contract
        collect__Loan_Account__c objcontract1 = new collect__Loan_Account__c();
        objcontract1.Name = 'Contract-001';
        objcontract1.collect__Source_System__c = objSourceSystem.Id;
        objcontract1.collect__Delinquent_Amount__c = 8000;
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
        objCCM1.Name = 'Monthly:' + objcontract1.Name;
        objCCM1.collect__Dev_Contract__c = objcontract1.Id;
        objCCM1.collect__Contact_Count__c = 2;
        objCCM1.collect__Threshold_Days__c = 20;
       
        lstCCM.add(objCCM1);
        
        collect__Contract_Collections_Metrics__c objCCM2 = new collect__Contract_Collections_Metrics__c();
        objCCM2.Name = 'Weekly:' + objcontract1.Name;
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
        
        Profile p = [select Id from Profile where Name = 'System Administrator']; 
        User u = new User(Alias='standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testadmin@pepper.com');
        
        System.runAs(u) 
        {
            objcontract1.collect__Collection_Status__c = Null;
            update objcontract1;
        }
        
        //insert status config
        objstatusconfig = ScCollection_CommonTrackerClass.createTestStatusConfig(objSourceSystem.Id);
          
        ApexPages.StandardController controller = new ApexPages.StandardController(objcontract1);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        objViewStatusClController.lookforRelateEntities();
        
        
        collect__Contract_Status__c objStatus = new collect__Contract_Status__c ();
        objStatus.ScCollection_Management_Notes__c ='abc';
        insert objStatus ;
        //collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        collect__Loan_Account__c objContract11 = new collect__Loan_Account__c();
        objContract11.Name = 'Contract-001';
        objContract11.collect__Source_System__c = objSourceSystem.id ;
        objContract11.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract11.collect__Delinquent_Amount__c = 80;
        objContract11.collect__Account__c = objAccount.id;
        objContract11.ScCollection_Loan_Status_Description__c = 'Arrears';
        objContract11.ScCollection_Loan_Sub_status_description__c = 'Overdue';
        objContract11.ScCollection_Bucket__c = 0;
        objContract11.ScCollection_Management_Notes__c ='hahah';
        objContract11.collect__Collection_Status__c = objStatus.id;
        objContract11.ScCollection_API_log__c ='1';
        insert objContract11;
        
        
        collect__Loan_Account__c objCont = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objContract11.Id];
        
        objViewStatusClController.objContract = objCont;
        objViewStatusClController.objStatus = objStatus ;
        test.startTest();
        
        test.stopTest();
        collect__Contract_Status__c objstatusForAssert = [Select Id,ScCollection_Misc_Status__c From collect__Contract_Status__c where Id In  (Select collect__Collection_Status__c from collect__Loan_Account__c Where Id = :objCont.Id)];
        System.Assert(objstatusForAssert.ScCollection_Misc_Status__c == null,'worked');
     }
     /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SuccessMortgageNotes
    Company:       Saasfocus
    Description:   This method is used to test Success in Mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void SuccessMortgageNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='MortgageManagementNotes';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            objViewStatusClController.SyncManagementNotes('a<>aa','MORTGAGE',objContract.Name,objContract.Id,null);
            String abc = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<>aaaaaa';
            
            objViewStatusClController.SyncManagementNotes(abc,'MORTGAGE',objContract.Name,objContract.Id,null);
            
            abc += 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<>aaaaaaaaaaaaaaaa';
            objViewStatusClController.SyncManagementNotes(abc,'MORTGAGE',objContract.Name,objContract.Id,null);
            
            abc += 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<>aaaaaaaaaaaaaaaa';
            objViewStatusClController.SyncManagementNotes(abc,'MORTGAGE',objContract.Name,objContract.Id,null);
            
        test.stopTest(); 
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_Error_Message__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_Error_Occurred__c  == false,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SuccessWithErrorAPICodeMortgageNotes
    Company:       Saasfocus
    Description:   This method is used to test Success with different api code in Mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void SuccessWithErrorAPICodeMortgageNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ScCollection_PaymentAPIParameters__c objcred = new ScCollection_PaymentAPIParameters__c();
        objcred.Name='ErrorLogManagmentNotes';
        objcred.Endpoint__c='www.google.com';
        objcred.Username__c='sandip';
        objcred.Password__c='sandip';
        insert objcred;
        
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='MortgageManagementNotes';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "100","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            objViewStatusClController.SyncManagementNotes('a<>aa','MORTGAGE',objContract.Name,objContract.Id,null);
            String abc = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<>aaaaaa';
             
        test.stopTest();    
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_Error_Message__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_Error_Occurred__c  == true,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ErrorMortgageNotes
    Company:       Saasfocus
    Description:   This method is used to test Error in Mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void ErrorMortgageNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='MortgageManagementNotes';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (500,'complete','{"APIStatus": {"APICode": "500","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            objViewStatusClController.SyncManagementNotes('a<>aa','MORTGAGE',objContract.Name,objContract.Id,null);
            String abc = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<>aaaaaa';
             
        test.stopTest();   
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_Error_Message__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_Error_Occurred__c  == true,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          UnKnownErrorMortgageNotes
    Company:       Saasfocus
    Description:   This method is used to test unknowne response in Mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void UnKnownErrorMortgageNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='MortgageManagementNotes';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (401,'complete','{"APIStatus": {"APICode": "401","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            objViewStatusClController.SyncManagementNotes('a<>aa','MORTGAGE',objContract.Name,objContract.Id,null);
            String abc = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<>aaaaaa';
             
        test.stopTest();    
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_Error_Message__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_Error_Occurred__c  == true,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ExceptionMortgageNotes
    Company:       Saasfocus
    Description:   This method is used to test Exception in Mortgage integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void ExceptionMortgageNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='MortgageManagementNotes';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (300,'complete','{"APIStatus": {"APICode": "300","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "1"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "ERROR","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            objViewStatusClController.SyncManagementNotes('a<>aa','MORTGAGE',objContract.Name,objContract.Id,null);
            String abc = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<>aaaaaa';
             
        test.stopTest();   
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_Error_Message__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_Error_Occurred__c  == true,'worked');      
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SuccessPAFNotes
    Company:       Saasfocus
    Description:   This method is used to test Success in PAF integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void SuccessPAFNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='PAFManagementNotes';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            ScCollection_ViewStatusClController.SyncPAFManagementNotes('testNotes','12345',objContract.Id);
            
        test.stopTest();    
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_Error_Message__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_Error_Occurred__c  == false,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ErrorPAFNotes
    Company:       Saasfocus
    Description:   This method is used to test Error in PAF integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void ErrorPAFNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ScCollection_PaymentAPIParameters__c objcred1 = new ScCollection_PaymentAPIParameters__c();
        objcred1.Name='PAFManagementNotes';
        objcred1.Endpoint__c='www.google.com';
        objcred1.Username__c='sandip';
        objcred1.Password__c='sandip';
        insert objcred1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (400,'complete','{"APIStatus": {"APICode": "400","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            ScCollection_ViewStatusClController.SyncPAFManagementNotes('testNotes','12345',objContract.Id);
            
        test.stopTest();   
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_Error_Message__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_Error_Occurred__c  == true,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ExceptionPAFNotes
    Company:       Saasfocus
    Description:   This method is used to test exception in integration.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest static  void ExceptionPAFNotes(){
        
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objCont = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objCont.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objCont.ScCollection_Loan_Sub_status_description__c = 'Settled';
        update objCont;
        
        collect__Loan_Account__c objContract = [Select Id,Name,collect__Source_System__c,ScCollection_Next_Installment_Date__c,collect__Delinquent_Amount__c,collect__Account__c,ScCollection_Loan_Status_Description__c,ScCollection_Loan_Sub_status_description__c,ScCollection_Bucket__c,ScCollection_Management_Notes__c,collect__Collection_Status__c,ScCollection_Source_System_Name__c,ScCollection_API_log__c from collect__Loan_Account__c where id = :objCont.Id];
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objContract);
        
        ScCollection_ViewStatusClController objViewStatusClController = new ScCollection_ViewStatusClController(controller);
        test.StartTest();
            
            ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (400,'complete','{"APIStatus": {"APICode": "400","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            
            Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
            ScCollection_ViewStatusClController.SyncPAFManagementNotes('testNotes','12345',objContract.Id);
            
        test.stopTest();  
        collect__Loan_Account__c objActionForAssert = [Select id,ScCollection_Error_Occurred__c,ScCollection_API_Call_Not_Process__c 
                                                        From collect__Loan_Account__c where Id = :objContract.Id];
        system.assert(objActionForAssert.ScCollection_API_Call_Not_Process__c  == true,'worked');
    }
}
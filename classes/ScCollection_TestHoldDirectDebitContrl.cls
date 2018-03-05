/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_TestHoldDirectDebitContrl 
Company:       Saasfocus
Description:   This class is use to test ScCollection_HoldDirectDebitController class.
History
Date    :  31/01/2018     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
public Class ScCollection_TestHoldDirectDebitContrl{
    
    public static collect__Source_System__c objSS;
    public static collect__Loan_Account__c objLoanAccount;
    public static collect__Contract_Status__c objStatus;
    public static ScCollection_PaymentAPIParameters__c objCredential;
    public static ScCollection_TriggerExecutionSettings__c objTrigExec;
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          actionFuncTest
    Company:       Saasfocus
    Description:   This method is used to test Action function test.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void actionFuncTest(){
        
        createDate();
        test.starttest();
        ApexPages.currentPage().getParameters().put('unhold','1');
        ApexPages.currentPage().getParameters().put('conId',objLoanAccount.Id);
        ApexPages.currentPage().getParameters().put('tabid','1');
        ApexPages.currentPage().getParameters().put('refresh','1');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objStatus);
        ScCollection_HoldDirectDebitController objController = new ScCollection_HoldDirectDebitController(sc);
        objController.actionFunc();
        ApexPages.currentPage().getParameters().put('unhold',null);
        ScCollection_HoldDirectDebitController objController1 = new ScCollection_HoldDirectDebitController(sc);
        test.stoptest();
        
        system.assertEquals(objController.strUnhold,'1','done');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          UnholdDataTest
    Company:       Saasfocus
    Description:   This method is used to test unhold payment.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void UnholdDataTest(){
        createDate();
        
        test.starttest();
        objStatus.ScCollection_Promise_Hold_From__c = system.today();
        objStatus.ScCollection_Promise_Hold_To__c = system.today() +1;
        update objStatus;
        
        ApexPages.currentPage().getParameters().put('unhold','1');
        ApexPages.currentPage().getParameters().put('conId',objLoanAccount.Id);
        ApexPages.currentPage().getParameters().put('tabid','1');
        ApexPages.currentPage().getParameters().put('refresh','1');
        ApexPages.StandardController sc = new ApexPages.StandardController(objStatus);
        ScCollection_HoldDirectDebitController objController = new ScCollection_HoldDirectDebitController(sc);
        objController.actionFunc();
        objController.UnholdData();
        
        ApexPages.currentPage().getParameters().put('unhold','1');
        ApexPages.currentPage().getParameters().put('conId',objLoanAccount.Id);
        ApexPages.currentPage().getParameters().put('tabid','1');
        ApexPages.currentPage().getParameters().put('refresh','1');
        objSS.Name = 'Mortgage';
        update objSS;
        ScCollection_HoldDirectDebitController objController1 = new ScCollection_HoldDirectDebitController(sc);
        objController1.actionFunc();
        objController1.UnholdData();
        test.stoptest();
        system.assertEquals(objController.objStatus.ScCollection_Promise_Hold_From__c,null,'unhold');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          submitData504ResponseTest
    Company:       Saasfocus
    Description:   This method is used to test error 504 hold call.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void submitData504ResponseTest(){
        createDate();
        
        objStatus.ScCollection_Promise_Hold_From__c = system.today();
        objStatus.ScCollection_Promise_Hold_To__c = system.today() +1;
        
        ApexPages.currentPage().getParameters().put('unhold','1');
        ApexPages.currentPage().getParameters().put('conId',objLoanAccount.Id);
        ApexPages.currentPage().getParameters().put('tabid','1');
        ApexPages.currentPage().getParameters().put('refresh','1');
        ApexPages.StandardController sc = new ApexPages.StandardController(objStatus);
        ScCollection_HoldDirectDebitController objController = new ScCollection_HoldDirectDebitController(sc);
        objController.actionFunc();
        test.starttest();
        
        ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (504,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
        Test.setMock(HttpcalloutMock.class,successMortgageTest);
        objController.SubmitData();
        test.stoptest();
        collect__Contract_Status__c objResponseStatus = [Select Id,ScCollection_Promise_Hold_From__c From collect__Contract_Status__c where Id=:objStatus.Id];
        system.assertEquals(objResponseStatus.ScCollection_Promise_Hold_From__c,Null,'Error 504');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          submitData404ResponseTest
    Company:       Saasfocus
    Description:   This method is used to test error 404 hold call.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void submitData404ResponseTest(){
        createDate();
        
        objStatus.ScCollection_Promise_Hold_From__c = system.today();
        objStatus.ScCollection_Promise_Hold_To__c = system.today() +1;
        //update objStatus;
        
        ApexPages.currentPage().getParameters().put('unhold','1');
        ApexPages.currentPage().getParameters().put('conId',objLoanAccount.Id);
        ApexPages.currentPage().getParameters().put('tabid','1');
        ApexPages.currentPage().getParameters().put('refresh','1');
        ApexPages.StandardController sc = new ApexPages.StandardController(objStatus);
        ScCollection_HoldDirectDebitController objController = new ScCollection_HoldDirectDebitController(sc);
        objController.actionFunc();
        test.starttest();
        
        ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (404,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
        Test.setMock(HttpcalloutMock.class,successMortgageTest);
        objController.SubmitData();
        test.stoptest();
        collect__Contract_Status__c objResponseStatus = [Select Id,ScCollection_Promise_Hold_From__c From collect__Contract_Status__c where Id=:objStatus.Id];
        system.assertEquals(objResponseStatus.ScCollection_Promise_Hold_From__c,Null,'Error 404');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          submitData400ResponseTest
    Company:       Saasfocus
    Description:   This method is used to test error 400 hold call.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void submitData400ResponseTest(){
        createDate();
        
        objStatus.ScCollection_Promise_Hold_From__c = system.today();
        objStatus.ScCollection_Promise_Hold_To__c = system.today() +1;
        
        ApexPages.currentPage().getParameters().put('unhold','1');
        ApexPages.currentPage().getParameters().put('conId',objLoanAccount.Id);
        ApexPages.currentPage().getParameters().put('tabid','1');
        ApexPages.currentPage().getParameters().put('refresh','1');
        ApexPages.StandardController sc = new ApexPages.StandardController(objStatus);
        ScCollection_HoldDirectDebitController objController = new ScCollection_HoldDirectDebitController(sc);
        objController.actionFunc();
        test.starttest();
        
        ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (400,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
        Test.setMock(HttpcalloutMock.class,successMortgageTest);
        objController.SubmitData();
        test.stoptest();
        collect__Contract_Status__c objResponseStatus = [Select Id,ScCollection_Promise_Hold_From__c From collect__Contract_Status__c where Id=:objStatus.Id];
        system.assertEquals(objResponseStatus.ScCollection_Promise_Hold_From__c,Null,'Error 400');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          submitData200ResponseTest
    Company:       Saasfocus
    Description:   This method is used to test success hold call.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void submitData200ResponseTest(){
        createDate();
        
        objStatus.ScCollection_Promise_Hold_From__c = system.today();
        objStatus.ScCollection_Promise_Hold_To__c = system.today() +1;
        
        ApexPages.currentPage().getParameters().put('unhold','1');
        ApexPages.currentPage().getParameters().put('conId',objLoanAccount.Id);
        ApexPages.currentPage().getParameters().put('tabid','1');
        ApexPages.currentPage().getParameters().put('refresh','1');
        ApexPages.StandardController sc = new ApexPages.StandardController(objStatus);
        ScCollection_HoldDirectDebitController objController = new ScCollection_HoldDirectDebitController(sc);
        objController.actionFunc();
        test.starttest();
        
        ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
        Test.setMock(HttpcalloutMock.class,successMortgageTest);
        objController.SubmitData();
        test.stoptest();
        collect__Contract_Status__c objResponseStatus = [Select Id,ScCollection_Promise_Hold_From__c From collect__Contract_Status__c where Id=:objStatus.Id];
        system.assertEquals(objResponseStatus.ScCollection_Promise_Hold_From__c,system.today(),'Success');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createDate
    Company:       Saasfocus
    Description:   This method is used to create data
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static void createDate(){
        objSS = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        objLoanAccount = ScCollection_CommonTrackerClass.createTestContract(objSS.Id);
        
        objStatus = new collect__Contract_Status__c();
        objStatus.ScCollection_Promise_Hold_From__c = null;
        objStatus.ScCollection_Promise_Hold_To__c = null;
        insert objStatus;
        
        objTrigExec = new ScCollection_TriggerExecutionSettings__c();
        objTrigExec.Name = 'All Trigger Execution';
        objTrigExec.ScCollection_Hold_Direct_Debit__c = true;
        insert objTrigExec;
        
        objCredential = new ScCollection_PaymentAPIParameters__c();
        objCredential.Name='HoldDirectDebitPAF';
        objCredential.Username__c = 'testuser';
        objCredential.Password__c = 'testpassword';
        objCredential.Endpoint__c = 'www.google.com';
        insert objCredential;
    }
}
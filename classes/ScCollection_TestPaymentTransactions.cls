// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_PaymentTransactions class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestPaymentTransactions
{
    static testMethod void myUnitTest() 
    {  
        ScCollection_TestPaymentTransactionsMock resMock = new ScCollection_TestPaymentTransactionsMock(200);
        Test.setMock(HttpCalloutMock.class, resMock);
        
        ScCollection_PaymentTransactionsInput inputApi = new ScCollection_PaymentTransactionsInput();
        inputApi.countryCode = 'AU';
        inputApi.loanNumber = 1231;
        inputApi.loanAccountNumber =2;
        inputApi.transactionStartDate = '20161001';
        inputApi.transactionEndDate = '20161005';
        inputApi.recordCount = 100;
        inputApi.recordPosition = 0;
        inputApi.lob = 'mortgage';
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Loan_Account__c objLoanAcc = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        ApexPages.currentPage().getParameters().put('id',objLoanAcc.Id);
        Account acc = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.WhatID = acc.id;
        t.Subject='none';
        t.Status='Not Started';
        t.Priority='Normal';
        t.ActivityDate = System.Today()-1;
        insert t;
        
        Task t1 = new Task();
        t1.OwnerId = UserInfo.getUserId();
        t1.WhatID = acc.id;
        t1.Subject='none';
        t1.Status='Not Started';
        t1.Priority='Normal';
        t1.ActivityDate = System.Today()+1;
        insert t1;
        
        ScCollection_PaymentAPIParameters__c objCust = new ScCollection_PaymentAPIParameters__c();
        objCust.name = 'ScCollection_PaymentAPIParameters';
        objCust.Endpoint__c = 'https://collections-sandbox.au.cloudhub.io/transactions';
        objCust.Password__c = 'P3pp3rPa55';
        objCust.Username__c = 'pepper';
        insert objCust;
        
        test.startTest();
        ScCollection_PaymentTransactions objPaymentTransaction = new ScCollection_PaymentTransactions();
        
        objPaymentTransaction.startTask = t;
        objPaymentTransaction.endTask = t1;
        objPaymentTransaction.inputApi = inputApi;
        objPaymentTransaction.fetchTransactions();
        objPaymentTransaction.OpenPdf();
        inputApi.lob = 'paf';
        objPaymentTransaction.inputApi = inputApi;
        objPaymentTransaction.fetchTransactions();
        
        objLoanAcc.Name = '1231_2';
        update objLoanAcc ;
        objPaymentTransaction.fetchTransactions();
        test.stopTest();
    }
    
    @istest static void test1(){
        
        ScCollection_TestPaymentTransactionsMock resMock = new ScCollection_TestPaymentTransactionsMock(400);
        Test.setMock(HttpCalloutMock.class, resMock);
        
        Account acc = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.WhatID = acc.id;
        t.Subject='none';
        t.Status='Not Started';
        t.Priority='Normal';
        t.ActivityDate = System.Today()-1;
        insert t;
        
        Task t1 = new Task();
        t1.OwnerId = UserInfo.getUserId();
        t1.WhatID = acc.id;
        t1.Subject='none';
        t1.Status='Not Started';
        t1.Priority='Normal';
        t1.ActivityDate = System.Today();
        insert t1;
        
        ScCollection_PaymentAPIParameters__c objCust = new ScCollection_PaymentAPIParameters__c();
        objCust.name = 'ScCollection_PaymentAPIParameters';
        objCust.Endpoint__c = 'https://collections-sandbox.au.cloudhub.io/transactions';
        objCust.Password__c = 'P3pp3rPa55';
        objCust.Username__c = 'pepper';
        insert objCust;
        
        test.startTest();
        ScCollection_PaymentTransactions objPaymentTransaction = new ScCollection_PaymentTransactions();
        objPaymentTransaction.startTask = t;
        objPaymentTransaction.endTask = t1;
        objPaymentTransaction.fetchTransactions();
        test.stopTest();
    }
    
    static testMethod void Test2() 
    {  
        ScCollection_TestPaymentTransactionsMock resMock = new ScCollection_TestPaymentTransactionsMock(200);
        Test.setMock(HttpCalloutMock.class, resMock);
        
        ScCollection_PaymentTransactionsInput inputApi = new ScCollection_PaymentTransactionsInput();
        inputApi.countryCode = 'AU';
        inputApi.loanNumber = 1231;
        inputApi.loanAccountNumber =2;
        inputApi.transactionStartDate = '20161001';
        inputApi.transactionEndDate = '20161005';
        inputApi.recordCount = 100;
        inputApi.recordPosition = 0;
        inputApi.lob = 'mortgage';
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objLoanAcc = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        ApexPages.currentPage().getParameters().put('id',objLoanAcc.Id);
        Account acc = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.WhatID = acc.id;
        t.Subject='none';
        t.Status='Not Started';
        t.Priority='Normal';
        t.ActivityDate = System.Today()-1;
        insert t;
        
        Task t1 = new Task();
        t1.OwnerId = UserInfo.getUserId();
        t1.WhatID = acc.id;
        t1.Subject='none';
        t1.Status='Not Started';
        t1.Priority='Normal';
        t1.ActivityDate = System.Today();
        insert t1;
        
        ScCollection_PaymentAPIParameters__c objCust = new ScCollection_PaymentAPIParameters__c();
        objCust.name = 'ScCollection_PaymentAPIParameters';
        objCust.Endpoint__c = 'https://collections-sandbox.au.cloudhub.io/transactions';
        objCust.Password__c = 'P3pp3rPa55';
        objCust.Username__c = 'pepper';
        insert objCust;
        
        test.startTest();
        ScCollection_PaymentTransactions objPaymentTransaction = new ScCollection_PaymentTransactions();
        
        objPaymentTransaction.startTask = t;
        objPaymentTransaction.endTask = t1;
        objPaymentTransaction.inputApi = inputApi;
        objPaymentTransaction.fetchTransactions();
        objPaymentTransaction.OpenPdf();
        inputApi.lob = 'paf';
        objPaymentTransaction.inputApi = inputApi;
        objPaymentTransaction.fetchTransactions();
        
        objLoanAcc.Name = '1231_2';
        objLoanAcc.collect__External_ID__c = 'PAF:1231_2';
        update objLoanAcc ;
        objPaymentTransaction.fetchTransactions();
        test.stopTest();
    }
}
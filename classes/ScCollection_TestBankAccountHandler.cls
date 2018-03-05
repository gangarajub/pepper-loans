// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_BankAccountHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(SeeAllData=False)
public class ScCollection_TestBankAccountHandler
{
    static testMethod Void muUnitTest()
    {
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
      
        collect__Loan_Account__c objLoanContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objLoanContract.collect__External_ID__c='TESTBANKID';
        update objLoanContract;  
      
        collect__Bank_Account__c objCollectBank = ScCollection_CommonTrackerClass.createTestBankAccount(objSourceSystem.Id);
    }
   
    static testMethod Void myUnitTest1()
    {
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
      
        collect__Loan_Account__c objLoanContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        clcommon__Party_Type__c objptype = new clcommon__Party_Type__c();
        objptype.Name = 'Primary Borrower';
        insert objptype;
        
        clcommon__Party__c objparty = new clcommon__Party__c();
        objparty.collect__CL_Contract__c = objLoanContract.Id;
        objparty.clcommon__Account__c = objAccount.Id;
        objparty.clcommon__Type__c = objptype.Id;
        insert objparty;
          
        collect__Bank_Account__c objCollectBank = new collect__Bank_Account__c();
        objCollectBank.collect__Account__c = objAccount.id;
        objCollectBank.Name = 'TestBank';
        objCollectBank.collect__Source_System__c = objSourceSystem.id;
        insert objCollectBank;
    }
}
// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_PartyHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestPartyHandler
{
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public Static Account objAccount;
    public static clcommon__Party_Type__c objptype;
    public static clcommon__Party__c objparty;
    
    static testMethod void myUnitTest() 
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        //Insert Account
        objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        collect__Bank_Account__c objCollectBank = new collect__Bank_Account__c();
        objCollectBank.collect__Account__c = objAccount.id;
        objCollectBank.Name = 'TestBank';
        objCollectBank.collect__Source_System__c = objSourceSystem.id;
        insert objCollectBank;
        
        objptype = new clcommon__Party_Type__c();
        objptype.Name = 'Primary Borrower';
        insert objptype;
        
        objparty = new clcommon__Party__c();
        objparty.clcommon__Account__c = objAccount.Id;
        objparty.collect__CL_Contract__c = objContract.Id;
        objparty.clcommon__Type__c = objptype.Id;
        objparty.ScCollection_Active__c = true;
        objparty.clcommon__isPrimary__c = true;
        insert objparty;
    }
    
    static testMethod void myUnitTest1() 
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        //Insert Account
        objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        objptype = new clcommon__Party_Type__c();
        objptype.Name = 'Primary Borrower';
        insert objptype;
        
        objparty = new clcommon__Party__c();
        objparty.clcommon__Account__c = objAccount.Id;
        objparty.collect__CL_Contract__c = objContract.Id;
        objparty.clcommon__Type__c = objptype.Id;
        objparty.ScCollection_Active__c = true;
        insert objparty;
        
        Account acc = new Account();
        acc.Name ='test acc';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.id;
        insert con;
        
        clcommon__Party_Type__c objP = new clcommon__Party_Type__c();
        objP.Name = 'Guarantor';
        insert objP;
        
        clcommon__Party__c objPartyNew= new clcommon__Party__c();
        objPartyNew.clcommon__Account__c = acc.Id;
        objPartyNew.collect__CL_Contract__c = objContract.Id;
        objPartyNew.clcommon__Type__c = objP.Id;
        objPartyNew.ScCollection_Active__c = true;
        objPartyNew.clcommon__Contact__c = con.id;
        insert objPartyNew;
        
        
        objparty.clcommon__isPrimary__c = true;
        update objparty;
    }
    static testMethod void myUnitTest2() 
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        //Insert Account
        objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account acc = new Account();
        acc.Name ='test acc';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.id;
        insert con;
        
        objptype = new clcommon__Party_Type__c();
        objptype.Name = 'Co.Borrower';
        insert objptype;
        
        objparty = new clcommon__Party__c();
        objparty.clcommon__Account__c = objAccount.Id;
        objparty.collect__CL_Contract__c = objContract.Id;
        objparty.clcommon__Type__c = objptype.Id;
        objparty.ScCollection_Active__c = true;
        objParty.clcommon__Contact__c = con.id;
        insert objparty;
        
        objparty.clcommon__isPrimary__c = true;
        update objparty;
    }
}
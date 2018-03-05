// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_PreferenceHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 06-OCT-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestPreferenceHandler
{
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public Static Account objAccount;
    public static clcommon__Party_Type__c objptype;
    public static clcommon__Party__c objparty;
    public static collect__Contact_Preference__c objpref;
    
    static testMethod void myUnitTest() 
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
        objparty.clcommon__isPrimary__c = true;
        insert objparty;
        
        objpref = new collect__Contact_Preference__c();
        objpref.collect__Party__c = objparty.Id;
        objpref.collect__Start_Time__c = System.Now();
        objpref.collect__End_Time__c = System.Now().addHours(1);
        objpref.collect__Preferred__c = true;
        insert objpref;
        
        objpref.collect__Start_Time__c = System.Now().addHours(2);
        update objpref;
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
        objparty.clcommon__isPrimary__c = true;
        insert objparty;
        
        objpref = new collect__Contact_Preference__c();
        objpref.collect__Party__c = objparty.Id;
        objpref.collect__Start_Time__c = System.Now();
        objpref.collect__End_Time__c = System.Now().addHours(1);
        insert objpref;
        
        objpref.collect__Preferred__c = true;
        update objpref;
    }
}
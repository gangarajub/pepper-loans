// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_TestCnslTopComponentHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(SeeAllData=False)
public class ScCollection_TestCnslTopComponentHandler 
{
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static collect__Loan_Account__c objContract1;
    public static loan__Loan_Account__c objplcontract;
    public Static Account objAccount;
    public static clcommon__Party_Type__c objptype;
    public static clcommon__Party__c objparty;
    public static clcommon__Party__c objparty1;
    
    static testMethod void myUnitTest() 
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        //Insert Account
        objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        objAccount.PersonBirthdate = System.Today();
        objAccount.PersonMailingStreet = 'test';
        objAccount.PersonMailingCity = 'test';
        objAccount.PersonMailingState = 'test';
        objAccount.PersonMailingPostalCode = '1244';
        update objAccount;
          
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.collect__External_ID__c = '10000_0';
        update objContract;
        
        //Insert Object of Contract
        objContract1 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract1.collect__External_ID__c = '10000_1';
        update objContract1;
        
        //Insert Object of Contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
        objplcontract.loan__Account__c = objAccount.Id;
        update objplcontract;
        
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
        
        objparty1 = new clcommon__Party__c();
        objparty1.clcommon__Account__c = objAccount.Id;
        objparty1.collect__CL_Contract__c = objContract1.Id;
        objparty1.clcommon__Type__c = objptype.Id;
        objparty1.ScCollection_Active__c = true;
        objparty1.clcommon__isPrimary__c = true;
        insert objparty1;
        
        collect__Contact_Preference__c objpref = new collect__Contact_Preference__c();
        objpref.collect__Party__c = objparty.Id;
        objpref.collect__Preferred__c = true;
        objpref.collect__Start_Time__c = System.Now();
        objpref.collect__End_Time__c = System.Now();
        insert objpref;
        
        Blob b = Blob.valueOf('Test Data');  
        Attachment attachment = new Attachment();  
        attachment.ParentId = objAccount.id;  
        attachment.Name = 'Profile Pic';  
        attachment.Body = b;  
        insert(attachment);
                  
        ApexPages.currentPage().getParameters().put('Id', objContract.id);
        ScCollection_CnslTopComponentHandler objCnslTopComponentHandler = new ScCollection_CnslTopComponentHandler(); 
    }
    
    static testMethod void myUnitTest1() 
    {
        //Insert Account
        objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        objAccount.PersonBirthdate = System.Today();
        objAccount.PersonMailingStreet = 'test';
        objAccount.PersonMailingCity = 'test';
        objAccount.PersonMailingState = 'test';
        objAccount.PersonMailingPostalCode = '1244';
        update objAccount;
        
        Residential_Address__c objAddress = new Residential_Address__c();
        objAddress.Account__c = objAccount.id;
        objAddress.Address__c = 'add';
        insert objAddress;
        //Insert Object of pl Contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
        objplcontract.loan__Account__c = objAccount.Id;
        update objplcontract;
        
        Blob b = Blob.valueOf('Test Data');  
        Attachment attachment = new Attachment();  
        attachment.ParentId = objAccount.id;  
        attachment.Name = 'Profile Pic';  
        attachment.Body = b;  
        insert(attachment);
                  
        ApexPages.currentPage().getParameters().put('Id', objplcontract.id);
        ScCollection_CnslTopComponentHandler objCnslTopComponentHandler = new ScCollection_CnslTopComponentHandler(); 
    }
}
// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_inlineContracts class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestinlineContracts 
{  
    public static Contact objContact = null;
    public static Account objAccount = null;
    public static collect__Source_System__c objSourceSystem = null;
    public static collect__Loan_Account__c objContract = null;
    public static clcommon__Party__c  objparty = null;

    public static void loadData()
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        //Insert Account
        objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        //Insert Contact
        objContact = new Contact(FirstName='Cntct',LastName='Test');
        //objContact.Account = objAccount;
        objContact.Salutation = 'Ms';
        objContact.MobilePhone = '9867436729';
        objContact.HomePhone = '01207428737' ;
        insert objContact;
        
        objparty = new clcommon__Party__c();
        objparty.ScCollection_Active__c = true;
        objparty.clcommon__Account__c = objAccount.Id;
        objparty.clcommon__Contact__c = objContact.Id;
        objparty.collect__CL_Contract__c = objContract.Id;
        insert objparty;
    }
    
    static testMethod void myUnitTest() 
    {
        loadData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        Apexpages.currentpage().getparameters().put('id',objAccount.id);
        ScCollection_inlineContracts objinlineContracts = new ScCollection_inlineContracts(sc);
    }
        
    static testMethod void myUnitTest2() 
    {
        loadData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objContact);
        Apexpages.currentpage().getparameters().put('id',objContact.id);
        ScCollection_inlineContracts objinlineContracts = new ScCollection_inlineContracts(sc);
    }    
}
// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ViewAllLeftController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestViewAllLeftController
{
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static collect__Promise_To_Pay__c objPromisetoPayNew;
    public static collect__Promise_To_Pay__c objPromisetoPayOld;
    
    public static testMethod void myunittest()
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        objPromisetoPayOld = new  collect__Promise_To_Pay__c();
        objPromisetoPayOld.collect__Loan_Account_Id__c = String.valueOf(objContract.id); 
        objPromisetoPayOld.collect__Promise_To_Pay_Date__c = System.Today().addDays(-1);
        objPromisetoPayOld.collect__Promise_To_Pay_Amount__c = 32732;
        objPromisetoPayOld.collect__Dev_Contract__c = objContract.id;
        insert objPromisetoPayOld;
        
        objPromisetoPayNew = new  collect__Promise_To_Pay__c();
        objPromisetoPayNew.collect__Loan_Account_Id__c = String.valueOf(objContract.id); 
        objPromisetoPayNew.collect__Promise_To_Pay_Date__c = System.Today().addDays(1);
        objPromisetoPayNew.collect__Promise_To_Pay_Amount__c = 32732;
        objPromisetoPayNew.collect__Dev_Contract__c = objContract.id;
        insert objPromisetoPayNew;
        
        ApexPages.currentPage().getParameters().put('Id', objContract.id);
        ApexPages.currentPage().getParameters().put('display', 'PTP');
        
        ScCollection_ViewAllLeftController obj = new ScCollection_ViewAllLeftController();
    }
}
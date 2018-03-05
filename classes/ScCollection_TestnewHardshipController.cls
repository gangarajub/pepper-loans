// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_newHardshipController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestnewHardshipController
{  
    static testMethod void myUnitTest() 
    { 
        ScCollection_Hardship__c objHardship = new ScCollection_Hardship__c();
        insert objHardship ;
          
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
         
        //Insert Object of Contract
        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name ='Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c =80;
        insert objContract ;
          
        ApexPages.StandardController sc = new ApexPages.StandardController(objHardship);
        Apexpages.currentpage().getparameters().put('contractId',objContract.id);
        ScCollection_newHardshipController objHardshipController = new ScCollection_newHardshipController(sc);
        objHardshipController.cancelCustom();
        objHardshipController.insertHardship();
    }    
}
// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CnslLeftComponentHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestCnslLeftComponentHand 
{
    static testMethod void myUnitTest() 
    { 
        //insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');

        //Insert Object of Contract
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
          
        ApexPages.currentPage().getParameters().put('Id',objContract.id);
        ScCollection_CnslLeftComponentHandler objCnslLeftComponentHandler = new ScCollection_CnslLeftComponentHandler();
        objCnslLeftComponentHandler.DeleteHardship();
        objCnslLeftComponentHandler.DeleteRecovery(); 
    }       
}
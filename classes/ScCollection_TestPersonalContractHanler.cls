// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_PersonalContractHanler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 26-SEP-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestPersonalContractHanler 
{
    public static loan__Loan_Account__c objplcontract;
    
    static testMethod void myUnitTest()
    {  
        //insert pl contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
        
        objplcontract.loan__Loan_Status__c = 'Active - Bad Standing';
        update objplcontract; 
        
        objplcontract.loan__Loan_Status__c = 'Active - Good Standing';
        update objplcontract; 
        
        objplcontract.loan__Loan_Status__c = 'Active - Matured';
        update objplcontract; 
        
        objplcontract.loan__Loan_Status__c = 'Closed - Obligations Met';
        update objplcontract; 
        
        objplcontract.loan__Loan_Status__c = 'Closed - Premature';
        update objplcontract; 
        
        objplcontract.FirstLPTRejected__c = true;
        update objplcontract;
    } 
}
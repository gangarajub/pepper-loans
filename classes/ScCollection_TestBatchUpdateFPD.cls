// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_BatchUpdateFPD class
// ----------------------------------------------------------------------------------------------------
// Created Date: 10-OCT-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestBatchUpdateFPD
{
    static testMethod void myUnitTest() 
    { 
        //insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        objSourceSystem.collect__Tolerance_Days__c     =    3;
        
        update objSourceSystem;

        //Insert Object of Contract
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
          
        objContract.ScCollection_First_Payment_Due_Date__c = System.today().adddays(-4);
        
        objContract.ScCollection_First_Payment_Due_Amount__c= 300;
        
        update objContract;
        collect__Loan_Payment_Transaction__c tempPayment = new collect__Loan_Payment_Transaction__c();
        tempPayment.collect__Dev_Contract__c       = objContract.id   ;
        tempPayment.collect__Transaction_Amount__c = 400;
        tempPayment.collect__Transaction_Date__c  = System.today().adddays(-2);
        tempPayment.collect__Cleared__c = true;
        tempPayment.collect__Reversed__c = false;
        insert tempPayment ;
        Database.executebatch(new ScCollection_BatchUpdateFPD(System.today(),'MORTGAGE'));
    }       
    
    static testMethod void myUnitTestNoToleranceDays() 
    { 
        //insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        objSourceSystem.collect__Tolerance_Days__c     =    3;
        
        update objSourceSystem;

        //Insert Object of Contract
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
          
        objContract.ScCollection_First_Payment_Due_Date__c = System.today().adddays(-4);
        
        objContract.ScCollection_First_Payment_Due_Amount__c= 300;
        
        update objContract;
        collect__Loan_Payment_Transaction__c tempPayment = new collect__Loan_Payment_Transaction__c();
        tempPayment.collect__Dev_Contract__c       = objContract.id   ;
        tempPayment.collect__Transaction_Amount__c = 200;
        tempPayment.collect__Transaction_Date__c  = System.today().adddays(-2);
        tempPayment.collect__Cleared__c = true;
        tempPayment.collect__Reversed__c = false;
        insert tempPayment ;
        Database.executebatch(new ScCollection_BatchUpdateFPD(System.today(),'MORTGAGE'));
    }       
}
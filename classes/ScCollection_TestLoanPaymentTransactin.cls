// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_LoanPaymentTransactinFacade class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestLoanPaymentTransactin
{  
    static testMethod void myUnitTest() 
    { 
        //Insert Object of Contract
        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name ='Contract-001';
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c =80;
        insert objContract ;
          
        collect__Loan_Payment_Transaction__c objLoanPayment = new collect__Loan_Payment_Transaction__c();
        objLoanPayment.collect__Reversed__c = false;
        objLoanPayment.collect__Dev_Contract__c = objContract.id;
        insert objLoanPayment ;
          
        Map<id,collect__Loan_Payment_Transaction__c> mapOld = new Map<id,collect__Loan_Payment_Transaction__c>();
        mapOld.put(objLoanPayment.id,objLoanPayment);
          
        collect__Loan_Payment_Transaction__c objLoanPaymentNew = new collect__Loan_Payment_Transaction__c(id = objLoanPayment.id);
        objLoanPaymentNew.collect__Reversed__c = true;
        update objLoanPaymentNew ;
          
        List<collect__Loan_Payment_Transaction__c> newList = new List<collect__Loan_Payment_Transaction__c>();
        newList.add(objLoanPaymentNew);
          
        ScCollection_LoanPaymentTransactinFacade.reversedIntimations(newList,mapOld);
    }        
}
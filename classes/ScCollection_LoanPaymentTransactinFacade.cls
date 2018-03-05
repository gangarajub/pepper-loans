// ----------------------------------------------------------------------------------------------------
// This class would handle all the transactions related to Payment Loan transaction and call the respective handlers
// ----------------------------------------------------------------------------------------------------
// Created Date: 07-JUN-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestLoanPaymentTransactin
// ----------------------------------------------------------------------------------------------------
public  class ScCollection_LoanPaymentTransactinFacade 
{    
    //this method would refine the the reversed transactions and forward it to handler
    public static void reversedIntimations(List<collect__Loan_Payment_Transaction__c> newList, Map<id,collect__Loan_Payment_Transaction__c> mapOld)
    {
        Set<Id> eligibleTransactiosn = new Set<Id>();
        
        //look for reversed transactions
        for(collect__Loan_Payment_Transaction__c tempTransaction : newList)
        {
            if(tempTransaction.collect__Reversed__c == true && mapOld.get(tempTransaction.id).collect__Reversed__c == false)
            {
                // add for processing 
                eligibleTransactiosn.add(tempTransaction.id);
            }
        }
         
        // if we have some eligible  transactions
        if(eligibleTransactiosn.size() > 0)
        {
            //SCCollection_TrgHanlrLoanPaymentTrntions.intimationForSmsOrEmail(eligibleTransactiosn);
        }
    }
}
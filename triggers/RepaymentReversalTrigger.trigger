trigger RepaymentReversalTrigger on loan__Repayment_Transaction_Adjustment__c (before insert) {
    List<loan__Repayment_Transaction_Adjustment__c>  RepaymentTxnList = new List<loan__Repayment_Transaction_Adjustment__c>();
    for (loan__Repayment_Transaction_Adjustment__c a : Trigger.New){
        a.loan__Custom_Logic__c = true;
        RepaymentTxnList.add(a); 
    }
    
}
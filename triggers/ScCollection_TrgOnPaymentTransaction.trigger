trigger ScCollection_TrgOnPaymentTransaction on collect__Loan_Payment_Transaction__c (Before Insert) {
    
    //if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Loan_Payment_Transaction')) return;
    
    /*if(Trigger.IsBefore && Trigger.IsInsert){
    
        
        ScCollection_TrgOnPaymentTxnHandler.UpdateExistingRecordOnNegetiveAmount(trigger.New); 
    }*/
}
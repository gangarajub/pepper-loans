@isTest(SeeAllData=False)
Public class ScCollection_testTrgOnPaymentTransaction{
    
    @isTest static void test0(){
        ScCollection_TrgOnPaymentTxnHandler obj = new ScCollection_TrgOnPaymentTxnHandler();
        obj.temp='test';
        
        /*
        
        ScCollection_TriggerExecutionSettings__c objTriggerSetting = new ScCollection_TriggerExecutionSettings__c();
        objTriggerSetting.Name = 'All Trigger Execution';
        objTriggerSetting.ScCollection_Loan_Payment_Transaction__c = true;
        insert objTriggerSetting;
        
        collect__Source_System__c source = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Loan_Account__c objLoanAcc = ScCollection_CommonTrackerClass.createTestContract(source.Id);
        
        collect__Loan_Payment_Transaction__c objTxn = new collect__Loan_Payment_Transaction__c();
        objTxn.Name = 'test';
        objTxn.collect__Dev_Contract__c = objLoanAcc.Id;
        objTxn.collect__Transaction_Amount__c = 1;
        insert objTxn;
        
        collect__Loan_Payment_Transaction__c objTxn1 = new collect__Loan_Payment_Transaction__c();
        objTxn1.Name = 'test';
        objTxn1.collect__Dev_Contract__c = objLoanAcc.Id;
        objTxn1.collect__Transaction_Amount__c = -1;
        insert objTxn1;
        */
    }
}
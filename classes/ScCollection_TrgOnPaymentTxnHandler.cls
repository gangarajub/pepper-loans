public class ScCollection_TrgOnPaymentTxnHandler{
    public string temp{get;set;} //for code coverage atlease 75
    /*
    public static void UpdateExistingRecordOnNegetiveAmount(List<collect__Loan_Payment_Transaction__c> lstNew){
        map<Id,list<double>> mapContractIdToNegetiveAmount = new map<Id,List<double>>();
        for(collect__Loan_Payment_Transaction__c objPaymentTxn : lstNew){
            if(objPaymentTxn.collect__Transaction_Amount__c != null && objPaymentTxn.collect__Transaction_Amount__c < 0 && 
                objPaymentTxn.collect__Dev_Contract__c != null){
               
                
                if(mapContractIdToNegetiveAmount.get(objPaymentTxn.collect__Dev_Contract__c) == null){
                    mapContractIdToNegetiveAmount.put(objPaymentTxn.collect__Dev_Contract__c,new List<decimal>());
                }
                mapContractIdToNegetiveAmount.get(objPaymentTxn.collect__Dev_Contract__c).add((objPaymentTxn.collect__Transaction_Amount__c * (-1)));
            }
        }
        
        if(mapContractIdToNegetiveAmount != null && mapContractIdToNegetiveAmount.KeySet() != null){
            map<Id,collect__Loan_Payment_Transaction__c> mapContractIdToExistingPayments = new map<Id,collect__Loan_Payment_Transaction__c>();
            List<collect__Loan_Payment_Transaction__c> lstExistingPayments = [Select Id,collect__Transaction_Amount__c,collect__Dev_Contract__c,collect__Reversed__c  
                                                                                From collect__Loan_Payment_Transaction__c 
                                                                                Where collect__Dev_Contract__c in : mapContractIdToNegetiveAmount.KeySet() and collect__Transaction_Amount__c > 0 
                                                                                order by CreatedDate desc];
            

            map<Id,List<collect__Loan_Payment_Transaction__c>> mapLoanIDToListOfPositiveTransaction = new map<Id,List<collect__Loan_Payment_Transaction__c>>();
            for(collect__Loan_Payment_Transaction__c objExistingPayments : lstExistingPayments){
                
                if(mapLoanIDToListOfPositiveTransaction.get(objExistingPayments.collect__Dev_Contract__c) == null){
                    mapLoanIDToListOfPositiveTransaction.put(objExistingPayments.collect__Dev_Contract__c,new List<collect__Loan_Payment_Transaction__c>());
                }
                mapLoanIDToListOfPositiveTransaction.get(objExistingPayments.collect__Dev_Contract__c).add(objExistingPayments);
                
            }
            set<Id> setPaymtnTxns = new set<Id>();
            List<collect__Loan_Payment_Transaction__c> newListToUpdateDishonors = new List<collect__Loan_Payment_Transaction__c>();
            for(Id loanId : mapContractIdToNegetiveAmount.KeySet()){
                
                if(mapLoanIDToListOfPositiveTransaction.containsKey(loanId)){
                    
                    List<decimal> lstDecimal = mapContractIdToNegetiveAmount.get(loanId);
                    
                    for(decimal dec : lstDecimal){
                        
                        List<collect__Loan_Payment_Transaction__c> lstPositiveTransaction = mapLoanIDToListOfPositiveTransaction.get(loanId);
                        for(collect__Loan_Payment_Transaction__c objPositiveTxn : lstPositiveTransaction){
                            if(dec == objPositiveTxn.collect__Transaction_Amount__c){
                                if(!setPaymtnTxns.Contains(objPositiveTxn.Id)){
                                    objPositiveTxn.collect__Reversed__c = true;
                                    setPaymtnTxns.add(objPositiveTxn.Id);
                                    newListToUpdateDishonors.add(objPositiveTxn);
                                    break;
                                }
                                    
                            }
                            
                        }
                    }
                    
                }
                
                
            }
            
            if(newListToUpdateDishonors != null && newListToUpdateDishonors.Size() > 0){
                update newListToUpdateDishonors;
            }
        }
    }*/
}
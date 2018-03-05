public class QueryUtil{
    public static String getBrokerTxnSweepToACHJobQuery(){
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        
         Date   iDate = util.getCurrentSystemDate();
        
        
       
         Set<String>   paymentModes =  new Set<String>();
         paymentModes = getAllPaymentModes();
        
        
        
        String ns = loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c;
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        Set<String> allowableTxnCodes = new Set<String> {loan.LoanConstants.TXN_COMMISSION_DISB,
                                                              loan.LoanConstants.TXN_COMMISSION_UP_DISB};
        mfiflexUtil.ObjectCache brTxnOC = ec.createObject('Broker Transactions',
                                                            'loan__Broker_Transactions__c'
                                                            );
        brTxnOC.addFields('loan__Sent_To_ACH__c,loan__Account__c,loan__Sent_To_ACH_On__c,Payment_Mode__r.name,loan__ACH_Filename__c,loan__Contact__c,loan__Contact__r.AccountId,loan__Contact__r.Name,loan__Transaction_Amount__c,Commission_Amount_Including_GST__c');
        brTxnOC.addNamedParameter('iDate', iDate);
        brTxnOC.addNamedParameter('allowableTxnCodes',allowableTxnCodes);
        brTxnOC.addNamedParameter('pModes', paymentModes);
        String whereClause = 'loan__Sent_To_ACH__c = false AND loan__Transaction_Date__c <= :iDate AND loan__Sent_To_ACH_On__c=null'+
                              ' AND loan__Broker__r.loan__Lending_Account__r.loan__Invalid_Data__c = false AND loan__Transaction_Code__c IN:allowableTxnCodes'+
                              ' AND loan__Transaction_Amount__c>0 AND Payment_Mode__r.Name IN :pModes';
        brTxnOC.setWhereClause(whereClause);
        brTxnOC.setOrderClause('loan__Transaction_Date__c');
        brTxnOC.buildQuery();
        return brTxnOC.getQuery();
    }
    
    public static Set<String> getAllPaymentModes() {
        Set<String> retVal = new Set<String>();
        if (loan.CustomSettingsutil.getACHParameters().loan__Multiple_Payment_Method_Support__c == true) {
            List<loan__Automated_Payment_Configuration__c> aPCs = [SELECT id,
                                                            loan__Payment_Mode__r.Name
                                                            FROM loan__Automated_Payment_Configuration__c
                                                            WHERE loan__Active__c = TRUE];

            if (aPCs.size() > 0){
                for(loan__Automated_Payment_Configuration__c aPC : aPCs){
                    retVal.add(aPC.loan__Payment_Mode__r.Name);
                }
            }
        }
        retVal.add('Direct Credit');
        return retVal;
    }
}
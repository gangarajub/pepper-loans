global class DownloadAccountStatement{

    webservice static String generateStatement(String loanAccountId){        
        String status = '';
        
        try {
            List<loan__Transaction_Summary__c> txnSummary = [select id,name from loan__Transaction_Summary__c where loan__Loan_Account__c=:loanAccountId];
            if(txnSummary.size()>0){
                delete txnSummary; 
            }
            
            
            List<loan__Loan_Account__c> loanAccount = [select id,name,Txn_Summary_Closing_Balance__c,
                    Txn_Summary_Opening_Balance__c,
                    Txn_Summary_Total_Credit__c,
                    Txn_Summary_Total_Debit__c,
                    Txn_Summary_Total_Fees__c,
                    Txn_Summary_Total_Interest__c from loan__Loan_Account__c where id=:loanAccountId];
            
            BulkCreateTransactionSummaryAction loanAction = new BulkCreateTransactionSummaryAction(loanAccount,null,null);
            list<loan__Transaction_Summary__c> act = loanAction.getSummary().get(loanAccountId);
            loanAccount[0].Txn_Summary_Total_Credit__c = 0;
            loanAccount[0].Txn_Summary_Total_Debit__c = 0;
            loanAccount[0].Txn_Summary_Total_Fees__c = 0;
            loanAccount[0].Txn_Summary_Total_Interest__c = 0;
            loanAccount[0].Txn_Summary_Closing_Balance__c = 0;
            loanAccount[0].Txn_Summary_Opening_Balance__c = 0;
            if(act[0].loan__Type__c.equalsIgnoreCase('Credit')){
                loanAccount[0].Txn_Summary_Opening_Balance__c = act[0].loan__Balance__c + act[0].loan__Txn_Amt__c;
            }else if(act[0].loan__Type__c.equalsIgnoreCase('Debit')){
                loanAccount[0].Txn_Summary_Opening_Balance__c = act[0].loan__Balance__c - act[0].loan__Txn_Amt__c;
                if(act[0].loan__Transaction_Type__c!=null && act[0].loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL)){
                    loanAccount[0].Txn_Summary_Opening_Balance__c = act[0].loan__Balance__c;
                }
            }
            
            loanAccount[0].Txn_Summary_Closing_Balance__c = act[act.size()-1].loan__Balance__c;
            for(loan__Transaction_Summary__c d:act){
                system.debug(d);
                if(d.loan__Type__c!=null){
                    if(d.loan__Type__c.equalsIgnoreCase('Credit')){
                        loanAccount[0].Txn_Summary_Total_Credit__c += d.Credit__C;
                    }else if(d.loan__Type__c.equalsIgnoreCase('Debit')){
                        loanAccount[0].Txn_Summary_Total_Debit__c += d.Debit__C;
                    }
                }
                
                
                if(d.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_CHARGE)){
                    loanAccount[0].Txn_Summary_Total_Fees__c += d.loan__Txn_Amt__c;
                }
                if(d.loan__Transaction_Type__c.equalsIgnoreCase('Interest Charge')){
                    loanAccount[0].Txn_Summary_Total_Interest__c += d.loan__Txn_Amt__c;
                }
            }
            if(loanAccount[0].Txn_Summary_Opening_Balance__c != null){
                loanAccount[0].Txn_Summary_Opening_Balance__c = loanAccount[0].Txn_Summary_Opening_Balance__c.setScale(2);
            }
            if(loanAccount[0].Txn_Summary_Closing_Balance__c!=null){
                loanAccount[0].Txn_Summary_Closing_Balance__c = loanAccount[0].Txn_Summary_Closing_Balance__c.setScale(2);
            }
            if(loanAccount[0].Txn_Summary_Total_Credit__c!=null){
                loanAccount[0].Txn_Summary_Total_Credit__c = loanAccount[0].Txn_Summary_Total_Credit__c.setScale(2);
            }
            if(loanAccount[0].Txn_Summary_Total_Debit__c!=null){
                loanAccount[0].Txn_Summary_Total_Debit__c = loanAccount[0].Txn_Summary_Total_Debit__c.setScale(2);
            }
            if(loanAccount[0].Txn_Summary_Total_Fees__c!=null){
                loanAccount[0].Txn_Summary_Total_Fees__c = loanAccount[0].Txn_Summary_Total_Fees__c.setScale(2);
            }
            if(loanAccount[0].Txn_Summary_Total_Interest__c!=null){
                loanAccount[0].Txn_Summary_Total_Interest__c = loanAccount[0].Txn_Summary_Total_Interest__c.setScale(2);
            }
            
            
            update loanAccount;
            status='Generating Borrower Statement..';
            insert act;
            List<loop__DDP__c> ddp = [select id,Name from Loop__DDP__c where Name = 'Loan Account Statement'];
            String ddpId = '';
            String deliveryId = '';
            if(ddp!=null && ddp.size()>0){
                ddpId = ddp[0].id;
                List<Loop__DDP_Integration_Option__c> deliveryIds= [select id , name from Loop__DDP_Integration_Option__c where Name = 'Attach' and Loop__DDP__c =:ddpId];
                if(deliveryIds.size()>0){
                    deliveryId = deliveryids[0].id;
                }
            }
            String sessionId = UserInfo.getSessionId();
            If(!String.isblank(ddpId) && !String.isBlank(deliveryId)){
                generateDDP(deliveryId,ddpId,loanAccountId,sessionId);
            }
        } catch(Exception e) {
            status = e.getMessage();
            return status;
        
       
    }
     return status;
}
  webservice static String generateContract(String loanAccountId){        
        String status = '';
        try { 
            status='Generating Contract..';
           
            List<loop__DDP__c> ddp = [select id,Name from Loop__DDP__c where Name = 'Contract DDP Internal'];
            String ddpId = '';
            String deliveryId = '';
            if(ddp!=null && ddp.size()>0){
                ddpId = ddp[0].id;
                List<Loop__DDP_Integration_Option__c> deliveryIds= [select id , name from Loop__DDP_Integration_Option__c where Name = 'Email' and Loop__DDP__c =:ddpId];
                if(deliveryIds.size()>0){
                    deliveryId = deliveryids[0].id;
                }
            }
            String sessionId = UserInfo.getSessionId();
            If(!String.isblank(ddpId) && !String.isBlank(deliveryId)){
                generateDDP(deliveryId,ddpId,loanAccountId,sessionId);
            }
        } catch(Exception e) {
            status = e.getMessage();
            return status;
        
       
    }
     return status;
}


@future(callout = true)
    public static void generateDDP(String deployId,String templateId,String loanAccId,String sessionId){
        Map<string, string> variables = new Map<string,string>();
        variables = new Map<string, string> { 'deploy' => deployId };
        Loop.loopMessage lm = new Loop.loopMessage();
        lm.sessionId=sessionId;
        lm.requests.add(new Loop.loopMessage.loopMessageRequest(loanAccId,templateId,variables));
        lm.sendAllRequests();
    }
 /*global String generateStatement2(List<loan__Loan_Account__c> loanAccountIds){        
        String status = '';
        try {
            
            List<loan__Transaction_Summary__c> txnSummry = new List<loan__Transaction_Summary__c>();
            for(loan__Loan_Account__c loanAcc:loanAccountIds){
                System.debug('loanAcc'+loanAcc);
                try{
                BulkCreateTransactionSummaryAction loanAction = new BulkCreateTransactionSummaryAction(loanAccountIds,null,null);
                list<loan__Transaction_Summary__c> act = loanAction.getSummary().get(loanAcc.Id);
                System.debug('act'+act);
                for(loan__Transaction_Summary__c d:act){
                    txnSummry.add(d);
                    
                }
                }catch(Exception e){
                    System.debug('e'+e.getMessage());
                      System.debug('e'+e.getLineNumber());
                }
                
            
            }
            System.debug('txnSummry'+txnSummry);
            
            status='Successfully inserted transactions';
            insert txnSummry;
            
        } catch(Exception e) {
            status = e.getMessage();
            return status;
        
       
    }
     return status;
}*/

}
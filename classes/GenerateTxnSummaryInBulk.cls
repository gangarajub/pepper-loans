public class GenerateTxnSummaryInBulk implements Schedulable,Database.Batchable<sobject>,Database.stateful,Database.AllowsCallouts  {

    private Integer batchSize = 500;

    private static String NAME = 'Generate Txn Summary';
    
   
    public GenerateTxnSummaryInBulk() {
        
    }
    
   
    
    public void execute(SchedulableContext sc) {
        GenerateTxnSummaryInBulk j = new GenerateTxnSummaryInBulk();
        Database.executeBatch(j, 1);
    }
    
    public Database.queryLocator Start(Database.BatchableContext bc) {
        loan.GlobalLoanUtilFacade loanUtil;
        Date systemDate;
        Date lastoneMonth;
        loanUtil = new loan.GlobalLoanUtilFacade();
        systemDate = loanUtil.getCurrentSystemDate();
        lastoneMonth= systemDate -31;
        String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_WRITTEN_OFF + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_ACTIVE_MATURED + '\'';
        String query = 'select id,name,SPV__c,Txn_Summary_Closing_Balance__c,Txn_Summary_Opening_Balance__c,Txn_Summary_Total_Credit__c,Txn_Summary_Total_Debit__c,Txn_Summary_Total_Fees__c,Txn_Summary_Total_Interest__c  from loan__Loan_Account__c' +
                ' WHERE loan__Loan_Status__c ' +
                'IN (' + allowabledLoanStatuses + ')  and loan__Last_Transaction_Timestamp__c>=:lastoneMonth';
        system.debug(query);
        return Database.getQueryLocator(query);
    } // do nothing
    
    public  void Execute(Database.BatchableContext bc, List<sObject> scope) {
        
        try {
            BorrowersStatement__c  bSt = BorrowersStatement__c.getInstance();
            Integer numberOfMonths = 6;
            if(bST.Statement_Period_Months__c!=null){
                numberOfMonths = 6;
            }
            loan.GlobalLoanUtilFacade loanUtil;
            Date systemDate;
            
            loanUtil = new loan.GlobalLoanUtilFacade();
            systemDate = loanUtil.getCurrentSystemDate();
            Date endDate  = systemDate;
            Date startDate = systemDate.addMonths(-1 * numberOfMonths);
            List<loan__Transaction_Summary__c> txnSummary = [select id,name from loan__Transaction_Summary__c where loan__Loan_Account__c=:scope[0].id];
            if(txnSummary.size()>0){
                delete txnSummary; 
            }
            
            List<loan__Loan_Account__c> loanAccount = [select id,name,Txn_Summary_Closing_Balance__c,
                    Txn_Summary_Opening_Balance__c,
                    Txn_Summary_Total_Credit__c,
                    Txn_Summary_Total_Debit__c,
                    Txn_Summary_Total_Fees__c,
                    Txn_Summary_Total_Interest__c from loan__Loan_Account__c where id=:scope[0].id];
            
            BulkCreateTransactionSummaryAction loanAction = new BulkCreateTransactionSummaryAction(loanAccount,startDate,endDate);
            list<loan__Transaction_Summary__c> act = loanAction.getSummary().get(scope[0].id);
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
            insert act;
          
        } catch (Exception e) {
            throw e;
        }
    }
    
    public void Finish(Database.BatchableContext bc) {
        
    }

}
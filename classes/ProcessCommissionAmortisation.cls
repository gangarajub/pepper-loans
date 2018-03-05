global virtual class ProcessCommissionAmortisation 
                extends loan.MFiFlexBatchJob implements Schedulable,DataBase.Stateful {
    
    private Integer batchSize;
    private Static String NAME = 'PROCESS COMMISSION AMORTISATION';  
    loan.GlobalLoanUtilFacade info = new loan.GlobalLoanUtilFacade();
    private Date iDate = info.getCurrentSystemDate();
    
    private String query = jobQuery();
    
    private List<String> fileEntries = new List<String>();
    
    private String jobQuery(){
        String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_WRITTEN_OFF + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_ACTIVE_MATURED + '\'';
    
        return 'Select id,name,loan__Loan_Amount__c, ' +
                                'loan__Charged_Off_Date__c, ' +
                                'loan__Charged_Off_Fees__c, ' +
                                'loan__Charged_Off_Interest__c, ' +
                                'loan__Charged_Off_Principal__c, ' +
                                'loan__Pay_Off_Amount_As_Of_Today__c, ' +
                                'loan__Interest_Accrued_Not_Due__c, ' +
                                'Remaining_Commission_Amount__c,' + 
                                'loan__Principal_Remaining__c,'+
                                'Upfront_Commission_Amount__c,'+
                                'loan__Interest_Remaining__c, ' +
                                'Last_Amort_Commission_Date__c,'+
                                'loan__Loan_Status__c ' +
                                'from loan__Loan_Account__c ' +
                                'WHERE loan__Loan_Status__c ' +
                                'IN (' + allowabledLoanStatuses + ') '+
                                ' AND Remaining_Commission_Amount__c>0';
    
            //Query needs to be refined... 
            //add date in where clause...
    
    }
    
    global ProcessCommissionAmortisation() {
        super(NAME,null);
        this.batchSize = 100; //loan.CustomSettingsUtil.getBatchSize();
        this.iDate = iDate;
    }
    
    override global virtual database.querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }
    
    global ProcessCommissionAmortisation(Date iDate, Integer batchSize) {
        super(NAME,null);
        if(iDate != null){
            this.iDate = iDate;
        }
        this.batchSize = 100;
        if(batchSize != null){
            this.batchSize = batchSize;
        }
    }
    
    global void execute(SchedulableContext sc) {     
        ProcessCommissionAmortisation job = new ProcessCommissionAmortisation();
        Database.executeBatch(job,job.batchSize);
    }
    
    public virtual override void submitNextJob() {  } //do nothing
    
    public override void doStart(Database.BatchableContext bc) { } //do nothing
    
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
        List<loan__Loan_Account__c> loanAccounts = (List<loan__Loan_Account__c>) scope;
        List<Commission_Amortisation__c> listOfAmortToBeInserted = new List<Commission_Amortisation__c>();
        Set<String> loanIds = new Set<String>();
        for(loan__Loan_Account__c lAcc:loanAccounts){
            loanids.add(lAcc.id);
        }
        Map<String,List<loan__broker_transactions__C>> bTxnMap = new Map<String, List<loan__broker_transactions__c>>();
        List<loan__broker_transactions__c> btxns = [select id, loan__sent_to_ach__c,loan__sent_to_ach_on__c,loan__broker__r.loan__lending_account__c from loan__broker_transactions__c where loan__broker__r.loan__lending_account__c IN:loanIds and loan__Sent_to_ach__c = true];
        for(loan__broker_transactions__C bt:btxns){
            if(bTxnMap.get(bt.loan__broker__r.loan__lending_account__c)==null){
                bTxnMap.put(bt.loan__broker__r.loan__lending_account__c,new List<loan__broker_transactions__c>());
                
            }
            bTxnMap.get(bt.loan__broker__r.loan__lending_account__c).add(bt);
        }
         System.debug('ProcessCommissionAmortisation Job : ' + loanAccounts.size());
        for(loan__Loan_Account__c lAcc: loanAccounts){
            if(bTxnMap.get(lAcc.id)!=null && bTxnMap.get(lAcc.id).size()>0){
                Commission_Amortisation__c amrt = new Commission_Amortisation__c();
                if(lAcc.Remaining_Commission_Amount__c!=lAcc.Upfront_Commission_Amount__c){
                    amrt.Opening_Balance__c = lAcc.Remaining_Commission_Amount__c;
                }else{
                    if(bTxnMap.get(lAcc.id)[0].loan__sent_To_ACH_On__c.month() != iDate.addDays(-1).month()){
                        amrt.opening_balance__c = lAcc.Upfront_Commission_Amount__c;
                    }
                    amrt.Commissions_Paid_On_New_Loan__c = lAcc.Upfront_Commission_Amount__c;
                }
                amrt.Amortisation_Amount__c = lAcc.loan__Principal_Remaining__c/lAcc.loan__Loan_Amount__c*lAcc.Upfront_Commission_Amount__c;
                amrt.Expense_Amount__c = lAcc.Remaining_Commission_Amount__c - amrt.Amortisation_Amount__c;
                amrt.Date_From__c = lAcc.Last_Amort_Commission_Date__c;
                if(lAcc.Remaining_Commission_Amount__c==lAcc.Upfront_Commission_Amount__c){
                    amrt.Closing_Balance__c = lAcc.Remaining_Commission_Amount__c - amrt.Expense_Amount__c;
                }else{
                    amrt.Closing_Balance__c = amrt.Opening_Balance__c - amrt.Expense_Amount__c;
                }
                
                amrt.Date_To__c = iDate;
                lAcc.Remaining_Commission_Amount__c -= amrt.Expense_Amount__c;
                lAcc.Last_Amort_Commission_Date__c = iDate;
                amrt.Report_date__c = iDate.addDays(-1);
                amrt.Cl_Contract__c = lAcc.id;
                listOfAmortToBeinserted.add(amrt);
            }
            
        }
        insert listOfAmortToBeInserted;
        update loanAccounts;
    }
    
    public override void doFinish(Database.BatchableContext bc) {
        
    
        
    }
    
}
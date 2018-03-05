public class GenerateTransactionListing  implements Schedulable,Database.Batchable<sobject>,Database.stateful  {

    private Integer batchSize = 500;

    private static String NAME = 'Transaction Listing'; 
    List<String> entries = new List<String>();
    Date startDate;
    Date endDate;
   
    public GenerateTransactionListing() {
        
    }
    
    public GenerateTransactionListing(Date startDate, Date endDate){
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    public void execute(SchedulableContext sc) {
        GenerateTransactionListing j = new GenerateTransactionListing();
        Database.executeBatch(j, 1);
    }
    
    public Database.queryLocator Start(Database.BatchableContext bc) {
        String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_WRITTEN_OFF + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUS_ACTIVE_MATURED + '\'';
        String query = 'select id,name,SPV__c from loan__Loan_Account__c' +
                ' WHERE loan__Loan_Status__c ' +
                'IN (' + allowabledLoanStatuses + ') ';
        system.debug(query);
        return Database.getQueryLocator(query);
    } // do nothing
    
    public  void Execute(Database.BatchableContext bc, List<sObject> scope) {
        try {
            system.debug(startDate);
            system.debug(endDate);
            
             List<loan__Transaction_Summary__c> txnSummaryList = new List<loan__Transaction_Summary__c>();
             Map<String,loan__Loan_Account__c> loanMap = new Map<String,loan__Loan_Account__c>();
             Map<Id,loan__Loan_Payment_Transaction__c> txnMap = new Map<Id,loan__Loan_Payment_Transaction__c>();
             
             List<loan__Loan_Account__c> loanAccount = (List<loan__Loan_Account__c>)scope;
            loanMap.put(loanAccount[0].id,loanAccount[0]);
            List<loan__Loan_Payment_Transaction__c> txns = new List<loan__Loan_Payment_transaction__c>();
            
            Set<Id> txnIds = new Set<Id>();
            BulkCreateTransactionSummaryAction loanAction = new BulkCreateTransactionSummaryAction(loanAccount,startDate,endDate);
            Map<Id,List<loan__Transaction_Summary__c>> txnSummaryMap = new Map<Id,List<loan__Transaction_Summary__c>>();
            txnSummaryMap = loanAction.getSummary();
            system.debug(txnSummaryMap);
            system.debug(loanAccount[0].id);
            List<loan__Transaction_Summary__c> act = txnSummaryMap.get(loanAccount[0].id);
            system.debug(act);
            txnSummaryList.addAll(act);
            for(loan__Transaction_Summary__c txn: act){
                if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT)){
                    txnIds.add(txn.loan__Transaction_Id__c);
                }
            }
            txns = [select id,loan__Balance__c from loan__Loan_payment_Transaction__c where loan__Loan_Account__c=:loanAccount[0].id and Id IN:txnIds];
            if(txns.size()>0){
                for(loan__Loan_Payment_Transaction__c txn:txns){
                    txnMap.put(txn.Id,txn);
                }
            }
            system.debug(txnSummaryList);
            
            If(entries.size() == 0){
            String header = 'Loan ID,SPV,Transaction Type,Transaction Type Description,Transaction Code,Transaction Date,Creation Date,Credit Amount,Debit Amount,Transaction Balance,Transaction From,Transaction To'+'\r\n';
            entries.add(header);
            }
             for(loan__Transaction_Summary__c txn:txnSummaryList){
            if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE)){
                continue; 
            }
            String detail = '';
            List<String> entry = new List<String>();
            entry.add(loanMap.get(txn.loan__Loan_Account__c).Name);
            entry.add(loanMap.get(txn.loan__Loan_Account__c).SPV__c);
            if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT)||txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL)||txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL)||txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_REFUND)||txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB)){
                entry.add('Cash');
            }else{
                entry.add('Non Cash');
            }
            entry.add(txn.loan__Transaction_Type__c);
            entry.add(txn.Transaction_Code__c);
            entry.add(String.valueOf(txn.Transaction_Timestamp__c));
            entry.add(String.valueOf(txn.Transaction_Creation_Date__c));
            String creditAmount = txn.Credit__c!=null?String.valueOf(txn.Credit__c):'';
            entry.add(String.valueOf(creditAmount));
            String debitAmount = txn.Debit__c!=null?String.valueOf(txn.Debit__c):'';
            entry.add(String.valueOf(debitAmount));
            Decimal balance= 0;
            if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT) && txnMap.get(txn.loan__Transaction_Id__c)!=null){
                balance = txn.loan__Balance__c;
                
            }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL)){
                balance = txn.loan__Balance__c;
                
            }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_CHARGE)){
                balance = txn.loan__Balance__c;
               
            }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase('Interest Charge')){
                balance = txn.loan__Balance__c;
                
            }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL)){
                balance = txn.loan__Balance__c;
                
            }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_REFUND)){
                balance = txn.loan__Balance__c;
            }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_ADD)){
                balance = txn.loan__Balance__c;
            }else if(txn.loan__Transaction_Type__c.equalsIgnoreCase(loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB)){
                balance = txn.loan__Balance__c;
            }else if(txn.loan__Transaction_Type__c.equalsignoreCase('Charge Waive')){
                balance = txn.loan__Balance__c;
            }
            if(balance<0){
                entry.add('-'+String.valueOf(Math.abs(balance)));
            }else{
                entry.add(String.valueOf(balance));
            }
            
            entry.add(String.valueOf(StartDate));
            entry.add(String.valueOf(endDate));
            
            for(String e :entry){
               detail += e+',';
            }
            detail.removeEnd(',');
            detail += '\r\n';
            entries.add(detail);
        }
          
        } catch (Exception e) {
            throw e;
        }
    }
    
    public void Finish(Database.BatchableContext bc) {
        
        String fileBody = '';
        for(String s:entries){
            fileBody += s;
        }
        Report_Configuration__c rpConfig = [select id , folder_name__c from Report_Configuration__c where Name =:Name];
        String folderName= '';
        if(rpConfig!=null && rpConfig.folder_name__c!=null){
            folderName = rpConfig.folder_name__c;
        }
        
        String folderid = '';
        
        if (folderName != null) {
            Folder[] folder = [SELECT Id FROM Folder WHERE Name = :folderName];
            if (folder.size() > 0) {
                folderId = folder[0].Id;
            } else {
                folderId = (Id) UserInfo.getUserId();
            }
        } else {
            folderId = (Id) UserInfo.getUserId();
        }
        loan.GlobalLoanUtilFacade util=new loan.GlobalLoanUtilFacade();
        Date fileDate=util.getCurrentSystemDate();
        String currentTime =String.valueOf(fileDate)+String.valueOf(DateTime.Now());
        Document d = new Document();
        d.Name = Name+ '_' +currentTime+'.csv';
        d.Body = Blob.valueOf(fileBody);
        d.ContentType = 'text/csv';
        d.Type = 'csv';
        d.Description='';
        d.folderid = folderId;
        insert d;
    }

}
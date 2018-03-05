global virtual class BrokerTransactionFilegenJob 
                    extends loan.MFiFlexBatchJob implements Schedulable, Database.Stateful, loan.IPaymentModeBasedScheduler {

    global Integer batchSize;

    private static String NAME = 'BROKER PAYMENT FILEGEN';
    private loan.TransactionSweepToACHState state;
    private Date iDate;
    private Boolean submitNextJob = true;
    String query = '';
    loan.GlobalLoanUtilFacade util = new loan.GlobalLoanutilFacade();
    private Map<String,loan__Automated_Payment_Configuration__c> pModeToPaymentConfigMap = new Map<String,loan__Automated_Payment_Configuration__c>();
    private Map<String,Integer> fileCount = new Map<String,Integer>();
    public List<loan__broker_transactions__c> validBrokerTxns = new List<loan__broker_transactions__c>();  
    
    global virtual override void submitNextJob() {
        
    }
    
    Set<String> paymentModes = new Set<String>();
    
    
    
    global BrokerTransactionFilegenJob(Boolean submitNextJob) {
        this();
        this.submitNextJob = submitnextJob;
        this.batchSize = 900;
    }
    
    global BrokerTransactionFilegenJob(Date iDate, Boolean submitNextJob) {
        this();
        this.submitNextJob = submitnextJob;
        this.batchSize = 900;
    }
    
    global BrokerTransactionFilegenJob() {
        //this.name = NAME;
        super(NAME,QueryUtil.getBrokerTxnSweepToACHJobQuery());
        
        this.state = new loan.TransactionSweepToACHState();
        this.state.o2 = fileCount;
        this.batchSize = 900;
    }
    
   
    
    global virtual Set<String> getPaymentModes() {
        return paymentModes;
    }
    
    private loan.FileGenerator initializeFilegen(loan__Automated_Payment_Configuration__c paymentConfig) {
        String className = paymentConfig.loan__Filegen_Class__c;
        if (className != null) {
            try {
                return (loan.FileGenerator) loan.FileGenerator.getNewInstance(className);
            } catch (Exception e) {
                throw new MyException('Could not instantiate filegen class');
            }
        }else{
            throw new MyException('Could not instantiate filegen class');
        }
        
    }
    
    global void execute(SchedulableContext sc) {
        BrokerTransactionFilegenJob j = new BrokerTransactionFilegenJob();
        Database.executeBatch(j, this.batchSize);
    }
    
    global override void doStart(Database.BatchableContext bc) {
        
    } // do nothing
    
    global override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
        List<loan__Broker_Transactions__c> payments = (List<loan__Broker_Transactions__c>)scope;
        List<loan__Broker_Transactions__c> validPayments = new List<loan__Broker_Transactions__c>();
        Map<String,List<loan__Broker_Transactions__c>> pModeToPaymentMap = new Map<String,List<loan__Broker_Transactions__c>>();
        for(loan__Broker_Transactions__c pmt:payments){
            if(pModeToPaymentMap.get(pmt.Payment_Mode__r.Name)==null){
                pModeToPaymentMap.put(pmt.Payment_Mode__r.Name,new List<loan__Broker_Transactions__c>());
            }
            pModeToPaymentMap.get(pmt.Payment_Mode__r.Name).add(pmt);
        }
        
        Set<String> pModes = new Set<String>();
        
        pModes = pModeToPaymentMap.keySet();
        
        if (scope.size() == 0) {
            return;
        }
        
        String ns = loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c;
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache aPmtConfigOC = ec.createObject('Automated Payment Config-LoanP',
                                                            'Automated_Payment_Configuration__c',
                                                            ns);
        aPmtConfigOC.addNamedParameter('pModes',pModes);  
        aPmtConfigOC.addNamedParameter('brokerPayment',loan.LoanConstants.BROKER_TRANSACTION);                                             
        aPmtConfigOC.addFields('Bank_Account__c,'+
                         'Filegen_Class__c,'+
                         'File_Type__c,'+
                         'Folder_Name__c,'+
                         'Immediate_Destination__c,'+
                         'Originating_DFI_Identification__c,'+
                         'Trace_Number_Prefix__c,'+
                         'Payment_Mode__r.Name');
         
        
        aPmtConfigOC.setWhereClause( 'Payment_Mode__r.Name IN :pModes '
                                    + ' AND Active__c = true'
                                    + ' AND Event__c INCLUDES (:brokerPayment)');
        aPmtConfigOC.executeQuery();
        List<loan__Automated_Payment_Configuration__c> paymentConfigs =(List<loan__Automated_Payment_Configuration__c>) aPmtConfigOC.getRecords(); 
        for(loan__Automated_Payment_Configuration__c pmtConfig:paymentConfigs){
            if(pModeToPaymentConfigMap.get(pmtConfig.loan__Payment_Mode__r.Name)==null){
                pModeToPaymentConfigMap.put(pmtConfig.loan__Payment_Mode__r.Name,pmtConfig);
            }
        }
        
        for(String pMode:pModes){
            if(pModeToPaymentConfigMap.get(pMode)!=null && pModeToPaymentMap.get(pMode).size()>0){
                try{
                    loan.FileGenerator filegen = initializeFilegen(pModeToPaymentConfigMap.get(pMode));
                    filegen.setScope(pModeToPaymentMap.get(pMode));
                    state.o1 = pModeToPaymentConfigMap.get(pMode);
                    loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
                    filegen.createLines(state);
                    String filename = filegen.writeFile(state);
                    List<SObject> validScope = filegen.getValidScope();
                    for (SObject s : validScope) {
                        loan__Broker_Transactions__c bt = (loan__Broker_Transactions__c) s;
                        bt.loan__Sent_To_ACH__c = true;
                        bt.loan__ACH_Filename__c = filename;
                        bt.loan__Sent_To_ACH_On__c = util.getCurrentSystemDate();
                    }
                    validPayments.addAll((List<loan__Broker_Transactions__c>)validScope);
                    
                } catch (Exception e) {
                    throw new MyException(e.getMessage());
                }
            }
        }
        update validPayments;
        //validBrokerTxns.addAll(validPayments);
    }
    
    global override void doFinish(Database.BatchableContext bc) {
        List<Account> accs = [select Id,Latest_RCTI_Sent_On__c,Contact__r.Last_RCTi_Sent_on__c,Contact__r.id, name from Account where loan__broker__c = true];
        List<Contact> cList = new List<Contact>();
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate = util.getCurrentSystemDate();
        validBrokerTxns = [select id ,loan__Account__c from loan__broker_transactions__C where loan__Sent_to_Ach_on__c =:systemDate ];
        Map<Id,List<loan__broker_transactions__c>> btxnMap = new Map<Id,List<loan__Broker_Transactions__c>>();
        if(validBrokerTxns.size()>0){
            for(loan__Broker_Transactions__c bTxn:validBrokerTxns){
                system.debug(bTxn.loan__Account__c);
                if(btxnMap.get(bTxn.loan__Account__c)==null){
                    btxnMap.put(btxn.loan__Account__c,new List<loan__broker_transactions__c>());
                }
                btxnmap.get(btxn.loan__Account__c).add(btxn);
            }
            for(Account acc: accs){
                if(btxnMap.get(acc.id)!=null && btxnMap.get(acc.id).size()>0){
                    if(acc.Contact__r!=null){
                        Contact c = acc.Contact__r;
                        if(acc.Latest_RCTI_Sent_On__c == null){
                            acc.Latest_RCTI_Sent_On__c = systemDate.addDays(-7);
                        }
                        c.Last_RCTI_Sent_on__c = acc.Latest_RCTI_Sent_On__c;
                        acc.Latest_RCTI_Sent_On__c = systemDate;
                        cList.add(c);
                    }
                    
                }
            }
        }
        
        update accs;
        update cList;
    }

}
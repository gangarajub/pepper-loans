global virtual class GLCSVFileGenerationJob 
                extends loan.MFiFlexBatchJob implements Schedulable,DataBase.Stateful {
    
    private Integer batchSize;
    private Static String NAME = 'FINANCE REPORT';  
    loan.GlobalLoanUtilFacade info = new loan.GlobalLoanUtilFacade();
    private Date iDate = info.getCurrentSystemDate();
    public Map<String, FinanceReportCSVFileFormat> mapGLCodeToReport = new Map<String, FinanceReportCSVFileFormat>();
    
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
                                'loan__Interest_Remaining__c, ' +
                                'loan__Loan_Status__c, ' +
                                'loan__Loan_Product_Name__c, ' + 
                                'Channel__c ' + 
                                'from loan__Loan_Account__c ' +
                                'WHERE loan__Loan_Status__c ' +
                                'IN (' + allowabledLoanStatuses + ') ';
    
            //Query needs to be refined... 
            //add date in where clause...
    
    }
    
    global GLCSVFileGenerationJob() {
        super(NAME,null);
        this.batchSize = 100; //loan.CustomSettingsUtil.getBatchSize();
        this.iDate = iDate;
        mapGLCodeToReport = new Map<String, FinanceReportCSVFileFormat>();
    }
    
    override global virtual database.querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }
    
    global GLCSVFileGenerationJob(Date iDate, Integer batchSize) {
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
        GLCSVFileGenerationJob job = new GLCSVFileGenerationJob();
        Database.executeBatch(job,job.batchSize);
    }
    
    public virtual override void submitNextJob() {  } //do nothing
    
    public override void doStart(Database.BatchableContext bc) { } //do nothing
    
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
        List<loan__Loan_Account__c> loanAccounts = (List<loan__Loan_Account__c>) scope;
        System.debug('Finance Report Job : ' + loanAccounts.size());
        GLCSVFileGenerationJobHandler j = new GLCSVFileGenerationJobHandler(iDate);
        //List<String> entries = new List<String>();
        System.debug('Input map : ' + mapGLCodeToReport);
        mapGLCodeToReport = j.process(loanAccounts, mapGLCodeToReport);
        System.debug('mapGLCodeToReport : ' + mapGLCodeToReport);
        //if(entries != null && entries.size() > 0){
        //    fileEntries.addAll(entries);
        //}
        //counter = j.getCounter();
    }
    
    public override void doFinish(Database.BatchableContext bc) {
        
        String fileBody = '\"FORMAT BATCH IMPORT, STANDARD 1.0\"\r\n';
        fileBody += 'DOCID,DREF1,DSOURCE,DPERIOD,DTYPE,DCLRENTITY,DENTITYPE,LINEID,LNEDETAILTYPE,LLDGCODE,LACCNBR,LAMOUNT1,LNARR1,LNARR2,LNARR3,BIMPNAME,BNAME,BGROUP,BDESCR,BNARR1,BNARR2,BNARR3,BFORMAT,BDOCTYPE,BPERIOD,BPROGRP,BSUSPLDGCODE,BSUSPACCNBRI,BBALLDG,BBALACCNBR,BDATE,BCLRENTITY,BSTATUS,LGSTTYPE,LGSTRATECODE';
        fileBody += '\r\n';
        if(mapGLCodeToReport != null && mapGLCodeToReport.size() > 0){
            for(String s : mapGLCodeToReport.keySet()){
                fileBody += mapGLCodeToReport.get(s).getEntry();
            }
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
        
        String currentTime =String.valueOf(iDate) + ' :: ' + Datetime.now();
        Document d = new Document();
        d.Name = Name+ '_' + currentTime +'.csv';
        d.Body = Blob.valueOf(fileBody);
        d.ContentType = 'text/csv';
        d.Type = 'csv';
        d.Description='';
        d.folderid = folderId;
        insert d;
    
        
    }
    
}
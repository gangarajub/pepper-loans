global class EDXRegStatJob implements Database.Batchable<sObject>,Schedulable, Database.AllowsCallouts{
    public Date sodDate;
    public Boolean submitNextJob=false;
    public Integer batchSize;
    public String query;
    List<Attachment> attachDoc=new List<Attachment>();
    List<EDX_Registration_Status__c> regStat= new List<EDX_Registration_Status__c>();
    List<EDX_Registration_Status_Res__c> listRes=new List<EDX_Registration_Status_Res__c>();
    List<ints.EDXRegistrationStatusRes> edxRes= new List<ints.EDXRegistrationStatusRes>();
    List<clcommon__collateral__c> listColl=new List<clcommon__collateral__c>();
    global EDXRegStatJob(){
        
    }
    global EDXRegStatJob(String query, Boolean submitNextJob){
        if(query==null)
            this.query=EDXQueryBuilder.createStatQuery();
        else
            this.query =query;
        this.submitNextJob = submitNextJob;
        this.batchSize=10;
    }
    public Integer getBatchSize(){
        return this.batchSize;
    }
    public  void submitNextJob(){
        if(!submitNextJob)
            return;
        String query = EDXQueryBuilder.createDisQuery();
        
        EDXDischargeRegJob disReg = new EDXDischargeRegJob(query, true);
        ID batchprocessid = Database.executeBatch(disReg, 10); 
    }
    public  database.querylocator start(Database.BatchableContext bc){
        if(query==null){
            query=EDXQueryBuilder.createStatQuery();
        }
        return Database.getQueryLocator(query);
        // nothing needs to be done here...we just need the results of the query
    }
    public  void execute(Database.BatchableContext bc,List<sObject> scope){
        List<loan__Loan_Collateral__c> equip =  (List<loan__Loan_Collateral__c>) scope;
        Set<Id> collateralIds = new Set<Id>();
        for(loan__Loan_Collateral__c collObj: equip){
            system.debug(collObj);
            collateralIds.add(collObj.Collateral__c);
        }
        for(Id collObjId: collateralIds){         
            EDXRegStatAPI handler = new EDXRegStatAPI(collObjId);
            regStat.addall(handler.getData());
            listRes.add(handler.getRes());
            listColl.add(handler.getColl());
            attachDoc.addAll(handler.storeAttachments());
        }
        insert attachDoc;
        upsert listRes;        
        for(EDX_Registration_Status__c ed: regStat){
            system.debug([select id from EDX_Registration_Status_Res__c where Collateral__c=:ed.Collateral_Id__c order by CreatedDate desc]);
            ed.EDX_Registration_Status_Res__c=[select id from EDX_Registration_Status_Res__c where Collateral__c=:ed.Collateral_Id__c order by CreatedDate desc limit  1].id;
        }        
        upsert regStat;
       
        for(clcommon__collateral__c coll:listColl){         
           coll.EDXRegNumber__c=[select registration_Number__c from EDX_Registration_Status__c where Collateral_Id__c=:coll.id limit 1].registration_Number__c;
        }
        upsert listColl;       
        system.debug(logginglevel.error,'Insert Interest List:'+listRes); 
    }
    public void execute(SchedulableContext sc){
        loan.GlobalLoanUtilFacade currentDt= new loan.GlobalLoanUtilFacade();
        //checks the customized batch size, if null then 100 batch size is populated 
        if(loan.CustomSettingsUtil.getBatchSize()==null){
            batchSize=10;
        }
        else{
            batchSize=loan.CustomSettingsUtil.getBatchSize();
        }        
        query =EDXQueryBuilder.createStatQuery();
        system.debug(logginglevel.error,' query :'+query);
        EDXRegStatJob job = new EDXRegStatJob(query,true);
        Database.executeBatch(job, batchSize);
    }
    public  void finish(Database.BatchableContext bc){
    }
}
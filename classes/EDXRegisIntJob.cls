global class EDXRegisIntJob implements Database.Batchable<sObject>,Schedulable, Database.AllowsCallouts{
    public Date sodDate;
    public Boolean submitNextJob=false;
    public Integer batchSize;
    public String query;
    List<Edx_Register_Data__c> resData= new List<Edx_Register_Data__c>();
    List<EDX_Register_Interest__c> listIn=new List<EDX_Register_Interest__c>();
    List<clcommon__collateral__c> listColl=new List<clcommon__collateral__c>();
    global EDXRegisIntJob(){
        
    }
    global EDXRegisIntJob(String query, Boolean submitNextJob){
        if(query==null)
            this.query=EDXQueryBuilder.createInterestQuery();
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
        String query = EDXQueryBuilder.createStatQuery();
        
        EDXRegStatJob statReg = new EDXRegStatJob(query, true);
        ID batchprocessid = Database.executeBatch(statReg, 10); 
    }
    public  database.querylocator start(Database.BatchableContext bc){
        if(query==null){
            query=EDXQueryBuilder.createInterestQuery();
        }
        return Database.getQueryLocator(query);
        // nothing needs to be done here...we just need the results of the query
    }
    public  void execute(Database.BatchableContext bc,List<sObject> scope){
        List<loan__Loan_Collateral__c> equip = (List<loan__Loan_Collateral__c>) scope;
        system.debug(equip);
        Set<Id> collateralIds = new Set<Id>();
        for(loan__Loan_Collateral__c collObj: equip){
            collateralIds.add(collObj.Collateral__c);
        }
        for(Id collObjId: collateralIds){
            EDXCreateRegIntegAPI handler = new EDXCreateRegIntegAPI(collObjId);
            handler.disReg();            
            resData.add(handler.getData());            
            listIn.add(handler.getInt());
            listColl.add(handler.getColl());           
        }
        upsert listIn;
        for(Edx_Register_Data__c ed: resData){
            ed.EDX_Register_Interest__c=[select id from EDX_Register_Interest__c where Collateral__c=:ed.Collateral_Id__c order by CreatedDate desc][0].id;
        }
        upsert resData; 
        for(clcommon__collateral__c co: listColl){
            
            co.vehicle_Registration_Id__c=[select id, registrationIds__c from Edx_Register_Data__c where Collateral_Id__c=:co.id order by CreatedDate desc][0].registrationIds__c;
        }
        
        upsert listColl;
        system.debug(logginglevel.error,'Insert Interest List:'+listIn); 
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
        query =EDXQueryBuilder.createInterestQuery();
        system.debug(logginglevel.error,' query :'+query);
        EDXRegisIntJob job = new EDXRegisIntJob(query,false);
        Database.executeBatch(job, batchSize);
    }
    public  void finish(Database.BatchableContext bc){
    }
}
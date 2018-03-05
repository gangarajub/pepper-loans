global class EDXDischargeRegJob implements Database.Batchable<sObject>,Schedulable, Database.AllowsCallouts{
    public Date sodDate;
    public Boolean submitNextJob=false;
    public Integer batchSize;
    public String query;
    List<EDX_Discharge_Data__c> resData= new List<EDX_Discharge_Data__c>();
    List<EDX_Discharge_Response__c> listRes=new List<EDX_Discharge_Response__c>();
    List<clcommon__collateral__c> listColl=new List<clcommon__collateral__c>();
    global EDXDischargeRegJob(){}
    global EDXDischargeRegJob(String query, Boolean submitNextJob){
        if(query==null)
            this.query=EDXQueryBuilder.createDisQuery();
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
    }
    public  database.querylocator start(Database.BatchableContext bc){
        if(query==null)
            query =EDXQueryBuilder.createDisQuery();
        return Database.getQueryLocator(query);
        // nothing needs to be done here...we just need the results of the query
    }
    public  void execute(Database.BatchableContext bc,List<sObject> scope){
        List<loan__Loan_Collateral__c> equip =  (List<loan__Loan_Collateral__c>) scope;
        Set<Id> collateralIds = new Set<Id>();
        for(loan__Loan_Collateral__c collObj: equip){
            collateralIds.add(collObj.Collateral__c);
        }
        for(Id collObjId: collateralIds){
            EDXDischargeRegistrationAPI handler = new EDXDischargeRegistrationAPI(collObjId);
            handler.disReg();
            resData.addALL(handler.getData());
            listRes.add(handler.getDis());
            listColl.add(handler.getColl());
        }
        upsert listRes;
        Integer lenDisData=resData.size();
        while(lenDisData>0){
            resData[lenDisData-1].EDX_Discharge_Response__c=[select id from EDX_Discharge_Response__c where Collateral__c=:resData[lenDisData-1].Collateral_Id__c order by CreatedDate desc][0].id;
            lenDisData--;
        }
        upsert resData;
        for(clcommon__collateral__c coll:listColl){
            if([select id,has_Errors__c from EDX_Discharge_Data__c where Collateral_Id__c=:coll.id order by createddate limit 1][0].has_Errors__c== false)
                coll.isDischarged__c=true;
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
        else
        {
            batchSize=loan.CustomSettingsUtil.getBatchSize();
        }
        date currentDate = currentDt.getCurrentSystemDate();                         
        query =EDXQueryBuilder.createDisQuery();
        system.debug(logginglevel.error,' query :'+query);
        EDXDischargeRegJob job = new EDXDischargeRegJob(query,false);
        Database.executeBatch(job, batchSize);
    }
    public  void finish(Database.BatchableContext bc){
    }
}
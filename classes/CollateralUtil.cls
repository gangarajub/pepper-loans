public class CollateralUtil{
    public CollateralUtil(){
        
    }
    
    public clcommon__Collateral_Valuation__c storeValuation(String redBookKey,String redBookVehicleSeries,String collateralId,Date appraisalDate,Decimal appraisedValue){
        clcommon__Collateral_Valuation__c cVal = new clcommon__Collateral_Valuation__c();
        if(String.isBlank(redBookKey)|| String.isBlank(redBookVehicleSeries) || String.isBlank(collateralId) || appraisalDate==null || appraisedValue == null){
            throw(new MyException('Input Parameter missing.'));
        }
        cVal.clcommon__Appraisal_Date__c = appraisalDate;
        cVal.clcommon__Appraised_Value__c = appraisedValue;
        cVal.clcommon__Collateral__c = collateralId;
        cVal.Red_Book_Key__c = redBookKey;
        cVal.Red_Book_Vehicle_Series__c = redBookVehicleSeries;
        insert cVal;
        return cVal;
    }
    
    public Decimal getLVRPercent(String collateralId, String applicationId){
        if(String.isBlank(collateralId) || String.isBlank(applicationId)){
            throw(new MyException('Input Parameters missing.'));
        }
        Decimal lVr = 0;
        List<clCommon__Collateral_Valuation__c> cVals = [select id, clcommon__Appraised_Value__c from clCommon__Collateral_Valuation__c where clcommon__Collateral__c=:collateralId order by Createddate desc];
        List<genesis__Applications__c> apps = [select id, genesis__Loan_Amount__c from genesis__Applications__c where id=:applicationId ];
        if(cVals.size()>0 && apps.size()>0){
            lVr = apps[0].genesis__Loan_Amount__c/cVals[0].clcommon__Appraised_Value__c*100;
        }
        
        apps[0].lVr_Percent__c = lVr;
        update apps[0];
        return lVr; 
    }
    
    public genesis__Applications__c checkStolenOrwrittenOffApp(String collateralId,String applicationId){
        List<clcommon__Collateral__c> coll = [select id,Summary__r.Stolen__c,Summary__r.writtenOff__c from clcommon__Collateral__c where Id=:collateralId];
        List<genesis__Applications__c> app = [select id,genesis__Status__c,Referred_Reason__c from genesis__Applications__c where Id=:applicationId];
        if(coll.size()>0 && app.size()>0 && coll[0].summary__r!=null){
            if(coll[0].summary__r.Stolen__c!=null && coll[0].summary__r.writtenOff__c!=null && (coll[0].summary__r.Stolen__c.equalsIgnoreCase('fail') || coll[0].summary__r.writtenOff__c.equalsIgnoreCase('fail')) ){
                app[0].genesis__Status__c = 'REFERRED';
                app[0].Referred_Reason__c = 'CAR HISTORY CHECK FAIL';
                update app;
            }
        }
        return app[0];
    }
}
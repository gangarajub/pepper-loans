global class EDXDischargeButton {
    
    webservice static void disInterest(String collId){
        List<EDX_Discharge_Data__c> exp= new List<EDX_Discharge_Data__c>();
        List<EDX_Discharge_Response__c> listRes=new List<EDX_Discharge_Response__c>();
        List<clcommon__collateral__c> listColl=new List<clcommon__collateral__c>();
        if([select id,name,loan__Loan__r.loan__Loan_Status__c FROM loan__Loan_Collateral__c WHERE Collateral__c=:collId and Collateral__r.isDischarged__c=false and Collateral__r.sent_for_registration__c =true and loan__Loan__r.Is_Secured__c = true and loan__Loan__r.loan__Loan_Status__c ='Closed - Obligations met'].size()>0){
            
                
            EDXDischargeRegistrationAPI handler = new EDXDischargeRegistrationAPI(collId);
            try{
            handler.disReg();
            exp.addALL(handler.getData());
            listRes.add(handler.getDis());
            listColl.add(handler.getColl());
            upsert listRes;
            Integer lenDisData=exp.size();            
            while(lenDisData>0){
                exp[lenDisData-1].EDX_Discharge_Response__c=[select id from EDX_Discharge_Response__c where Collateral__c=:exp[lenDisData-1].Collateral_Id__c order by CreatedDate desc][0].id;
                lenDisData--;
            }
            upsert exp;
            for(clcommon__collateral__c coll:listColl){
                if([select id,has_Errors__c from EDX_Discharge_Data__c where Collateral_Id__c=:coll.id order by createddate limit 1][0].has_Errors__c== false)
                coll.isDischarged__c=true;
            }
            upsert listColl;
            system.debug(logginglevel.error,'Insert Interest List:'+listRes);
            } catch(Exception ex){
                system.debug('Error Message'+ex.getMessage());
            }
        }
    }
    
}
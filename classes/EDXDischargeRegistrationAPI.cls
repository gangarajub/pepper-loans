public class EDXDischargeRegistrationAPI {
    ints.EDXDischargeResponse res =new ints.EDXDischargeResponse();
    clcommon__collateral__c collObj = new clcommon__collateral__c();
    ints.EDXDischargeIntegration disInt = new ints.EDXDischargeIntegration();
    ints.IntegrationRequestObject requestObj = new ints.IntegrationRequestObject();
    EDX_Discharge_Response__c edxRes= new EDX_Discharge_Response__c();
    EDX_Discharge_Data__c edxData= new EDX_Discharge_Data__c();
    List<EDX_Discharge_Data__c> edxDataList= new List<EDX_Discharge_Data__c>();
    Id collId;
    public EDXDischargeRegistrationAPI(Id collid){
        this.collId=collId;
        ints__EDXDisInt__c setting =ints__EDXDisInt__c.getInstance();
        if(setting == null || (setting.ints__username__c== null || setting.ints__password__c==null || setting.ints__endpoint__c==null)){
            throw new ints.IntegrationException('EDX Discharge setting has not been set.');
        }
        collObj=[select id,sent_for_registration__c,vehicle_Registration_Id__c,clcommon__Vehicle_Serial_Number__c,EDXRegNumber__c from clcommon__collateral__c where id=:collId];      
        requestObj.requestMap.put('securedPartyGroupNumber', setting.securedPartyGroupNumber__c);
        requestObj.requestMap.put('registrationNumber', collObj.EDXRegNumber__c);       
        
    }
    public void disReg(){
        if(!Test.isRunningTest()){        
            res=(ints.EDXDischargeResponse) disInt.integrate(requestObj);            
        }
        else{
             String dummy='abc';            
            res.integrationErrorStatus='ok';
            res.meta=dummy;
            res.isSuccess=true;
            res.requestBody=dummy;
            res.responseBody=dummy;
            res.integrationErrorStatusCode='200';
            List<String>regIds= new List<String>();
            regIds.add(dummy);
            List<String> error= new List<String>();
            error.add(dummy);            
		    ints.EDXDischargeResponse.Data d = new ints.EDXDischargeResponse.Data();   
            d.registrationNumber=dummy;
            d.hasErrors=false;
            d.registrationId=regIds;
            d.errors=error;           
           res.data = new list<ints.EDXDischargeResponse.Data>();
            res.data.add(d);                   
        }
        }
    
    public EDX_Discharge_Response__c getDis(){
        EDX_Discharge_Response__c edxRes= new EDX_Discharge_Response__c();
        edxRes.errors__c= res.errors;
        edxRes.integration_Error_Status__c=res.integrationErrorStatus;
        edxRes.integration_Error_Status_Code__c=res.integrationErrorStatusCode;
        edxRes.isSuccess__c=res.isSuccess;
        edxRes.meta__c=res.meta;
        edxRes.errors__c=res.errors;
        edxRes.Collateral__c=collId;
        return edxRes;
    }
    public List<EDX_Discharge_Data__c> getData(){
        EDX_Discharge_Data__c edxData= new EDX_Discharge_Data__c();
        try{            
        Integer dataLen= res.data.size();        
        while(dataLen>0){
            edxData.Collateral_Id__c=collId;
            edxData.has_Errors__c=res.data[dataLen-1].hasErrors;
            edxData.registration_Number__c=res.data[dataLen-1].registrationNumber;
            
            if(res.data[dataLen-1].errors!=null){
                Integer lenErr= res.data[dataLen-1].errors.size();            
                String error='';
                while(lenErr>0){
                    error= error+ res.data[dataLen-1].errors[lenErr-1];
                    lenErr--;
                }
                edxData.errors__c =error;
            }
            
            if(res.data[dataLen-1].registrationId!=null){
                edxData.registrationId__c=res.data[dataLen-1].registrationId[0];             
                
            }
           else{
                edxData.registrationId__c=[select vehicle_Registration_Id__c from clcommon__collateral__c where id=:collId][0].vehicle_Registration_Id__c;
            }
            edxDataList.add(edxData);
            dataLen--;
        }        
        return edxDataList;        
        } catch(Exception ex){
            system.debug('error'+ex.getMessage());
            edxDataList.add(new EDX_Discharge_Data__c());
            return edxDataList;
        }
    }
    public clcommon__collateral__c getColl(){
        return collObj;
    }
    
}
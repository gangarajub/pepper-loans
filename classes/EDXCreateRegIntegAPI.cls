public class EDXCreateRegIntegAPI {
    ints.EDXCreateRegIntegrationRes res =new ints.EDXCreateRegIntegrationRes();
    ints.EDXCreateRegIntegration disInt=new ints.EDXCreateRegIntegration();    
    ints.IntegrationRequestObject requestObj = new ints.IntegrationRequestObject();
    clcommon__collateral__c collObj = new clcommon__collateral__c();
    EDX_Register_Interest__c edxRes= new EDX_Register_Interest__c();
    Edx_Register_Data__c edxData= new Edx_Register_Data__c();
    Id collId;
    public EDXCreateRegIntegAPI(Id collId){        
        this.collId=collId;
        ints__EDXCrtReg__c setting =ints__EDXCrtReg__c.getInstance();
        if(setting == null || (setting.ints__username__c== null || setting.ints__password__c==null || setting.ints__endpoint__c==null|| setting.securedPartyGroupNumber__c==null || setting.refinanceContractTypeCode__c == null || setting.vehicleContractTypeCode__c == null || setting.givingOfNoticeIdentifier__c==null||setting.sequenceNumber__c==null||setting.serialNumberType__c==null)){
            throw new ints.IntegrationException('EDX Discharge setting has not been set.');
        }
        
        //Changes made by Chirag on 14-03-17 for introducing different contract type code basis application purpose
        collObj = [select id,
                          sent_for_registration__c,
                          vehicle_Registration_Id__c,
                          clcommon__Vehicle_ID_Number__c,
                          pep_Registration_Number__c,
                          genesis__application__r.genesis__cl_purpose__r.name,
                          genesis__application__r.CL_Contract__r.name
                     from clcommon__collateral__c 
                    where id=:collId];

        if(System.label.PURPOSE_VEHICLE_LOAN.equalsIgnoreCase(collObj.genesis__application__r.genesis__cl_purpose__r.name)){
            requestObj.requestMap.put('contractTypeCode', setting.vehicleContractTypeCode__c);
        }
        else{
            requestObj.requestMap.put('contractTypeCode', setting.refinanceContractTypeCode__c);
        }
        
        if(collObj.genesis__application__r.CL_Contract__r.name != null){
            requestObj.requestMap.put('givingOfNoticeIdentifier', collObj.genesis__application__r.CL_Contract__r.name);
        }
        else{
            requestObj.requestMap.put('givingOfNoticeIdentifier', setting.givingOfNoticeIdentifier__c);
        }


        requestObj.requestMap.put('securedPartyGroupNumber', setting.securedPartyGroupNumber__c);
        //requestObj.requestMap.put('givingOfNoticeIdentifier', setting.givingOfNoticeIdentifier__c);
        requestObj.requestMap.put('sequenceNumber', setting.sequenceNumber__c);
        requestObj.requestMap.put('serialNumberType', setting.serialNumberType__c);
        requestObj.requestMap.put('serialNumber', collObj.clcommon__Vehicle_ID_Number__c);
        requestObj.requestMap.put('vehicleRegistrationNumber', collObj.pep_Registration_Number__c);
        edxRes.Collateral__c=collId;  
        
    }
    public void disReg(){
        if(!Test.isRunningTest()){                    
            System.debug('My Request : ' + requestObj);
            res=(ints.EDXCreateRegIntegrationRes) (disInt).integrate(requestObj);   
            System.debug('My Response : ' + res);     
        }
        else{
            String dummy='abc';
            res.integrationErrorStatus='ok';
            res.meta=dummy;
            res.isSuccess=true;
            res.requestBody=dummy;
            res.responseBody=dummy;
            List<String> error= new List<String>();
            error.add(dummy);
            res.errors=error;
            res.integrationErrorStatusCode='200'; 
            List<String>regIds= new List<String>();
            regIds.add(dummy);
            ints.EDXCreateRegIntegrationRes.Edx d= new ints.EDXCreateRegIntegrationRes.Edx();
            d.hasErrors=false;            
            d.registrationIds=regIds;
            d.errors=error;
            res.data=new ints.EDXCreateRegIntegrationRes.Edx();           
            res.data=d;       
           
        }
    }
    public EDX_Register_Interest__c getInt(){
        edxRes.Collateral__c=collId;
        edxRes.isSuccess__c= res.isSuccess;
        edxRes.meta__c= res.meta;
        if(edxRes.integrationErrorStatus__c == null){
            edxRes.integrationErrorStatus__c='ok';
            edxRes.integrationErrorStatusCode__c='200';
        }
        else{
            edxRes.integrationErrorStatus__c=res.integrationErrorStatus;
            edxRes.integrationErrorStatusCode__c=res.integrationErrorStatusCode;
        }
        return edxRes;
    }
    public clcommon__collateral__c getColl(){
        collObj.sent_for_registration__c=true;
        return collObj;
    }
    public Edx_Register_Data__c getData(){    
        
        edxData.Collateral_Id__c=collId;      
             
        if(res.data.errors!=null){
             edxData.hasErrors__c=res.data.hasErrors;  
            Integer lenErr= res.data.errors.size();            
            String error='';
            while(lenErr>0){
                error= error+ res.data.errors[lenErr-1];
                lenErr--;
            }
            edxData.errors__c =error;
        }
        
        if(res.data.registrationIds!=null){
            Integer lenRegId= res.data.registrationIds.size();
            while(lenRegId>0){
                edxData.registrationIds__c=res.data.registrationIds[lenRegId-1];
                
                lenRegId--;
            }
        }
        
        return edxData;
    }
    
}
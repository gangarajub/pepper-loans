public class EDXRegStatAPI {
    ints.EDXRegistrationStatusRes res =new ints.EDXRegistrationStatusRes();
    clcommon__collateral__c collObj = new clcommon__collateral__c();
    ints.EDXRegistrationStatusIntegration disInt = new ints.EDXRegistrationStatusIntegration();
    ints.IntegrationRequestObject requestObj = new ints.IntegrationRequestObject();
    EDX_Registration_Status_Res__c edxRes= new EDX_Registration_Status_Res__c();
    List<ints.EDXRegistrationStatusRes> edxResList= new List<ints.EDXRegistrationStatusRes>();
    EDX_Registration_Status__c edxData= new EDX_Registration_Status__c();
    list<Edx_Register_Data__c> regObj= new list<Edx_Register_Data__c>();
    
    List<EDX_Registration_Status__c> edxDataList= new List<EDX_Registration_Status__c>();
    Id collId;
    public EDXRegStatAPI(Id collId){
        this.collId= collId;
        ints__EDXRegStatSettings__c setting =ints__EDXRegStatSettings__c.getInstance();
        if(setting == null || (setting.ints__username__c== null || setting.ints__password__c==null || setting.ints__endpoint__c==null)){
            throw new ints.IntegrationException('EDX Stat setting has not been set.');
        }
        try{
            regobj.add([SELECT ID, name,registrationIds__c, EDX_Register_Interest__r.Collateral__r.EDXRegNumber__c, EDX_Register_Interest__r.Collateral__r.sent_for_registration__c, EDX_Register_Interest__r.Collateral__r.isDischarged__c,EDX_Register_Interest__r.Collateral__c FROM Edx_Register_Data__c WHERE EDX_Register_Interest__r.Collateral__r.EDXRegNumber__c =null   and registrationIds__c !=null and EDX_Register_Interest__r.Collateral__r.sent_for_registration__c =true and EDX_Register_Interest__r.Collateral__c=:colliD order by createdDate desc limit 1]);
            requestObj.requestMap.put('registrationIds',regobj[0].registrationIds__c);        
            disReg();
        }catch(Exception ex){
            system.debug('-----Error------'+ex.getMessage());
            return;
        }
        
    }
    public void disReg(){
        if(!Test.isRunningTest()){                          
            res=(ints.EDXRegistrationStatusRes) disInt.integrate(requestObj);             
            edxResList.add(res);               
        }else{
            system.debug('hi');
            String dummy='abc';            
            
            res.integrationErrorStatus='ok';
            res.meta=dummy;
            res.isSuccess=true;
            res.requestBody=dummy;
            res.responseBody=dummy;
            List<String> error= new List<String>();
            error.add(dummy);
            List<String>regIds= new List<String>();
            regIds.add(dummy);
            res.errors=error;
            res.integrationErrorStatusCode='200';
            res.data= new ints.EDXRegistrationStatusRes.Edx();
            ints.EDXRegistrationStatusRes.RegistrationStatus regStat= new ints.EDXRegistrationStatusRes.RegistrationStatus();
            regStat.registrationId=dummy;
            regStat.status=dummy;
            regStat.errorMessage=dummy;
            regStat.isFinalStatus=false;
            regStat.esisId=dummy;
            regStat.registrationNumber=dummy;
            ints.EDXRegistrationStatusRes.edx ed= new ints.EDXRegistrationStatusRes.Edx();
            List<ints.EDXRegistrationStatusRes.RegistrationStatus> edr= new List<ints.EDXRegistrationStatusRes.RegistrationStatus>();
            edr.add(regStat);
            ed.registrationStatus=edr;
            res.data=ed;
            edxResList.add(res);
            system.debug(edxResList);
           // res.data=regStat;
            
            // res.errors[0]=dummy;
            
        }
        
    }
    public EDX_Registration_Status_Res__c getRes(){
        EDX_Registration_Status_Res__c edxRes= new EDX_Registration_Status_Res__c();
        if(res.errors!=null){
            Integer lenErr= res.errors.size();            
            String error='';
            while(lenErr>0){
                error= error+ res.errors[lenErr-1];
                lenErr--;
            }
            edxRes.errors__c =error;
        }           
        edxRes.Collateral__c=collId;
        edxRes.integrationErrorStatus__c=res.integrationErrorStatus;
        edxRes.integrationErrorStatusCode__c=res.integrationErrorStatusCode;
        edxRes.isSuccess__c=res.isSuccess;
        edxRes.meta__c=res.meta;            
        return edxRes;
    }
    public List<Attachment> storeAttachments(){
        List<Attachment> attachDoc=new List<Attachment>();
        Attachment attachRes = new Attachment();
        attachRes.Body = Blob.valueOf((String)res.responseBody);
        attachRes.name =  'Registration Status response body - ' + datetime.now() + '.xml';
        attachRes.parentId = collId;
        attachRes.contentType = 'text/xml';
        attachDoc.add(attachRes);
        /*attachment for request*/
        Attachment attachReq = new Attachment();
        attachReq.Body = Blob.valueOf((String)res.requestBody);
        attachReq.name =  'Registration Status request body - ' + datetime.now() + '.xml';
        attachReq.parentId = collId;
        attachReq.contentType = 'text/xml';
        attachDoc.add(attachReq);
        return attachDoc;
    }
    public List<EDX_Registration_Status__c> getData(){
        EDX_Registration_Status__c edxData= new EDX_Registration_Status__c();        
        
        edxData.Collateral_Id__c=collID;
        Integer dataLen1= edxResList.size();
        Integer dataLen= edxResList[0].data.registrationStatus.size();        
        while(dataLen>0){
            edxData.error_Message__c=edxResList[0].data.registrationStatus[dataLen-1].errorMessage;
            edxData.esisId__c=edxResList[0].data.registrationStatus[dataLen-1].esisId;
            edxData.is_Final_Status__c=edxResList[0].data.registrationStatus[dataLen-1].isFinalStatus;
            edxData.registration_Id__c=edxResList[0].data.registrationStatus[dataLen-1].registrationId;            
            edxData.registration_Number__c=edxResList[0].data.registrationStatus[dataLen-1].registrationNumber;
            edxData.status__c=edxResList[0].data.registrationStatus[dataLen-1].status;
            edxDataList.add(edxData);
            dataLen--;
        }        
        return edxDataList;        
        
    }
    public clcommon__collateral__c getColl(){
        return [select id,sent_for_registration__c,EDXRegNumber__c,clcommon__Vehicle_Serial_Number__c,pep_Registration_Number__c from clcommon__collateral__c where id=:collId];
    }
    
}
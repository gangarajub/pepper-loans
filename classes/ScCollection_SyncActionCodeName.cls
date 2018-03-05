/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_SyncActionCodeName 
Company:       Saasfocus
Description:   This class is use to sync the action code.
History
Date    :  22/04/2017     
------------------------------------------------------------*/
global class ScCollection_SyncActionCodeName{
    
    //wrapper for Action code integration.
    public class InputWrapper{
    
         public String countryCode{get;set;}
         public String lob{get;set;}
         public String usernEmailAddress{get;set;}
         public String collectionsActivityDescriptionCDE{get;set;}
         public String collectionsActivityDescriptionICM{get;set;}
         
         public String parse(){
            return  System.JSON.serialize(this);
         }
         
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SyncActionCodeNameToJackson
    Company:       Saasfocus
    Description:   This method is used to sync action code in the source system.
    Inputs:        String,String,Id
    Returns:       String
    -----------------------------------------------------------------------------------*/
    webservice static String SyncActionCodeNameToJackson(String actionCodeName,String actionCodeOldName,Id recordId){
        
        if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_SyncActionCodeName')){
            return 'Integration to Jackson is not enable yet. Please enable it from Custom Setting -> Trigger Execution Setting';
        }
        
        String responseString ;
        String errorCode;
        Boolean isError = false;
        
        String userEmail = [Select Id,Email from User where Id = :UserInfo.GetUserId()].Email;
        String apiParameterName = 'ActivitySyncCode';
        String apiParameterError = 'GetErrorLog';
        string apiResponse;
        String apiResponseError;
        ScCollection_MeetingNotesResponseSuccess responseApi;
        ScCollection_MeetingNotesResponseSuccess responseApiError;
        InputWrapper objWrapper = new InputWrapper();
        objWrapper.countryCode = 'AU';
        objWrapper.lob = 'mortgage';
        objWrapper.usernEmailAddress = userEmail ;
        objWrapper.collectionsActivityDescriptionICM = actionCodeName;
        
        if(!string.isBlank(actionCodeOldName) ){
        
            objWrapper.collectionsActivityDescriptionCDE = actionCodeOldName;
        }
        else{
            objWrapper.collectionsActivityDescriptionCDE = actionCodeName;
        }
        
        try{
            ScCollection_PaymentAPIParameters__c objcred = ScCollection_PaymentAPIParameters__c.getValues(apiParameterName);
            
            String apiUrl = objcred.Endpoint__c;
            String str = objWrapper.parse();
            // API to sync Action Code Name 
            Http objhttp = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(apiUrl);
            req.setMethod('POST');
            Blob headerValue = Blob.valueOf(objcred.Username__c+ ':' + objcred.Password__c);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(120000);
            req.setBody(str);
            system.debug('Request action code :'+str);
            HttpResponse res = objhttp.send(req);
            apiResponse =  res.getBody();
            system.debug('Response action code :'+apiResponse );
            if(apiResponse != null){
                collect__Action_Code__c objActionCode = new collect__Action_Code__c();
                objActionCode.Id = recordId;
                    
                responseApi = ScCollection_MeetingNotesResponseSuccess.parse(apiResponse);
                if(res.getStatusCode() == 200){
                    if(responseApi.APIStatus != null){
                        if(responseApi.APIStatus.APICode =='200'){
                            if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                    if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                        if(tempresponse.PepperReference.Reference != '99'){
                                            isError = True;
                                        }
                                        else{
                                            responseString = 'Success: Actvitiy code has been sync successfully.';
                                            objActionCode.ScCollection_Error_Message__c = null;
                                            update objActionCode;
                                            return responseString;
                                        }
                                    }
                                    if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                        errorCode = tempresponse.PepperReference.Reference;
                                    }
                                }
                            }
                        }
                        else{
                            
                            objActionCode.ScCollection_Error_Message__c = 'We have received again an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                            if(responseApi.APIStatus.Messages != null && responseApi.APIStatus.Messages.size()>0){
                                for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                    if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                        
                                        objActionCode.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription ;
                                    }
                                }
                            }
                        }
                    }
                }
                else if(res.getStatusCode() == 500){
                    if(responseApi.APIStatus !=null){
                        if(responseApi.APIStatus.APICode =='500'){
                            if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                    if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                        if(tempresponse.PepperReference.Reference != '99'){
                                            isError = True;
                                        }
                                    }
                                    if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                        errorCode = tempresponse.PepperReference.Reference;
                                    }
                                }
                            }
                        }
                    }
                }
                else if(res.getStatusCode() == 401){
                    if(responseApi.APIStatus !=null){
                        if(responseApi.APIStatus.APICode =='401'){
                            if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                    if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                        if(tempresponse.PepperReference.Reference != '99'){
                                            isError = True;
                                        }
                                    }
                                    if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                        errorCode = tempresponse.PepperReference.Reference;
                                    }
                                }
                            }
                        }
                    }
                }
                else{
                    objActionCode.ScCollection_Error_Message__c = 'Some error occured during the sync process. Request you to please try again.' ;
                    if(responseApi != null && responseApi.APIStatus != null){
                        if(responseApi.APIStatus.Messages != null && responseApi.APIStatus.Messages.size()>0){
                            for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                    
                                    objActionCode.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription ;
                                }
                            }
                        }
                    }
                }
                
                //If Error then API call to get Error msg
                if(isError && !String.isBlank(errorCode)){
                    String strResponse = ScCollection_CommonCodeHandler.GetErrorResponse(errorCode);  
                    objActionCode.ScCollection_Error_Message__c = strResponse ;
                }
                update objActionCode;
                return objActionCode.ScCollection_Error_Message__c;
            }
            
        }
        catch(Exception e){
            responseString = 'Error: ' + e.getMessage();
            collect__Action_Code__c objActionCode = new collect__Action_Code__c();
            objActionCode.Id = recordId;
            objActionCode.ScCollection_Error_Message__c = responseString;
            update objActionCode;
            return responseString;
        }
        
        return 'Some error occured during the sync process. Request you to please try again.';
  }
}
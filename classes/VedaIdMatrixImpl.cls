global with sharing class VedaIdMatrixImpl implements IService{
    VedaResponse resp ;
    genesis__Applications__c app;
    
    
    public void setRequest(String configId,VedaResponse vResp){
        this.resp = vResp;
        System.debug('vResp'+vResp.app.Id);
        List<genesis__Applications__c> app = [select id,name,Identification_Type__c,genesis__ID_State__c,Identification_Number__c,
                                              (select City__c,Country__c,Country_Code__c,PostCode__c,
                                               Property__c,State__c,Current_Address__c,
                                               Street_Number__c,Street_Type__c,
                                               Street_Type_Code__c,Suburb__c,Address__c,Internal_Address__c,
                                               Unit_Number__c,Street_Name__c from Residential_Address__r),
                                              genesis__Account__r.PersonBirthdate,genesis__Account__r.FirstName,genesis__Account__r.LastName,genesis__Account__r.MiddleName,
                                              genesis__Account__r.Gender__c,genesis__Account__r.Salutation,
                                              genesis__Account__r.PersonMobilePhone,genesis__Account__r.PersonOtherPhone,
                                              genesis__Account__r.PersonEmail,
                                              genesis__ID_Number__c,genesis__Loan_Amount__c
                                              from genesis__Applications__c 
                                              where id=:vResp.app.Id];
        
        
        Ints.IntegrationRequestObject requestObj = new Ints.IntegrationRequestObject(); 
        ints.IntegrationObjectFactory factroy = ints.IntegrationObjectFactory.getInstance(); 
        ints__IDMatrix__c vedaIdMatrix = ints__IDMatrix__c.getInstance();
        
        for(genesis__Applications__c  dp : app) {
            
            for(Residential_Address__c address : dp.Residential_Address__r) {
                
                if(address.Current_Address__c==true){
                    requestObj.requestMap.put('type_address_addresses_individual_enquiry-data_1',String.valueof(address.Current_Address__c));
                    system.debug('hello');
                    requestObj.requestMap.put('type_address_addresses_individual_enquiry-data_1','C');
                    
                    if(address.Address__c!=null){
                        
                        requestObj.requestMap.put('unformatted-address_current-address',address.Internal_Address__c.replaceAll(':',' ')); 
                    }else{ 
                        if(address.Street_Number__c!=null){
                            requestObj.requestMap.put('street-number_current-address',address.Street_Number__c);
                        }        
                        
                        if(address.Street_Name__c!=null){
                            requestObj.requestMap.put('street-name_current-address',address.Street_Name__c);
                        }
                        
                        if(address.Street_Type__c!=null){
                            requestObj.requestMap.put('street-type_current-address',address.Street_Type__c);
                        }
                        if(address.Suburb__c!=null){
                            requestObj.requestMap.put('suburb_current-address',address.Suburb__c);
                        }
                        
                        if(address.State__c!=null){
                            requestObj.requestMap.put('state_current-address',address.State__c);
                            
                            
                        }
                        
                        if(address.Property__c!=null){
                            requestObj.requestMap.put('property_current-address',address.Property__c);
                        }
                        
                        if(address.Unit_Number__c!=null){
                            requestObj.requestMap.put('unit-number_current-address',address.Unit_Number__c);
                        }
                        
                        if(address.PostCode__c!=null){
                            requestObj.requestMap.put('postcode_current-address',address.PostCode__c);
                        }
                        
                        
                    }
                    
                    
                    
                }    
                
                
            }
        }                                           
        
        
        
        
        if(app[0].genesis__Account__r.PersonBirthdate!=null){
            requestObj.requestMap.put('date-of-birth',String.valueof(app[0].genesis__Account__r.PersonBirthdate));    
            
        }
        
        if(app[0].genesis__Account__r.LastName!=null){
            requestObj.requestMap.put('family-name_individual-name',app[0].genesis__Account__r.LastName);    
            
        }
        
        if(app[0].genesis__Account__r.FirstName!=null){
            requestObj.requestMap.put('first-given-name_individual-name',app[0].genesis__Account__r.FirstName);    
            
        }
        if(app[0].genesis__Account__r.MiddleName!=null){
            requestObj.requestMap.put('other-given-name_individual-name',app[0].genesis__Account__r.MiddleName);    
            
        }
        
        
        if(app[0].genesis__Account__r.Gender__c!=null){
            requestObj.requestMap.put('gender',app[0].genesis__Account__r.Gender__c);    
            
        }
        
        if(app[0].genesis__Account__r.PersonMobilePhone!=null){
            requestObj.requestMap.put('home-phone-number_numbers_phone',app[0].genesis__Account__r.PersonMobilePhone);
            
        }
        
        if(app[0].genesis__Account__r.PersonMobilePhone!=null){
            requestObj.requestMap.put('mobile-phone-number_numbers_phone',app[0].genesis__Account__r.PersonMobilePhone);
            
        }
        
        if(app[0].genesis__Account__r.PersonOtherPhone!=null){
            requestObj.requestMap.put('work-phone-number_numbers_phone',app[0].genesis__Account__r.PersonOtherPhone);
            
        }
        
        if(app[0].genesis__Account__r.PersonEmail!=null){
            requestObj.requestMap.put('email-address',app[0].genesis__Account__r.PersonEmail);
            
        }
        
        /*
if(app[0].genesis__Account__r.PersonEmail!=null){
requestObj.requestMap.put('email-address',app[0].genesis__Account__r.PersonEmail);

}*/
        
        if(app[0].Identification_Type__c!=null && app[0].Identification_Type__c.equalsignorecase('Drivers Licence')){
            requestObj.requestMap.put('number_drivers-licence-details',app[0].Identification_Number__c); 
            if(!String.isBlank(app[0].genesis__ID_State__c)){
                requestObj.requestMap.put('state-code_drivers-licence-details',app[0].genesis__ID_State__c);   
            }
            
        }
        
        if(app[0].Identification_Type__c!=null && app[0].Identification_Type__c.equalsignorecase('Passport')){
            requestObj.requestMap.put('country-code_passport-details','AUS');
            requestObj.requestMap.put('number_passport-details',app[0].Identification_Number__c); 
        }
        
        
        
        System.debug('requestObj'+requestObj);
        String serialized = (String)JSON.serialize(requestObj.requestMap); 
        System.debug('serialized'+serialized);
        System.debug('request'+requestObj);
        
        
        ints.IDMatrixResponse res = new ints.IDMatrixResponse();
        if(Test.isRunningTest())
        {
            ints.IDMatrixResponse.rulesResult rules = new ints.IDMatrixResponse.rulesResult();
            ints.IDMatrixResponse.AnalysisResult analysis = new ints.IDMatrixResponse.AnalysisResult();
            ints.IDMatrixResponse.SearchResult search = new ints.IDMatrixResponse.SearchResult();
            ints.IDMatrixResponse.FraudAssessmentResponse assses = new ints.IDMatrixResponse.FraudAssessmentResponse();
            ints.IDMatrixResponse.AssessmentFactor factor = new ints.IDMatrixResponse.AssessmentFactor();
            ints.IDMatrixResponse.PhoneVerificationResponse phone = new ints.IDMatrixResponse.PhoneVerificationResponse();
            ints.IDMatrixResponse.DeviceIntelligenceResponse device = new ints.IDMatrixResponse.DeviceIntelligenceResponse();
            ints.IDMatrixResponse.VEVORecord vevo = new ints.IDMatrixResponse.VEVORecord();
            ints.IDMatrixResponse.SharedFraudRecord shared = new ints.IDMatrixResponse.SharedFraudRecord();
            ints.IDMatrixResponse.SharedFraudPhoneNumber phoneNo = new ints.IDMatrixResponse.SharedFraudPhoneNumber();
            ints.IDMatrixResponse.SharedFraudaddress  add = new ints.IDMatrixResponse.SharedFraudaddress();
            ints.IDMatrixResponse.AccuityResultsRecord accuity = new ints.IDMatrixResponse.AccuityResultsRecord();
            ints.IDMatrixResponse.SFD sdf = new ints.IDMatrixResponse.SFD();
            
            res.fraudAssessmentResponse.assessmentFactors.add(factor);
            res.sharedFraudRecord.phoneNumbers.add(phoneNo);
            res.sharedFraudRecord.addresses.add(add);
            res.accuityResultsRecord.sfd.add(sdf);
            res.rulesResults.add(rules);
            res.analysisResults.add(analysis);
            res.searchResults.add(search);
            res.phoneVerificationResponses.add(phone);
            res.vevoRecords.add(vevo);
            res.requestXMLBody = '13';
            res.responseXMLBody = '123';
        }
        else
        {
            res=(ints.IDMatrixResponse)factroy.getIntegrationObject('IDMatrix').integrate(requestObj);
            system.debug(res);
            //System.debug('response'+res.responseXMLBody);
            
            //System.debug('request'+res.requestXMLBody);
            
            
            if(res!= null && res.overallOutcome!=null){
                resp.app.Veda_IdMatrix_Overall_Outcome__c=res.overallOutcome;
                resp.app.Veda_IdMatrix_Completed__c = true;
            }
        }
        
        resp.serviceIdToResponse.put(configId,res);
        
    }
    
    
    public VedaResponse getResponse(){
        return resp;
    }
}
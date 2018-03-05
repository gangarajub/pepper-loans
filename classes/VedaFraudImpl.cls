global with sharing class VedaFraudImpl implements IService{
    VedaResponse resp ;
    genesis__Applications__c app;
    
    
    
    public void setRequest(String configId,VedaResponse vResp){
        this.resp = vResp;
        
        List<genesis__Applications__c> app = [select id,name,genesis__ID_Type__c,Identification_Type__c,Identification_Number__c,
                                              (select City__c,Country__c,Country_Code__c,PostCode__c,
                                               Property__c,State__c,Current_Address__c,
                                               Street_Number__c,Street_Type__c,
                                               Street_Type_Code__c,Suburb__c,Address__c,Internal_Address__c,
                                               Unit_Number__c,Street_Name__c from Residential_Address__r),
                                              genesis__Account__r.PersonBirthdate,genesis__Account__r.FirstName,genesis__Account__r.LastName,genesis__Account__r.MiddleName,
                                              genesis__Account__r.Gender__c,genesis__Account__r.Salutation,genesis__Account__r.Phone,
                                              genesis__ID_Number__c,genesis__Loan_Amount__c,genesis__Account__r.PersonMobilePhone
                                              from genesis__Applications__c 
                                              where id=:vResp.app.Id];
        //System.debug('app'+app[0].genesis__Account__r.FirstName+'lsr'+app[0].genesis__Account__r.LastName);
        
        ints__Veda_Fraud_Elements__c vedafraud = ints__Veda_Fraud_Elements__c.getInstance();  
        ints.IntegrationObjectFactory factroy = ints.IntegrationObjectFactory.getInstance();                                             
        ints.IntegrationRequestObject requestObj = new ints.IntegrationRequestObject();
        
        for(genesis__Applications__c  dp : app) {
            
            for(Residential_Address__c address : dp.Residential_Address__r) {
                
                if(address.Current_Address__c==true){
                    
                    requestObj.requestMap.put('type_address_addresses_individual_enquiry-data_1',String.valueof(address.Current_Address__c));
                    
                    
                    if(address.Address__c!=null){
                    /* MODIFIED BY CJJOYA 301120161013 */
                    /* ADDED A SPACE AFTER THE REPLACEALL */
                       //requestObj.requestMap.put('unformatted-address_Current',address.Internal_Address__c.replaceAll(':','')); 
                       requestObj.requestMap.put('unformatted-address_Current',address.Internal_Address__c.replaceAll(':',' ')); 
                    /* END OF MODIFICATION 301120161013  */   
                    }else{
                        
                        if(address.Street_Number__c!=null){
                            requestObj.requestMap.put('street-number_currentAddress',address.Street_Number__c);
                        }        
                        
                        if(address.Street_Name__c!=null){
                            requestObj.requestMap.put('street-name_currentAddress',address.Street_Name__c);
                        }
                        if(address.Property__c!=null){
                            requestObj.requestMap.put('property_currentAddress',address.Property__c);
                        }
                        
                        if(address.Street_Type__c!=null){
                            requestObj.requestMap.put('street-type_currentAddress',address.Street_Type__c);
                        }
                        if(address.Suburb__c!=null){
                            requestObj.requestMap.put('suburb_currentAddress',address.Suburb__c);
                        }
                        
                        if(address.State__c!=null){
                            requestObj.requestMap.put('state_currentAddress',address.State__c);
                        }
                        
                        if(address.City__c!=null){
                            requestObj.requestMap.put('city_currentAddress',address.City__c);
                        }
                        
                        if(address.Country__c!=null){
                            
                            requestObj.requestMap.put('country_currentAddress',address.Country__c);
                            
                        }
                        if(address.Unit_Number__c!=null){
                            requestObj.requestMap.put('unit-number_currentAddress',address.Unit_Number__c);
                            
                        }
                        if(address.PostCode__c!=null){
                            requestObj.requestMap.put('postcode_currentAddress',address.PostCode__c);
                        }
                        
                    }
                    
                    
                    
                }    
                
                System.debug('requestObj.requestMapadress'+requestObj.requestMap);  
            }
            
            //added by ketan
            /*
requestObj.requestMap.put('unit-number_currentAddress','4');
requestObj.requestMap.put('street-number_currentAddress','16');
requestObj.requestMap.put('property_currentAddress','test');
requestObj.requestMap.put('street-name_currentAddress','Berry');
requestObj.requestMap.put('street-type_currentAddress','st');
requestObj.requestMap.put('suburb_currentAddress','North Sydney');
requestObj.requestMap.put('fraudcheck-aus_Product','yes');
requestObj.requestMap.put('state_currentAddress','NSW');
requestObj.requestMap.put('city_currentAddress','Sydney');
requestObj.requestMap.put('postcode_currentAddress','NSW');
requestObj.requestMap.put('country_currentAddress','AUS');
*/
        }                                           
        
        if(vedafraud.ints__Product__c!=null){
            requestObj.requestMap.put('fraudcheck-aus_Product','yes');
            
        }
        if(vedafraud.vericheck_Product__c!=null){
            requestObj.requestMap.put('vericheck_Product','yes');
            
        }
        
        
        if(vedafraud.ints__subscriber_identifier__c!=null){
            requestObj.requestMap.put('client-reference',vedafraud.ints__subscriber_identifier__c);
            
        }
        
        if(app[0].genesis__Account__r.LastName!=null){
            requestObj.requestMap.put('family-name_Individual',app[0].genesis__Account__r.LastName);
            
        }
        
        if(app[0].genesis__Account__r.FirstName!=null){
            requestObj.requestMap.put('first-given-name_Individual',app[0].genesis__Account__r.FirstName);
            
        }
        
        if(app[0].genesis__Account__r.PersonBirthdate!=null){
            requestObj.requestMap.put('date-of-birth_Individual',String.valueof(app[0].genesis__Account__r.PersonBirthdate));
        }
        
        
        if(app[0].Identification_Type__c!=null && app[0].Identification_Type__c.equalsignorecase('Drivers Licence')){
            requestObj.requestMap.put('drivers-licence-number_Individual',app[0].Identification_Number__c);
        }
        if(app[0].genesis__Account__r.PersonMobilePhone!=null){
            requestObj.requestMap.put('phone-number_phone-details',app[0].genesis__Account__r.PersonMobilePhone);
        }
        
        System.debug('app[0].genesis__Account__r.PersonMobilePhone'+app[0].genesis__Account__r.PersonMobilePhone);
        /*Decimal len=app[0].genesis__Account__r.PersonMobilePhone.length();
if(len==8){
requestObj.requestMap.put('phone-area-code_phone-details','02');
String str = app[0].genesis__Account__r.PersonMobilePhone;
if(str.charAt(0)==0 && str.charAt(0)==1){
System.debug('first Digit must not zero or one');
}
}else{
requestObj.requestMap.put('phone-area-code_phone-details','03');
String str = app[0].genesis__Account__r.PersonMobilePhone;
System.debug('phone with length is more than 8'+str);
//System.debug('check0='+String.valueof(str.CharAt(0))+'check1'+str.CharAt(str.CharAt(1)));

if(str.charAt(0)==0 || str.charAt(0)==1){

}else{
System.debug('first Digit must be zero or one');
}
}
*/
        
        //requestObj.requestMap.put('phone-area-code_phone-details','');
        requestObj.requestMap.put('isd_phone-details','61');
        
        System.debug('requestObj.requestMap'+requestObj.requestMap);
        
        
        
        ints.VedaFraudResponseObj res = new ints.VedaFraudResponseObj();
        if(Test.isRunningTest())
        {
            ints.VedaFraudResponseObj.VeriCheckSuiteSummary veriCheck = new ints.VedaFraudResponseObj.VeriCheckSuiteSummary();
            veriCheck.vericheckIndicator = '123';
            
            ints.VedaFraudResponseObj.VeriCheckReport veriReport = new ints.VedaFraudResponseObj.VeriCheckReport();
            veriReport.reportSummary = '123';
            
            ints.VedaFraudResponseObj.FraudCheckReport fraudCheck = new ints.VedaFraudResponseObj.FraudCheckReport();
            
            ints.VedaFraudResponseObj.FraudResultSummary summary = new ints.VedaFraudResponseObj.FraudResultSummary();
            
            ints.VedaFraudResponseObj.Address add = new ints.VedaFraudResponseObj.Address();
            
            ints.VedaFraudResponseObj.AddressIndicator addInd = new ints.VedaFraudResponseObj.AddressIndicator();
            
            ints.VedaFraudResponseObj.FraudcheckResultDetails detail = new ints.VedaFraudResponseObj.FraudcheckResultDetails();
            detail.addressList.add(add);
            
            ints.VedaFraudResponseObj.FraudCheckResult check = new ints.VedaFraudResponseObj.FraudCheckResult();
            check.fraudFileNumber = '123';
            check.fraudResultSummaryObj = summary;
            check.fraudcheckResultDetailsObj = detail;
            
            ints.VedaFraudResponseObj.DateofBirthIndicator birth = new ints.VedaFraudResponseObj.DateofBirthIndicator();
            ints.VedaFraudResponseObj.IndividualNameIndicator individual = new ints.VedaFraudResponseObj.IndividualNameIndicator();
            
            ints.VedaFraudResponseObj.BureauResult results = new ints.VedaFraudResponseObj.BureauResult();
            results.addressIndicatorList.add(addInd);
            results.dateofBirthIndicatorList.add(birth);
            results.individualNameIndicatorList.add(individual);
            
            ints.VedaFraudResponseObj.BureauReport bureau = new ints.VedaFraudResponseObj.BureauReport();
            bureau.BureauResultList.add(results);
            
            
            ints.VedaFraudResponseObj.PhoneListingResult phone = new ints.VedaFraudResponseObj.PhoneListingResult();
            phone.phoneListingResultMatchSummary = '123';
            phone.addressIndicatorList.add(addInd);
            
            ints.VedaFraudResponseObj.ElectoralRollresult elect = new ints.VedaFraudResponseObj.ElectoralRollresult();
            elect.type = '123';
            elect.addressIndicatorList.add(addInd);
            
            ints.VedaFraudResponseObj.IndividualNameIndicator nameInd = new ints.VedaFraudResponseObj.IndividualNameIndicator();
            
            ints.VedaFraudResponseObj.AmlSummary aml = new ints.VedaFraudResponseObj.AmlSummary();
            
            res.veriCheckReportobj.phoneListingResultList.add(phone);
            res.veriCheckReportobj.electoralRollresultList.add(elect);
            //res.PhoneListingResult.addressIndicatorList.add(addInd);
            //res.ElectoralRollresult.addressIndicatorList.add(addInd);
            res.fraudCheckReportObj.fraudCheckResultList.add(check);
            res.bureauReportObj.BureauResultList.add(results);
            //res.PhoneListingResult.addressIndicatorList.add(addInd);
            //res.amlSummaryObj.
            res.requestXMLBody = '12';
            res.responseXMLBody = '123';
            
        }
        else
        {
            try{
                res=(ints.VedaFraudResponseObj)factroy.getIntegrationObject('VedaFraud').integrate(requestObj);
                System.debug('req'+res.requestXMLBody);
                
                System.debug('res.veriCheckSuiteSummaryObj.fraudCheckIndicator'+res.veriCheckSuiteSummaryObj.fraudCheckIndicator);
                if(res.veriCheckSuiteSummaryObj.fraudCheckIndicator!=null){
                    
                    resp.app.Veda_Fraud_Completed__c = true;
                }
                
                if(res.generalMessage!=null){
                    resp.app.Veda_Fraud_General_Message__c= res.generalMessage;
                    resp.app.Veda_Fraud_Completed__c = true;
                }
                
                if(res.fraudCheckReportObj.fraudCheckResultList.size()>0){
                    if(res.fraudCheckReportObj.fraudCheckResultList[0].fraudResultSummaryObj!=null){
                        resp.app.fraudcheck_phone_indicator__c=res.fraudCheckReportObj.fraudCheckResultList[0].fraudResultSummaryObj.fraudCheckPhoneIndicator;
                        resp.app.fraudcheck_address_indicator__c=res.fraudCheckReportObj.fraudCheckResultList[0].fraudResultSummaryObj.fraudCheckAddressIndicator;
                        resp.app.fraudcheck_drivers_licence_indicator__c=res.fraudCheckReportObj.fraudCheckResultList[0].fraudResultSummaryObj.fraudCheckDriversLicenceIndicator;
                    }
                }
                
                //resp.serviceIdToResponse.put(configId,res);
            }catch(Exception e){
            }
            
        }
        resp.serviceIdToResponse.put(configId,res);
        
        
        
    }
    
    public VedaResponse getResponse(){
        return resp;
    }
}
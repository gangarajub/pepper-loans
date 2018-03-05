global with sharing class DandBImpl implements IService{
    VedaResponse resp ;
    genesis__Applications__c app;
    
    public void setRequest(String configId,VedaResponse vResp){
        this.resp = vResp;
        System.debug('this.resp'+vResp);
        List<genesis__Applications__c> app = [select id,name,Identification_Type__c,Identification_Number__c,
                                              (select City__c,Country_Code__c,PostCode__c,
                                               Property__c,State__c,Current_Address__c,
                                               Street_Number__c,Street_Type__c,Address__c,
                                               Street_Type_Code__c,Country__c,Suburb__c,
                                               Unit_Number__c,Street_Name__c from Residential_Address__r),
                                              genesis__Account__r.PersonBirthdate,genesis__Account__r.FirstName,genesis__Account__r.LastName,genesis__Account__r.MiddleName,
                                              genesis__Account__r.Gender__c,genesis__Account__r.Salutation,
                                              genesis__ID_Number__c,genesis__Loan_Amount__c
                                              from genesis__Applications__c 
                                              where id=:vResp.app.Id];
        
        ints.IntegrationRequestObject requestObj = new ints.IntegrationRequestObject();
        for(genesis__Applications__c  dp : app) {
            
            for(Residential_Address__c address : dp.Residential_Address__r) {
                
                if(address.Current_Address__c==true){
                        requestObj.requestMap.put('currAddrIsCurrent', 'Yes');
                        requestObj.requestMap.put('currAddrIsPriorAddress', 'No');
                        requestObj.requestMap.put('currAddrIsMailing', 'No');   
                        if(address.Address__c!=null){
                              requestObj.requestMap.put('currNonStdAddress_1',address.Address__c);
                        }else{           
                        if(address.Unit_Number__c!=null){
                            requestObj.requestMap.put('currAddrUnitNo', address.Unit_Number__c);
                        }    
                    
                        if(address.Street_Number__c!=null){
                           requestObj.requestMap.put('currAddrStreetNo',address.Street_Number__c);
                        }        
                        
                        if(address.Street_Name__c!=null){
                            requestObj.requestMap.put('currAddrStreet', address.Street_Name__c);
                        }
                        
                        if(address.Street_Type__c!=null){
                           requestObj.requestMap.put('currAddrStreetType', address.Street_Type__c);
                        }
                        System.debug('address'+address);
                        System.debug('address.City__c'+address.City__c);
                        if(address.City__c!=null){
                           requestObj.requestMap.put('currAddrCity',address.City__c);
                        }
                        if(address.State__c!=null){
                            requestObj.requestMap.put('currAddrState',address.State__c);
                        }
                        
                        if(address.PostCode__c!=null){
                           requestObj.requestMap.put('currAddrPostcode',address.PostCode__c);
                        }
                     }
                    
                    
                    
                }    
                System.debug('requestObj.requestMap'+requestObj.requestMap);
                
            }
        }                                           
        if(app[0].genesis__Account__r.FirstName!=null){
             requestObj.requestMap.put('firstName', app[0].genesis__Account__r.FirstName);
        }
       
        if(app[0].genesis__Account__r.MiddleName!=null){
             requestObj.requestMap.put('otherName',app[0].genesis__Account__r.MiddleName);
        }
        
        if(app[0].genesis__Account__r.LastName!=null){
             requestObj.requestMap.put('surname', app[0].genesis__Account__r.LastName);
        }
        if(app[0].genesis__Account__r.PersonBirthdate!=null){
           String s = String.valueOf(app[0].genesis__Account__r.PersonBirthdate);
           List<String> hparts = s.split('-');

        if(hparts.size()>0 && hparts[2]!=null){
             requestObj.requestMap.put('dobYear', hparts[0]);
        }
        
        
        if(hparts.size()>0 && hparts[1]!=null){
              requestObj.requestMap.put('dobMonth',  hparts[1]);
        }
       
       
        if(hparts.size()>0 && hparts[0]!=null){
              requestObj.requestMap.put('dobDay', hparts[2]);
        }
        
        }
       
       
       
        if(app[0].Identification_Type__c!=null && app[0].Identification_Type__c.equalsignorecase('Drivers Licence')){
            requestObj.requestMap.put('driversLicenceNumber',app[0].Identification_Number__c);
        }
        
         if(app[0].genesis__Account__r.Gender__c!=null && app[0].genesis__Account__r.Gender__c.equalsignorecase('Female')){
            requestObj.requestMap.put('gender','F');
        }
        
        if(app[0].genesis__Account__r.Gender__c!=null && app[0].genesis__Account__r.Gender__c.equalsignorecase('Male')){
            requestObj.requestMap.put('gender','M');
        }
        
        if(app[0].genesis__Account__r.Gender__c!=null && app[0].genesis__Account__r.Gender__c.equalsignorecase('Transgender')){
            requestObj.requestMap.put('gender','U');
        }
        
        
        
       
       
        requestObj.requestMap.put('accountTypeCode', '005');
        
        requestObj.requestMap.put('creditObligationCode', '005');
      
        
       
      
        
        try{
            ints.DunAndBradstreetIntegration dun = new ints.DunAndBradstreetIntegration();
            
            //ints.IntegrationResponseObject res = dun.integrate(requestObj);
            //ints.DunAndBradstreetResponse dnbRes= (ints.DunAndBradstreetResponse)res;
            ints.DunAndBradstreetResponse dnbRes=  new ints.DunAndBradstreetResponse();
            if(Test.isRunningTest())
            {
                ints.DunAndBradstreetResponse.Column col = new ints.DunAndBradstreetResponse.Column();
                ints.DunAndBradstreetResponse.ContactAddress add = new ints.DunAndBradstreetResponse.ContactAddress();
                ints.DunAndBradstreetResponse.ScoreMeasureType score = new ints.DunAndBradstreetResponse.ScoreMeasureType();
                ints.DunAndBradstreetResponse.KeyInfluencingFactor keys = new ints.DunAndBradstreetResponse.KeyInfluencingFactor();
                ints.DunAndBradstreetResponse.SummaryItem summary = new ints.DunAndBradstreetResponse.SummaryItem();
                ints.DunAndBradstreetResponse.Defaults defaults = new ints.DunAndBradstreetResponse.Defaults();
                ints.DunAndBradstreetResponse.Enquiry enquiry = new ints.DunAndBradstreetResponse.Enquiry();
                ints.DunAndBradstreetResponse.SeriousCreditInfringement serious = new ints.DunAndBradstreetResponse.SeriousCreditInfringement();
                ints.DunAndBradstreetResponse.FileNote files = new ints.DunAndBradstreetResponse.FileNote();
                ints.DunAndBradstreetResponse.OtherPublicRecord records = new ints.DunAndBradstreetResponse.OtherPublicRecord();
                ints.DunAndBradstreetResponse.Bankruptcy bankrupt = new ints.DunAndBradstreetResponse.Bankruptcy();
                ints.DunAndBradstreetResponse.Directorship directors = new ints.DunAndBradstreetResponse.Directorship();
                ints.DunAndBradstreetResponse.Aae aae = new ints.DunAndBradstreetResponse.Aae();
                ints.DunAndBradstreetResponse.Judgments judges = new ints.DunAndBradstreetResponse.Judgments();
                ints.DunAndBradstreetResponse.Summonses summonse = new ints.DunAndBradstreetResponse.Summonses();
                ints.DunAndBradstreetResponse.PossibleMatchAddress match = new ints.DunAndBradstreetResponse.PossibleMatchAddress();
                dnbRes.scoreMeasures.add(score);
                dnbRes.keyInfluencingFactors.add(keys);
                dnbRes.summary.add(summary);
                dnbRes.defaultColumns.add(col);
                dnbRes.defaults.add(defaults);
                
                dnbRes.enquiries.add(enquiry);
                dnbRes.seriousCreditInfringements.add(serious); 
                dnbRes.fileNotes.add(files);
                dnbRes.otherPublicRecords.add(records);
                dnbRes.bankruptcies.add(bankrupt);
                dnbRes.directorships.add(directors);
                dnbRes.judgments.add(judges);
                dnbRes.summonses.add(summonse);
                dnbRes.possibleMchAddress.add(match);
                dnbRes.rawRequest = '12';
                dnbRes.rawResponse = '123';
                    
                     resp.serviceIdToResponse.put(configId,dnbRes);
            }else{
             ints.IntegrationResponseObject res = dun.integrate(requestObj);
            ints.DunAndBradstreetResponse dnbRes1= (ints.DunAndBradstreetResponse)res;
             System.debug('re1'+dnbRes1);
              System.debug('res'+res);
            System.debug('response'+dnbRes1.rawResponse);
         
           
            resp.serviceIdToResponse.put(configId,dnbRes1);
            
            }
           
        }catch(Exception e){
          
           System.debug('Error'+e.getMessage());
        }
        
        
        
      
        
    }
    
    public VedaResponse getResponse(){
        return resp;
    }
    
    
    
}
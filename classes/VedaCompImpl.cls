global with sharing class VedaCompImpl implements IService{
    VedaResponse resp ;
    genesis__Applications__c app;
    
    public void setRequest(String configId,VedaResponse vResp){
        this.resp = vResp;
        //System.debug('this.resp'+vResp);
        List<genesis__Applications__c> app = [select id,name,Identification_Type__c,Identification_Number__c,
                                              (select City__c,Country_Code__c,PostCode__c,
                                               Property__c,State__c,Current_Address__c,
                                               Street_Number__c,Street_Type__c,Address__c,
                                               Street_Type_Code__c,Country__c,Suburb__c,Internal_Address__c,
                                               Unit_Number__c,Street_Name__c from Residential_Address__r),
                                              genesis__Account__r.PersonBirthdate,genesis__Account__r.FirstName,genesis__Account__r.LastName,genesis__Account__r.MiddleName,
                                              genesis__Account__r.Gender__c,genesis__Account__r.Salutation,
                                              genesis__ID_Number__c,genesis__Loan_Amount__c
                                              from genesis__Applications__c 
                                              where id=:vResp.app.Id];
        
        ints__Veda_Comprehensive__c veda = ints__Veda_Comprehensive__c.getInstance();
        ints.IntegrationObjectFactory factroy = ints.IntegrationObjectFactory.getInstance();                                            
        ints.IntegrationRequestObject requestObj = new ints.IntegrationRequestObject();
        
        for(genesis__Applications__c  dp : app) {
            
            for(Residential_Address__c address : dp.Residential_Address__r) {
                
                if(address.Current_Address__c==true){
                    
                    requestObj.requestMap.put('type_address_addresses_individual_enquiry-data_1','C');
                    
                    if(address.Internal_Address__c!=null){
                        requestObj.requestMap.put('unformatted-address_address_addresses_individual_enquiry-data_1',address.Internal_Address__c.replaceAll(':',' ')); 
                    }
                    else{
                        if(address.Address__c==null && address.Street_Number__c!=null){
                            requestObj.requestMap.put('street-number_address_addresses_individual_enquiry-data_1',address.Street_Number__c);
                        }        
                        
                        if(address.Address__c==null && address.Street_Name__c!=null){
                            requestObj.requestMap.put('street-name_address_addresses_individual_enquiry-data_1',address.Street_Name__c);
                        }
                        
                        if(address.Address__c==null && address.Street_Type__c!=null){
                            requestObj.requestMap.put('street-type_address_addresses_individual_enquiry-data_1',address.Street_Type__c.touppercase());
                        }
                        if(address.Address__c==null && address.Suburb__c!=null){
                            requestObj.requestMap.put('suburb_address_addresses_individual_enquiry-data_1',address.Suburb__c);
                        }
                        
                        if(address.Address__c==null && address.State__c!=null){
                            requestObj.requestMap.put('state_address_addresses_individual_enquiry-data_1',address.State__c);
                        }
                        
                        if(address.Address__c==null && address.Country_Code__c!=null){
                            requestObj.requestMap.put('country-code_address_addresses_individual_enquiry-data_1',address.Country__c);
                        }
                    }
                    
                    
                    
                }    
                //System.debug('requestObj.requestMap'+requestObj.requestMap);
                
            }
        }                                           
        
        
        
        if(veda.Client_Reference__c!=null){
            requestObj.requestMap.put('client-reference_enquiry-header',veda.Client_Reference__c);
        }
        
        
        if(veda.Operator_Id__c!=null){
            requestObj.requestMap.put('operator-id_enquiry-header',veda.Operator_Id__c);
        }
        
        
        if(veda.Operator_Name__c!=null){
            requestObj.requestMap.put('operator-name_enquiry-header',veda.Operator_Name__c);
        }
        
        
        
        if(veda.Product_Data_Level_Code__c!=null){
            requestObj.requestMap.put('product-data-level-code_enquiry-header',veda.Product_Data_Level_Code__c);
        }
        
        if(app.size()>0){
            requestObj.requestMap.put('enquiry-client-reference_enquiry_enquiry-data',app[0].name);    
        }
        
        if(app[0].genesis__Account__r.Salutation!=null){
            requestObj.requestMap.put('title_current-name_individual_enquiry-data',app[0].genesis__Account__r.Salutation);
        }
        
        
        if(app[0].genesis__Account__r.LastName!=null){
            requestObj.requestMap.put('family-name_current-name_individual_enquiry-data',app[0].genesis__Account__r.LastName);
        }
        
        
        if(app[0].genesis__Account__r.FirstName!=null){
            requestObj.requestMap.put('first-given-name_current-name_individual_enquiry-data',app[0].genesis__Account__r.FirstName);
        }
        
        
        if(app[0].genesis__Account__r.MiddleName!=null){
            requestObj.requestMap.put('other-given-name_current-name_individual_enquiry-data',app[0].genesis__Account__r.MiddleName);
        }
        
        
        if(app[0].Identification_Type__c!=null && app[0].Identification_Type__c.equalsignorecase('Drivers Licence')){
            requestObj.requestMap.put('number_drivers-licence_individual_enquiry-data',app[0].Identification_Number__c);
        }
        
        //System.debug('gender'+app[0].genesis__Account__r.Gender__c);
        if(app[0].genesis__Account__r.Gender__c!=null && app[0].genesis__Account__r.Gender__c.equalsignorecase('Transgender')){
            requestObj.requestMap.put('gender-code_individual_enquiry-data','U');
        }
        if(app[0].genesis__Account__r.Gender__c!=null && app[0].genesis__Account__r.Gender__c.equalsignorecase('Prefer Not To Say')){
            requestObj.requestMap.put('gender-code_individual_enquiry-data','U');
        }
        //System.debug('gender'+app[0].genesis__Account__r.Gender__c);
        if(app[0].genesis__Account__r.Gender__c!=null && app[0].genesis__Account__r.Gender__c.equalsignorecase('Female')){
            requestObj.requestMap.put('gender-code_individual_enquiry-data','F');
        }
        
        if(app[0].genesis__Account__r.Gender__c!=null && app[0].genesis__Account__r.Gender__c.equalsignorecase('Male')){
            requestObj.requestMap.put('gender-code_individual_enquiry-data','M');
        }
        
        if(app[0].genesis__Account__r.PersonBirthdate!=null){
            requestObj.requestMap.put('date-of-birth_individual_enquiry-data',String.valueOf(app[0].genesis__Account__r.PersonBirthdate));
        }
        
        if(veda.Account_Type_Code__c!=null){
            requestObj.requestMap.put('account-type-code_enquiry_enquiry-data',veda.Account_Type_Code__c);
        }
        
        
        if(app[0].genesis__Loan_Amount__c!=null){
            requestObj.requestMap.put('enquiry-amount_enquiry_enquiry-data',String.valueOf(app[0].genesis__Loan_Amount__c.round(System.RoundingMode.CEILING)));
            
        }
        
        if(veda.Relationship_Code__c!=null){
            requestObj.requestMap.put('relationship-code_enquiry_enquiry-data',veda.Relationship_Code__c);
            
        }
        if(veda.Permission_Type_Code__c!=null){
            requestObj.requestMap.put('permission-type-code_enquiry-header',veda.Permission_Type_Code__c);
        }        
        
        
        
        ints.VedaComprehensiveResponse res = new ints.VedaComprehensiveResponse();
        if(Test.isRunningTest()){
            
            //List<StaticResource> resourceList = [SELECT Name,Body , NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = 'vedaComprehensiveResponse'];
            //res = (ints.VedaComprehensiveResponse)JSON.deserialize(resourceList[0].Body.toString(),ints.VedaComprehensiveResponse.class);
            
            
            ints.VedaComprehensiveResponse.address ad = new  ints.VedaComprehensiveResponse.address();
            ad.countryCode='AUS';
            ad.firstReportedDate='2016-05-26';
            ad.lastReportedDate='2016-07-04';
            ad.postcode='200';
            ad.property='';
            ad.state='NSW';
            ad.streetName='GEORGE';
            ad.streetNumber='6';
            ad.streetType='ST';
            ad.suburb='SYDNEY';
            ad.type='C';
            ad.unitNumber='123';
            
            ints.VedaComprehensiveResponse.configurationDataAttribute conf = new ints.VedaComprehensiveResponse.configurationDataAttribute();
            conf.key='1';
            conf.value='12';
            conf.unit='43';
            
            ints.VedaComprehensiveResponse.otherIdentity oth = new ints.VedaComprehensiveResponse.otherIdentity();
            oth.idIndex='1';
            oth.type='1';
            oth.bureauReference='12';
            oth.individualNameFirstReportedDate='12';
            oth.individualNameLastReportedDate='1';
            oth.gender='MALE';
            
            ints.VedaComprehensiveResponse.employer emp  = new ints.VedaComprehensiveResponse.employer();
            emp.firstReportedDate='12';
            emp.lastReportedDate='12';
            emp.type='1';
            
            
            ints.VedaComprehensiveResponse.courtAction crt = new ints.VedaComprehensiveResponse.courtAction();
            crt.courtActionType='12';
            crt.coBorrower='12';
            
            ints.VedaComprehensiveResponse.fileNote fl = new ints.VedaComprehensiveResponse.fileNote();
            fl.dateRecorded='123';
            fl.note='23';
            
            ints.VedaComprehensiveResponse.creditEnquiry cr = new ints.VedaComprehensiveResponse.creditEnquiry();
            cr.type='12';
            cr.enquiryDate='1';
            cr.accountType='1';
            
            ints.VedaComprehensiveResponse.account ac = new ints.VedaComprehensiveResponse.account();
            ac.latestUpdateDate='1';
            ac.accountDataLevel='1';
            
            ints.VedaComprehensiveResponse.VedaComprehensivedefault vd = new ints.VedaComprehensiveResponse.VedaComprehensivedefault();
            vd.status='1';
            vd.statusCode='1';
            vd.originalDefaultDefaultAmount='12';
            
            ints.VedaComprehensiveResponse.directorship dirt = new ints.VedaComprehensiveResponse.directorship();
            
            ints.VedaComprehensiveResponse.disqualifiedDirectorship dcr  = new ints.VedaComprehensiveResponse.disqualifiedDirectorship();
            dcr.lastExtractDate='12';
            dcr.lastUpdateDate='12';
            
            ints.VedaComprehensiveResponse.businessName bn = new  ints.VedaComprehensiveResponse.businessName();
            
            bn.lastExtractDate='23';
            bn.businessBureauReference='1';
            
            
            ints.VedaComprehensiveResponse.payment pm = new ints.VedaComprehensiveResponse.payment();
            pm.period='1';
            pm.status='1';
            
            ints.VedaComprehensiveResponse.DataBlock db = new ints.VedaComprehensiveResponse.DataBlock();
            ints.VedaComprehensiveResponse.Characteristic chr= new ints.VedaComprehensiveResponse.Characteristic();
            chr.description='Number of insolvencies in the last 84 months';
            chr.value='11';
            
            ints.VedaComprehensiveResponse.personalInsolvency pr = new ints.VedaComprehensiveResponse.personalInsolvency();
            pr.typeCode='12';
            pr.dateDeclared='1';
            pr.administrationIdYear='4';
            
            ints.VedaComprehensiveResponse.Score scr = new ints.VedaComprehensiveResponse.Score();
            scr.scoreMasterscale='10';
            res.personalInsolvencies.add(pr);
            res.businessNames.add(bn);
            res.accounts.add(ac);
            res.accounts[0].repaymentHistory.add(pm);
            res.accounts[0].defaults.add(vd);
            res.scoreData.add(scr);
            res.courtActions.add(crt);
            res.summaryData.add(db);
            res.summaryData[0].characteristic.add(chr);
           
            res.directorships.add(dirt);
            res.disqualifiedDirectorships.add(dcr);
            res.commercialCreditFileAccounts.add(ac);
            res.addresses.add(ad);
            res.otherIdentities.add(oth);
            res.fileNotes.add(fl);
            res.commercialCreditFileFileNotes.add(fl);
            res.creditEnquiries.add(cr);
            res.commercialCreditFileCreditEnquiries.add(cr);
            res.employers.add(emp);
            
            res.configurationDataAttributes.add(conf);
            res.xmlResponse='123';
            res.xmlRequest='123';
            
        }else{
            
            res=(ints.VedaComprehensiveResponse)factroy.getIntegrationObject('Veda Comprehensive').integrate(requestObj);
            
        }
        
        //System.debug('res.response=='+res.xmlResponse);
        //System.debug('res='+res);
        //System.debug('res.request=='+res.xmlRequest);
        
        //System.debug('res.scoreData'+res.scoreData);
        if(res.summaryData.size()>0){
            for(ints.VedaComprehensiveResponse.DataBlock datablock :res.summaryData){
                
                
                if(datablock.Characteristic.size()>0){
                    for(ints.VedaComprehensiveResponse.Characteristic chr : datablock.Characteristic){
                        
                        //System.debug('chr.description'+chr.description+'chr.value'+chr.value); 
                        //System.debug('chr.description'+chr.description+'Integer.valueof(chr.value)'+Integer.valueof(chr.value));
                        if(chr.description.equalsIgnoreCase('Number of insolvencies in the last 84 months')){
                           // System.debug('11111'+chr.description+'Integer.valueof(chr.value)'+Integer.valueof(chr.value));
                            resp.app.Number_of_Insolvencies_in_last_84_months__c = Integer.valueof(chr.value);    
                        }
                        
                        if(chr.description.equalsIgnoreCase('Number of bankrupt only insolvencies in the last 84 months')){
                           // System.debug('22222'+chr.description+'Integer.valueof(chr.value)'+Integer.valueof(chr.value));
                            resp.app.Bankrupt_Only_Insolvencies_in_84_months__c = Integer.valueof(chr.value);    
                        }
                        
                        if(chr.description.equalsIgnoreCase('Number of discharged insolvencies in the last 84 months')){
                            //System.debug('333'+chr.description+'Integer.valueof(chr.value)'+Integer.valueof(chr.value));
                            resp.app.Discharged_Insolvencies_in_84_months__c = Integer.valueof(chr.value);
                        }
                        
                        
                        
                    }    
                    
                }
                
            }
        }
        
        if(res.scoreData.size()>0){
            if(res.scoreData[0].scoreMasterscale!=null){
                resp.app.Current_Veda_Score__c = Integer.valueof(res.scoreData[0].scoreMasterscale);
                resp.app.Veda_Comprehensive_Completed__c = true;
                
            }
        }
        
        
        
        resp.serviceIdToResponse.put(configId,res);
        
        
    }
    
    public VedaResponse getResponse(){
        return resp;
    }
    
    
    
}
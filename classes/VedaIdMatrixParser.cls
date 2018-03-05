public with sharing class VedaIdMatrixParser implements IParser{
    
    
    public void parseResponse(ints.IntegrationResponseObject resp,String respClass,String appId){
        
        ints.IDMatrixResponse res = (ints.IDMatrixResponse)resp;
        list<sObject> obj = new list<sObject>();
        list<sObject> AssessmentFactor2 = new list<sObject>();
        Map<sObject, sObject> m = new Map<sObject, sObject>(); 
        
        
        Veda_IdMatrix__c vedaId = new Veda_IdMatrix__c();
        vedaId.Message_Id__c=res.messageId;
        vedaId.Relates_To__c=res.relatesTo;
        vedaId.Client_Reference__c=res.clientReference;
        vedaId.Enquiry_ID__c=res.enquiryId;
        vedaId.Profile_Name__c=res.profileName;
        vedaId.Profile_Version__c=res.profileVersion;
        vedaId.overallOutcome__c=res.overallOutcome;
        vedaId.Indicator__c=res.indicator;
        vedaId.Total_Point__c=res.totalPoint;
        vedaId.Self_Verification_Url__c=res.selfVerificationUrl;
        vedaId.Fault_String__c=res.faultstring;
        vedaId.Fault_Code__c=res.faultcode;
        vedaId.Fault_Actor__c=res.faultactor;
        vedaId.Error_Status__c=res.errorStatus;
        vedaId.Application__c=appid;
        insert vedaId;
        Veda_IdMatrix__c ved = [select name from Veda_IdMatrix__c  where id=:vedaId.Id limit 1];
        Attachment att1 = new Attachment();
        att1.parentId =  vedaId.id;
        att1.body = Blob.valueOf(res.requestXMLBody);
        att1.Name = 'Id Matrix Request'+ved.name;
        //resp.attachments.add(att);
        insert att1;
        
        
        Attachment att = new Attachment();
        att.parentId = vedaId.Id;
        att.body = Blob.valueOf(res.responseXMLBody);
        att.Name = 'Id Matrix Response'+ved.name;
        insert att; 
        
        if(res.rulesResults.size()>0){
            
            for(ints.IDMatrixResponse.rulesResult rul : res.rulesResults){
                IdMatrix_Rules_Result__c rel = new IdMatrix_Rules_Result__c();
                rel.name__c=rul.name;
                rel.Indicator__c=rul.indicator;
                rel.Reason__c=rul.reason;
                rel.Veda_IdMatrix__c = vedaId.Id;
                obj.add(rel);
                
            }
            
        }
        
        if(res.analysisResults.size()>0){
            
            for(ints.IDMatrixResponse.AnalysisResult rul : res.analysisResults){ 
                IdMatrix_Analysis_Result__c   ana = new IdMatrix_Analysis_Result__c();
                ana.Category__c=rul.category;
                ana.Search_Name__c=rul.searchName;
                ana.Minimum_Value__c=rul.minimumValue;
                ana.Raw_Score__c=rul.rawScore;
                ana.Filtered_Score__c=rul.filteredScore;
                ana.Weight__c=rul.weight;
                ana.Points__c=rul.points;
                ana.dateofbirth__c=rul.dateOfBirthMatch;
                ana.documentIdentifierMatch__c= rul.documentIdentifierMatch;
                ana.Name_Match__c=rul.nameMatch;
                ana.Address_Match__c=rul.addressMatch;
                ana.Veda_IdMatrix__c = vedaId.Id;
                obj.add(ana);
                
            }   
            
            
        }
        if(res.searchResults.size()>0){
            
            for(ints.IDMatrixResponse.SearchResult rul : res.searchResults){ 
                
                IdMatrix_Search_Result__c search = new IdMatrix_Search_Result__c();
                search.Match_Indicator__c=rul.matchScore;
                search.Search_Name__c=rul.searchName;
                search.Match_Score__c=rul.matchScore; 
                search.Search_Type__c=rul.searchYype;  
                search.Service_Result_Code__c=rul.serviceResultCode;
                search.Service_Result_Detail__c=rul.serviceResultDetail;
                search.Service_Result_String__c=rul.serviceResultString;
                search.Individual_Match_Score__c=rul.individualMatchScore;
                search.Individual_Match_Score_Weight__c =rul.individualMatchScoreWeight;
                search.Family_Name_Match_Indicator__c=rul.familyNameMatchIndicator;
                search.Family_Name_Match_Score__c=rul.familyNameMatchScore;
                search.Family_Name_Match_Score_Weight__c=rul.familyNameMatchScoreWeight;
                search.Family_Name_Search_Value__c=rul.familyNameSearchValue;
                search.First_Name_Match_Indicator__c=rul.firstNameMatchIndicator;
                search.First_Name_Match_Score__c=rul.firstNameMatchScore;
                search.First_Name_Match_Score_Weight__c=rul.firstNameMatchScoreWeight;
                search.First_Name_Search_Value__c=rul.firstNameSearchValue;
                
                search.Other_Name_Match_Indicator__c=rul.otherNameMatchIndicator;
                search.Other_Name_Match_Score__c=rul.otherNameMatchScore;
                search.Other_Name_Match_Score_Weight__c=rul.otherNameMatchScoreWeight;
                search.Other_Name_Search_Value__c=rul.otherNameSearchValue;
                
                search.Date_Of_Birth__c=rul.dateOfDirth;
                search.Gender__c=rul.gender;
                search.Current_Address_Match_Score__c=rul.currentAddressMatchScore;
                search.Current_Address_Match_Score_Weight__c=rul.currentAddressMatchScoreWeight;
                
                search.Street_Number_Match_Indicator__c=rul.streetNumberMatchIndicator;
                search.Street_Number_Match_Score__c=rul.streetNumberMatchScore;
                search.Street_Number_Match_Score_Weight__c=rul.streetNumberMatchScoreWeight;
                search.Street_Number_Search_Value__c=rul.streetNumberSearchValue;
                
                search.Street_Name_Match_Indicator__c=rul.streetNameMatchIndicator;
                search.Street_Name_Match_Score__c=rul.streetNameMatchScore;
                search.Street_Name_Match_Score_Weight__c=rul.streetNameMatchScoreWeight;
                search.Street_Name_Search_Value__c=rul.streetNameSearchValue;
                
                search.Street_Type_Search_Value__c=rul.streetTypeSearchValue;
                search.Suburb_Match_Indicator__c=rul.suburbMatchIndicator;
                search.Suburb_Match_Score__c=rul.suburbMatchScore;
                search.Suburb_Match_Score_Weight__c=rul.suburbMatchScoreWeight;
                
                search.Suburb_Search_Value__c=rul.suburbSearchValue;
                
                search.Post_Code_Match_Indicator__c=rul.postcodeMatchIndicator;
                search.Post_Code_Match_Score__c=rul.postcodeMatchScore;
                search.Post_Code_Match_Score_Weight__c=rul.postcodeMatchScoreWeight;
                search.Post_Code_Search_Value__c=rul.postcodeSearchValue;
                
                search.State_Match_Indicator__c=rul.stateMatchIndicator;
                search.State_Match_Score__c=rul.stateMatchScore;
                search.State_Match_Score_Weight__c=rul.stateMatchScoreWeight;
                search.State_Search_Value__c=rul.stateSearchValue;
                
                search.Veda_IdMatrix__c = vedaId.Id;
                obj.add(search); 
                
            }    
            
        }
        Map<IdMatrix_Assessment_Factor__c,IdMatrix_Fraud_Assessment_Response__c> assesment = new  Map<IdMatrix_Assessment_Factor__c,IdMatrix_Fraud_Assessment_Response__c>();
        
        if(res.fraudAssessmentResponse!=null){
            
            
            
            IdMatrix_Fraud_Assessment_Response__c   idfraud  = new IdMatrix_Fraud_Assessment_Response__c();
            idfraud.Score__c = res.fraudAssessmentResponse.score;
            
            idfraud.Threshold__c= res.fraudAssessmentResponse.threshold;
            idfraud.Result__c= res.fraudAssessmentResponse.result;
            if(res.fraudAssessmentResponse.assessmentFactors.size()>0){
                
                for(ints.IDMatrixResponse.AssessmentFactor rul : res.fraudAssessmentResponse.assessmentFactors){ 
                    
                    IdMatrix_Assessment_Factor__c assment = new IdMatrix_Assessment_Factor__c();
                    assment.Type__c = rul.type;
                    assment.Score__c= rul.score;
                    assment.Weight__c= rul.weight;
                    assment.Threshold__c= rul.threshold;
                    assment.Result__c= rul.result;
                    assment.Fraud_Assessment_Response__c = idfraud.Id;
                    assesment.put(assment,idfraud);
                    
                }
                
            }
            
            idfraud.Veda_IdMatrix__c = vedaId.Id;
            obj.add(idfraud);
            
        }
        
        
        if(res.phoneVerificationResponses.size()>0){
            
            for(ints.IDMatrixResponse.PhoneVerificationResponse ph : res.phoneVerificationResponses){
                
                IdMatrix_Phone_Verification_Response__c iph = new IdMatrix_Phone_Verification_Response__c();
                iph.Phone_Number__c=ph.phoneNumber;
                iph.Phone_Status__c=ph.phoneStatus;
                iph.Veda_IdMatrix__c= vedaId.Id;
                obj.add(iph);
                m.put(vedaId,iph);
            } 
            
            
            
        }
        
        if(res.deviceIntelligenceResponse!=null){
            
            IdMatrix_Device_Intelligence_Response__c device = new IdMatrix_Device_Intelligence_Response__c(); 
            device.Device_Status__c=  res.deviceIntelligenceResponse.deviceStatus;
            device.Policy_Score__c=  res.deviceIntelligenceResponse.policyScore;
            device.Policy_Score_Reason_Code__c=  res.deviceIntelligenceResponse.policyScoreReasonCode;
            
            device.Veda_IdMatrix__c =  vedaId.Id;
            obj.add(device);
            m.put(vedaId,device);
            
            
        }
        
        if(res.vevoRecords.size()>0){
            
            for(ints.IDMatrixResponse.VEVORecord ph : res.vevoRecords){
                
                IdMatrix_Vevo_Record__c vevo = new IdMatrix_Vevo_Record__c();
                vevo.Visa_Class_Subclass__c = ph.visaClassSubclass;
                vevo.Visa_Applicant__c=ph.visaApplicant;
                vevo.Visa_Date_Of_Grant__c = ph.visaDateOfGrant;
                vevo.Visa_Date_Of_Expiry__c = ph.visaDateOfExpiry;
                vevo.Visa_Work_Entitlement__c = ph.visaWorkEntitlement;
                vevo.Location__c = ph.location;
                vevo.Veda_IdMatrix__c = vedaId.Id;
                obj.add(vevo);
                m.put(vedaId,vevo);
            }    
            
        }
        
        Map<IdMatrix_Shared_Fraud_Phone_Number__c,IdMatrix_Shared_Fraud_Record__c> sharedphn = new Map<IdMatrix_Shared_Fraud_Phone_Number__c,IdMatrix_Shared_Fraud_Record__c>();
        Map<Residential_Address__c,IdMatrix_Shared_Fraud_Record__c> sharedadd = new Map<Residential_Address__c,IdMatrix_Shared_Fraud_Record__c>();
        System.debug('sharedFraudRecord='+res.sharedFraudRecord);
        if(res.sharedFraudRecord !=null){
            
            
            
            
            IdMatrix_Shared_Fraud_Record__c   sh = new IdMatrix_Shared_Fraud_Record__c();
            sh.Fraud_File_Number__c=res.sharedFraudRecord.fraudFileNumber;
            sh.Date_Fraud_Occured__c=res.sharedFraudRecord.dateFraudOccured;
            sh.Reporting_Subscriber__c=res.sharedFraudRecord.reportingSubscriber;
            sh.Reference_Number__c=res.sharedFraudRecord.referenceNumber;
            sh.Product_Code__c=res.sharedFraudRecord.productCode;
            sh.Product__c=res.sharedFraudRecord.product;
            sh.Fraud_Type_Code__c=res.sharedFraudRecord.fraudTypeCode;
            sh.Fraud_Type__c=res.sharedFraudRecord.fraudType;
            sh.Fraud_Sub_Type__c=res.sharedFraudRecord.fraudSubtype;
            sh.Employment_Status__c=res.sharedFraudRecord.employmentStatus;
            sh.Other_Comment__c=res.sharedFraudRecord.otherComment;
            sh.Employer__c=res.sharedFraudRecord.employer;
            sh.Driver_Licence_Number__c=res.sharedFraudRecord.driversLicenceNumber;
            sh.Passport_Number__c=res.sharedFraudRecord.passportNumber;
            sh.Fraud_Subject_Role__c=res.sharedFraudRecord.fraudSubjectRole;
            
            if(res.sharedFraudRecord.phoneNumbers.size()>0){
                
                for(ints.IDMatrixResponse.SharedFraudPhoneNumber ph : res.sharedFraudRecord.phoneNumbers){
                    
                    IdMatrix_Shared_Fraud_Phone_Number__c shh = new IdMatrix_Shared_Fraud_Phone_Number__c();
                    shh.Phone_Number__c=ph.phoneNumber;
                    shh.Type__c=ph.type;
                    shh.IdMatrix_Shared_Fraud_Record__c = sh.Id;
                    sharedphn.put(shh,sh);
                }    
                
            }
            
            if(res.sharedFraudRecord.addresses.size()>0){
                
                for(ints.IDMatrixResponse.SharedFraudaddress  ph : res.sharedFraudRecord.addresses){
                    
                    Residential_Address__c add = new Residential_Address__c();
                    add.Street_Number__c = ph.streetNumber;
                    add.Street_Name__c = ph.streetName;
                    add.Street_Type__c=ph.streetType;
                    add.Suburb__c=ph.suburb;
                    add.State__c=ph.state;
                    add.PostCode__c=ph.postcode;
                    add.Country__c=ph.country;
                    add.unit_Number__c=ph.unitNumber;
                    add.IdMatrix_Shared_Fraud_Record__c=sh.Id;
                    sharedadd.put(add,sh);
                }
                
            }
            sh.Veda_IdMatrix__c=vedaId.Id;
            obj.add(sh);
            
        }  
        
        Map<IdMatrix_SFD__c,IdMatrix_Accuity_Result_Record__c> sfd = new Map<IdMatrix_SFD__c,IdMatrix_Accuity_Result_Record__c>();
        if(res.accuityResultsRecord!=null){
            
            IdMatrix_Accuity_Result_Record__c acr = new IdMatrix_Accuity_Result_Record__c();
            acr.Accuity_Id__c=res.accuityResultsRecord.accuityId;
            acr.Is_Hit__c=res.accuityResultsRecord.isHit;
            acr.Search_Result_Name__c=res.accuityResultsRecord.searchResultName;
            acr.Total_Changed__c=res.accuityResultsRecord.totalChanged;
            acr.Total_Good__c=res.accuityResultsRecord.totalGood;
            acr.Total_Matches__c=res.accuityResultsRecord.totalMatches;
            acr.Total_Open__c=res.accuityResultsRecord.totalOpen;
            acr.Match_On__c=res.accuityResultsRecord.matchOn;
            acr.Matched__c=res.accuityResultsRecord.matched;
            acr.Stop_Descriptor__c=res.accuityResultsRecord.stopDescriptor;
            acr.Entity_Id__c=res.accuityResultsRecord.entityId;
            acr.Entity_Source__c=res.accuityResultsRecord.entitySource;
            acr.Entity_Version__c=res.accuityResultsRecord.entityVersion;
            
            acr.Entity_Details_Id__c=res.accuityResultsRecord.entityDetailsId;
            acr.Entity_Details_Version__c=res.accuityResultsRecord.entityDetailsVersion;
            acr.Name__c=res.accuityResultsRecord.name;
            acr.Entity_Version__c=res.accuityResultsRecord.entityVersion;
            
            acr.List_Id__c=res.accuityResultsRecord.listId;
            acr.List_Code__c=res.accuityResultsRecord.listCode;
            acr.Entity_Type__c=res.accuityResultsRecord.entityType;
            
            acr.Created_Date__c=res.accuityResultsRecord.createdDate;
            acr.Last_Update_Date__c=res.accuityResultsRecord.entityDetailsVersion;
            acr.Title__c=res.accuityResultsRecord.title;
            acr.Source__c=res.accuityResultsRecord.source;
            
            acr.Country__c=res.accuityResultsRecord.country;
            acr.Country_Name__c=res.accuityResultsRecord.countryName;
            acr.Veda_IdMatrix__c  = vedaId.Id;
            if(res.accuityResultsRecord.sfd.size()>0){
                
                for(ints.IDMatrixResponse.SFD ph : res.accuityResultsRecord.sfd){
                    
                    IdMatrix_SFD__c isfd = new IdMatrix_SFD__c();
                    isfd.name__c = ph.name;
                    isfd.sfd__c = ph.sfd;
                    isfd.Accuity_Result_Record__c = acr.Id;
                    sfd.put(isfd,acr);
                }
            }
            obj.add(acr);
            
            
        }             
        insert obj;
        Map<sObject,Id> mp = new Map<sObject,Id>();
        for(sobject s : obj){
            mp.put(s,s.Id);
            
        }
        list<sObject> child = new list<sObject>();
        
        for (IdMatrix_Assessment_Factor__c  key : assesment.keySet()) {
            
            sObject o = assesment.get(key);
            Id p = mp.get(o);
            key.Fraud_Assessment_Response__c =p;
            System.debug('P'+p);
            child.add(key);
            
        }
        
        for (IdMatrix_Shared_Fraud_Phone_Number__c  key : sharedphn.keySet()) {
            
            sObject o = sharedphn.get(key);
            Id p = mp.get(o);
            key.IdMatrix_Shared_Fraud_Record__c  =p;
            System.debug('P'+p);
            child.add(key);
            
        }
        
        for (Residential_Address__c   key : sharedadd.keySet()) {
            
            sObject o = sharedadd.get(key);
            Id p = mp.get(o);
            key.IdMatrix_Shared_Fraud_Record__c  =p;
            System.debug('P'+p);
            child.add(key);
            
        }
        for (IdMatrix_SFD__c   key : sfd.keySet()) {
            
            sObject o = sfd.get(key);
            Id p = mp.get(o);
            key.Accuity_Result_Record__c   =p;
            System.debug('P'+p);
            child.add(key);
            
        }
        
        System.debug('child'+child);
        insert child;
        
        
        //return 'Thanks';
    }
    
    
    
}
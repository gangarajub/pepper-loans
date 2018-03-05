public with sharing class VedaFraudParser implements IParser{
    
    
    public void parseResponse(ints.IntegrationResponseObject resp,String respClass,String appId){
        
        ints.VedaFraudResponseObj res = (ints.VedaFraudResponseObj)resp;
        list<sObject> obj = new list<sObject>();
        Veda_Fraud__c vf = new Veda_Fraud__c();
        vf.Service_Requested_Id__c=res.serviceRequestId;
        vf.BCA_Message_Type__c=res.bCAmessageType;
        vf.Service_Code__c=res.serviceCode;
        vf.Code_Version_Id__c=res.codeVersionId;
        vf.Client_Reference__c=res.clientReference;
        vf.Response_Version__c=res.responseVersion;
        vf.General_Message__c=res.generalMessage;
        vf.status_Code__c=res.statusCode;
        vf.Error_Status__c=res.errorStatus;
        vf.Dfat_Verification_Indicator__c=res.dfatVerificationIndicator;
        vf.Ofat_Verification_Indicator__c=res.ofacVerificationIndicator;
        vf.Application__c=appid;
        vf.Fraud_Check_Indicator__c=res.veriCheckSuiteSummaryObj.fraudCheckIndicator;
        insert vf;
        
        Veda_Fraud__c vedFr = [select Id,Name from Veda_Fraud__c where Id=: vf.Id limit 1];
        Attachment att1 = new Attachment();
        att1.parentId =  vedFr.id;
        att1.body = Blob.valueOf(res.requestXMLBody);
        att1.Name = 'Veda Fraud Request'+vedFr.Name;
        //resp.attachments.add(att);
        insert att1;
        
        
        Attachment att = new Attachment();
        att.parentId = vedFr.Id;
        att.body = Blob.valueOf(res.responseXMLBody);
        att.Name = 'Veda Fraud Response'+vedFr.Name;
        insert att; 
        System.debug('res.veriCheckSuiteSummaryObj='+res.veriCheckSuiteSummaryObj);
        if(res.veriCheckSuiteSummaryObj!=null){
            
            Veda_Fraud_Veri_Check_Suit_Summary__c vedafraud = new Veda_Fraud_Veri_Check_Suit_Summary__c();
            vedafraud.Veri_Check_Indicator__c=res.veriCheckSuiteSummaryObj.vericheckIndicator;
            vedafraud.Fraud_Check_Indicator__c=res.veriCheckSuiteSummaryObj.fraudCheckIndicator;
            vedafraud.Birth_Certificate_Verification_Indicator__c=res.veriCheckSuiteSummaryObj.birthCertificateVerificationIndicator;
            vedafraud.Ftra_Bureau_Check_Indicator__c=res.veriCheckSuiteSummaryObj.ftraBureauCheckIndicator;  
            vedafraud.Dfat_Verification_Indicator__c=res.veriCheckSuiteSummaryObj.dfatVerificationIndicator;
            vedafraud.Ofat_Verification_Indicator__c=res.veriCheckSuiteSummaryObj.ofacVerificationIndicator;
            vedafraud.Veda_Fraud__c=vf.id;
            obj.add(vedafraud);
            
        }
        System.debug('res.errorObj='+res.errorObj);
        if(res.errorObj!=null){
            Veda_Error__c verr=new Veda_Error__c();
            verr.Error_Code__c = res.errorObj.errorCode;
            verr.Error_Type__c= res.errorObj.errorType;
            verr.Input_Container__c = res.errorObj.inputContainer;
            verr.Description_Code__c= res.errorObj.descriptionCode;
            verr.Error_Description__c= res.errorObj.errorDescription;
            verr.Veda_Fraud__c=vf.id;
            obj.add(verr);
        }
        
        Map<Veda_Fraud_Address_Indicator__c ,Veda_Fraud_Phone_Listing_Result__c > map1= new Map<Veda_Fraud_Address_Indicator__c ,Veda_Fraud_Phone_Listing_Result__c >();
        Map<Veda_Fraud_Address_Indicator__c ,Veda_Fraud_Phone_Listing_Result__c > map2 = new Map<Veda_Fraud_Address_Indicator__c ,Veda_Fraud_Phone_Listing_Result__c >();
        Map<Veda_Fraud_Address_Indicator__c ,Veda_Electoral_Roll_Result_List__c > map3 = new Map<Veda_Fraud_Address_Indicator__c ,Veda_Electoral_Roll_Result_List__c >();
        Map<Veda_Fraud_Individual_Name_Indicator__c ,Veda_Electoral_Roll_Result_List__c > map4 = new Map<Veda_Fraud_Individual_Name_Indicator__c ,Veda_Electoral_Roll_Result_List__c >();
        Map<Veda_Electoral_Roll_Result_List__c ,Veda_Fraud_Veri_Check_Report__c > map5 = new Map<Veda_Electoral_Roll_Result_List__c ,Veda_Fraud_Veri_Check_Report__c >();
        Map<Veda_Fraud_Phone_Listing_Result__c ,Veda_Fraud_Veri_Check_Report__c > map6 = new Map<Veda_Fraud_Phone_Listing_Result__c ,Veda_Fraud_Veri_Check_Report__c >();
        System.debug('res.veriCheckReportobj='+res.veriCheckReportobj);
        if(res.veriCheckReportobj!=null){
            Veda_Fraud_Veri_Check_Report__c vedrep = new Veda_Fraud_Veri_Check_Report__c();
            vedrep.Report_Summary__c = res.veriCheckReportobj.reportSummary;
            vedrep.Report_Summary_Code__c= res.veriCheckReportobj.reportSummaryCode;
            vedrep.Driver_License_Result__c= res.veriCheckReportobj.driversLicenceResult;
            vedrep.Number_Indicator__c= res.veriCheckReportobj.numberIndicator;
            vedrep.Name_Indicator__c= res.veriCheckReportobj.nameIndicator;
            System.debug('res.veriCheckReportobj.phoneListingResultList='+res.veriCheckReportobj.phoneListingResultList);
            if(res.veriCheckReportobj.phoneListingResultList.size()>0){
                for(ints.VedaFraudResponseObj.PhoneListingResult phone : res.veriCheckReportobj.phoneListingResultList){
                    Veda_Fraud_Phone_Listing_Result__c phlist =  new Veda_Fraud_Phone_Listing_Result__c();
                    phlist.Phone_Listing_Result_Match_Summary__c=phone.phoneListingResultMatchSummary;
                    phlist.Phone_Listing_Result_Type__c=phone.phoneIndicator;
                    phlist.Family_Name_Indicator__c=phone.familyNameIndicator;
                    phlist.Phone_Listing_Result_Match_Summary__c=phone.initialsIndicator;
                    phlist.Veri_Check_Report__c = vedrep.Id;
                    System.debug('phone.addressIndicatorList='+phone.addressIndicatorList);
                    if(phone.addressIndicatorList.size()>0){
                        for(ints.VedaFraudResponseObj.AddressIndicator adr : phone.addressIndicatorList){
                            
                            Veda_Fraud_Address_Indicator__c addind = new Veda_Fraud_Address_Indicator__c();
                            addind.Type__c=adr.type;
                            addind.Address_Indicator_Match__c=adr.addressIndicatorMatch;
                            addind.Street_Number_Indicator__c=adr.streetNumberIndicator;
                            addind.Property_Indicator__c=adr.propertyIndicator;
                            addind.Street_Name_Indicator__c=adr.streetNameIndicator;
                            addind.Street_Type_Indicator__c=adr.streetTypeIndicator;
                            addind.suburb_Indicator__c=adr.suburbIndicator;
                            addind.State_Indicator__c=adr.stateIndicator;
                            addind.Unit_Number_Indicator__c=adr.unitNumberIndicator;
                            addind.Post_code_Indicator__c=adr.postcodeIndicator;
                            addind.Phone_Listing_Result__c=phlist.Id;
                            map1.put(addind,phlist);
                            
                        }
                    }
                    map6.put(phlist,vedrep);
                }
            } 
            System.debug('res.veriCheckReportobj.electoralRollresultList='+res.veriCheckReportobj.electoralRollresultList);
            if(res.veriCheckReportobj.electoralRollresultList.size()>0){
                for(ints.VedaFraudResponseObj.ElectoralRollresult adr : res.veriCheckReportobj.electoralRollresultList){
                    Veda_Electoral_Roll_Result_List__c roll  = new Veda_Electoral_Roll_Result_List__c();
                    roll.Electoral_Roll_Result_Match_Summary__c=adr.electoralRollresultMatchSummary;
                    roll.Type__c= adr.type;
                    System.debug('adr.addressIndicatorList='+adr.addressIndicatorList);
                    if(adr.addressIndicatorList.size()>0){
                        
                        for(ints.VedaFraudResponseObj.AddressIndicator addr : adr.addressIndicatorList){
                            
                            Veda_Fraud_Address_Indicator__c addind = new Veda_Fraud_Address_Indicator__c();
                            addind.Type__c=adr.type;
                            addind.Address_Indicator_Match__c=addr.addressIndicatorMatch;
                            addind.Street_Number_Indicator__c=addr.streetNumberIndicator;
                            addind.Property_Indicator__c=addr.propertyIndicator;
                            addind.Street_Name_Indicator__c=addr.streetNameIndicator;
                            addind.Street_Type_Indicator__c=addr.streetTypeIndicator;
                            addind.suburb_Indicator__c=addr.suburbIndicator;
                            addind.State_Indicator__c=addr.stateIndicator;
                            addind.Post_code_Indicator__c=addr.postcodeIndicator;
                            addind.Electoral_Roll_Result_List__c=roll.Id;
                            map3.put(addind,roll);
                            
                        }    
                    }
                    System.debug('adr.individualNameIndicatorObj='+adr.individualNameIndicatorObj);
                    if(adr.individualNameIndicatorObj!=null){
                        
                        Veda_Fraud_Individual_Name_Indicator__c vedaname =  new Veda_Fraud_Individual_Name_Indicator__c();
                        vedaname.Individual_Name_Indicator__c = adr.individualNameIndicatorObj.individualNameIndicator;
                        vedaname.First_Given_Name_Indicator__c = adr.individualNameIndicatorObj.firstGivenNameIndicator;
                        vedaname.First_Given_Name_Indicator_Match_Initial__c= adr.individualNameIndicatorObj.firstGivenNameIndicatorMatchInitial;
                        vedaname.Other_Given_Name_Indicator_Match_Initial__c = adr.individualNameIndicatorObj.otherGivenNameIndicatorMatchInitial;
                        vedaname.Other_Given_Name_Indicator__c = adr.individualNameIndicatorObj.otherGivenNameIndicator;
                        vedaname.Family_Name_Indicator__c = adr.individualNameIndicatorObj.familyNameIndicator;
                        vedaname.Family_Name_Indicator_Match_Initial__c = adr.individualNameIndicatorObj.familyNameIndicatorMatchInitial;
                        vedaname.Electoral_Roll_Result_List__c=roll.Id;
                        map4.put(vedaname,roll);
                    }
                    map5.put(roll,vedrep);
                }
                
            }
            
            vedrep.Veda_Fraud__c=vf.Id;
            obj.add(vedrep); 
        }
        
        Map<Fraud_Check_Result__c ,Fraud_Check_Report__c> mapa1 = new Map<Fraud_Check_Result__c ,Fraud_Check_Report__c>();
        Map<Fraud_Result_Summary__c ,Fraud_Check_Result__c > mapa2 = new Map<Fraud_Result_Summary__c ,Fraud_Check_Result__c >();
        Map<Fraud_Check_Result_Details__c ,Fraud_Check_Result__c > mapa3 = new Map<Fraud_Check_Result_Details__c ,Fraud_Check_Result__c >();
        Map<Residential_Address__c,Fraud_Check_Result_Details__c > mapa4 = new Map<Residential_Address__c,Fraud_Check_Result_Details__c >();
        
        Map<Fraud_Check_Result__c ,Fraud_Check_Report__c > mapa5 = new Map<Fraud_Check_Result__c ,Fraud_Check_Report__c>();
        System.debug('res.fraudCheckReportObj.fraudCheckResultList='+res.fraudCheckReportObj.fraudCheckResultList);
        if(res.fraudCheckReportObj.fraudCheckResultList.size()>0){
            Fraud_Check_Report__c rp = new Fraud_Check_Report__c();
            
            for(ints.VedaFraudResponseObj.FraudCheckResult addr : res.fraudCheckReportObj.fraudCheckResultList){
                Fraud_Check_Result__c checkresult = new Fraud_Check_Result__c();              
                checkresult.Fraud_File_Number__c = addr.fraudFileNumber;
                
                Fraud_Result_Summary__c fres = new Fraud_Result_Summary__c();
                fres.Fraud_Check_Phone_Indicator__c = addr.fraudResultSummaryObj.fraudCheckPhoneIndicator;
                fres.Fraud_Check_Employer_Indicator__c = addr.fraudResultSummaryObj.fraudcheckEmployerIndicator;
                fres.Fraud_Check_Employer_Phone_Indicator__c = addr.fraudResultSummaryObj.fraudCheckEmployerPhoneIndicator;
                fres.Fraud_Check_Guarantor_Phone_Indicator__c = addr.fraudResultSummaryObj.fraudCheckGuarantorPhoneIndicator;
                fres.Fraud_Check_Referee_Phone_Indicator__c = addr.fraudResultSummaryObj.fraudCheckRefereePhoneIndicator;
                fres.Fraud_Check_Address_Indicator__c = addr.fraudResultSummaryObj.fraudCheckRefereePhoneIndicator;
                fres.Fraud_Check_Drivers_Licence_Indicator__c = addr.fraudResultSummaryObj.fraudCheckDriversLicenceIndicator;
                fres.Fraud_Check_Passport_Indicator__c = addr.fraudResultSummaryObj.fraudCheckPassportIndicator;
                fres.fraudCheck_Second_Phone_Indicator__c = addr.fraudResultSummaryObj.fraudCheckSecondPhoneIndicator;
                fres.Fraud_Check_Result__c=checkresult.Id;
                mapa2.put(fres,checkresult);
                
                Fraud_Check_Result_Details__c fraudresult = new Fraud_Check_Result_Details__c();
                fraudresult.Date_Fraud_Occurred__c = addr.fraudcheckResultDetailsObj.dateFraudOccurred;
                fraudresult.Reporting_Subscriber__c = addr.fraudcheckResultDetailsObj.reportingSubscriber;
                fraudresult.Fraud_Type__c = addr.fraudcheckResultDetailsObj.fraudType;
                fraudresult.Employment_Status__c = addr.fraudcheckResultDetailsObj.employmentStatus;
                fraudresult.Fraud_Subject__c = addr.fraudcheckResultDetailsObj.fraudSubject;
                fraudresult.Fraud_Subject_Role__c    = addr.fraudcheckResultDetailsObj.fraudSubject;
                fraudresult.Date_Fraud_Occurred__c = addr.fraudcheckResultDetailsObj.dateFraudOccurred;
                fraudresult.Comment__c = addr.fraudcheckResultDetailsObj.comment;
                fraudresult.Isd_Phone_Details__c = addr.fraudcheckResultDetailsObj.isdPhoneDetails;
                fraudresult.Phone_Area_Code_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodePhoneDetails;
                fraudresult.Phone_Number_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneNumberPhoneDetails;
                fraudresult.Isd_Second_Phone_Details__c    = addr.fraudcheckResultDetailsObj.isdSecondPhoneDetails;
                fraudresult.Phone_Area_Code_Second_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeSecondPhoneDetails;
                fraudresult.Phone_Number_Second_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneNumberSecondPhoneDetails;
                fraudresult.Isd_Employer_Phone_Details__c = addr.fraudcheckResultDetailsObj.isdEmployerPhoneDetails;
                fraudresult.Phone_Area_Code_Employer_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeEmployerPhoneDetails;
                fraudresult.Phone_Number_Employer_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneNumberEmployerPhoneDetails;
                fraudresult.Isd_Referee_Phone_Details__c    = addr.fraudcheckResultDetailsObj.isdRefereePhoneDetails;
                fraudresult.Phone_Area_Code_Second_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeSecondPhoneDetails;
                fraudresult.Phone_Area_Code_Referee_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeRefereePhoneDetails;
                fraudresult.Isd_Guarantor_Phone_Details__c = addr.fraudcheckResultDetailsObj.isdGuarantorPhoneDetails;
                fraudresult.Phone_Area_Code_Guarantor_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeGuarantorPhoneDetails;
                fraudresult.Phone_Number_Guarantor_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneNumberGuarantorPhoneDetails;
                fraudresult.Isd_Referee_Phone_Details__c    = addr.fraudcheckResultDetailsObj.isdRefereePhoneDetails;
                fraudresult.Phone_Area_Code_Second_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeSecondPhoneDetails;
                fraudresult.Phone_Area_Code_Referee_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeRefereePhoneDetails;
                
                
                fraudresult.employment__c = addr.fraudcheckResultDetailsObj.employment;
                fraudresult.employer__c = addr.fraudcheckResultDetailsObj.employer;
                fraudresult.occupation__c = addr.fraudcheckResultDetailsObj.occupation;  
                fraudresult.passportNumber__c = addr.fraudcheckResultDetailsObj.passportNumber;
                fraudresult.Passport_Country_Code__c = addr.fraudcheckResultDetailsObj.passportCountryCode;
                fraudresult.Phone_Area_Code_Referee_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeRefereePhoneDetails;
                fraudresult.Phone_Area_Code_Referee_Phone_Details__c = addr.fraudcheckResultDetailsObj.phoneAreaCodeRefereePhoneDetails;
                fraudresult.Fraud_Check_Result__c = checkresult.Id;
                mapa3.put(fraudresult,checkresult);
                
                
                if(addr.fraudcheckResultDetailsObj.addressList.size()>0){
                    for(ints.VedaFraudResponseObj.Address adr : addr.fraudcheckResultDetailsObj.addressList){
                        
                        Residential_Address__c resadd = new Residential_Address__c(); 
                        resadd.Street_Number__c = adr.streetNumber;
                        resadd.Property__c = adr.property;
                        resadd.Street_Name__c = adr.streetName;
                        resadd.Street_Type__c = adr.streetType;
                        resadd.Street_Type_Code__c = adr.streetTypeCode;
                        resadd.Suburb__c = adr.suburb;
                        resadd.City__c = adr.city;
                        resadd.Unit_Number__c=adr.unitNumber;
                        resadd.State__c = adr.state;
                        resadd.Country__c = adr.country;
                        resadd.PostCode__c = adr.countryCode;
                        resadd.Country_Code__c = adr.countryCode;
                        resadd.Fraud_Check_Result_Details__c= fraudresult.Id;
                        mapa4.put(resadd,fraudresult);
                    }
                    
                }
                checkresult.Fraud_Check_Report__c=rp.Id;
                mapa5.put(checkresult,rp);
            }           
            rp.Veda_Fraud__c=vf.Id;
            obj.add(rp);
        }
        
        Map<Veda_Fraud_Bureau_Result__c ,Veda_Fraud_Bureau_Report__c > mapb1 = new  Map<Veda_Fraud_Bureau_Result__c ,Veda_Fraud_Bureau_Report__c >();  
        Map<Veda_Fraud_Address_Indicator__c ,Veda_Fraud_Bureau_Result__c > mapb2 = new Map<Veda_Fraud_Address_Indicator__c ,Veda_Fraud_Bureau_Result__c>();
        Map<Veda_Fraud_Date_Of_Birth_Indicator__c ,Veda_Fraud_Bureau_Result__c > mapb3 = new  Map<Veda_Fraud_Date_Of_Birth_Indicator__c ,Veda_Fraud_Bureau_Result__c >();  
        
        Map<Veda_Fraud_Individual_Name_Indicator__c,Veda_Fraud_Bureau_Result__c > mapb4 = new  Map<Veda_Fraud_Individual_Name_Indicator__c,Veda_Fraud_Bureau_Result__c >();  
        
        System.debug('res.bureauReportObj='+res.bureauReportObj);
        if(res.bureauReportObj!=null){
            Veda_Fraud_Bureau_Report__c vfb = new Veda_Fraud_Bureau_Report__c();
            if(res.bureauReportObj.BureauResultList.size()>0){
                for(ints.VedaFraudResponseObj.BureauResult br : res.bureauReportObj.BureauResultList){
                    Veda_Fraud_Bureau_Result__c result = new Veda_Fraud_Bureau_Result__c();
                    result.Bureau_File_Create_Date__c= br.bureauFileCreateDate;
                    result.Bureau_Report_Type__c= br.bureauReportType;
                    result.Bureau_Result_Type__c= br.bureauResultType;
                    result.Score_Indicator__c= br.scoreIndicator;
                    result.Delivery_Point_Identifier_Indicator__c= br.deliveryPointIdentifierIndicator;
                    System.debug('br.addressIndicatorList='+br.addressIndicatorList);
                    if(br.addressIndicatorList.size()>0){
                        for(ints.VedaFraudResponseObj.AddressIndicator brr : br.addressIndicatorList){
                            Veda_Fraud_Address_Indicator__c addr = new Veda_Fraud_Address_Indicator__c();
                            addr.Type__c=brr.type;
                            addr.Address_Indicator_Match__c=brr.type;
                            addr.Unit_Number_Indicator__c=brr.unitNumberIndicator;
                            addr.Street_Name_Indicator__c=brr.streetNumberIndicator;
                            addr.Property_Indicator__c=brr.propertyIndicator;
                            addr.Street_Name_Indicator__c=brr.streetNameIndicator;
                            addr.Street_Type_Indicator__c=brr.streetTypeIndicator;
                            addr.suburb_Indicator__c=brr.streetTypeIndicator;
                            addr.State_Indicator__c=brr.stateIndicator;
                            addr.Post_code_Indicator__c=brr.postcodeIndicator;
                            addr.Bureau_Result__c=result.Id; 
                            mapb2.put(addr,result);
                            
                        }
                    }
                    System.debug('br.dateofBirthIndicatorList='+br.dateofBirthIndicatorList);
                    if(br.dateofBirthIndicatorList.size()>0){
                        for(ints.VedaFraudResponseObj.DateofBirthIndicator brr : br.dateofBirthIndicatorList){
                            Veda_Fraud_Date_Of_Birth_Indicator__c birth = new Veda_Fraud_Date_Of_Birth_Indicator__c();
                            birth.Date_Of_Birth_Indicator__c = brr.dateofBirthIndicator;
                            birth.Date_Of_Birth_Day_Indicator__c= brr.dateofBirthDayIndicator;
                            birth.Date_Of_Birth_Month_Indicator__c= brr.dateofBirthMonthIndicator;
                            birth.Date_Of_Birth_Year_Indicator__c= brr.dateofBirthYearIndicator;
                            birth.Bureau_Result__c= result.Id;
                            mapb3.put(birth,result);
                        }
                    }
                    System.debug('br.individualNameIndicatorList='+br.individualNameIndicatorList);
                    if(br.individualNameIndicatorList.size()>0){
                        for(ints.VedaFraudResponseObj.IndividualNameIndicator brr : br.individualNameIndicatorList){
                            Veda_Fraud_Individual_Name_Indicator__c ind = new Veda_Fraud_Individual_Name_Indicator__c();
                            ind.Individual_Name_Indicator__c=brr.individualNameIndicator;
                            ind.First_Given_Name_Indicator_Match_Initial__c=brr.firstGivenNameIndicatorMatchInitial;
                            ind.Other_Given_Name_Indicator__c=brr.otherGivenNameIndicator;
                            ind.Individual_Name_Indicator__c=brr.individualNameIndicator;
                            ind.Other_Given_Name_Indicator_Match_Initial__c=brr.otherGivenNameIndicatorMatchInitial;
                            ind.Family_Name_Indicator__c=brr.familyNameIndicator;
                            ind.Family_Name_Indicator_Match_Initial__c=brr.familyNameIndicatorMatchInitial;
                            ind.Bureau_Result__c = result.Id;
                            mapb4.put(ind,result);
                        }
                        
                    }
                    
                    result.Bureau_Report__c=vfb.Id;
                    mapb1.put(result ,vfb);
                }    
                
                
            }
            
            vfb.Veda_Fraud__c=vf.Id;
            obj.add(vfb);
            
        } 
        Map<Veda_Fraud_Minimal_Requirements__c ,Veda_Fraud_Aml_Summary__c > mapc1 = new Map<Veda_Fraud_Minimal_Requirements__c ,Veda_Fraud_Aml_Summary__c >();
        System.debug('res.amlSummaryObj='+res.amlSummaryObj);
        if(res.amlSummaryObj!=null){
            Veda_Fraud_Aml_Summary__c aml = new Veda_Fraud_Aml_Summary__c();
            aml.Name_Address_Present__c =  res.amlSummaryObj.nameAddressPresent;
            aml.Date_Of_Birth_Present__c=  res.amlSummaryObj.dateofBirthPresent;
            aml.History_Present__c=  res.amlSummaryObj.historyPresent;
            aml.Safe_Harbour_Present__c=  res.amlSummaryObj.safeHarbourPresent;
            if(res.amlSummaryObj.minimalRequirementsObj!=null){
                Veda_Fraud_Minimal_Requirements__c min = new Veda_Fraud_Minimal_Requirements__c();
                min.Name_Address_Met__c=res.amlSummaryObj.minimalRequirementsObj.nameAddressMet;
                min.Name_And_Dob_Met__c=res.amlSummaryObj.minimalRequirementsObj.nameAndDobMet;
                min.Match_Criteria_Met__c=res.amlSummaryObj.minimalRequirementsObj.matchCriteriaMet;
                min.Aml_Summary__c =  aml.Id;
                mapc1.put(min,aml);
            }   
            aml.Veda_Fraud__c=vf.Id;
            obj.add(aml);
            
        }
        
        
        insert obj;
        for(sObject s : obj){
            system.debug('obj'+obj);
        }
        system.debug('obj='+obj);   
        Map<sObject,Id> mp = new Map<sObject,Id>();
        for(sobject s : obj){
            mp.put(s,s.Id);
        }   
        list<sObject> child1 = new list<sObject>();
        list<sObject> child2 = new list<sObject>();
        for (Veda_Fraud_Phone_Listing_Result__c key : map6.keySet()) {
            
            sObject o = map6.get(key);
            Id p = mp.get(o);
            key.Veri_Check_Report__c =p;
            System.debug('P'+p);
            child1.add(key);
            
        }
        for (Veda_Electoral_Roll_Result_List__c key : map5.keySet()) {
            
            sObject o = map5.get(key);
            Id p = mp.get(o);
            key.Veri_Check_Report__c =p;
            System.debug('P'+p);
            child1.add(key);
            
        }
        for (Fraud_Check_Result__c key : mapa5.keySet()) {
            
            sObject o = mapa5.get(key);
            Id p = mp.get(o);
            key.Fraud_Check_Report__c   =p;
            System.debug('P'+p);
            child1.add(key);
            
        }
        
        for (Veda_Fraud_Bureau_Result__c key : mapb1.keySet()) {
            
            sObject o = mapb1.get(key);
            Id p = mp.get(o);
            key.Bureau_Report__c=p;
            System.debug('P'+p);
            child1.add(key);
            
        }
        
        for (Veda_Fraud_Minimal_Requirements__c key : mapc1.keySet()) {
            
            sObject o = mapc1.get(key);
            Id p = mp.get(o);
            key.Aml_Summary__c =p;
            System.debug('P'+p);
            child1.add(key);
            
        }
        insert child1;
        
        Map<sObject,Id> mpc = new Map<sObject,Id>();
        for(sobject s : child1){
            mpc.put(s,s.Id);
        }     
        for (Veda_Fraud_Address_Indicator__c key : map1.keySet()) {
            
            sObject o = map1.get(key);
            Id p = mpc.get(o);
            key.Phone_Listing_Result__c=p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        
        
        for (Veda_Fraud_Address_Indicator__c key : map3.keySet()) {
            
            sObject o = map3.get(key);
            Id p = mpc.get(o);
            key.Electoral_Roll_Result_List__c=p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        
        for (Veda_Fraud_Individual_Name_Indicator__c key : map4.keySet()) {
            
            sObject o = map4.get(key);
            Id p = mpc.get(o);
            key.Electoral_Roll_Result_List__c=p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        
        for (Fraud_Result_Summary__c  key : mapa2.keySet()) {
            
            sObject o = mapa2.get(key);
            Id p = mpc.get(o);
            key.Fraud_Check_Result__c=p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        
        
        for(Fraud_Check_Result_Details__c  key : mapa3.keySet()) {
            
            sObject o = mapa3.get(key);
            Id p = mpc.get(o);
            key.Fraud_Check_Result__c =p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        
        
        for(Veda_Fraud_Address_Indicator__c key : mapb2.keySet()) {
            
            sObject o = mapb2.get(key);
            Id p = mpc.get(o);
            key.Bureau_Result__c=p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        
        
        
        for(Veda_Fraud_Date_Of_Birth_Indicator__c key : mapb3.keySet()) {
            
            sObject o = mapb3.get(key);
            Id p = mpc.get(o);
            key.Bureau_Result__c=p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        
        
        for(Veda_Fraud_Individual_Name_Indicator__c key : mapb4.keySet()) {
            
            sObject o = mapb4.get(key);
            Id p = mpc.get(o);
            key.Bureau_Result__c=p;
            System.debug('P'+p);
            child2.add(key);
            
        }
        insert child2;
        //return 'Thanks';
    }
    
    
    
}
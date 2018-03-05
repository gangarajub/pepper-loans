public with sharing class VedaComprehensiveParser Implements IParser{
    
    public void parseResponse(ints.IntegrationResponseObject resp,String respClass,String appId){
        
        ints.VedaComprehensiveResponse res = (ints.VedaComprehensiveResponse)resp;
        List<sObject> obj = new list<sObject>();
        List<sObject> obj1 = new List<sObject>();
        List<sObject> vedaAdd = new list<sObject>();
        list<sObject> payment2 = new list<sObject>();
        list<sObject> vedaDefault2 = new list<sObject>();
        list<sObject> character2 = new list<sObject>();
        list<sObject> contributingFactor2 = new list<sObject>();
        Map<sObject,sObject> m = new Map<sObject,sObject>();
        List<genesis__Applications__c> app = [select id,name from genesis__Applications__c where id=:appId];
        
        Veda_Comprehensive__c vc = new Veda_Comprehensive__c();
        vc.Application__c=appid;
        vc.Message_Id__c=res.messageId;
        vc.response_Type__c=res.responseType;
        vc.enquiry_Id__c=res.enquiryId;
        vc.date_time_Requested__c=res.datetimeRequested;
        vc.date_time_Generated__c=res.datetimeGenerated;
        vc.client_Reference__c=res.clientReference;
        vc.operator_Id__c = res.operatorId;
        vc.operator_Name__c=res.operatorName;
        vc.permission_Type__c=res.permissionType;
        vc.permission_Type_Code__c=res.permissionTypeCode;
        vc.product_Data_Level__c=res.productDataLevel;
        vc.product_Data_Level_Code__c= res.productDataLevelCode;
        vc.product_Version__c=res.productVersion;
        vc.primary_Match_Id_Index__c=res.primaryMatchIdIndex;
        vc.primary_Match_Type__c=res.primaryMatchIdIndex;
        vc.bureau_Reference__c =res.bureauReference;
        vc.date_Of_Birth__c=res.dateOfBirth;
        vc.family_Name__c=res.familyName;
        vc.first_Given_Name__c=res.firstGivenName;
        vc.gender__c=res.gender;
        if(res.scoreData.size()>0){
            vc.Veda_Score__c = res.scoreData[0].scoreMasterscale;
        }
        
        vc.isDeceased__c=res.isDeceased;
        vc.individual_Name_First_Reported_Date__c=res.individualNameFirstReportedDate;
        vc.individual_Name_Last_Reported_Date__c=res.individualNameLastReportedDate;
        vc.individualName_Last_Credit_Enquiry_Date__c=res.individualNameLastCreditEnquiryDate;
        vc.gender_Code__c=res.genderCode;
        vc.date_Of_Birth_First_Reported_Date__c=res.dateOfBirthFirstReportedDate;
        vc.date_Of_Birth_Last_Reported_Date__c=res.dateOfBirthLastReportedDate;
        vc.drivers_Licence_First_Reported_Date__c=res.driversLicenceFirstReportedDate;
        vc.drivers_Licence_Last_Reported_Date__c=res.driversLicenceLastReportedDate;
        vc.drivers_Licence_Number__c = res.driversLicenceNumber;
        vc.lodged_Complaint_Reported_Date__c=res.lodgedComplaintReportedDate;
        vc.lodgedComplaint__c=res.lodgedComplaint;
        vc.is_Deceased_Reported_Date__c=res.isDeceasedReportedDate;
        vc.integration_Error_Status__c=res.integrationErrorStatus;
        vc.integration_Error_Status_Code__c=res.integrationErrorStatusCode;
        String sub;
        if(res.otherGivenName.size()>0){
            
            for(String str:res.otherGivenName){
                sub=sub+'/'+str;
            }
        }
        
        vc.other_given_name__c=sub;
        insert vc;
        
        Veda_Comprehensive__c vedC = [select id,Name from Veda_Comprehensive__c where Id=:vc.Id limit 1];
        
        Attachment att1 = new Attachment();
        att1.parentId =  vedC.id;
        att1.body = Blob.valueOf(res.xmlRequest);
        att1.Name = 'Veda Comprehensive Request'+vedC.Name;
        //resp.attachments.add(att);
        insert att1;
        
        
        Attachment att = new Attachment();
        att.parentId = vc.Id;
        att.body = Blob.valueOf(res.xmlResponse);
        att.Name = 'Veda Comprehensive Response'+vedC.Name;
        insert att; 
        
        if(res.configurationDataAttributes.size()>0){
            System.debug('res.configurationDataAttributes'+res.configurationDataAttributes);
            for(ints.VedaComprehensiveResponse.configurationDataAttribute conf:res.configurationDataAttributes){
                Veda_Configuration_Data_Attribute__c vcd = new Veda_Configuration_Data_Attribute__c();
                vcd.Key__c=conf.key;
                vcd.Value__c=conf.value;
                vcd.Unit__c=conf.unit;    
                vcd.Veda_Comprehensive__c = vc.Id;   
                obj.add(vcd);  
                
            }
            
        }
        
        
        
        if(res.otherIdentities.size()>0){
            System.debug('res.otherIdentities'+res.otherIdentities);
            for(ints.VedaComprehensiveResponse.otherIdentity oth : res.otherIdentities){
                Veda_Other_Identity__c vot = new Veda_Other_Identity__c();
                vot.Id_Index__c =  oth.idIndex;
                vot.Type__c=oth.type;
                vot.bureauReference__c=oth.bureauReference;
                vot.individual_Name_First_Reported_Date__c=oth.individualNameFirstReportedDate;
                vot.individual_Name_Last_Reported_Date__c=oth.individualNameLastReportedDate;
                vot.individualName_Last_Credit_Enquiry_Date__c=oth.individualNameLastCreditEnquiryDate;
                vot.individual_Name_Family_Name__c=oth.individualNameFamilyName;
                vot.individual_Name_First_Given_Name__c=oth.individualNameFirstGivenName;
                vot.gender__c=oth.gender;
                vot.gender_Code__c = oth.genderCode;
                vot.dateOfBirth__c=oth.dateOfBirth;
                vot.date_Of_Birth_First_Reported_Date__c= oth.dateOfBirthFirstReportedDate;
                vot.dateOfBirthLastReportedDate__c=oth.dateOfBirthLastReportedDate;
                vot.drivers_LicenceFirst_Reported_Date__c=oth.driversLicenceFirstReportedDate;
                vot.drivers_Licence_Last_Reported_Date__c = oth.driversLicenceLastReportedDate;
                vot.drivers_Licence_Number__c  = oth.driversLicenceNumber;
                vot.lodged_Complaint__c = oth.lodgedComplaint;
                vot.lodged_Complaint_Reported_Date__c = oth.lodgedComplaintReportedDate;
                vot.is_Deceased__c = oth.isDeceased;
                vot.is_Deceased_Reported_Date__c = oth.isDeceasedReportedDate;
                String sub1;
                if(oth.individualNameOtherGivenName.size()>0){
                    for(String str:res.otherGivenName){
                        sub1=sub1+'/'+str;
                    }
                }
                vot.individual_Name_Other_Given_Name__c = sub1;   
                vot.Veda_Comprehensive__c =vc.Id;
                obj.add(vot); 
                
            }
            
        }
        
        if(res.addresses.size()>0){
            System.debug('res.addresses'+res.addresses);
            
            for(ints.VedaComprehensiveResponse.address resAdd : res.addresses){
                Residential_Address__c add = new Residential_Address__c();
                add.first_Reported_Date__c=resAdd.firstReportedDate;
                add.last_Reported_Date__c=resAdd.lastReportedDate;
                String sub2;
                if(resAdd.idReference.size()>0){
                    for(String str : resAdd.idReference){
                        sub2=sub2+'/'+str;
                    }
                }
                add.idReference__c=sub2;
                add.Property__c = resAdd.property;
                add.Street_Number__c = resAdd.streetNumber;
                add.Street_Name__c = resAdd.streetName;
                add.Street_Type__c = resAdd.streetType;
                add.Suburb__c = resAdd.suburb;
                add.State__c  = resAdd.state;
                add.Unit_Number__c=resAdd.unitNumber;
                add.PostCode__c = resAdd.postcode;
                add.Country__c = resAdd.countryCode;
                add.Veda_Comprehensive__c = vc.Id;    
                obj.add(add);
            }
            
            
        }
        
        
        
        if(res.employers.size()>0){
            for(ints.VedaComprehensiveResponse.employer emp : res.employers){
                Veda_Employer__c vedEmp = new Veda_Employer__c();
                vedEmp.first_Reported_Date__c = emp.firstReportedDate;
                vedEmp.last_Reported_Date__c = emp.lastReportedDate;
                vedEmp.type__c = emp.type;
                vedEmp.name__c= emp.name;
                vedEmp.occupation__c = emp.occupation;
                String sub2;
                if(emp.idReferences.size()>0){
                    for(String str : emp.idReferences){
                        sub2=sub2+'/'+str;
                    }
                }
                vedEmp.idReferences__c = sub2;
                vedEmp.Veda_Comprehensive__c=vc.Id;
                obj.add(vedEmp);
            }                       
        }
        System.debug('res.fileNotes'+res.fileNotes);
        
        
        if(res.fileNotes.size()>0){   
            System.debug('res.fileNotes'+res.fileNotes);
            for(ints.VedaComprehensiveResponse.fileNote file : res.fileNotes){
                Veda_file_Note__c vf = new Veda_file_Note__c();
                vf.date_Recorded__c = file.dateRecorded;
                vf.note__c= file.note;
                String sub3;
                if(file.idReferences.size()>0){
                    for(String str : file.idReferences){
                        sub3=sub3+'/'+str;
                    }
                }
                vf.id_References__c = sub3; 
                vf.Veda_Comprehensive__c = vc.Id;
                obj.add(vf);   
            }
            
        }
        
        if(res.creditEnquiries.size()>0){
            System.debug('res.creditEnquiries'+res.creditEnquiries);
            for(ints.VedaComprehensiveResponse.creditEnquiry  cred : res.creditEnquiries){
                Veda_credit_Enquiry__c veda = new Veda_credit_Enquiry__c();
                veda.Type__c  = cred.type;
                veda.TypeOfEnquiry__c='consumer';
                veda.enquiryDate__c = cred.enquiryDate;
                veda.account_Type__c = cred.accountType;
                veda.account_Type_Code__c = cred.accountTypeCode;
                veda.enquiry_Amount__c = cred.enquiryAmount;
                veda.enquiry_Amount_Currency_Code__c = cred.enquiryAmountCurrencyCode;
                veda.relationship__c = cred.relationship;
                veda.relationship_Code__c = cred.relationshipCode;
                veda.co_Borrower__c = cred.coBorrower;
                veda.credit_Enquirer_Name__c =cred.creditEnquirerName;
                veda.enquiry_Client_Reference__c = cred.enquiryClientReference;
                veda.Credit_Enquiry_Classification__c = cred.creditEnquirerClassification;
                veda.Veda_Comprehensive__c = vc.Id;
                obj.add(veda);
            }
            
        }
        if(res.commercialCreditFileCreditEnquiries.size()>0){
            System.debug('res.commercialCreditFileCreditEnquiries '+res.commercialCreditFileCreditEnquiries);
            for(ints.VedaComprehensiveResponse.creditEnquiry cred : res.commercialCreditFileCreditEnquiries){
                Veda_credit_Enquiry__c veda = new Veda_credit_Enquiry__c();
                veda.Type__c  = cred.type;
                veda.TypeOfEnquiry__c='commercial';
                veda.enquiryDate__c = cred.enquiryDate;
                veda.account_Type__c = cred.accountType;
                veda.account_Type_Code__c = cred.accountTypeCode;
                veda.enquiry_Amount__c = cred.enquiryAmount;
                veda.enquiry_Amount_Currency_Code__c = cred.enquiryAmountCurrencyCode;
                veda.relationship__c = cred.relationship;
                veda.relationship_Code__c = cred.relationshipCode;
                veda.co_Borrower__c = cred.coBorrower;
                veda.credit_Enquirer_Name__c =cred.creditEnquirerName;
                veda.enquiry_Client_Reference__c = cred.enquiryClientReference;
                veda.Credit_Enquiry_Classification__c = cred.creditEnquirerClassification;
                veda.Veda_Comprehensive__c = vc.Id;
                obj.add(veda);
            }
            
        } 
        Map<Veda_Payment__c ,Veda_Account__c> vedapayment = new Map<Veda_Payment__c  ,Veda_Account__c>();
        Map<Veda_Comprehensive_default__c ,Veda_Account__c> vedadefault = new Map<Veda_Comprehensive_default__c  ,Veda_Account__c>();
        if(res.accounts.size()>0){
            System.debug('res.accounts'+res.accounts);
            for(ints.VedaComprehensiveResponse.account veda : res.accounts){
                Veda_Account__c  vedacc = new Veda_Account__c();
                vedacc.latest_Update_Date__c = veda.latestUpdateDate;
                vedacc.account_Data_Level__c = veda.accountDataLevel;
                vedacc.accountId__c= veda.accountId;
                vedacc.original_Credit_Provider_Name__c =veda.originalCreditProviderName;
                vedacc.original_Credit_Provider_Is_Licensee__c = veda.originalCreditProviderIsLicensee;
                vedacc.Original_credit_provider_classification__c = veda.originalCreditProviderClassification;
                vedacc.latest_Credit_Provider_Name__c = veda.latestCreditProviderName;
                vedacc.latest_Credit_Provider_Is_Licensee__c = veda.latestCreditProviderIsLicensee;
                vedacc.latest_Credit_provider_classification__c = veda.latestCreditProviderClassification;
                vedacc.account_Type__c = veda.accountType;
                vedacc.account_Type_Code__c = veda.accountTypeCode;
                vedacc.relationship__c = veda.relationship;
                vedacc.relationship_Code__c= veda.relationshipCode;
                vedacc.account_Holder_Count__c = veda.accountHolderCount;
                vedacc.account_Open_Date__c  = veda.accountOpenDate;
                vedacc.account_Closed_Date__c = veda.accountClosedDate;
                vedacc.account_Reopen_Date__c = veda.accountReopenDate;
                vedacc.loan_Payment_Method__c = veda.loanPaymentMethod;
                vedacc.loan_Payment_Method_Code__c = veda.loanPaymentMethodCode;
                vedacc.term_Type__c =  veda.termType;
                vedacc.term_Type_Code__c = veda.termTypeCode;
                vedacc.secured_Credit__c= veda.securedCredit;
                vedacc.secured_Credit_Code__c = veda.securedCreditCode;
                vedacc.term_Of_Loan__c= veda.termOfLoan;
                vedacc.original_Maximum_Amount_Credit__c = veda.originalMaximumAmountCredit;
                vedacc.originalMaximumAmountCreditCurrencyCode__c = veda.originalMaximumAmountCreditCurrencyCode;
                vedacc.latestMaximumAmountCredit__c = veda.latestMaximumAmountCredit;
                vedacc.latestMaximumAmountCreditCurrencyCode__c = veda.latestMaximumAmountCreditCurrencyCode;
                vedacc.date_Last_Changed__c = veda.dateLastChanged;
                vedacc.is_Unlimited_Credit__c= veda.isUnlimitedCredit;
                vedacc.associationInformationLatestStartDate__c=veda.associationInformationLatestStartDate;
                vedacc.associationInformationLatestCeasedDate__c = veda.associationInformationLatestCeasedDate;
                vedacc.associationInformationIsSeriousCreditInf__c = veda.associationInformationIsSeriousCreditInfringement;
                vedacc.associationInformationSciDate__c = veda.associationInformationSciDate;
                vedacc.Default_Association_Start_Date__c = veda.associationInformationDefaultAssociationStartDate;
                vedacc.DefaultAssociationCeaseDate__c = veda.associationInformationDefaultAssociationCeaseDate;
                
                if(veda.repaymentHistory.size()>0){
                    for(ints.VedaComprehensiveResponse.payment pm : veda.repaymentHistory){
                        Veda_Payment__c p = new Veda_Payment__c();
                        p.Period__c=pm.period;
                        p.Status__c=pm.status;
                        p.Veda_Account__c= vedacc.Id;
                        payment2.add(p);    
                        m.put(p,vedacc);
                        vedapayment.put(p,vedacc);
                    }
                    
                }
                
                if(veda.defaults.size()>0){
                    for(ints.VedaComprehensiveResponse.VedaComprehensivedefault def: veda.defaults){
                        Veda_Comprehensive_default__c vdf= new Veda_Comprehensive_default__c();
                        vdf.Status__c=def.status;
                        vdf.status_Code__c=def.statusCode;
                        vdf.status_Date__c=def.statusDate;
                        vdf.original_Default_Date_Recorded__c=def.originalDefaultDateRecorded;
                        vdf.original_Default_DefaultAmount__c=def.originalDefaultDefaultAmount;
                        vdf.originalDefaultAmountCurrencyCode__c=def.originalDefaultDefaultAmountCurrencyCode;
                        vdf.DefaultReasonToReportCurrencyCode__c = def.originalDefaultDefaultReasonToReportCode;
                        vdf.Default_Reason_To_Report__c= def.originalDefaultDefaultReasonToReport;
                        vdf.Default_Date_Recorded__c=def.currentDefaultDateRecorded;
                        vdf.Default_DefaultAmount__c=def.currentDefaultDefaultAmount;
                        vdf.Default_Amount_Currency_Code__c=def.currentDefaultDefaultAmountCurrencyCode;
                        vdf.reasonToReport__c = def.currentDefaultReasonToReport;
                        vdf.reason_To_Report_Code__c = def.currentDefaultReasonToReportCode;
                        vdf.Veda_Account__c= vedacc.Id;
                        vedaDefault2.add(vdf);
                        // m.put(vdf,vedacc);
                        vedadefault.put(vdf,vedacc);
                        
                    }
                    
                }
                vedacc.Veda_Comprehensive__c= vc.Id;
                obj.add(vedacc);
            }
            
            
        }
        
        if(res.generalMessages!=null){
            System.debug('res.generalMessages'+res.generalMessages);
            Veda_General_Messages__c gm = new Veda_General_Messages__c();
            gm.code__c = res.generalMessages.code;
            gm.message__c = res.generalMessages.message;
            gm.Veda_Comprehensive__c= vc.Id;
            obj.add(gm);
            
            
        }
        
        if(res.courtActions.size()>0){
            System.debug('res.courtActions'+res.courtActions);
            for(ints.VedaComprehensiveResponse.courtAction court : res.courtActions){
                Veda_Court_Action__c vco  = new Veda_Court_Action__c();
                vco.action_Date__c = court.actionDate;
                vco.court_Type__c = court.courtActionType;
                vco.creditor__c = court.creditor;
                vco.courtActionAmount__c= court.courtActionAmount;
                vco.creditor_Currency_Code__c =court.courtActionAmountCurrencyCode;
                vco.plaint_Number__c = court.plaintNumber;
                vco.relationship__c = court.relationship;
                vco.relationship_Code__c = court.relationshipCode;
                vco.co_Borrower__c = court.coBorrower;
                vco.court_Action_Status__c = court.courtActionStatus;
                vco.court_Action_Status_Date__c= court.courtActionStatusDate;
                vco.court_Action_Status_Code__c=court.courtActionStatusCode;
                vco.Veda_Comprehensive__c = vc.Id;
                obj.add(vco);
            }
            
        }
        
        if(res.disqualifiedDirectorships.size()>0){
            System.debug('res.disqualifiedDirectorships'+res.disqualifiedDirectorships);
            for(ints.VedaComprehensiveResponse.disqualifiedDirectorship dict : res.disqualifiedDirectorships){
                Veda_dis_qualified_Directorship__c dic =  new Veda_dis_qualified_Directorship__c();
                dic.last_Extract_Date__c=dict.lastExtractDate;
                dic.last_Extract_Time__c=dict.lastExtractTime;
                dic.last_Update_Date__c = dict.lastUpdateTime;
                dic.date_Disqualified__c = dict.dateDisqualified;
                dic.date_Disqualified_Until__c= dict.dateDisqualifiedUntil;
                dic.Veda_Comprehensive__c=vc.Id;
                obj1.add(dic);
                
            }
            
        }
        
        if(res.directorships.size()>0){
            System.debug('res.directorships'+res.directorships);
            for(ints.VedaComprehensiveResponse.directorship ds : res.directorships){
                Veda_directorship__c ved  = new Veda_directorship__c();
                ved.Type__c=ds.type;
                ved.last_Extract_Date__c=ds.lastExtractDate;
                ved.last_Extract_Time__c=ds.lastExtractTime;
                ved.last_Update_Date__c = ds.lastUpdateDate;
                ved.last_Update_Time__c = ds.lastUpdateTime;
                ved.date_Appointed__c= ds.dateAppointed;
                ved.date_Ceased__c= ds.dateCeased;
                ved.Last_Known_As_Director__c=ds.dateLastKnownAsDirector;
                ved.organisation_Bureau_Reference__c=ds.organisationBureauReference;
                ved.organisation_Name__c=ds.organisationName;
                ved.organisation_Name_Start_Date__c=ds.organisationNameStartDate;
                ved.organisation_Type__c=ds.organisationType;
                ved.organisation_Type_Code__c=ds.organisationTypeCode;
                ved.organisation_Status__c=ds.organisationStatus;
                ved.organisation_Status_Code__c = ds.organisationStatusCode;
                ved.organisation_Organisation_Number__c=ds.organisationOrganisationNumber;
                ved.organisation_ABN__c =  ds.organisationABN;
                ved.Veda_Comprehensive__c=vc.Id;
                obj1.add(ved);
                
                
            }
            
        }
        
        if(res.businessNames.size()>0){
            System.debug('res.businessNames'+res.businessNames);
            for(ints.VedaComprehensiveResponse.businessName bsn : res.businessNames){
                
                Veda_Business_Name__c bn = new Veda_Business_Name__c();
                bn.last_Extract_Date__c=bsn.lastExtractDate;
                bn.last_Extract_Time__c=bsn.lastExtractTime;
                bn.last_Update_Date__c = bsn.lastUpdateDate;
                bn.last_Update_Time__c = bsn.lastUpdateTime;
                bn.start_Date__c = bsn.startDate;
                bn.business_Bureau_Reference__c=bsn.businessBureauReference;
                bn.StateOrRegistrationState__c = bsn.businessPreviousStateOrTerritoryRegistrationState;
                bn.business_Number__c = bsn.businessNumber;
                bn.business_ABN__c = bsn.businessABN;
                bn.Veda_Comprehensive__c = vc.Id;
                obj1.add(bn);
            }
            
            
            
        }
        
        if(res.personalInsolvencies.size()>0){
            System.debug('res.personalInsolvencies'+res.personalInsolvencies);
            for(ints.VedaComprehensiveResponse.personalInsolvency prs : res.personalInsolvencies){
                
                Veda_personal_Insolvency__c pr = new Veda_personal_Insolvency__c();
                pr.type__c = prs.type;
                pr.type_Code__c = prs.typeCode;
                pr.date_Declared__c=prs.dateDeclared;
                pr.text__c = prs.text;
                pr.administration_Id_District__c = prs.administrationIdDistrict;
                pr.administration_Id_Year__c = prs.administrationIdYear;
                pr.administration_Id_Number__c= prs.administrationIdNumber;
                pr.administration_Id_Proceedings_Status__c = prs.administrationIdProceedingsStatus;
                pr.status__c = prs.status;
                pr.status_Code__c = prs.statusCode;
                pr.status_Date__c = prs.statusDate;
                pr.relationship__c = prs.relationship;
                pr.relationship_Code__c=prs.relationshipCode;
                pr.co_Borrower__c= prs.coBorrower;
                pr.Veda_Comprehensive__c = vc.Id;
                obj1.add(pr);
            }
        }
        
        if(res.fileBanReport!=null){
            
            System.debug('FileBanReport'+res.fileBanReport);
            Veda_File_Ban_Report__c ban= new Veda_File_Ban_Report__c();
            ban.reported_Date__c = res.fileBanReport.reportedDate;
            ban.is_Extended__c = res.fileBanReport.isExtended;
            ban.end_Date__c=res.fileBanReport.endDate;
            ban.Veda_Comprehensive__c = vc.Id;
            obj1.add(ban);
            
            
        }
        Map<Veda_Characteristic__c,Veda_Data_Block__c> mapchr = new Map<Veda_Characteristic__c ,Veda_Data_Block__c>();
        if(res.summaryData.size()>0){
            System.debug('res.summaryData'+res.summaryData); 
            
            for(ints.VedaComprehensiveResponse.DataBlock db : res.summaryData){
                Veda_Data_Block__c dbl = new Veda_Data_Block__c();
                dbl.Type__c = db.type;
                dbl.name__c=db.name;
                dbl.Veda_Comprehensive__c =vc.Id;
                insert dbl;
                
                if(db.characteristic.size()>0){
                    for(ints.VedaComprehensiveResponse.Characteristic chr : db.characteristic){
                        Veda_Characteristic__c ch= new Veda_Characteristic__c();
                        ch.characteristic_Id__c=chr.characteristicId;
                        ch.data_Level__c=chr.dataLevel;
                        ch.key_Characteristic__c=chr.keyCharacteristic;
                        ch.variable_Name__c=chr.variableName;
                        ch.description__c=chr.description;
                        if(app.size()>0){
                            if(chr.description.equalsIgnoreCase(Label.ConsumerDefault12Months)){
                            app[0].ConsumerDefaultInLast12Months__c=chr.value;
                            }
                            else if(chr.description.equalsIgnoreCase(Label.ConsumerDefault60Months)){
                            app[0].ConsumerDefaultInLast60_84Months__c=chr.value;
                            }
                            else if(chr.description.equalsIgnoreCase(Label.ConsumerDefaultLessThan60Months)){
                            app[0].ConsumerDefaultInLess60_84Months__c=chr.value;
                            }
                            else if(chr.description.equalsIgnoreCase(Label.DollarAmountInLast12Months)){
                            app[0].DollarAmountInLast12Months__c=chr.value;
                            }
                            else if(chr.description.equalsIgnoreCase(Label.DollarAmountInLast60Months)){
                            app[0].DollarAmountInLast60_80Months__c=chr.value;
                            }
                            else if(chr.description.equalsIgnoreCase(Label.CommercialDefault12Months)){
                            app[0].CommercialDefault12Months__c=chr.value;
                            }
                            else if(chr.description.equalsIgnoreCase(Label.CommercialTelcoDefault12Months)){
                            app[0].CommercialTelcoDefault12Months__c=chr.value;
                            }
                            else if(chr.description.equalsIgnoreCase(Label.ConsumerTelcoDefault12Months)){
                            app[0].ConsumerTelcoDefault12Months__c =chr.value;
                            }
                            
                            
                        }
                        
                        ch.value__c=chr.value;
                        ch.unit__c=chr.unit;
                        ch.data_Level_Code__c=chr.dataLevelCode;
                        ch.Veda_Data_Block__c=dbl.Id;
                        
                        
                        mapchr.put(ch,dbl);
                        
                    } 
                    
                    update app[0];
                }
               
                //obj1.add(dbl);
                
                
            }
            
        }
        Map<Veda_Contributing_Factor__c,Veda_Score__c > mpfactor = new Map<Veda_Contributing_Factor__c,Veda_Score__c>();
        if(res.scoreData.size()>0){
            System.debug('res.ScoreData'+res.ScoreData);
            for(ints.VedaComprehensiveResponse.Score scr: res.scoreData){
                Veda_Score__c vs = new Veda_Score__c();
                vs.score_Id__c=  scr.scoreId;
                vs.score_Name__c = scr.scoreName;
                vs.score_Version__c=scr.scoreVersion;
                vs.score_Type__c = scr.scorType;
                vs.score_Data_Level__c = scr.scoreDataLevel;
                vs.score_Data_Level_Code__c = scr.scoreDataLevelCode;
                vs.risk_Odds__c= scr.riskOdds;
                vs.score_Master_scale__c =  scr.scoreMasterscale;
                vs.Veda_Comprehensive__c = vc.Id;
                insert vs;
                if(scr.contributingFactor.size()>0){
                    for(ints.VedaComprehensiveResponse.ContributingFactor vf: scr.contributingFactor){
                        Veda_Contributing_Factor__c vcf = new Veda_Contributing_Factor__c();
                        vcf.contributing_Factor_Id__c=vf.contributingFactorId;
                        vcf.name__c=vf.name;
                        vcf.score_Impactor__c=vf.scoreImpactor; 
                        vcf.Score__c = vs.Id;
                        
                        contributingFactor2.add(vcf);
                        
                        mpfactor.put(vcf,vs);
                    }
                }
                //obj1.add(vs); 
                
            }
            
        }
        if(res.possibleMatches.size()>0){
            
            System.debug('res.possibleMatches'+res.possibleMatches);
            Veda_Possible_Match__c pss = new Veda_Possible_Match__c();
            pss.Veda_Comprehensive__c= vc.Id;
            insert pss;
            
            Veda_Primary_Match__c vm = new Veda_Primary_Match__c();
            vm.id_Index__c = res.possibleMatches[0].identity.idIndex;
            vm.type__c =  res.possibleMatches[0].identity.type;
            vm.bureau_Reference__c = res.possibleMatches[0].identity.bureauReference;
            vm.individual_Name_First_Reported_Date__c = res.possibleMatches[0].identity.individualNameFirstReportedDate;
            vm.individual_Name_Last_Reported_Date__c = res.possibleMatches[0].identity.individualNameLastReportedDate;
            vm.individualName_Last_Credit_Enquiry_Date__c =res.possibleMatches[0].identity.individualNameLastCreditEnquiryDate;
            vm.individual_Name_Family_Name__c=res.possibleMatches[0].identity.individualNameFamilyName;
            vm.individual_Name_First_Given_Name__c=res.possibleMatches[0].identity.individualNameFirstGivenName;
            vm.gender__c= res.possibleMatches[0].identity.gender;
            vm.gender_Code__c =res.possibleMatches[0].identity.genderCode;
            vm.date_Of_Birth__c=res.possibleMatches[0].identity.dateOfBirth;
            vm.date_Of_Birth_First_Reported_Date__c=res.possibleMatches[0].identity.dateOfBirthFirstReportedDate;
            vm.date_Of_Birth_Last_Reported_Date__c=res.possibleMatches[0].identity.dateOfBirthLastReportedDate;
            vm.drivers_Licence_First_Reported_Date__c=res.possibleMatches[0].identity.driversLicenceFirstReportedDate;
            vm.drivers_Licence_Last_Reported_Date__c=res.possibleMatches[0].identity.driversLicenceLastReportedDate;
            vm.drivers_Licence_Number__c=res.possibleMatches[0].identity.driversLicenceNumber;
            vm.lodged_Complaint__c=res.possibleMatches[0].identity.lodgedComplaint;
            vm.lodged_Complaint_Reported_Date__c=res.possibleMatches[0].identity.lodgedComplaintReportedDate;
            vm.is_Deceased__c=res.possibleMatches[0].identity.isDeceased;
            vm.is_Deceased_Reported_Date__c=res.possibleMatches[0].identity.isDeceasedReportedDate;
            vm.Possible_Match__c= pss.Id;
            obj1.add(vm);
            if(res.possibleMatches[0].addresses.size()>0){
             for(ints.VedaComprehensiveResponse.address resAdd : res.possibleMatches[0].addresses){
                 Residential_Address__c addr = new Residential_Address__c();
                addr.first_Reported_Date__c=resAdd.firstReportedDate;
                addr.last_Reported_Date__c=resAdd.lastReportedDate;
                String sub2;
                if(resAdd.idReference.size()>0){
                    for(String str : resAdd.idReference){
                        sub2=sub2+'/'+str;
                    }
                }
                addr.idReference__c=sub2;
                addr.Property__c = resAdd.property;
                addr.Street_Number__c = resAdd.streetNumber;
                addr.Street_Name__c = resAdd.streetName;
                addr.Street_Type__c = resAdd.streetType;
                addr.Suburb__c = resAdd.suburb;
                addr.State__c  = resAdd.state;
                addr.Unit_Number__c=resAdd.unitNumber;
                addr.PostCode__c = resAdd.postcode;
                addr.Country__c = resAdd.countryCode;
                addr.Veda_Possible_Match__c=pss.Id;
                obj1.add(addr);
             }
            }
             if(res.possibleMatches[0].employment.size()>0){
               for(ints.VedaComprehensiveResponse.employer emp : res.possibleMatches[0].employment){
                Veda_Employer__c vedEmp = new Veda_Employer__c();
                vedEmp.first_Reported_Date__c = emp.firstReportedDate;
                vedEmp.last_Reported_Date__c = emp.lastReportedDate;
                vedEmp.type__c = emp.type;
                vedEmp.name__c= emp.name;
                vedEmp.occupation__c = emp.occupation;
                String sub2;
                if(emp.idReferences.size()>0){
                    for(String str : emp.idReferences){
                        sub2=sub2+'/'+str;
                    }
                }
                vedEmp.idReferences__c = sub2;
                vedEmp.Possible_Match__c=pss.Id;
                obj1.add(vedEmp);
            }                
           }
            
            
        }
        
        insert obj;
        insert obj1;
        Map<sObject,Id> mp = new Map<sObject,Id>();
        for(sobject s : obj){
            mp.put(s,s.Id);
            
        }
        System.debug('map'+mp);
        list<sObject> child = new list<sObject>();
        for (Veda_Comprehensive_default__c key : vedadefault.keySet()) {
            
            sObject o = vedadefault.get(key);
            Id p = mp.get(o);
            key.Veda_Account__c =p;
            System.debug('P'+p);
            child.add(key);
            
        }
        for (Veda_Payment__c key : vedapayment.keySet()) {
            
            sObject o = vedapayment.get(key);
            Id p = mp.get(o);
            key.Veda_Account__c =p;
            System.debug('P'+p);
            child.add(key);
            
        }
        
        for (Veda_Characteristic__c key : mapchr.keySet()) {
            
            //sObject o = mapchr.get(key);
            //Id p = mp.get(o);
            //key.Veda_Data_Block__c=p;
            //System.debug('P'+p);
            child.add(key);
            
        }
        for (Veda_Contributing_Factor__c key : mpfactor.keySet()) {
            
            //sObject o = mpfactor.get(key);
            //Id p = mp.get(o);
            //key.Score__c=p;
            //System.debug('P'+p);
            child.add(key);
            
        }
        
        
        
        
        insert child;
  
        
 }
    
    
    
}
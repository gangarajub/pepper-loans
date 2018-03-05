public with sharing class DandBParser Implements IParser{

    public void parseResponse(ints.IntegrationResponseObject resp,String respClass,String appId){
        ints.DunAndBradstreetResponse dnbRes= (ints.DunAndBradstreetResponse)resp;
        List<sObject> obj = new List<sObject>(); 
        DandB__c dnb = new DandB__c();
        if(dnbRes!=null){
        
        dnb.birthDay__c=dnbRes.birthDay;
        dnb.birthMonth__c=dnbRes.birthMonth;
        dnb.birthYear__c=dnbRes.birthYear;
        dnb.consumerId__c=dnbRes.consumerId;
        dnb.disclosure__c=dnbRes.disclosure;
        dnb.driversLicenceNumber__c=dnbRes.driversLicenceNumber;
        dnb.employer__c=dnbRes.employer;
        dnb.enquiryMonth__c=dnbRes.enquiryMonth;
        dnb.enquiryYear__c=dnbRes.enquiryYear;
        dnb.environment__c=dnbRes.environment;
        dnb.firstName__c=dnbRes.firstName;
        dnb.firstRecordedDay__c=dnbRes.firstRecordedDay;
        dnb.firstRecordedMonth__c=dnbRes.firstRecordedMonth;
        dnb.firstRecordedYear__c=dnbRes.firstRecordedYear;
        dnb.hasDefault__c=dnbRes.hasDefault;
        dnb.hasDirector__c=dnbRes.hasDirector;
        dnb.hasEnquiry__c=dnbRes.hasEnquiry;
        dnb.hasError__c=dnbRes.hasError;
        dnb.hasFileNote__c=dnbRes.hasFileNote;
        dnb.hasJudgment__c=dnbRes.hasJudgment;
        dnb.hasOtherPublicRecord__c=dnbRes.hasOtherPublicRecord;
        dnb.hasSummary__c=dnbRes.hasSummary;
        dnb.hasWarning__c=dnbRes.hasWarning;
        dnb.indSegId__c=dnbRes.indSegId;
        dnb.integrationErrorStatus__c=dnbRes.integrationErrorStatus;
        dnb.internalReference__c=dnbRes.internalReference;
        dnb.isMinor__c=dnbRes.isMinor;
        dnb.newFileCreated__c=dnbRes.newFileCreated;
        dnb.otherName__c=dnbRes.otherName;
        dnb.personFirstName__c=dnbRes.personFirstName;
        dnb.personOtherName__c=dnbRes.personOtherName;
        dnb.personSurname__c=dnbRes.personSurname;
        dnb.possibleMchDobDay__c=dnbRes.possibleMchDobDay;
        dnb.possibleMchDobMonth__c=dnbRes.possibleMchDobMonth;
        dnb.possibleMchDobYear__c=dnbRes.possibleMchDobYear;
        dnb.possibleMchFirstName__c=dnbRes.possibleMchFirstName;
        dnb.possibleMchFirstRecordedDay__c=dnbRes.possibleMchFirstRecordedDay;
        dnb.possibleMchFirstRecordedMonth__c=dnbRes.possibleMchFirstRecordedMonth;
        dnb.possibleMchFirstRecordedYear__c=dnbRes.possibleMchFirstRecordedYear;
        dnb.possibleMchIndConsumerId__c=dnbRes.possibleMchIndConsumerId;
        dnb.possibleMchIndSegId__c=dnbRes.possibleMchIndSegId;
        dnb.possibleMchOtherName__c=dnbRes.possibleMchOtherName;
        dnb.possibleMchSegId__c=dnbRes.possibleMchSegId;
        dnb.possibleMchSequence__c=dnbRes.possibleMchSequence;
        dnb.possibleMchSex__c=dnbRes.possibleMchSex;
        dnb.possibleMchSurname__c=dnbRes.possibleMchSurname;
        dnb.productCode__c=dnbRes.productCode;
        dnb.rawRequest__c=dnbRes.rawRequest;
        dnb.rawResponse__c=dnbRes.rawResponse;
        dnb.score__c=dnbRes.score;
        dnb.scoreBand__c=dnbRes.scoreBand;
        dnb.scorecardIndicator__c=dnbRes.scorecardIndicator;
        dnb.scoreDay__c=dnbRes.scoreDay;
        dnb.scoreMonth__c=dnbRes.scoreMonth;
        dnb.scoreName__c=dnbRes.scoreName;
        dnb.scoreYear__c=dnbRes.scoreYear;
        dnb.segId__c=dnbRes.segId;
        dnb.sex__c=dnbRes.sex;
        dnb.summarySegId__c=dnbRes.summarySegId;
        dnb.summarySequence__c=dnbRes.summarySequence;
        dnb.surname__c=dnbRes.surname;
        dnb.summarySequence__c=dnbRes.summarySequence;
        dnb.trailerSegId__c=dnbRes.trailerSegId;
        dnb.uniqueCustomerReference__c=dnbRes.uniqueCustomerReference;
        dnb.version__c=dnbRes.version;
        
        
            System.debug('res inside'+dnbRes);
            dnb.Application__c=appId;
            insert dnb;   
            DandB__c d = [select id,name from DandB__c where id=:dnb.Id];
            Attachment att1 = new Attachment();
            att1.parentId =  d.id;
            att1.body = Blob.valueOf(dnbRes.rawResponse);
            att1.Name = 'DandB Response'+d.Name;
            
            insert att1;
            
            Attachment att = new Attachment();
            att.parentId = dnb.Id;
            att.body = Blob.valueOf(dnbRes.rawRequest);
            att.Name = 'DandB Request'+d.Name;
            insert att; 
        }
        
        if(dnbRes.addressDetails.size()>0){
            for(ints.DunAndBradstreetResponse.ContactAddress con:dnbRes.addressDetails){
                DandB_ContactAddress__c dnbContact = new DandB_ContactAddress__c();
                dnbContact.buildingName__c=con.buildingName;
                dnbContact.buildingName2__c=con.buildingName2;
                dnbContact.city__c=con.city;
                dnbContact.isCurrent__c=con.isCurrent;
                dnbContact.isMailing__c=con.isMailing;
                dnbContact.isPriorAddress__c=con.isPriorAddress;
                dnbContact.LastRecordedDay__c=con.LastRecordedDay;
                dnbContact.LastRecordedMonth__c=con.LastRecordedMonth;
                dnbContact.LastRecordedYear__c=con.LastRecordedYear;
                dnbContact.Postcode__c=con.Postcode;
                dnbContact.recordedMonth__c=con.recordedMonth;
                dnbContact.LastRecordedYear__c=con.LastRecordedYear;
                dnbContact.recordedYear__c=con.recordedYear;
                dnbContact.State__c=con.State;
                dnbContact.streetNo__c=con.streetNo;
                dnbContact.streetType__c=con.streetType;
                dnbContact.unitNo__c=con.unitNo;
                dnbContact.DandB__c=dnb.Id;
                obj.add(dnbContact);                
            }
            
        }
        
        if(dnbRes.scoreMeasures.size()>0){
            for(ints.DunAndBradstreetResponse.ScoreMeasureType sc:dnbRes.scoreMeasures){
                DandB_ScoreMeasureType__c score = new DandB_ScoreMeasureType__c();
                score.MeasureType__c=sc.MeasureType;
                score.Value__c=sc.Value;
                score.DandB__c=dnb.Id;
                obj.add(score);
            }
        }
        
        if(dnbRes.keyInfluencingFactors.size()>0){
            for(ints.DunAndBradstreetResponse.KeyInfluencingFactor sc:dnbRes.keyInfluencingFactors){
                DandB_KeyInfluencingFactor__c dnbkey = new DandB_KeyInfluencingFactor__c();
                dnbkey.code__c=sc.code;
                dnbkey.desctiption__c=sc.description;
                dnbkey.DandB__c=dnb.Id;
                obj.add(dnbkey);
            }
        }
        if(dnbRes.summary.size()>0){
            for(ints.DunAndBradstreetResponse.SummaryItem dnbsumdata:dnbRes.summary){
                
                DandB_SummaryItem__c dnbsum = new DandB_SummaryItem__c();
                dnbsum.samount__c= dnbsumdata.samount;
                dnbsum.scount__c= dnbsumdata.scount;
                dnbsum.segId__c= dnbsumdata.segId;
                dnbsum.sequence__c= dnbsumdata.sequence;
                dnbsum.stype__c= dnbsumdata.stype;
                dnbsum.DandB__c= dnb.Id;
                obj.add(dnbsum);
            }
            
        }
        
        if(dnbRes.defaultColumns.size()>0){ 
            for(ints.DunAndBradstreetResponse.Column defaultc:dnbRes.defaultColumns){
                DandB_Column__c d = new DandB_Column__c();
                d.DandB__c=dnb.Id;
                d.name=defaultc.name+'defaultColumns';
                obj.add(d);
            }
            
        }
        
        if(dnbRes.enquiriesColumns.size()>0){ 
            for(ints.DunAndBradstreetResponse.Column defaultc:dnbRes.enquiriesColumns){
                DandB_Column__c d = new DandB_Column__c();
                d.DandB__c=dnb.Id;
                d.name=defaultc.name+'enquiriesColumns';
                obj.add(d);
            }
            
        }
        if(dnbRes.enquiries.size()>0){ 
            for(ints.DunAndBradstreetResponse.Enquiry enq:dnbRes.enquiries){
                DandB_Enquiry__c dnq = new DandB_Enquiry__c();
                dnq.accountTypeCode__c = enq.accountTypeCode;
                dnq.accountTypeDesc__c = enq.accountTypeDesc;
                dnq.amount__c = enq.amount;
                dnq.creditObligationCode__c = enq.creditObligationCode;
                dnq.creditObligationDesc__c = enq.creditObligationDesc;
                dnq.enqDay__c = enq.enqDay;
                dnq.enqHour__c = enq.enqHour;
                dnq.enqMinute__c = enq.enqMinute;
                dnq.enqMonth__c = enq.enqMonth;
                dnq.enqSecond__c = enq.enqSecond;
                dnq.enqYear__c = enq.enqYear;
                dnq.organisation__c = enq.organisation;
                dnq.purpose__c = enq.purpose;
                dnq.segId__c = enq.segId;
                dnq.sequence__c = enq.sequence;
                dnq.DandB__c=dnb.Id;
                dnq.uniqueCustomerReference__c = enq.uniqueCustomerReference;
                obj.add(dnq);
            }
            
        }
        if(dnbRes.defaults.size()>0){ 
            for(ints.DunAndBradstreetResponse.Defaults defaultc:dnbRes.defaults){   
                DandB_Defaults__c df = new DandB_Defaults__c();
                df.accountTypeCode__c=defaultc.accountTypeCode;
                df.accountTypeDesc__c=defaultc.accountTypeDesc;
                df.creditObligationCode__c=defaultc.creditObligationCode;
                df.creditObligationDesc__c=defaultc.creditObligationDesc;
                df.currentAmount__c=defaultc.currentAmount;
                df.currentCreditProvider__c=defaultc.currentCreditProvider;
                df.currentCustomerReference__c=defaultc.currentCustomerReference;
                df.currentReasonToReportCode__c=defaultc.currentReasonToReportCode;
                df.currentReasonToReportDesc__c=defaultc.currentReasonToReportDesc;
                df.ddefaultDay__c=defaultc.defaultDay;
                df.defaultMonth__c=defaultc.defaultMonth;
                df.defaultSegId__c=defaultc.defaultSegId;
                df.defaultYear__c=defaultc.defaultYear;
                df.lastPaymentDay__c=defaultc.lastPaymentDay;
                df.lastPaymentYear__c=defaultc.lastPaymentYear;
                df.lastPaymentMonth__c=defaultc.lastPaymentMonth;
                df.lastPaymentYear__c=defaultc.lastPaymentYear;
                df.originalAmount__c=defaultc.originalAmount;
                df.originalCustomerReference__c=defaultc.originalCustomerReference;
                df.originalReasonToReportCode__c=defaultc.originalReasonToReportCode;
                df.originalReasonToReportDesc__c=defaultc.originalReasonToReportDesc;
                df.purpose__c=defaultc.purpose;
                df.statusCode__c=defaultc.statusCode;
                df.statusDesc__c=defaultc.statusDesc;
                df.DandB__c=dnb.Id;
                obj.add(df);
                
            }
        }
        if(dnbRes.seriousCreditInfringements.size()>0){ 
            for(ints.DunAndBradstreetResponse.SeriousCreditInfringement src:dnbRes.seriousCreditInfringements){ 
                DandB_SeriousCreditInfringement__c des = new DandB_SeriousCreditInfringement__c();
                des.accountTypeCode__c = src.accountTypeCode;
                des.accountTypeDesc__c = src.accountTypeDesc;
                des.creditObligationCode__c = src.creditObligationCode;
                des.creditObligationDesc__c = src.creditObligationDesc;
                des.currentAmount__c = src.currentAmount;
                des.currentCreditProvider__c = src.currentCreditProvider;
                des.currentCustomerReference__c = src.currentCustomerReference;
                des.currentReasonToReportCode__c = src.currentReasonToReportCode;
                des.currentCreditProvider__c = src.currentCreditProvider;
                des.currentCustomerReference__c = src.currentCustomerReference;
                des.currentReasonToReportCode__c = src.currentReasonToReportCode;
                des.currentReasonToReportDesc__c = src.currentReasonToReportDesc;
                des.dateOfDefaultDay__c = src.dateOfDefaultDay; 
                des.dateOfDefaultMonth__c = src.dateOfDefaultMonth;
                des.dateOfDefaultYear__c = src.dateOfDefaultYear;
                des.lastPaymentDay__c = src.lastPaymentDay;
                des.lastPaymentMonth__c = src.lastPaymentMonth;
                des.lastPaymentYear__c = src.lastPaymentYear;
                des.originalAmount__c = src.originalAmount;
                des.originalCreditProvider__c = src.originalCreditProvider;
                des.originalCustomerReference__c = src.originalCustomerReference;
                des.originalReasonToReportCode__c = src.originalReasonToReportCode;
                des.originalReasonToReportDesc__c = src.originalReasonToReportDesc;
                des.purpose__c = src.purpose;
                des.segId__c = src.segId;
                des.sequence__c = src.sequence;
                des.statusCode__c = src.statusCode;
                des.statusDesc__c = src.statusDesc;
                des.DandB__c=dnb.Id;
                obj.add(des);
                
            }
        }
        if(dnbRes.fileNotes.size()>0){ 
            for(ints.DunAndBradstreetResponse.FileNote file:dnbRes.fileNotes){  
                DandB_FileNote__c dnbFileNotes = new DandB_FileNote__c();
                dnbFileNotes.day__c =file.day;
                dnbFileNotes.fnType__c  =file.fnType;
                dnbFileNotes.month__c   =file.month;
                dnbFileNotes.segId__c   =file.segId;
                dnbFileNotes.sequence__c    =file.sequence;
                dnbFileNotes.text__c    =file.text;
                dnbFileNotes.year__c    =file.year;
                dnbFileNotes.DandB__c = dnb.Id;
                obj.add(dnbFileNotes);   
            }
        }
        if(dnbRes.otherPublicRecords.size()>0){ 
            for(ints.DunAndBradstreetResponse.OtherPublicRecord othr:dnbRes.otherPublicRecords){
                DandB_OtherPublicRecord__c dnbOthr =  new DandB_OtherPublicRecord__c();
                dnbOthr.actionTypeCode__c = othr.actionTypeCode;
                dnbOthr.actionTypeDesc__c = othr.actionTypeDesc;
                dnbOthr.amount__c = othr.amount;
                dnbOthr.court__c = othr.court;
                dnbOthr.type__c='Other Public Records';
                dnbOthr.creditor__c = othr.creditor;
                dnbOthr.lodgedDay__c = othr.lodgedDay;
                dnbOthr.lodgedMonth__c = othr.lodgedMonth;
                dnbOthr.lodgedYear__c = othr.lodgedYear;
                
                dnbOthr.paidDay__c = othr.paidDay;
                dnbOthr.paidMonth__c = othr.paidMonth;
                dnbOthr.paidYear__c = othr.paidYear;
                dnbOthr.plaintiffName__c = othr.plaintiffName;
                dnbOthr.plaintiffNumber__c = othr.plaintiffNumber;
                dnbOthr.segId__c = othr.segId;
                dnbOthr.DandB__c = dnb.Id;
               obj.add(dnbOthr);
            }
        }
        if(dnbRes.summonses.size()>0){ 
            for(ints.DunAndBradstreetResponse.Summonses othr:dnbRes.summonses){
                DandB_OtherPublicRecord__c dnbOthr =  new DandB_OtherPublicRecord__c();
                dnbOthr.actionTypeCode__c = othr.actionTypeCode;
                dnbOthr.actionTypeDesc__c = othr.actionTypeDesc;
                dnbOthr.amount__c = othr.amount;
                dnbOthr.court__c = othr.court;
                dnbOthr.type__c='Summonses';
                dnbOthr.creditor__c = othr.creditor;
                dnbOthr.lodgedDay__c = othr.lodgedDay;
                dnbOthr.lodgedMonth__c = othr.lodgedMonth;
                dnbOthr.lodgedYear__c = othr.lodgedYear;
                dnbOthr.Name__c = 'OtherPublicRecord';
                dnbOthr.paidDay__c = othr.paidDay;
                dnbOthr.paidMonth__c = othr.paidMonth;
                dnbOthr.paidYear__c = othr.paidYear;
                dnbOthr.plaintiffName__c = othr.plaintiffName;
                dnbOthr.plaintiffNumber__c = othr.plaintiffNumber;
                dnbOthr.segId__c = othr.segId;
                dnbOthr.DandB__c = dnb.Id;
               obj.add(dnbOthr);
            }
        }
         if(dnbRes.judgments.size()>0){ 
            for(ints.DunAndBradstreetResponse.Judgments othr:dnbRes.judgments){
                DandB_OtherPublicRecord__c dnbOthr =  new DandB_OtherPublicRecord__c();
                dnbOthr.actionTypeCode__c = othr.actionTypeCode;
                dnbOthr.actionTypeDesc__c = othr.actionTypeDesc;
                dnbOthr.amount__c = othr.amount;
                dnbOthr.court__c = othr.court;
                dnbOthr.type__c='Judgments';
                dnbOthr.creditor__c = othr.creditor;
                dnbOthr.lodgedDay__c = othr.lodgedDay;
                dnbOthr.lodgedMonth__c = othr.lodgedMonth;
                dnbOthr.lodgedYear__c = othr.lodgedYear;
                dnbOthr.Name__c = 'OtherPublicRecord';
                dnbOthr.paidDay__c = othr.paidDay;
                dnbOthr.paidMonth__c = othr.paidMonth;
                dnbOthr.paidYear__c = othr.paidYear;
                dnbOthr.plaintiffName__c = othr.plaintiffName;
                dnbOthr.plaintiffNumber__c = othr.plaintiffNumber;
                dnbOthr.segId__c = othr.segId;
                dnbOthr.DandB__c = dnb.Id;
               obj.add(dnbOthr);
            }
        }
        if(dnbRes.bankruptcies.size()>0){ 
            for(ints.DunAndBradstreetResponse.Bankruptcy bnkr:dnbRes.bankruptcies){
                DandB_Bankruptcy__c dnbbankr = new DandB_Bankruptcy__c();
                dnbbankr.actionTypeCode__c = bnkr.actionTypeCode;
                dnbbankr.actionTypeDesc__c = bnkr.actionTypeDesc;
                dnbbankr.comments__c = bnkr.comments;
                dnbbankr.court__c = bnkr.court;
                dnbbankr.declaredDay__c = bnkr.declaredDay;
                dnbbankr.declaredMonth__c = bnkr.declaredMonth;
                dnbbankr.declaredYear__c = bnkr.declaredYear;
                dnbbankr.dischargeAnnulmentDay__c = bnkr.dischargeAnnulmentDay;
                dnbbankr.dischargeAnnulmentMonth__c = bnkr.dischargeAnnulmentMonth;
                dnbbankr.dischargeAnnulmentYear__c = bnkr.dischargeAnnulmentYear;
                dnbbankr.proceedingsDay__c = bnkr.proceedingsDay;
                dnbbankr.proceedingsNumber__c = bnkr.proceedingsNumber;
                dnbbankr.proceedingsYear__c = bnkr.proceedingsYear;
                dnbbankr.segId__c = bnkr.segId;
                dnbbankr.sequence__c = bnkr.sequence;
                dnbbankr.DandB__c = dnb.Id;
                obj.add(dnbbankr);
                
            }
        }
        if(dnbRes.directorships.size()>0){ 
            for(ints.DunAndBradstreetResponse.Directorship dirct:dnbRes.directorships){
                 DandB_Directorship__c dir = new  DandB_Directorship__c();
                 dir.companyName__c = dirct.companyName;
                 dir.companyNumber__c = dirct.companyNumber;
                 dir.companyStatus__c = dirct.companyStatus;
                 dir.dataSource__c = dirct.dataSource;
                 dir.dateAppointedDay__c = dirct.dateAppointedDay;
                 dir.dateAppointedMonth__c = dirct.dateAppointedMonth;
                 dir.dateAppointedYear__c = dirct.dateAppointedYear;
                 dir.dateCeasedDay__c = dirct.dateCeasedDay;
                 dir.dateCeasedYear__c = dirct.dateCeasedYear;
                dir.dateCeasedMonth__c = dirct.dateCeasedMonth;
                dir.detailsType__c = dirct.detailsType;
                dir.dunsNumber__c = dirct.dunsNumber;
                dir.extractDay__c = dirct.extractDay;
                dir.extractMonth__c = dirct.extractMonth;
                dir.extractDay__c = dirct.extractDay;
                dir.extractYear__c = dirct.extractYear;
                dir.segId__c = dirct.segId;
                dir.sequence__c = dirct.sequence;
                dir.DandB__c = dnb.Id;
                obj.add(dir);
                    
            }
        }
      
        if(dnbRes.warnings.size()>0){ 
            for(ints.DunAndBradstreetResponse.Warning dbwr:dnbRes.warnings){
                DandB_Warning__c dbw = new DandB_Warning__c();
                dbw.code__c = dbwr.code;
                dbw.type__c = 'Warning';
                dbw.description__c = dbwr.description;
                dbw.elementName__c = dbwr.elementName;
                dbw.segId__c = dbwr.segId;
                dbw.sequence__c = dbwr.sequence;
                dbw.value__c = dbwr.value;
                dbw.xPath__c = dbwr.xPath;
                dbw.DandB__c=dnb.Id;
                obj.add(dbw);
            }
        }
         if(dnbRes.errors.size()>0){ 
            for(ints.DunAndBradstreetResponse.Error dbwr:dnbRes.errors){
                DandB_Warning__c dbw = new DandB_Warning__c();
                dbw.code__c = dbwr.code;
                dbw.type__c='Error';
                dbw.description__c = dbwr.description;
                dbw.elementName__c = dbwr.elementName;
                dbw.segId__c = dbwr.segId;
                dbw.sequence__c = dbwr.sequence;
                dbw.xPath__c = dbwr.xPath;
                dbw.DandB__c=dnb.Id;
                obj.add(dbw);
            }
        }
        if(dnbRes.possibleMchAddress.size()>0){ 
            for(ints.DunAndBradstreetResponse.PossibleMatchAddress dbpossb:dnbRes.possibleMchAddress){
                DandB_PossibleMatchAddress__c dandbpos = new  DandB_PossibleMatchAddress__c();
                dandbpos.possibleMchBuildingName__c=dbpossb.possibleMchBuildingName;
                dandbpos.possibleMchBuildingName2__c=dbpossb.possibleMchBuildingName2;
                dandbpos.possibleMchCity__c=dbpossb.possibleMchCity;
                dandbpos.possibleMchIsCurrent__c=dbpossb.possibleMchIsCurrent;
                dandbpos.possibleMchIsMailing__c=dbpossb.possibleMchIsMailing;
                dandbpos.possibleMchIsPriorAddress__c=dbpossb.possibleMchIsPriorAddress;
                dandbpos.possibleMchPostcode__c=dbpossb.possibleMchPostcode;
                dandbpos.possibleMchRecordedDay__c=dbpossb.possibleMchRecordedDay;
                dandbpos.possibleMchRecordedYear__c=dbpossb.possibleMchRecordedYear;
                dandbpos.possibleMchState__c=dbpossb.possibleMchState;
                dandbpos.possibleMchStreet__c=dbpossb.possibleMchStreet;
                dandbpos.possibleMchStreetNo__c=dbpossb.possibleMchStreetNo;
                dandbpos.possibleMchStreetType__c=dbpossb.possibleMchStreetType;
                dandbpos.possibleMchUnitNo__c=dbpossb.possibleMchUnitNo;
                dandbpos.DandB__c=dnb.Id;
                obj.add(dandbpos);
            }
        }
        if(dnbRes.aaes.size()>0){ 
            for(ints.DunAndBradstreetResponse.Aae ae:dnbRes.aaes){
                DandB_Aae__c dnbAe = new DandB_Aae__c();
                dnbAe.accountTypeCode__c = ae.accountTypeCode;
                dnbAe.accountTypeDesc__c = ae.accountTypeDesc;
                dnbAe.amount__c = ae.amount;
                dnbAe.applicationDay__c = ae.applicationDay;
                dnbAe.applicationHour__c = ae.applicationHour;
                dnbAe.applicationMinute__c = ae.applicationMinute;
                dnbAe.applicationMonth__c = ae.applicationMonth;
                dnbAe.applicationSecond__c = ae.applicationSecond;
                dnbAe.applicationYear__c = ae.applicationYear;
                dnbAe.creditObligationCode__c = ae.creditObligationCode;
                dnbAe.creditObligationDesc__c = ae.creditObligationDesc;
                dnbAe.day__c = ae.day;
                dnbAe.hour__c = ae.hour;
                dnbAe.minute__c = ae.minute;
                dnbAe.month__c = ae.month;
                dnbAe.organisation__c = ae.organisation;
                dnbAe.purpose__c = ae.purpose;
                dnbAe.second__c = ae.second;
                dnbAe.segId__c = ae.segId;
                dnbAe.sequence__c = ae.sequence;
                dnbAe.uniqueCustomerReference__c = ae.uniqueCustomerReference;
                dnbAe.year__c = ae.year;
                dnbAe.DandB__c = dnb.Id;
                obj.add(dnbAe);
               
            }
        }
     //obj.sort();
     //insert obj;
     insertInBatch(obj,10);   
    }
    static void insertInBatch(List<sObject> batchList,Integer totallimit){
        if(batchList.size()>0){
          Integer start=0;
          Integer endlist = totallimit-1;
          System.debug('size='+batchList.size());
          List<Sobject> safeListForChunking = new List<Sobject>();
         
          for(start=0;start<endlist && start<batchList.size();start++){
           //   safeListForChunking.add();
              System.debug('sizeof='+batchList.size());
              System.debug('='+ start);
              
              if(batchList.get(start)!=null){
                 System.debug('batchList.get(start)'+batchList.get(start));
                 safeListForChunking.add(batchList.get(start)); 
              }
             
          }
          
           Integer count=0;
           for(start=0;start<endlist && start<safeListForChunking.size();start++){
           System.debug('remove='+batchList.remove(count));
             
          }
          
          insert safeListForChunking;
          safeListForChunking.clear();
          insertInBatch(batchList,totallimit);
      }
   }
}
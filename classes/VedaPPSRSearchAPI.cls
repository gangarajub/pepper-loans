global class VedaPPSRSearchAPI{
     global String collId;
    list<VPPSR_Change_History__c> chgMap = new List<VPPSR_Change_History__c>();
            list<VPPSR_Address_For_Service__c> addMap= new list<VPPSR_Address_For_Service__c>();
            list<VPPSR_Mailing_Address__c> mailMap=new List<VPPSR_Mailing_Address__c>();
            List<VPPSR_Result_Detail__c> resObj = new List<VPPSR_Result_Detail__c>();
            list<VPPSR_Registration_Detail__c> regList=new list<VPPSR_Registration_Detail__c>();
            list<VPPSR_Grantor__c> gr1 = new list<VPPSR_Grantor__c>();
            list<VPPSR_Grantor__c> gr2=new list<VPPSR_Grantor__c>();
            list<VPPSR_Individual__c> ind1= new list<VPPSR_Individual__c>();
            list<VPPSR_Individual__c> ind2= new list<VPPSR_Individual__c>();
            list<VPPSR_Organisation__c> orgList=new list<VPPSR_Organisation__c>();
            list<VPPSR_Organisation__c> orgList1=new list<VPPSR_Organisation__c>();
            list<VPPSR_Secured_Party__c> secList=new List<VPPSR_Secured_Party__c>();
            list<VPPSR_Serial_Number_Detail__c> snuList=new list<VPPSR_Serial_Number_Detail__c>();
            list<VPPSR_Result_Detail__c> resList=new List<VPPSR_Result_Detail__c>();
            list<VPPSR_Search_Result__c> serList=new list<VPPSR_Search_Result__c>();
   
    ints.IntegrationRequestObject requestObj =new ints.IntegrationRequestObject();
    	ints.VedaPPSRSearchIntegration vPsearch = new ints.VedaPPSRSearchIntegration();
    ints.VedaPPSRSearchRes response= new ints.VedaPPSRSearchRes();
    VPPSR_Serial_Number_Search_Response__c vPSRes = new VPPSR_Serial_Number_Search_Response__c();

    global VedaPPSRSearchAPI(String collId){
        ints__VedaPPSRSetting__c setting = ints__VedaPPSRSetting__c.getInstance();
        if(setting == null || (setting.ints__username__c== null || setting.ints__password__c==null || setting.ints__endpoint__c==null)){
            throw new ints.IntegrationException('Veda PPSR setting has not been set.');
        }
        this.collId = collId;
        requestObj.requestMap.put('data:CustomersRequestMessageId', collId);
        requestObj.requestMap.put('veda:searchCertificateRequired', 'true');
        requestObj.requestMap.put('data:SerialNumberType', 'VIN');
        requestObj.requestMap.put('veda:continueUponVINValidationFailureOrServiceNotAvailable', 'true');
        requestObj.requestMap.put('data:IncludeArchived', 'false');
        requestObj.requestMap.put('data:IncludeCurrent', 'true');
        requestObj.requestMap.put('data:IncludeExpired', 'false');
        requestObj.requestMap.put('data:IncludeRemoved', 'false');
        String vinNumb= [select clcommon__Vehicle_ID_Number__c from clcommon__Collateral__c where id=:collId][0].clcommon__Vehicle_ID_Number__c;
        requestObj.requestMap.put('data:SerialNumber', vinNumb); 
		System.debug('AAAAAAAAA: requestObj: ' + requestObj  );       
    }   
    global VPPSR_Serial_Number_Search_Response__c getSearchRes(){    
   
        if(!Test.isRunningTest()){
            response=(ints.VedaPPSRSearchRes) vPsearch.integrate(requestObj);     
            System.debug('AAAAAAAAA: response: ' + response);
        }
        else{        
            response= new ints.VedaPPSRSearchRes();
            String abc='200';
            response.rawRequest=abc;
            response.integrationErrorStatus=abc;
            response.integrationErrorStatusCode=abc;
            response.rawResponse=abc;
            response.message=abc;
            ints.VedaPPSRSearchRes.SerialNumberSearchResponse snsr= new ints.VedaPPSRSearchRes.SerialNumberSearchResponse();
            snsr.searchCertificateNumber=abc;
            ints.VedaPPSRSearchRes.SearchBySerialNumberResponseType ssnr= new ints.VedaPPSRSearchRes.SearchBySerialNumberResponseType();
            ssnr.customersRequestMessageId=abc;
            ssnr.requestProcessedDateTime=abc;
            ints.VedaPPSRSearchRes.SearchCriteria sc = new ints.VedaPPSRSearchRes.SearchCriteria();
            sc.includeArchived=abc;
            sc.includeCurrent=abc;
            sc.includeExpired=abc;
            sc.includeRemoved=abc;
            sc.pointInTimeDateTime=abc;
            sc.serialNumber=abc;
            sc.serialNumberType=abc;
            ssnr.searchCriteria.add(sc);
            ints.VedaPPSRSearchRes.SearchResult sr= new ints.VedaPPSRSearchRes.SearchResult();
            ints.VedaPPSRSearchRes.NevdisData nd = new ints.VedaPPSRSearchRes.NevdisData();
            ints.VedaPPSRSearchRes.VehicleDetail vd= new ints.VedaPPSRSearchRes.VehicleDetail();
            vd.jurisdiction =abc;
            vd.jurisdictionParticipation=abc;
            ints.VedaPPSRSearchRes.Registration reg1 = new ints.VedaPPSRSearchRes.Registration();
            reg1.expiryDate=abc;
            reg1.plateNumber=abc;
            vd.reg.add(reg1);
            ints.VedaPPSRSearchRes.VehicleDescription vdd= new ints.VedaPPSRSearchRes.VehicleDescription();
            vdd.bodyType=abc;
            vdd.colour=abc;
            vdd.complianceYearMonth=abc;
            vdd.engineNumber=abc;
            vdd.make=abc;
            vdd.manufactureYear=abc;
            vdd.model=abc;
            vdd.vehicleType=abc;
            vd.vDesp.add(vdd);
            nd.vehicleDetail.add(vd);
            ints.VedaPPSRSearchRes.VehicleIdentifier vi = new ints.VedaPPSRSearchRes.VehicleIdentifier();
            vi.identifierType=abc;
            vi.identifierValue=abc;
            nd.vehicleIdentifier.add(vi);
            nd.stolenDet=abc;
            nd.verificationStatus=abc;
            sr.nevdisData.add(nd);
            ints.VedaPPSRSearchRes.ResultDetail rd = new ints.VedaPPSRSearchRes.ResultDetail();
            ints.VedaPPSRSearchRes.ChangeHistory ch= new ints.VedaPPSRSearchRes.ChangeHistory();
            CH.changeNumber=abc;
            ch.changeType=abc;
            ch.registrationChangeTime=abc;
            rd.changeHist.add(ch);
            ints.VedaPPSRSearchRes.RegistrationDetail rdd= new ints.VedaPPSRSearchRes.RegistrationDetail();
            ints.VedaPPSRSearchRes.AddressForService ads=new ints.VedaPPSRSearchRes.AddressForService();
            ads.addressee=abc;
            ads.emailAddress=abc;
            ads.faxNumber=abc;
            ads.physicalAddress=abc;
            ints.VedaPPSRSearchRes.MailingAddress ma= new ints.VedaPPSRSearchRes.MailingAddress();
            ma.countryName=abc;
            ma.iSO3166CountryCode=abc;
            ma.line1=abc;
            ma.state=abc;
            ads.mailingAddress.add(ma);
            rdd.addressForService.add(ads);
            ints.VedaPPSRSearchRes.Grantors gr = new ints.VedaPPSRSearchRes.Grantors();
            gr.grantorType=abc;
            ints.VedaPPSRSearchRes.Individual ind= new ints.VedaPPSRSearchRes.Individual();
            ind.familyName=abc;
            gr.indv.add(ind);
            ints.VedaPPSRSearchRes.Organisation org=new ints.VedaPPSRSearchRes.Organisation();
            org.organisationName=abc;
            gr.organisation.add(org);
            rdd.grantors.add(gr);
            ints.VedaPPSRSearchRes.SecuredParties sp= new ints.VedaPPSRSearchRes.SecuredParties();
            sp.indv.add(ind);
            sp.organisation.add(org);
            sp.securedPartyType=abc;
            rdd.securedParties.add(sp);
            ints.VedaPPSRSearchRes.SerialNumberDetails snd = new ints.VedaPPSRSearchRes.SerialNumberDetails();
            snd.serialNumber=abc;
            rdd.serialNumberDetails.add(snd);
            rd.registrationDetail.add(rdd);
            rd.restrictionDetail=abc;
            rd.resultSequenceNumber=abc;
            sr.resultDetail.add(rd);
            sr.searchResultRetrievedDateTime=abc;
            sr.transitionalPeriodMessage=abc;
            ssnr.searchResult.add(sr);
            ints.VedaPPSRSearchRes.SearchSummary ss= new ints.VedaPPSRSearchRes.SearchSummary();
            ss.accessToSearchResultExpiryTime=abc;
            ss.resultCount=abc;
            ss.searchExecutedDateTime=abc;
            ss.searchNumber=abc;
            ss.searchType=abc;
            ssnr.searchSummary.add(ss);
            snsr.searchBySerialNumberResponseType.add(ssnr);
            ints.VedaPPSRSearchRes.RetrieveSearchCertificateResponseType rrr=new ints.VedaPPSRSearchRes.RetrieveSearchCertificateResponseType();
            rrr.customersRequestMessageId=abc;
            rrr.requestProcessedDateTime=abc;
            rrr.accessToSearchCertificateExpiryTime=abc;
            rrr.searchCertificateFile=abc;
            rrr.searchCertificateNumber=abc;
            rrr.searchCertificateFileName=abc;
            snsr.retSrcCertResType.add(rrr);
           	response.serialNumSearchResp.add(snsr);            
        }    
        if(response.integrationErrorStatusCode=='200'){           
            vPSRes.Collateral__c=collId;
            vPSRes.search_Certificate_Number__c=response.serialNumSearchResp[0].searchCertificateNumber;
            vPSRes.integrationErrorStatus__c=response.integrationErrorStatus;
            vPSRes.integrationErrorStatusCode__c=response.integrationErrorStatusCode;
            vPSRes.message__c=null;
            
            return vPSRes;     
            //upsert vPSRes;
        }
        else{
            vPSRes.integrationErrorStatus__c=response.integrationErrorStatus;
            vPSRes.integrationErrorStatusCode__c=response.integrationErrorStatusCode;
            vPSRes.search_Certificate_Number__c=null;
            vPSRes.Collateral__c=collId;
            Dom.Document doc = new Dom.Document();
            doc.load(response.message);
            Dom.XMLNode root = doc.getRootElement();
            for (Dom.XmlNode element : root.getChildElements()){
                if (element.getName().equalsIgnoreCase('Body')){
                    for(Dom.XMLNode subChild : element.getChildElements()){
                        if(subChild.getName().equalsIgnoreCase('Fault')){
                            for(Dom.XMLNode subChildf : subChild.getChildElements()){
                                if (subChildf.getName().equalsIgnoreCase('Detail')) {
                                    for(Dom.XMLNode subChildd : subChildf.getChildElements()){
                                        if(subChildd.getName().equalsIgnoreCase('VedaValidationFaultDetail')){
                                            for(Dom.XMLNode subChildmsg : subChildd.getChildElements()){
                                                if(subChildmsg.getName().equalsIgnoreCase('message')){
                                                    vPSRes.message__c=subChildmsg.getText();
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            upsert vPSRes;
            vPSRes =[Select id,Collateral__c,message__c,search_Certificate_Number__c,integrationErrorStatusCode__c,integrationErrorStatus__c from VPPSR_Serial_Number_Search_Response__c where id=:vPSRes.id];
            system.debug('<-------OUTPUT QUERY---------------->'+vPSRes);
          
            return vPSRes;
        }
    }
    
            global VPPSR_Retrieve_Search_Cert_Resp_Type__c getResponseTyp(){
            VPPSR_Retrieve_Search_Cert_Resp_Type__c retResTyp= new VPPSR_Retrieve_Search_Cert_Resp_Type__c();
            retResTyp.customer_Req_Message_Id__c =response.serialNumSearchResp[0].retSrcCertResType[0].customersRequestMessageId;
            retResTyp.access_Search_Cert_Expiry_Time__c= response.serialNumSearchResp[0].retSrcCertResType[0].accessToSearchCertificateExpiryTime;
            retResTyp.attachments__c=response.serialNumSearchResp[0].retSrcCertResType[0].attachments;
            retResTyp.search_Certi_Created_Date_Time__c=response.serialNumSearchResp[0].retSrcCertResType[0].searchCertificateCreatedDateTime;
            retResTyp.search_Certificate_File_Name__c=response.serialNumSearchResp[0].retSrcCertResType[0].searchCertificateFileName;
            retResTyp.search_Certificate_Number__c=response.serialNumSearchResp[0].retSrcCertResType[0].searchCertificateNumber;
            retResTyp.request_Processed_Date_Time__c=response.serialNumSearchResp[0].retSrcCertResType[0].requestProcessedDateTime;
            //retResTyp.Veda_PPSR_SerialNumber_Search_Response__c= vPSRes.id;
            return retResTyp;
            }
    
    global List<Attachment> getAttachments(){
        list<Attachment> attachList= new List<Attachment>();
             /*attachment for PDF File*/
            Attachment attachFile = new Attachment();
            Blob bl = Blob.valueOf((response.serialNumSearchResp[0].retSrcCertResType[0].searchCertificateFile)); 
            attachFile.Body = (EncodingUtil.base64Decode(bl.toString()));             
            attachFile.name =  'Veda PPSR search Certificate file -' + datetime.now() + '.pdf';            
            attachFile.parentId = collId;
            attachFile.contentType = 'application/pdf';
            attachList.add(attachFile);       
        /*attachment for response*/
            Attachment attachRes = new Attachment();
            attachRes.Body = Blob.valueOf((String)response.rawResponse);
            attachRes.name =  'Veda PPSR Search response body - ' + datetime.now() + '.xml';
            attachRes.parentId = vPSRes.id;
            attachRes.contentType = 'text/xml';
        attachList.add(attachRes);
      //      insert attachRes;
            /*attachment for request*/
            Attachment attachReq = new Attachment();
            attachReq.Body = Blob.valueOf((String)response.rawRequest);
            attachReq.name =  'Veda PPSR Search request body - ' + datetime.now() + '.xml';
            attachReq.parentId = vPSRes.id;
            attachReq.contentType = 'text/xml';
        attachList.add(attachReq);
        return attachList;
        
    }
    global VPPSR_Search_By_Serial_Num_Resp_Type__c getresTyp(){
   //         insert attachReq;
            /*searchBySerialNumberResponseType*/
            VPPSR_Search_By_Serial_Num_Resp_Type__c searchSerialType= new VPPSR_Search_By_Serial_Num_Resp_Type__c();
            searchSerialType.customers_Request_Message_Id__c = response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].customersRequestMessageId;
            searchSerialType.request_Processed_Date_Time__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].requestProcessedDateTime;
        //    searchSerialType.Veda_PPSR_SerialNumber_Search_Response__c=vPSRes.id;
        
            return searchSerialType;
    }
    global VPPSR_Search_Criteria__c getSrcCr(){
            /* Search Criteria*/
            VPPSR_Search_Criteria__c sc = new VPPSR_Search_Criteria__c();
            sc.include_Archived__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchCriteria[0].includeArchived;
            sc.include_Current__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchCriteria[0].includeCurrent;
            sc.include_Expired__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchCriteria[0].includeExpired;
            sc.include_Removed__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchCriteria[0].includeRemoved;
            sc.point_In_Time_Date_Time__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchCriteria[0].pointInTimeDateTime;
            sc.serial_Number__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchCriteria[0].serialNumber;
            sc.serial_Number_Type__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchCriteria[0].serialNumberType;
            //sc.Search_By_Serial_Num_Resp_Type__c=searchSerialType.id;
            return sc;
    }
  
            /*searchResult */
    /*        VPPSR_Search_Result__c searchRes = new VPPSR_Search_Result__c();
            upsert searchRes;
            /*nevdisData
            VPPSR_NevdisData__c colData = new VPPSR_NevdisData__c();
            upsert colData;
            /*vehicleDetail*/
    global VPPSR_Vehicle_Detail__c getColSet(){
            VPPSR_Vehicle_Detail__c colDetail = new VPPSR_Vehicle_Detail__c();
            //upsert colDetail;
        TRY{
            colDetail.jurisdiction__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].jurisdiction;
            colDetail.jurisdiction_Participation__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].jurisdictionParticipation;
            return colDetail;}
        catch(Exception ex){
            system.debug(ex.getMessage());
            return null;
        }
    }
    global Registration__c getReg(){
            /*Registraion*/
            Registration__c regist= new Registration__c();
            regist.registration_Expiry_Date__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].reg[0].expiryDate;
            regist.registration_Plate__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].reg[0].plateNumber;
           // regist.Collateral_Detail__c=colDetail.id;
            return regist;
    }
    global VPPSR_Vehicle_Description__c getVehDisc(){
            /*VehicleDescription*/
            VPPSR_Vehicle_Description__c vehDescp= new VPPSR_Vehicle_Description__c();
            vehDescp.body_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].bodyType;
            vehDescp.colour__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].colour;
            vehDescp.make__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].make;
            vehDescp.manufacture_Year__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].manufactureYear;
            vehDescp.model__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].model;
            vehDescp.vehicle_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].vehicleType;
            vehDescp.compliance_Year_Month__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].complianceYearMonth;
            vehDescp.engine_Number__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleDetail[0].vDesp[0].engineNumber;            
            //vehDescp.Collateral_Detail__c =colDetail.Id;
            return vehDescp;            
    }
         //   colDetail.NevdisData__c=colData.id;
         //   upsert colDetail;          
    global VPPSR_Vehicle_Identifier__c getVehIden(){
            /*vehicleIdentifier*/
            VPPSR_Vehicle_Identifier__c vehIden= new VPPSR_Vehicle_Identifier__c();
            vehIden.identifier_Type__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleIdentifier[0].identifierType;
            vehIden.identifier_Value__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].vehicleIdentifier[0].identifierValue;
            //vehIden.NevdisData__c=colData.id;
            return vehIden;
    }
    global VPPSR_NevdisData__c getColData(){
        VPPSR_NevdisData__c colData = new VPPSR_NevdisData__c();
            colData.stolen_detail__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].stolenDet;
            colData.verification_Status__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].nevdisData[0].verificationStatus;
            //colData.Search_Result__c=searchRes.id;
            return colData;
    }
            
    global List<VPPSR_Result_Detail__c> getResDet(){
            Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){           
                
                /*ResultDetail*/
              
                VPPSR_Result_Detail__c	 resultDet= new VPPSR_Result_Detail__c	();
                resultDet.restriction_Detail__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].restrictionDetail;
                resultDet.result_Sequence_Number__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].resultSequenceNumber;
              //  resultDet.Search_Result__c=searchRes.id;
                resList.add(resultDet);
              i--;
            }
          return resList;
    }
        global List<VPPSR_Change_History__c> getChgHist(){
            Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){ 
                /*change hist*/
                VPPSR_Change_History__c chgHist= new VPPSR_Change_History__c();
                chgHist.change_Number__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].changeHist[0].changeNumber;
                chgHist.change_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].changeHist[0].changeType;
                chgHist.registration_Change_Time__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].changeHist[0].registrationChangeTime;
                //chgHist.Result_Detail__c=resultDet.id;
                chgMap.add(chgHist);              
                i--;
            }
            return chgMap;
            
        }
    global List<VPPSR_Registration_Detail__c> getRegDet(){
          
        Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){  
                VPPSR_Registration_Detail__c regDet= new VPPSR_Registration_Detail__c();
                /*RegistrationDetail*/                
              
                regDet.areAssetsSubjectToControl__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].areAssetsSubjectToControl;
                regDet.areProceedsClaimed__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].areProceedsClaimed;
                regDet.changeNumber__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].changeNumber;
                regDet.collateralClassDescription__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].collateralClassDescription;
                regDet.collateralClassType__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].collateralClassType;
                regDet.collateralDescription__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].collateralDescription;
                regDet.collateralType__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].collateralType;
                regDet.earlierRegistrationNumber__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].earlierRegistrationNumber;
                regDet.givingOfNoticeIdentifier__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].givingOfNoticeIdentifier;
               
                regDet.isInventory__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].isInventory;
                regDet.isMigrated__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].isMigrated;
                regDet.isPMSI__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].isPMSI;
                regDet.isSecurityInterestRegistrationKind__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].isSecurityInterestRegistrationKind;
                regDet.isSubordinate__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].isSubordinate;
                regDet.isTransitional__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].isTransitional;
                regDet.migrationDetail__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].migrationDetail;
                regDet.proceedsClaimedDescription__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].proceedsClaimedDescription;
                regDet.registrationChangeTime__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].registrationChangeTime;
                regDet.registrationEndTime__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].registrationEndTime;
                regDet.registrationKind__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].registrationKind;
                regDet.registrationNumber__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].registrationNumber;
                regDet.registrationStartTime__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].registrationStartTime;
                regDet.attachments__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].attachments;
                //regDet.Result_Detail__c=resultDet.id;
                regList.add(regDet);
               
                
               i--;
            }
         return regList;
    }
    global List<VPPSR_Address_For_Service__c> getAddSer(){
                /*AddressForService*/
        Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){                 
        
                VPPSR_Address_For_Service__c addSer= new VPPSR_Address_For_Service__c();
                addSer.email_Address__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].emailAddress;
                addSer.fax_Number__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].faxNumber;
                addSer.physical_Address__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].physicalAddress;
                addSer.addressee__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].addressee;
                //addSer.Registration_Detail__c=regDet.id;
               addMap.add(addSer);
                i--;
            }
        return addMap;
    }
    global List<VPPSR_Mailing_Address__c> getMailAdd(){
                /*MailingAddress*/
        Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){                 
        
                VPPSR_Mailing_Address__c mailAdd= new VPPSR_Mailing_Address__c();
                mailAdd.country_Name__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].countryName;
                mailAdd.ISO_Country_Code__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].iSO3166CountryCode;
                mailAdd.line1__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].line1;
                mailAdd.line2__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].line2;
                mailAdd.line3__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].line3;
                mailAdd.locality__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].locality;
                mailAdd.post_Code__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].postcode;
                mailAdd.state__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].addressForService[0].mailingAddress[0].state;
                //mailAdd.Address_For_Service__c=addSer.id;
                mailMap.add(mailAdd);
                i--;
            }
        return mailMap;
    }
    global List<VPPSR_Grantor__c> getGrant(){
        Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){                 
        
                /*Grantor*/
                VPPSR_Grantor__c gr= new VPPSR_Grantor__c();
                gr.grantor_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].grantorType;
                //gr.Registration_Detail__c=regDet.id;
                gr1.add(gr);                
                i--;
            }
        return gr1;
    }
    global List<VPPSR_Individual__c> getInd(){
                /*Individual*/
         Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){   
                VPPSR_Individual__c ind = new VPPSR_Individual__c();
                if((response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].indv).size()!=0){
                    ind.family_Name__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].indv[0].familyName;
                    ind.given_Name__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].indv[0].givenName;
                  //  ind.VPPSR_Grantor__c= gr.id;
                    ind2.add(ind);     
                    
                }
                i--;
            }
        return ind2;
    }
    global List<VPPSR_Organisation__c> getOrg(){
         Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){   
                /*Organisation*/
                VPPSR_Organisation__c org= new VPPSR_Organisation__c();
                if((response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].organisation).size()!=0){
                    org.organisation_Name__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].organisation[0].organisationName;
                    org.organisation_Number__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].organisation[0].organisationNumber;
                    org.organisation_Number_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].grantors[0].organisation[0].organisationNumberType;
                    //org.VPPSR_Grantor__c=gr.id;
                    orgList.add(org);
                }
                i--;
            }
        return orgList;
    }
                //insert regDet;
                /*SecuredParties*/
                //VPPSR_Secured_Party__c secParty= new VPPSR_Secured_Party__c();
               // insert secParty;
    global List<VPPSR_Individual__c> getInd1(){
    /*Individual*/
         Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){   
                VPPSR_Individual__c indd = new VPPSR_Individual__c();
                indd.family_Name__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].securedParties[0].indv[0].familyName;
                indd.given_Name__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].securedParties[0].indv[0].givenName;
                //indd.VPPSR_Secured_Party__c=secParty.Id;
                ind1.add(indd);                
                i--;
            }
        return ind1;
    }
    global List<VPPSR_Organisation__c> getOrg1(){
         Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){   
                /*organisation*/
                VPPSR_Organisation__c orgg= new VPPSR_Organisation__c();
                orgg.organisation_Name__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].securedParties[0].organisation[0].organisationName;
                orgg.organisation_Number__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].securedParties[0].organisation[0].organisationNumber;
                orgg.organisation_Number_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].securedParties[0].organisation[0].organisationNumberType;
                //orgg.VPPSR_Secured_Party__c=secParty.id;
                orgList1.add(orgg);
                i--;
            }
        return orgList1;
    }
    global List<VPPSR_Secured_Party__c> getSecParty(){
         Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){   
    	VPPSR_Secured_Party__c secParty= new VPPSR_Secured_Party__c();
               // insert secParty;
    
                //secParty.Registration_Detail__c=regDet.id;
                secParty.secured_Party_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].securedParties[0].securedPartyType;
                secList.add(secParty);
                i--;
            }
        return secList;
    }
    global List<VPPSR_Serial_Number_Detail__c> getSrNbDt(){
         Integer i = (response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail).size();
            while(i>0){   
                /*SerialNumberDetails*/
                VPPSR_Serial_Number_Detail__c serNumDet= new VPPSR_Serial_Number_Detail__c();
                serNumDet.additional_Aircraft_Details__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].serialNumberDetails[0].additionalAircraftDetails;
                serNumDet.additional_Vehicle_Details__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].serialNumberDetails[0].additionalVehicleDetails;
                serNumDet.serial_Number__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].serialNumberDetails[0].serialNumber;
                serNumDet.serial_Number_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].resultDetail[i-1].registrationDetail[0].serialNumberDetails[0].serialNumberType;
                //serNumDet.Registration_Detail__c=regDet.id;
                snulist.add(serNumDet);
                i--;
            }
         
        return snuList;
    }
                

    global  VPPSR_Search_Result__c getsrchRes(){
        VPPSR_Search_Result__c searchRes = new VPPSR_Search_Result__c();
            //upsert regList
            searchRes.searchResultRetrievedDateTime__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].searchResultRetrievedDateTime;
            searchRes.transitionalPeriodMessage__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchResult[0].transitionalPeriodMessage;
            return searchRes;            
    }
    global VPPSR_Search_Summary__c getSrcSum(){
            /*SearchSummary*/
            VPPSR_Search_Summary__c searchSum= new VPPSR_Search_Summary__c();
            searchSum.access_Search_Result_Expiry_Time__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchSummary[0].accessToSearchResultExpiryTime;
            searchSum.result_Count__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchSummary[0].resultCount;
            searchSum.search_Executed_Date_Time__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchSummary[0].searchExecutedDateTime;
            searchSum.search_Number__c= response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchSummary[0].searchNumber;
            searchSum.search_Type__c=response.serialNumSearchResp[0].searchBySerialNumberResponseType[0].searchSummary[0].searchType;
            //searchSum.Search_By_Serial_Num_Resp_Type__c=searchSerialType.id;
            return searchSum;
    }
                      
        }
@RestResource(urlMapping='/col/letter/updateURL')
global with sharing class ScCollection_UpdateLetterURL{
    
     global class indexes{
        public String CreationTime{get;set;}
        public String RecipientIdentifier{get;set;}
        public String AccountIdentifier{get;set;}
        public String RecipientName{get;set;}
        public String LetterDate{get;set;}
        public String RecipientAddress{get;set;}
        public String CreationDate{get;set;}
        public String DPID{get;set;}
        public String LetterFormIdentifier{get;set;}
        public String OutputMethod{get;set;}
        public String Category{get;set;}
        public String OutputLocation{get;set;}
        public String Application{get;set;}
        public String AggregatorShortName{get;set;}
        public String Region{get;set;}
        public String Format{get;set;}
        public String CountryCode{get;set;}
        public String DocumentType{get;set;}
        public String FileDate{get;set;}
        public String DocumentTypeIdentifier{get;set;}
        public Integer ItemID{get;set;}
        public String BarcodeLinkage{get;set;}
        public String APPID{get;set;}
        public String Status{get;set;}
        public String BCUID{get;set;}
        public String ErrorHandler{get;set;}
        public String Filedby{get;set;}
        public String LeadID{get;set;}
    }
    global class ids{
        public String value{get;set;}
        public String description{get;set;}
        public String type{get;set;}
    }
    global class document{
        public String path{get;set;}
        public String description{get;set;}
        public String linktype{get;set;}
        public Integer name{get;set;}
        public indexes indexes{get;set;}
        public String type{get;set;}
    }
    
    
    @HttpPatch
    global static ScCollection_ApiResponse UpdateURL() {
        
        ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();    
        ScCollection_ApiResponse.APIStatus objApiStatus = new ScCollection_ApiResponse.APIStatus(); 
        List<ScCollection_ApiResponse.Messages> lstMessages = new List<ScCollection_ApiResponse.Messages>();
        
        String jsonString = RestContext.request.requestBody.toString();
        
        
        ScCollection_UpdateLetterParse wrapper = new ScCollection_UpdateLetterParse();
        
        jsonString = jsonString.replace('Letter/Form Identifier','LetterFormIdentifier');
        jsonString = jsonString.replace('Account Identifier','AccountIdentifier');
        jsonString = jsonString.replace('Recipient Identifier','RecipientIdentifier');
        jsonString = jsonString.replace('Recipient Name','RecipientName');
        jsonString = jsonString.replace('Recipient Address','RecipientAddress');
        
        jsonString = jsonString.replace('Output Method','OutputMethod');
        jsonString = jsonString.replace('Output Location','OutputLocation');
        jsonString = jsonString.replace('Aggregator Short Name','AggregatorShortName');
        jsonString = jsonString.replace('BCU ID','BCUID');
        jsonString = jsonString.replace('Error Handler','ErrorHandler');
        jsonString = jsonString.replace('Lead ID','LeadID');
        jsonString = jsonString.replace('Filed by','Filedby');
        jsonString = jsonString.replace('File Date','FileDate');
        
        wrapper = wrapper.parse(jsonString );
        
        //For Jackson Variable------
        String varLetterFormIdentifier = '';
        String varAddress = '';
        String businessType = '';
        
        
        String loanNo = '';
        String uniqueId = '';
        String letterUrl = '';
        Boolean temp_check =false;
        date varLetterDate;
        List<ScCollection_UpdateLetterParse.ids> ids = new List<ScCollection_UpdateLetterParse.ids>();
        ScCollection_UpdateLetterParse.indexes objIndexes = new ScCollection_UpdateLetterParse.indexes();
        if(wrapper != null){
            ids = wrapper.ids;
            businessType = wrapper.business;
            
            if(wrapper.document != null){
               letterUrl = wrapper.document.path;
               
               objIndexes = wrapper.document.indexes;
               
               if(objIndexes != null){
                 varLetterFormIdentifier = objIndexes.LetterFormIdentifier;
                 varAddress = objIndexes.RecipientAddress;
                 if(!String.IsBlank(objIndexes.LetterDate)){
                     try{
                         varLetterDate = date.valueOf(objIndexes.LetterDate);
                     }
                     Catch(Exception ex){
                         varLetterDate = null;
                     }
                     
                 }  
               }
               
            }
        }
          
        //ScCollection_ApiResponse.Messages objMsges = new ScCollection_ApiResponse.Messages();
        
        if(ids != null && ids.Size()>0){
            for(ScCollection_UpdateLetterParse.ids objIds : ids){
                if(!String.IsBlank(objIds.type) && ScCollection_CommonCodeHandler.RemoveSpace(objIds.type).equalsIgnoreCase('AccountIdentifier')){
                   loanNo = objIds.value;
                }
                else if(!String.IsBlank(objIds.type) && ScCollection_CommonCodeHandler.RemoveSpace(objIds.type).equalsIgnoreCase('LeadID')){
                   uniqueId = objIds.value;
                }
            }
        }
       
        List<cnotify__Delivery_Detail__c> lstDelivery = new List<cnotify__Delivery_Detail__c>();
        
        if(businessType.equalsIgnoreCase('Jackson')){
            
            if(loanNo != ''){
                System.debug(loanNo);
                String contractName = loanNo+'_0';
                List<collect__Loan_Account__c> lstLoanAcc = [Select Id,Name From collect__Loan_Account__c Where Name =:contractName];
                if(lstLoanAcc != null && lstLoanAcc.Size() > 0){
                    String loanRecId = String.valueOf(lstLoanAcc[0].Id).substring(0, 15);
                    cnotify__Delivery_Detail__c objDetailsToInsert = new cnotify__Delivery_Detail__c();
                    objDetailsToInsert.Name = varLetterFormIdentifier;
                    objDetailsToInsert.cnotify__Subject__c = varLetterFormIdentifier;
                    objDetailsToInsert.cnotify__Sent__c = true;
                    objDetailsToInsert.cnotify__Address__c = varAddress;
                    objDetailsToInsert.ScCollection_Communication_Type__c = 'Letter';
                    objDetailsToInsert.ScCollection_Is_Manual__c = true;
                    objDetailsToInsert.cnotify__Contract_Id__c = loanRecId;
                    objDetailsToInsert.ScCollection_Letter_URL__c = letterUrl;
                    objDetailsToInsert.cnotify__Sent_Date__c = varLetterDate;
                    
                    try{
                        insert objDetailsToInsert;
                        
                        objApiStatus.Status = 'Success';
                        objApiStatus.Description = 'Success Response';
                        ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                        objMsg.MessageDescription = 'Request has been processed successfully - '+objDetailsToInsert.Id;
                       
                        objApiStatus.Messages = new List<ScCollection_ApiResponse.Messages>();
                        objApiStatus.Messages.add(objMsg);
                        
                        objResponse.APIStatus = objApiStatus;
                        
                        return objResponse;
                    }
                    catch(Exception e){
                        objApiStatus.Status = 'Fail';
                        objApiStatus.Description = 'Failure Response';
                        ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                        objMsg.MessageDescription = e.getMessage();
                        lstMessages.add(objMsg);
                        objApiStatus.Messages = lstMessages;
                        objResponse.APIStatus = objApiStatus;
                        return objResponse;
                    }
                }
                else{
                    ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                    objMsg.MessageDescription = 'No Matching Contract Found with AccountIdentifier.';
                    lstMessages.add(objMsg);
                    objApiStatus.Status = 'Fail';
                    objApiStatus.Description = 'Failure Response';
                    objApiStatus.Messages = lstMessages;
                    objResponse.APIStatus = objApiStatus;
                    return objResponse;
                }
            }
            else{
                ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                objMsg.MessageDescription = 'Loan No value is missing for AccountIdentifier.';
                lstMessages.add(objMsg);
                objApiStatus.Status = 'Fail';
                objApiStatus.Description = 'Failure Response';
                objApiStatus.Messages = lstMessages;
                objResponse.APIStatus = objApiStatus;
                return objResponse;
            }
        }
        else if(businessType.equalsIgnoreCase('SALESFORCE')){
            
            if(uniqueId != '' && loanNo != ''){
                system.debug(uniqueId +'=='+loanNo);
               lstDelivery = [select id,ScCollection_Letter_Key__c from cnotify__Delivery_Detail__c  where ScCollection_Letter_Key__c = : uniqueId and ScCollection_Contract_Name__c = : loanNo limit 1];
            }
            else{
                if(uniqueId == ''){
                  temp_check = true;
                  
                   ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                   objMsg.MessageDescription = 'Key value is missing for LeadID.';
                   lstMessages.add(objMsg);
                 
                }
                if(loanNo == ''){
                    
                    temp_check = true;
                    
                    ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                    objMsg.MessageDescription = 'Loan No value is missing for AccountIdentifier.';
                    lstMessages.add(objMsg);
                    
                    
                }
                if(temp_check){
                    objApiStatus.Status = 'Fail';
                    objApiStatus.Description = 'Failure Response';
                    objApiStatus.Messages = lstMessages;
                    objResponse.APIStatus = objApiStatus;
                    return objResponse;
                }
                   
            }
           
            if((lstDelivery != null && lstDelivery.Size()>0) || test.isRunningTest()){
                cnotify__Delivery_Detail__c objDelivery = new cnotify__Delivery_Detail__c();
                try{
                    objDelivery.Id = lstDelivery[0].Id;
                    objDelivery.ScCollection_Letter_URL__c = letterUrl;
                 
                
                    update objDelivery;
                    objApiStatus.Status = 'Success';
                    objApiStatus.Description = 'Success Response';
                    ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                    objMsg.MessageDescription = 'Request has been processed successfully';
                   
                    objApiStatus.Messages = new List<ScCollection_ApiResponse.Messages>();
                    objApiStatus.Messages.add(objMsg);
                    
                    objResponse.APIStatus = objApiStatus;
                    
                    return objResponse;
                }
                catch(Exception e){
                    
                    objApiStatus.Status = 'Fail';
                    objApiStatus.Description = 'Failure Response';
                    ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                    objMsg.MessageDescription = e.getMessage();
                    lstMessages.add(objMsg);
                    objApiStatus.Messages = lstMessages;
                    objResponse.APIStatus = objApiStatus;
                    return objResponse;
                }
            }
            else{
                
                objApiStatus.Status = 'Fail';
                objApiStatus.Description = 'Failure Response';    
                ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
                objMsg.MessageDescription = 'No matching record found with LeadID and AccountIdentifier value to update the document URL.';
                lstMessages.add(objMsg);
                objApiStatus.Messages = lstMessages;
                objResponse.APIStatus = objApiStatus;
                return objResponse;
                
               
            }
        }
        ScCollection_ApiResponse.Messages objMsg = new ScCollection_ApiResponse.Messages ();
        objMsg.MessageDescription = 'Something went wrong please contact you administrator.';
        lstMessages.add(objMsg);
        objApiStatus.Status = 'Fail';
        objApiStatus.Description = 'Failure Response';
        objApiStatus.Messages = lstMessages;
        objResponse.APIStatus = objApiStatus;
        return objResponse;  
    }
}
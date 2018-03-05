@RestResource(urlMapping='/uploadFile')
global with sharing class WebServiceUploadReturns{
   
    global class Response{
        public String status;
        public String errorCode;
        
        public Response(){
            errorCode = 'No_Error';
            status =null;
        }
    }
    global class Request{
        public String fileContent;
        public String fileName;
        public String parserClassName;
        public Integer batchSize;
    }
    
    @HttpPost
    global static Response doPost(){
        Response r = new Response();
        
        RestRequest req = RestContext.request;
        loan.ACHReturnPaymentProcessor paymentProcessor;
        
        String jsonData = req.requestBody.toString();
        System.debug(jsonData);
        Request doc;
        try{
           doc = (Request)JSON.deserialize(jsondata, Request.class);
        }catch (Exception e){
           r.status=e.getMessage();
           r.errorCode='INVALID_INPUT';
           return r;
        }
        String className;
        
        List<Document> existingDocs = [select id from Document where Name =:doc.fileName];
        
        if(existingDocs.size()>0){
            r.Status = 'Success';
            r.errorCode = 'Duplicate file';
        }
        
        
        if(doc.fileName.contains('wibs_pl_bilat_cr')){
            Bank_File_Config__c bConfig = Bank_File_Config__c.getInstance('wibs_pl_bilat_cr');
            Folder  fId = [select id from Folder where Name =:bConfig.Folder_Name__c];
            Request bReq = new Request();
            bReq.fileContent = doc.fileContent;
            Document d = new Document();
            d.Body = Blob.valueOf(doc.fileContent);
            if(fId == null){
                d.FolderId = UserInfo.getUserId();
            }else{
                d.FolderId = fId.Id;
            }
            d.Name = doc.fileName;
            d.ContentType = 'text/plain';
            d.Type = 'txt';
            bReq.parserClassName = 'BilatFileParser';
            String jsonBody = Json.serialize(bReq);
            System.debug(jsonBody);
            RestRequest tReq = new RestRequest(); 
            RestResponse res = new RestResponse();
     
            tReq.requestURI = '/peer/V1/UploadBankStatement';
            tReq.httpMethod = 'POST';
            
            tReq.requestBody = Blob.valueOf(jsonBody);
            
            RestContext.request = tReq;
            RestContext.response = res;
            try{
                peer.WSUploadBankStatement.Response results = peer.WSUploadBankStatement.doPost();
            }catch(Exception e){
            
            }
            
            insert d;
        }else if(doc.fileName.contains('bpay_pl_recall')){
            Bank_File_Config__c bConfig = Bank_File_Config__c.getInstance('bpay_pl_recall');
            Folder  fId = [select id from Folder where Name =:bConfig.Folder_Name__c];
            Request bReq = new Request();
            bReq.fileContent = doc.fileContent;
            bReq.parserClassName = 'BPayFileParser';
            Document d = new Document();
            d.Body = Blob.valueOf(doc.fileContent);
            if(fId == null){
                d.FolderId = UserInfo.getUserId();
            }else{
                d.FolderId = fId.Id;
            }
            
            d.Name = doc.fileName;
            d.ContentType = 'text/plain';
            d.Type = 'txt';
            
            String jsonBody = Json.serialize(bReq);
            System.debug(jsonBody);
            RestRequest tReq = new RestRequest(); 
            RestResponse res = new RestResponse();
     
            tReq.requestURI = '/peer/V1/UploadBankStatement';
            tReq.httpMethod = 'POST';
            
            tReq.requestBody = Blob.valueOf(jsonBody);
            
            RestContext.request = tReq;
            try{
                peer.WSUploadBankStatement.Response results = peer.WSUploadBankStatement.doPost();
            }catch(Exception e){
            
            }
            
            
            insert d;
        }else if(doc.fileName.contains('wibs_pl_deeds_mx')){
            Bank_File_Config__c bConfig = Bank_File_Config__c.getInstance('wibs_pl_deeds_mx');
            Folder  fId = [select id from Folder where Name =:bConfig.Folder_Name__c];
            
            
            className = 'ACHDeedsReturnPaymentFileParser';
            Document d = new Document();
            d.Body = Blob.valueOf(doc.fileContent);
            if(fId == null){
                d.FolderId = UserInfo.getUserId();
            }else{
                d.FolderId = fId.Id;
            }
            
            d.Name = doc.fileName;
            d.ContentType = 'text/plain';
            d.Type = 'txt';
            try{
                if (className == null) {
                    className = loan.CustomSettingsUtil.getACHParameters().loan__ACH_Return_Filegen__c;
                }
                if (className != null) {
                    try {
                        paymentProcessor = (loan.ACHReturnPaymentProcessor) loan.FileGenerator.getNewInstance(className);
                    } catch (Exception e) {
                        throw new MyException('Could not instantiate filegen class');
                    }
                } 
                if(doc.fileContent!=null){
                    paymentProcessor.setBlob(doc.fileContent);
                }
                if(doc.batchSize!=null){
                    paymentProcessor.setScope(doc.batchSize);
                }else{
                    paymentProcessor.setScope(1);
                }
                paymentProcessor.processPaymentReversal();
            }catch(Exception e){
                
            }
            
            
            if(doc.fileContent!=null){
                r.status = 'Success';
            }
            insert d;
        }else if(doc.fileName.contains('wibs_pl_derps_mx')){
            Bank_File_Config__c bConfig = Bank_File_Config__c.getInstance('wibs_pl_derps_mx');
            Folder  fId = [select id from Folder where Name =:bConfig.Folder_Name__c];
            
            
            className = 'ACHDerpsReturnPaymentFileParser';
            Document d = new Document();
            d.Body = Blob.valueOf(doc.fileContent);
            if(fId == null){
                d.FolderId = UserInfo.getUserId();
            }else{
                d.FolderId = fId.Id;
            }
            
            d.Name = doc.fileName;
            d.ContentType = 'text/plain';
            d.Type = 'txt';
            try{
                if (className == null) {
                    className = loan.CustomSettingsUtil.getACHParameters().loan__ACH_Return_Filegen__c;
                }
                if (className != null) {
                    try {
                        paymentProcessor = (loan.ACHReturnPaymentProcessor) loan.FileGenerator.getNewInstance(className);
                    } catch (Exception e) {
                        throw new MyException('Could not instantiate filegen class');
                    }
                } 
                if(doc.fileContent!=null){
                    paymentProcessor.setBlob(doc.fileContent);
                }
                if(doc.batchSize!=null){
                    paymentProcessor.setScope(doc.batchSize);
                }else{
                    paymentProcessor.setScope(1);
                }
                paymentProcessor.processPaymentReversal();
                if(doc.fileContent!=null){
                    r.status = 'Success';
                }
            }catch(Exception e){
                
            }
            
            insert d;
        }else if(doc.fileName.contains('wibs_pl_deeds_cr')){
            Bank_File_Config__c bConfig = Bank_File_Config__c.getInstance('wibs_pl_deeds_cr');
            Folder  fId = [select id from Folder where Name =:bConfig.Folder_Name__c];
            Document d = new Document();
            d.Body = Blob.valueOf(doc.fileContent);
            if(fId == null){
                d.FolderId = UserInfo.getUserId();
            }else{
                d.FolderId = fId.Id;
            }
            
            d.Name = doc.fileName;
            d.ContentType = 'text/plain';
            d.Type = 'txt';
            insert d;
            
            className = 'ACHDeedsReturnDisbursalFileParser';
            try{
                ACHDeedsReturnDisbursalFileParser parser = new ACHDeedsReturnDisbursalFileParser();
                List<Disbursal_Exception__c> disbExp = parser.parseReturnFile(doc.fileContent);
                
                
                for(Disbursal_Exception__c exp:disbExp){
                    exp.File_Name__c = doc.fileName;
                }
                insert disbExp;
            }catch(Exception e){
                
            }
            
        }else if(doc.fileName.contains('wibs_pl_derps_cr')){
            Bank_File_Config__c bConfig = Bank_File_Config__c.getInstance('wibs_pl_derps_cr');
            Folder  fId = [select id from Folder where Name =:bConfig.Folder_Name__c];
            Document d = new Document();
            d.Body = Blob.valueOf(doc.fileContent);
            if(fId == null){
                d.FolderId = UserInfo.getUserId();
            }else{
                d.FolderId = fId.Id;
            }
            
            d.Name = doc.fileName;
            d.ContentType = 'text/plain';
            d.Type = 'txt';
            insert d;
            try{
                ACHDerpsReturnDisbursalFileParser parser = new ACHDerpsReturnDisbursalFileParser();
                List<Disbursal_Exception__c> disbExp = parser.parseReturnFile(doc.fileContent);
                
                for(Disbursal_Exception__c exp:disbExp){
                    exp.File_Name__c = doc.fileName;
                }
                insert disbExp;
            }catch(Exception e){
            
            }
            
        }
        
        
        
        return r;
    }
}
//To call bank statements API
public class pepBankStatementRequest 
{
    Public string strEndpoint;
    Public string strApiKey;
    //Constructor
    public pepBankStatementRequest()
    {
        //Get Bankstmt Api from Custom setting
        pepBank_Statement_Credential__c objBankstmtCredential = pepBank_Statement_Credential__c.getValues('Credential');   
        strEndpoint = objBankstmtCredential.pepEndPoint_Url__c;
        strApiKey = objBankstmtCredential.pepX_API_KEY__c;
    }
    
    //Method to initiate the statement process
    public pagereference initiate(string bankname, list<String> lstUserCredentials, list<string> lstUserQuearyType, boolean isTest, string parentid, string selectedAccounts)
    {
       return statementRequest(loginRequest(bankname, lstUserCredentials,lstUserQuearyType, isTest), parentid, isTest, selectedAccounts,bankname);  
    }
    
    //Method is used to login and fetch user token from bank statement
    public pepBankStatementResponse.bankSatementResponseSuccessorFailure loginRequest(String bank_Slug_Nmme, list<String> lstUserCredentials, list<string> lstUserQuearyType,Boolean istest)
    {
        pepBankStatementResponse.bankSatementResponseSuccessorFailure return_Ref = new pepBankStatementResponse.bankSatementResponseSuccessorFailure(Null,false,Null);       
        String response;
        String strBody = '{"credentials": {"institution": "'+bank_Slug_Nmme+'"';
        for(integer i=0;i<lstUserQuearyType.size();i++){
            System.debug('####amit'+lstUserQuearyType[i]);
            System.debug('####amit'+lstUserCredentials[i]);
            strBody = strBody+',"'+lstUserQuearyType[i]+'": "'+lstUserCredentials[i]+'"';
            
        }
        strBody = strBody+'}}';
        //String body = '{"credentials": {"institution": "'+bank_Slug_Nmme+'","username": "'+username+'","password": "'+password+'"}}';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/login');
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept-Language', 'en-US,en;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip,deflate,sdch');
        req.setHeader('Content-Encoding', 'gzip'); 
        req.setHeader('Accept-Encoding', 'gzip');
        req.setHeader('Accept', '*/*');
        req.setHeader('X-API-KEY',strApiKey);
        req.setTimeout(120000);
     //   req.setCompressed(true); 
        req.setbody(strBody);
        Http http = new Http();
        String Statuscode;
        String responseFromHttp;
        
        if(isTest == false)
        {
            try
            {
                system.debug('reqresponseValueIs1'+req);
                HTTPResponse res = http.send(req);
                Statuscode = String.valueOf(res.getStatusCode());
                responseFromHttp = res.getBody();
                System.debug('@#@#amit'+res.getBody());
                if(Statuscode == '200')
                {
                    if(res.getBody().contains('mfa')){
                    return new pepBankStatementResponse.bankSatementResponseSuccessorFailure((pepProfileHandler)System.JSON.deserialize(responseFromHttp,pepProfileHandler.class),true,'Successful Hit.','mfa');
                    }
                    else{
                    return new pepBankStatementResponse.bankSatementResponseSuccessorFailure(pepBankStmtAPIResponse.parse(responseFromHttp),true,'Successful Hit.');
                    }
                }else
                {
                    return new pepBankStatementResponse.bankSatementResponseSuccessorFailure(Null,false,'Unsuccessful Hit. Response from server is :'+responseFromHttp + 'Request is -:'+req);
                }                    
            }
            catch(Exception e)
            {
                response = e.getMessage();
                System.debug('response&*&*'+response);
                return new pepBankStatementResponse.bankSatementResponseSuccessorFailure(Null,false,response);
            }
        }
        else
        {
            Statuscode = '200';
            response = 'Test Mode';
            return new pepBankStatementResponse.bankSatementResponseSuccessorFailure(Null,true,response);
        }                                
        
        return return_Ref;                
    }
    
    //Method to initiate statemnt and Fetch file methods to set account number to fetch statement from
    public pagereference statementRequest(pepBankStatementResponse.bankSatementResponseSuccessorFailure objtoProcess, Id parentId, boolean isTest, string selectedAccounts ,string bankname)
    {
        String user_Token ;
        String AccountId = '';        
        if(objtoProcess.success == true)
        {
            if(objtoProcess.ismfa==True)
            user_Token = objtoProcess.responseProfile.user_token;
            else    
            user_Token = objtoProcess.response.user_token;         
            System.debug('$$$$$#### - ' + user_Token);        
            populate(user_Token, selectedAccounts,bankname,parentId);
            FetchFile(user_Token, parentId);
        }
        return null;   
    }
    
    //Method to call statemnt method to set account number to fetch statement from
    public void populate(string user_Token, string selectedAccounts, string bankname,string applicationId)
    {
       //String body = '{"user_token":"'+user_Token+'","accounts":{"'+bankname+'":['+selectedAccounts+']}}';
       if(selectedAccounts <> null && selectedAccounts <> '')
       {
        list<string> lstAccValues = selectedAccounts.split(',');
        string innerBody = '';
        if(lstAccValues != null && !lstAccValues.isEmpty())
        {
            for(string strValue : lstAccValues)
            {
                innerBody = innerBody+'<value>'+strValue+'</value>';
            }           
        }
        String Body = '<xml><user_token>'+user_Token+'</user_token><accounts><'+bankname+'>'+innerBody+'</'+bankname+'></accounts></xml>';
        system.debug('@@@karthik'+Body);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/statements');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        req.setHeader('X-API-KEY',strApiKey);
        req.setbody(body);
        req.setTimeout(100000); 
        req.setHeader('Content-Encoding', 'gzip'); 
        req.setHeader('Accept-Encoding', 'gzip');
      //  req.setCompressed(true);        
        System.debug('!!!!Statement Body -'+body);       
        Http http = new Http();
        system.debug('reqresponseValueIs12'+req);
        HTTPResponse res = http.send(req);
        String Statuscode = String.valueOf(res.getStatusCode());
        String response = res.getBody();              
        System.debug('!!!! XML Response - '+response);
        BankParserService objBankParserService = new BankParserService();
        objBankParserService.fetchAndInsertBankStatement(response,applicationId,bankname);
          //added by Amit Kumar
            Map<String,SObject> relatedObjects = new Map<String,SObject>();
            Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();    
            genesis__Applications__c objApplication =  new genesis__Applications__c();
            objApplication.is_Bank_Statement_Utilized__c  = true;              
            objApplication.id=applicationid;
            pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
       }
    }
    
    //Method to fetch file from bank statement and save it in salesforce
    @future(callout=true)
    public static void FetchFile(string user_Token, string strAppId)
    {         
       //Get Bankstmt Api from Custom setting
        pepBank_Statement_Credential__c objBankstmtCredential = pepBank_Statement_Credential__c.getValues('Credential');   
        string strEndpoint = objBankstmtCredential.pepEndPoint_Url__c;
        string strApiKey = objBankstmtCredential.pepX_API_KEY__c;
        //create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/files?X-API-KEY='+strApiKey+'&user_token='+ user_Token);
      //  req.setCompressed(true);
        req.setMethod('GET');
        
        //getting Response     
        Http http = new Http();
        system.debug('reqresponseValueIs13'+req);
        HTTPResponse objresponse = http.send(req); 
        system.debug('objresponse?????' + objresponse.getBody());
        if(objresponse.getstatuscode()==200){        
        Blob objBlob = objresponse.getBodyAsBlob();       
        system.debug('status???' + objresponse.getBodyAsBlob());
        string strBankstmtCategory = system.label.pepBankstatementAPI;
        list<genesis__Application_Document_Category__c> lstappDocCategory = [select id, Name from genesis__Application_Document_Category__c where genesis__Application__c=:strAppId AND Name =:strBankstmtCategory];
        if(lstappDocCategory != null && !lstappDocCategory.isEmpty())
        {
            Attachment attach = new Attachment();
            attach.Body = objBlob;
            attach.Name = 'Bankstatement.zip';
            attach.ContentType = 'application/zip';
            attach.ParentID = lstappDocCategory[0].id;
            insert attach; 
            //added by karthik on 06/05/2016
            String jsonRes = genesis.TransactionRoomRemoteAction.linkAttachmentToADC(strAppId,lstappDocCategory[0].id,attach.id);
           
        } 
      }
                   
    }
    
    public pepBankInstitution FetchInstitutionDetails(String strBankName)
    {
        //fetch the login details from custom settings
        pepBank_Statement_Credential__c objBankStatement = pepBank_Statement_Credential__c.getValues('Credential');
        
        //create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/institutions');
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('X-API-KEY', strApiKey);
        req.setHeader('Content-Encoding', 'gzip'); 
        req.setHeader('Accept-Encoding', 'gzip');
     //   req.setCompressed(true);
        //getting Response     
        Http http = new Http();   
        system.debug('reqresponseValueIs14'+req);       
        HTTPResponse objresponse = http.send(req);
       
        system.debug('objresponse?????' + objresponse.getBody()); 
        
        //Parse entire JSON response.
        String strJsonResponse = objresponse.getBody().replace('"values":""','"values":{"one":1,"two":2,"three":3,"four":4}'); 
        
        strJsonResponse = strJsonResponse.replace('"values":{"1":1,"2":2,"3":3,"4":4}','"values":{"one":1,"two":2,"three":3,"four":4}');    
            
        system.debug('objresponse2222' + strJsonResponse); 
        System.JSONParser parser = JSON.createParser(strJsonResponse);
        
        List<pepBankInstitution> lstInstitutions = new List<pepBankInstitution>();
        
        while (parser.nextToken() != null) 
        {
            system.debug('KKKKKKK***'+parser.getText()); 
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) 
            {
                while (parser.nextToken() != null) 
                {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
                    {
                             
                        pepBankInstitution inv = (pepBankInstitution)parser.readValueAs(pepBankInstitution.class);
                        lstInstitutions.add(inv);
                        
                        if(inv.slug == strBankName)
                            return inv;
                    }
                }
            }
        }
        
        system.debug('NRAC::::::'+lstInstitutions.size()+':::'+lstInstitutions);
        
        return null;
    }

    public String PreloadFetchCaptcha(String strBankName)
    {
        //create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/preload?institution='+strBankName);
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/xml');
        req.setHeader('X-API-KEY', strApiKey);
        req.setHeader('Content-Encoding', 'gzip'); 
        req.setHeader('Accept-Encoding', 'gzip');
     //   req.setCompressed(true);
        //getting Response     
        Http http = new Http();
        system.debug('reqresponseValueIs12'+req);
        HTTPResponse objresponse;
        if(!test.isRunningTest()){
         objresponse = http.send(req);
         }
         else{
         Httpresponse temp = new Httpresponse();
         temp.setbody('<?xml version="1.0" encoding="utf-8"?><xml><institution><slug>bank_of_captcha</slug><name>Bank of CAPTCHA</name><credentials><credential><name>Username</name><fieldID>username</fieldID><type>TEXT</type><description/><values/><keyboardType>default</keyboardType></credential><credential><name>Password</name><fieldID>password</fieldID><type>password</type><description/><values/><keyboardType>default</keyboardType></credential><credential><name>Enter Text Shown</name><fieldID>captcha</fieldID><type>captcha</type><description/><values/><keyboardType>default</keyboardType><src>data:image/gif;base64,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</src><width>300</width><height>60</height><alt/></credential></credentials><status/><available>1</available><searchable>1</searchable><display>0</display><searchVal>bankofcaptchademotest</searchVal><region/><export_with_password>0</export_with_password><estatements_supported>0</estatements_supported><transaction_listings_supported>0</transaction_listings_supported><card_validation_supported>0</card_validation_supported><requires_preload>1</requires_preload><requires_mfa>0</requires_mfa><do_not_proxy>0</do_not_proxy><updated_at>2016-11-17 16:28:55</updated_at><max_days>365</max_days><get_address_supported>0</get_address_supported></institution><user_token>RizL9ce4la_L7C3B_zhdRQ</user_token></xml>');
         objresponse=temp;
         } 
        
         system.debug('objresponsecaptcha?????' + objresponse.getBody()); 
        
        //institution institutions = (institution)JSON.deserialize(objresponse.getBody(), institution.class);
        //system.debug('NRAC::::'+institutions);
                
        Dom.Document doc = objresponse.getBodyDocument();
        
        //Retrieve the root element for this document.
        Dom.XMLNode objParent = doc.getRootElement();
        
        System.debug('NRAC:::objParent::'+objParent);
        
        // Alternatively, loop through the child elements.
        // This prints out all the elements of the address
        for(Dom.XMLNode objInstitute : objParent.getChildElements()) 
        {
            System.debug('objInstitute:::::'+objInstitute);
            for(Dom.XMLNode objInstituteProp : objInstitute.getChildElements())
            {
                System.debug('objInstituteProp:::::'+objInstituteProp);             
            }
            
            Dom.XMLNode objCredentials = objInstitute.getChildElement('credentials', null);
            
            if(objCredentials != null)
            {
            
                system.debug('NRAC:::CRED::'+objCredentials.getName());
                
                for(Dom.XMLNode objCredential : objCredentials.getChildElements())
                {
                    system.debug('objCredential:::'+objCredential.getname());
                     for(Dom.XMLNode objCaptcha : objCredential.getChildElements())
                     {
                          system.debug('objCaptcha :::'+objCaptcha.getName());
                          If(objCaptcha.getName() == 'src'){
                            system.debug('objCaptchaImg :::'+objCaptcha.getText());
                            String strCaptchaUrl = objCaptcha.getText();
                            return strCaptchaUrl;
                          }
                     }
                }
               // Dom.XMLNode objCredentials = objCredentials.getChildElement('credentials', null);
            }
        }
       
        return null;
    }
}
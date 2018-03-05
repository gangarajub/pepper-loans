public class peploanSetupverifyidController 
{
    public Id LoggedInAccountId;
    public  Id idApplication;
    Public Boolean exceptionOccur{get;set;}
    public string StrAuthToken{get;set;}
    public string clientRedirectURL {get;set;}
    public boolean calljumioApi{get;set;}
    public String siteUrl;
    public String siteUrlForJumio;
    public genesis__Applications__c objApplication;
    public Boolean successSaveForLater{get;set;}
    //Constructor
    public peploanSetupverifyidController ()
    {
        objApplication = new genesis__Applications__c ();
        siteUrl = System.label.pepSiteUrl;
        siteUrlForJumio = System.label.Site_URL;
        exceptionOccur=false;
        calljumioApi = false;
        if(apexpages.currentpage().getparameters().get('error') != null
           && apexpages.currentpage().getparameters().get('error') == 'true')
        {
            exceptionOccur=true;
            calljumioApi = true;
        }
        getCookieData();
        fetchApplication();   
    
    
    }
    
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
        if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
               idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
               objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
       
    }
    
    public void fetchApplication()
    {
         Map<string,string> childobjects = new Map<string,string>();
         if(idApplication != null)
         {
             List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,idApplication,null,null,childobjects );
             if(lstApplication != null && lstApplication.size() > 0)
             {
                 LoggedInAccountId = lstApplication[0].genesis__Account__c;
                 objApplication = lstApplication[0];
                
             }
         }
    
    }
    public void displayIframe()
    {
        try{
        calljumioApi = true;
        JSONGenerator objJsonGen = JSON.createGenerator(true);
        objJsonGen.writeStartObject();
        
        if(LoggedInAccountId != null)
        {
            objJsonGen.writeStringField('merchantIdScanReference', LoggedInAccountId);
        }
        else{
                objJsonGen.writeStringField('merchantIdScanReference', 'TestScanReference'); 
            }          
        
         //Get Merchant Api and Secret from Custom setting
        pepJumio_Credentials__c objJumioCredential = pepJumio_Credentials__c.getValues('Credential');     
        String strUserName = objJumioCredential.pepMerchant_API_token__c;
        String strPassword = objJumioCredential.pepActive_API_secret_c__c;    
        String strEndPoint = objJumioCredential.pepEnd_Point__c;
        
        objJsonGen.writeStringField('successUrl',   siteUrl+'/pepJumioSuccess');
        objJsonGen.writeStringField('errorUrl',     siteUrl+'/pepJumioFailure');
        objJsonGen.writeStringField('callbackUrl',  siteUrl+'/pepJumioCallBackUrl');
        objJsonGen.writeStringField('country','AUS');
        objJsonGen.writeEndObject();
        String jsonRequest = objJsonGen.getAsString();                
        
       
        
        String strAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(strUserName + ':' + strPassword));
        
        //Create Http request
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(strEndPoint);
        System.debug('!!!! strAuthorizationHeader -'+ strAuthorizationHeader);
        req.setHeader('Authorization', strAuthorizationHeader);
        req.setHeader('Accept', 'application/json');             
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
        req.setHeader('Content-Encoding', 'gzip'); 
        req.setHeader('Accept-Encoding', 'gzip');
      //  req.setCompressed(true); 
        req.setBody(jsonRequest);
                
        //send request        
        Http http = new Http();
        HTTPResponse jsonResponse = new HTTPResponse();
        if(!Test.isRunningTest())
        jsonResponse = http.send(req);
        else
        jsonResponse=createddummyresponse();
        String jsonResponseBody = jsonResponse.getBody(); 
        system.debug('@@@json'+jsonResponseBody);  
                    
        RootObject objRootObject = parse(jsonResponseBody);      
        System.debug('RootObject*********'+objRootObject);
        StrAuthToken = objRootObject.authorizationToken;
        clientRedirectURL = objRootObject.clientRedirectUrl;
        if(idApplication != null)
        {           
           if(objRootObject != null)
           {
               if(LoggedInAccountId != null)
               {
                Account objAccount = new Account(id=LoggedInAccountId); 
                objAccount.Session_Key__c = objRootObject.authorizationToken;
                objAccount.Tracking_Id__c = objRootObject.jumioIdScanReference;
                objAccount.Current_Application_Id__c = idApplication ;
                objAccount.URL__c = objRootObject.clientRedirectUrl;
                update objAccount;        
                
               }
                                              
               
           } 
        }
      }
      Catch(Exception ex){
      String str='';
      str=ex.getmessage();
      PeputilityClass.CreateExceptionRecord(str,'Jumio Invoke Error');
      exceptionOccur=true;
      }  
    }
    
    public class RootObject
    {
        public string timestamp { get; set; }
        public string authorizationToken { get; set; }
        public string clientRedirectUrl { get; set; }
        public string jumioIdScanReference { get; set; }
    }
    
    public static RootObject parse(String json) 
    {
        return (RootObject) System.JSON.deserialize(json, RootObject.class);
    }
    
    Public HttpResponse createddummyresponse(){
      HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"timestamp":"2016-06-23T08:28:07.014Z","authorizationToken":"df13c032-c29c-4f63-97f8-3d345316da7f","clientRedirectUrl":"https://netverify.com/widget/jumio-verify/2.0/form?authorizationToken=df13c032-c29c-4f63-97f8-3d345316da7f","jumioIdScanReference":"cb3977c0-e47a-4f81-a3e4-48be6edd5b32"}');
        res.setStatusCode(200);
        return res;
    }
    public PageReference redirect()
    {   
        string redircetPageName= pages_config__c.getinstance('peploansetupmanualupload').Page_Label__c;
        pageReference p = new Pagereference('/'+redircetPageName);
        Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
        cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
        system.debug('cookieApplicationId2--'+cookieApplicationId2 );
        p.setCookies(new Cookie[]{cookieApplicationId2 });
        p.setRedirect(true);
        return p;
    
    }
    
    //  This method is used to save the page name of current page in navigation status of application and sent notification(retrieval code)
  //  through SMS and Email to related account of respected application.

     public void saveForLater()
     {
           
            system.debug('aplicationIdIs'+objApplication);
            successSaveForLater=false;
           if(objApplication!=null && objApplication.id!=null)  
             {
                       
                         genesis__Applications__c objApplicationReturn = new  genesis__Applications__c ();
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'peploanSetupverifyid') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                   system.debug('objApplicationIs'+objApplication.genesis__Account__c);
                                  
                         }     
               }                                  
      
     }

    Public Pagereference refreshpage(){
    string redircetPageName= pages_config__c.getinstance('peploansetupverifyid').Page_Label__c;
    
    return new Pagereference('/'+redircetPageName).setRedirect(True);
    }
   
    Public Pagereference checkcookie()
    {
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        return pr;
    }
    

}
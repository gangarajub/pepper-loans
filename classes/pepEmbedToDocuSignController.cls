public without sharing class pepEmbedToDocuSignController 
{

    public String Page_Label { get; set; }
    Public Boolean processchecker{get;set;}
    Public Boolean DDDpusercontext{get;set;}
    Public string redirectstring{get;set;}
    Public Boolean DDPError{get;set;}
    Public Boolean mobileProcessing{get;set;}
    Public string mobileURL;
    public pepEmbedToDocuSignController(pepContractController controller) 
    {   
        envelopeId = 'Not sent yet';
        mobileURL='';
        mobileProcessing=false;
        ishidebutton=false;
        redirectstring='';
        processchecker=controller.processddp;
        istopWindow=false;
        isDocusignStart=false;
        DDPError=controller.isError;
        DDDpusercontext=controller.isDDP_User_LoggedIn;
        lstSection=new List<pepCMSSection__c>();
        lstSection=[Select id,pepHeader__c,pepSectionBodyRich__c from pepCmsSection__c  where pepPage__r.pepPageName__c='Contract' order by pepSequence__c asc];
    }
    public List<pepCMSSection__c> lstSection{get;set;}
    public List<pepCmsQuestion__c> lstQuestions{get;set;}
    public boolean ishidebutton{get;set;}
    public boolean istopWindow{get;set;}
    public String envelopeId {get;set;}
    private Id idApplication;
    public String tokenURL {get;set;}
    //Get docusign Secrets from Custom setting
    DocuSignCredentials__c objDocusignCredential = DocuSignCredentials__c.getValues('DocuSignCreds');
    private String accountId = objDocusignCredential.API_Account_ID__c;
    private String userId = objDocusignCredential.API_Username__c;
    private String password = objDocusignCredential.API_Password__c;
    private String integratorsKey = objDocusignCredential.Integrated_Key__c;
    private String webServiceUrl 
        = objDocusignCredential.Webservice_URL__c;
    private integer lengthAttachmentList;
    public boolean isPollerEnable{get;set;}
    public boolean isDocusignStart{get;set;}
    public pepEmbedToDocuSignController()
    {
        
    }
    
    public void embedDocuSignOpen() {
        if(mobileprocessing==False)
        tokenurl = SendNow();
        else
        mobileURL=SendNow();
    }
    
    // returns URL of POP page that redirects callbacks to correct URL
    // Strips off end of path and replaces with ndaPOP
    @TestVisible()
    private String getPopURL() {
        String popURL ;//= Site.getCurrentSiteUrl();
        if (popURL == null) {
            popURL = Label.Site_URL_for_Docusign;
        } 
        System.Debug('pop page: ' + popURL);
        return popURL;
    }
   
   public string  fetchSignedPDF()
   {
        try{
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        system.debug('cookieApplicationId--'+cookieApplicationId);
        if(cookieApplicationId != null && cookieApplicationId.getValue()!= null && cookieApplicationId.getValue() != '')
        {            
            idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }  
        else
        {
            idApplication=ApexPages.currentPage().getParameters().get('id');
        } 
       DocuSignAPI.APIServiceSoap dsApiSend 
                = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = webServiceUrl;            

        //Set Authentication
        String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password><IntegratorKey>' + integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';
        System.debug('Setting authentication to: ' + auth);

        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', 
            auth);

        genesis__Applications__c ap=[select id,genesis__Account__c,PepDocusignenvelopeId__c from genesis__Applications__c where id=:idApplication limit 1];
        envelopeId=ap.PepDocusignenvelopeId__c ;

        
        DocuSignAPI.DocumentPDFs signedPDF = new DocuSignAPI.DocumentPDFs();
        if(!test.isRunningTest())
          signedPDF=dsApiSend.RequestDocumentPDFs(envelopeId);
          DocuSignAPI.DocumentPDF DocPDF =new DocuSignAPI.DocumentPDF();
          
        if((!test.isRunningTest()) && signedPDF.DocumentPDF.size()>0)
        {
            DocPDF=signedPDF.DocumentPDF[0];
            system.debug('DocPDF-----------'+DocPDF);
            saveAttachmentPDF(DocPDF.Name,DocPDF.PDFBytes,idApplication);
           

        }
        else{
        Peputilityclass.CreateExceptionRecord('Signed PDF doesn\'t get returned from Docusign\'s API','Docusign');
       
        }
        redirectstring=Label.Site_URL+getfriendlyurl('pepthankyou');
        istopWindow=true;
        return null;
        }
       catch(Exception ex){
       String str='';
       str=ex.getmessage();
       PepUtilityClass.CreateExceptionRecord(str,'Docusign');
       throw ex;//throwing exception to not interupt the normal flow.
       return null;
       }       
   }
  // @future
   public static void saveAttachmentPDF(string name,string pdfBytes,Id applicationId){
        system.debug('inside save attachment');
        
        List<Attachment> lstAttachments = new List<Attachment>();
        lstAttachments = [Select id, name, parentid, CreatedDate from attachment where parentId =: applicationId order by createdDate];
        Boolean bAttachmentInsertFlag = false;
        attachment signedcontract;
        for(attachment a: lstAttachments)
        {
            if(a.Name == 'Signed Contract')
            {
                signedcontract = a;
            }
        }
        system.debug('signedcontract   '+signedcontract);
        if(signedcontract != NULL && signedcontract.Id != NULL)
        {
            for(attachment a: lstAttachments)
            {
                system.debug('a   '+a);
                if(a.Name.contains('Application Contract') && signedcontract.createdDate < a.createdDate)
                {
                    bAttachmentInsertFlag = true;
                    break;
                }
            }
        }else{
            bAttachmentInsertFlag = true;
        }
        
        system.debug('bAttachmentInsertFlag     '+bAttachmentInsertFlag);
        
        attachment attach=new attachment();
        if(bAttachmentInsertFlag)
        {
            attach.body=EncodingUtil.base64Decode(pdfBytes);
            attach.Name='Signed Contract';
            attach.ContentType='application/pdf';
            attach.parentid=applicationId;
            system.debug('attach=========='+attach);
            insert attach;
        }
        updateApplicationStatus(applicationId);
        
        if(bAttachmentInsertFlag)
        {
            //Added by Varun on discussion with Ishu Jain
            string strCreditCategory = system.label.PepCreditCategory;
            list<genesis__Application_Document_Category__c> lstappDocCategory = [select id, Name from genesis__Application_Document_Category__c where genesis__Application__c=:applicationId AND Name =:strCreditCategory];
            if(lstappDocCategory != null && lstappDocCategory.size()>0)
            String jsonRes = genesis.TransactionRoomRemoteAction.linkAttachmentToADC(applicationId,lstappDocCategory[0].id,attach.id); 
            //Varun Code ends.
        }
   }
   public PageReference configure(){
       Pagereference pr=Peputilityclass.checkCookieAndRedirect();
       if(pr!=null)
         return pr;
   
   
       list<pepCmsSection__c> lstSection=[SELECT pepHeader__c,pepPage__c, pepSectionBody__c, Name, pepSectionUniqueName__c, pepType__c, 
                                                pepSectionStory__c , Page_Name__c  ,pepSectionStoryRich__c,pepSectionBodyRich__c
                                                from pepCmsSection__c where Page_Name__c=:'Application Complete'];
                                                 
       if(lstSection.size()>0) lstQuestions = [SELECT Id,Is_Date_to_Birth__c, pepSection__c,pepSection__r.Name, pepSection__r.pepHeader__c,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, pepRecordSequence__c,
                                                pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, 
                                                pepGoogleApi__c from pepCmsQuestion__c where pepSection__c =: lstSection.get(0).id];
                                                
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        system.debug('cookieApplicationId--'+cookieApplicationId);
        if(cookieApplicationId != null && cookieApplicationId.getValue()!= null && cookieApplicationId.getValue() != '')
        {            
            idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }  
        else
        {
            idApplication=ApexPages.currentPage().getParameters().get('id');
        } 
        
        // Added by Rishabh to check that veda has already been called
         if(idApplication!=null)
        {
               List<genesis__Applications__c>  lstApp = new List<genesis__Applications__c> ();
               Map<string,string> childobjects = new Map<string,string>();
               lstApp = pepInvokeCLMethodHelper.fetchApplications(null,idApplication,null,null,childobjects);
               if(lstApp.size()>0)
               {
                    if(lstApp[0].Veda_IdMatrix_Completed__c==false && lstApp[0].Veda_Fraud_Completed__c==false)
                        ServiceabilityCalcCtrl.doPostContractVedaCallout(idApplication);
               }
        }  
         //Added by Varun to update the Contract Signed Ip
         String ipAddress;
         Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();   
                //Proceed further only and only if map of header parameter have not null value with it
                if(mapHeaders != null) {
                    ipAddress = mapHeaders.get('True-Client-IP');
                    system.debug('-------Client IP------'+ipAddress);
                    if(ipAddress == null)
                        ipAddress = mapHeaders.get('X-Salesforce-SIP');
                    system.debug('-------Salesforce IP------'+ipAddress);   
  genesis__Applications__c Application = new genesis__Applications__c(id=idApplication,Contract_Signed_IP__c=ipAddress);
  update Application;
  }
       return  null;   
}
   private String SendNow()
        {
            String token = '';
            envelopeid='';
            try{
            
            Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
            
            if(cookieApplicationId!=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')
            {            
                idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
            }
            else
            {
             IDApplication=ApexPages.currentPage().getParameters().get('id');
            }
           
            
            if(idApplication!=null)
                {    
                        DocuSignAPI.APIServiceSoap dsApiSend 
                            = new DocuSignAPI.APIServiceSoap();
                        dsApiSend.endpoint_x = webServiceUrl;            
                
                        //Set Authentication
                        String auth = '<DocuSignCredentials><Username>'+ userId 
                            +'</Username><Password>' + password 
                            + '</Password><IntegratorKey>' + integratorsKey 
                            + '</IntegratorKey></DocuSignCredentials>';
                        System.debug('Setting authentication to: ' + auth);
                            
                        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
                        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', 
                            auth);
                            
                    genesis__Applications__c ap;
                    ap=[select id,genesis__Account__c,PepDocusignenvelopeId__c,genesis__Account__r.FirstName,genesis__Account__r.LastName,genesis__Account__r.PersonMobilePhone,genesis__Account__r.PersonEmail from genesis__Applications__c where id=:idApplication limit 1];
                    if(ap.PepDocusignenvelopeId__c == null || ap.PepDocusignenvelopeId__c == ''){
                        
                 
                        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
                        envelope.Subject = 'Personal Loan Contract' ;
                        /*envelope.EmailBlurb = 'This is my new eSignature service,'+ 
                            ' it allows me to get your signoff without having to fax, ' +
                            'scan, retype, refile and wait forever';*/
                        envelope.AccountId  = accountId; 
                        
                        // fetch contract from application
                        List<Attachment> attachment = [select id, Name, body, ContentType from Attachment where parentid=:idApplication and name='Application Contract.pdf' order by LastModifiedDate DESC limit 1];            
                        System.debug('Attachmentsize'+attachment);
                        if(attachment.size()>0) 
                        {
                            Blob pdfBlob;
                            if(!test.isRunningTest())
                              pdfBlob=attachment[0].body;     
                    
                            // Document
                            DocuSignAPI.Document document = new DocuSignAPI.Document();
                            document.ID = 1;
                            if(!test.isRunningTest())
                            document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
                            document.Name = 'Contract';
                            document.FileExtension = attachment[0].ContentType;
                            envelope.Documents = new DocuSignAPI.ArrayOfDocument();
                            envelope.Documents.Document = new DocuSignAPI.Document[1];
                            envelope.Documents.Document[0] = document;
                            
                            
                            DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
                            recipient.ID = 1;
                            recipient.Type_x = 'Signer';
                            recipient.RoutingOrder = 1;
                            recipient.Email = ap.genesis__Account__r.PersonEmail;
                            recipient.UserName = ap.genesis__Account__r.FirstName + ' ' + ap.genesis__Account__r.LastName;
                            
                            recipient.CaptiveInfo = new DocuSignAPI.RecipientCaptiveInfo();
                            recipient.CaptiveInfo.ClientUserId = '1';
                                
                            // This setting seems required or you see the error:
                            // "The string '' is not a valid Boolean value. 
                            // at System.Xml.XmlConvert.ToBoolean(String s)" 
                            recipient.RequireIDLookup = false;      
                            
                            envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
                            envelope.Recipients.Recipient = new DocuSignAPI.Recipient[1];
                            envelope.Recipients.Recipient[0] = recipient;
                            
                            // Tab
                            DocuSignAPI.Tab tab1 = new DocuSignAPI.Tab();
                            tab1.Type_x = 'SignHere';
                            tab1.RecipientID = 1;
                            tab1.DocumentID = 1;
                            tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
                            tab1.AnchorTabItem.AnchorTabString = '\\s1\\';
                    
                            DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
                            tab2.Type_x = 'DateSigned';
                            tab2.RecipientID = 1;
                            tab2.DocumentID = 1;
                            tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
                            tab2.AnchorTabItem.AnchorTabString = '\\d1\\';
                            
                            DocuSignAPI.Tab tab3 = new DocuSignAPI.Tab();
                            tab3.Type_x = 'FullName';
                            tab3.RecipientID = 1;
                            tab3.DocumentID = 1;
                            tab3.AnchorTabItem = new DocuSignAPI.AnchorTab();
                            tab3.AnchorTabItem.AnchorTabString = '\\n1\\';
                            
                            envelope.Tabs = new DocuSignAPI.ArrayOfTab();
                            envelope.Tabs.Tab = new DocuSignAPI.Tab[3];
                            envelope.Tabs.Tab[0] = tab1;        
                            envelope.Tabs.Tab[1] = tab2;
                            envelope.Tabs.Tab[2] = tab3; 
                            //Added by Varun on discussion with ishu and Support       
                            envelope.CustomFields = new DocuSignAPI.ArrayOfCustomField();
                            DocusignApi.CustomField temp = new DocusignApi.CustomField();
                            temp.Name='##SFAccount';
                            temp.Value=''+ap.genesis__Account__c;
                            temp.CustomFieldType='Text';
                            DocusignApi.CustomField temp1 = new DocusignApi.CustomField();
                            temp1.Name='DSFSSourceObjectId';
                            temp1.Value=''+ap.id;
                            temp1.CustomFieldType='Text';
                            envelope.CustomFields.CustomField= new DocuSignAPI.CustomField[2];
                            envelope.CustomFields.CustomField.add(temp);
                            envelope.CustomFields.CustomField.add(temp1);
                           
                           if(!test.isRunningTest())
                           {
                               DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
                               envelopeId = es.EnvelopeID;
                           }
                }
                else{
                    PeputilityClass.CreateExceptionRecord('Application Contract doesn\'t exist under the Application','DrawLoop');
                   
                    
                }
        }
        else{
             envelopeid=ap.PepDocusignenvelopeId__c;
        }
                    
                      
                     DocuSignAPI.RequestRecipientTokenAuthenticationAssertion assert = new DocuSignAPI.RequestRecipientTokenAuthenticationAssertion();
                     assert.AssertionID = 'Your AssertionID Here';
                     assert.AuthenticationInstant = system.now();
                     assert.AuthenticationMethod = 'Password';
                     assert.SecurityDomain = 'login.Salesforce.com';
                    //'YourApp.com';
                    
                    DocuSignAPI.RequestRecipientTokenClientURLs clientURLs = new DocuSignAPI.RequestRecipientTokenClientURLs();
                    
                    clientURLs.OnAccessCodeFailed = getPopURL() + '?Id='+idApplication+'&event=OnAccessCodeFailed&envelopeid=' + envelopeID;
                    clientURLs.OnCancel = getPopURL() + '?Id='+idApplication+'&event=OnCancel&envelopeid=' + envelopeID;
                    //clientURLs.OnDecline = Label.Site_URL+'getfriendlyurl('pepcontractdeclined')'+'?Id='+idApplication+'&event=OnDecline&envelopeid=' + envelopeID;
                    clientURLs.OnDecline = Label.Site_URL+ getfriendlyurl('pepcontractdeclined');
                    clientURLs.OnException = getPopURL() + '?Id='+idApplication+'&event=OnException&envelopeid=' + envelopeID;
                    clientURLs.OnFaxPending = getPopURL() + '?Id='+idApplication+'&event=OnFaxPending&envelopeid=' + envelopeID;
                    clientURLs.OnIdCheckFailed = getPopURL() + '?Id='+idApplication+'&event=OnIdCheckFailed&envelopeid=' + envelopeID;
                    clientURLs.OnSessionTimeout = getPopURL() + '?Id='+idApplication+'&event=OnSessionTimeout&envelopeid=' + envelopeID;
                    //clientURLs.OnSigningComplete = Label.Site_URL + getfriendlyurl() + '?Id='+idApplication+'&event=OnSigningComplete&envelopeid=' + envelopeID;
                    clientURLs.OnSigningComplete = Label.Site_URL + getfriendlyurl('pepcontractsigned');
                    clientURLs.OnTTLExpired = getPopURL() + '?Id='+idApplication+'&event=OnTTLExpired&envelopeid=' + envelopeID;
                    clientURLs.OnViewingComplete = Label.Site_URL + getfriendlyurl('pepcontractsigned');
                    system.debug('clientURLs--'+clientURLs);
                        
                          //token = dsApiSend.RequestRecipientToken(envelopeId,recipient.captiveinfo.ClientUserId,recipient.UserName,recipient.Email,assert,clientURLs);
                           if(!test.isRunningTest())
                            token = dsApiSend.RequestRecipientToken(envelopeId,'1',ap.genesis__Account__r.FirstName + ' ' + ap.genesis__Account__r.LastName,ap.genesis__Account__r.PersonEmail,assert,clientURLs);
                       
                  
            }
            else{
            PeputilityClass.CreateExceptionRecord('There exists no application at Browser Level','Docusign/DrawLoop');
          
            }
            if(envelopeId !=null && envelopeId !=''){
            updateEnvelopeId(envelopeId,idApplication);
            }
            else{
            PeputilityClass.CreateExceptionRecord('Envelope not created in Docusign Side','Docusign');
            
            }
            system.debug('token--'+token);
            if(token!=null && token!='')
            {
            ishidebutton=true;
            return token;
            }
            else{
            PeputilityClass.CreateExceptionRecord('Problem in getting iframe\'s URL from Docusign API','Docusign');
            
            }
            return token;
        }
        Catch(Exception ex){
        string str='';
        str=ex.getmessage();
        PeputilityClass.CreateExceptionRecord(str,'DrawLoop');
        throw ex;//throwing exception to not interupt the actual flow of user.
        return token;
        }
}
    @future
    public static void updateEnvelopeId(String envelopeId,Id idApplication)
    {
            
                genesis__Applications__c ap=[select id,genesis__Account__c,PepDocusignenvelopeId__c,pepLastSaved__c from genesis__Applications__c where id=:idApplication limit 1];
                ap.PepDocusignenvelopeId__c=envelopeId;
                ap.pepLastSaved__c=System.now();
                update ap;
    }
   Private static void updateApplicationStatus(Id applicationid){
   loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
   Date systemDate;
   if(!test.isRunningTest())
   systemDate = util .getCurrentSystemDate();
   List<genesis__Applications__c> application =[Select id,genesis__Status__c,pepLastSaved__c,RedirectToContract__c from genesis__Applications__c where id=:applicationid];
   application[0].genesis__Status__c='APPROVED - DOCUMENT SIGNED';
   application[0].pepRetrieval_Code_Time__c=null;
   application[0].genesis__Expected_Close_Date__c =systemDate;
   //application[0].pepNavigation_Status__c='ContractSigned';
   application[0].pepLastSaved__c=System.now();
   application[0].RedirectToContract__c=false;
   update application[0];
   
  }
  public static void rejectApplication(){
   try{
   Id idApplication;
   Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
   if(cookieApplicationId!=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')
   {            
       idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
   }
   else
   {
       idApplication=ApexPages.currentPage().getParameters().get('id');
   }
   List<genesis__Applications__c> application =[Select id,genesis__Status__c,pepLastSaved__c,RedirectToContract__c from genesis__Applications__c where id=:idApplication];
       application[0].genesis__Status__c='CONTRACT REJECTED';
       application[0].pepRetrieval_Code_Time__c=null;
       //application[0].pepNavigation_Status__c='ContractDeclined';
       application[0].RedirectToContract__c=false;
       update application[0];
      
   }
   Catch(Exception ex){
   String str='';
   str=ex.getmessage();
   Peputilityclass.CreateExceptionRecord(str,'Docusign');
   throw ex;//throwing exception to not interupt the actual flow of user.
   }
 }
 Private string getfriendlyurl(String s){
 return Pages_config__c.getinstance(s).Page_Label__c;
 }  
 Public Pagereference checkcookie(){
     Pagereference pr=Peputilityclass.checkCookieAndRedirect();
    if(pr==null){
                    
    if(processchecker==false && DDDpusercontext==false && DDPError==false){
    String userAgent =
    ApexPages.currentPage().getHeaders().get('USER-AGENT');
    if(userAgent != null && userAgent !=''){
    if(userAgent.tolowercase().contains('mobile') || userAgent.tolowercase().contains('iphone'))
    mobileProcessing=true;
    }
    embedDocuSignOpen();
        } 
    }
   return pr;
 } 
Public Pagereference updatecontractredirect(){
          try{
         Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
    
        if(cookieApplicationId!=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')
        {            
            idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        genesis__Applications__c ap=[select id,pepLastSaved__c,genesis__Account__c,PepDocusignenvelopeId__c,DDP_Exception__c,DDP_Processed__c,RedirectToContract__c from genesis__Applications__c where id=:idApplication limit 1];
        ap.RedirectToContract__c=True;
        if(ApexPages.currentPage().getparameters().get('ddpException') != null && ApexPages.currentPage().getparameters().get('ddpException') !='' && ApexPages.currentPage().getparameters().get('ddpException')=='Yes'){
        ap.DDP_Exception__c=True;
        ap.DDP_Processed__c=false;
        }
        else{
        ap.DDP_Processed__c=true;
        ap.DDP_Exception__c=false;
        }
        ap.pepLastSaved__c=System.now();
        update ap;
        return null;
    }
    Catch(Exception ex){
    String str='';
    str=ex.getmessage();
    PeputilityClass.CreateExceptionRecord(str,'Docusign');
    String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
    return new Pagereference('/'+redircetPageName);
    }
}
Public Pagereference continuetoSign(){
if(mobileUrl != null && mobileUrl !=''){
Pagereference pr = new Pagereference(''+mobileUrl);
pr.setredirect(true);
return pr;
}
else{
PeputilityClass.CreateExceptionRecord('Mobile Url not returned from Docusign','Docusign');
String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
return new Pagereference('/'+redircetPageName);
}
}
}
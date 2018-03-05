public class pepJumioCallBackUrlController 
{

     public id idApplication;
     public id idAccount;
     String jumioReference;
     public pepJumioCallBackUrlController()
     {
     
         System.debug('AMIT KUMAR******'+apexpages.currentpage().getparameters());
         
         Map<String,String> mapQueryParameters = apexpages.currentpage().getparameters();
         if(mapQueryParameters != null && mapQueryParameters.size() > 0)
         {
             for(String str :mapQueryParameters.keyset())
             {
                 System.debug('queryParam********************'+str );
             
             }
             
             
         
         }
         
              
         if(apexpages.currentpage().getparameters().get('jumioIdScanReference') != null &&
             apexpages.currentpage().getparameters().get('jumioIdScanReference') !='')
        {
            jumioReference = apexpages.currentpage().getparameters().get('jumioIdScanReference');
            System.debug('jumioReference ****'+jumioReference );
        }
        
        if(jumioReference != null)
        {
            System.debug('******+'+jumioReference );
            List<Account> lstAccount =[select id ,Current_Application_Id__c from Account where Tracking_Id__c =:jumioReference];
            System.debug(lstAccount);
            
            if(lstAccount != null && lstAccount.size() > 0)
            {
               idAccount = lstAccount[0].id;
               idApplication = lstAccount[0].Current_Application_Id__c;
               System.debug('idAccount'+idAccount );
               
            }
        }
         
        
     
     }
    
   

    public pagereference saveData()
    {
        try{
        String strFirstName  = Apexpages.currentpage().getparameters().get('idFirstName');
        String strLastName   = Apexpages.currentpage().getparameters().get('idLastName');
        String strIdNumber   = Apexpages.currentpage().getparameters().get('idNumber');
        String strIdType     = Apexpages.currentpage().getparameters().get('idType');
        String strDob        = Apexpages.currentpage().getparameters().get('idDob');
        String strCountry    = Apexpages.currentpage().getparameters().get('idCountry');
        String strExpiryDate = Apexpages.currentpage().getparameters().get('idExpiry');
        String strverificationStatus = Apexpages.currentpage().getparameters().get('verificationStatus');
        String strFrontImageUrl = Apexpages.currentpage().getparameters().get('idScanImage');
        String strbackImageUrl = Apexpages.currentpage().getparameters().get('idScanImageBackside'); 
        String strScanStatus   = Apexpages.currentpage().getparameters().get('idScanStatus'); 
        String strFaceImageUrl = Apexpages.currentpage().getparameters().get('idScanImageFace');  
        String rejectReasonDescription  = Apexpages.currentpage().getparameters().get('rejectReasonDescription');
        String rejectReasonDetails = Apexpages.currentpage().getparameters().get('rejectReasonDetails');
        string FaceMatchScore= Apexpages.currentpage().getparameters().get('idFaceMatch');
        string clientip=Apexpages.currentpage().getparameters().get('clientIp');
        String capturemethod=Apexpages.currentpage().getparameters().get('idScanSource');
        System.debug('rejectReasonDetails******'+rejectReasonDetails);
        System.debug('rejectReasonDescription******'+rejectReasonDescription);  
        System.debug('strverificationStatus **********'+strverificationStatus); 
        System.debug('strbackImageUrl **********'+strbackImageUrl ); 
        System.debug('idScanStatus**********'+strScanStatus); 
                
        Account objAccount = new Account(id =idAccount);
        if(strFirstName != null && strFirstName.contains(' '))
        strFirstName=strFirstName.split(' ')[0];
        objAccount.Jumio_First_Name__c = strFirstName;        
        objAccount.Jumio_Last_Name__c  = strLastName;
        objAccount.Jumio_Id_Number__c  = strIdNumber;
        objAccount.Jumio_Id_Type__c    = strIdType;
        objAccount.pep_Customer_Ip__c=clientip;
        if(FaceMAtchScore != null && FaceMAtchScore != '')
        objAccount.FaceMatchScore__c=Decimal.valueof(FaceMAtchScore);
        if(capturemethod != null && capturemethod !='')
        objAccount.CaptureMethod__c=capturemethod;
        if(rejectReasonDetails != null)
        {
            objAccount.Jumio_Response__c = rejectReasonDetails;
        }
        else if(rejectReasonDescription != null)
        {
            objAccount.Jumio_Response__c = rejectReasonDescription;
        }
        else
        {
            objAccount.Jumio_Response__c = strverificationStatus;
        }
        if(strDob != null && strDob != '')
        {
         objAccount.Jumio_Date_Of_Birth__c = Date.valueOf(strDob);
        }
        objAccount.Jumio_Issuing_Country__c = strCountry;
        objAccount.Jumio_Expiry_Date__c = strExpiryDate;
        Map<String,SObject> relatedObjects = new Map<String,SObject>();
        Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>(); 
        genesis__Applications__c objApplication = new genesis__Applications__c(Id =idApplication);
        if(strverificationStatus =='APPROVED_VERIFIED') 
        {
            objAccount.Jumio_Status__c  = 'Verified';   
            objApplication.Identification_Verification_Status__c = 'Verified';            
           
        }
        else
        {
             
            objAccount.Jumio_Status__c  = 'Declined';   
            objApplication.Identification_Verification_Status__c = 'Not Verified';            
           
        
        }
        
        System.debug('jumioReference****'+jumioReference);
        System.debug('idAccount****'+idAccount);
        System.debug('strFrontImageUrl****'+strFrontImageUrl);
        System.debug('strbackImageUrl ****'+strbackImageUrl );
        SaveAttachments(jumioReference,idAccount,strFrontImageUrl,strbackImageUrl,strFaceImageUrl);        
        update objAccount;
        objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);            
        
        }
        Catch(Exception ex){
            String str='';
            str=ex.getmessage();
            PeputilityClass.CreateExceptionRecord(str,'JumioCallBackUrl');
            throw ex;//Not interupting the normal flow.
            string redircetPageName= pages_config__c.getinstance('peploansetupverifyid').Page_Label__c;
            pageReference p = new Pagereference('/'+redircetPageName);
            Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
            cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
            system.debug('cookieApplicationId2--'+cookieApplicationId2 );
            p.setCookies(new Cookie[]{cookieApplicationId2 });
            p.getParameters().put('error','true');
            
            p.setRedirect(true);
            return p;
        }
        
        return null;
    
    }
    
    
   
    public static void SaveAttachments(String jumioReferences,Id idAccount,String strFrontImageUrl,String strBackImageUrl,String strFaceImageUrl)
    {
        List<Attachment> lstAttachment = new List<Attachment>();
        pepJumio_Credentials__c objJumioCredential = pepJumio_Credentials__c.getValues('Credential');
        String strUserName = objJumioCredential.pepMerchant_API_token__c;
        String strPassword = objJumioCredential.pepActive_API_secret_c__c;    
        String strEndPoint = objJumioCredential.pepEnd_Point__c;            
        strEndPoint = strEndPoint.removeEnd('initiateNetverify');
        String strAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(strUserName + ':' + strPassword));
        //Making request for front Image                   
        HttpRequest req_img_front = new HttpRequest();
        req_img_front.setMethod('GET');
        req_img_front.setEndpoint(strFrontImageUrl);            
        
       // req_img_front.setEndpoint(strEndPoint + 'scans/' + jumioReferences+ '/images/front');            
        req_img_front.setHeader('Authorization', strAuthorizationHeader);
        req_img_front.setHeader('Accept', 'image/jpeg');             
        req_img_front.setHeader('Content-Type', 'application/json');
        req_img_front.setHeader('User-Agent', 'SaasFocus Saas/1.9.0'); 
        req_img_front.setHeader('Content-Encoding', 'gzip'); 
        req_img_front.setHeader('Accept-Encoding', 'gzip');  
       // req_img_front.setCompressed(true);    
        
        Http http_img_front = new Http();
        if(!Test.isRunningTest())
        {
            system.debug('req_img_frontValueIs1'+req_img_front);
            HTTPResponse img_front_Response = http_img_front.send(req_img_front);
            blob imgFrontResponse = img_front_Response.getBodyAsBlob(); 
            system.debug('imgFrontResponse-----------------'+imgFrontResponse);
            system.debug('imgFrontResponse-----------------'+strEndPoint + 'scans/' + jumioReferences+ '/images/front');
            
            if(img_front_Response.getStatus() == 'OK')
            {
                system.debug('expiry front image ok ----');
                Attachment attach_front_img = new Attachment();
                attach_front_img.body = imgFrontResponse;
                attach_front_img.name = 'front.jpeg';
                attach_front_img.ParentId = idAccount;
                lstAttachment.add(attach_front_img);                           
            }
        }
        
        //making request for back image 
        if(strBackImageUrl !=null && strBackImageUrl!='')
        {
        HttpRequest req_img_back = new HttpRequest();
        req_img_back.setMethod('GET');
        req_img_back.setEndpoint(strBackImageUrl);        
        req_img_back.setHeader('Authorization', strAuthorizationHeader);
        req_img_back.setHeader('Accept', 'image/jpeg');             
        req_img_back.setHeader('Content-Type', 'application/json');
        req_img_back.setHeader('User-Agent', 'SaasFocus Saas/1.9.0'); 
        req_img_back.setHeader('Content-Encoding', 'gzip'); 
        req_img_back.setHeader('Accept-Encoding', 'gzip'); 
       // req_img_back.setCompressed(true);      
        Http http_img_back = new Http();
        if(!Test.isRunningTest())
        {
            system.debug('req_img_backValueIs1'+req_img_back);
            HTTPResponse img_back_Response = http_img_back.send(req_img_back);
            blob imgBackResponse = img_back_Response.getBodyAsBlob(); 
            system.debug('imgBackResponse-----------------'+imgBackResponse);        
            if(img_back_Response.getStatus() == 'OK')
            {
                system.debug('expiry back image ok-----------');
                Attachment attach_back_img = new Attachment();
                attach_back_img.body = imgBackResponse;
                attach_back_img.name = 'back.jpeg';
                attach_back_img.ParentId = idAccount;
                lstAttachment.add(attach_back_img);
            }
        }
        }
        
        
        //making request for face Image
         
        HttpRequest req_img_Face = new HttpRequest();
        req_img_Face.setMethod('GET');
        req_img_Face.setEndpoint(strFaceImageUrl);        
        req_img_Face.setHeader('Authorization', strAuthorizationHeader);
        req_img_Face.setHeader('Accept', 'image/jpeg');             
        req_img_Face.setHeader('Content-Type', 'application/json');
        req_img_Face.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
        req_img_Face.setHeader('Content-Encoding', 'gzip'); 
        req_img_Face.setHeader('Accept-Encoding', 'gzip');
      //  req_img_Face.setCompressed(true);       
        Http http_img_Face = new Http();
        if(!Test.isRunningTest())
        {
            system.debug('req_img_FaceValueIs1'+req_img_Face);
            HTTPResponse img_Face_Response = http_img_Face.send(req_img_Face);
            blob imgFaceResponse = img_Face_Response.getBodyAsBlob(); 
            system.debug('imgFaceResponse-----------------'+imgFaceResponse);        
            if(img_Face_Response.getStatus() == 'OK')
            {
                system.debug('Face Image OK');
                Attachment attach_Face_img = new Attachment();
                attach_Face_img.body = imgFaceResponse;
                attach_Face_img.name = 'Face.jpeg';
                attach_Face_img.ParentId = idAccount;
                lstAttachment.add(attach_Face_img);
            }
        }
        
        if(lstAttachment.size() > 0)
        {
            insert lstAttachment;
        }
        
        
        
    
    }
    
   
}
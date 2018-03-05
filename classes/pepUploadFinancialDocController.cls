global class pepUploadFinancialDocController 
{
   public  Id idApplication;
   public string strErrorMesg{get;set;}
   public genesis__Applications__c objApplication{get;set;}
   public Boolean successSaveForLater{get;set;}
   public Attachment attachDoc
    {
        get {
        if (attachDoc == null)
        attachDoc = new Attachment();
        return attachDoc;
        }
       set;
    }
    public pepUploadFinancialDocController()
    {
        strErrorMesg = '';
        objApplication = new genesis__Applications__c();
        getCookieData();
        fetchApplication();
    }
    global PageReference uploadFile()
    {
       boolean isBankstmtadcExist = false;
       boolean isCreditContractExist = false;
       string adcId;
       string strfileName;
       string strContentType;
       string Strbase64BlobValue;
       string attachmentId;
       String jsonRes;       
       string parentId;
       map<string,genesis__Application_Document_Category__c> mapNameToDocAppObj = new map<string,genesis__Application_Document_Category__c>();
       list<genesis__Application_Document_Category__c> lstAppDocCgryInsert = new list<genesis__Application_Document_Category__c>();
       try
       {
          if(attachDoc != null)
          {
            strfileName = attachDoc.Name;
            strContentType = attachDoc.contentType;
            Strbase64BlobValue =  EncodingUtil.base64Encode(attachDoc.body);
            string strDocCategory = system.label.pepBank_statement;
            system.debug(strContentType);
            list<genesis__Application_Document_Category__c> lstappDocCategory = [select id, Name from genesis__Application_Document_Category__c where genesis__Application__c=:idApplication AND Name =:strDocCategory]; 
            if(lstappDocCategory != null && lstappDocCategory.size()>0)
            {
                if(attachDoc.body.size() <= 5000000) //5MB validation
                {
                    if(strContentType == 'image/jpeg' || strContentType == 'image/jpg' || strContentType == 'application/pdf')
                    {
                        //jsonRes = genesis.TransactionRoomRemoteAction.attachBlob(null,lstappDocCategory[0].id,StrfileName,StrcontentType,Strbase64BlobValue,null);
                        //changed by IJ
                        jsonRes = genesis.TransactionRoomRemoteAction.attachBlob(lstappDocCategory[0].id,idApplication,StrfileName,StrcontentType,Strbase64BlobValue,null);
                         //Same attachment will be saved also under application document category
                     //line added by AMIT KR
                     genesis.TransactionRoomRemoteAction.attachBlob(null,lstappDocCategory[0].id,StrfileName,StrcontentType,Strbase64BlobValue,null);
                        system.debug('@@@test@'+jsonRes);
                         pepUtilityClass.SaveContinueStatus(objApplication,'pepLoanSetupUploadedDocs') ;
                        string redircetPageName= pages_config__c.getinstance('peploansetupuploadeddocs').Page_Label__c;
                        pagereference redirectToUploadedPage = new Pagereference('/'+redircetPageName);
                        return redirectToUploadedPage;
                    }else{
                        strErrorMesg = 'Please select .pdf or .jpg file';
                    }
                }else{
                    strErrorMesg = 'Please select file less than 5MB.';
                }
            }else{
                strErrorMesg = 'Application does not have document category.';
            }
          }
         }
        catch(Exception e)
        {
             strErrorMesg = 'Error uploading file';
             attachDoc = new Attachment();
            return null;
        }
        attachDoc = new Attachment();
        return null;
    }
    
    
     
    public pagereference redirectToNextPage()
    {
        Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
         myCookies = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
         pageReference pagerf;
         string redircetPageName;
         if(objApplication.Is_Secured__c==true)
         {
            pepUtilityClass.SaveContinueStatus(objApplication,'pepAssetPage') ;
            redircetPageName = pages_config__c.getinstance('pepassetpage').Page_Label__c;
         }
         else
         {
             pepUtilityClass.SaveContinueStatus(objApplication,'pepPaymentSetup') ;
             redircetPageName= pages_config__c.getinstance('peppaymentsetup').Page_Label__c;
         }
         pagerf =new Pagereference('/'+redircetPageName);                
         pagerf.setCookies(new Cookie[]{myCookies }); 
         pagerf.setRedirect(true);
         return pagerf;
    }
    
    
    public void getCookieData()
    {
            
            Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
            System.debug('cookieApplicationId **************'+cookieApplicationId);      
              
             if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
            {                           
                   idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
                   objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
            }
    }
    
    public void fetchApplication()
    {
            
            Map<string,string> childobjects = new Map<string,string>();       
            if(objApplication != null && objApplication.Id !=null)
            {
                
               List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
               System.debug('lstApplication  *********'+lstApplication);
                if(lstApplication != null && lstApplication.size() >0)
                {        
                    objApplication = lstApplication[0];
                }
            }
    }
    
    //  This method is used to save the page name of current page in navigation status of application and sent notification(retrieval code)
  //  through SMS and Email to related account of respected application.

    public void saveForLater()
     {
            successSaveForLater=false;
            if(objApplication!=null && objApplication.id!=null)  
             {
                         genesis__Applications__c objApplicationReturn = new  genesis__Applications__c ();
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepUploadFinancialDoc') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                 
                         }      
               }                                  
      
     }

    
     Public Pagereference checkcookie(){
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        if(pr==null)
        Peputilityclass.updatebank();
        return pr;
        }
}
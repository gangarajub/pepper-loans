global class pepLoanSetupUploadedDocsController 
{ 
   public Id IdAttachment{get;set;}
   public  Id idApplication;
   public list<loan__Bank_Account__c> lstBankAccs {get;set;}
   public string strErrorMesg {get;set;}
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
    public pepLoanSetupUploadedDocsController()
    {
        
        lstBankAccs = new list<loan__Bank_Account__c>();
        set<Id> setAccids = new set<Id>();
        objApplication = new genesis__Applications__c();
        strErrorMesg = '';
        getCookieData();
        fetchApplication();
        list<Bank_Statement__c> lstBankstmts = [select id,Application__c,Bank_Account__c from Bank_Statement__c where Application__c=:idApplication];
        for(Bank_Statement__c objBankstmt : lstBankstmts)
        {
            setAccids.add(objBankstmt.Bank_Account__c);
            System.debug('!!!'+setAccids);
        }
        lstBankAccs = [select loan__Bank_Name__c,Bank_Account_Number__c from loan__Bank_Account__c where id IN:setAccids];
        System.debug('@@@'+lstBankAccs);
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
            string strBankCatName = system.label.pepBank_statement;
            list<genesis__Application_Document_Category__c> lstappDocCategory = [select id, Name from genesis__Application_Document_Category__c where genesis__Application__c=:idApplication AND Name =:strBankCatName]; 
            System.debug('lstappDocCategory *****'+lstappDocCategory );
            if(lstappDocCategory != null && lstappDocCategory.size()>0)
            {
               if(attachDoc.body.size() <= 5000000) //5MB validation
                {
                    if(strContentType == 'image/jpeg' || strContentType == 'image/jpg' || strContentType == 'application/pdf')
                    {
                    //changed by AMIT KUMAR in parameters
                     //jsonRes = genesis.TransactionRoomRemoteAction.attachBlob(null,lstappDocCategory[0].id,StrfileName,StrcontentType,Strbase64BlobValue,null);
                     //Corrected by IJ
                     jsonRes = genesis.TransactionRoomRemoteAction.attachBlob(lstappDocCategory[0].id,idApplication,StrfileName,StrcontentType,Strbase64BlobValue,null);
                     //Same attachment will be saved also under application document category
                     //line added by AMIT KR
                     genesis.TransactionRoomRemoteAction.attachBlob(null,lstappDocCategory[0].id,StrfileName,StrcontentType,Strbase64BlobValue,null);
                     system.debug('@@@test@'+jsonRes);                 
                     Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
                     myCookies = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
                     pageReference pagerf; 
                     string redircetPageName= pages_config__c.getinstance('peploansetupuploadeddocs').Page_Label__c;
                     pagerf =new Pagereference('/'+redircetPageName);                    
                     pagerf.setCookies(new Cookie[]{myCookies }); 
                     pagerf.setRedirect(true);
                     return pagerf;
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
    
    public pagereference redirectToBankStmt()
    {
         pepUtilityClass.SaveContinueStatus(objApplication,'pepbankinfodetails') ;
         Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
         myCookies = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
         pageReference pagerf; 
         string redircetPageName= pages_config__c.getinstance('pepbankinfodetails').Page_Label__c;
         pagerf =new Pagereference('/'+redircetPageName);        
         pagerf.setCookies(new Cookie[]{myCookies }); 
         pagerf.setRedirect(true);
         return pagerf;
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
    
    public List<Attachment> getAllAttachments()
    {
        List<Attachment> retAttachments = new List<Attachment>();
        string strBankCatName = system.label.pepBank_statement;
        List<genesis__Application_Document_Category__c> docCategory = [select name,(select name, id from Attachments order by createddate desc) from genesis__Application_Document_Category__c where genesis__Application__c=:idApplication AND Name =:strBankCatName];
        
            for(genesis__Application_Document_Category__c d : docCategory )
            {
                retAttachments.addAll(d.Attachments);
            }
        
        return retAttachments;
    }
    
     Public Pagereference checkcookie(){
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        return pr;
        }
       
     
     
    public void deleteAttachment()
    {
                      
        AttachmentHandler objAttachmentHandler = new AttachmentHandler();
        List<String> lstOfAttachmentId = new List<String>();
        System.debug('strAttachmentId **********'+IdAttachment);
        lstOfAttachmentId.add(IdAttachment);        
        String response = objAttachmentHandler.deleteAttachments(lstOfAttachmentId);      
        
        getAllAttachments();    
    
    }
    
    //  This method is used to save the page name of current page in navigation status of application and sent notification(retrieval code)
  //  through SMS and Email to related account of respected application.

     public void saveForLater()
     {
            successSaveForLater=false;
           if(objApplication!=null && objApplication.id!=null)  
             {
                         genesis__Applications__c objApplicationReturn = new  genesis__Applications__c ();
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepLoanSetupUploadedDocs') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                
                         }     
               }                                  
      
     }
    
}
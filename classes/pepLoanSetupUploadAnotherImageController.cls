public class pepLoanSetupUploadAnotherImageController
 {
    public List<Attachment> lstAttachment{get;set;}
    public Attachment objAttachment{get;set;}
    public Id idApplication;
    public Id idAccount;
    public Id IdAttachment{get;set;}
    public List<genesis__Application_Document_Category__c>  lstDocumentCategory;
    public pepLoanSetupUploadAnotherImageController()
    {
        if(objAttachment == null)
        {
            objAttachment = new Attachment();
        }       
        lstAttachment = new List<Attachment>();
        getCookieData();
        fetchApplication();
        getAllAttachments();
    }
    
    
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');
        System.debug('cookieApplicationId *******'+cookieApplicationId);  
        System.debug('cookieApplicationId **************'+cookieApplicationId);      
             
         if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
               idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        
    }
    
    public void fetchApplication()
    {
         Map<string,string> childobjects = new Map<string,string>();
         List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,idApplication,null,null,childobjects );
         if(lstApplication != null && lstApplication.size() > 0)
         {
             idAccount = lstApplication[0].genesis__Account__c;
         }
    
    }
    
    public void getAllAttachments()
    {
         lstDocumentCategory =[select id,genesis__Application__c, 
                                         Name from genesis__Application_Document_Category__c
                                         where genesis__Application__c=:idApplication  
                                         and Name =:System.label.Jumio_Document_cate];
        if(lstDocumentCategory !=null && lstDocumentCategory.size() > 0)
        {                                                                                                     
            lstAttachment  =[select id,name from Attachment where parentId =:lstDocumentCategory[0].Id order by createddate desc];
        }
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
    
    
    public PageReference upload() 
    {
       
        try
        {
         
        String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepUploadFinancialDoc');                                                                                                                                                     
        String jsonRes = genesis.TransactionRoomRemoteAction.attachBlob(null,lstDocumentCategory[0].Id, objAttachment.name, 
                                                                       objAttachment.contentType, EncodingUtil.base64Encode(objAttachment.body) ,
                                                                       objattachment.id);
                                                                      
        Account objAccount = new Account(id=idAccount);
        objAttachment = null;
        objAccount.Jumio_Status__c ='Uploaded';
        update objAccount;
        Map<String,SObject> relatedObjects = new Map<String,SObject>();
        Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();  
        genesis__Applications__c objApplication = new genesis__Applications__c(Id =idApplication);
        objApplication.Identification_Verification_Status__c = 'Uploaded';
        objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
        objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);      
        getAllAttachments(); 
        string redircetPageName= pages_config__c.getinstance('peploansetupuploadanotherimage').Page_Label__c;
        pageReference p = new Pagereference('/'+redircetPageName);  
        p.setredirect(true);
        return p;      
        
       }  
        
       catch(Exception exp)
       {
        pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('Account',exp)}) ;

       }
        return null;
    }
    
    
    public PageReference continueToNextPage()
    {
        peputilityclass.updatelastsaved(idApplication);
        Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
        objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{objCookie});
        String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepUploadFinancialDoc');
        
        genesis__Applications__c app = new genesis__Applications__c(id=idApplication,pepNavigation_Status__c=strNavigationStatusPageName);
        update app;
        string redircetPageName= pages_config__c.getinstance('pepuploadfinancialdoc').Page_Label__c;
        pageReference objNextPage =new Pagereference('/'+redircetPageName);     
        objNextPage.setCookies(new Cookie[]{objCookie}); 
        return objNextPage;  
    
    }
    
    Public Pagereference checkcookie()
    {
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        return pr;
    }
    
}
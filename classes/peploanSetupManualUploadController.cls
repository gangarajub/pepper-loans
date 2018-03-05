public class peploanSetupManualUploadController 
{
    public Id idApplication;
    public Id idAccount;   
    public Attachment objAttachment{get;set;}
    public peploanSetupManualUploadController ()
    {
        objAttachment = new Attachment();        
        getCookieData();
        fetchApplication();
    }

    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');
        
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
    //This method uploads Attachment to Account and updates the jumio status
    public ApexPages.Pagereference upload()
    {
        String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('peploansetupuploadanotherimage');
        List<genesis__Application_Document_Category__c>  lstDocumentCategory =[select id,genesis__Application__c, 
                                                                                         Name from genesis__Application_Document_Category__c
                                                                                                             where genesis__Application__c=:idApplication  
                                                                                                             and Name =:System.label.Jumio_Document_cate];
                                                                                   
       try{                                                                         
           String jsonRes = genesis.TransactionRoomRemoteAction.attachBlob(null,lstDocumentCategory[0].Id, objAttachment.name, 
                                                                       objAttachment.contentType, EncodingUtil.base64Encode(objAttachment.body) ,
                                                                       objattachment.id);
                                                                       
        Account objAccount = new Account(id=idAccount);
        objAccount.Jumio_Status__c ='Uploaded';
        update objAccount;
        Map<String,SObject> relatedObjects = new Map<String,SObject>();
        Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();  
        genesis__Applications__c objApplication = new genesis__Applications__c(Id =idApplication);
         objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
        objApplication.Identification_Verification_Status__c = 'Uploaded';
        objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);      
        objAttachment = null;
       }  
        
       catch(Exception exp)
       {
       pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('Account',exp)}) ;
       }
       
        
        Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
        objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{objCookie});
        string redircetPageName= pages_config__c.getinstance('peploansetupuploadanotherimage').Page_Label__c;
        pageReference objNextPage = new Pagereference('/'+redircetPageName);
        objNextPage.setCookies(new Cookie[]{objCookie}); 
        return objNextPage;  
    }
    
    
    Public Pagereference checkcookie()
    {
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        return pr;
    }

}
public class pepJumioSuccessController
{
    Public String retUrlPage {get;set;}
    public string siteURL{get;set;}
    public string siteJumioUrl{get;set;}
    Id idApplication;
    Id idAccount;
    String jumioReference;
    public pepJumioSuccessController()
    {
        if(apexpages.currentpage().getparameters().get('jumioIdScanReference') != null &&
             apexpages.currentpage().getparameters().get('jumioIdScanReference') !='')
        {
            jumioReference = apexpages.currentpage().getparameters().get('jumioIdScanReference');
        }
        
        if(jumioReference != null)
        {
            List<Account> lstAccount =[select id ,Current_Application_Id__c from Account where Tracking_Id__c =:jumioReference];
            if(lstAccount != null && lstAccount.size() > 0)
            {
               idAccount = lstAccount[0].id;
               idApplication = lstAccount[0].Current_Application_Id__c;
               
            }
        }
        
        siteURL = System.label.pepSiteUrl;
        siteJumioUrl = System.label.Site_Url;
        string redirectPageName= pages_config__c.getinstance('pepuploadfinancialdoc').Page_Label__c;
        retUrlPage  =redirectPageName;
       
    
    }
  
    public void Redirect()
    {  
        try{
        if(idAccount != null)
        {
            Account objAccount = new Account(id= idAccount);
            objAccount.jumio_status__c = 'Uploaded';
            update objAccount;
        }   
        
        String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepUploadFinancialDoc');
        if(idApplication != null)
        {
            Map<String,SObject> relatedObjects = new Map<String,SObject>();
            Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>(); 
            genesis__Applications__c  objApplication = new genesis__Applications__c (id =idApplication );
            objApplication.Identification_Verification_Status__c = 'Uploaded'; 
            objApplication.pepNavigation_Status__c = strNavigationStatusPageName;                 
            objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
            Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
            objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.encryptdata(string.valueof(objApplication.Id)),null,-1,false); 
            ApexPages.currentPage().setCookies(new Cookie[]{objCookie});
            
        }
        
        
        
        
    }
    catch(Exception ex){
    String str='';
    str=ex.getmessage();
    PeputilityClass.CreateExceptionRecord(str,'Jumio Success');
    throw ex;//Allowing the normal flow.
    }
}
}
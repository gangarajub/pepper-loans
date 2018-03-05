public class pepJumioFailureController 
{
    Public String retUrlPage {get;set;}
    public string siteURL{get;set;}
    String jumioReference;
    Id idApplication;
    public void redirect()
    {
        try{
        siteURL = System.label.pepSiteUrl;
//        retUrlPage  ='/peploanSetupManualUpload';
        retUrlPage  ='peploanSetupManualUpload';
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
               
               idApplication = lstAccount[0].Current_Application_Id__c;
               
            }
        }
        if(idApplication != null)
        {
            Map<String,SObject> relatedObjects = new Map<String,SObject>();
            Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>(); 
            genesis__Applications__c  objApplication = new genesis__Applications__c (id =idApplication);
            objApplication.Jumio_Status__c = 'Failure';                   
            objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
            Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
            objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{objCookie});
            string redircetPageName= pages_config__c.getinstance('peploansetupmanualupload').Page_Label__c;     
            pageReference objNextPage = new Pagereference('/'+redircetPageName);
            objNextPage.setCookies(new Cookie[]{objCookie}); 
            objNextPage.setRedirect(true);
           // return objNextPage;
        }
        
       // return null;
    
    }
    Catch(Exception ex){
    String str='';
    str=ex.getmessage();
    Peputilityclass.createExceptionrecord(str,'Jumio failure');
    throw ex;//Not interupting the normal flow.
    }
  }
}
// ---------------------------------------------------------------------------------------------------------
// This class is used to create the login functionality for users. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      11th May 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
public class PepLoginController
{
 
      public String userName{get;set;}
      public String password{get;set;}
      public boolean ShowMsg{get;set;}
      public List<pepCmsQuestion__c> lstQuestions{get;set;}
      public String PageName{get;set;}//Added by KG
      public String Page_Label{get;set;}//Added by KG
           
      public PepLoginController()
      {
            pageName=ApexPages.currentPage().getUrl();
            pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
            Page_Label=pages_config__c.getValues(pageName.toLowerCase()).Page_Label__c;//Added by KG
            userName='';
            password = '';
            ShowMsg = false;
            lstQuestions = new List<pepCmsQuestion__c>();
            loadCmsData();
      }

// This method is used to load CMS data.

         public void loadCmsData()
         {
            lstQuestions = [select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c
                            from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='Login Screen' and pepSection__r.pepSectionUniqueName__c='SectionThree(LS)' and pepType__c='Text' order by pepSequence__c];
         
         }  

// This method is used to logged in to user.
 
      public pageReference loginUser()
       {
            
            SiteLoginController objSiteLogin=new SiteLoginController(); // site standard method for login
           
            objSiteLogin.username=userName;
            objSiteLogin.password=password;
            string redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;
            objSiteLogin.retURL='/'+redircetPageName;
            pagereference pr = objSiteLogin.login();
            System.debug('==========='+pr);
            if(pr==null){
                         ShowMsg = true;
            }
            return pr;
       }
 
 // This method is used to navigate forgot password page.
 
     public pageReference navigateToForgot()
     {
         string redircetPageName= pages_config__c.getinstance('pepforgotpassword').Page_Label__c;
         Pagereference pr = new Pagereference('/'+redircetPageName);
         return pr  ;
     }
     
  // This method is used to navigate forgot userId page.
     
     public pageReference navigateToForgotUserId()
     {
         string redircetPageName= pages_config__c.getinstance('pepforgotusername').Page_Label__c;
         Pagereference pr = new Pagereference('/'+redircetPageName);
         return pr  ;
     }  
     
      Public Static Pagereference checkCookieAndRedirect(){
    if(ApexPages.currentPage().getcookies().get('ApplicationId') != null){
    
    if(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != null && ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != '')
    {
    //genesis__Applications__c ap=[select id,genesis__Account__c,PepDocusignenvelopeId__c,RedirectToContract__c from genesis__Applications__c where id=: pepEncryptDecryptData.DecryptData(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue()) limit 1];
      genesis__Applications__c ap=[select id,genesis__Account__c,PepDocusignenvelopeId__c,RedirectToContract__c from genesis__Applications__c where id=:pepEncryptDecryptData.DecryptData(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue()) limit 1];
      
        if(ap.RedirectToContract__c)
        {
        ap.RedirectToContract__c=false;
        update ap;
              //string redircetPageName= pages_config__c.getinstance('pepcontract').Page_Label__c;
              Pagereference pg=new Pagereference('/'+Label.loginTOContract);
              pg.setRedirect(true);
              return pg;
        }
   
    }
    
    } 
    return null;
    }
 
}
public class pepSessionController
{
     String application_ID{get;set;}
     public pepSessionController()
     {
     }
      public pagereference redirect()
        {
                try{
                List<genesis__Applications__c> lstApp = new List<genesis__Applications__c>();
                Pagereference pr;
                Id ID_Application;
                List<Attachment> attachment = new List<Attachment>();
                pr=PeputilityClass.checkCookieAndRedirect();
                
                if(pr==null){
                         Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
                        if(cookieApplicationId!=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')
                        {            
                            ID_Application = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
                            lstApp=[Select id,DDP_Exception__c,DDP_Processed__c,RedirectToContract__c,PepDocusignenvelopeId__c,pepNavigation_Status__c  from genesis__Applications__c where id=:ID_Application ];
                            if(lstApp[0].PepDocusignenvelopeId__c != null && lstApp[0].PepDocusignenvelopeId__c != ''){
                             
                             String navigatingStep=lstApp[0].pepNavigation_Status__c;
                             if(navigatingStep!=null && navigatingStep!= '' && pepUtilityClass.navigateToPage(navigatingStep) != null)
                            {
                                lstApp[0].RedirectToContract__c=false;
                                lstApp[0].DDP_Exception__c=false;
                                                               update lstApp;
                                if(pepUtilityClass.navigateToPage(navigatingStep).toLowerCase()=='pepsession')
                                return new Pagereference('/'+pages_config__c.getinstance('pepcontract').Page_Label__c);
                                return new PageReference('/'+pages_config__c.getinstance(pepUtilityClass.navigateToPage(navigatingStep).toLowerCase()).Page_Label__c);
                            } 
                            else{
                             PeputilityClass.CreateExceptionRecord('Navigation custom setting not updated or Navigation status on Application is Blank.','Drawloop invoke Error.');
                             String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
                             return new Pagereference('/'+redircetPageName);
                             }
                        }
                            else{
                                 lstApp[0].RedirectToContract__c=false;
                                 lstApp[0].DDP_Exception__c=false;
                                 lstApp[0].DDP_Processed__c=false;
                                update lstApp;
                                SiteLoginController objSiteLogin=new SiteLoginController();
                                Drawloop_User_Setting__c DDP_USER=Drawloop_User_Setting__c.getValues('DDP_User');
                                objSiteLogin.username=DDP_USER.username__c;
                                objSiteLogin.password=DDP_USER.password__c;
                                
                                objSiteLogin.retURL='/'+pages_config__c.getinstance('pepcontract').Page_Label__c;
                                
                                Pagereference temp=objSiteLogin.login();
                                if(temp==null){
                                    PeputilityClass.CreateExceptionRecord('User Login returns null','Drawloop Login');
                                    String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
                                    return new Pagereference('/'+redircetPageName);
                                }
                                else{
                                    return temp;
                                }
                            }
                       }
                                    PeputilityClass.CreateExceptionRecord('Cookie doesn\'t returns value','Drawloop Login');
                                    String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
                                    return new Pagereference('/'+redircetPageName);   
              }
              else{
               return pr;
              }
       }
       //Throwing the exception to just allow the user to go to the Pep Generic  Exception Page.
       Catch(Exception ex){
       String str='';
       str=ex.getmessage();
       PeputilityClass.CreateExceptionRecord(str,'Drawloop Invoke');
       String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
       return new Pagereference('/'+redircetPageName); 
       }
}    

}
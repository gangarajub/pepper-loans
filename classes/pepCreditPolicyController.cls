// ---------------------------------------------------------------------------------------------------------
// This class is used to show the credit policy to users.
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      5th Apr 2016           Vivek kumar         
// ---------------------------------------------------------------------------------------------------------

public class pepCreditPolicyController
{
    public genesis__Applications__c objApplication;
    public transient Cookie cookieApplicationId;
    public Boolean successSaveForLater{get;set;}
  
   public pepCreditPolicyController()
   {
        objApplication = new genesis__Applications__c ();
        getCookieData();
        fetchApplication();
   } 
  
  // This method is used to get cookies from previous page.
    
     public void getCookieData()
    {
          cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
          if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
          {                           
               objApplication.Id =pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
          }
           System.debug('CookieValueIs'+cookieApplicationId);
    }
    
      Public Pagereference checkcookie(){
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        return pr;
        }
  
   
   public void fetchApplication()
    {
            
            Map<string,string> childobjects = new Map<string,string>();       
            if(objApplication != null && objApplication.Id !=null)
            {
                
               List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
               System.debug('lstApplication  *********'+lstApplication);
                if(lstApplication != null && !lstApplication.isEmpty())
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
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepLoanSetupCreditPolicy') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                  
                         }     
               }                                  
      
     }
  
 // This methood is used to update agreement checkbox on application and to redirect on next page.
    
  public pagereference saveAndRedirect()
   {
        
       if(objApplication.Id !=null)
        {
                String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepContract');
                objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                objApplication.AgreementCheck__c = true;
                objApplication.Credit_guide_acknowledgement__c = true;
                objApplication.Credit_guide_loan_agreement__c = true;
                objApplication.Credit_guide_acknowledgement_ts__c = dateTime.Now();
                Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
                objApplication = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
        }
       String redircetPageName= pages_config__c.getinstance('pepsession').Page_Label__c;
       pageReference objNextPage = new PageReference('/'+redircetPageName);
     //  pageReference objNextPage = new pagereference('/pepSession');
       objNextPage.setCookies(new Cookie[]{cookieApplicationId}); 
       objNextPage.setRedirect(true);
       return objNextPage;
    }
}
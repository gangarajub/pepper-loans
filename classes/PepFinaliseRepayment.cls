// ---------------------------------------------------------------------------------------------------------
// This class is used to calculate the repayment amount on the basis of frequency(weekly,fortnightly and monthly). 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      5th Apr 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------

public class PepFinaliseRepayment
{
public List<pepCmsQuestion__c> lstQuestion{get;set;} 
public List<wrappperQusetion> wrapperList{get;set;}
public decimal calculatedRepayment{get;set;}
public String selectedFrequency{get;set;}
public genesis__Applications__c objApplication{get;set;}
public transient Cookie cookieApplicationId; 
public String inputDate{get;set;}
public Boolean successSaveForLater{get;set;}

// This is used to initialize the variable and to assign values to different variables on page load.

public PepFinaliseRepayment()
 {
         objApplication = new genesis__Applications__c();
     //    objApplication.id = 'a5UN0000000959v';
         lstQuestion = new List<pepCmsQuestion__c>();
         wrapperList = new List<wrappperQusetion>();
         calculatedRepayment = 0;
         selectedFrequency = '';
         getCookieData();
         loadCMSContent();
         fetchApplication();
         if(objApplication.id !=null)
          {
            
             if(objApplication.Automated_Payment_Start_Date__c !=null)
             inputDate = (objApplication.Automated_Payment_Start_Date__c).format();
             if(objApplication.Debit_Amount__c !=null && objApplication.Debit_Amount__c !=0)
             calculatedRepayment = (objApplication.Debit_Amount__c).setScale(2) ;
             if(objApplication.Debit_Frequency__c !='' && objApplication.Debit_Frequency__c !=null)
                selectedFrequency = (objApplication.Debit_Frequency__c).tolowercase();
             if(selectedFrequency == 'bi-weekly')
                selectedFrequency = 'fortnightly';
             system.debug('freIS'+selectedFrequency);
         }    
 } 

// This method is to fetch application on the basis of application id.

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
 
 // Thid method id used to load data from CMS.
        
 public void loadCMSContent()
  {  
      for(pepCmsQuestion__c objQuestion:[select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c,
      (select id,pepActualValue__c,pepCmsQuestion__c,pepDisplayText__c,pepSequence__c from pepCMSAnswer__r order by pepSequence__c limit 3 ) from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='Finalise Repayment' order by pepSequence__c])
      {  
          wrapperList.add(new wrappperQusetion(objQuestion));
      }
  }
 
 // This wrapper class is used to create container of frequncy option list(weekly,fortnightly and monthly) and other variables which is used in page.
 
 public class wrappperQusetion
 {
       public pepCmsQuestion__c objCmsQuestion {get; set;} //main question      
       public list<selectOption> lstOptions {get; set;}
 
    public wrappperQusetion(pepCmsQuestion__c objQuestion)
    {
       objCmsQuestion = objQuestion;
       lstOptions = new list<selectOption>();
      if(objQuestion != null && objQuestion.pepCmsAnswer__r!=null && objQuestion.pepCmsAnswer__r.size()>0)
       {
           for(pepCmsAnswer__c objAnswer : objQuestion.pepCmsAnswer__r)
                {
                   if(objAnswer.pepDisplayText__c !='' && objAnswer.pepDisplayText__c !=null)
                    {
                       lstOptions.add(new selectOption(objAnswer.pepDisplayText__c, objAnswer.pepDisplayText__c));
                    }
               }
      }
   }
 }

// This method is used to calculate the repayment amount on the basis of frquency.

public void calculateRepaymentValue()
 {
        system.debug('freqIs'+selectedFrequency);
        if(objApplication.genesis__Payment_Amount__c !=null && objApplication.genesis__Payment_Amount__c !=0)
        {
      
                       if(selectedFrequency=='weekly')
                       {
                           calculatedRepayment = (objApplication.genesis__Payment_Amount__c)/4;
                           objApplication.Debit_Frequency__c = 'WEEKLY';
                           objApplication.Automated_Payment_Start_Date__c = date.parse(inputDate);
                       }
                      else if(selectedFrequency=='fortnightly')
                      {
                          calculatedRepayment =(objApplication.genesis__Payment_Amount__c)/2;
                          objApplication.Debit_Frequency__c = 'BI-WEEKLY';
                          objApplication.Automated_Payment_Start_Date__c = date.parse(inputDate);
                      }
                      else  if(selectedFrequency=='monthly')
                      {
                          calculatedRepayment = (objApplication.genesis__Payment_Amount__c);
                          objApplication.Debit_Frequency__c = 'MONTHLY';
                          objApplication.Automated_Payment_Start_Date__c = date.parse(inputDate);
                      }
                    
                      else
                      {
                         calculatedRepayment = (objApplication.genesis__Payment_Amount__c);
                      }
                          calculatedRepayment  = calculatedRepayment.setScale(2);
        }
 } 

// This method is used to get cookies from previous page.
 
   public void getCookieData()
    {
             cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
             
             if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
            {                           
               objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
            }
             System.debug('CookieValueIs'+cookieApplicationId);
    }
  
    Public Pagereference checkcookie(){
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        return pr;
        }
    
    //  This method is used to save the page name of current page in navigation status of application and sent notification(retrieval code)
  //  through SMS and Email to related account of respected application.

      public void saveForLater()
     {
            successSaveForLater=false;
           if(objApplication!=null && objApplication.id!=null)  
             {
                         genesis__Applications__c objApplicationReturn = new  genesis__Applications__c ();
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepFinaliseRepayment') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                  
                         }     
               }                                  
      
     }

         
 // This method is used to update frequency and debit amount of application and to redirect on next page.
    
  public pagereference redirectToNextPage()
   {
            if(objApplication.Id !=null)
            {
                String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepLoanSetupCreditPolicy');
                objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                objApplication.Debit_Amount__c = calculatedRepayment;
                Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
                objApplication = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
            }
            String redircetPageName= pages_config__c.getinstance('peploansetupcreditpolicy').Page_Label__c;
            pageReference objNextPage = new PageReference('/'+redircetPageName);
           // pageReference objNextPage = Page.pepLoanSetupCreditPolicy;
            objNextPage.setCookies(new Cookie[]{cookieApplicationId}); 
            objNextPage.setRedirect(true);
            return objNextPage;
    }        
 
}
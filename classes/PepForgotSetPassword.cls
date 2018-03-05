// ---------------------------------------------------------------------------------------------------------
// This class is  used to set password,link sent to email id,after click on forgot password button. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      12th May 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
public class PepForgotSetPassword
{
   public String password{get;set;}
   public String confirmPassword{get;set;}  
   public boolean ShowMsg{get;set;}
   public List<pepCmsQuestion__c> lstQuestions{get;set;}
   public PepForgotSetPassword()
   {
          ShowMsg = false;
          loadCmsData();
   }
 
 // This method is used to load CMS data.
   
  public void loadCmsData()
  {
            lstQuestions = [select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c
                            from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='Forgot Set Password' and pepSection__r.pepSectionUniqueName__c='SectionFour(FSP)' and pepType__c='Text' order by pepSequence__c];
  }  
  
  // This method is used to set new password for user.
  
  public pageReference resetPassword()
   {
      pagereference pr ;
       try
       {
              
              pr = site.changePassword(password,confirmPassword,null); // site standard method to reset password
               if(pr==null){
                        ShowMsg = true;
                }
                else
                {
                   ShowMsg = false;
                   string redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;
                   pr = new Pagereference('/'+redircetPageName).setredirect(True);
                  
                }
                 system.debug('prIssss'+pr);
                  
        }
        
       catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage())); 
        }  
        return pr;
   }
}
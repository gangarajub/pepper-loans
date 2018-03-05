// ---------------------------------------------------------------------------------------------------------
// This class is  used to  sent link to email id to reset password,after click on forgot password button. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      12th May 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
public class PepForgotPassword
{
       public string userId{get;set;}
       public boolean ShowMsg{get;set;}
       public boolean password{get;set;}
       public List<pepCmsQuestion__c> lstQuestions{get;set;}
       list<user> objuserList;
       
       public PepForgotPassword()
       {
           userId = '';
           ShowMsg = false;
           objuserList = new  list<user> ();
           loadCmsData();
       }
  
  // This method is used to load CMS data.
   
      public void loadCmsData()
      {
        lstQuestions = [select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c
                        from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='Forgot Password' and pepSection__r.pepSectionUniqueName__c='SectionFour(FP)' and pepType__c='Text' order by pepSequence__c];
     
      }  
      
 // This method is used to send link to email id of user.
   
   public void sendPassword()
    {
              ShowMsg = false;
              
              if(string.isNotBlank(userId))
              {
                          objuserList = [select id from user where userName=:userId and (profile.name = 'Drawloop User Profile' or profile.name ='Custom Customer Community Login user') limit 1];                          
                          if(objuserList!=null && !objuserList.isEmpty())
                          {
                                  password =Site.forgotPassword(userId); // site standard method to sent link in registered email id.
                                  if(password)
                                  {
                                     ShowMsg = false;
                                     userId ='';
                                  }   
                                  else
                                  {
                                     ShowMsg = true;
                                  }
                          } 
                          else
                          {
                                 ShowMsg = true; 
                          }
              }  
              
              else
              {
                       ShowMsg = true;
              }      
     }
}
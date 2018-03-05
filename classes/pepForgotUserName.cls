public class pepForgotUserName
{
public String email{get;set;}
public String dob{get;set;}
public boolean userNameExist{get;set;}
public List<pepCmsQuestion__c> lstQuestions{get;set;}
public list<account>acclist;

    public pepForgotUserName()
    {
       userNameExist =true;
       lstQuestions = new List<pepCmsQuestion__c>();
       loadCmsData();
    }
    
    // This method is used to load CMS data.

         public void loadCmsData()
         {
            lstQuestions = [select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c
                            from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='Forgot UserID' and pepSection__r.pepSectionUniqueName__c='Forgot userId section 3' order by pepSequence__c limit 2];
         
         }  
         
  public pageReference checkUserName()
  { 
         
           userNameExist =true;
           if(string.isNotBlank(email) && string.isNotBlank(dob))
           {
                 try
                 {
                      date inputDob = date.parse(dob);
                      acclist = new list<account>();
                      acclist =[select id,name from account where personEmail=:email and PersonBirthdate=:inputDob and recordtype.developername='PersonAccount'];
                     System.debug(email +'  '+ inputDob);
                     if(acclist.size()!=1)
                      {
                          userNameExist = true;
                          return null;
                      }
                      
                    else if(string.isNotBlank(acclist[0].id))
                     {   
                        user objUser=[select id,userName,name,email from User where  isActive =true and contact.accountid=:acclist[0].id];
                        UserLogin objUserLogin;
                        if(objUser.id!=null)
                            objUserLogin= [Select Id, UserId, IsFrozen, IsPasswordLocked From UserLogin where UserId=:objUser.id and IsFrozen=false];
                        if(objUserLogin.id!=null)    
                        {
                        
                       
                                pepPepperCustomSetting__c objPepper= pepPepperCustomSetting__c.getOrgDefaults();
                                string callNumber = objPepper.pepCall__c;
                                EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where name ='Send Username email'];
                                String subject = emailTemplate.Subject;
                                String htmlBody = emailTemplate.HtmlValue;
                                htmlBody = htmlBody.replace('{!User.Name}', objUser.Name);
                                htmlBody = htmlBody.replace('{!User.Username}', objUser.userName);
                                htmlBody = htmlBody.replace('{!$Setup.pepPepperCustomSetting__c.pepCall__c}', callNumber);
                                String plainBody = emailTemplate.Body;
                                plainBody = plainBody.replace('{!User.Name}', objUser.Name);
                                plainBody = plainBody.replace('{!User.Username}', objUser.userName);
                                plainBody = plainBody.replace('{!$Setup.pepPepperCustomSetting__c.pepCall__c}', callNumber);
 
                                 list<String> lstEmailAddress = new list<String> ();
                                 Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage(); 
                                        lstEmailAddress.add(objUser.Email);
                                        objEmail.setToAddresses(lstEmailAddress); 
                                        objEmail.setTargetObjectId(objUser.id);
                                        objEmail.setSaveAsActivity(false);
                                        objEmail.setSubject(subject);
                                        objEmail.setHtmlBody(htmlBody);
                                        objEmail.setPlainTextBody(plainBody);
         
                                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {objEmail});
                                                  // objUser.Pep_Send_Username__c = true;
                                                  // update objUser;
                                                   system.debug('userDetailsIs'+objUser.userName);
                                                   userNameExist = false;
                      }
                 }
            }
                 catch (exception e)
                 {
                    userNameExist = true;
                 }
           
           }
        return null;
  }

}
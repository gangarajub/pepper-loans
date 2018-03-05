// ---------------------------------------------------------------------------------------------------------
// This class is used to show the loan details to users. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      6th Apr 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------

public class pepCongratulations
{
    public String Section1{get;set;}
    public String Section2{get;set;}
    public String Section4{get;set;}
    public genesis__Applications__c objApplication;
    public account objAccount;
    public transient Cookie cookieApplicationId;
    public Boolean successSaveForLater{get;set;}
   
// This method is used to fetch values from Application object on the basis of fields coming from CMS.
   
 public pepCongratulations()
 {
  
        
        objApplication = new genesis__Applications__c ();
        
        objAccount = new Account();
        getCookieData();
     //   objApplication.id = 'a5UN0000000959v';
        fetchApplication();
        fetchAccount();
        
        if(objApplication.Id !=null)
           {
              
                 List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name,pepSequence__c,
                                                                    pepSectionUniqueName__c, pepType__c,pepSectionBodyRich__c, 
                                                                    pepSectionStory__c ,pepPage__r.pepPageName__c 
                                                                    from pepCmsSection__c  where pepPage__r.pepPageName__c='Congratulations' order by pepSequence__c ASC];
                                                              
                 Section1 = lstSections[0].pepSectionBodyRich__c; 
                 Section2 = lstSections[2].pepSectionBodyRich__c; 
                 Section4 = lstSections[3].pepSectionBodyRich__c;
                
         // This  loop is used to fetch field values dynamically from Application object.     
              
                  for(Schema.sobjectfield str:Schema.SObjectType.genesis__Applications__c.fields.getMap().values())
                  {
                     
                         string tempString = '{!genesis__Applications__c.'+str;
                         tempString+='}';
                         system.debug('tempStringis '+tempString);
                       
                        if(Section2.contains(tempString) || Section4.contains(tempString) || Section1.contains(tempString))
                         {
                             
                                 System.debug('stringIs'+tempString);
                               if(string.isnotblank(String.valueof(objApplication.get(str))))
                               {
                                          String replaceValue = '';
                                          Schema.DisplayType fielddataType = str.getDescribe().getType();
                                          if(String.valueof(fielddataType) =='DOUBLE')
                                           {
                                                Decimal comingValue = double.valueof(objApplication.get(str));
                                                replaceValue = (comingValue.setScale(2)).format();
                                                System.debug(replaceValue);
                                           }
                                       
                                       
                                       else{         
                                               replaceValue=String.valueof(objApplication.get(str));
                                           }
                                             
                                             Section2=Section2.replace(tempString,replaceValue);
                                             Section4=Section4.replace(tempString,replaceValue);
                                             Section1=Section1.replace(tempString,replaceValue);
                                             System.debug('sectionValue2Is'+Section2);
                                             System.debug('sectionValue4Is'+Section4);
                               }           
                          }
                      }
        
     // This method is used to fetch fields values from Account object.                
                  
                  if(objAccount !=null && objAccount.id !=null)
                  {       
                    for(Schema.sobjectfield str:Schema.SObjectType.Account.fields.getMap().values())
                      {
                         
                             string tempString = '{!genesis__Applications__c.genesis__Account__r.'+str;
                             tempString+='}';
                             system.debug('tempStringAccountis'+tempString);
                           
                            if(Section2.contains(tempString) || Section4.contains(tempString) || Section1.contains(tempString))
                             {
                                 
                                 System.debug('stringIs'+tempString);
                                 if(string.isnotblank(String.valueof(objAccount.get(str))))
                                 {
                                          String replaceValue = '';
                                          Schema.DisplayType fielddataType = str.getDescribe().getType();
                                          if(String.valueof(fielddataType) =='DOUBLE')
                                           {
                                                Decimal comingValue = double.valueof(objAccount.get(str));
                                                replaceValue = (comingValue.setScale(2)).format();
                                                System.debug(replaceValue);
                                           }
                                       
                                       
                                       else{         
                                               replaceValue=String.valueof(objAccount.get(str));
                                           }
                                    
                                     Section1=Section1.replace(tempString,replaceValue);
                                     Section2=Section2.replace(tempString,replaceValue);
                                     Section4=Section4.replace(tempString,replaceValue);
                                     System.debug('sectionValue1Is'+Section1);
                                     System.debug('sectionValue2Is'+Section2);
                                     System.debug('sectionValue4Is'+Section4);
                                 }
                             }
                      }  
                  }               
                                                           
          }                                                   
     } 
 
// This method is used to get cookies from previous page.
 
   public void getCookieData()
    {
             cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
             if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
            {                           
                   objApplication.Id =  pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
                   System.debug('CookieValueIs'+cookieApplicationId);
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
                if(lstApplication != null && lstApplication.size() >0)
                {        
                    objApplication = lstApplication[0];
                }
            }
    }
  
 // This method is used to fetch the fields values of account object 
    
    private void fetchAccount()
    {
            if(objApplication != null && objApplication.Id !=null && objApplication.genesis__Account__c !=null)
            {
                
                    String theQuery = 'SELECT ';
                    for(Schema.sobjectfield str:Schema.SObjectType.Account.fields.getMap().values())
                    {
                       theQuery += str+ ',';
                    }
                    // trim last comma
                    theQuery = theQuery.subString(0, theQuery.length() - 1);
                    theQuery += ' FROM Account WHERE Id = \''+ objApplication.genesis__Account__c +'\'';
                    system.debug('accountListis'+theQuery);
                    List<Account> accountList = Database.query(theQuery);
                    if(accountList != null && accountList.size()>0)
                      objAccount = accountList[0];
            }  
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
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepCongratulations') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                               /*   system.debug('aplicationIs'+objApplicationReturn);
                                   Account  objAccount = [Select id,PersonEmail,PersonContactId,Phone,PersonMobilePhone from Account where id=: objApplication.genesis__Account__c limit 1];
                
                                    if(objAccount.PersonEmail !=null && objAccount.PersonEmail !='')
                                    { 
                                         String subject='Retrieval Code';
                                         String retrievalCode= objApplication.Ret_Code__c;
                                         String body='';
                                        // Sets the paramaters of the email
                                        list<RetrievalCodeTemplateId__c> tempId=RetrievalCodeTemplateId__c.getall().values();
                                        Id TemplateId = Id.valueOf(tempId[0].Name);
                                        EmailTemplate objTemplate = [Select id,HtmlValue, body from EmailTemplate where id=: TemplateId ];
                                        String htmlBody = objTemplate.HtmlValue;
                                        body=htmlBody.replace('{!genesis__Applications__c.Ret_Code__c}',retrievalCode);
                                        pepUtilNotification.SendEmailNotification(objAccount.PersonEmail,body,subject);
                                   }
            
                                    if(objAccount.PersonMobilePhone !=null && objAccount.PersonMobilePhone !='')
                                        {
                                                try{
                                                
                                                            system.debug('PhoneForNoIs'+objAccount.PersonMobilePhone );
                                                          //  isError=false;
                                                            String retrievalCode= objApplication.Ret_Code__c;
                                                            system.debug('retrievalCode--'+retrievalCode);
                                                            String receipentName = objAccount.PersonMobilePhone;
                                                            String receipentNo = objAccount.PersonMobilePhone ;
                                                            String message = ('Your Pepper verification code is:'+retrievalCode);
                                                            pepUtilNotification.SendSMSNotification(receipentName,receipentNo,message);
                                                   }
                                                catch(Exception ex)
                                                {
                                                  //  isError=true;
                                                }
                                        } */
                              }     
               }                                  
      
     }


// This method id used to redirect on next page.

  public pagereference redirectToNextPage()
   {
         /*   if(objApplication.OBS_Contract_Check__c==true) 
            {
               AddParty p = new AddParty();
               clcommon__Party__c   party = p.add(objApplication.pepP2__c,objApplication.id);
            } */
            pepUtilityClass.SaveContinueStatus(objApplication,'peploanSetupverifyid') ;
            cookieApplicationId = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
            string redircetPageName= pages_config__c.getinstance('peploansetupverifyid').Page_Label__c;
            pageReference objNextPage =new Pagereference('/'+redircetPageName);
            objNextPage.setCookies(new Cookie[]{cookieApplicationId}); 
            objNextPage.setRedirect(true);
            return objNextPage;
    }        
  
}
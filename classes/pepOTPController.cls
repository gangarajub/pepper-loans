public class pepOTPController {
public Account objAccount{get;set;}
public list<String> lstEmailAddress;
public genesis__Applications__c objApplication{get;set;}
public String password{get;set;}
public List<sobject> lstSobject{get;set;}
public string PIN;
public string applicationId{get;set;}
public string errormessage{get;set;}
public boolean boolEnable{get;set;}
public String PageName{get;set;}//Added by KG
public String Page_Label{get;set;}//Added by KG
    public pepOTPController()
    {
        pageName=ApexPages.currentPage().getUrl();
        pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        Page_Label=pages_config__c.getValues(pageName.toLowerCase()).Page_Label__c;//Added by KG
        objAccount = new Account();
        lstEmailAddress = new list<String> ();
        objApplication = new genesis__Applications__c ();
        lstSobject = new List<sobject>();
        getCookieData();
       // fetchApplication();
        boolEnable = true;
    }
    
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');   
        
         if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {
            system.debug('cookie values:: '+cookieApplicationId.getValue());
            //applicationId = 'a5UN000000097C5';
            applicationId = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
            String[] lstTypes = new String[]{'genesis__Applications__c','Residential_Address__c','genesis__Employment_Information__c','Account'};
            String FieldSetName='pepGeneral';
           //lstApplication=pepUtilityClass.fetchApplicationAndChild(lstTypes,FieldSetName,null,idApplication,null);                    
           list<genesis__Applications__c> lstApplication=pepUtilityClass.fetchApplicationAndChild(lstTypes,FieldSetName,null,applicationId,null);
           if(lstApplication!=null && lstApplication.size()>0)
           {
               objApplication = lstApplication[0];
               applicationId = lstApplication[0].Id;
           }
           System.debug('varunthis'+objApplication); 
           
            
            
        }
    }
    
    public void fetchApplication()
    {
        //hardcode application Id
        System.debug('method called'+ '--then show application id:'+objApplication.Id);
        Map<string,string> childobjects = new Map<string,string>();       
        String[] lstTypes = new String[]{};
 
        List<genesis__Applications__c>  lstApplication = pepUtilityClass.fetchApplicationAndChild(lstTypes ,'ExpenseFieldSet',null,objApplication.Id,null);
        System.debug('lstApplication ******'+lstApplication);
        if(lstApplication != null && lstApplication.size() >0)
        {        
            objApplication = lstApplication[0];
        }
        System.debug(objApplication.Ret_Code__c); 
        System.debug('@@@@@@@@@@@@@'+objApplication.OTP__c); 
        System.debug(objApplication.genesis__Account__c);
        
    }
    
    
    public pagereference GetMyOffer()
    {
    
   // fetchApplication();
   getCookieData();
    system.debug('password12' +objApplication.OTP__c);
    system.debug('password123' +password);
    objAccount = [Select id,PersonEmail,PersonContactId,Phone,PersonMobilePhone,OTP__c from Account where id=: objApplication.genesis__Account__c limit 1];
        
        if(objAccount.OTP__c != null )
        {
            system.debug('password1234' +password);
            if(objAccount.OTP__c == password )
            {
                system.debug('password1235' +password);
                pepUtilityClass.SaveContinueStatus(objApplication,'pepCongratulations') ;
                String redircetPageName= pages_config__c.getinstance('pepcongratulations').Page_Label__c;
                pageReference objNextPage = new PageReference('/'+redircetPageName); 
                Cookie objcookie = new cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
                objNextPage.setcookies(new cookie[]{objcookie});
                objNextPage.setRedirect(true);
                return objNextPage;
            }
            else
            {
                
                system.debug('Swati' + boolEnable);
                boolEnable = false;
                //errormessage = 'OTP does not match!';
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'OTP does not match!'));
                //return null;
                
            }
        }
        else{
         boolEnable = false;
        }
        return null;
    }
    public Pagereference ResendNow()
    {
        boolEnable = true;
        list<OTP_Template__c> LstOTPTemplate = OTP_Template__c.getAll().Values();
        objAccount = [Select id,PersonEmail,PersonContactId,Phone,PersonMobilePhone from Account where id=: objApplication.genesis__Account__c limit 1];
        Id TemplateId = Id.valueOf(LstOTPTemplate[0].Template_Id__c);
        EmailTemplate objTemplate = [Select id, body from EmailTemplate where id=: TemplateId ];
        PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
        
        
        
        if(objAccount.PersonEmail != null)
        {
            if(PIN != '')
            {
                objAccount.OTP__c = PIN;
                objAccount.PepOTP__c = PIN;
                update objAccount;
                fetchAndUpdateApplication(objApplication,lstSobject);
            }
            
            /*Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage(); 
            lstEmailAddress.add(objAccount.PersonEmail);
            objEmail.setToAddresses(lstEmailAddress); 
            objEmail.setTargetObjectId(objAccount.PersonContactId);
            //objEmail.setSubject(objTemplate.Subject);
            objEmail.setTemplateId(objTemplate.Id);
            //objEmail.setHtmlBody(strUpdatedBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {objEmail});*/
              
        }
        
     /*   if(objAccount.PersonMobilePhone != null)
        {
            system.debug('phoneNoIsvalue'+objAccount.PersonMobilePhone);
            String receipentName = objAccount.PersonMobilePhone;
            String receipentNo = objAccount.PersonMobilePhone;
            String retrievalCode= objApplication.Ret_Code__c;
            String message = ('Your Pepper verification code is:'+retrievalCode);
            //passing parameter values to the sms class
            String smsResponse = pepSMSmagicSendMessageHandler.sendSMS(receipentName, receipentNo, message);
            system.debug('reponseis'+smsResponse);
        } */
         String redircetPageName= pages_config__c.getinstance('pepotp').Page_Label__c;
                pageReference objNextPage = new PageReference('/'+redircetPageName); 
                Cookie objcookie = new cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
                objNextPage.setcookies(new cookie[]{objcookie});
                objNextPage.setRedirect(true);
                return objNextPage;
             
    }
    
    public void fetchAndUpdateApplication(genesis__Applications__c ObjApplication,List<sobject> lstSobject)
    {
        Id idApplication;
        
        
        Map<string,string> childobjects = new Map<string,string>();
        List<genesis__Applications__c>  lstApplication = pepInvokeCLMethodHelper.fetchApplications(null,ObjApplication.Id,null,null,childobjects);
        if(lstApplication != null && lstApplication.size() > 0)
        {
            lstApplication[0].OTP__c = PIN; 
            System.debug('lstApplication*************'+lstApplication);        
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            System.debug('lstObject******'+lstsObject.size());
            System.debug('lstObject******'+lstsObject);
            objApplication = pepInvokeCLMethodHelper.updateApplication(lstApplication[0],mapRelatedObjects,mapChildObjects);
            System.debug('objApplication****'+objApplication);
        }
        
    
    }
    
    Public Pagereference checkcookie(){
    Pagereference pr=Peputilityclass.checkCookieAndRedirect();
    return pr;
}
}
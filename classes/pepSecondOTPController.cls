public class pepSecondOTPController{
public Account objAccount{get;set;}
public list<String> lstEmailAddress;
public genesis__Applications__c objApplication{get;set;}
public String password{get;set;}
public List<sobject> lstSobject{get;set;}
public string PIN;
public string applicationId{get;set;}
public string errormessage{get;set;}
public boolean boolEnable{get;set;}

    public pepSecondOTPController()
    {
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
        system.debug('cookieApplicationId ::'+cookieApplicationId );     
        if (cookieApplicationId == null)
        {system.debug('in if');
            cookieApplicationId = new Cookie('ApplicationId',objApplication.Id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookieApplicationId});
        }        
        else if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {system.debug('in else');
            system.debug('cookie values:: '+cookieApplicationId.getValue());
            //applicationId = 'a5UN000000097C5';
            applicationId = cookieApplicationId.getValue();
            String[] lstTypes = new String[]{'genesis__Applications__c','Residential_Address__c','genesis__Employment_Information__c','Account'};
            String FieldSetName='pepGeneral';
           //lstApplication=pepUtilityClass.fetchApplicationAndChild(lstTypes,FieldSetName,null,idApplication,null);                    
           list<genesis__Applications__c> lstApplication=pepUtilityClass.fetchApplicationAndChild(lstTypes,FieldSetName,null,applicationId,null);
           if(lstApplication!=null && lstApplication.size()>0)
           {
               objApplication = lstApplication[0];
               applicationId = lstApplication[0].Id;
           }
            
            /*if(cookieApplicationId.getValue() == lstApplication[0].Id)
            {
               cookieApplicationId = new Cookie('ApplicationId',applicationId,null,-1,false); 
               ApexPages.currentPage().setCookies(new Cookie[]{cookieApplicationId});
               objApplication.Id = cookieApplicationId.getValue();
               applicationId = cookieApplicationId.getValue();
            }*/
            
            
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
        System.debug(objApplication.OTP__c); 
        System.debug(objApplication.genesis__Account__c);
        
    }
    
    
    public pagereference GetMyOffer()
    {
    
   // fetchApplication();
   getCookieData();
    system.debug('password12' +objApplication.OTP__c);
    system.debug('password123' +password);
        if(objApplication.OTP__c != null )
        {
            system.debug('password1234' +password);
            if(objApplication.OTP__c == password )
            {
                system.debug('password1235' +password);
                pageReference objNextPage = new PageReference('/apex/pepCongratulations'); 
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
        
        return null;
    }
    public void ResendNow()
    {
        boolEnable = true;
        list<OTP_Template__c> LstOTPTemplate = OTP_Template__c.getAll().Values();
        objAccount = [Select id,PersonEmail,PersonContactId,Phone from Account where id=: objApplication.genesis__Account__c limit 1];
        Id TemplateId = Id.valueOf(LstOTPTemplate[0].Template_Id__c);
        EmailTemplate objTemplate = [Select id, body from EmailTemplate where id=: TemplateId ];
        PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
        
        
        
        if(objAccount.PersonEmail != null)
        {
            if(PIN != '')
            {
                objAccount.Second_OTP__c = PIN;
                objAccount.PepSecond_OTP__c = PIN;
                objAccount.Second_OTP_Generation_Time__c = System.now();
                update objAccount;
                fetchAndUpdateApplication(objApplication,lstSobject);
            }
            
            Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage(); 
            lstEmailAddress.add(objAccount.PersonEmail);
            objEmail.setToAddresses(lstEmailAddress); 
            objEmail.setTargetObjectId(objAccount.PersonContactId);
            //objEmail.setSubject(objTemplate.Subject);
            objEmail.setTemplateId(objTemplate.Id);
            //objEmail.setHtmlBody(strUpdatedBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {objEmail});
                     
            
        }
        
        if(objAccount.Phone != null)
        {
            system.debug('phoneNoIsvalue'+objAccount.Phone);
            String receipentName = objAccount.Phone;
            String receipentNo = objAccount.Phone;
            String retrievalCode= objApplication.Ret_Code__c;
            String message = ('Your Pepper verification code is:'+retrievalCode);
            //passing parameter values to the sms class
            String smsResponse = pepSMSmagicSendMessageHandler.sendSMS(receipentName, receipentNo, message);
            system.debug('reponseis'+smsResponse);
        }
        
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
}
Public class pepgenericredirection{

Public Boolean checkcookie{get;set;}
Public string App{get;set;}
Public string page_Name{get;set;}
Public string Page_Label{get;set;}
public String failingPageResponse {get; set;}

Public pepgenericredirection(){
        page_Name=ApexPages.currentPage().getUrl();
        page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
if(ApexPages.currentPage().getcookies().get('ApplicationId') != null){
    
    if(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != null && ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != '')
    {
      genesis__Applications__c ap=[select id,name,genesis__Account__c,PepDocusignenvelopeId__c,RedirectToContract__c from genesis__Applications__c where id=:pepEncryptDecryptData.DecryptData(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue()) limit 1];
      App=ap.name;
      checkcookie=True;
    }
}
}
//Written By Varun Arora to send the Technical Error Message on Nov 30,2016.
Public PageReference sendTechnicalerroremail(){
        failingPageResponse = Site.getErrorDescription();
        Cookie cookieExceptionId = ApexPages.currentPage().getCookies().get('ExceptionId');  
        String exceptionString;  
        if(cookieExceptionId !=null && cookieExceptionId.getValue() !=null && cookieExceptionId.getValue() !='')
        {                           
               exceptionString = pepEncryptDecryptData.DecryptData(String.valueof(cookieExceptionId.getValue()));
        }
        Boolean apiserviceused=false;
        Messaging.singleemailmessage msg  = new Messaging.SingleEmailmessage();
        string subject='Technical Error Alert -App';
        subject+=App!=null?' '+App:' '+'Widget page';
        msg.setSubject(subject);
        if(exceptionString != null && exceptionString.length() >0)
        {
            msg.setplaintextbody(exceptionString);
        }else{
            msg.setplaintextbody(Label.TechnicalErrorMessage);
        }
        List<string> emailaddresses= new List<string>();//List to hold the email addresses.
        List<string> mobileNumbers = new List<string>();//List to hold the mobile numbers.
        List <smagicinteract__smsmagic__c> smsObjectList = new List <smagicinteract__smsmagic__c>();
        List<Technical_Error_Email_Group__c> emailRecordsList=Technical_Error_Email_Group__c.getall().values();//Accessing Mobile Numbers and Emails from the custom setting.
        if(emailRecordsList != null && emailRecordsList.size()>0){
            for(Technical_Error_Email_Group__c terGrp:emailRecordsList){
                 if(terGrp.Email__c != null)
                 emailaddresses.add(terGrp.Email__c);
                 if(terGrp.Mobile__c != null)
                 mobileNumbers.add(terGrp.Mobile__c);
             }
        }
        if(emailaddresses != null && emailaddresses.size()>0 && Technical_Error_Email_Group__c.getinstance('AutomaticEmail/SMS').Disable_Automatic_Notification__c != True){
            msg.settoaddresses(emailaddresses);
            apiserviceused=True;
            Messaging.sendemail(new Messaging.SingleEmailmessage[]{msg});//Sending Email.
        }
        if(mobileNumbers != null && mobileNumbers.size()>0 && Technical_Error_Email_Group__c.getinstance('AutomaticEmail/SMS').Disable_Automatic_Notification__c != true){
            for(String str:mobileNumbers){
                 //Making a Call to the SMS Magic Interact Services.
                 String senderId =Label.SenderId;
                 String templateText = Label.TechnicalErrorMessage;
                 smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                 smsObject.smagicinteract__SenderId__c = senderId;
                 smsObject.smagicinteract__PhoneNumber__c =str;
                 smsObject.smagicinteract__Name__c ='Pepper'; 
                 smsObject.smagicinteract__ObjectType__c = 'Contact';
                 smsObject.smagicinteract__disableSMSOnTrigger__c = 0;
                 smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                 smsObject.smagicinteract__SMSText__c = templateText;
                 smsObjectList.add(smsObject);
                 apiserviceused=True;
              }
              if(smsObjectList != null && smsObjectList.size()>0)
              insert smsObjectList;
              if(apiserviceused=True){
              Technical_Error_Email_Group__c trg = new Technical_Error_Email_Group__c(id=Technical_Error_Email_Group__c.getinstance('AutomaticEmail/SMS').id,Email_SMS_count__c=Technical_Error_Email_Group__c.getinstance('AutomaticEmail/SMS').Email_SMS_count__c+1,Disable_Automatic_Notification__c =Technical_Error_Email_Group__c.getinstance('AutomaticEmail/SMS').Email_SMS_count__c+1==10?True:False);
              update trg;
              }
        }
        return null;
    }
}
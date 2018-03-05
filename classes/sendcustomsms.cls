Global class sendcustomsms {
    Public string accounMobilenumber{get;set;}
    Public Boolean showsmsblock{get;set;}
    Public string text{get;set;}
    Public String Applicationid{get;set;}
    Public sendcustomsms(){
    Applicationid=ApexPages.currentPage().getParameters().get('applicationid');
    List<genesis__Applications__c> Application =[Select id,Account_Mobile_Phone__c from genesis__Applications__c where id=:ApexPages.currentPage().getParameters().get('applicationid')];
    if(Application != null && Application[0].Account_Mobile_Phone__c != null ){
        showsmsblock=True;
        accounMobilenumber=Application[0].Account_Mobile_Phone__c;
        
    }
    else{
        showsmsblock=False;
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Account associated with Application must have the mobile number associated with it.'));
    }
    }
    Public Pagereference sendsms(){
        if(text==null || text ==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please provide the text to send to the customer.'));
            return null;
        }
        else{
            String senderId = Label.senderId;
            String templateText = text;
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = senderId;
            smsObject.smagicinteract__PhoneNumber__c =accounMobilenumber;
            smsObject.smagicinteract__Name__c ='Pepper'; // records name
            smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            smsObject.smagicinteract__SMSText__c = templateText+' ' + Label.GenericErrorMessage;
            insert smsObject;
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.confirm,'SMS Sent Sucessfully.Please click on the Back button to move to the Application.'));
            return null;
        }
    }
    Webservice static string sendEmail(string appId){
     genesis__Applications__c app =[Select id,Account_Mobile_Phone__c,Account_Email__c,SendEmailRetrievalthroughButton__c  from genesis__Applications__c where id=:appId Limit 1];
     if(app.Account_Email__c != null){
     app.SendEmailRetrievalthroughButton__c =True;
     update app;
     return 'true';
     }else{
     return 'false';
     }
   }
   Webservice static string sendwebserviceSMS(string appId){
     genesis__Applications__c app =[Select id,Account_Mobile_Phone__c,Account_Email__c,SendEmailRetrievalthroughButton__c,SendSMSRetrievalThroughButton__c   from genesis__Applications__c where id=:appId Limit 1];
     if(app.Account_Mobile_Phone__c != null){
     app.SendSMSRetrievalThroughButton__c =True;
     update app;
     return 'true';
     }else{
     return 'false';
     }
   }
}
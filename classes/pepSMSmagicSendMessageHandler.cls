public class pepSMSmagicSendMessageHandler {
   public static string sendSMS(String recepientName, String recepientNumber, String message)
    {
        System.debug(recepientName);
        System.debug(recepientNumber);
        System.debug(message);
        String response;
        if(recepientName == Null || recepientName.trim() == '')
        {
            response = 'Recepient Name should not be null or blank';
            return response;
        }
        if(recepientNumber == Null || recepientNumber.trim() == '')
        {
            response = 'Recepient Number should not be null or blank';
            return response;
        }
        if(message == Null || message.trim() == '')
        {
            response = 'Message should not be null or blank';
            return response;
        }
        try
        {
            List<smagicinteract__smsmagic__c> smsObjectList;
            smsObjectList = new List <smagicinteract__smsmagic__c>();
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('senderId');
            if(objSetting == Null)
            {
                response = 'Sender ID not found in custom settings.';
                return response;
            }
            String senderId = objSetting.senderId__c;
            String templateText = message;
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = senderId;
            smsObject.smagicinteract__PhoneNumber__c = recepientNumber;
            smsObject.smagicinteract__Name__c = recepientName; // records name
            smsObject.smagicinteract__ObjectType__c = 'Mobile'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            smsObject.smagicinteract__SMSText__c = templateText;
            smsObjectList.add(smsObject);
            Database.insert(smsObjectList,false);
            
            //System.debug('!!!! smsObjectList -'+smsObjectList);
            return response;
        }catch(Exception e)
        {
            response = 'Exception occurred :1.Message is -'+e.getMessage() +'2.Stack trace is -'+e.getStackTraceString();
            return response;
        }       
    } 

}
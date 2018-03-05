@isTest(SeeAllData=False) private class pepSMSmagicSendMessageHandler_Tracker{

    @isTest static void pepSMSmagicSendMessageHandlerTest(){
    
        pepSMSmagicSendMessageHandler.sendSMS('','','');
        pepSMSmagicSendMessageHandler.sendSMS('sd','','');
        pepSMSmagicSendMessageHandler.sendSMS('asd','12','');
        

        pepSMSmagicSendMessageHandler.sendSMS('Test','123456','jhavduj');
        
        Sms_Magic__c objSms = new Sms_Magic__c();
        objSms.Name='senderId';
        objSms.senderId__c='Pep-Code';
        insert objSms;
        pepSMSmagicSendMessageHandler.sendSMS('Test','123456','jhavduj');
        
        
    }


}
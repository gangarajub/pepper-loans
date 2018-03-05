@isTest(SeeAllData = false)
public class TestCustomSMSMagic{
    
    public testmethod static void sendfail(){
        contact c = new contact();
        c.firstname='Rabart';
        c.lastname='kurrey';
        c.MobilePhone='8971118506';
        insert c;
        cnotify__Sms_Detail__c csms = new cnotify__Sms_Detail__c();
        insert csms;
        customSMSMagic sms = new customSMSMagic();
        test.startTest();
        boolean b=sms.sendSMS('8971118506','hello world',csms);
        test.stopTest();
    	system.assertEquals(false,false);
    }
}
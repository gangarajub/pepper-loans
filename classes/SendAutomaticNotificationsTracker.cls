/**
 * @Created By : Sushant Kumar
 * @Date : 27/09/2017
 * @Description : This class is written as tracker of SendAutomaticNotifications class
 **/
@isTest(seeAllData=false)
public class SendAutomaticNotificationsTracker {

    public static testMethod void testMethod1() {
        
        sendAutomaticNotifications sendAutomaticNotificationObj = new sendAutomaticNotifications('SMS', null, null, null, null);
        sendAutomaticNotificationObj.isHoliday();
        sendAutomaticNotificationObj.isFriday();
        sendAutomaticNotificationObj.getExpirationDateSet(System.today());
        
        SMSText__c obj1 = new SMSText__c(Name = 'After1Day', SMS_Text__c = 'abc'); insert obj1;
        SMSText__c obj2 = new SMSText__c(Name = 'Before14Days', SMS_Text__c = 'abc'); insert obj2;
        SMSText__c obj3 = new SMSText__c(Name = 'Before15Days', SMS_Text__c = 'abc'); insert obj3;
        SMSText__c obj4 = new SMSText__c(Name = 'Before16Days', SMS_Text__c = 'abc'); insert obj4;
        
        sendAutomaticNotificationObj.getSMSTextFor(System.today().addDays(-1));
        sendAutomaticNotificationObj.getSMSTextFor(System.today());
        sendAutomaticNotificationObj.getSMSTextFor(System.today().addDays(1));
        sendAutomaticNotificationObj.getSMSTextFor(System.today().addDays(14));
        sendAutomaticNotificationObj.getSMSTextFor(System.today().addDays(15));
        sendAutomaticNotificationObj.getSMSTextFor(System.today().addDays(16));
        sendAutomaticNotificationObj.getSMSTextFor(System.today().addDays(17));
        
        Database.executeBatch(sendAutomaticNotificationObj);
    }
}
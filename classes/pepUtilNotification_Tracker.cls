@isTest(SeeAllData=false) private class pepUtilNotification_Tracker{

    @isTest static void pepUtilNotificationTest(){
    
    pepUtilNotification.SendEmailNotification('test@test.com','hvv','hgv');
    pepUtilNotification.SendSMSNotification('jv','133','sdvsv');
    
    pepUtilNotification.SendEmailNotification('testtest.com','hvv','hgv');
    
    }


}
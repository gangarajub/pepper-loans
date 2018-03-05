//-----------------------------------------------------------------------------------------------------
// Description : This class is test class for CRM_Mtg_BDMTargetHandler class
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
// 1.0                            Sandip Bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
@isTest(SeeAllData = false)
public class CRM_Mtg_TestBDMTargetHandler
{
    @isTest static void test0()
    {
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
        LastName = 'last',
        Email = 'puser000@amamama.com',
        Username = 'puser000@amamama.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        CRM_Mtg_Unique_Id__c = 121111
        );   
        
        insert u; 
        
        system.runAs(u)
        {
            CRM_Mtg_BDM_Target__c objBdmTarget = 
            new CRM_Mtg_BDM_Target__c(
            Name = '1234567-Mar-2017',
            CRM_Mtg_BDM_Unique_Id__c = 121111,
            CRM_Mtg_Month__c = 'jan',
            CRM_Mtg_Year__c = '2017',
            CRM_Mtg_Default_Record__c = true);
            
            insert objBdmTarget;
        }
    }
}
//-----------------------------------------------------------------------------------------------------
// Description : This class is test class for CRM_Mtg_CreateEmailMessage class
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
// 1.0                            Sandip Bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
@isTest(SeeAllData = false)
public class CRM_Mtg_TestCreateEmailMessage
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
        LocaleSidKey = 'en_US'
        );   
        
        insert u; 
        
        system.runAs(u)
        {
        
            Account acc = new Account(Name = 'testAccount',CRM_Mtg_Channel__c = 'White Label');
            insert acc;
            
            Contact con = new Contact(LastName = 'testContact',AccountId = acc.Id,email = 'abc@pqr.com');
            insert con;
            
            Case cse = new Case(
                RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mortgage Broker Scenario').getRecordTypeId(),
                Status = 'New',
                Origin = 'Email',
                Priority = 'Medium',
                ContactId = con.id);
            
         
            insert cse;
            List<Id> caseIds = new List<Id>();
            caseIds.add(cse.Id);
            CRM_Mtg_CreateEmailMessage.CreateEmailMessageRecord(caseIds);
            
        }
    }
}
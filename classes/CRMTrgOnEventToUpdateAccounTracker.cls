//-----------------------------------------------------------------------------------------------------
// Description : This class is test class for CRMTrgOnEventToUpdateAccountHandler class
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
// 1.0                            Sandip Bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
@isTest(SeeAllData = false)
public class CRMTrgOnEventToUpdateAccounTracker
{
    @isTest static void test0()
    {
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator-CRM'].Id,
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
            
            Account acc = new Account();
            acc.Name = 'testData';
            insert acc;
            Contact con = new Contact(firstName ='First',LastName='last',AccountId = acc.Id);
            insert con;
            
            Event eve= new Event();
            eve.Type = 'Email';
            eve.Description = 'meeting'; //string Meeting
            eve.Subject='Meeting';
            eve.CRM_Status__c = 'Completed';
            eve.OwnerId = u.id; //user id
            eve.WhatId = acc.id; //record id
            eve.WhoId= con.id;
            eve.CRM_Meeting_Notes__c ='notes';
            eve.EndDateTime=DateTime.newInstance(2016,12,12);
            eve.StartDateTime=DateTime.newInstance(2016,12,12);
            eve.CRM_Mtg_Send_MoM_Email__c =true;
            eve.CRM_Mtg_Meeting_Objectives__c = 'Training';
            eve.CRM_Mtg_Meeting_Outcomes__c = 'meeting outcome';
            eve.CRM_Mtg_Meeting_Email_Body__c ='meeting body';
            
            insert eve;
            
            eve.Description = 'abc';
            update eve;
        }
    }
}
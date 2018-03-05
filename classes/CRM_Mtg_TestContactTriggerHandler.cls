// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for CRM_Mtg_ContactTriggerHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 22-APR-2017          Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class CRM_Mtg_TestContactTriggerHandler
{
    static testMethod void myUnitTest1() 
    {  
        test.startTest();
        Account acc = new Account(Name='testAccount',CRM_Mtg_Channel__c='White Label',CRM_Mtg_Unique_Id__c = 1211);
        insert acc;
        Contact con1 = new Contact(LastName = 'testContact',AccountId=acc.Id,CRM_Mtg_Unique_Id__c = 123, MobilePhone='0400000000');
        insert con1;
        Contact con3 = new Contact(LastName = 'testContact',AccountId=acc.Id,CRM_Mtg_Unique_Id__c = 1234, MobilePhone='+61400000000');
        insert con3;
        Contact con = new Contact(LastName = 'testContact',AccountId=acc.Id,CRM_Mtg_Accreditation_Status__c = 'Active');
        insert con;
        Contact con2 = new Contact(LastName = 'testContact',AccountId=acc.Id,CRM_Mtg_Accreditation_Status__c = '');
        insert con2;
        
        con2.CRM_Mtg_Accreditation_Status__c ='Active';
        con2.MobilePhone='+61400000000';
        update con2;
        test.stopTest();
        Contact c = [Select id, MobilePhone from Contact where CRM_Mtg_Unique_Id__c = 1234];
        system.assertEquals(c.MobilePhone, '61400000000');
    }       
    
      
}
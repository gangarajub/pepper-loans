// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for CRM_Mtg_AccountTriggerHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 22-APR-2017          Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class CRM_Mtg_TestAccountTriggerHandler
{
    static testMethod void myUnitTest1() 
    {  
        Account acc = new Account(Name='testAccount',CRM_Mtg_Accreditation_Status__c ='Active',CRM_Mtg_Unique_Id__c = 1211);
        insert acc;
        
        Account acc1 = new Account(Name='testAccount',CRM_Mtg_Accreditation_Status__c ='Active');
        insert acc1;
        
        Account acc2 = new Account(Name='testAccount',CRM_Mtg_Accreditation_Status__c ='');
        insert acc2;
        
        acc2.CRM_Mtg_Accreditation_Status__c ='Active';
        update acc2;
    }       
      
}
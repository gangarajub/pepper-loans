/*------------------------------------------------------------------------
Author:        Sean Jolly
Name:          PL_Broker_Accreditation_TriggerTest
Company:       Pepper
Class Covered: PL_Broker_Accreditation_Trigger, PL_Broker_Accreditation_TriggerHandler
Description:   A test class created to validate the PL_Broker_Accreditation_TriggerHandler 
              Tests executed:
              1 - testInsert()
              Inserts a record and validates that P1 is populated by the trigger.
History
2017-11-13    Sean Jolly     Created
----------------------------------------------------------------------------*/


@isTest
public class PL_Broker_Accreditation_TriggerTest {

    @isTest static void testInsert() {
    	loan__Commission_Plan__c CommPlan = new loan__Commission_Plan__c();
        CommPlan.loan__Factor__c = 100;
        CommPlan.loan__Maximum_Commission_Percentage__c = 100;
        CommPlan.loan__Plan_Description__c = 'Test Plan';
        CommPlan.loan__Buy_Rate__c = 100;
        CommPlan.loan__Upfront_Percentage__c = 0;
        CommPlan.loan__Enabled__c = true;
        CommPlan.loan__Flat_Amount__c = 0;
        
        Insert CommPlan;       
        
        Account acct = new Account();
        acct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeID();
        acct.Name = 'Test Account';
        acct.Default_PL_Commission_Plan__c = CommPlan.Id;
        
        Insert acct;
        
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Smith';
        contact.AccountId = acct.Id;
        contact.Email = 'test@test.com';
        
        Insert contact;
        
        PL_Broker_Accreditation__c plba = new PL_Broker_Accreditation__c();
    	plba.First_Name__c = 'John';
        plba.Last_Name__c = 'Smith';
        plba.Street__c = '1 StreetName St';
        plba.City__c = 'Suburb';
        plba.State__c = 'NSW';
        plba.Postcode__c = '2000';
        plba.Phone__c = '0414414141';
        plba.Email__c = 'sjolly@pepper.com.au';
        plba.Aggregator__c = 'FAST';
        plba.Contact__c = contact.Id;
    
        insert plba;
 
        String P1 = [SELECT P1__c FROM PL_Broker_Accreditation__c WHERE Id =: plba.Id LIMIT 1].P1__c;
        Integer size = P1.length();
        
        System.assertNotEquals(null, P1);
        System.assertEquals(20, size);
        
    }  
     
}
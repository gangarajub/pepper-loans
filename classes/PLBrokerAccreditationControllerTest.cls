/*------------------------------------------------------------------------
Author:        Sean Jolly
Name:          PLBrokerAccreditationControllerTest
Company:       Pepper
Class Covered: PLBrokerAccreditationController
Description:   A test class created to validate the PLBrokerAccreditation and PLBrokerAccreditationInvalid VisualForce pages
              Tests executed:
              1 - testParamsOk()
              Tests when supplied parameters are ok
              2 - testExpiredP1()
              Tests what happens when the p1 parameter is an expired value
              3 - testPreviouslyOptedIn()
              Tests what happens when the broker has already opted in.
History
2017-11-13      Sean Jolly     Created
----------------------------------------------------------------------------*/

@isTest 
public class PLBrokerAccreditationControllerTest{

    
    static testMethod PL_Broker_Accreditation__c InsertData() {
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
        contact.Email = 'sjolly@pepper.com.au';
        
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
        
        plba.P1__c = [SELECT P1__c from PL_Broker_Accreditation__c where Id =: plba.id limit 1].P1__c;
        
        return plba;
    }
    
    static testMethod void testParamsOk() {
    	
        PL_Broker_Accreditation__c plba = InsertData();
        
        PageReference pageRef = Page.PLBrokerAccreditation; // VF page Name
        pageRef.getParameters().put('id', String.valueOf(plba.Id));
        pageRef.getParameters().put('P1', plba.P1__c);
        Test.setCurrentPage(pageRef);
        
        plba.P1_Timestamp__c = Date.today().addDays(20);
        Update plba;
        
        PLBrokerAccreditationController testAccreditation = new PLBrokerAccreditationController(new ApexPages.StandardController(plba));

      	Test.StartTest(); 
        
        //Test when supplied parameters are ok
        PageReference result1 = testAccreditation.router();
        PageReference result2 = testAccreditation.requestURL();
        PageReference result3 = testAccreditation.saveBrokers();
        
        system.assertEquals(null, result1);
        
        PageReference expectedPR1 = new PageReference('/apex/PLBrokerAccreditationEmailSent'); 
        system.assertEquals(expectedPR1.getURL(), result2.getURL());
        
        PageReference expectedPR2 = new PageReference('/apex/PLBrokerAccreditationThanks'); 
        system.assertEquals(expectedPR2.getURL(), result3.getURL());
        
        Test.StopTest();
        
    }
    
     static testMethod void testExpiredP1() {
    	
        PL_Broker_Accreditation__c plba = InsertData();
       
 		Test.StartTest(); 

        PageReference pageRef = Page.PLBrokerAccreditation; // VF page Name
        pageRef.getParameters().put('id', String.valueOf(plba.Id));
        pageRef.getParameters().put('P1', plba.P1__c);
        Test.setCurrentPage(pageRef);
        
        PLBrokerAccreditationController testAccreditation = new PLBrokerAccreditationController(new ApexPages.StandardController(plba));
        
        //Test when expired parameters
        plba.P1_Timestamp__c = Date.today().addDays(-100);
        Update plba;
       
        PageReference result1 = testAccreditation.router();
        
        PageReference ExpectedPR1 = new PageReference('/apex/PLBrokerAccreditationInvalid?id=' + String.valueOf(plba.Id)); 
        system.assertEquals(ExpectedPR1.getURL(), result1.getURL());
         
         Test.StopTest();
        
    }   
		        

 static testMethod void testPreviouslyOptedIn() {
    	
        PL_Broker_Accreditation__c plba = InsertData();
        
 		PageReference pageRef = Page.PLBrokerAccreditation; // VF page Name
        pageRef.getParameters().put('id', String.valueOf(plba.Id));
        pageRef.getParameters().put('P1', plba.P1__c);
        Test.setCurrentPage(pageRef);
        
        PLBrokerAccreditationController testAccreditation = new PLBrokerAccreditationController(new ApexPages.StandardController(plba));
        
        //Test when previously opted in
        plba.P1_Timestamp__c = Date.today().addDays(1);
        plba.Opt_In__c = true;
        Update plba;
        
        Test.StartTest();
     
        PageReference result1 = testAccreditation.router();
     
     	PageReference ExpectedPR1 = new PageReference('/apex/PLBrokerAccreditationThanks');
     	system.assertEquals(ExpectedPR1.getURL(), result1.getURL());
        
        Test.StopTest();
        
    }   
       

}
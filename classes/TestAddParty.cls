@isTest
public class TestAddParty {
    
     //test method for Business Account
     public static testmethod void addBusinessAccountAsReferral(){
       loan.TestHelper.createSeedDataForTesting();
      
       RetrieveCode__c rc = new RetrieveCode__c();
       rc.Code__c = 'AAB37706';
       insert rc;
       
       Account ac1 = genesis.TestHelper.createAccount();
       ac1.Referral_Code__c= '123abc';
       ac1.loan__Broker__c=true;
       update ac1;
      
       
       genesis__applications__c application = genesis.TestHelper.createLoanApplication();
       //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
       application.genesis__Account__c=ac1.Id;
       update application; 
       
       clcommon__Party_Type__c clparty1 = new clcommon__Party_Type__c();
       clparty1.name='Broker';
       
       insert clparty1;
       
       clcommon__Party_Type__c clparty2 = new clcommon__Party_Type__c();
       clparty2.name='REFERRAL';
       
       insert clparty2;
       
       Test.startTest();
       AddParty addp = new AddParty();
       addp.add('123abc',application.Id);
       Test.stopTest();
       
       List<clcommon__Party__c> newParty = [select id,name from clcommon__Party__c  where genesis__Application__c=:application.Id and clcommon__Type__c=:clparty1.Id];
       System.assertEquals(newParty.size(),1);
       
     
      
     
    
    }
    
    //Test method for Person Account
     public static testmethod void addPersonAccountAsReferral(){
       loan.TestHelper.createSeedDataForTesting();
      
       RetrieveCode__c rc = new RetrieveCode__c();
       rc.Code__c = 'AAB37706';
       insert rc;
       RecordType  rec=[select id,name from RecordType where name ='Person Account'];
       Account ac1 = TestHelper.createAccount();
       ac1.Referral_Code__c= '123abc';
       ac1.loan__Broker__c=true;
       ac1.RecordTypeId=rec.Id;
       update ac1;
      
       
       genesis__applications__c application = genesis.TestHelper.createLoanApplication();
       //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
       application.genesis__Account__c=ac1.Id;
       update application; 
       
       clcommon__Party_Type__c clparty1 = new clcommon__Party_Type__c();
       clparty1.name='Broker';
       
       insert clparty1;
       
       clcommon__Party_Type__c clparty2 = new clcommon__Party_Type__c();
       clparty2.name='REFERRAL';
       
       insert clparty2;
       Test.startTest();
       AddParty addp = new AddParty();
       addp.add('123abc',application.Id);
       Test.stopTest();
       
       List<clcommon__Party__c> newParty= [select id,name from clcommon__Party__c  where genesis__Application__c=:application.Id and clcommon__Type__c=:clparty2.Id];
       System.assertEquals(newParty.size(),1);
       
     
      
     
    
    }
    
      //Test Method for invalid Referral code
      public static testmethod void invalidReferralCode(){
       loan.TestHelper.createSeedDataForTesting();
       pepPepperCustomSetting__c pepCustomValues = new pepPepperCustomSetting__c();
       pepCustomValues.replyemailId__c='admint@gmail.com';
       pepCustomValues.displayname__c='Pepper Money';
       insert pepCustomValues;
       PepperEmailTemplates__c pepCustomTemplate = new PepperEmailTemplates__c();
       pepCustomTemplate.referral_email_template__c='REFERRAL_EMAIL';
       pepCustomTemplate.welcome_email_template__c='WELCOME_MAIL';
       insert pepCustomTemplate;
       
       RetrieveCode__c rc = new RetrieveCode__c();
       rc.Code__c = 'AAB37706';
       insert rc;
       RecordType  rec=[select id,name from RecordType where name ='Person Account'];
       Account ac1 = TestHelper.createAccount();
       ac1.Referral_Code__c= '123abc';
       ac1.loan__Broker__c=true;
       ac1.RecordTypeId=rec.Id;
       update ac1;
      
       
       genesis__applications__c application = genesis.TestHelper.createLoanApplication();
       //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
       application.genesis__Account__c=ac1.Id;
       update application; 
       
       clcommon__Party_Type__c clparty1 = new clcommon__Party_Type__c();
       clparty1.name='Broker';
       
       insert clparty1;
       
       clcommon__Party_Type__c clparty2 = new clcommon__Party_Type__c();
       clparty2.name='REFERRAL';
       
       insert clparty2;
       
       Test.startTest();
       AddParty addp = new AddParty();
       addp.add('123a4bc',application.Id);
       Test.stopTest();
       
       List<clcommon__Party__c> BrokerPartyType = [select id,name from clcommon__Party__c  where genesis__Application__c=:application.Id and clcommon__Type__c=:clparty1.Id];
       List<clcommon__Party__c> ReferalPartyType = [select id,name from clcommon__Party__c  where genesis__Application__c=:application.Id and clcommon__Type__c=:clparty2.Id];
       System.assertEquals(BrokerPartyType.size(),0);
       System.assertEquals(ReferalPartyType.size(),0);
       
     
      
     
    
    }
    
     //Test Method for isBroker=false and ContactType=null
      public static testmethod void addFreshReferral(){
       loan.TestHelper.createSeedDataForTesting();
      
       RetrieveCode__c rc = new RetrieveCode__c();
       rc.Code__c = 'AAB37706';
       insert rc;
       RecordType  rec=[select id,name from RecordType where name ='Person Account'];
       Account ac1 = TestHelper.createAccount();
       ac1.Referral_Code__c= '123abc';
       ac1.loan__Broker__c=false;
       ac1.loan__Contact_Type__pc=null;
       ac1.RecordTypeId=rec.Id;
       update ac1;
      
       
       genesis__applications__c application = genesis.TestHelper.createLoanApplication();
       //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
       application.genesis__Account__c=ac1.Id;
       update application; 
       
       clcommon__Party_Type__c clparty1 = new clcommon__Party_Type__c();
       clparty1.name='Broker';
       
       insert clparty1;
       
       clcommon__Party_Type__c clparty2 = new clcommon__Party_Type__c();
       clparty2.name='REFERRAL';
       
       insert clparty2;
       
       Test.startTest();
       AddParty addp = new AddParty();
       addp.add('123abc',application.Id);
       Test.stopTest();
       
       List<clcommon__Party__c> newParty = [select id,name from clcommon__Party__c  where genesis__Application__c=:application.Id and clcommon__Type__c=:clparty2.Id];
     
       System.assertEquals(newParty.size(),1);
       
     
      
     
    
    }
}
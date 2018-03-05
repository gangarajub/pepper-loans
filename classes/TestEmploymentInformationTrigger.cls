@isTest
public class TestEmploymentInformationTrigger {
    public static testmethod void deleteAttachmentTest(){
        loan.TestHelper.createSeedDataForTesting();
  	    RetrieveCode__c mc =  new RetrieveCode__c();
        mc.code__c='AAA14341';
        insert mc;
        Account ac = genesis.TestHelper.createAccount();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        genesis__Employment_Information__c emp = new genesis__Employment_Information__c();
        emp.sequence__c=1;
        emp.genesis__Application__c=app.Id;
        emp.Employment_Status__c='casual';
        emp.Current_Occupation__c='office worker';
        emp.How_Long_have_you_worked__c='2';
        
        test.startTest();
        insert emp;
        test.stopTest();
        List<genesis__Applications__c> vd = [select id,name,How_long_have_you_worked__c from genesis__Applications__c where id=:app.Id];
        system.assertEquals('2',vd[0].How_long_have_you_worked__c);    
        
    }
}
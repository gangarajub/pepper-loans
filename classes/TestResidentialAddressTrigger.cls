@isTest
public class TestResidentialAddressTrigger {
	 @isTest
    private static void vedaComprehensiveTest(){ 
     RetrieveCode__c mc =  new RetrieveCode__c();
        mc.code__c='AAA14341';
        insert mc;
        Account ac = genesis.TestHelper.createAccount();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        Residential_Address__c rs = new Residential_Address__c();
        rs.Current_Address__c=true;
        rs.Street_Number__c='123';
        rs.Street_Name__c='Privet';
        rs.Street_Type__c='ST';
        rs.Suburb__c='Little Whinging';
        rs.State__c='NSW';
        rs.Property__c='Potter Manor';
        rs.Unit_Number__c='3';
        rs.PostCode__c='2999';
        rs.How_Long_have_you_lived_here__c='2';
        rs.Country_Code__c='AUS';
        rs.Application__c=app.Id;
        test.startTest();
        insert rs;
        test.stopTest();
        List<genesis__Applications__c> vd = [select id,name,How_long_you_have_lived_here__c from genesis__Applications__c where id=:app.Id];
        system.assertEquals('2',vd[0].How_long_you_have_lived_here__c);    
    }
}
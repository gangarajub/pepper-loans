@isTest
public class TestDandBImpl {
    testMethod static void DandBTest(){ 
        RetrieveCode__c mc =  new RetrieveCode__c();
        mc.code__c='AAA14341';
        insert mc;
        Account ac = genesis.TestHelper.createAccount();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        Residential_Address__c rs = new Residential_Address__c();
        rs.City__c = 'Melbourne';
        rs.Country__c = 'Australia';
        rs.Current_Address__c=true;
        rs.Street_Number__c='123';
        rs.Street_Name__c='Privet';
        rs.Street_Type__c='ST';
        rs.Suburb__c='Little Whinging';
        rs.State__c='NSW';
        rs.Property__c='Potter Manor';
        rs.Unit_Number__c='3';
        rs.PostCode__c='2999';
        rs.Country_Code__c='AUS';
        rs.Application__c=app.Id;
        insert rs;
        //TestHelper.insertIDMatrixCustomSetting();
        System.debug('app='+app.Id);
        VedaResponse vr = new VedaResponse();
        DandBImpl  v  = new DandBImpl();
        Decisioning_Configuration__c c = new Decisioning_Configuration__c();
        c.Name='DandB';
        c.Active__c=true;
        c.Callout_Class_Name__c='DandBImpl';
        c.Order__c=1;
        c.Parser_Class_Name__c='DandBParser';
        c.Response_Class_Name__c='ints.DunAndBradstreetResponse';
        insert c;
        vr.app=app;
        Test.startTest();
        VedaServices.webServiceDanB(app.Id);
        Test.stopTest();
    }    
    

}
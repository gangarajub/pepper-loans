@isTest
public class TestVedaComprehensiveImpl{
    
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
        rs.Country_Code__c='AUS';
        rs.Application__c=app.Id;
        insert rs;
       
        System.debug('app='+app.Id);
        ints__Veda_Comprehensive__c vdc = new ints__Veda_Comprehensive__c();
        vdc.Account_Type_Code__c='PL';
        vdc.Client_Reference__c='AQMF 9999';
        vdc.ints__Endpoint__c='https://cteau.vedaxml.com/sys2/soap11/vedascore-apply-v2-0';
        vdc.Operator_Id__c='PA';
        vdc.Operator_Name__c='James Smith';
        vdc.ints__Password__c='nYWp3PPerg5N';
        vdc.Permission_Type_Code__c='YX';
        vdc.Product_Data_Level_Code__c='N';
        vdc.Relationship_Code__c='1';
        insert vdc;
        vdc.ints__UserName__c='p3Pp3RhL04nz';
        Decisioning_Configuration__c c = new Decisioning_Configuration__c();
        c.Name='Veda Comprehensive';
        c.Active__c=true;
        c.Callout_Class_Name__c='VedaCompImpl';
        c.Order__c=1;
        c.Parser_Class_Name__c='VedaComprehensiveParser';
        c.Response_Class_Name__c='ints.VedaComprehensiveResponse';
        insert c;
        test.startTest();
        VedaServices.webServiceVedaComprehensive(app.Id);    
        test.stopTest();
        List<Veda_Comprehensive__c> vd = [select id,name from Veda_Comprehensive__c];
        system.assertEquals(vd.size(),1);     
       
    }

}
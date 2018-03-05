@isTest
public class TestServiceabilityCalcCtrl {
    public static testmethod void resAddressTest(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        Residential_Address__c res = new Residential_Address__c();
        res.Application__c = application.id;
        res.Current_Address__c = true;
        insert res;
        Invalid_Postcodes__c post = new Invalid_Postcodes__c();
        post.Post_Code__c = res.PostCode__c;
        insert post;
        Decisioning_Configuration__c dec = new Decisioning_Configuration__c();
        dec.Active__c = true;
        dec.Type__c = 'PRE-CONTRACT';
        insert dec;
       
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Test.startTest();
        ServiceabilityCalcCtrl cal = new ServiceabilityCalcCtrl(application.id);
        genesis__Applications__c app = ServiceabilityCalcCtrl.callVedaServices();
        
        system.assertEquals('Declined', app.genesis__Status__c);
        system.assertEquals(app.Decline_Reason__c, 'POSTCODE_DECLINE');
        Test.stopTest();
    }
    public static testmethod void decisionConfigTest(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        Decisioning_Configuration__c dec = new Decisioning_Configuration__c();
        dec.Active__c = true;
        dec.Callout_Class_Name__c = 'VedaFraudImpl';
        dec.Type__c = 'PRE-CONTRACT';
        insert dec;
     
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Test.startTest();
        ServiceabilityCalcCtrl cal = new ServiceabilityCalcCtrl(application.id);
        genesis__Applications__c app = ServiceabilityCalcCtrl.callVedaServices();
        
        system.assertEquals(ServiceabilityCalcCtrl.app.genesis__Status__c ,'NEW - CREDIT PULLED');
        system.assertEquals(ServiceabilityCalcCtrl.app.Serviceability_Status__C , 'In-Progress');
        Test.stopTest();
    }
    public static testmethod void decisionConfigTest1(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        Decisioning_Configuration__c dec = new Decisioning_Configuration__c();
        dec.Active__c = true;
        dec.Callout_Class_Name__c = 'VedaFraudImpl';
        dec.Type__c = 'POST-CONTRACT';
        insert dec;
     
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Test.startTest();
        ServiceabilityCalcCtrl cal = new ServiceabilityCalcCtrl(application.id);
        genesis__Applications__c app = ServiceabilityCalcCtrl.postContractCallVedaServices();
        
        //system.assertEquals(ServiceabilityCalcCtrl.app.genesis__Status__c ,'NEW - CREDIT PULLED');
        //system.assertEquals(ServiceabilityCalcCtrl.app.Serviceability_Status__C , 'In-Progress');
        Test.stopTest();
    }

}
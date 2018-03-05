@isTest
public class TestAutoScheduleGenerator {
    
    public static testmethod void autoScheduleGenerate(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis.TestHelper test1 = new genesis.TestHelper();
        test1.createDefaultOrgParameters();
        loan.testhelper.createOffice();
        
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        update application; 
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Account__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Account__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        list<boolean> gen = AutoScheduleGenerator.generate(applicationIds);
        system.assertEquals(true, gen[0]);
        Test.stopTest();
    }
    public static testmethod void autoScheduleBiWeekly(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis.TestHelper test1 = new genesis.TestHelper();
        test1.createDefaultOrgParameters();
        loan.testhelper.createOffice();
        
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        application.Debit_Frequency__c = 'BI-WEEKLY';
        update application; 
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Account__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Account__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        list<boolean> gen = AutoScheduleGenerator.generate(applicationIds);
        system.assertEquals(true, gen[0]);
        Test.stopTest();
    }
    public static testmethod void autoScheduleWeekly(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis.TestHelper test1 = new genesis.TestHelper();
        test1.createDefaultOrgParameters();
        loan.testhelper.createOffice();
        
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        application.Debit_Frequency__c = 'WEEKLY';
        update application; 
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Account__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Account__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        list<boolean> gen = AutoScheduleGenerator.generate(applicationIds);
        system.assertEquals(true, gen[0]);
        Test.stopTest();
    }

}
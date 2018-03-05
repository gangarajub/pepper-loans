@isTest
public class TestUncheckShowFlagDetails {
    public static testMethod void UncheckVedaFraud(){
        RetrieveCode__c mc =  new RetrieveCode__c();
        mc.code__c='AAA14341';
        insert mc;
        Account ac = genesis.TestHelper.createAccount();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        
        Veda_Fraud__c vf = new Veda_Fraud__c();
        vf.Application__c=app.Id;
        insert vf;
        test.startTest();
        UncheckShowDetailsFlag.uncheckShowDetaislFlagOfVedaFraud(vf.Id,app.Id);
        test.stopTest();
    }
     public static testMethod void UncheckVedaComprehensive(){
        RetrieveCode__c mc =  new RetrieveCode__c();
        mc.code__c='AAA14341';
        insert mc;
        Account ac = genesis.TestHelper.createAccount();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        
        Veda_Comprehensive__c vc = new Veda_Comprehensive__c();
        vc.Application__c=app.Id;
        insert vc;
        test.startTest();
        UncheckShowDetailsFlag.uncheckShowDetaislOfVedaComprehensive(vc.Id,app.Id);
        test.stopTest();
         
    }
     public static testMethod void UncheckIdMatrix(){
        RetrieveCode__c mc =  new RetrieveCode__c();
        mc.code__c='AAA14341';
        insert mc;
        Account ac = genesis.TestHelper.createAccount();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        
        Veda_IdMatrix__c IdMtx = new Veda_IdMatrix__c();
        IdMtx.Application__c=app.Id;
        insert IdMtx;
        test.startTest();
        UncheckShowDetailsFlag.uncheckShowDetaislOfIdMatrix(IdMtx.Id,app.Id);
        test.stopTest();
    }
    public static testMethod void UncheckDandB(){
        RetrieveCode__c mc =  new RetrieveCode__c();
        mc.code__c='AAA14341';
        insert mc;
        Account ac = genesis.TestHelper.createAccount();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        
        DandB__c dandb = new DandB__c();
        dandb.Application__c=app.Id;
        insert dandb;
        test.startTest();
        UncheckShowDetailsFlag.uncheckShowDetaislOfDanB(dandb.Id,app.Id);
        test.stopTest();
    }
    
    public static testMethod void testUncheckCollateral(){
        
        Test.startTest();
        genesis__Applications__c app=TestHelper.createLoanApplication();
        clcommon__Collateral__c col = new clcommon__Collateral__c(
                                clcommon__Collateral_Name__c = 'ABC',genesis__Application__c= app.id);
        insert col;
        clcommon__Collateral__c col1 = new clcommon__Collateral__c(
                                clcommon__Collateral_Name__c = 'ABC',genesis__Application__c= app.id);
        insert col1;
        
        UncheckShowDetailsFlag.uncheckShowDetailsFlagForCollateral(col.Id);
        
        Test.stopTest();
    }
}
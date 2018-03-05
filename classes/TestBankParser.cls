@isTest
public class TestBankParser {
    public static testmethod void testFetchAndInsertBankStatement(){
        loan.TestHelper.createSeedDataForTesting();
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application; 
        
        loan__Bank_Account__c bankAccount= new loan__Bank_Account__c();
        bankAccount.Account_Holder_Name__c='Mary Jones';
        bankAccount.Bank_Account_Number__c='123456789';
        bankAccount.loan__Bank_Account_Number__c='123456789';
        bankAccount.BSB__c='789999';
        bankAccount.loan__Account_Usage__c='Borrower/Investor Account';
        bankAccount.loan__Bank_Name__c='Commonwealth Bank';
        bankAccount.loan__Account__c=ac.Id;                                               
        insert bankAccount;
        
        
        
        
        Bank_Statement__c bnkk = new Bank_Statement__c();
        bnkk.Bank_Account__c=bankAccount.Id;
        bnkk.Application__c=application.Id;
        insert bnkk;
        Test.startTest();
        BankParserService bank = new BankParserService();
        String res=bank.fetchAndInsertBankStatement('adsfa',application.Id,'nab');
        Test.stopTest();
        System.assertEquals(res,'Not Successful');
        
    }
    public static testmethod void testGetBankAccountsForAccounts(){
        loan.TestHelper.createSeedDataForTesting();
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application; 
        
        loan__Bank_Account__c bankAccount= new loan__Bank_Account__c();
        bankAccount.Account_Holder_Name__c='Mary Jones';
        bankAccount.Bank_Account_Number__c='123456789';
        bankAccount.loan__Bank_Account_Number__c='123456789';
        bankAccount.BSB__c='789999';
        bankAccount.loan__Account_Usage__c='Borrower/Investor Account';
        bankAccount.loan__Bank_Name__c='Commonwealth Bank';
        bankAccount.loan__Account__c=ac.Id;                                               
        insert bankAccount;
        
        
        
        
        Bank_Statement__c bnkk = new Bank_Statement__c();
        bnkk.Bank_Account__c=bankAccount.Id;
        bnkk.Application__c=application.Id;
        insert bnkk;
        
        BankParserService bank = new BankParserService();
        String res=bank.fetchAndInsertBankStatement('adsfa',application.Id,'nab');
        System.assertEquals(res,'Not Successful');
        Test.startTest();
        List<loan__Bank_Account__c> bankacc =bank.getBankAccountsForAccount(ac.Id);
        
        Test.stopTest();
        System.assertEquals(bankacc.size(),1);
        
    }
    
    public static testmethod void testGetBankAccountsForApplication(){
        loan.TestHelper.createSeedDataForTesting();
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application; 
        
        loan__Bank_Account__c bankAccount= new loan__Bank_Account__c();
        bankAccount.Account_Holder_Name__c='Mary Jones';
        bankAccount.Bank_Account_Number__c='123456789';
        bankAccount.loan__Bank_Account_Number__c='123456789';
        bankAccount.BSB__c='789999';
        bankAccount.loan__Account_Usage__c='Borrower/Investor Account';
        bankAccount.loan__Bank_Name__c='Commonwealth Bank';
        bankAccount.loan__Account__c=ac.Id;                                               
        insert bankAccount;
        
        
        
        
        Bank_Statement__c bnkk = new Bank_Statement__c();
        bnkk.Bank_Account__c=bankAccount.Id;
        bnkk.Application__c=application.Id;
        insert bnkk;
        
        BankParserService bank = new BankParserService();
        Test.startTest();
        List<loan__Bank_Account__c> bankacc1 =bank.getBankAccountsForApplication(application.Id);
        Test.stopTest();
        System.assertEquals(bankacc1.size(),1);
        
    }
}
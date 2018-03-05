@isTest
public class TestBankApi {
     public static testmethod void addNewBankAccoun1(){
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application; 
        
        Expense_and_Debt__c expnd = new Expense_and_Debt__c();
        expnd.Application__c = application.Id;
        insert expnd;
        
        WrapperBankAccount  bankAcc = new WrapperBankAccount();
        List< WrapperBankAccount > listacc = new List<WrapperBankAccount>();
        bankAcc.Set(ac.Id,'Borrower/Investor Account','123', '123-456', 'HDFC',expnd.Id,'test bank holder',loan_app.Id,true,application.Id,true,true);//null, false, objApplication.Id,true,true
        Listacc.add(bankAcc);
        
        bankAcc.Set(ac.Id,'Borrower/Investor Account','123', '123-456', 'SBI',null,'test bank holder',loan_app.Id,true,application.Id,true,true);
        Test.startTest();
        BankApi bankapi= new BankApi();
        list<BankApi.Response> lstresp = bankapi.addNewBanks(Listacc);
        
        Test.stopTest();
        List<loan__Bank_Account__c>   newbankAccount1 = [select id,name from loan__Bank_Account__c];
        
        System.assertEquals(newbankAccount1.size(),1);
        
        
        
        
    }
    
    public static testmethod void addNewBankAccount2(){
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application; 
        
        Expense_and_Debt__c expnd = new Expense_and_Debt__c();
        expnd.Application__c = application.Id;
        insert expnd;
        
        WrapperBankAccount  bankAcc = new WrapperBankAccount();
        List< WrapperBankAccount > listacc = new List<WrapperBankAccount>();
        bankAcc.Set(ac.Id,'Borrower/Investor Account','123', '123-456', 'HDFC',expnd.Id,'test bank holder',loan_app.Id,true,application.Id,true,true);//null, false, objApplication.Id,true,true
        Listacc.add(bankAcc);
        
        bankAcc.Set(ac.Id,'Borrower/Investor Account','123', '123-456', 'HDFC',null,'test bank holder',loan_app.Id,true,application.Id,true,true);
        Test.startTest();
        BankApi bankapi= new BankApi();
        list<BankApi.Response> lstresp = bankapi.addNewBanks(Listacc);
        
        Test.stopTest();
        List<loan__Bank_Account__c>   newbankAccount1 = [select id,name from loan__Bank_Account__c];
        
        System.assertEquals(newbankAccount1.size(),1);
        
        
        
        
    }
    
    
    public static testmethod void activateBankAccount(){
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application; 
        
        Expense_and_Debt__c expnd = new Expense_and_Debt__c();
        expnd.Application__c = application.Id;
        insert expnd;
        TestHelper.createBankAccount(ac,'Borrower/Investor Account');
        TestHelper.createContact1();
        TestHelper.createContact2();
        TestHelper.createContact3();
        TestHelper.createContact4();
        TestHelper.createContact5();
        TestHelper.createContact6();
        TestHelper.createContact7();
        TestHelper.createContact8();
        TestHelper.createContact9();
        TestHelper.createContact10();
        TestHelper.createContact11();
        WrapperBankAccount  bankAcc = new WrapperBankAccount();
        List< WrapperBankAccount > listacc = new List<WrapperBankAccount>();
        bankAcc.Set(ac.Id,'Borrower/Investor Account','123', '123-456', 'HDFC',expnd.Id,'test bank holder',loan_app.Id,true,application.Id,true,true);//null, false, objApplication.Id,true,true
        Listacc.add(bankAcc);
        BankApi bankapi= new BankApi();
        list<BankApi.Response> lstresp = bankapi.addNewBanks(Listacc);
        List<loan__Bank_Account__c>   newbankAccount2 = [select id,name from loan__Bank_Account__c];
        newbankAccount2[0].loan__Active__c=false;
        update newbankAccount2;
        
        Test.startTest();
        BankApi.Response strresponse = bankapi.activateBankAccount(String.valueOf(newbankAccount2[0].Id),String.valueOf(application.Id),String.valueOf(loan_app.Id));
        Test.stopTest();
        List<loan__Bank_Account__c>   existingAccount = [select id,name,loan__Active__c from loan__Bank_Account__c];
        System.assertEquals(existingAccount[0].loan__Active__c,true);
        
    }
    
}
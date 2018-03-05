@isTest
public class TestRetrieveLoanAccounts {
    public static testmethod void getContracts()
    {
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);

        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        Account acc = genesis.TestHelper.createAccount();
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        String additionalFields='loan__Contact__r.Email, loan__Contact__r.BirthDate';
        String ChildObjectFields='loan__Active__c,loan__Frequency__c';
        Map<String,String> ChildObjectMap = new Map<String,String>();
        String status = 'Approved';
        ChildObjectMap.put('loan__Automated_Payment_Setup__r',ChildObjectFields);
        Test.startTest();
        List<loan__Loan_Account__c> ls = RetrieveLoanAccounts.getLoanContracts(acc.id,loan_app.id,status,additionalFields,ChildObjectMap);
        system.assertEquals(ls.size(), 1);
        Test.stopTest();
    }
    
    public static testmethod void contractIdNullTest()
    {
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);

        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        Account acc = genesis.TestHelper.createAccount();
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        String additionalFields='loan__Contact__r.Email, loan__Contact__r.BirthDate';
        String ChildObjectFields='loan__Active__c,loan__Frequency__c';
        Map<String,String> ChildObjectMap = new Map<String,String>();
        String status = Null;
        ChildObjectMap.put('loan__Automated_Payment_Setup__r',ChildObjectFields);
        List<loan__Loan_Account__c> ls = new List<loan__Loan_Account__c>();
        Test.startTest();
        try{
        ls = RetrieveLoanAccounts.getLoanContracts(acc.id,null,status,additionalFields,ChildObjectMap);
        }
        catch(Exception e)
        {
            system.debug('Contract Id is missing'+e.getMessage());
            
        }
        system.assertEquals(ls.size(), 0);
        Test.stopTest();
    }
    
    public static testmethod void borrowerIdNullTest()
    {
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);

        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        Account acc = genesis.TestHelper.createAccount();
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        String additionalFields='loan__Contact__r.Email, loan__Contact__r.BirthDate';
        String ChildObjectFields='loan__Active__c,loan__Frequency__c';
        Map<String,String> ChildObjectMap = new Map<String,String>();
        String status = Null;
        ChildObjectMap.put('loan__Automated_Payment_Setup__r',ChildObjectFields);
        ID borowerId ='00300000003T2PGAA0';
        List<loan__Loan_Account__c> ls = new List<loan__Loan_Account__c>();
        Test.startTest();
        try{
        ls = RetrieveLoanAccounts.getLoanContracts(borowerId,null,status,additionalFields,ChildObjectMap);
        }
        catch(Exception e)
        {
            system.debug('Borrower Id is missing'+e.getMessage());
            
        }
        system.assertEquals(ls.size(), 0);
        Test.stopTest();
    }
    
    public static testmethod void NullTest()
    {
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);

        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        Account acc = genesis.TestHelper.createAccount();
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        String additionalFields='loan__Contact__r.Email, loan__Contact__r.BirthDate';
        String ChildObjectFields='loan__Active__c,loan__Frequency__c';
        Map<String,String> ChildObjectMap = new Map<String,String>();
        String status = Null;
        ChildObjectMap.put('loan__Automated_Payment_Setup__r',ChildObjectFields);
        List<loan__Loan_Account__c> ls = new List<loan__Loan_Account__c>();
        Test.startTest();
        try{
        ls = RetrieveLoanAccounts.getLoanContracts(null,null,status,additionalFields,ChildObjectMap);
        }
        catch(Exception e)
        {
            system.debug('Contract Id and Borrower ID is missing'+e.getMessage());
            
        }
        system.assertEquals(ls.size(), 0);
        Test.stopTest();
    }

}
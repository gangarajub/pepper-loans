@isTest
public class TestGenerateRandomNumber {
    public static testmethod void generateCRNTest(){
        loan.TestHelper.createSeedDataForTesting();
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
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        List<loan__Loan_Account__c> loan_app1 =[select id,name from loan__Loan_Account__c  where id=:loan_app.Id];
        if(loan_app1.size()>0){
            System.debug('loan_app1'+loan_app1[0].name);
        }
        Test.startTest();
         
        GenerateRandomNumber gen = new GenerateRandomNumber();
        String str1 = gen.generateCRN(loan_app1[0].name);
        String str = gen.generateReferralCode(loan_app1[0].name);
        System.assertNotEquals(str1,null);
        System.assertNotEquals(str1,null);
        Test.stopTest();
    }

}
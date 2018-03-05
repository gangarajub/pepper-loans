@isTest
public class TestGenerateContract {
	public static testmethod void generateContractUnSecured(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        //create Currency
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
        loan__Loan_Account__c cl = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        loan__Transaction_Summary__c trans = new loan__Transaction_Summary__c();
        trans.loan__Loan_Account__c = cl.id;
        trans.loan__Type__c = 'Credit';
        insert trans;
        loan__Interest_Posting_Transaction__c inpt = new loan__Interest_Posting_Transaction__c();
        inpt.loan__Loan_Contract__c=cl.Id;
        inpt.loan__Interest_Posted__c=12;
        insert inpt;
        
        clcommon__CL_Product__c clpc = new clcommon__CL_Product__c();
        clpc.Lending_Product__c = dummyLP.id;
        clpc.PL_Product__c = 'UNSECURED';
        clpc.clcommon__Product_Name__c = 'Unsecured Product';
        insert clpc;
        
        genesis__Applications__c gac = genesis.TestHelper.createApplication();
        gac.CL_Contract__c = cl.id;
        gac.genesis__CL_Product__c = clpc.id;
        update gac;
        
        loop__DDP__c loop_ddc = new loop__DDP__c();
        loop_ddc.Name = 'Contract DDP';
        insert loop_ddc;
        Loop__DDP_Integration_Option__c ddp_option = new Loop__DDP_Integration_Option__c();
        ddp_option.Name = 'Email';
        ddp_option.Loop__DDP__c = loop_ddc.id;
        
        insert ddp_option;
        Test.startTest();
        String s = GenerateContract.generate(gac.id);
        system.assertEquals('Generating Contract..', s);
        Test.stopTest();
        
    }
    
    public static testmethod void generateContractSecured(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        //create Currency
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
        loan__Loan_Account__c cl = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        loan__Transaction_Summary__c trans = new loan__Transaction_Summary__c();
        trans.loan__Loan_Account__c = cl.id;
        trans.loan__Type__c = 'Credit';
        insert trans;
        loan__Interest_Posting_Transaction__c inpt = new loan__Interest_Posting_Transaction__c();
        inpt.loan__Loan_Contract__c=cl.Id;
        inpt.loan__Interest_Posted__c=12;
        insert inpt;
        
        clcommon__CL_Product__c clpc = new clcommon__CL_Product__c();
        clpc.Lending_Product__c = dummyLP.id;
        clpc.PL_Product__c = 'SECURED';
        clpc.clcommon__Product_Name__c = 'Secured Product';
        insert clpc;
        
        genesis__Applications__c gac = genesis.TestHelper.createApplication();
        gac.CL_Contract__c = cl.id;
        gac.genesis__CL_Product__c = clpc.id;
        update gac;
        
        
        loop__DDP__c loop_ddc = new loop__DDP__c();
        loop_ddc.Name = 'Secured Contract DDP';
        insert loop_ddc;
        Loop__DDP_Integration_Option__c ddp_option = new Loop__DDP_Integration_Option__c();
        ddp_option.Name = 'Email';
        ddp_option.Loop__DDP__c = loop_ddc.id;
        
        insert ddp_option;
        Test.startTest();
        String s = GenerateContract.generate(gac.id);
        system.assertEquals('Generating Contract..', s);
        Test.stopTest();
    }
}
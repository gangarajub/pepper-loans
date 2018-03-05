@isTest
public class TestDownloadAccountStatement {
    public static testmethod void generateStatement(){
        loan.TestHelper.createSeedDataForTesting();
        
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
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
        cl.loan__Loan_Status__c='Approved';
        update cl;
        
            //Test.startTest();
        loan__Transaction_Summary__c trans = new loan__Transaction_Summary__c();
        trans.loan__Loan_Account__c = cl.id;
        //trans.loan__Transaction_Id__c = charge.id;
        insert trans;
        loan__Payment_Mode__c modes = new loan__Payment_Mode__c();
        modes.Name = 'Direct Credit';
        insert modes;
        
        loan__Loan_Disbursal_Transaction__c disbursed = new loan__Loan_Disbursal_Transaction__c();
        disbursed.loan__Loan_Account__c = cl.id;
        insert disbursed;
        System.debug('Hellow');
        
        //loan__Loan_Payment_Transaction__c pays = new loan__Loan_Payment_Transaction__c();
        //pays.loan__Loan_Account__c = cl.id;
        //pays.loan__Transaction_Amount__c = 100;
        //pays.loan__Payment_Mode__c = modes.id;
        //insert pays;
        //Test.stopTest();
        
       /*
        loan__Other_Transaction__c oth = new loan__Other_Transaction__c();
        oth.loan__Transaction_Type__c = loan.LoanConstants.LOAN_ACCOUNT_OTHER_LOAN_TRANSACTION;
        oth.loan__Total_Fees_Due__c = 500 ;
        oth.loan__Txn_Amt__c = 100;
        oth.loan__Loan_Account__C = cl.Id;
        insert oth;  
        */
        
        System.debug('Hellow1');
        
        
        loop__DDP__c loop_ddc = new loop__DDP__c();
        loop_ddc.Name = 'Loan Account Statement';
        insert loop_ddc;
    System.debug('Hellow2');
        Loop__DDP_Integration_Option__c ddp_option = new Loop__DDP_Integration_Option__c();
        ddp_option.Name = 'Attach';
        ddp_option.Loop__DDP__c = loop_ddc.id;
        
        insert ddp_option;
        System.debug('Hellow3');
        Test.startTest();
        loan__Loan_Payment_Transaction__c pays = new loan__Loan_Payment_Transaction__c();
        pays.loan__Loan_Account__c = cl.id;
        pays.loan__Transaction_Amount__c = 100;
        pays.loan__Payment_Mode__c = modes.id;
        insert pays;
        String s = DownloadAccountStatement.generateStatement(cl.id);
        system.assertEquals('Generating Borrower Statement..', s);
        Test.stopTest();
        
    }
    public static testmethod void generateContract(){
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
        loop__DDP__c loop_ddc = new loop__DDP__c();
        loop_ddc.Name = 'Contract DDP Internal';
        insert loop_ddc;
        Loop__DDP_Integration_Option__c ddp_option = new Loop__DDP_Integration_Option__c();
        ddp_option.Name = 'Email';
        ddp_option.Loop__DDP__c = loop_ddc.id;
        
        insert ddp_option;
        Test.startTest();
        String s = DownloadAccountStatement.generateContract(cl.id);
        system.assertEquals('Generating Contract..', s);
        Test.stopTest();
        
    }
     public static testmethod void generateStatementWithCharges(){
        loan.TestHelper.createSeedDataForTesting();
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
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
        cl.loan__Loan_Status__c='Approved';
        update cl;
        
        
        loan__Transaction_Summary__c trans = new loan__Transaction_Summary__c();
        trans.loan__Loan_Account__c = cl.id;
        insert trans;
        loan__Payment_Mode__c modes = new loan__Payment_Mode__c();
        modes.Name = 'Direct Credit';
        insert modes;
        
        loan__Loan_Disbursal_Transaction__c disbursed = new loan__Loan_Disbursal_Transaction__c();
        disbursed.loan__Loan_Account__c = cl.id;
        insert disbursed;
        /*
         loan__Charge__C dummyCharge = new loan__Charge__C( loan__Loan_Account__c  = cl.id,
                                                    loan__Paid__c = True,
                                                    loan__Waive__c = True,
                                                    loan__Date__c  = myDate,
                                                    loan__Fee__c = dummyFee.id
                                                    );                                              
        insert dummyCharge;
*/
        //loan__Loan_Payment_Transaction__c pays = new loan__Loan_Payment_Transaction__c();
        //pays.loan__Loan_Account__c = cl.id;
        //pays.loan__Transaction_Amount__c = 100;
        //pays.loan__Payment_Mode__c = modes.id;
        //insert pays;
        
               
        
        
        loan__Payoff_Quote__c payoff = new loan__Payoff_Quote__c();
        payoff.loan__Loan_Account__c=cl.id;
        insert payoff;
         
        loop__DDP__c loop_ddc = new loop__DDP__c();
        loop_ddc.Name = 'Loan Account Statement';
        insert loop_ddc;
    
        Loop__DDP_Integration_Option__c ddp_option = new Loop__DDP_Integration_Option__c();
        ddp_option.Name = 'Attach';
        ddp_option.Loop__DDP__c = loop_ddc.id;
        
        insert ddp_option;
        Test.startTest();
         loan__Loan_Payment_Transaction__c pays = new loan__Loan_Payment_Transaction__c();
        pays.loan__Loan_Account__c = cl.id;
        pays.loan__Transaction_Amount__c = 100;
        pays.loan__Payment_Mode__c = modes.id;
        insert pays;
        
        String s = DownloadAccountStatement.generateStatement(cl.id);
        system.assertEquals('Generating Borrower Statement..', s);
        Test.stopTest();
        
    }

}
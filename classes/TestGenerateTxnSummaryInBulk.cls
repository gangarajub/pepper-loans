@isTest(SeeAllData = false)
public class TestGenerateTxnSummaryInBulk{
    public static  testMethod void method1(){
                
        loan.TestHelper.createSeedDataForTesting();
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
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
        loan_app1[0].loan__Is_Interest_Posting_Enabled__c = true;
        loan_app1[0].loan__Is_Capitalization_Enabled__c = true;
        loan_app1[0].loan__Next_Interest_Posting_Date__c = myDate - 4;
        loan_app1[0].loan__Interest_Posting_Day__c = loan_app1[0].loan__Next_Interest_Posting_Date__c.day();
        loan_app1[0].loan__Interest_Posting_Frequency__c = loan.LoanConstants.LOAN_PAYMENT_FREQ_MONTHLY;
        loan_app1[0].loan__Disbursal_Date__c=myDate;
        update loan_app1[0];
        loan__Payment_Mode__c pMode = [select ID from loan__Payment_Mode__c limit 1];
        loan__Loan_Disbursal_Transaction__c dTxn = new loan__Loan_Disbursal_Transaction__c();
        dTxn.loan__Loan_Account__c = loan_app1[0].ID;
        dTxn.loan__Mode_of_Payment__c = pMode.ID;
        dTxn.loan__Disbursal_Date__c = myDate+5;
        insert dTxn;
        loan__Charge__C dummyCharge = new loan__Charge__C( loan__Loan_Account__c  = loan_app1[0].id,
                                                    loan__Paid__c = True,
                                                    loan__Waive__c = True,
                                                    loan__Date__c  = myDate,
                                                    loan__Fee__c = dummyFee.id
                                                    );                                              
        insert dummyCharge;
        loan__Other_Transaction__c oth = new loan__Other_Transaction__c();
        oth.loan__Transaction_Type__c = loan.LoanConstants.LOAN_ACCOUNT_OTHER_LOAN_TRANSACTION;
        oth.loan__Txn_Date__c =myDate;
        oth.loan__Total_Fees_Due__c = 500 ;
        oth.loan__Txn_Amt__c = 100;
        oth.loan__Loan_Account__C = loan_app1[0].ID;
        insert oth;
        
        
         
        List<loan__Loan_Account__c> lList = new List<loan__Loan_Account__c>();
        lList.add(loan_app);
        Test.startTest();       
        loan__Loan_Payment_Transaction__c pTxn = new loan__Loan_Payment_Transaction__c();
        pTxn.loan__Loan_Account__c = loan_app1[0].ID;
        pTxn.loan__Payment_Mode__c = pMode.ID;
        pTxn.loan__Receipt_Date__c = myDate;
        pTxn.loan__Transaction_Amount__c = 1000;
        pTxn.loan__Transaction_Date__c = myDate;
        insert pTxn; 
        System.debug('---pTxn--- ' + pTxn);
        loan__Repayment_Transaction_Adjustment__c revtxn = new loan__Repayment_Transaction_Adjustment__c();
        revTXn.loan__Loan_Payment_Transaction__c = ptxn.id;
        insert revtxn;
        GenerateTxnSummaryInBulk j = new GenerateTxnSummaryInBulk();
        Database.executeBatch(j);
        Test.stopTest();
        
    }
      public static testMethod void method2(){
        loan.TestHelper.createSeedDataForTesting();
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
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
        loan_app1[0].loan__Loan_Status__c=loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        update  loan_app1[0];
        loan__Interest_Posting_Transaction__c inpt = new loan__Interest_Posting_Transaction__c();
        inpt.loan__Loan_Contract__c=loan_app1[0].Id;
        inpt.loan__Transaction_Creation_Date__c=myDate.toStartofMonth();
        insert inpt;
        
        Test.startTest();
        
        GenerateTxnSummaryInBulk j = new GenerateTxnSummaryInBulk();
        Database.executeBatch(j);
        Test.stopTest();
        
    }
     
}
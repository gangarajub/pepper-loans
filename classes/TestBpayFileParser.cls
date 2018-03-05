@isTest
public class TestBpayFileParser {
    public static testmethod void testBpay(){
        TestHelper.createReportConfiguration();
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
        loan_app1[0].CRN__c = '000003804';
        update loan_app1[0];
        loan__Payment_Mode__c pMode = [select ID from loan__Payment_Mode__c limit 1];
        loan__Payment_Mode__C pMode1 = new loan__Payment_Mode__c(Name='Bpay');
        insert pMode1;
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
        
        test.startTest();
        loan__Loan_Payment_Transaction__c pTxn = new loan__Loan_Payment_Transaction__c();
        pTxn.loan__Loan_Account__c = loan_app1[0].ID;
        pTxn.loan__Payment_Mode__c = pMode.ID;
        pTxn.loan__Receipt_Date__c = myDate;
        pTxn.loan__Transaction_Amount__c = 1000;
        pTxn.loan__Transaction_Date__c = myDate;
        insert pTxn; 
        
        String filecontent = '040368PEPPER PERSONAL LOAN        20320996437300000003052015\r\n1000003804                    B00000010000IB          2   0000000000NAB1209201631023702089310000\r\n9000000001000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000\r\n';
        
        BpayFileParser bpay = new BPayFileParser();
        bpay.getTrasactions(fileCOntent);
        test.stopTest();
    }
}
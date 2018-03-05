@isTest(SeeAllData = false)
public class TestChargeUtil {
    public static testMethod void method1(){
        TestHelper.createReportConfiguration();
        loan.TestHelper.createSeedDataForTesting();
         
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        RetrieveCode__c rc = new RetrieveCode__c();
        //loan.TestHelper.systemDate = Date.Today();
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
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        
         genesis__applications__c gac = genesis.TestHelper.createApplication();
         gac.Channel__c = 'DIRECT';
         update gac;
         
         List<loan__Loan_Account__c> loan_app1 =[select id,name from loan__Loan_Account__c  where id=:loan_app.Id];
        loan_app1[0].loan__Is_Interest_Posting_Enabled__c = true;
        loan_app1[0].loan__Is_Capitalization_Enabled__c = true;
        loan_app1[0].loan__Next_Interest_Posting_Date__c = myDate - 4;
        loan_app1[0].loan__Interest_Posting_Day__c = loan_app1[0].loan__Next_Interest_Posting_Date__c.day();
        loan_app1[0].loan__Interest_Posting_Frequency__c = loan.LoanConstants.LOAN_PAYMENT_FREQ_MONTHLY;
        loan_app1[0].loan__Disbursal_Date__c=myDate;
        loan_app1[0].application__c = gac.id;
        loan_app1[0].loan__Interest_Remaining__c = 100;
        loan_app1[0].loan__Fees_Remaining__c = 0;
        loan_app1[0].loan__Total_Due_Charges__c = 0;
        loan_app1[0].loan__Product_Type__c = 'LOAN';
        loan_app1[0].loan__Frequency_of_Loan_Payment__c = 'MONTHLY';
        loan_app1[0].loan__Pay_Off_Amount_As_Of_Today__c = 0;
        loan_app1[0].loan__Time_Counting_Method__c = loan.LoanConstants.TIME_COUNTING_MONTH_AND_DAYS;
        loan_app1[0].loan__Interest_Calculation_Method__c = loan.LoanConstants.REPAYMENT_INT_CALC_METHOD_FLAT;
        loan_app1[0].loan__Principal_Adjustment_Subtract__c = 0;
        loan_app1[0].loan__Principal_Adjustment__c = 0;
        loan_app1[0].loan__Loan_Amount__c = 10000;
        loan_app1[0].loan__Interest_Rate__c=10;
        loan_app1[0].loan__Last_Accrual_Date__c = myDate;
        loan_app1[0].loan__Pay_Off_Amount_As_Of_Today__c = 10000;
        loan_app1[0].loan__Capitalized_Fee__c = 10;
        loan_app1[0].loan__Interest_Accrued_Not_Due__c = 0;
        loan_app1[0].loan__Capitalized_Interest__c = null;
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
        
        loan__Interest_Posting_Transaction__c ipt = new loan__Interest_Posting_Transaction__c();
        ipt.loan__capitalization_date__c = myDate;
        ipt.loan__interest_rate__c = 10;
        ipt.loan__Loan_Contract__c = loan_app1[0].id;
        insert ipt;
        
        loan__Other_Transaction__c oth = new loan__Other_Transaction__c();
        oth.loan__Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_REFUND;
        oth.loan__Txn_Date__c =myDate;
        oth.loan__Total_Fees_Due__c = 500 ;
        oth.loan__Txn_Amt__c = 100;
        oth.loan__Loan_Account__C = loan_app1[0].ID;
        insert oth;
        
        ChargeUtil.updateLoanAddCharge(loan_app1[0], 10);
        ChargeUtil.updateLoanRemoveCharge(loan_app1[0], 10);
        ChargeUtil.updateLoanCapitalizeCharge(loan_app1[0], 10, Date.today());
        Test.startTest();
        ChargeUtil.WaiveCharge(dummyCharge.id);
        ChargeUtil.findSameChargeAppliedWithinMinimumDays(new List<loan__Charge__c>{dummyCharge}, dummyFee, Date.today());
        Test.stopTest();
    } 
    
    public static testMethod void method2(){
        ChargeUtil.findSameChargeAppliedWithinMinimumDays(null, new loan__Fee__c(), Date.today());
    }   
    
    public static testMethod void method3(){
        TestHelper.createReportConfiguration();
        loan.TestHelper.createSeedDataForTesting();
         
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        RetrieveCode__c rc = new RetrieveCode__c();
        //loan.TestHelper.systemDate = Date.Today();
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
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        
         genesis__applications__c gac = genesis.TestHelper.createApplication();
         gac.Channel__c = 'DIRECT';
         update gac;
         
         List<loan__Loan_Account__c> loan_app1 =[select id,name from loan__Loan_Account__c  where id=:loan_app.Id];
        loan_app1[0].loan__Is_Interest_Posting_Enabled__c = true;
        loan_app1[0].loan__Is_Capitalization_Enabled__c = true;
        loan_app1[0].loan__Next_Interest_Posting_Date__c = myDate - 4;
        loan_app1[0].loan__Interest_Posting_Day__c = loan_app1[0].loan__Next_Interest_Posting_Date__c.day();
        loan_app1[0].loan__Interest_Posting_Frequency__c = loan.LoanConstants.LOAN_PAYMENT_FREQ_MONTHLY;
        loan_app1[0].loan__Disbursal_Date__c=myDate;
        loan_app1[0].application__c = gac.id;
        loan_app1[0].loan__Interest_Remaining__c = 100;
        loan_app1[0].loan__Fees_Remaining__c = 0;
        loan_app1[0].loan__Total_Due_Charges__c = 0;
        loan_app1[0].loan__Frequency_of_Loan_Payment__c = 'MONTHLY';
        loan_app1[0].loan__Pay_Off_Amount_As_Of_Today__c = 0;
        loan_app1[0].loan__Time_Counting_Method__c = loan.LoanConstants.TIME_COUNTING_MONTH_AND_DAYS;
        loan_app1[0].loan__Interest_Calculation_Method__c = loan.LoanConstants.REPAYMENT_INT_CALC_METHOD_FLAT;
        loan_app1[0].loan__Principal_Adjustment_Subtract__c = 0;
        loan_app1[0].loan__Principal_Adjustment__c = 0;
        loan_app1[0].loan__Loan_Amount__c = 10000;
        loan_app1[0].loan__Interest_Rate__c=10;
        loan_app1[0].loan__Last_Accrual_Date__c = myDate;
        loan_app1[0].loan__Pay_Off_Amount_As_Of_Today__c = 10000;
        loan_app1[0].loan__Capitalized_Fee__c = 10;
        loan_app1[0].loan__Interest_Accrued_Not_Due__c = 0;
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
        
        loan__Interest_Posting_Transaction__c ipt = new loan__Interest_Posting_Transaction__c();
        ipt.loan__capitalization_date__c = myDate;
        ipt.loan__interest_rate__c = 10;
        ipt.loan__Loan_Contract__c = loan_app1[0].id;
        insert ipt;
        
        loan__Other_Transaction__c oth = new loan__Other_Transaction__c();
        oth.loan__Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_REFUND;
        oth.loan__Txn_Date__c =myDate;
        oth.loan__Total_Fees_Due__c = 500 ;
        oth.loan__Txn_Amt__c = 100;
        oth.loan__Loan_Account__C = loan_app1[0].ID;
        insert oth;
        
        ChargeUtil.updateLoanAddCharge(loan_app1[0], 10);
        ChargeUtil.updateLoanRemoveCharge(loan_app1[0], 10);
        ChargeUtil.updateLoanCapitalizeCharge(loan_app1[0], 10, Date.today());
        Test.startTest();
        ChargeUtil.WaiveCharge(dummyCharge.id);
        ChargeUtil.findSameChargeAppliedWithinMinimumDays(new List<loan__Charge__c>{dummyCharge}, dummyFee, Date.today());
        Test.stopTest();
    } 
}
@isTest(SeeAllData = false)
public class TestGLCSVFileGeneratorJob{
    
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
        oth.loan__Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_REFUND;
        oth.loan__Txn_Date__c =myDate;
        oth.loan__Total_Fees_Due__c = 500 ;
        oth.loan__Txn_Amt__c = 100;
        oth.loan__Loan_Account__C = loan_app1[0].ID;
        insert oth;
        Test.startTest(); 
        loan__Loan_Payment_Transaction__c pTxn = new loan__Loan_Payment_Transaction__c();
        pTxn.loan__Loan_Account__c = loan_app1[0].ID;
        pTxn.loan__Payment_Mode__c = pMode.ID;
        pTxn.loan__Receipt_Date__c = myDate;
        pTxn.loan__Transaction_Amount__c = 1000;
        pTxn.loan__Transaction_Date__c = myDate;
        insert pTxn; 
        System.debug('---pTxn--- ' + pTxn);
         
        List<loan__Loan_Account__c> lList = new List<loan__Loan_Account__c>();
        lList.add(loan_app);
              
        loan__Repayment_Transaction_Adjustment__c revtxn = new loan__Repayment_Transaction_Adjustment__c();
        revTXn.loan__Loan_Payment_Transaction__c = ptxn.id;
        revTXn.loan__Cleared__c = true;
        revTXn.loan__Adjustment_Txn_Date__c = myDate;
        insert revtxn;
         
        GL_Account_Junction__c gajc = new GL_Account_Junction__c();
        gajc.GL_Code__c = '123456';
        gajc.Amount_Type__c = 'TOTALDISBURSMENTAMOUNT';
        gajc.Loan_Product__c = dummyLP.id;
        gajc.Channel__c = 'DIRECT';
        gajc.Transaction_Type__c = 'Credit';
        insert gajc;
 
        GL_Account_Junction__c gajc1 = new GL_Account_Junction__c(GL_Code__c = '123456', Amount_Type__c = 'TOTALDISBURSMENTAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc1;
 
        GL_Account_Junction__c gajc2 = new GL_Account_Junction__c(GL_Code__c = '123457', Amount_Type__c = 'REFUNDTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc2;
 
        GL_Account_Junction__c gajc3 = new GL_Account_Junction__c(GL_Code__c = '123458', Amount_Type__c = 'REFUNDTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc3;
          
        GL_Account_Junction__c gajc4 = new GL_Account_Junction__c(GL_Code__c = '123459', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc4;
 
        GL_Account_Junction__c gajc5 = new GL_Account_Junction__c(GL_Code__c = '123450', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc5; 
         
         GL_Account_Junction__c gajc41 = new GL_Account_Junction__c(GL_Code__c = '123459', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc41;
 
        GL_Account_Junction__c gajc51 = new GL_Account_Junction__c(GL_Code__c = '123450', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc51; 
         GL_Account_Junction__c gajc6 = new GL_Account_Junction__c(GL_Code__c = '123422', Amount_Type__c = 'LOANPAYMENTREVERSALAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc6;
 
        GL_Account_Junction__c gajc7 = new GL_Account_Junction__c(GL_Code__c = '123433', Amount_Type__c = 'LOANPAYMENTREVERSALAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc7; 
         GL_Account_Junction__c gajc61 = new GL_Account_Junction__c(GL_Code__c = '1234221', Amount_Type__c = 'INTERESTACCRUEDAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc61;
 
        GL_Account_Junction__c gajc71 = new GL_Account_Junction__c(GL_Code__c = '1234331', Amount_Type__c = 'INTERESTACCRUEDAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc71;
         GL_Account_Junction__c gajc62 = new GL_Account_Junction__c(GL_Code__c = '12342212', Amount_Type__c = 'WRITTENOFFAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc62;
 
        GL_Account_Junction__c gajc72 = new GL_Account_Junction__c(GL_Code__c = '12343312', Amount_Type__c = 'WRITTENOFFAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc72;
          Date iDate = Date.newInstance(2016, 03, 01);
        GLCSVFileGenerationJob job = new GLCSVFileGenerationJob(iDate, 100);
        Database.executeBatch(job,100);
    } 
    
    public static testMethod void method2(){
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
        oth.loan__Transaction_Type__c = loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_SUB;
        oth.loan__Txn_Date__c =myDate;
        oth.loan__Total_Fees_Due__c = 500 ;
        oth.loan__Txn_Amt__c = 100;
        oth.loan__Loan_Account__C = loan_app1[0].ID;
        insert oth;
        
        Test.startTest();
        loan__Loan_Payment_Transaction__c pTxn = new loan__Loan_Payment_Transaction__c();
        pTxn.loan__Loan_Account__c = loan_app1[0].ID;
        pTxn.loan__Payment_Mode__c = pMode.ID;
        pTxn.loan__Receipt_Date__c = myDate;
        pTxn.loan__Transaction_Amount__c = 1000;
        pTxn.loan__Transaction_Date__c = myDate;
        insert pTxn; 
        System.debug('---pTxn--- ' + pTxn);
         
        List<loan__Loan_Account__c> lList = new List<loan__Loan_Account__c>();
        lList.add(loan_app);
        //Test.startTest();       
        loan__Repayment_Transaction_Adjustment__c revtxn = new loan__Repayment_Transaction_Adjustment__c();
        revTXn.loan__Loan_Payment_Transaction__c = ptxn.id;
        revTXn.loan__Cleared__c = true;
        revTXn.loan__Adjustment_Txn_Date__c = myDate;
        insert revtxn;
        
        loan__Interest_Posting_Transaction__c ipt = new loan__Interest_Posting_Transaction__c();
        ipt.loan__Loan_Contract__c = loan_app1[0].ID;
        ipt.loan__Transaction_Creation_Date__c = myDate;
        ipt.loan__Interest_Posted__c = 100;
        insert ipt;
        
        Contact accBroker = new Contact();
        accBroker.LastName = 'Nino Eid';
        accBroker.Referral_Code__c = '3645';
        accBroker.loan__Contact_Type__c = 'Broker';
        accBroker.MobilePhone = '12345678';
        insert accBroker;
        
        loan__Broker__c lb = new loan__Broker__c();
        lb.loan__Lending_Account__c = loan_app1[0].ID;
        lb.loan__Commission_Amount__c = 100;
        lb.loan__Contact__c = accBroker.id;
        insert lb;
        
        loan__Broker_Transactions__c lbt = new loan__Broker_Transactions__c();
        lbt.loan__Broker__c = lb.ID;
        lbt.loan__Sent_To_Ach_on__c = myDate;
        insert lbt;
         
        GL_Account_Junction__c gajc = new GL_Account_Junction__c();
        gajc.GL_Code__c = '123456';
        gajc.Amount_Type__c = 'TOTALDISBURSMENTAMOUNT';
        gajc.Loan_Product__c = dummyLP.id;
        gajc.Channel__c = 'DIRECT';
        gajc.Transaction_Type__c = 'Credit';
        insert gajc;
 
        GL_Account_Junction__c gajc1 = new GL_Account_Junction__c(GL_Code__c = '123456', Amount_Type__c = 'TOTALDISBURSMENTAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc1;
 
        GL_Account_Junction__c gajc2 = new GL_Account_Junction__c(GL_Code__c = '123457', Amount_Type__c = 'REFUNDTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc2;
 
        GL_Account_Junction__c gajc3 = new GL_Account_Junction__c(GL_Code__c = '123458', Amount_Type__c = 'REFUNDTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc3;
          
        GL_Account_Junction__c gajc4 = new GL_Account_Junction__c(GL_Code__c = '123459', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc4;
 
        GL_Account_Junction__c gajc5 = new GL_Account_Junction__c(GL_Code__c = '123450', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc5; 
         
         GL_Account_Junction__c gajc41 = new GL_Account_Junction__c(GL_Code__c = '123459', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc41;
 
        GL_Account_Junction__c gajc51 = new GL_Account_Junction__c(GL_Code__c = '123450', Amount_Type__c = 'LOANPAYMENTTRANSACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc51; 
         GL_Account_Junction__c gajc6 = new GL_Account_Junction__c(GL_Code__c = '123422', Amount_Type__c = 'LOANPAYMENTREVERSALAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc6;
 
        GL_Account_Junction__c gajc7 = new GL_Account_Junction__c(GL_Code__c = '123433', Amount_Type__c = 'LOANPAYMENTREVERSALAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc7; 
         GL_Account_Junction__c gajc61 = new GL_Account_Junction__c(GL_Code__c = '1234221', Amount_Type__c = 'INTERESTACCRUEDAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc61;
 
        GL_Account_Junction__c gajc71 = new GL_Account_Junction__c(GL_Code__c = '1234331', Amount_Type__c = 'INTERESTACCRUEDAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc71;
         GL_Account_Junction__c gajc62 = new GL_Account_Junction__c(GL_Code__c = '12342212', Amount_Type__c = 'WRITTENOFFAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc62;
 
        GL_Account_Junction__c gajc72 = new GL_Account_Junction__c(GL_Code__c = '12343312', Amount_Type__c = 'WRITTENOFFAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc72;
           GL_Account_Junction__c gajc621 = new GL_Account_Junction__c(GL_Code__c = '12342212', Amount_Type__c = 'PRINCIPALSUBTRACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc621;
 
        GL_Account_Junction__c gajc721 = new GL_Account_Junction__c(GL_Code__c = '12343312', Amount_Type__c = 'PRINCIPALSUBTRACTIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc721;
        
        GL_Account_Junction__c gajc622 = new GL_Account_Junction__c(GL_Code__c = '12342212', Amount_Type__c = 'INTERESTCHARGEDAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc622;
 
        GL_Account_Junction__c gajc722 = new GL_Account_Junction__c(GL_Code__c = '12343312', Amount_Type__c = 'INTERESTCHARGEDAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc722;
        GL_Account_Junction__c gajc623 = new GL_Account_Junction__c(GL_Code__c = '12342212', Amount_Type__c = 'CHARGEAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc623;
 
        GL_Account_Junction__c gajc723 = new GL_Account_Junction__c(GL_Code__c = '12343312', Amount_Type__c = 'CHARGEAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc723;
        
        GL_Account_Junction__c gajc624 = new GL_Account_Junction__c(GL_Code__c = '12342212', Amount_Type__c = 'COMMISSIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Credit');
        insert gajc624;
 
        GL_Account_Junction__c gajc724 = new GL_Account_Junction__c(GL_Code__c = '12343312', Amount_Type__c = 'COMMISSIONAMOUNT',
                                                                Loan_Product__c = dummyLP.id, Channel__c = 'DIRECT',
                                                                 Transaction_Type__c = 'Debit');
        insert gajc724;
        
          Date iDate = Date.newInstance(2016, 03, 01);
        GLCSVFileGenerationJob job = new GLCSVFileGenerationJob(iDate, 100);
        Database.executeBatch(job,100);
        
        Test.stopTest();
    } 
    
    public static testMethod void method3(){
        TestHelper.createReportConfiguration();
        loan.TestHelper.createSeedDataForTesting();
        
         loan__Custom_Logic_Parameters__c clp = new loan__Custom_Logic_Parameters__c();
         clp.loan__Reversal_Class__c = 'CustomBulkRepaymentAdjustmentAction';
         insert clp;
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
        //loan_app1[0].loan__product_type__C = loan.LoanConstants.AMZ;
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
        Test.startTest();  
        loan__Interest_Posting_Transaction__c ipt = new loan__Interest_Posting_Transaction__c();
        ipt.loan__Is_Capitalized__c = true;
        ipt.Adjustment_Transaction__c = false;
        ipt.loan__Balance__c = 100;
        ipt.loan__Capitalization_Date__c = myDate;
        ipt.loan__Transaction_Creation_Date__c = myDate;
        ipt.loan__Interest_Rate__c = 10;
        ipt.loan__Loan_Contract__c = loan_app1[0].id;
        
        insert ipt;
        
        loan__charge__c ch = new loan__charge__c();
        ch.loan__Loan_Account__c = loan_app1[0].id;
        ch.loan__Fee__c = dummyFee.id;
        ch.loan__Interest_Rate__c = 10;
        ch.loan__Date__c = myDate;
        ch.loan__Original_Amount__c= 35;
        insert ch;
        
        loan__Loan_Payment_Transaction__c pTxn = new loan__Loan_Payment_Transaction__c();
        pTxn.loan__Loan_Account__c = loan_app1[0].id;
        pTxn.loan__Payment_Mode__c = pMode.ID;
        pTxn.loan__Receipt_Date__c = myDate;
        pTxn.loan__Transaction_Amount__c = 1000;
        pTxn.loan__Transaction_Date__c = myDate;
        insert pTxn; 
        System.debug('---pTxn--- ' + pTxn);
        
        loan__Interest_Posting_Loan_Payment__c iptl = new loan__Interest_Posting_Loan_Payment__c();
        iptl.loan__Interest_Paid__c = 10;
        iptl.loan__Interest_Posting_Transaction__c = ipt.id;
        iptl.loan__Loan_Payment_Transaction__c = pTxn.id;
        insert iptl;
        
        
        loan__Interest_Posting_Transaction__c ipt1 = new loan__Interest_Posting_Transaction__c();
        ipt1.loan__Is_Capitalized__c = true;
        ipt1.Adjustment_Transaction__c = false;
        ipt1.loan__Balance__c = 100;
        ipt1.loan__Capitalization_Date__c = myDate;
        ipt1.loan__Transaction_Creation_Date__c = myDate;
        ipt1.loan__Interest_Rate__c = 10;
        ipt1.loan__Loan_Contract__c = loan_app1[0].id;
        
        insert ipt1;
        
        loan__Loan_Payment_Transaction__c pTxn1 = new loan__Loan_Payment_Transaction__c();
        pTxn1.loan__Loan_Account__c = loan_app1[0].id;
        pTxn1.loan__Payment_Mode__c = pMode.ID;
        pTxn1.loan__Receipt_Date__c = myDate;
        pTxn1.loan__Transaction_Amount__c = 1000;
        pTxn1.loan__Transaction_Date__c = myDate;
        insert pTxn1; 
        System.debug('---pTxn--- ' + pTxn);
        
        loan__Interest_Posting_Loan_Payment__c ipt2 = new loan__Interest_Posting_Loan_Payment__c();
        ipt2.loan__Interest_Paid__c = 10;
        ipt2.loan__Interest_Posting_Transaction__c = ipt1.id;
        ipt2.loan__Loan_Payment_Transaction__c = pTxn1.id;
        insert ipt2;
         
        List<loan__Loan_Account__c> lList = new List<loan__Loan_Account__c>();
        lList.add(loan_app);
        
        loan__Repayment_Transaction_Adjustment__c revtxn = new loan__Repayment_Transaction_Adjustment__c();
        revTXn.loan__Loan_Payment_Transaction__c = ptxn.id;
        revTxn.loan__cleared__c = true;
        revTxn.loan__Adjustment_Txn_Date__c = myDate;
        revTxn.loan__Balance__c = 1000;
        revTxn.loan__Interest_Rate__c = 11.99;
        
        insert revtxn;
                
        CustomBulkRepaymentAdjustmentAction cp = new CustomBulkRepaymentAdjustmentAction(new List<loan__Repayment_Transaction_Adjustment__c>{revtxn});
        cp.rejectRepaymentsAdjusment();
        
        CustomBulkRepaymentAdjustmentAction.createInterestPostingTransaction(loan_app1[0], 1000, Date.today());
        
        test.stopTest();
    } 
    
     public static testMethod void positiveMethod1(){
        //TestHelper.createReportConfiguration();
        loan.TestHelper.createSeedDataForTesting();
         loan__Custom_Logic_Parameters__c clp = new loan__Custom_Logic_Parameters__c();
         clp.loan__Reversal_Class__c = 'CustomBulkRepaymentAdjustmentAction';
         insert clp;
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr); 
        dummyFee.loan__Is_Fee_Capitalized__c = true;
        update dummyFee;                                    
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
        loan_app1[0].loan__Is_Interest_Posting_Enabled__c = false;
        loan_app1[0].loan__Is_Capitalization_Enabled__c = false;
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
        loan__Trigger_Parameters__c trg = new loan__Trigger_Parameters__c();
        trg.loan__Disable_Charge_trigger__c = true;
        upsert trg;
        loan__Charge__C dummyCharge = new loan__Charge__C( loan__Loan_Account__c  = loan_app1[0].id,
                                                    loan__Paid__c = True,
                                                    loan__Waive__c = True,
                                                    loan__Date__c  = myDate,
                                                    loan__Fee__c = dummyFee.id,
                                                          loan__Original_Amount__c = 100
                                                    );                                              
        insert dummyCharge;
        
        dummyCharge = [select id,loan__Waive__c from loan__Charge__c where id=:dummyCharge.id];
        dummyCharge.loan__Waive__c = true;
        update dummyCharge;
        Charge_Reversal_Transaction__c cTxn = new Charge_Reversal_Transaction__c(Balance__c=1200,Charge__c= dummyCharge.id,CL_Contract__c=loan_app1[0].id,Transaction_Amount__c=100,Transaction_Date__c=myDate);
        insert cTxn;
        loan__Other_Transaction__c oth = new loan__Other_Transaction__c();
        oth.loan__Transaction_Type__c = loan.LoanConstants.LOAN_ACCOUNT_OTHER_LOAN_TRANSACTION;
        oth.loan__Txn_Date__c =myDate;
        oth.loan__Total_Fees_Due__c = 500 ;
        oth.loan__Txn_Amt__c = 100;
        oth.loan__Loan_Account__C = loan_app1[0].ID;
        insert oth;
         Test.startTest();      
        loan__Loan_Payment_Transaction__c pTxn = new loan__Loan_Payment_Transaction__c();
        pTxn.loan__Loan_Account__c = loan_app1[0].id;
        pTxn.loan__Payment_Mode__c = pMode.ID;
        pTxn.loan__Receipt_Date__c = myDate;
        pTxn.loan__Transaction_Amount__c = 1000;
        pTxn.loan__Transaction_Date__c = myDate;
        insert pTxn; 
        System.debug('---pTxn--- ' + pTxn);
         
        List<loan__Loan_Account__c> lList = new List<loan__Loan_Account__c>();
        lList.add(loan_app);
        
        loan__Repayment_Transaction_Adjustment__c revtxn = new loan__Repayment_Transaction_Adjustment__c();
        revTXn.loan__Loan_Payment_Transaction__c = ptxn.id;
        revTxn.loan__cleared__c = true;
        revTxn.loan__Adjustment_Txn_Date__c = myDate;
        revTxn.loan__Balance__c = 1000;
        revTxn.loan__Interest_Rate__c = 11.99;
        
        insert revtxn;
        
        loan__Interest_Posting_Transaction__c ipt = new loan__Interest_Posting_Transaction__c();
        ipt.loan__Is_Capitalized__c = true;
        ipt.Adjustment_Transaction__c = false;
        ipt.loan__Balance__c = 100;
        ipt.loan__Capitalization_Date__c = myDate.addDays(1);
        ipt.loan__Transaction_Creation_Date__c = myDate.addDays(1);
        ipt.loan__Interest_Rate__c = 10;
        ipt.loan__Loan_Contract__c = loan_app1[0].id;
        
        insert ipt;
        
        //CustomBulkRepaymentAdjustmentAction cp = new CustomBulkRepaymentAdjustmentAction(new List<loan__Repayment_Transaction_Adjustment__c>{revtxn});
        //cp.rejectRepaymentsAdjusment();
        
        CustomBulkRepaymentAdjustmentAction.createInterestPostingTransaction(loan_app1[0], 1000, Date.today());
        
        CustomBulkRepaymentAdjustmentAction cs = new CustomBulkRepaymentAdjustmentAction(new List<loan__Repayment_Transaction_Adjustment__c>{revtxn});
        cs.rejectRepaymentsAdjusment();
        //GenerateTransactionListing j = new GenerateTransactionListing(myDate,myDate.addMonths(1));
        //Database.executeBatch(j);
        //ServicerStatement q = new ServicerStatement(myDate,myDate.addMonths(1));
        //Database.executeBatch(q);
        Test.stopTest();
    }
     
}
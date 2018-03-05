@isTest

Public class TestLoanDisbursalFilegenJob1{

    private static loan__Payment_Mode__c ACH;
    private static List<loan__Loan_Account__c> loans;
   
    
    testMethod static void testLoanDisbursalFilegenJob(){
        loan.TestHelper.systemDate = Date.today();
        loan.TestHelper.createSeedDataForTesting();
        loan.TestHelper.setupApprovalProcessForTxn(); // 3 day lock period
        Test.loadData(filegen__File_metadata__c.sObjectType,'Filegen_Metadata');
      
        loan.TestHelper.setupACHParameters();
        
        filegen__Metadata_Segments__c metadata1 = new filegen__Metadata_Segments__c();
        metadata1.filegen__Segment__c='Descriptive_record_header__c';
        metadata1.name='Descriptive_record_header';
        insert metadata1;
        
        filegen__Metadata_Segments__c metadata2 = new filegen__Metadata_Segments__c();
        metadata2.filegen__Segment__c='Detail_record__c';
        metadata2.name='Detail_record';
        insert metadata2;
        
        filegen__Metadata_Segments__c metadata3 = new filegen__Metadata_Segments__c();
        metadata3.filegen__Segment__c='File_Total_Record_Trailer__c';
        metadata3.name='File_Total_Record_Trailer';
        insert metadata3;
        
        loan.TestHelper2.createOrgBankAccounts();
        ACH = [select Id from loan__Payment_Mode__c where Name = 'ACH'];
        loan.TestHelper.systemDate = Date.today().addDays(-200);
        
        //loan__ACH_Parameters__c ach = loan.CustomSettingsUtil.getACHParameters();
        //ach.loan__Days_In_Advance_To_Create_File__c = 0;
       // ach.loan__Multiple_Payment_Method_Support__c =true;
       // upsert ach;
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest', '10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest', '30000 - INCOME');
        loan__Payment_Mode__c pMode = [select id from loan__Payment_Mode__c where Name = 'ACH'];
        loan__Payment_Mode__c pMode1 = [select id from loan__Payment_Mode__c where Name = 'Cash'];
         
        loan__Bank_Account__c bank = [select id from loan__Bank_Account__c where loan__Account_usage__c=:loan.FractionalizationConstants.ADVANCE_TRUST_ACCOUNT limit 1];
        bank.BSB__c='123-456';
        update bank;
        loan.TestHelper2.createAutomatedPaymentConfiguration(loan.LoanConstants.LOAN_DISBURSAL,pMode,bank,'LoanDisbursalTxnPepperFileGen');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr, dummyIncAccount, dummyAccount);
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee, dummyFeeSet);
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        //Create a dummy Loan Product
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(dummyOffice,
                            dummyAccount, 
                            curr, 
                            dummyFeeSet);
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        Account a1 = loan.TestHelper2.createInvestor('Bull', 1000);
        Account b1 = loan.TestHelper2.createBorrower('ShoeString');
         loan__Bank_Account__c ba = new loan__Bank_Account__c(loan__Bank_Account_Number__c = '12',
                                                   Account_Holder_Name__c='Rabart Kurrey',
                                                 loan__Bank_Name__c = 'Some Bank',
                                                 loan__Routing_Number__c = '99999999',
                                                 BSB__c='123-456',
                                                 loan__Account_Type__c = 'Checking',
                                                 loan__Account__c = a1.id);
        
        insert ba;
        Test.startTest();
        loan__Loan_Account__c dummylaMonthly = loan.TestHelper.createLoanAccountForAccountObj(dummyLP,
                                        a1,
                                        dummyFeeSet,
                                        dummyLoanPurpose,
                                        dummyOffice);
         loan__Automated_Payment_Setup__c aPS = loan.TestHelper2.createAutomatedPaymentSetup(loan.LoanConstants.ONE_TIME,loan.LoanConstants.FIXED_AMOUNT,ba,dummylaMonthly,'Monthly',pMode);
        
        loan__Loan_Disbursal_Transaction__c disbTxn = new loan__Loan_Disbursal_Transaction__c();
        disbTxn.loan__Disbursal_Date__c = loan.TestHelper.systemDate;
        disbTxn.loan__Disbursed_Amt__c = dummylaMonthly.loan__Loan_Amount__c;
        disbTxn.loan__Loan_Account__c = dummylaMonthly.id;
        disbTxn.loan__Mode_of_Payment__c =  pMode.id;
        disbTxn.loan__bank_Account__c = ba.id;
        insert disbTxn;
        disbTxn.loan__Cleared__c =true;
        update disbTxn;
        peer__Disbursement_Schedule__c dsh = new peer__Disbursement_Schedule__c();
        dsh.peer__Loan_Disbursal_Transaction__c=disbTxn.Id;
        dsh.peer__Bank_Account__c=ba.Id;
        dsh.peer__Loan_Account__c=dummylaMonthly.Id;
        dsh.peer__Amount__c=122;
        insert dsh;
        loan__Disbursal_Txn_Distribution__c disbtxns = new loan__Disbursal_Txn_Distribution__c();
        disbtxns.loan__Bank_Account__c=ba.Id;
        disbtxns.loan__Distribution_Amount__c=100;
        disbtxns.loan__Distribution_Type__c='Disbursement';
        disbtxns.loan__Loan_Disbursal_Transaction__c=disbTxn.Id;
        insert disbtxns;
        
        
        loan.LoanDisbursalFilegenJob j = new loan.LoanDisbursalFilegenJob(false);
        Database.executeBatch(j, 200);
        Test.stopTest();
        system.assertEquals([select Id from Document].size(),1);
    }
}
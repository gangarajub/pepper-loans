@isTest
public class TestLoanPaymentFilegenJob1{
    
    testMethod static void testLoanPaymentFilegen(){
        loan.TestHelper.systemDate = Date.today();
        loan.TestHelper.createSeedDataForTesting();
        loan.TestHelper.setupApprovalProcessForTxn(); // 3 day lock period
        Test.loadData(filegen__File_metadata__c.sObjectType,'Filegen_Metadata');
      
        loan.TestHelper.setupACHParameters();
        //loan.TestHelper2.createFileGenMetaData();
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
        /*loan__Transaction_Approval_Config__c c = loan.CustomSettingsUtil.getApprovalConfig();
        c.loan__Payment__c = false;
        upsert c;*/
        /*loan__ACH_Parameters__c ach = loan.CustomSettingsUtil.getACHParameters();
        ach.loan__Days_In_Advance_To_Create_File__c = 0;
        ach.loan__Multiple_Payment_Method_Support__c =true;
        upsert ach;
        */
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest', '10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest', '30000 - INCOME');
        loan__Payment_Mode__c pMode = [select id from loan__Payment_Mode__c where Name= 'ACH'];
        
        loan__Bank_Account__c bank = [select id from loan__Bank_Account__c where loan__Account_usage__c=:loan.FractionalizationConstants.COLLECTIONS_TRUST_ACCOUNT limit 1];
        bank.BSB__c='123-456';
        update bank;
        loan.TestHelper2.createAutomatedPaymentConfiguration(loan.LoanConstants.LOAN_PAYMENT,pMode,bank,'LoanPaymentTxnPepperFileGen');
        
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
        loan__Loan_Account__c dummylaMonthly = loan.TestHelper.createLoanAccountForAccountObj(dummyLP,
                                        a1,
                                        dummyFeeSet,
                                        dummyLoanPurpose,
                                        dummyOffice);
        /*
        loan__Loan_Disbursal_Transaction__c disbTxn = new loan__Loan_Disbursal_Transaction__c();
        disbTxn.loan__Disbursal_Date__c = TestHelper.systemDate;
        disbTxn.loan__Disbursed_Amt__c = dummylaMonthly.loan__Loan_Amount__c;
        disbTxn.loan__Loan_Account__c = dummylaMonthly.id;
        disbTxn.loan__Mode_of_Payment__c =  pMode.id;
        
        insert disbTxn;
        disbTxn.loan__Cleared__c =true;
        update disbTxn;*/
        
        loan__Automated_Payment_Setup__c aPS = loan.TestHelper2.createAutomatedPaymentSetup(loan.LoanConstants.ONE_TIME,loan.LoanConstants.FIXED_AMOUNT,ba,dummylaMonthly,'Monthly',pMode);
        loan__Loan_Payment_Transaction__c dummyPmt = new loan__Loan_Payment_Transaction__c();
        dummyPmt.loan__Cleared__c = false;
        dummyPmt.loan__Payment_Mode__c = pMode.id;
        dummyPmt.loan__Transaction_Amount__c  = 100;
        dummyPmt.loan__Transaction_Date__c = TestHelper.systemDate;
        dummyPmt.loan__Loan_Account__c  = dummylaMonthly.id;
        dummyPmt.loan__Automated_Payment_Setup__c = aPS.id;
        
        insert dummyPmt;
        //loan__Automated_Payment_Setup__c aPS1 = loan.TestHelper2.createAutomatedPaymentSetup(loan.LoanConstants.ONE_TIME,loan.LoanConstants.FIXED_AMOUNT,ba,dummylaMonthly,'Monthly',pMode1);
        Test.startTest();
        System.debug('inside test');  
        loan.LoanPaymentFilegenJob lpJob = new loan.LoanPaymentFilegenJob(false);
        Database.executeBatch(lpJob, 200);
        Test.stopTest();
       
        
        System.assertEquals([select Id from Document].size(),1);
    }
    
    
    
   
}
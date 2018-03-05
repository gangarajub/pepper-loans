@isTest
public class TestCommissionAmortisationJob{
    private static loan__Payment_Mode__c ACH;
    private static List<loan__Loan_Account__c> loans;
   
    testMethod static void testCommAmrt(){
    
    
    
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
        ACH = [select Id from loan__Payment_Mode__c where Name = 'Direct Credit'];
        loan.TestHelper.systemDate = Date.today().addDays(-200);
        
        //loan__ACH_Parameters__c ach = loan.CustomSettingsUtil.getACHParameters();
        //ach.loan__Days_In_Advance_To_Create_File__c = 0;
       // ach.loan__Multiple_Payment_Method_Support__c =true;
       // upsert ach;
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest', '10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest', '30000 - INCOME');
        loan__Payment_Mode__c pMode = [select id from loan__Payment_Mode__c where Name = 'Direct Credit'];
        loan__Payment_Mode__c pMode1 = [select id from loan__Payment_Mode__c where Name = 'Cash'];
         
        loan__Bank_Account__c bank = [select id from loan__Bank_Account__c where loan__Account_usage__c=:loan.FractionalizationConstants.ADVANCE_TRUST_ACCOUNT limit 1];
        bank.BSB__c='123-456';
        update bank;
        loan.TestHelper2.createAutomatedPaymentConfiguration(loan.LoanConstants.BROKER_TRANSACTION,pMode,bank,'BrokerTxnPepperFileGen');
        
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
        
       
        Account broker = new Account();
        broker.loan__broker__c= true;
        broker.Name = 'OBS';
        insert broker;
        Contact c = new Contact();
        c.LastName = 'obs1';
        c.AccountId = broker.id;
        c.loan__Contact_type__c = 'Broker';
        insert c;
        loan__Bank_Account__c brokerAcc = new loan__bank_Account__c(loan__Bank_Account_Number__c = '12',
                                                   Account_Holder_Name__c='Rabart Kurrey',
                                                 loan__Bank_Name__c = 'Some Bank',
                                                 loan__Routing_Number__c = '99999999',
                                                 BSB__c='123-456',
                                                 loan__Account_Type__c = 'Checking',
                                                 loan__Account__c = broker.id,
                                                 loan__Account_usage__c='Broker Account',
                                                 loan__Active__c = true);
         insert brokerAcc;
         loan__Commission_Plan__c cp = new loan__Commission_Plan__c();
         cp.loan__Calculation_Method__c = 'Percentage Of Financed Amount';
         cp.loan__Factor__c = 100;
         cp.loan__Commission_Disbursement_Method__c = 'Upfront';
         cp.loan__Maximum_Commission_Percentage__c = 2;
         cp.loan__Buy_Rate__C = 2;
         cp.loan__Upfront_Percentage__c = 100;
         cp.GST_rate__c = 10;
         cp.loan__enabled__c = true;
         cp.loan__Plan_Description__c = 'test';
         insert cp;
         List<loan__Commission_Plan__c> comPlan = [select id,loan__Calculation_Method__c,loan__Commission_Disbursement_Method__c,
                                loan__Enabled__c,loan__Factor__c,   loan__Flat_Amount__c,
                                loan__Maximum_Commission_Percentage__c,loan__Plan_Description__c,GST_Rate__c,
                                loan__Upfront_Percentage__c from loan__Commission_Plan__c 
                                where Id=:cp.id limit 1];
          loan__Broker__c br = new loan__Broker__c();
            
                
                br.loan__Contact__c = c.id;
                br.loan__Account__C = broker.id;
            
            
            
            br.loan__Commission_Plan__c=comPlan[0].Id;
            br.loan__Lending_Account__c=dummylaMonthly.Id;
            br.loan__Commission_Amount__c = (((dummylaMonthly.loan__loan_amount__c) * (comPlan[0].loan__Maximum_Commission_Percentage__c/100))*(comPlan[0].loan__Factor__c/100));
            br.loan__Upfront_Commission_Amount__c = loan.ValueUtil.round(br.loan__Commission_Amount__c * ((comPlan[0].loan__Upfront_Percentage__c)/100));
            br.loan__Upfront_Percentage__c = comPlan[0].loan__Upfront_Percentage__c;
            br.loan__Maximum_Commission_Percentage__c = comPlan[0].loan__Maximum_Commission_Percentage__c;
            br.loan__Calculation_Method__c = comPlan[0].loan__Calculation_Method__c;
            br.loan__Commission_Disbursement_Method__c = comPlan[0].loan__Commission_Disbursement_Method__c;
            br.loan__Factor__c = comPlan[0].loan__Factor__c;
            br.loan__Plan_Description__c = comPlan[0].loan__Plan_Description__c;
            br.GST_Rate__c = comPlan[0].GST_Rate__c;
            dummylaMonthly.Remaining_Commission_Amount__c = br.loan__Upfront_Commission_Amount__c;
            dummylaMonthly.Upfront_Commission_Amount__c = br.loan__Upfront_Commission_Amount__c;
            dummylaMonthly.Last_Amort_Commission_Date__c = loan.TestHelper.systemDate;
            dummylaMonthly.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_APPROVED;
                
                insert br; 
                
            loan__Payment_Mode__c pModeDR = [select id from loan__Payment_Mode__c where Name='Direct Credit'];
            List<loan__Broker_Transactions__c> bTxns = [select id,Payment_Mode__C from loan__Broker_Transactions__c where loan__Broker__C=:br.id];
            for(loan__broker_transactions__c btxn: bTxns){
                btxn.Payment_mode__c = pModeDR.id;
            }
            update bTxns;
            update dummylaMonthly;
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
        
        loan__Broker_transactions__c btxn = new loan__broker_transactions__c();
        btxn.loan__Account__c = broker.id;
        btxn.Payment_Mode__c = pMode.id;
        bTxn.loan__Contact__c = c.id;
        bTxn.loan__Transaction_Amount__c = 444;
        btxn.loan__broker__c = br.Id;
        bTxn.loan__Transaction_Date__c = loan.TestHelper.systemDate;
        btxn.loan__Transaction_Code__C = loan.LoanConstants.TXN_COMMISSION_UP_DISB;
        btxn.loan__Sent_to_Ach__c =true;
        btxn.loan__sent_To_ACH_On__c = loan.testHelper.systemDate;
        insert bTxn;
        system.debug('btxn1'+ btxn);
        ProcessCommissionAmortisation job = new ProcessCommissionAmortisation();
        Database.executeBatch(job,200);
        Test.stopTest();
       
    }
    
    
    
   
}
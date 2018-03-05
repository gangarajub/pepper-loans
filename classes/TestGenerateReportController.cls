@isTest
public class TestGenerateReportController {
    public static testMethod void method1(){
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
        cl.loan__Loan_Status__c=loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        cl.loan__Last_Transaction_Timestamp__c=myDate-31;
        update cl;
       
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
        
        loan__Loan_Payment_Transaction__c pays = new loan__Loan_Payment_Transaction__c();
        pays.loan__Loan_Account__c = cl.id;
        pays.loan__Transaction_Amount__c = 100;
        pays.loan__Payment_Mode__c = modes.id;
        insert pays;
                
               
        
        
        
        Test.startTest();
        Report_Configuration__c rc1 = new Report_Configuration__c();
        rc1.name='Transaction Listing';
        rc1.Folder_Name__c='Transaction';
        insert  rc1;
       
        
        
        GenerateReportController g = new GenerateReportController();
        g.selectedReport='Transaction Listing';
        g.getReportOptions();
        g.generateReport();
        Test.stopTest();
    }
     public static testMethod void method2(){
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
        cl.loan__Loan_Status__c=loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        cl.loan__Last_Transaction_Timestamp__c=myDate-31;
        update cl;
        

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
        
        loan__Loan_Payment_Transaction__c pays = new loan__Loan_Payment_Transaction__c();
        pays.loan__Loan_Account__c = cl.id;
        pays.loan__Transaction_Amount__c = 100;
        pays.loan__Payment_Mode__c = modes.id;
        insert pays;
                
        
                 
                
        Test.startTest();
        
        Report_Configuration__c rc3 = new Report_Configuration__c();
        rc3.name='Servicer Statement';
        rc3.Folder_Name__c='Servicer';
        insert  rc3;
        
        
        GenerateReportController g = new GenerateReportController();
        g.selectedReport='Servicer Statement';
        g.startDate = myDate;
        g.endDate = myDate.addDays(30);
        g.getReportOptions();
        g.generateReport();
        Test.stopTest();
    }
}
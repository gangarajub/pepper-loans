@isTest(SeeAllData=false)
private class TestGenerateBorrowerStmtInBulk{
    
    public static testMethod void method1(){
       
        loan.TestHelper.createSeedDataForTesting();
      
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        Contact con = new Contact();
        con.FirstName='Demi';
        con.LastName='Lavat0';
        con.Birthdate=myDate;
        insert con;  
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        List<loan__Loan_Account__c> loan_app1 =[select id,name from loan__Loan_Account__c  where id=:loan_app.Id];
        loan_app1[0].loan__Loan_Status__c=loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loan_app1[0].loan__Last_Transaction_Timestamp__c=myDate-31;
        loan_app1[0].loan__contact__C=con.id;
        update loan_app1[0];
        pepPepperCustomSetting__c pepCustomValues = new pepPepperCustomSetting__c();
        pepCustomValues.replyemailId__c='admint@gmail.com';
        pepCustomValues.displayname__c='Pepper Money';
        insert pepCustomValues;
        PepperEmailTemplates__c pepCustomTemplate = new PepperEmailTemplates__c();
        pepCustomTemplate.referral_email_template__c='REFERRAL_EMAIL';
        pepCustomTemplate.welcome_email_template__c='WELCOME_MAIL';
        pepCustomTemplate.Borrower_Statement__c='statementHTML';
        insert pepCustomTemplate;
        

        loop__DDP__c loop_ddc = new loop__DDP__c();
        loop_ddc.Name = 'Loan Account Statement';
        insert loop_ddc;
    
        Loop__DDP_Integration_Option__c ddp_option = new Loop__DDP_Integration_Option__c();
        ddp_option.Name = 'Attach';
        ddp_option.Loop__DDP__c = loop_ddc.id;
        
        insert ddp_option;
        Test.startTest();
        GenerateBorrowerStatementInBulk j = new GenerateBorrowerStatementInBulk();
        Database.executeBatch(j);
        Test.stopTest();   
    }
  
         
}
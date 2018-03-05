public class TestHelper{
   
    private static loan__Payment_Mode__c ACH;
    public static Date systemDate = Date.today();
    private static loan__Loan_Product__c dLP;
    private static loan__Office_Name__c dOffice;
    private static loan__Loan_Purpose__c dLoanPurpose;
    private static loan__Fee_Set__c dFeeSet;
    private static loan__Bank_Account__c ba;
    
    public static void createReportConfiguration(){
        List<Report_Configuration__c> reportConfig = new List<Report_Configuration__c>();
        Report_Configuration__c txnList = new Report_Configuration__c();
        txnList.Folder_Name__c = 'Treasury';
        txnList.Name = 'Servicer Statement';
        reportConfig.add(txnList);
        Report_Configuration__c txnList1 = new Report_Configuration__c();
        txnList1.Folder_Name__c = 'Treasury';
        txnList1.Name = 'Transaction Listing';
        reportConfig.add(txnList1);
        
        
        Report_Configuration__c txnList2 = new Report_Configuration__c();
        txnList2.Folder_Name__c = 'Finance';
        txnList2.Name = 'FINANCE REPORT';
        reportConfig.add(txnList2);
        insert reportConfig;
    }
    
    //this method creates a contact
    public static Contact createContact1(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact2(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact3(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact4(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact5(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact6(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact7(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact8(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact9(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact10(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    public static Contact createContact11(){
        Contact c= new Contact();
        c.FirstName='Wonder';
        c.LastName='Woman';
        
        c.MailingStreet='123,baker street';
        c.MailingCity='hometown';
        c.MailingState='NV';
        c.MailingPostalCode='20009';
        c.HomePhone='3232242112';
        c.MobilePhone='2867236832';
        c.Email='sample@test.com';
        c.Birthdate=Date.Today().addYears(-20);
        
        insert c;
        return c;
    }
    
    
    public static void createSeedData(){
        loan.PostInstallManager.createSeedDataOnInstall();
        loan__Org_Parameters__C orgParams = loan__Org_Parameters__c.getInstance();
               update orgParams;
        loan.TestHelper.setupMultiplePaymentModeACH();
        //loan.TestHelper.setupApprovalProcessForTxnFilegen();
       
        createLoanProduct('BW','Bi-weekly');
        createLoanProduct('MN','Monthly');
        loan.TestHelper2.createOrgBankAccounts();
        createAutomatedPaymentConfig();
        
    }
    
    private static void createAutomatedPaymentConfig() {
        loan__Bank_Account__c colbank = [SELECT id FROM loan__Bank_Account__c 
                                    WHERE loan__Account_Usage__c = :loan.FractionalizationConstants.COLLECTIONS_TRUST_ACCOUNT 
                                    LIMIT 1];
        ACH = [select id from loan__Payment_Mode__c where Name='ACH'];
        
        loan.TestHelper2.createAutomatedPaymentConfiguration(loan.LoanConstants.LOAN_PAYMENT, ACH, colbank, 'LoanPaymentTxnMoneyPlaceGen'); // 2 day lock period
        
        loan.TestHelper2.createAutomatedPaymentConfiguration(loan.LoanConstants.LOAN_DISBURSAL, ACH, colbank, 'LoanDisbursalTxnMoneyPlaceGen');
        
        loan.TestHelper2.createAutomatedPaymentConfiguration(loan.LoanConstants.INVESTOR_PAYMENT, ACH, colbank, 'CustomInvestorPaymentTxnACHGen');
        
    }
    
    
    
    public static List<loan__Loan_Account__c> insertAndDisburseLoans() {
        List<loan__Loan_Account__c> retVal = new List<loan__Loan_Account__c>();
        loan__Currency__c curr = [select id from loan__Currency__c limit 1];
        
        ach = [select id from loan__Payment_Mode__c where Name = 'ACH'];
       
        dLoanPurpose = [select id from loan__Loan_Purpose__c];
        
        dLP = createLoanProduct('BW','Bi-weekly');
        dFeeSet = [select id from loan__Fee_Set__C limit 1];
        dOffice = [select id from loan__Office_Name__c limit 1];
        Account a1 = loan.TestHelper2.createInvestor('Bull', 1000);
        ba = new loan__Bank_Account__c(loan__Bank_Account_Number__c = '12',
                                                 loan__Bank_Name__c = 'Some Bank',
                                                 loan__Routing_Number__c = '99999999',
                                                 loan__Account_Type__c = 'Checking',
                                                 loan__Account__c = a1.id);
        insert ba;
        
       
        
        loan__Loan_Account__c dummylaMonthly = loan.TestHelper.createLoanAccountForAccountObj(dLP,
                                        a1,
                                        dFeeSet,
                                        dLoanPurpose,
                                        dOffice);
        Date d = Date.today();
        Date d1=d.addDays(-3);
        loan__Loan_Disbursal_Transaction__c disbTxn = new loan__Loan_Disbursal_Transaction__c();
        disbTxn.loan__Disbursal_Date__c = d1;
        disbTxn.loan__Disbursed_Amt__c = dummylaMonthly.loan__Loan_Amount__c;
        disbTxn.loan__Loan_Account__c = dummylaMonthly.id;
        disbTxn.loan__Mode_of_Payment__c = ach.id;
        disbTxn.loan__bank_Account__c = ba.id;
        insert disbTxn;
        retVal.add(dummylaMonthly);
        
        return retVal;
    }
    
    public static loan__Loan_Product__c createLoanProduct(String Name,String paymentFrequency){
       String branchname;
        User[] user = [SELECT 
                           ID, loan__Current_Branch__c, loan__Default_Branch__c 
                           FROM User 
                           WHERE Username = :UserInfo.getUserName()];
       if(user.size()>0){
             branchname=user[0].loan__Current_Branch__c;
       
       }                    
        loan__Office_Name__c office = [select Id,name,
                                    loan__Office_Location__c,
                                    loan__Office_Short_Name__c,
                                    loan__Cash_Account__c,
                                    loan__Check_Account__c,
                                    loan__Bank_Account_Checks__c, 
                                    loan__Inward_Check_Clearance_Account__c,
                                    loan__Outward_Check_Clearance_Account__c,
                                    loan__Profit_and_Loss_Account__c,
                                    loan__Loan_Schedule_tied_to_Meeting_Schedule__c,
                                    loan__Mark_Suspended_After_Days__c,
                                    loan__State__c,
                                    loan__Write_Off_Suggestion_Days__c,
                                    loan__Office_Type__c,
                                    loan__Days_in_advance_to_create_Collection_Rep__c,
                                    loan__Current_System_Date__c,
                                    loan__Is_Branch__c from loan__Office_Name__c limit 1 ];
        office.name=branchname;
        update office;                            
        loan__MF_Account__c mfAccount = [select id ,Name ,loan__IsLeaf__c,loan__Account_Type__c,loan__Balance__c ,loan__Description__c,loan__is_Master__C from loan__MF_Account__c where loan__is_Master__c = true limit 1];
        loan__Currency__c curr1 = new loan__Currency__c(Name='AUD');
        insert curr1;
        loan__Fee__c dummyFee = new loan__Fee__c(Name='MoneyPlaceFee',
                                    loan__State__c = 'Active',
                                    loan__Fee_Calculation_Method__c = 'Amount calculated as % of Offerred Loan',
                                    loan__Amount__c = 100.0,
                                    loan__Currency__c = curr1.ID,
                                    loan__Fee_Category__c = 'Loan',
                                    loan__Time_Of_Charge__c = 'Origination');
                                    
        insert dummyFee;
        loan__Fee_Set__c dummyFeeSet = new loan__Fee_Set__c(Name='MoneyPlaceFeeSet',
                                    loan__Fee_Set_Category__c = 'Loan');
        
        insert dummyFeeSet;
        loan__Fee_Junction__c dummyFeeJunction = new loan__Fee_Junction__c(loan__Fee__c=dummyFee.ID,
                                                            loan__Fee_Set__c=dummyFeeSet.ID);
        insert dummyFeeJunction;
        loan__Currency__c curr = [select Id,Name from loan__Currency__c limit 1];
        loan__Fee_Set__c feeSet = [select Id from loan__Fee_Set__c limit 1];
        return createLoanProductwithProductType(name,office,mfAccount,curr,dummyFeeSet,'Interest Only',
                                                                                40,
                                                                                12,
                                                                                null,
                                                                                'Loan',paymentFrequency);
    }
    public static loan__Loan_Product__c createLoanProductwithProductType(
                            String name,
                            loan__Office_Name__c dummyOffice,
                            loan__MF_Account__c dummyAccount, 
                            loan__Currency__c curr, 
                            loan__Fee_Set__c dummyFeeSet,
                            String billingMethod,
                            Integer defaultNoOfInstallments,
                            Decimal defaultInterestRate,
                            String loanCycleSetup,
                            String productType,
                            String paymentFrequency) {
           System.debug('loanCycleSetup: ' + loanCycleSetup);
        if(loanCycleSetup == null || loanCycleSetup == '')
            loanCycleSetup = loan.LoanConstants.LOAN_ATTRIBUTES_SAME_FOR_ALL_LOANS;
        loan__Loan_Product__c dummyLP = new loan__Loan_Product__c(Name=name,
                                                    loan__Loan_Product_Type__c = 'Loan',
                                                    loan__Loan_Cycle_Setup__c = loanCycleSetup,
                                                    loan__Currency__c = curr.ID,
                                                    loan__Fee_Set__c = dummyFeeSet.ID,
                                                    loan__Accrual_Based_Accounting__c=true,
                                                    loan__Accrue_Income_On_Suspended_Account__c=true,
                                                    loan__Approval_Date__c=Date.today()-50,
                                                    loan__Cash_Based_Accounting__c=false,
                                                    loan__Default_Interest_Rate__c=defaultInterestRate,
                                                    loan__Default_Number_of_Installments__c=defaultNoOfInstallments,
                                                    loan__Interest_Rate_Type__c=billingMethod,
                                                    loan__Maximum_Gap_Between_Installments__c=1,
                                                    loan__Minimum_Gap_Between_Installments__c=1,
                                                    loan__Max_Interest_Rate__c=defaultInterestRate+5,
                                                    loan__Max_Loan_Amount__c=30000,
                                                    loan__Max_Number_of_Installments__c=defaultNoOfInstallments+6,
                                                    loan__Max_Overdue_Interest_Rate__c=24,
                                                    loan__Minimum_Installment_Amount__c=100,
                                                    loan__Min_Interest_Rate__c=1,
                                                    loan__Min_Loan_Amount__c=1000,
                                                    loan__Min_Number_of_Installments__c=0,
                                                    loan__Min_Overdue_Interest_Rate__c=10,
                                                    loan__Product_Interest_Income_Account__c=dummyAccount.ID,
                                                    loan__Product_Int_On_Overdue_Income_Acc__c=dummyAccount.ID,
                                                    loan__Product_Loan_Control_Account__c=dummyAccount.ID,
                                                    loan__Product_Loan_Loss_Provision_Account__c=dummyAccount.ID,
                                                    loan__Product_Loan_Loss_Reserve_Account__c=dummyAccount.ID,
                                                    loan__Product_Overdue_Interest_Account__c=dummyAccount.ID,
                                                    loan__Product_Suspended_Interest_Account__c=dummyAccount.ID,
                                                    loan__Product_Suspended_Int_On_Overdue_Acc__c=dummyAccount.ID,
                                                    loan__Product_Write_Off_Recovery_Account__c=dummyAccount.ID,
                                                    loan__Product_Excess_Account__c=dummyAccount.ID,
                                                    loan__Status__c='Active',
                                                    loan__Frequency_of_Loan_Payment__c = paymentFrequency
                                                    );
         System.debug('dummyLP: ' + dummyLP.RecordTypeId);
        ID rt = null;
        if (productType.equals(loan.LoanConstants.Loan)) {
            rt = [SELECT ID, Name FROM RecordType WHERE DeveloperName = 'Loan_Product_Record_Type' AND SObjectType = 'loan__Loan_Product__c'].Id;
       
        } else if (productType.equals(loan.LoanConstants.LOC)) {
            rt = [SELECT ID, Name FROM RecordType WHERE DeveloperName = 'Line_Of_Credit_Product_Record_Type'].Id;
        } else if (productType.equals(loan.LoanConstants.MCA)) {
            rt = [SELECT ID, Name FROM RecordType WHERE DeveloperName = 'Merchant_Cash_Advance'].Id;
        }
        
        dummyLP.RecordTypeId = rt;
       // insert dummyLP;                                            
        insert dummyLP;
        System.debug('dummyLP1'+dummyLP);
        
        //Associate loan product with branch and create rules
        loan__Branch_Loan_Product__c dummyBLP = new loan__Branch_Loan_Product__c(loan__Branch__c=dummyOffice.ID,
                                                                loan__Loan_Product__c=dummyLP.ID);
        
        insert dummyBLP;
             
        return dummyLP;
    }
    
    //this method creates an   account
    public static Account createAccount(){
        Account acc= new Account();
        Id recordTypeId=[select id,name from recordtype where sObjectType='Account' and name='Person Account' limit 1].id;
        date myDate = date.newInstance(1966, 12, 8);

        acc.recordTypeId=recordTypeId;
        acc.Salutation='Miss';
        acc.FirstName='Toni';
        acc.LastName='Fisher';
        acc.MiddleName='John';
        acc.PersonEmail='rabart@cloudlendinginc.com';
        acc.PersonBirthdate=myDate;
        acc.Gender__c='Female';
        
       
      
       
       
        try{
      insert acc;
      }catch(Exception e){
      System.debug('e'+e.getMessage());
      }      
        return acc;
    }
    
    //this method creates an   account
    public static void CreateCustomSettings(){
        
      
       
    }
    
    
    
    //this method creates an   account
    public static genesis__Applications__c createLoanApplication(){
        genesis__Applications__c loanApp= new genesis__Applications__c();
        Id recordTypeId=[select id,name from recordtype where sObjectType='genesis__Applications__c' and name='loan' limit 1].id;
        
        Account act = testhelper.createAccount();
        loanApp.recordTypeId=recordTypeId;       
        loanApp.genesis__Loan_Amount__c= 32000;
       
        loanApp.genesis__Account__c=act.id;
        
        
      try{
      insert loanApp;
      }catch(Exception e){
      System.debug('e'+e.getMessage());
      }      
        
        return loanApp;
    }
    
    
       
    
    
    
  
   public static loan__Bank_Account__c  createBankAccount(Account b2,String str){
   //Account b2 = TestHelper.createAccount();
    loan__Bank_Account__c dummyBank = new loan__Bank_Account__c();
     dummyBank.loan__Account_Type__c='saving';
     dummyBank.loan__Bank_Account_Number__c='money place';
     dummyBank.loan__Bank_Name__c='hdfc';
     dummyBank.loan__Routing_Number__c='123';
     dummyBank.loan__Account__c=b2.Id;
     dummyBank.loan__Active__c=true;
     dummyBank.loan__Account_Usage__c=str;
    
    
     insert dummyBank;
   return  dummyBank;
   }
   

   
   public static void insertVedaFraudCustomSetting(){
   ints__Veda_Fraud_Elements__c vdf = new ints__Veda_Fraud_Elements__c();
   vdf.ints__BCAaccess_code__c='mONepL032015';
   vdf.ints__BCAaccess_pwd__c='mON$$L0320!$';
   vdf.ints__BCAservice_client_ref__c='511555';
   vdf.ints__BCAservice_code__c='VSS001';
   vdf.ints__BCAservice_code_version__c='V00';
   vdf.ints__BCAservice_mode__c='test';
   vdf.ints__BCAservice_trans_ref__c='89123456';
   vdf.ints__end_point_url__c='https://ctaau.vedaxml.com/cta/sys1';
   vdf.ints__path_url__c='http://l/B2B%20QA/Schema/product-verification-services-suite-request.xsd';
   vdf.ints__Product__c='verification-services-suite';
   vdf.ints__security__c='TS';
   vdf.ints__Service__c='verification-services-suite';
   vdf.ints__subscriber_identifier__c='A5GQ9999';
   insert vdf;
   }
   
   public static void insertVedaCustomSetting(){
   ints__Veda_Comprehensive__c  vd = new ints__Veda_Comprehensive__c();
   vd.Client_Reference__c='Client-Ref';
   vd.ints__Endpoint__c='https://cteau.vedaxml.com/sys2/soap11/vedascore-apply-v2-0 ';
   vd.Operator_Id__c='I1N3';
   vd.Operator_Name__c='John Doe';
   vd.ints__Password__c='nYWp3PPerg5N';
   vd.Permission_Type_Code__c='X';
   vd.Product_Data_Level_Code__c='C';
   vd.ints__Username__c='p3Pp3RhL04nz';
   insert vd;
   }
   
   public static void insertIDMatrixCustomSetting(){
   ints__IDMatrix__c id= new ints__IDMatrix__c();
   
   id.ints__Endpoint__c='https://ctaau.vedaxml.com/cta/sys2/idmatrix-v4';
   id.ints__Password__c='8qmNZLgvr6';
   id.ints__UserName__c='PLKwjtqjfP';
   insert id;
   }
   
    
    
    
    
}
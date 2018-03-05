@isTest
public class TestGenerateACHSchedule{
    public static testmethod void LoanActiveFalsewithRecurring(){
        loan.TestHelper.createSeedDataForTesting();
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        RetrieveCode__c rc = new RetrieveCode__c();
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
        loan.GlobalLoanUtilFacade gluf = new loan.GlobalLoanUtilFacade();
        Date contractDate=gluf.getCurrentSystemDate();
        loan__Payment_Mode__c pay = new loan__Payment_Mode__c();
        pay.Name ='cash';
        insert pay;
        
        loan_app.loan__ACH_Frequency__c = 'Monthly';
        loan_app.loan__Payment_mode__c = pay.id;
        loan_app.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        update loan_app;
        loan__Automated_Payment_Setup__c auto = new loan__Automated_Payment_Setup__c();
        auto.loan__Debit_Date__c = contractDate;
        auto.loan__Active__c=true ;
        auto.loan__type__c='RECURRING';
        auto.loan__CL_Contract__c = loan_app.id;
        auto.loan__Frequency__c = 'Weekly';
        auto.loan__Payment_Mode__c = pay.id;
        auto.loan__Recurring_ACH_Start_Date__c = contractDate.addDays(12);
        auto.loan__Transaction_Amount__C = 100;
        insert auto;
        Automated_Repayment_Schedule__c repayment = new Automated_Repayment_Schedule__c();
        repayment.CL_Contract__c = loan_app.id;
        repayment.Is_Primary__c =  true;
        insert repayment;
        Account acc = genesis.TestHelper.createAccount();
        Contact contact = genesis.TestHelper.createContact();
        loan__Bank_Account__c bankAcc =new loan__Bank_Account__c();
        bankAcc.loan__Contact__c = contact.id;
        bankAcc.loan__Account__c = acc.id;
        bankAcc.loan__Bank_Account_Number__c= '1234';
        bankAcc.loan__Bank_Name__c = 'ABC';
        insert bankAcc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        
        Test.startTest(); 
        LoanActions loanAct = new LoanActions();
        LoanActions.HolidayPeriod holiday = new LoanActions.HolidayPeriod(contractDate,contractDate.addDays(20));
  
        List<LoanActions.HolidayPeriod> hPeriod = new List<LoanActions.HolidayPeriod>();
        hPeriod.add(holiday);
        List<clcommon.FinancialCalculator.RepaymentSchedule> lst = loanAct.calculateSchedule(loan_app.id, 100);
        Decimal d = loanAct.calculateMonthlyPaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,application.id);
        //system.assertEquals(900.92, d);
        
        loan__Automated_Payment_Setup__c change = loanAct.changePaymentAmount(200,loan_app.id);
        //system.assertEquals(change.loan__Transaction_Amount__c, 46.1538461538461538461538461538462);
        
        
        loan__Automated_Payment_Setup__c oneOff = loanAct.makeOneOffPayment(200, bankAcc.id,loan_app.id,pay.id,contractDate.addDays(20),true, true);
        system.debug('oneOff.loan__Transaction_Amount__c='+oneOff.loan__Transaction_Amount__c);
        //system.assertEquals(oneOff.loan__Transaction_Amount__c, 200);
        
        List<Automated_Repayment_Schedule__c> scheWithHolidays = loanAct.generateScheduleWithHolidays(loan_app.id, hPeriod, contractDate,contractDate.addDays(20), true);
        List<loan__Automated_Payment_Setup__c> APSHist = loanAct.getAPSHistory(loan_app.id,true);
        
        Map <String,String> maps = new Map<String,String>();
        maps.put('loan__Transaction_Amount__c','200');
        loan__Loan_Account__c upDateLoan = loanAct.updateLoanAccount(loan_app.id,maps );
        collect__Promise_To_Pay__c promise = loanAct.makePromiseToPay(acc.id,auto.id, 500, contractDate.addDays(30));
        loanAct.saveScheduleWithHolidays(loan_app.id,hPeriod, contractDate,contractDate.addDays(20), true);
        Test.stopTest();
        GenerateACHSchedule j = new GenerateACHSchedule();
        Database.executeBatch(j, 1);
    }
    
    public static testmethod void LoanActiveFalsewithRecurring2(){
        loan.TestHelper.createSeedDataForTesting();
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        RetrieveCode__c rc = new RetrieveCode__c();
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
        loan.GlobalLoanUtilFacade gluf = new loan.GlobalLoanUtilFacade();
        Date contractDate=gluf.getCurrentSystemDate();
        loan__Payment_Mode__c pay = new loan__Payment_Mode__c();
        pay.Name ='cash';
        
        insert pay;
       
        loan_app.loan__ACH_Frequency__c = 'Monthly';
        loan_app.loan__Payment_mode__c = pay.id;
        loan_app.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        update loan_app;
        loan__Automated_Payment_Setup__c auto = new loan__Automated_Payment_Setup__c();
        auto.loan__Debit_Date__c = contractDate.addDays(1);
        auto.loan__Active__c=true ;
        auto.loan__type__c='RECURRING';
        auto.loan__CL_Contract__c = loan_app.id;
        auto.loan__Frequency__c = 'Weekly';
        auto.loan__Payment_Mode__c = pay.id;
        auto.loan__Recurring_ACH_Start_Date__c = contractDate.addDays(-12);
        auto.loan__Transaction_Amount__C = 100;
        insert auto;
        loan__Automated_Payment_Setup__c auto2 = new loan__Automated_Payment_Setup__c();
        auto2.loan__Debit_Date__c = contractDate;
        auto2.loan__Active__c=false ;
        auto2.loan__type__c='RECURRING';
        auto2.loan__CL_Contract__c = loan_app.id;
        auto2.loan__Frequency__c = 'Weekly';
        auto2.loan__Payment_Mode__c = pay.id;
        auto2.loan__Recurring_ACH_Start_Date__c = contractDate;
        auto2.loan__Transaction_Amount__C = 100;
        insert auto2;
        Automated_Repayment_Schedule__c repayment = new Automated_Repayment_Schedule__c();
        repayment.CL_Contract__c = loan_app.id;
        repayment.Is_Primary__c =  true;
        insert repayment;
        Account acc = genesis.TestHelper.createAccount();
        Contact contact = genesis.TestHelper.createContact();
        loan__Bank_Account__c bankAcc =new loan__Bank_Account__c();
        bankAcc.loan__Contact__c = contact.id;
        bankAcc.loan__Account__c = acc.id;
        bankAcc.loan__Bank_Account_Number__c= '1234';
        bankAcc.loan__Bank_Name__c = 'ABC';
        insert bankAcc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        
        Test.startTest(); 
        LoanActions loanAct = new LoanActions();
        LoanActions.HolidayPeriod holiday = new LoanActions.HolidayPeriod(contractDate,contractDate.addDays(20));
  
        List<LoanActions.HolidayPeriod> hPeriod = new List<LoanActions.HolidayPeriod>();
        hPeriod.add(holiday);
        List<clcommon.FinancialCalculator.RepaymentSchedule> lst = loanAct.calculateSchedule(loan_app.id, 100);
        Decimal d = loanAct.calculateMonthlyPaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,application.id);
        //system.assertEquals(900.92, d);
        
        loan__Automated_Payment_Setup__c change = loanAct.changePaymentAmount(200,loan_app.id);
        //system.assertEquals(change.loan__Transaction_Amount__c, 46.1538461538461538461538461538462);
        
        
        loan__Automated_Payment_Setup__c oneOff = loanAct.makeOneOffPayment(200, bankAcc.id,loan_app.id,pay.id,contractDate.addDays(20),true, true);
        system.debug('oneOff.loan__Transaction_Amount__c='+oneOff.loan__Transaction_Amount__c);
        //system.assertEquals(oneOff.loan__Transaction_Amount__c, 200);
        
        List<Automated_Repayment_Schedule__c> scheWithHolidays = loanAct.generateScheduleWithHolidays(loan_app.id, hPeriod, contractDate,contractDate.addDays(20), true);
        List<loan__Automated_Payment_Setup__c> APSHist = loanAct.getAPSHistory(loan_app.id,true);
        
        Map <String,String> maps = new Map<String,String>();
        maps.put('loan__Transaction_Amount__c','200');
        loan__Loan_Account__c upDateLoan = loanAct.updateLoanAccount(loan_app.id,maps );
        collect__Promise_To_Pay__c promise = loanAct.makePromiseToPay(acc.id,auto.id, 500, contractDate.addDays(30));
        
        Test.stopTest();
        GenerateACHSchedule j = new GenerateACHSchedule();
        Database.executeBatch(j, 1);
    }
    
    public static testmethod void LoanActiveFalsewithRecurring3(){
        loan.TestHelper.createSeedDataForTesting();
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        RetrieveCode__c rc = new RetrieveCode__c();
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
        loan.GlobalLoanUtilFacade gluf = new loan.GlobalLoanUtilFacade();
        Date contractDate=gluf.getCurrentSystemDate();
        loan__Payment_Mode__c pay = new loan__Payment_Mode__c();
        pay.Name ='cash';
        
        insert pay;
        peer__Bank_Recon_Configuration__c bankCs=peer__Bank_Recon_Configuration__c.getOrgDefaults();
             bankCs.peer__Loan_Cancellation_Period__c=6;
             insert bankCs;
        loan_app.loan__ACH_Frequency__c = 'Monthly';
        loan_app.loan__Payment_mode__c = pay.id;
        loan_app.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loan_app.loan__Last_Disbursal_Date__c=contractDate;

        update loan_app;
        
        loan__Automated_Payment_Setup__c auto = new loan__Automated_Payment_Setup__c();
        auto.loan__Debit_Date__c = contractDate.addDays(1);
        auto.loan__Active__c=true ;
        auto.loan__type__c='RECURRING';
        auto.loan__CL_Contract__c = loan_app.id;
        auto.loan__Frequency__c = 'Weekly';
        auto.loan__Payment_Mode__c = pay.id;
        auto.loan__Recurring_ACH_Start_Date__c = contractDate.addDays(-12);
        auto.loan__Transaction_Amount__C = 100;
        insert auto;
        loan__Automated_Payment_Setup__c auto2 = new loan__Automated_Payment_Setup__c();
        auto2.loan__Debit_Date__c = contractDate;
        auto2.loan__Active__c=false ;
        auto2.loan__type__c='RECURRING';
        auto2.loan__CL_Contract__c = loan_app.id;
        auto2.loan__Frequency__c = 'Weekly';
        auto2.loan__Payment_Mode__c = pay.id;
        auto2.loan__Recurring_ACH_Start_Date__c = contractDate;
        auto2.loan__Transaction_Amount__C = 0 ;
        insert auto2;
        Automated_Repayment_Schedule__c repayment = new Automated_Repayment_Schedule__c();
        repayment.CL_Contract__c = loan_app.id;
        repayment.Is_Primary__c =  true;
        insert repayment;
        Account acc = genesis.TestHelper.createAccount();
        Contact contact = genesis.TestHelper.createContact();
        loan__Bank_Account__c bankAcc =new loan__Bank_Account__c();
        bankAcc.loan__Contact__c = contact.id;
        bankAcc.loan__Account__c = acc.id;
        bankAcc.loan__Bank_Account_Number__c= '1234';
        bankAcc.loan__Bank_Name__c = 'ABC';
        insert bankAcc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        
        Test.startTest(); 
        LoanActions loanAct = new LoanActions();
        LoanActions.HolidayPeriod holiday = new LoanActions.HolidayPeriod(contractDate,contractDate.addDays(20));
  
        List<LoanActions.HolidayPeriod> hPeriod = new List<LoanActions.HolidayPeriod>();
        hPeriod.add(holiday);
        List<clcommon.FinancialCalculator.RepaymentSchedule> lst = loanAct.calculateSchedule(loan_app.id, 100);
        Decimal d = loanAct.calculateMonthlyPaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,application.id);
        //system.assertEquals(900.92, d);
        
        loan__Automated_Payment_Setup__c change = loanAct.changePaymentAmount(200,loan_app.id);
        //system.assertEquals(change.loan__Transaction_Amount__c, 46.1538461538461538461538461538462);
        
        
        loan__Automated_Payment_Setup__c oneOff = loanAct.makeOneOffPayment(200, bankAcc.id,loan_app.id,pay.id,contractDate.addDays(20),true, true);
        system.debug('oneOff.loan__Transaction_Amount__c='+oneOff.loan__Transaction_Amount__c);
        //system.assertEquals(oneOff.loan__Transaction_Amount__c, 200);
        
        List<Automated_Repayment_Schedule__c> scheWithHolidays = loanAct.generateScheduleWithHolidays(loan_app.id, hPeriod, contractDate,contractDate.addDays(20), true);
        List<loan__Automated_Payment_Setup__c> APSHist = loanAct.getAPSHistory(loan_app.id,true);
        
        Map <String,String> maps = new Map<String,String>();
        maps.put('loan__Transaction_Amount__c','200');
        loan__Loan_Account__c upDateLoan = loanAct.updateLoanAccount(loan_app.id,maps );
        collect__Promise_To_Pay__c promise = loanAct.makePromiseToPay(acc.id,auto.id, 500, contractDate.addDays(30));
        
        Test.stopTest();
        GenerateACHSchedule j = new GenerateACHSchedule();
        Database.executeBatch(j, 1);
    }
    
    public static testmethod void breakcosttest(){
        loan.TestHelper.createSeedDataForTesting();
        Date myDate = Date.newInstance(2016, 2, 17);//year month and day
        loan.TestHelper.systemDate = myDate;
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee__c dummyFee1 = loan.TestHelper.createFee(curr);
        dummyFee1.Name = 'Break Cost';
        dummyFee1.loan__Amount__c = 200;
        update dummyFee1;
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        loan__Fee_Junction__c dummyFeeJunction1 = loan.TestHelper.createFeeJunction(dummyFee1,dummyFeeSet);
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
        dummyLP.loan__Interest_Rate_Type__c = 'Fixed';
        update dummyLP;
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        loan.GlobalLoanUtilFacade gluf = new loan.GlobalLoanUtilFacade();
        Date contractDate=gluf.getCurrentSystemDate();
        loan__Payment_Mode__c pay = new loan__Payment_Mode__c();
        pay.Name ='cash';
        
        insert pay;
        peer__Bank_Recon_Configuration__c bankCs=peer__Bank_Recon_Configuration__c.getOrgDefaults();
        bankCs.peer__Loan_Cancellation_Period__c=6;
        insert bankCs;

        loan_app.loan__ACH_Frequency__c = 'Monthly';
        loan_app.loan__Payment_mode__c = pay.id;
        loan_app.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loan_app.loan__Reserve_Amount_for_Next_Due__c = 4000;
        loan_app.loan__Last_Disbursal_Date__c=contractDate;

        update loan_app;
        loan__Automated_Payment_Setup__c auto = new loan__Automated_Payment_Setup__c();
        auto.loan__Debit_Date__c = contractDate;
        auto.loan__Active__c=true ;
        auto.loan__type__c='RECURRING';
        auto.loan__CL_Contract__c = loan_app.id;
        auto.loan__Frequency__c = 'Weekly';
        auto.loan__Payment_Mode__c = pay.id;
        auto.loan__Recurring_ACH_Start_Date__c = contractDate.addDays(12);
        auto.loan__Transaction_Amount__C = 100;
        insert auto;
        //Automated_Repayment_Schedule__c repayment = new Automated_Repayment_Schedule__c();
        //repayment.CL_Contract__c = loan_app.id;
        //repayment.Is_Primary__c =  true;
        //insert repayment;
        Account acc = genesis.TestHelper.createAccount();
        Contact contact = genesis.TestHelper.createContact();
        loan__Bank_Account__c bankAcc =new loan__Bank_Account__c();
        bankAcc.loan__Contact__c = contact.id;
        bankAcc.loan__Account__c = acc.id;
        bankAcc.loan__Bank_Account_Number__c= '1234';
        bankAcc.loan__Bank_Name__c = 'ABC';
        insert bankAcc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        
        Test.startTest(); 
        LoanActions loanAct = new LoanActions();
        LoanActions.HolidayPeriod holiday = new LoanActions.HolidayPeriod(contractDate,contractDate.addDays(20));
  
        List<LoanActions.HolidayPeriod> hPeriod = new List<LoanActions.HolidayPeriod>();
        hPeriod.add(holiday);
        List<clcommon.FinancialCalculator.RepaymentSchedule> lst = loanAct.calculateSchedule(loan_app.id, 100);
        Decimal d = loanAct.calculateMonthlyPaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,application.id);
        //system.assertEquals(900.92, d);
        
        loan__Automated_Payment_Setup__c change = loanAct.changePaymentAmount(2000,loan_app.id);
        //system.assertEquals(change.loan__Transaction_Amount__c, 46.1538461538461538461538461538462);
        
        
        loan__Automated_Payment_Setup__c oneOff = loanAct.makeOneOffPayment(2000, bankAcc.id,loan_app.id,pay.id,contractDate.addDays(20),true, true);
        system.debug('oneOff.loan__Transaction_Amount__c='+oneOff.loan__Transaction_Amount__c);
        //system.assertEquals(oneOff.loan__Transaction_Amount__c, 200);
        
        List<Automated_Repayment_Schedule__c> scheWithHolidays = loanAct.generateScheduleWithHolidays(loan_app.id, hPeriod, contractDate,contractDate.addDays(20), true);
        List<loan__Automated_Payment_Setup__c> APSHist = loanAct.getAPSHistory(loan_app.id,true);
        
        Map <String,String> maps = new Map<String,String>();
        maps.put('loan__Transaction_Amount__c','200');
        loan__Loan_Account__c upDateLoan = loanAct.updateLoanAccount(loan_app.id,maps );
        collect__Promise_To_Pay__c promise = loanAct.makePromiseToPay(acc.id,auto.id, 500, contractDate.addDays(30));
        //loanAct.saveScheduleWithHolidays(loan_app.id,hPeriod, contractDate,contractDate.addDays(20), true);
        Test.stopTest();
        System.debug('My Amounts 1: '+ loan_app.loan__Reserve_Amount_for_Next_Due__c);
        System.debug('My Amounts 2: '+ loan_app.loan__Pmt_Amt_Cur__c);
        BreakFeeJob j = new BreakFeeJob();
        Database.executeBatch(j, 1);
    }
}
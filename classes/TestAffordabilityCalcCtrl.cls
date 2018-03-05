@isTest
public class TestAffordabilityCalcCtrl {
    
    public static testmethod void testAnnually(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        loan.TestHelper.systemDate = Date.Today();
        rc.Code__c = 'AAB37706';
        insert rc;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c();
        purpose.Name = 'a vehicle loan rate card'; 
        
        insert purpose; 
        
        genesis__Credit_Rating_Matrix__c credit = new genesis__Credit_Rating_Matrix__c();
        credit.Name = 'B2';
        insert credit;
        
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.PL_Product__c = 'UNSECURED';
        clProduct.Interest_Type__c = 'variable';
        clProduct.clcommon__Product_Name__c = 'CP1';
        insert clproduct;
        CL_Product_Purpose_Junction__c junc = new CL_Product_Purpose_Junction__c();
        junc.CL_Product__c = clproduct.id;
        junc.CL_Purpose__c = purpose.id;
        insert junc;
        
        Credit_Rating_Product_Junction__c ratingProduct = new Credit_Rating_Product_Junction__c();
        ratingProduct.CL_Product__c = clProduct.id;
        ratingproduct.Credit_Rating_Matrix__c = credit.id;
        ratingproduct.Interest_Rate__c = 12.99;
        insert ratingProduct;
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
         
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        loan.GlobalLoanUtilFacade gluf = new loan.GlobalLoanUtilFacade();
        Date contractDate=gluf.getCurrentSystemDate(); 
        loan.BranchUtil branch = new loan.BranchUtil();
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        Account acc = genesis.TestHelper.createAccount();
        acc.loan__Active__c = 'Yes';
        acc.Relationship_Status__c = 'Married';
        acc.Number_of_Dependants__c = 2;
        update acc;
        
        
        application.genesis__Account__c = acc.id;
        application.genesis__Term__c = 36;
        application.genesis__Loan_Amount__c = 8000;
        application.Percentage_of_Expense_Contribution__c = 100;
        application.genesis__Interest_Rate__c = 15.99;
        application.genesis__CL_Purpose__c = purpose.id;
        application.debit_frequency__c = 'WEEKLY';
        application.genesis__CL_product__c = clproduct.id;
        update application;
        genesis__Rate_Card_Setup_Header__c rate_card = new genesis__Rate_Card_Setup_Header__c();
        rate_card.CL_Purpose__c = application.genesis__CL_Purpose__c;
        rate_card.genesis__Enabled_Flag__c = true;
        rate_card.genesis__Start_Date__c = contractDate;
        rate_card.genesis__End_Date__c = rate_card.genesis__Start_Date__c.addDays(20);
        rate_card.Type__c = 'Post Credit Check';
        rate_card.genesis__Transaction_Date__c = contractDate;
        insert rate_card;
        
        genesis__Rate_Card_Setup_Detail__c detail = new genesis__Rate_Card_Setup_Detail__c();
        
        detail.genesis__Maximum_Financed_Amount__c =8000;
        detail.genesis__Minimum_Financed_Amount__c =7000; 
        detail.genesis__Min_Term__c = 24;
        detail.genesis__Max_Term__c = 36 ;
        detail.genesis__Rate_Card_Setup_Header__c = rate_card.id;
        insert detail;
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Affordability_Configuration__c afford_config = new Affordability_Configuration__c();
        afford_config.Active__c = true;
        afford_config.Revolving_Credit_Percent_As_Expense__c = 15;
        afford_config.Rate_Buffer__c = -1801.2300; 
        insert afford_config;
        Affordability_Configuration__c add = [select id,name from Affordability_Configuration__c where Active__c=true];
        Income__c income = new Income__c();
        income.Type__c = 'Rental Income';
        income.Application__c = application.id;
        income.Frequency__c = 'Yearly';
        income.Gross_Income__c = 2300000;
        insert income;
        HEM__c hem = new HEM__c();
        hem.Type__c = 'Single';
        hem.Value_Per_Dependant__c = 242.67;
        hem.Value_Per_Adult__c = 1191.67;
        insert hem;
        HEM__c hem1 = new HEM__c();
        hem1.Type__c = 'Couple';
        insert hem1;
        Residential_Address__c res = new Residential_Address__c();
        res.Application__c = application.id;
        insert res;
        Expense_and_Debt__c expense = new Expense_and_Debt__c();
        expense.Is_Revolving_Credit__c = true;
        expense.Application__c = application.id;
        expense.Credit_Limit__c = 1000;
        insert expense;
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.id);
        Test.startTest();
        AffordabilityCalcCtrl afford = new AffordabilityCalcCtrl(application.id);
      
        String s = AffordabilityCalcCtrl.webServiceAffordability(application.id);
        system.assertEquals('Affordability calculation completed', s);
        
        Decimal d = afford.calculatePaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,'Annually');
        System.assertEquals(1285.36433884224657979462945524987, d);
        Decimal next = afford.getNextTermMovedByAYear(36,'Annually');
        System.assertEquals(37,next);
        Decimal pay = afford.calculateMonthlyPaymentAmount(1000, 'Annually');
        System.assertEquals(83.3333333333333333333333333333333,pay);
        Decimal service = afford.calculateServiceability(500,1000,10000, 500,2000,1000);
        System.assertEquals(5000, service);
        List<Boolean> retVal = AffordabilityCalcCtrl.postPricingAffordabilityCheck(applicationIds);
        system.assertEquals(true, retVal[0]);
        Test.stopTest();
    }
    
    public static testmethod void testWeekly(){
        loan.TestHelper.createSeedDataForTesting();
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
        loan.BranchUtil branch = new loan.BranchUtil();
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        Account acc = genesis.TestHelper.createAccount();
        acc.loan__Active__c = 'Yes';
        //acc.Relationship_Status__c = 'Married';
        //acc.Number_of_Dependants__c = 2;
        update acc;
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c();
        purpose.Name = 'a vehicle loan rate card'; 
        
        insert purpose; 
        
        genesis__Credit_Rating_Matrix__c credit = new genesis__Credit_Rating_Matrix__c();
        credit.Name = 'B2';
        insert credit;
        
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.PL_Product__c = 'UNSECURED';
        clProduct.Interest_Type__c = 'variable';
        clProduct.clcommon__Product_Name__c = 'CP1';
        insert clproduct;
        CL_Product_Purpose_Junction__c junc = new CL_Product_Purpose_Junction__c();
        junc.CL_Product__c = clproduct.id;
        junc.CL_Purpose__c = purpose.id;
        insert junc;
        
        Credit_Rating_Product_Junction__c ratingProduct = new Credit_Rating_Product_Junction__c();
        ratingProduct.CL_Product__c = clProduct.id;
        ratingproduct.Credit_Rating_Matrix__c = credit.id;
        ratingProduct.Interest_Rate__c =12.99;
        insert ratingProduct;
        
        application.genesis__Account__c = acc.id;
        application.genesis__Term__c = 36;
        application.genesis__Loan_Amount__c = 8000;
        application.Percentage_of_Expense_Contribution__c = 100;
        application.debit_frequency__c = 'WEEKLY';
        application.current_veda_score__C = 123;
        application.genesis__CL_Product__c = clProduct.id;
        application.genesis__Interest_Rate__c = 15.99;
        //application.Post_Creditcheck_Affordability_Status__c ='Yes';
        application.genesis__CL_Purpose__c = purpose.id;
        update application;
        genesis__Rate_Card_Setup_Header__c rate_card = new genesis__Rate_Card_Setup_Header__c();
        rate_card.CL_Purpose__c = application.genesis__CL_Purpose__c;
        rate_card.genesis__Enabled_Flag__c = true;
        rate_card.genesis__Start_Date__c = contractDate;
        rate_card.genesis__End_Date__c = rate_card.genesis__Start_Date__c.addDays(20);
        rate_card.Type__c = 'Post Credit Check';
        rate_card.genesis__Transaction_Date__c = contractDate;
        insert rate_card;
        
        genesis__Rate_Card_Setup_Detail__c detail = new genesis__Rate_Card_Setup_Detail__c();
        detail.genesis__Credit_Rating__c = credit.id;
        detail.genesis__Maximum_Financed_Amount__c =8000;
        detail.genesis__Minimum_Financed_Amount__c =7000; 
        detail.genesis__Min_Term__c = 24;
        detail.genesis__Max_Term__c = 36 ;
        detail.genesis__Rate_Card_Setup_Header__c = rate_card.id;
        insert detail;
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Affordability_Configuration__c afford_config = new Affordability_Configuration__c();
        afford_config.Active__c = true;
        afford_config.Revolving_Credit_Percent_As_Expense__c = 15;
        afford_config.Rate_Buffer__c = -1801.2300; 
        insert afford_config;
        Affordability_Configuration__c add = [select id,name from Affordability_Configuration__c where Active__c=true];
        Income__c income = new Income__c();
        income.Type__c = 'Rental Income';
        income.Application__c = application.id;
        income.Frequency__c = 'Yearly';
        income.Gross_Income__c = 2300000;
        insert income;
        HEM__c hem = new HEM__c();
        hem.Type__c = 'Single';
        hem.Value_Per_Dependant__c = 242.67;
        hem.Value_Per_Adult__c = 1191.67;
        insert hem; 
        HEM__c hem1 = new HEM__c();
        hem1.Type__c = 'Couple';
        insert hem1;
        Expense_and_Debt__c expense = new Expense_and_Debt__c();
        expense.Is_Revolving_Credit__c = true;
        expense.Application__c = application.id;
        expense.Credit_Limit__c = 1000;
        insert expense;
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.id);
        Test.startTest();
        AffordabilityCalcCtrl afford = new AffordabilityCalcCtrl(application.id);
      
        String s = AffordabilityCalcCtrl.webServiceAffordability(application.id);
        system.assertEquals('Affordability calculation completed', s);
        
        Decimal d = afford.calculatePaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,'Weekly');
        //system.assertEquals(235.090254731382906837227331728664, d);
        Decimal next = afford.getNextTermMovedByAYear(36,'Weekly');
        //system.assertEquals(88,next);
        
        Decimal pay = afford.calculateMonthlyPaymentAmount(1000, 'Weekly');
        //system.assertEquals(4330.00, pay);
        Decimal service = afford.calculateServiceability(500,1000,10000, 500,2000,1000);
        //system.assertEquals(5000,service);
        List<Boolean> retVal = AffordabilityCalcCtrl.postPricingAffordabilityCheck(applicationIds);
        system.assertEquals(true, retVal[0]);
        Test.stopTest();
    }
    
    public static testmethod void testBiWeekly(){
        loan.TestHelper.createSeedDataForTesting();
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
        loan.BranchUtil branch = new loan.BranchUtil();
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        Account acc = genesis.TestHelper.createAccount();
        acc.loan__Active__c = 'Yes';
        //acc.Relationship_Status__c = 'Married';
        //acc.Number_of_Dependants__c = 2;
        update acc;
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c();
        purpose.Name = 'a vehicle loan rate card'; 
        
        insert purpose; 
        
        genesis__Credit_Rating_Matrix__c credit = new genesis__Credit_Rating_Matrix__c();
        credit.Name = 'B2';
        insert credit;
        
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.PL_Product__c = 'UNSECURED';
        clProduct.Interest_Type__c = 'variable';
        clProduct.clcommon__Product_Name__c = 'CP1';
        insert clproduct;
        CL_Product_Purpose_Junction__c junc = new CL_Product_Purpose_Junction__c();
        junc.CL_Product__c = clproduct.id;
        junc.CL_Purpose__c = purpose.id;
        insert junc;
        
        Credit_Rating_Product_Junction__c ratingProduct = new Credit_Rating_Product_Junction__c();
        ratingProduct.CL_Product__c = clProduct.id;
        ratingproduct.Credit_Rating_Matrix__c = credit.id;
        ratingProduct.Interest_Rate__c =12.99;
        insert ratingProduct;
        
        application.genesis__Account__c = acc.id;
        application.genesis__Term__c = 36;
        application.genesis__Loan_Amount__c = 8000;
        application.Percentage_of_Expense_Contribution__c = 100;
        application.debit_frequency__c = 'Bi-Weekly';
        application.current_veda_score__C = 123;
        application.genesis__CL_product__c = clProduct.id;
        application.genesis__Interest_Rate__c = 15.99;
        //application.Post_Creditcheck_Affordability_Status__c ='Yes';
        application.genesis__CL_Purpose__c = purpose.id;
        update application;
        genesis__Rate_Card_Setup_Header__c rate_card = new genesis__Rate_Card_Setup_Header__c();
        rate_card.CL_Purpose__c = application.genesis__CL_Purpose__c;
        rate_card.genesis__Enabled_Flag__c = true;
        rate_card.genesis__Start_Date__c = contractDate;
        rate_card.genesis__End_Date__c = rate_card.genesis__Start_Date__c.addDays(20);
        rate_card.Type__c = 'Post Credit Check';
        rate_card.genesis__Transaction_Date__c = contractDate;
        insert rate_card;
        
        genesis__Rate_Card_Setup_Detail__c detail = new genesis__Rate_Card_Setup_Detail__c();
        detail.genesis__Credit_Rating__c = credit.id;
        detail.genesis__Maximum_Financed_Amount__c =8000;
        detail.genesis__Minimum_Financed_Amount__c =7000; 
        detail.genesis__Min_Term__c = 24;
        detail.genesis__Max_Term__c = 36 ;
        detail.genesis__Rate_Card_Setup_Header__c = rate_card.id;
        insert detail;
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Affordability_Configuration__c afford_config = new Affordability_Configuration__c();
        afford_config.Active__c = true;
        afford_config.Revolving_Credit_Percent_As_Expense__c = 15;
        afford_config.Rate_Buffer__c = -1801.2300; 
        insert afford_config;
        Affordability_Configuration__c add = [select id,name from Affordability_Configuration__c where Active__c=true];
        Income__c income = new Income__c();
        income.Type__c = 'Rental Income';
        income.Application__c = application.id;
        income.Frequency__c = 'Yearly';
        income.Gross_Income__c = 2300000;
        insert income;
        HEM__c hem = new HEM__c();
        hem.Type__c = 'Single';
        hem.Value_Per_Dependant__c = 242.67;
        hem.Value_Per_Adult__c = 1191.67;
        insert hem; 
        HEM__c hem1 = new HEM__c();
        hem1.Type__c = 'Couple';
        insert hem1;
        Expense_and_Debt__c expense = new Expense_and_Debt__c();
        expense.Is_Revolving_Credit__c = true;
        expense.Application__c = application.id;
        expense.Credit_Limit__c = 1000;
        insert expense;
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.id);
        Test.startTest();
        AffordabilityCalcCtrl afford = new AffordabilityCalcCtrl(application.id);
      
        String s = AffordabilityCalcCtrl.webServiceAffordability(application.id);
        system.assertEquals('Affordability calculation completed', s);
        
        Decimal d = afford.calculatePaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,'Weekly');
        //system.assertEquals(235.090254731382906837227331728664, d);
        Decimal next = afford.getNextTermMovedByAYear(36,'Bi-Weekly');
        //system.assertEquals(88,next);
        
        Decimal pay = afford.calculateMonthlyPaymentAmount(1000, 'Bi-Weekly');
        //system.assertEquals(4330.00, pay);
        Decimal service = afford.calculateServiceability(500,1000,10000, 500,2000,1000);
        //system.assertEquals(5000,service);
        List<Boolean> retVal = AffordabilityCalcCtrl.postPricingAffordabilityCheck(applicationIds);
        system.assertEquals(true, retVal[0]);
        Test.stopTest();
    }
   
    public static testmethod void failedAffordabilityTest(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
         
        //loan__Floating_Rate_Change_Action__c rates = new loan__Floating_Rate_Change_Action__c();
        //insert rates;
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        loan__Client__c dummyClient = loan.TestHelper.createClient();
        //create a Loan Product
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        String Name = 'loan product';
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
         
        loan__Loan_Account__c loan_app = loan.TestHelper.createLoanAccount(dummyLP, dummyClient, dummyFeeSet, dummyLoanPurpose, dummyOffice);
        loan.GlobalLoanUtilFacade gluf = new loan.GlobalLoanUtilFacade();
        Date contractDate=gluf.getCurrentSystemDate(); 
        loan.BranchUtil branch = new loan.BranchUtil();
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        Account acc = genesis.TestHelper.createAccount();
        acc.loan__Active__c = 'Yes';
        acc.Relationship_Status__c = 'Married';
        acc.Number_of_Dependants__c = 2;
        update acc;
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c();
        purpose.Name = 'a vehicle loan rate card'; 
        
        insert purpose; 
        
        genesis__Credit_Rating_Matrix__c credit = new genesis__Credit_Rating_Matrix__c();
        credit.Name = 'Good';
        insert credit;
        
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.PL_Product__c = 'UNSECURED';
        clProduct.Interest_Type__c = 'variable';
        clProduct.clcommon__Product_Name__c = 'CP1';
        insert clproduct;
        CL_Product_Purpose_Junction__c junc = new CL_Product_Purpose_Junction__c();
        junc.CL_Product__c = clproduct.id;
        junc.CL_Purpose__c = purpose.id;
        insert junc;
        
        Credit_Rating_Product_Junction__c ratingProduct = new Credit_Rating_Product_Junction__c();
        ratingProduct.CL_Product__c = clProduct.id;
        ratingproduct.Credit_Rating_Matrix__c = credit.id;
        ratingProduct.Interest_Rate__c = 12.99;
        insert ratingProduct;
        
        application.genesis__Account__c = acc.id;
        application.genesis__Term__c = 36;
        application.genesis__Loan_Amount__c = 8000;
        application.Percentage_of_Expense_Contribution__c = 100;
        application.current_veda_score__C = 123;
        application.genesis__CL_Product__c = clProduct.id;
        application.genesis__Interest_Rate__c = 15.99;
        application.Post_Creditcheck_Affordability_Status__c ='No';
        application.pepnavigation_Status__c = 'Expense';
        application.genesis__CL_Purpose__c = purpose.id;
        update application;
        genesis__Rate_Card_Setup_Header__c rate_card = new genesis__Rate_Card_Setup_Header__c();
        rate_card.CL_Purpose__c = application.genesis__CL_Purpose__c;
        rate_card.genesis__Enabled_Flag__c = true;
        rate_card.genesis__Start_Date__c = contractDate;
        rate_card.genesis__End_Date__c = rate_card.genesis__Start_Date__c.addDays(20);
        rate_card.Type__c = 'Pre Credit Check';
        rate_card.genesis__Transaction_Date__c = contractDate;
        insert rate_card;
        
        genesis__Rate_Card_Setup_Detail__c detail = new genesis__Rate_Card_Setup_Detail__c();
        detail.genesis__Enabled_Flag__c = true;
        detail.genesis__Interest_Rate__c = application.genesis__Interest_Rate__c;
        detail.genesis__Credit_Rating__c = application.genesis__Credit_Rating__c;
        detail.genesis__Maximum_Financed_Amount__c =8000;
        detail.genesis__Minimum_Financed_Amount__c =7000; 
        detail.genesis__Min_Term__c = 24;
        detail.genesis__Max_Term__c = 36 ;
        detail.genesis__Rate_Card_Setup_Header__c = rate_card.id;
        insert detail;
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Affordability_Configuration__c afford_config = new Affordability_Configuration__c();
        afford_config.Active__c = true;
        afford_config.Revolving_Credit_Percent_As_Expense__c = 15;
        afford_config.Rate_Buffer__c = 180000.2300; 
        insert afford_config;
        Affordability_Configuration__c add = [select id,name from Affordability_Configuration__c where Active__c=true];
        Income__c income = new Income__c();
        income.Type__c = 'Rental Income';
        income.Application__c = application.id;
        income.Frequency__c = 'Yearly';
        income.Gross_Income__c = 2300000;
        insert income;
        HEM__c hem = new HEM__c();
        hem.Type__c = 'Single';
        hem.Value_Per_Dependant__c = 242.67;
        hem.Value_Per_Adult__c = 1191.67;
        insert hem;
        HEM__c hem1 = new HEM__c();
        hem1.Type__c = 'Couple';
        insert hem1;
        Expense_and_Debt__c expense = new Expense_and_Debt__c();
        expense.Is_Revolving_Credit__c = true;
        expense.Application__c = application.id;
        expense.Credit_Limit__c = 1000;
        insert expense;
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.id);
        Test.startTest();
        AffordabilityCalcCtrl afford = new AffordabilityCalcCtrl(application.id);
    
        String s = AffordabilityCalcCtrl.webServiceAffordability(application.id);
        system.assertEquals('Affordability calculation completed', s);
        Decimal d = afford.calculatePaymentAmount(application.genesis__Loan_Amount__c,application.genesis__Interest_Rate__c,application.genesis__Term__c,'Monthly');
        system.assertEquals(281.216769710780053355014063906972, d);
        
        Decimal next = afford.getNextTermMovedByAYear(36,'Annually');
        system.assertEquals(37,next);
        Decimal pay = afford.calculateMonthlyPaymentAmount(1000, 'Annually');
        system.assertEquals(83.3333333333333333333333333333333, pay);
        
        Decimal service = afford.calculateServiceability(500,1000,10000, 500,2000,1000);
        system.assertEquals(5000,service);
        
        List<Boolean> retVal = AffordabilityCalcCtrl.postPricingAffordabilityCheck(applicationIds);
        system.assertEquals(true, retVal[0]);
        Test.stopTest();
    }

}
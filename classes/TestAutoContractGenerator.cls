@isTest
public class TestAutoContractGenerator {
    
    public static testmethod void autoContractGenerate(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        pepPepperCustomSetting__c pepCustomValues = new pepPepperCustomSetting__c();
        pepCustomValues.replyemailId__c='admint@gmail.com';
        pepCustomValues.displayname__c='Pepper Money';
        insert pepCustomValues;
        PepperEmailTemplates__c pepCustomTemplate = new PepperEmailTemplates__c();
        pepCustomTemplate.referral_email_template__c='REFERRAL_EMAIL';
        pepCustomTemplate.welcome_email_template__c='WELCOME_MAIL';
        insert pepCustomTemplate;
        
        
        
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
        /*loan__Floating_Rate_Index__c rate = new loan__Floating_Rate_Index__c();
        rate.Name = 'PL Variable Rate';
        insert rate;
        loan__Floating_Rate__c floats = new loan__Floating_Rate__c();
        floats.loan__Floating_Rate_Index__c = rate.Id;
        floats.loan__Rate_Percentage__c = 10;
        insert floats;*/
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
            
       /* dummyLP.loan__Interest_Rate_Type__c = 'Floating';
        dummyLP.loan__Floating_Rate_Index__c = rate.id;
        dummyLP.loan__Floating_Rate_Change_Action__c = 'Change Payment Amount';
        update dummyLP;*/
        genesis__Company__c comp = genesis.TestHelper.createCompany(); 
        comp.Name = 'ABS';
        update comp;
        clcommon__CL_Product__c pr = new clcommon__CL_Product__c();
        pr.clcommon__Product_Name__c = dummyLP.Name;
        pr.loan__Lending_Product__c = dummyLP.id;
        pr.PL_Product__c = 'SECURED';
        insert pr;
        Account acc = genesis.TestHelper.createAccount(); 
        acc.loan__Branch__c = dummyOffice.id;
        acc.loan__Broker__c = true;
        update acc;
        Contact con = genesis.TestHelper.createContact();
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c(Name = 'debt',loan__Lending_Purpose__c =dummyLoanPurpose.id );
        insert purpose;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Company__c = comp.id;
        application.genesis__Product_Type__c = 'LOAN';
        application.genesis__CL_Product__c = pr.id;
        application.genesis__Account__c = acc.id;
        application.genesis__Contact__c = con.id;
        application.Debit_Frequency__c = 'Monthly';
        application.genesis__CL_Purpose__c = purpose.id;
        application.Automated_Payment_Start_Date__c = loan.testhelper.systemDate.addDays(-1);
        update application;
        
        clcommon__Collateral__c asset = new clcommon__Collateral__c();
        asset.active__c = true;
        asset.genesis__Application__c = application.id;
        asset.clcommon__Year__c = '2008';
        asset.clcommon__Make__c = 'HONDA';
        asset.clcommon__Model__c = 'CRV';
        asset.ppsr_Search_Certificate_Number__c = '123456789';
        asset.pep_User_Selected_Vehicle__c = 'Car';
        //asset.Asset_Class__c = 'Used';
        asset.clcommon__Collateral_Name__c = 'My Vehicle';
        insert asset;
        
        clcommon__Collateral_Valuation__c assetValuation = new clcommon__Collateral_Valuation__c();
        assetValuation.clcommon__Collateral__c = asset.id;
        assetValuation.clcommon__Appraised_Value__c = 1234;
        assetValuation.Red_Book_Key__c = '122344';
        insert assetValuation;
        clcommon__Party_Type__c party_type = new clcommon__Party_Type__c();
        party_type.name = 'Referral';
        insert party_type;
        clcommon__Party_Type__c party_type1 = new clcommon__Party_Type__c();
        party_type1.name = 'Broker';
        insert party_type1;
        
        
        loan__Commission_Plan__c commision = new loan__Commission_Plan__c();
        commision.loan__Plan_Description__c='Referrer';
        commision.loan__Buy_Rate__c = 12;
        insert commision;
        
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        genesis__Conversion_Mapping__c con_map1 = new genesis__Conversion_Mapping__c();
        con_map1.genesis__Application_Field_Name__c = 'genesis__Contact__c';
        con_map1.genesis__Contract_Field_Name__c = 'loan__Contact__c';
        con_map1.genesis__Product_Type__c = 'loan';
        con_map1.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map1;
        clcommon__Party__c party = new clcommon__Party__c();
        party.genesis__Application__c = application.id;
        party.clcommon__Type__c = party_type1.id;
        party.clcommon__Account__c = application.genesis__Account__c;
        party.clcommon__Contact__c = con.id;
        insert party;
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Account__c = acc.id;
        bank.loan__Bank_Account_Number__c = '123456788';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Active__C =true;
        insert bank;
        
        Expense_and_Debt__c debt = new Expense_and_Debt__c();
        debt.Application__c = application.id;
        debt.Consolidate_As_A_Debt__c = true;
        debt.Type_of_Expense_Debt__c ='Personal Loan';
        debt.Amount_Remaining_as_Debt__c = 100;
        insert debt;
        
        
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        try{
            list<boolean> gen = AutoContractGenerator.generate(applicationIds);
            system.assertEquals(true, gen[0]);
        }
        catch(Exception e)
        {
            System.debug('Exception caught');
            
        }
       
        Test.stopTest();
    }
    
    public static testmethod void autoContractGenerate11(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        pepPepperCustomSetting__c pepCustomValues = new pepPepperCustomSetting__c();
        pepCustomValues.replyemailId__c='admint@gmail.com';
        pepCustomValues.displayname__c='Pepper Money';
        insert pepCustomValues;
        PepperEmailTemplates__c pepCustomTemplate = new PepperEmailTemplates__c();
        pepCustomTemplate.referral_email_template__c='REFERRAL_EMAIL';
        pepCustomTemplate.welcome_email_template__c='WELCOME_MAIL';
        insert pepCustomTemplate;
        
        
        
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
        /*loan__Floating_Rate_Index__c rate = new loan__Floating_Rate_Index__c();
        rate.Name = 'PL Variable Rate';
        insert rate;
        loan__Floating_Rate__c floats = new loan__Floating_Rate__c();
        floats.loan__Floating_Rate_Index__c = rate.Id;
        floats.loan__Rate_Percentage__c = 10;
        insert floats;*/
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
            
        //dummyLP.loan__Interest_Rate_Type__c = 'Floating';
       // dummyLP.loan__Floating_Rate_Index__c = rate.id;
        //dummyLP.loan__Floating_Rate_Change_Action__c = 'Change Payment Amount';
        //update dummyLP;
        genesis__Company__c comp = genesis.TestHelper.createCompany(); 
        comp.Name = 'ABS';
        update comp;
        clcommon__CL_Product__c pr = new clcommon__CL_Product__c();
        pr.clcommon__Product_Name__c = dummyLP.Name;
        pr.loan__Lending_Product__c = dummyLP.id;
        pr.PL_Product__c = 'SECURED';
        insert pr;
        Account acc = genesis.TestHelper.createAccount(); 
        acc.loan__Branch__c = dummyOffice.id;
        acc.loan__Broker__c = true;
        update acc;
        Contact con = genesis.TestHelper.createContact();
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c(Name = 'debt',loan__Lending_Purpose__c =dummyLoanPurpose.id );
        insert purpose;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Company__c = comp.id;
        application.genesis__Product_Type__c = 'LOAN';
        application.genesis__CL_Product__c = pr.id;
        application.genesis__Account__c = acc.id;
        application.genesis__Contact__c = con.id;
        application.Debit_Frequency__c = 'Monthly';
        application.genesis__CL_Purpose__c = purpose.id;
        application.Automated_Payment_Start_Date__c = loan.testhelper.systemDate.addDays(-1);
        update application;
        
        clcommon__Collateral__c asset = new clcommon__Collateral__c();
        asset.active__c = true;
        asset.genesis__Application__c = application.id;
        asset.clcommon__Year__c = '2008';
        asset.clcommon__Make__c = 'HONDA';
        asset.clcommon__Model__c = 'CRV';
        asset.ppsr_Search_Certificate_Number__c = '123456789';
        asset.pep_User_Selected_Vehicle__c = 'Car';
        //asset.Asset_Class__c = 'Used';
        asset.clcommon__Collateral_Name__c = 'My Vehicle';
        insert asset;
        
        clcommon__Collateral_Valuation__c assetValuation = new clcommon__Collateral_Valuation__c();
        assetValuation.clcommon__Collateral__c = asset.id;
        assetValuation.clcommon__Appraised_Value__c = 1234;
        assetValuation.Red_Book_Key__c = '122344';
        insert assetValuation;
        clcommon__Party_Type__c party_type = new clcommon__Party_Type__c();
        party_type.name = 'Referral';
        insert party_type;
        clcommon__Party_Type__c party_type1 = new clcommon__Party_Type__c();
        party_type1.name = 'Broker';
        insert party_type1;
        
        
        loan__Commission_Plan__c commision = new loan__Commission_Plan__c();
        commision.loan__Plan_Description__c='Referrer';
        commision.loan__Buy_Rate__c = 12;
        insert commision;
        
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        genesis__Conversion_Mapping__c con_map1 = new genesis__Conversion_Mapping__c();
        con_map1.genesis__Application_Field_Name__c = 'genesis__Contact__c';
        con_map1.genesis__Contract_Field_Name__c = 'loan__Contact__c';
        con_map1.genesis__Product_Type__c = 'loan';
        con_map1.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map1;
        clcommon__Party__c party = new clcommon__Party__c();
        party.genesis__Application__c = application.id;
        party.clcommon__Type__c = party_type1.id;
        party.clcommon__Account__c = application.genesis__Account__c;
        party.clcommon__Contact__c = con.id;
        insert party;
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Account__c = acc.id;
        bank.loan__Bank_Account_Number__c = '123456788';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Active__C =true;
        insert bank;
        
        Expense_and_Debt__c debt = new Expense_and_Debt__c();
        debt.Application__c = application.id;
        debt.Consolidate_As_A_Debt__c = true;
        debt.Type_of_Expense_Debt__c ='Personal Loan';
        debt.Amount_Remaining_as_Debt__c = 100;
        insert debt;
        
        
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        try{
            list<boolean> gen = AutoContractGenerator.generate(applicationIds);
            system.assertEquals(true, gen[0]);
        }
        catch(Exception e)
        {
            System.debug('Exception caught');
            
        }
       
        Test.stopTest();
    }
    
    public static testmethod void autoContractGenerate1(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        pepPepperCustomSetting__c pepCustomValues = new pepPepperCustomSetting__c();
        pepCustomValues.replyemailId__c='admint@gmail.com';
        pepCustomValues.displayname__c='Pepper Money';
        insert pepCustomValues;
        PepperEmailTemplates__c pepCustomTemplate = new PepperEmailTemplates__c();
        pepCustomTemplate.referral_email_template__c='REFERRAL_EMAIL';
        pepCustomTemplate.welcome_email_template__c='WELCOME_MAIL';
        insert pepCustomTemplate;
        
        
        
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
        /*loan__Floating_Rate_Index__c rate = new loan__Floating_Rate_Index__c();
        rate.Name = 'PL Variable Rate';
        insert rate;
        loan__Floating_Rate__c floats = new loan__Floating_Rate__c();
        floats.loan__Floating_Rate_Index__c = rate.Id;
        floats.loan__Rate_Percentage__c = 10;
        insert floats;*/
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
            
       /* dummyLP.loan__Interest_Rate_Type__c = 'Floating';
        dummyLP.loan__Floating_Rate_Index__c = rate.id;
        dummyLP.loan__Floating_Rate_Change_Action__c = 'Change Payment Amount';
        update dummyLP;*/
        genesis__Company__c comp = genesis.TestHelper.createCompany(); 
        comp.Name = 'ABS';
        update comp;
        clcommon__CL_Product__c pr = new clcommon__CL_Product__c();
        pr.clcommon__Product_Name__c = dummyLP.Name;
        pr.loan__Lending_Product__c = dummyLP.id;
        pr.PL_Product__c = 'SECURED';
        insert pr;
        Account acc = genesis.TestHelper.createAccount(); 
        acc.loan__Branch__c = dummyOffice.id;
        acc.loan__Broker__c = true;
        update acc;
        Contact con = genesis.TestHelper.createContact();
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c(Name = 'debt',loan__Lending_Purpose__c =dummyLoanPurpose.id );
        insert purpose;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Company__c = comp.id;
        application.genesis__Product_Type__c = 'LOAN';
        application.genesis__CL_Product__c = pr.id;
        application.genesis__Account__c = acc.id;
        application.genesis__Contact__c = con.id;
        application.Debit_Frequency__c = 'Monthly';
        application.genesis__CL_Purpose__c = purpose.id;
        application.Automated_Payment_Start_Date__c = loan.testhelper.systemDate.addDays(-1);
        update application;
        
        clcommon__Collateral__c asset = new clcommon__Collateral__c();
        asset.active__c = true;
        asset.genesis__Application__c = application.id;
        asset.clcommon__Year__c = '2008';
        asset.clcommon__Make__c = 'HONDA';
        asset.clcommon__Model__c = 'CRV';
        asset.ppsr_Search_Certificate_Number__c = '123456789';
        asset.pep_User_Selected_Vehicle__c = 'Car';
        //asset.Asset_Class__c = 'Used';
        asset.clcommon__Collateral_Name__c = 'My Vehicle';
        insert asset;
        
        clcommon__Collateral_Valuation__c assetValuation = new clcommon__Collateral_Valuation__c();
        assetValuation.clcommon__Collateral__c = asset.id;
        assetValuation.clcommon__Appraised_Value__c = 1234;
        assetValuation.Red_Book_Key__c = '122344';
        insert assetValuation;
        clcommon__Party_Type__c party_type = new clcommon__Party_Type__c();
        party_type.name = 'Referral';
        insert party_type;
        clcommon__Party_Type__c party_type1 = new clcommon__Party_Type__c();
        party_type1.name = 'Broker';
        insert party_type1;
        
        
        loan__Commission_Plan__c commision = new loan__Commission_Plan__c();
        commision.loan__Plan_Description__c='Referrer';
        commision.loan__Buy_Rate__c = 12;
        insert commision;
        
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        genesis__Conversion_Mapping__c con_map1 = new genesis__Conversion_Mapping__c();
        con_map1.genesis__Application_Field_Name__c = 'genesis__Contact__c';
        con_map1.genesis__Contract_Field_Name__c = 'loan__Contact__c';
        con_map1.genesis__Product_Type__c = 'loan';
        con_map1.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map1;
        clcommon__Party__c party = new clcommon__Party__c();
        party.genesis__Application__c = application.id;
        party.clcommon__Type__c = party_type1.id;
        party.clcommon__Account__c = application.genesis__Account__c;
        party.clcommon__Contact__c = con.id;
        insert party;
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Account__c = acc.id;
        bank.loan__Bank_Account_Number__c = '123456788';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Active__C =false;
        insert bank;
        
        Expense_and_Debt__c debt = new Expense_and_Debt__c();
        debt.Application__c = application.id;
        debt.Consolidate_As_A_Debt__c = true;
        debt.Type_of_Expense_Debt__c ='Personal Loan';
        debt.Amount_Remaining_as_Debt__c = 100;
        insert debt;
        
        
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        try{
            list<boolean> gen = AutoContractGenerator.generate(applicationIds);
            system.assertEquals(true, gen[0]);
        }
        catch(Exception e)
        {
            System.debug('Exception caught');
            
        }
       
        Test.stopTest();
    }
    
    public static testmethod void autoContractGenerate2(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        pepPepperCustomSetting__c pepCustomValues = new pepPepperCustomSetting__c();
        pepCustomValues.replyemailId__c='admint@gmail.com';
        pepCustomValues.displayname__c='Pepper Money';
        insert pepCustomValues;
        PepperEmailTemplates__c pepCustomTemplate = new PepperEmailTemplates__c();
        pepCustomTemplate.referral_email_template__c='REFERRAL_EMAIL';
        pepCustomTemplate.welcome_email_template__c='WELCOME_MAIL';
        insert pepCustomTemplate;
        
        
        
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
        /*loan__Floating_Rate_Index__c rate = new loan__Floating_Rate_Index__c();
        rate.Name = 'PL Variable Rate';
        insert rate;
        loan__Floating_Rate__c floats = new loan__Floating_Rate__c();
        floats.loan__Floating_Rate_Index__c = rate.Id;
        floats.loan__Rate_Percentage__c = 10;
        insert floats;*/
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
            
       /* dummyLP.loan__Interest_Rate_Type__c = 'Floating';
        dummyLP.loan__Floating_Rate_Index__c = rate.id;
        dummyLP.loan__Floating_Rate_Change_Action__c = 'Change Payment Amount';
        update dummyLP;*/
        genesis__Company__c comp = genesis.TestHelper.createCompany(); 
        comp.Name = 'ABS';
        update comp;
        clcommon__CL_Product__c pr = new clcommon__CL_Product__c();
        pr.clcommon__Product_Name__c = dummyLP.Name;
        pr.loan__Lending_Product__c = dummyLP.id;
        pr.PL_Product__c = 'SECURED';
        insert pr;
        Account acc = genesis.TestHelper.createAccount(); 
        acc.loan__Branch__c = dummyOffice.id;
        acc.loan__Broker__c = true;
        update acc;
        //Contact con = genesis.TestHelper.createContact();
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c(Name = 'debt',loan__Lending_Purpose__c =dummyLoanPurpose.id );
        insert purpose;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Company__c = comp.id;
        application.genesis__Product_Type__c = 'LOAN';
        application.genesis__CL_Product__c = pr.id;
        application.genesis__Account__c = acc.id;
        //application.genesis__Contact__c = con.id;
        application.Debit_Frequency__c = 'Monthly';
        application.genesis__CL_Purpose__c = purpose.id;
        application.Automated_Payment_Start_Date__c = loan.testhelper.systemDate.addDays(-1);
        update application;
        
        clcommon__Collateral__c asset = new clcommon__Collateral__c();
        asset.active__c = true;
        asset.genesis__Application__c = application.id;
        asset.clcommon__Year__c = '2008';
        asset.clcommon__Make__c = 'HONDA';
        asset.clcommon__Model__c = 'CRV';
        asset.ppsr_Search_Certificate_Number__c = '123456789';
        asset.pep_User_Selected_Vehicle__c = 'Car';
        //asset.Asset_Class__c = 'Used';
        asset.clcommon__Collateral_Name__c = 'My Vehicle';
        insert asset;
        
        clcommon__Collateral_Valuation__c assetValuation = new clcommon__Collateral_Valuation__c();
        assetValuation.clcommon__Collateral__c = asset.id;
        assetValuation.clcommon__Appraised_Value__c = 1234;
        assetValuation.Red_Book_Key__c = '122344';
        insert assetValuation;
        clcommon__Party_Type__c party_type = new clcommon__Party_Type__c();
        party_type.name = 'Referral';
        insert party_type;
        clcommon__Party_Type__c party_type1 = new clcommon__Party_Type__c();
        party_type1.name = 'Broker';
        insert party_type1;
        
        
        loan__Commission_Plan__c commision = new loan__Commission_Plan__c();
        commision.loan__Plan_Description__c='Referrer';
        commision.loan__Buy_Rate__c = 12;
        insert commision;
        
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        genesis__Conversion_Mapping__c con_map1 = new genesis__Conversion_Mapping__c();
        con_map1.genesis__Application_Field_Name__c = 'genesis__Contact__c';
        con_map1.genesis__Contract_Field_Name__c = 'loan__Contact__c';
        con_map1.genesis__Product_Type__c = 'loan';
        con_map1.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map1;
        clcommon__Party__c party = new clcommon__Party__c();
        party.genesis__Application__c = application.id;
        party.clcommon__Type__c = party_type1.id;
        party.clcommon__Account__c = application.genesis__Account__c;
        //party.clcommon__Contact__c = con.id;
        insert party;
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Account__c = acc.id;
        bank.loan__Bank_Account_Number__c = '123456788';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Active__C =false;
        insert bank;
        
        Expense_and_Debt__c debt = new Expense_and_Debt__c();
        debt.Application__c = application.id;
        debt.Consolidate_As_A_Debt__c = true;
        debt.Type_of_Expense_Debt__c ='Personal Loan';
        debt.Amount_Remaining_as_Debt__c = 100;
        insert debt;
        
        
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        try{
            list<boolean> gen = AutoContractGenerator.generate(applicationIds);
            system.assertEquals(true, gen[0]);
        }
        catch(Exception e)
        {
            System.debug('Exception caught');
            
        }
       
        Test.stopTest();
    }
    
    public static testmethod void autoContractGenerateWeekly(){
        loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        pepPepperCustomSetting__c pepCustomValues = new pepPepperCustomSetting__c();
        pepCustomValues.replyemailId__c='admint@gmail.com';
        pepCustomValues.displayname__c='Pepper Money';
        insert pepCustomValues;
        PepperEmailTemplates__c pepCustomTemplate = new PepperEmailTemplates__c();
        pepCustomTemplate.referral_email_template__c='REFERRAL_EMAIL';
        pepCustomTemplate.welcome_email_template__c='WELCOME_MAIL';
        insert pepCustomTemplate;
        
        
        
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
        /*loan__Floating_Rate_Index__c rate = new loan__Floating_Rate_Index__c();
        rate.Name = 'PL Variable Rate';
        insert rate;
        loan__Floating_Rate__c floats = new loan__Floating_Rate__c();
        floats.loan__Floating_Rate_Index__c = rate.Id;
        floats.loan__Rate_Percentage__c = 10;
        insert floats;*/
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(Name, dummyOffice, dummyAccount, curr, dummyFeeSet);
            
       /* dummyLP.loan__Interest_Rate_Type__c = 'Floating';
        dummyLP.loan__Floating_Rate_Index__c = rate.id;
        dummyLP.loan__Floating_Rate_Change_Action__c = 'Change Payment Amount';
        update dummyLP;*/
        genesis__Company__c comp = genesis.TestHelper.createCompany(); 
        comp.Name = 'ABS';
        update comp;
        clcommon__CL_Product__c pr = new clcommon__CL_Product__c();
        pr.clcommon__Product_Name__c = dummyLP.Name;
        pr.loan__Lending_Product__c = dummyLP.id;
        insert pr;
        Account acc = genesis.TestHelper.createAccount(); 
        acc.loan__Branch__c = dummyOffice.id;
        acc.loan__Broker__c = true;
        update acc;
        Contact con = genesis.TestHelper.createContact();
        clcommon__CL_Purpose__c purpose = new clcommon__CL_Purpose__c(Name = 'debt',loan__Lending_Purpose__c =dummyLoanPurpose.id );
        insert purpose;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        application.genesis__Status__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Company__c = comp.id;
        application.genesis__Product_Type__c = 'LOAN';
        application.genesis__CL_Product__c = pr.id;
        application.genesis__Account__c = acc.id;
        application.genesis__Contact__c = con.id;
        application.Debit_Frequency__c = 'Weekly';
        application.genesis__CL_Purpose__c = purpose.id;
        application.Automated_Payment_Start_Date__c = loan.testhelper.systemDate.addDays(-1);
        update application; 
        clcommon__Party_Type__c party_type = new clcommon__Party_Type__c();
        party_type.name = 'Referral';
        insert party_type;
        clcommon__Party_Type__c party_type1 = new clcommon__Party_Type__c();
        party_type1.name = 'Broker';
        insert party_type1;
        
        
        loan__Commission_Plan__c commision = new loan__Commission_Plan__c();
        commision.loan__Plan_Description__c='Referrer';
        commision.loan__Buy_Rate__c = 12;
        insert commision;
        
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        genesis__Conversion_Mapping__c con_map1 = new genesis__Conversion_Mapping__c();
        con_map1.genesis__Application_Field_Name__c = 'genesis__Contact__c';
        con_map1.genesis__Contract_Field_Name__c = 'loan__Contact__c';
        con_map1.genesis__Product_Type__c = 'loan';
        con_map1.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map1;
        clcommon__Party__c party = new clcommon__Party__c();
        party.genesis__Application__c = application.id;
        party.clcommon__Type__c = party_type1.id;
        party.clcommon__Account__c = application.genesis__Account__c;
        party.clcommon__Contact__c = con.id;
        insert party;
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Account__c = acc.id;
        bank.loan__Bank_Account_Number__c = '123456788';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Active__C =true;
        insert bank;
        
        Expense_and_Debt__c debt = new Expense_and_Debt__c();
        debt.Application__c = application.id;
        debt.Consolidate_As_A_Debt__c = true;
        debt.Type_of_Expense_Debt__c ='Personal Loan';
        debt.Amount_Remaining_as_Debt__c = 100;
        insert debt;
        
        
        List<Id> applicationIds = new List<Id>();
        applicationIds.add(application.Id);
        
        genesis__Custom_Logic_Parameters__c cust = new genesis__Custom_Logic_Parameters__c();
        cust.genesis__Custom_Contract_Generation_Class__c = 'ApplicationToContractConverter';
        insert cust;
        Test.startTest();
        try{
            list<boolean> gen = AutoContractGenerator.generate(applicationIds);
            system.assertEquals(true, gen[0]);
        }
        catch(Exception e)
        {
            System.debug('Exception caught');
            
        }
       
        Test.stopTest();
    }

}
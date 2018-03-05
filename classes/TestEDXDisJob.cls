@isTest
private class TestEDXDisJob {
    
    ints.EDXCreateRegIntegration disInt=new ints.EDXCreateRegIntegration();    
    ints.IntegrationRequestObject requestObj = new ints.IntegrationRequestObject();
    clcommon__collateral__c collObj = new clcommon__collateral__c();
    EDX_Register_Interest__c edxRes= new EDX_Register_Interest__c();
    Edx_Register_Data__c edxData= new Edx_Register_Data__c();    
    public static testMethod void test1(){ 
       
        insert new ints__EDXDisInt__c(ints__endpoint__c ='http://api.esis.mhi.nz/b2bapi/createregistrationbycontractyype',ints__username__c='pldev',ints__password__c='pplb2b',securedPartyGroupNumber__c='100135254');        
         String sample='abc';
        list<loan__Loan_Collateral__c> collList= new List<loan__Loan_Collateral__c>();
        clcommon__collateral__c collObj = new clcommon__collateral__c();
        collObj.clcommon__Vehicle_ID_Number__c='MRHRE48308P010835';
        collObj.clcommon__Make__c=sample;
        collObj.clcommon__Model__c=sample;
        collObj.clcommon__Style__c=sample;
        collObj.clcommon__Year__c=sample;
        collObj.clcommon__Vehicle_Color__c=sample;
        collObj.clcommon__Collateral_Name__c='My Vehicle';
        collObj.Vehicle_Series__c=sample;
        collObj.Vehicle_Type__c=sample;
        collObj.transmission__c=sample;        
        collObj.integration_Error_Status__c=sample;
        collObj.integration_Error_Status_Code__c=sample;
        collObj.ppsr_Search_Certificate_Number__c=sample;
        collObj.message__c=sample;
        collObj.Variant__c=sample;    
        upsert collObj;
       
        Summary__c sum = new Summary__c();
        sum.encumbrance__c='true';
        sum.insurance__c='true';
        sum.odometer__c='Pass';
        sum.registration__c='Pass';
        insert sum;
        Registration__c reg=new Registration__c();
        reg.registration_Expiry_Date__c='19-11-2016';
        reg.registration_Plate__c='X76JK';
        reg.registration_State__c='SA';
        insert reg;
        loan.TestHelper.createSeedDataForTesting();
        
                
        //genesis__Company__c dummyCompany = TestHelperForManaged.createCompany('OfficeForTest');
        
        list<genesis__applications__c> dummyApplication = new list<genesis__applications__c>();
        //genesis__applications__c application = genesis.TestHelper.createApplication();
       // TestHelperForManaged.calculateTierHelper();
        //Create a Company
        //genesis__Company__c company = TestHelperForManaged.createCompany('HQ in ABQ');
        
       loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create CL Prodcut
     /*   clcommon__CL_Product__c product = loan.testHelper.createCLProduct('Dummy CL Product');
        //Create Contact
        Contact con = loan.TestHelper.createContact('Dummy LN');
        con.MailingState = 'MN';
        Update con;
  
/*        
        //Create Application
        genesis__Applications__c application = TestHelperForManaged.createApplication(con,product,company);
        
        
        //application.Final_Decision__c = 'Approved';
        //application.genesis__Company__c = dummyCompany.Id;
        */
  genesis.TestHelper th= new genesis.TestHelper();
        th.createDefaultOrgParameters();
        List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType=: genesis.CustomSettingsUtil.getNS()+'Applications__c' and isActive=true];
        Map<String,String> applicationRecordTypes = new Map<String,String>{};
        for(RecordType rt: rtypes)
            applicationRecordTypes.put(rt.Name.toUppercase(),rt.Id);          
        genesis__Applications__c application = new genesis__Applications__c(recordtypeid = applicationRecordTypes.get('LEASE'));
      //  application.genesis__RecordTypeId = genesis.testHelper.applicationRecordTypes.get('LEASE');
        application.genesis__Contact__c = genesis.testhelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        application.genesis__Loan_Amount__c = 6700;
        application.genesis__company__c = genesis.testHelper.createCompany().Id;
        application.genesis__Collateral_Value__c= 6700;
        application.genesis__Estimated_Selling_Price__c = 6700;
        application.genesis__Fees_Amount__c =0;
        application.genesis__Expected_Start_Date__c = Date.today();
        application.genesis__Warranty_Amount__c=0;
        
        application.genesis__Tax_Amount__c=0;
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;        
        
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
        application.genesis__Days_Convention__c = '30/360';
        application.genesis__Landing_Sequence__c = 3;
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        application.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
       // insert application;
      
    Date FromDay = Date.today().addDays(-10);
        Date toDay = Date.today().addDays(10);
        
        String docFolder = 'HQ in ABQ';
        String formDateStr = FromDay.year() + '-' + FromDay.month() + '-' + FromDay.day();
        String toDateStr = toDay.year() + '-' + toDay.month() + '-' + toDay.day();
        String fileName = 'LOScorecards' + 'HQ_in_ABQ_'+ formDateStr +'_To_'+ toDateStr + '.csv';
        
        //loan__Currency__c curr = loan.TestHelper.createCurrency();
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr);
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        
        User u = loan.TestHelper.createUser('testUser1', 'MyOffice1');
        loan__Meeting_Schedule__c schedule = loan.TestHelper.createMeetingSchedule('Weekly');
        
        u.UserName = application.OwnerId;
        
        //Create a dummy Loan Product
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProductWithCycle('TestLPWithCycle',dummyOffice,
                            dummyAccount, 
                            curr, 
                            dummyFeeSet,
                            'Declining Balance');
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();        
        loan__Client__c dummyContact = loan.TestHelper.createClient();
        
        
        loan__Loan_Account__c dummyLoanAccount = loan.TestHelper.createLoanAccount(dummyLP,
                                                    dummyContact,
                                                    dummyFeeSet,
                                                    dummyLoanPurpose,
                                                    dummyOffice);
        //dummyLoanAccount.loan__Number_of_Days_Overdue__c = 31;
        dummyLoanAccount.loan__Pay_Off_Amount_As_Of_Today__c =1000;
        //update dummyLoanAccount;
        
        dummyLoanAccount.loan__Number_of_Days_Overdue__c = 31;
        dummyLoanAccount.loan__Delinquent_Amount__c =1000;
        dummyLoanAccount.loan__Loan_Status__c ='active bad standing';
        
        update dummyLoanAccount;        
       
        loan__Loan_Collateral__c loColl=new loan__Loan_Collateral__c();
        loColl.Collateral__c=collObj.id;
        loColl.loan__Loan__c=dummyLoanAccount.id;
        collList.add(loColl);
        insert collList;
        Test.startTest();
        
        
        EDXDischargeRegJob schduleJob = new EDXDischargeRegJob();
        String sch = '20 30 8 10 2 ?';
        String jobID = system.schedule('Register Interest', sch, schduleJob);
        EDXDischargeRegJob af=new EDXDischargeRegJob();
        Database.executeBatch(af);
        Database.BatchableContext bc;
        
        af.Execute(bc,collList);
        
        Test.stopTest();
        
        
    }
}
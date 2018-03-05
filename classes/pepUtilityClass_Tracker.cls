@isTest
public class pepUtilityClass_Tracker 
{
    @isTest  
    static void Method_1() 
    {
        test.starttest();
        account obj= pepCommonTrackerController.createAccount();
        list<string> lst=new list<string>();
        lst.add('Account');
        
        
        
        pepBSB_WebService_Credentials__c oCust = new pepBSB_WebService_Credentials__c();
        oCust.Name='Credential';
        oCust.pepBSB_End_Point__c ='https://kleber.datatoolscloud.net.au/KleberWebService/DtKleberService.svc/ProcessQueryStringRequest';
        oCust.peprequest_key__c = 'RK-37A34-91788-1D6AF-DF73B-6D5B5-C3613-E7476-39595';
        insert oCust;
        
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        loan__loan_Account__c objLoanAccount= pepCommonTrackerController.createLoanAccount();
        Account objAccount=pepCommonTrackerController.createAccount();
        objAccount.Referral_Code__c='a13';
        objAccount.Loan_Account_Id__c=objLoanAccount.id;
        update objAccount;
        
        objLoanAccount.loan__Account__c = objAccount.id;
        update objLoanAccount;
        pepUtilityClass.getAllLoanContract(objAccount.id);
        
        genesis__Applications__c objApplication = new genesis__Applications__c();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Automated_Payment_Start_Date__c=System.Today();
        objApplication.genesis__Payment_Amount__c=2000;
        objApplication.Debit_Amount__c=2000;
        objApplication.pepNavigation_Status__c='LoanSetup-Offer';
        update objApplication;
        
        Application__c objapp= pepCommonTrackerController.createApplication();
        objapp.Name='pepCongratulations';
        objapp.Navigation_Status__c='LoanSetup-Offer';
        objapp.RedirectPage__c='pepCongratulations';
        update objapp;
        
        pages_config__c objConfig2 = new pages_config__c();
        objConfig2.Page_Label__c='Congratulations';
        objConfig2.Name='pepcongratulations';
        insert objConfig2;
        
        pepBank_Statement_Credential__c objBankStatement = new pepBank_Statement_Credential__c();
        objBankStatement.name = 'Credential';
        objBankStatement.pepEndPoint_Url__c = 'https://test.bankstatements.com.au/api/v1';
        objBankStatement.pepX_API_KEY__c = 'BKZYR9ACQMMUVYHVCLEN1B6AUOJLATYRXQO1PIKF'; 
        insert objBankStatement;
        
        loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
        payMode.Name ='testPayMOde';
        insert payMode;
        
        loan__Automated_Payment_Setup__c automatedPayment = new loan__Automated_Payment_Setup__c();
        automatedPayment.loan__Active__c = true;
        automatedPayment.loan__Type__c = 'RECURRING';
        automatedPayment.loan__Debit_Date__c = system.today();
        automatedPayment.loan__CL_Contract__c = objLoanAccount.id;
        automatedPayment.loan__Frequency__c = 'Bi-Monthly';
        automatedPayment.loan__Payment_Mode__c = payMode.id;
        insert automatedPayment;
        
        Decimal loanEMI1 = pepUtilityClass.calculateLoanEmi(12.1,12.12,12.12,'Monthly');
        System.assertEquals(0.159313933170951340474387536711664, loanEMI1);
        Decimal loanEMI2 = pepUtilityClass.calculateLoanEmi(12.1,12.12,12.12,'daily');
        System.assertEquals(0.00521994071171413777885495767178581, loanEMI2);
        Decimal loanEMI3 = pepUtilityClass.calculateLoanEmi(12.1,12.12,12.12,'quarterly');
        System.assertEquals(0.481545891367908533783860192041528, loanEMI3);
        Decimal loanEMI4 = pepUtilityClass.calculateLoanEmi(12.1,12.12,12.12,'weekly');
        System.assertEquals(0.0366592727344954004333263285376283, loanEMI4);
        Decimal loanEMI5 = pepUtilityClass.calculateLoanEmi(12.1,12.12,12.12,'fortnightly');
        System.assertEquals(0.0733560448300984641190971706910543, loanEMI5);
        Decimal loanEMI6 = pepUtilityClass.calculateLoanEmi(12.1,12.12,12.12,'annually');
        System.assertEquals(1.96425901799506923038739216234326, loanEMI6);
        pepUtilityClass.fetchApplicationAndChild(lst,'pepGeneral',obj.id,objApplication.id,null);
        pepUtilityClass.readFieldSet('pepGeneral','Account');
        pepUtilityClass.getRecordTypeId('Account', 'Person Account');
        pepUtilityClass.getAccountId();
        pepUtilityClass.getLoanAccountId(objAccount.id);
        pepUtilityClass.getLoanContract(objAccount.Loan_Account_Id__c);
        
        
        pepUtilityClass.getActiveAutomatedPaymentSetup(null);
        pepUtilityClass.checkCookieAndRedirect();
        Pagereference pd=Page.pepCongratulations;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        //ApexPages.currentPage().getcookies().put('ApplicationId','hello');
        pepUtilityClass.checkCookieAndRedirect();
        pepUtilityClass.getNavigationPageName(objapp.Name);
        pepUtilityClass.navigateToPage( objapp.Navigation_Status__c);
        pepUtilityClass.SaveContinueStatus(objApplication,objapp.Name);
        pepUtilityClass.SaveForLater(objApplication,objapp.Name);
        pepUtilityClass.updateRetrieval(objApplication.id);
        pepUtilityClass.updateLastsaved(objApplication.id);
        pepUtilityClass.sendEmailRetrievalcode(objApplication);
        pepUtilityClass.sendSMSRetrievalcode(objApplication);
        pepUtilityClass.CreateExceptionRecord('NoReason','SOAP');
        test.stoptest();
        
        pepUtilityClass.getActiveAutomatedPaymentSetup(objLoanAccount.id);
        
        pepUtilityClass.HandleRedirectSecurity();
        pepUtilityClass.updatebank();
        pepUtilityClass.callBSBvalidationWebService('062001');
        pepUtilityClass.sideBarWrapper objwrapper = new pepUtilityClass.sideBarWrapper();
        pepUtilityClass.sideBarWrapper objwrapper1 = new pepUtilityClass.sideBarWrapper('123','46');
        
        Application__c obja = new Application__c();
        obja.Navigation_Status__c='LoanDetails';
        obja.RedirectPage__c = 'pepLoanDetails';
        obja.Name = 'pepLoanDetails';
        insert obja;
        Application__c obja1 = new Application__c();
        obja1.Navigation_Status__c='Expense';
        obja1.RedirectPage__c = 'pepExpensePage';
        obja1.Name = 'pepExpensePage';
        insert obja1;
        
        Application__c obja2 = new Application__c();
        obja2.Navigation_Status__c='Income';
        obja2.RedirectPage__c = 'pepIncomePage';
        obja2.Name = 'pepIncomePage';
        insert obja2;
        
        pepUtilityClass.returnPageName('1');
        pepUtilityClass.returnPageName('2');
        pepUtilityClass.returnPageName('3');
        pepUtilityClass.returnPageName('4');
        
        pepBank_API_Details__c bnkDet = new pepBank_API_Details__c();
        bnkDet.pepBank_Name__c = 'Macquarie';
        bnkDet.pepBank_Slug_Name__c = '1234';
        insert bnkDet;
        pepUtilityClass.updatebank();
        
        pepUtilityClass.createRetrievalCode('9999999999');
        
        obj.pafss_Duplication_Check_Key__c = 'jay:elderidge:0410804074:ckefalianos@pepper.com.au:1972-01-20';
        update obj;
        
        clcommon__Party_Type__c oPT = new clcommon__Party_Type__c();
        oPT.Name = 'aaa';
        oPT.pafss_Is_Individual_Loan__c =true;
       // oPT.ScCollection_is_ATP__c = true;
        oPT.ScCollection_Only_For_ESB__c =true;
        insert oPT;
        
        collect__Source_System__c  oSS = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c oLA = ScCollection_CommonTrackerClass.createTestContract(oSS.id);
        oLA.ScCollection_FP_Group_Name__c = 'Consumer Loan';
        update oLA;
        
        clcommon__Party__c objComParty = new clcommon__Party__c();
        objComParty.clcommon__Account__c = obj.id;
        objComParty.clcommon__Type__c = oPT.id;
        objComParty.collect__CL_Contract__c= oLA.id;
        //contact number added by: sushant kumar
       // objComParty.pepATPContactNumber__c = '123456789';
        Date currentDate = System.today();
        Date afterOneMonthDate = currentDate.addMonths(1);
       // objComParty.pepATP_Expiry_Date__c = afterOneMonthDate;
       // objComParty.pepVerbal_Password__c = 'testPass';
        insert objComPArty;
        
        pepUtilityClass.contractWrapper objWrapCon = new pepUtilityClass.contractWrapper();
        
        objWrapCon.getContract(obj.id);
        
        //testing handlePageException method
        pages_config__c objConfig = new pages_config__c();
        objConfig.Name = 'pepTechnicalException';
        objConfig.Page_Label__c = 'TechnicalException';
        insert objConfig;
        PageReference technicalExceptionPage = pepUtilityClass.handlePageException(new TestException('this is an exception'));
        
        System.assertEquals('/TechnicalException', technicalExceptionPage.getUrl());
    }
    
    public static void test1(){
        Account portalAccount1 ;
        User user1 ;
        Profile pdashboard = [SELECT Id FROM Profile WHERE Name='Custom Customer Community Login user'];
        UserRole portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            
            portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = usr1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
            //Create user
            Profile profileid  = [SELECT Id FROM Profile WHERE Name='Custom Customer Community Login user'];
            user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = profileid.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            
            
            
        }
        system.runas(user1 ){
            
            
            portalAccount1.pafss_Duplication_Check_Key__c = 'jay:elderidge:0410804074:ckefalianos@pepper.com.au:1972-01-20';
            update portalAccount1;
            
            clcommon__Party_Type__c oPT = new clcommon__Party_Type__c();
            oPT.Name = 'aaa';
            oPT.pafss_Is_Individual_Loan__c =true;
          //  oPT.ScCollection_is_ATP__c = true;
            oPT.ScCollection_Only_For_ESB__c =true;
            insert oPT;
            
            collect__Source_System__c  oSS = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
            
            collect__Loan_Account__c oLA = ScCollection_CommonTrackerClass.createTestContract(oSS.id);
            oLA.ScCollection_FP_Group_Name__c = 'Consumer Loan';
            update oLA;
            
            clcommon__Party__c objComParty = new clcommon__Party__c();
            objComParty.clcommon__Account__c = portalAccount1.id;
            objComParty.clcommon__Type__c = oPT.id;
            objComParty.collect__CL_Contract__c= oLA.id;
            insert objComPArty;
            
            pepUtilityClass.contractWrapper objWrapCon = new pepUtilityClass.contractWrapper();
            
            objWrapCon.getContract(portalAccount1.id);
            
            
        }
        
    }
    private static  Account objAccount;
    private static Contact objContact;
    private static Profile p ;
    private static UserRole portalRole1;
    private static user objUser;
    private static loan__Loan_Account__c objLoanAccount;
    
    public static void loadData()
    { 
        createAccount();
        createLoanAccount();
        createContact();
        createUser();
        
    }
    private static void createAccount()
    {     
        objAccount=  new Account();
        objAccount.LastName ='testAcc';
        objAccount.PersonEmail ='sandip.bijlwan@saasfocus.com';
        objAccount.PersonBirthDate = system.today() - 4000;
        objAccount.PersonMobilePhone = '9090909090';
        objAccount.PersonMailingPostalCode='400101';
        objAccount.Is_Portal_User_Created__c =true;
        insert objAccount;
        
    }
    private static void createContact()
    {
        objContact = [select id,Accountid from contact where Accountid = : objAccount.id];
    }
    private static void createRoleAndProfile()
    {
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner','Custom Customer Community Login user', 'PowerCustomerSuccess',   'CustomerSuccess'};
            p = [select Id,name from Profile where name in :customerUserTypes limit 1];
        //portalRole1 = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    }
    private static void createLoanAccount()
    {
        objLoanAccount = pepCommonTrackerController.createLoanAccount();
        objLoanAccount.loan__Account__c = objAccount.id;
        update objLoanAccount;
        
        loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
        payMode.Name ='testPayMOde';
        insert payMode;
        
        loan__Automated_Payment_Setup__c automatedPayment = new loan__Automated_Payment_Setup__c();
        automatedPayment.loan__Active__c = true;
        automatedPayment.loan__Type__c = 'RECURRING';
        automatedPayment.loan__Debit_Date__c = system.today();
        automatedPayment.loan__CL_Contract__c = objLoanAccount.id;
        automatedPayment.loan__Frequency__c = 'Bi-Monthly';
        automatedPayment.loan__Payment_Mode__c = payMode.id;
        insert automatedPayment;
    }
    private static void createUser()
    {  
        createRoleAndProfile();
        objuser = new User();
        objUser.profileId = p.id;
        //objuser.userroleid = portalRole1.id;
        objuser.userName ='newUser@yahoo.com';
        objUser.email ='amit@test.com';
        objUser.emailencodingkey ='UTF-8';
        objUser.localesidkey ='en_US';
        objUser.languagelocalekey ='en_US';
        objUser.timezonesidkey ='America/Los_Angeles';
        objUser.alias ='ak';
        objUser.lastname ='kumar';
        objUser.contactId =objContact.Id;
        insert objUser;
        
    }
    
    @isTest 
    static void test0() {
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            test.startTest();
            loadData();
            clcommon__Party_Type__c oPT = new clcommon__Party_Type__c();
            oPT.Name = 'aaa';
            oPT.pafss_Is_Individual_Loan__c =true;
          //  oPT.ScCollection_is_ATP__c = true;
            oPT.ScCollection_Only_For_ESB__c =true;
            insert oPT;
            
            collect__Source_System__c  oSS = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
            
            collect__Loan_Account__c oLA = ScCollection_CommonTrackerClass.createTestContract(oSS.id);
            oLA.ScCollection_FP_Group_Name__c = 'Consumer Loan';
            update oLA;
            
            ScCollection_TriggerExecutionSettings__c objCustomSetting = new ScCollection_TriggerExecutionSettings__c();
            objCustomSetting.Name = 'All Trigger Execution';
            insert objCustomSetting;
            
            clcommon__Party__c objComParty = new clcommon__Party__c();
            objComParty.clcommon__Account__c = objAccount.id;
            objComParty.clcommon__Type__c = oPT.id;
            objComParty.collect__CL_Contract__c= oLA.id;
            //contact number added by: sushant kumar
           // objComParty.pepATPContactNumber__c = '123456789';
            Date currentDate = System.today();
            Date afterOneMonthDate = currentDate.addMonths(1);
           // objComParty.pepATP_Expiry_Date__c = afterOneMonthDate;
           // objComParty.pepVerbal_Password__c = 'testPass';
            
            insert objComParty;
            
            DashboardPAFSetting__c objDS = new DashboardPAFSetting__c();
            objDS.Name ='PAFDashboardSetting';
            objDS.PAF_Dashboard_Checkbox__c = true;
            insert objDS;
            
            
            test.stopTest();
        }
        
        system.runas(objUser)     
        { 
            pepUtilityClass.contractWrapper objWrapCon = new pepUtilityClass.contractWrapper();
            System.assertNotEquals(0, objWrapCon.getContract(objAccount.id).size());
            
        }
    }
    
    @isTest
    static void test2() {
        test.startTest();
        pages_config__c objConfig = new pages_config__c();
        objConfig.Name = 'pepTechnicalException';
        objConfig.Page_Label__c = 'TechnicalException';
        insert objConfig;
        
        pepUtilityClass.retrieveApplication(false, true, '0000');
        pepUtilityClass.getCurrrentString();
        pepUtilityClass.sendExceptionEmail('testReason');
        pages_config__c objConfig11 = new pages_config__c();
        objConfig11.name='pepincomepage';
        objConfig11.page_label__c ='incomepage';
        insert objConfig11;
        
        pepUtilityClass.safeDelete(objConfig11, 'pages_config__c');
        test.stopTest();
        List<pages_config__c> lssconfig = [Select Id, Name, isDeleted from pages_config__c Where Id =:objConfig11.Id];
        System.assertEquals(true, lssconfig.isEmpty());
    }
    
    public static testmethod void setParametersInCookiesAndApplicationTest() {
        
        test.startTest();
        Test.setCurrentPage(new Pagereference('/pepApplyNow'));
        Map<String, String> pageParameters = ApexPages.currentPage().getParameters();
        pageParameters.put('utm_source', 'utm_source');
        pageParameters.put('utm_medium', 'utm_medium');
        pageParameters.put('utm_campaign', 'utm_campaign');
        pageParameters.put('utm_content', 'utm_content');
        pageParameters.put('utm_term', 'utm_term');
        pageParameters.put('utm_referrer', 'utm_referrer');
        
        pageParameters.put('apex_Debit_Frequency_c', 'apex_Debit_Frequency_c');
        pageParameters.put('apex_Requested_Loan_Amount_c', 'apex_Requested_Loan_Amount_c');
        pageParameters.put('apex_Requested_Term_c', 'apex_Requested_Term_c');
        pageParameters.put('apex_genesisCredit_Rating_c', 'apex_genesisCredit_Rating_c');
        pageParameters.put('apex_genesisCL_Product_c', 'apex_genesisCL_Product_c');
        pageParameters.put('apex_genesisCL_Purpose_c', 'apex_genesisCL_Purpose_c');
        
        genesis__Applications__c app = pepUtilityClass.fillApplicationSourceInfo(new genesis__Applications__c());
        pepUtilityClass.setParametersInCookie();
        test.stopTest();
        System.assertEquals(app.Web_Analytics_Campaign__c, 'utm_campaign');
        
    }
    
    public class TestException extends Exception{}
}
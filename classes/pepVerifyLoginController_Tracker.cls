@isTest
public class pepVerifyLoginController_Tracker 
{
    @isTest static void Method_1() 
    {
        test.starttest();
        UserRole portalRole1;
        user objuser;
        Contact objCon;
        Account objAccount;
        loan__Automated_Payment_Setup__c automatedPayment;
        Loan__loan_Account__c objLoanAccount;
        Contact objContact1;
        pepBank_API_Details__c BankApi;
        loan__Bank_Account__c loanbank;
        map<string , string> maps;
        genesis__Applications__c objApplication;
        pepCmsSection__c  Sec_ReferAFriendSection1;
        pepCmsSection__c  Sec_ReferAFriendSection2;
        pepCmsPage__c objPage;
        pepCmsQuestion__c Ques_Sec_ReferAFriendSection1;
        pepCmsQuestion__c Ques_Sec_ReferAFriendSection2;
        pepCmsAnswer__c Ans_Sec_ReferAFriendSection2;
        pages_config__c objpageConfig;
        pepCmsSection__c  Sec_ReferAFriendSection3;
        pepCmsPage__c objPage2;
        pepCmsQuestion__c Ques_Sec_ReferAFriendSection3;
        list<account> acclst;
        Pagereference pd1;
        pepVerifyLoginController objclass;
        set<integer> setInt;
        List<String> lstMonthsNames;
        Map<String,Decimal> mapOfMonthsToDatas;
        list<loan__Automated_Payment_Setup__c >lstPayLoan;
        OTP_Template__c objTem;
        DashboardProfileId__c dashprofile;
        Residential_Address__c resdentoaladdr;
        list<DashboardProfileId__c> dashboard;
        list<Residential_Address__c> lstresidential;
        
        Profile pdashboard = [SELECT Id FROM Profile WHERE Name='Custom Customer Community Login user'];
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            objpageConfig = new pages_config__c();
            objpageConfig = pepCommonTrackerController.createPagesConfig()[0];
            objpageConfig.Page_Label__c='PaymentHolidayDashBoard';
            objpageConfig.Name='peppaymentholidaydashboard';
            update objpageConfig;
            
            createPageConfigurations();
            
            //Page setup;            
            pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Forgot Set Password');
            
            Sec_ReferAFriendSection1= pepCommonTrackerController.createSection(objPage1);
            Sec_ReferAFriendSection1.pepSectionUniqueName__c='SectionFour(FSP)';
            Sec_ReferAFriendSection1.pepSectionBodyRich__c='Test';
            update Sec_ReferAFriendSection1;
            
            Sec_ReferAFriendSection2= pepCommonTrackerController.createSection(objPage1);
            Sec_ReferAFriendSection2.pepSectionUniqueName__c='PaymentHolidayDBSection2';
            Sec_ReferAFriendSection2.pepSectionBodyRich__c='Test';
            update Sec_ReferAFriendSection2; 
            
            Ques_Sec_ReferAFriendSection2=pepCommonTrackerController.createCmsQuestion(objPage1,Sec_ReferAFriendSection2);
            Ques_Sec_ReferAFriendSection2.pepSObjectApiName__c ='Account';
            Ques_Sec_ReferAFriendSection2.pepFieldApiName__c ='LastName';
            Ques_Sec_ReferAFriendSection2.pepType__c ='Text';
            update Ques_Sec_ReferAFriendSection2;
            
            Ans_Sec_ReferAFriendSection2=pepCommonTrackerController.createCmsAnswer(Ques_Sec_ReferAFriendSection2);
            Ans_Sec_ReferAFriendSection2.pepDisplayText__c = 'Select other';
            update Ans_Sec_ReferAFriendSection2;
            
            objPage2 = pepCommonTrackerController.createPage('Verify Login');
            
            Sec_ReferAFriendSection3= pepCommonTrackerController.createSection(objPage2);
            Sec_ReferAFriendSection3.pepSectionUniqueName__c='Verify Login Section 3';
            Sec_ReferAFriendSection3.pepSectionBodyRich__c='Test';
            update Sec_ReferAFriendSection3;
            
            Ques_Sec_ReferAFriendSection3=pepCommonTrackerController.createCmsQuestion(objPage2,Sec_ReferAFriendSection3);
            Ques_Sec_ReferAFriendSection3.pepSObjectApiName__c ='Account';
            Ques_Sec_ReferAFriendSection3.pepFieldApiName__c ='LastName';
            Ques_Sec_ReferAFriendSection3.pepType__c ='Text';
            update Ques_Sec_ReferAFriendSection3;
            
            objAccount=pepCommonTrackerController.createAccount(); 
            objLoanAccount = pepCommonTrackerController.createLoanAccount();
            objLoanAccount.Loan__Account__c=objAccount.id;
            update objLoanAccount;
            
            objAccount.Referral_Code__c='a13';
            objAccount.Is_Portal_User_Created__c=true;
            objAccount.Is_Account_Locked__c=true;
            objAccount.Second_OTP_Generation_Time__c=system.now();
            objAccount.PersonBirthDate=system.today();
            objAccount.Second_OTP__c='982640';
            objAccount.PersonBirthDate=system.today().addmonths(1);
            
            
            objAccount.Loan_Account_Id__c=objLoanAccount.id;
            update objAccount;
            
            
            
            //acclst.add(objAccount);            
            
            loanbank= pepCommonTrackerController.createLoanBankAccount(objAccount.id);
            
            loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
            payMode.Name ='testPayMOde';
            insert payMode;
            
            automatedPayment = new loan__Automated_Payment_Setup__c();
            automatedPayment.loan__Active__c = true;
            automatedPayment.loan__Type__c = 'RECURRING';
            automatedPayment.loan__Debit_Date__c = system.today();
            automatedPayment.loan__CL_Contract__c = objAccount.Loan_Account_Id__c;
            automatedPayment.loan__Frequency__c = 'weekly';
            automatedPayment.loan__Payment_Mode__c = payMode.id;
            automatedPayment.loan__Transaction_Amount__c=0;
            automatedPayment.loan__Recurring_ACH_Start_Date__c=system.today();
            automatedPayment.loan__Recurring_ACH_End_Date__c=system.today() + 3;
            insert automatedPayment;
            
            //objtem=pepCommonTrackerController.createOTPTemplate();
            List<Folder> folderLst = new List<Folder>();
            EmailTemplate e;
            folderLst = [Select Id,Name from Folder where Name =: 'PepperHTML' limit 1];
            
            e = new EmailTemplate (developerName = 'test', IsActive=True , FolderId = folderLst.get(0).Id, TemplateType= 'Text', Name = 'test'); 
            insert e;
            Second_OTP_Template__c objOtpTemplate = new Second_OTP_Template__c(Name='First',Template_Id__c=e.id, OTP_Duration__c='13');
            insert objOtpTemplate;
            
            BankApi=new pepBank_API_Details__c ();
            BankApi.pepBank_Name__c='Hello';
            insert BankApi;
            // loan.TestHelper.createSeedDataForTesting();
            
            // objContact1=pepCommonTrackerController.createContact();
            
            
            resdentoaladdr=pepCommonTrackerController.createResidential();
            resdentoaladdr.PostCode__c='123456';
            resdentoaladdr.Contact__c=objAccount.PersonContactId;
            update resdentoaladdr;
            
            lstresidential=new list<Residential_Address__c>();
            lstresidential.add(resdentoaladdr);
            
            objuser = pepCommonTrackerController.createuser();
            
            dashprofile =new DashboardProfileId__c ();
            dashprofile.name=pdashboard.id;
            insert dashprofile; 
            
            dashboard=new list<DashboardProfileId__c>();
            dashboard.add(dashprofile);
            system.debug('hello!!! '+dashprofile);
            
            
            
        }
        
        system.runas(objUser)     
        {
            maps=new map<string, string>();
            maps.put('abc', '123');
            Pagereference pd=Page.peppaymentholidaydashboard;
            Test.setcurrentPagereference(pd);
            ApexPages.currentPage().getParameters().put('id',pepEncryptDecryptData.EncryptData(String.valueof(objLoanAccount.id)));
            objclass=new pepVerifyLoginController();
            objclass.VerifyMe();
            objclass.lstDashboardProfileId=dashboard;
            //objclass.lstAccount=acclst;
            objclass.strDOB='2017/01/08';
            objclass.strPostCode='123456';
            objclass.objAccountId=objAccount.id;
            objclass.boolEnable=true;
            objclass.boolOTPDuration=true;
            objclass.boolChangePassword=true;
            objclass.Changepassword='123abc';
            objclass.Newpassword='123abc';
            objclass.password='982640';
            objclass.RedirectToLoginPage();
            objclass.lstResidentialAddress=lstresidential;
            objclass.VerifyMe();
            
            //objclass.test=maps;
            //objclass.ResendNow();
            objclass.GenerateOTP();
            objclass.loadCMSContent();
            objclass.checkcookie();
            pepVerifyLoginController.updateAccount(objAccount.id);
            objclass.ResendNow();
            objclass.SetOTP();
            objclass.ChangePassword();
            objclass.SetOTP();
            
            objclass=new pepVerifyLoginController();
            objclass.Changepassword='123abc';
            objclass.Newpassword='123abcaxz';
            objAccount.Is_Portal_User_Created__c=false;
            objAccount.Is_Account_Locked__c=false;
            update  objAccount;
            objclass.RedirectToLoginPage();
            objclass.ChangePassword();
            objclass.SetOTP();
            
            clcommon__Party_Type__c objParty = new clcommon__Party_Type__c();
            objParty.Name='Primary Borrower';
            objParty.pafss_Is_Individual_Loan__c = true;
            objParty.ScCollection_Only_For_ESB__c = false;
            insert objParty;
            
            clcommon__Party__c objP = new clcommon__Party__c ();
            objP.clcommon__Account__c = objAccount.id;
            objP.clcommon__Type__c = objParty.id;
            objP.ScCollection_Relationship__c = 'Relation';
            insert objP;
            
            ApexPages.currentPage().getParameters().put('id',pepEncryptDecryptData.EncryptData(String.valueof(objP.id)));
            pepVerifyLoginController objclass1=new pepVerifyLoginController();
            
            objclass1.strDOB='2017/01/08';
            objclass1.strPostCode='123456';
            objclass1.lstResidentialAddress = lstresidential;
            objclass1.VerifyMe();
            
            objAccount.PersonBirthDate = date.newInstance(1960,1,1);
            objAccount.Second_OTP__c = 'passwd';
            update objAccount;
            
            objclass1.strDOB ='1960/1/1';
            objclass1.strPostCode='1234567';
            objclass1.VerifyMe();
            
            objclass1.password = 'passwd';
            objclass1.SetOTP();
            
            objAccount.pafss_Account_Locked_Counter__c =1;
            update objAccount;
            objclass1.password = 'passwd1';
            objclass1.SetOTP();  
            
            //added by : sushant kumar
            lstresidential[0].PostCode__c = '2222';
            lstresidential[0].Contact__c = objAccount.PersonContactId;
            update lstresidential;
            objclass1.strPostCode = '2222';
            objclass1.verifyMe();
         //   objclass1.getCurrentStateOfClass(); 
            System.assertNotEquals(null, objclass1.lstAccount[0].Id);
        }  
        test.stoptest(); 
    }
    
    public static testMethod void constructorRunTest() {
        
        Test.startTest();
        createPageConfigurations();
        
        Profile pdashboard = [SELECT Id FROM Profile WHERE Name='Custom Customer Community Login user'];
        DashboardProfileId__c profileInConfig = new DashboardProfileId__c(Name=pdashboard.Id);
        insert profileInConfig;
        
        Account objAccount = new Account();
        objAccount.RecordTypeId = [SELECT Name, SobjectType,IsPersonType FROM RecordType WHERE SobjectType='Account' AND IsPersonType=True][0].id;
        objAccount.PersonEmail = 'abc@gmail.com';
        objAccount.pepOTP_Email__c = 'abc@gmail.com';
        objAccount.PersonBirthdate = date.newInstance(1990, 11, 21);
        objAccount.BillingPostalCode = '2222';
        objAccount.ShippingPostalCode = '2222';
        objAccount.FirstName = 'sushant';
        objAccount.LastName = 'kumar';
        objAccount.collect__External_ID__pc = 'PAF123';
        insert objAccount;
        
        collect__Source_System__c objSourceSystem = new collect__Source_System__c(Name='PAF');
        insert objSourceSystem;
        
        collect__Loan_Account__c contract = new collect__Loan_Account__c();
        contract.Name = 'testContract';
        contract.collect__Source_System__c = objSourceSystem.Id;
        insert contract;
        
        clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(Name='Primary Borrower');
        partyType.pafss_Is_Individual_Loan__c = true;
        partyType.ScCollection_is_ATP__c = true;
        insert partyType;
        
        clcommon__Party__c party = new clcommon__Party__c();
        party.clcommon__Account__c = objAccount.id;
        party.collect__CL_Contract__c = contract.id;
        party.clcommon__Type__c = partyType.Id;
        Insert party;
        
        Test.setCurrentPage(new PageReference('/apex/pepSecondOtp'));
        Map<String, String> pageParameters = ApexPages.currentPage().getParameters();
        pageParameters.put('accId', objAccount.Id);
        ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('accountId', null, null, -1, false)});
        pepVerifyLoginController objController = new pepVerifyLoginController();
        
        objController.Changepassword = 'zxcvbnm@123';
        objController.Newpassword = 'zxcvbnm@123';
        PageReference redirectPage = objController.ChangePassword();
        system.debug('Test '+redirectPage);
        System.assertEquals(Label.LoginURL + 'loginpage', redirectPage.getUrl());
        
        //for catch block of changepassword()
        objController.LstDashboardProfileId = null;
        objController.ChangePassword();
        
        //for else part of changePassword();
        objController.accountidHolder = null;
        objController.objAccount2 = null;
        objController.ChangePassword();
        
        objController.RedirectToLoginPage();
        Test.stopTest();
    }
    
    
    public static testMethod void verifyMeTest() {
    
        Test.startTest();
        createPageConfigurations();
        Test.setCurrentPage(new PageReference('/apex/pepSecondOtp'));
        
        Account objAccount = new Account();
        objAccount.RecordTypeId = [SELECT Name, SobjectType,IsPersonType FROM RecordType WHERE SobjectType='Account' AND IsPersonType=True][0].id;
        objAccount.PersonEmail = 'abc@gmail.com';
        objAccount.pepOTP_Email__c = 'abc@gmail.com';
        objAccount.PersonBirthdate = date.newInstance(1990, 11, 21);
        objAccount.BillingPostalCode = '2222';
        objAccount.ShippingPostalCode = '2222';
        objAccount.PersonMailingPostalCode = '2222';
        objAccount.FirstName = 'sushant';
        objAccount.LastName = 'kumar';
        objAccount.collect__External_ID__pc = 'PAF123';
        insert objAccount;
        
        collect__Source_System__c objSourceSystem = new collect__Source_System__c(Name='PAF');
        insert objSourceSystem;
        
        collect__Loan_Account__c contract = new collect__Loan_Account__c();
        contract.Name = 'testContract';
        contract.collect__Source_System__c = objSourceSystem.Id;
        insert contract;
        
        clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(Name='Primary Borrower');
        partyType.pafss_Is_Individual_Loan__c = true;
        partyType.ScCollection_is_ATP__c = true;
        insert partyType;
        
        clcommon__Party__c party = new clcommon__Party__c();
        party.clcommon__Account__c = objAccount.id;
        party.collect__CL_Contract__c = contract.id;
        party.clcommon__Type__c = partyType.Id;
        Insert party;
        
        
        pepVerifyLoginController objController = new pepVerifyLoginController();
        objController.strDOB = '21/10/1990';
        objController.strPostCode = '2222';
        objController.accountidHolder = objAccount.id;
        objController.strObjectName = 'loan__Loan_Account__c';
        
        List<Account> lstAccount = [Select id, PersonContactId from account where id=: objAccount.id limit 1];
        
        Residential_Address__c residentialAddress = pepCommonTrackerController.createResidential();
        residentialAddress.PostCode__c = '2222';
        residentialAddress.Contact__c = lstAccount[0].PersonContactId;
        update residentialAddress;
        
        objController.verifyMe();
        
        objController.strDOB = '21/11/1990';
    objController.verifyMe();
        
        objController.strPostCode = '3333';
        objController.verifyMe();
        
        //for strObjectName = 'Party'
        
        objController.strObjectName = 'clcommon__Party__c';
        objController.objParty = [Select Id, ScCollection_Customer_Birth_Date__c, ScCollection_Customer_Post_Code__c from 
                                 clcommon__Party__c WHERE ID =:Party.Id][0];
        objController.strDOB = '21/11/1991';
        objController.verifyMe();
        
        objController.strPostCode = '2222';
        objController.verifyMe();
        
        objController.strPostCode = '3333';
        objController.strDOB = '21/11/1990';
        objController.verifyMe();
        
        objController.strPostCode = '2222';
        Pagereference redirectPage = objController.verifyMe();
        System.assertEquals('/SecondOtp', redirectPage.getUrl());
        
        Test.stopTest();
    }    
    
    public static void createPageConfigurations() {
        
        pages_config__c pg1 = new pages_config__c(Name='peploginpage',Page_Label__c='loginpage');
        insert pg1;
        
        pages_config__c pg2 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
        insert pg2;
        
        pages_config__c pg3 = new pages_config__c(Name='pepsetpassword',Page_Label__c='SetPassword');
        insert pg3;
        
        pages_config__c pg4 = new pages_config__c(Name='pepsecondotp',Page_Label__c='SecondOtp');
        insert pg4;
        
        pages_config__c pg5 = new pages_config__c(Name='pepTechnicalException',Page_Label__c='TechnicalException');
        insert pg5;
    }
}
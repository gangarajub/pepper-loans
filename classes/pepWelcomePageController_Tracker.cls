@isTest(SeeAllData=False)

private class pepWelcomePageController_Tracker 
{
	private static Profile p ;
    private static UserRole portalRole1;
    private static user objUser;
    private static  Account objAccount;
    private static Contact objContact;
    private static loan__Loan_Account__c objLoanAccount;
    private static List<loan__Loan_Account__c> lstLoanAcount;
    
    
    public static void loadData()
    { 
        createAccount();
        createLoanAccount();
        createContact();
        createUser();
        createSectionAndPage();
        
		clcommon__Party_Type__c oPT = new clcommon__Party_Type__c();
		oPT.Name = 'aaa';
		oPT.pafss_Is_Individual_Loan__c =true;
		oPT.ScCollection_is_ATP__c = true;
		oPT.ScCollection_Only_For_ESB__c =true;
		insert oPT;
		
		collect__Source_System__c  oSS = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
		
		collect__Loan_Account__c oLA = ScCollection_CommonTrackerClass.createTestContract(oSS.id);
		oLA.ScCollection_FP_Group_Name__c = 'Consumer Loan';
		update oLA;
		
		clcommon__Party__c objComParty = new clcommon__Party__c();
		objComParty.clcommon__Account__c = objAccount.id;
		objComParty.clcommon__Type__c = oPT.id;
		objComParty.collect__CL_Contract__c= oLA.id;
		insert objComPArty;
		
		DashboardPAFSetting__c objDS = new DashboardPAFSetting__c();
        objDS.Name ='PAFDashboardSetting';
		objDS.PAF_Dashboard_Checkbox__c = true;
        insert objDS;
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
    
    
    //This method creates account
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

  
    private static void createSectionAndPage()
    {
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
          
        PageReference pageRef = Page.pepWelcomePage;
        Test.setCurrentPagereference(pageRef);
   
        pepCmsPage__c cmsPage = pepCommonTrackerController.createPage('Welcome');
        pepCmsSection__c cmsSection =  pepCommonTrackerController.createSection(cmsPage);
        cmsSection.pepSectionUniqueName__c = 'Welcome Section 1';
        cmsSection.pepType__c = 'Marketing Ad';
        cmsSection.pepSectionBodyRich__c = 'testBodyRich';
        update cmsSection;
        
        pages_config__c pageConfig =  pepCommonTrackerController.createPagesConfig()[25];    
        
    }
    
    @isTest static void pepWelcomePageControllerTest0() {
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
           test.startTest();
            loadData();
           test.stopTest();
        }
        
        system.runas(objUser)     
        { 
            
            pages_config__c pg1 = new pages_config__c(Name='pepviewmyloanpage',Page_Label__c='ViewMyLoanPage');
            insert pg1;
            pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
           
            System.currentPageReference().getParameters().put('LoanAccountId','testLoan');  
            pepWelcomePageController objClass = new pepWelcomePageController();
            objClass.AccountId = objAccount.id;
            objClass.nextRepaymentAmount = 'repaymentAmount';
            objClass.nextRepaymentDate = 'repaymentDate';
            objClass.lstloancontract = lstLoanAcount;
            objClass.strAccountName = 'accName';
            objClass.PageLoanId = 'testLoan';
            objClass.ViewMyLoan();
            objClass.updateAccount();
            Pagereference pd=Page.pepviewmyloanpage;
            Test.setcurrentPagereference(pd);
            objClass.redirectToPage();
        }
    }
    
    @isTest static void pepWelcomePageControllerTest1() {
        pages_config__c pageConfig0 =  pepCommonTrackerController.createPagesConfig()[26];
        PageReference pageRef1 = Page.pepchangeProfile;
        Test.setCurrentPagereference(pageRef1);
        
            pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
        pepWelcomePageController objClass1 = new pepWelcomePageController();
    }
    
    @isTest static void pepWelcomePageControllerTest2() {
        pages_config__c pageConfig2 =  pepCommonTrackerController.createPagesConfig()[26];
        PageReference pageRef2 = Page.pepReferAFriend;
        Test.setCurrentPagereference(pageRef2);
          pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
        pepWelcomePageController objClass2 = new pepWelcomePageController();
    }
    
    @isTest static void pepWelcomePageControllerTest5() {
        pages_config__c pageConfig7 =  pepCommonTrackerController.createPagesConfig()[24];
        PageReference pageRef5 = Page.pepTransactionHistory;
        Test.setCurrentPagereference(pageRef5);
            pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
        pepWelcomePageController objClass5 = new pepWelcomePageController();
    }
    
    @isTest static void pepWelcomePageControllerTest8() {
        pages_config__c pageConfig8 =  pepCommonTrackerController.createPagesConfig()[23];
        PageReference pageRef8 = Page.pepChangePaymentsFrequency;
        Test.setCurrentPagereference(pageRef8);
            pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
        pepWelcomePageController objClass8 = new pepWelcomePageController();
    }
    
    @isTest static void pepWelcomePageControllerTest3() {
        pages_config__c pageConfig1 =  pepCommonTrackerController.createPagesConfig()[25];
        PageReference pageRef3 = Page.pepContactCentre;
        Test.setCurrentPagereference(pageRef3);
            pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
        pepWelcomePageController objClass3 = new pepWelcomePageController();
    }
    
    @isTest static void pepWelcomePageControllerTest7() {
        pages_config__c pageConfig4 =  pepCommonTrackerController.createPagesConfig()[25];
        PageReference pageRef7 = Page.pepAdjustRepayments;
        Test.setCurrentPagereference(pageRef7);
            pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
        pepWelcomePageController objClass7 = new pepWelcomePageController();
    }




}
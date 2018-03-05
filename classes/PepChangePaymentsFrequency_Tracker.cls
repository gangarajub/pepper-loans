@isTest(SeeAllData=False)

private class PepChangePaymentsFrequency_Tracker 
{
    public static User usr;
    public static loan__Loan_Account__c loanAcc;
    private static  Account objAccount;
    private static Contact objContact;
    private static loan__Loan_Account__c objLoanAccount;
    private static loan__Automated_Payment_Setup__c automatedPayment;
    public static genesis__Applications__c objApplication;
    
    private static void createData()
    {
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
        
        pepCmsPage__c cmsPage = pepCommonTrackerController.createPage('Change payments frequency');
        pepCmsSection__c cmsSection =  pepCommonTrackerController.createSection(cmsPage);
        cmsSection.pepSectionBodyRich__c = 'test rich area';
        update cmsSection;
        
         pages_config__c objConfig = new pages_config__c();
         objConfig.Page_Label__c='ViewMyLoanPage';
         objConfig.Name='pepviewmyloanpage';
         insert objConfig;
         pages_config__c objConfig1 = new pages_config__c();
         objConfig1.Page_Label__c='ChangePaymentsFrequency';
         objConfig1.Name='pepchangepaymentsfrequency';
         insert objConfig1;
        
        loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
        payMode.Name ='testPayMOde';
        insert payMode;
       
        automatedPayment = new loan__Automated_Payment_Setup__c();
        automatedPayment.loan__Active__c = true;
        automatedPayment.loan__Type__c = 'RECURRING';
        automatedPayment.loan__Debit_Date__c = system.today();
        automatedPayment.loan__CL_Contract__c = objLoanAccount.id;
        automatedPayment.loan__Frequency__c = 'bi-weekly';
        automatedPayment.loan__Payment_Mode__c = payMode.id;
        automatedPayment.loan__Transaction_Amount__c = 200000;
        insert automatedPayment;
        
        objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();

    }   
    
    @isTest static void PepChangePaymentsFrequencyTest0() {
        
        
        UserRole portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        system.runas(usr1)     
        {
            
           
            objAccount = pepCommonTrackerController.createAccount1();
            objLoanAccount = pepCommonTrackerController.createLoanAccount1();
            objLoanAccount.loan__ACH_Debit_Amount__c = 1000000;
            update objLoanAccount;
            objAccount.Loan_Account_Id__c = objLoanAccount.Id;
            update objAccount;
            
            pepCommonTrackerController.createContact1();
            usr = pepCommonTrackerController.createUser1();
        test.startTest();    
            createData();
         test.StopTest();   
        }
        
        system.runas(usr)     
        { 
            
        PepChangePaymentsFrequency objClass = new PepChangePaymentsFrequency();
        objClass.objLoanAccount = objLoanAccount;
        objClass.getFrequency();
        objClass.cancelRedirection();
        objClass.calculateRepaymentValue();
        objClass.updateLoanAccount();
        
        PepChangePaymentsFrequency objClass1 = new PepChangePaymentsFrequency();
        objClass1.selectedFrequency = 'weekly';
        automatedPayment.loan__Frequency__c = 'weekly';
        update automatedPayment;
        objClass1.calculateRepaymentValue();
        objClass1.updateLoanAccount();
        
        PepChangePaymentsFrequency objClass2 = new PepChangePaymentsFrequency();
        objClass2.selectedFrequency= 'monthly';
        automatedPayment.loan__Frequency__c = 'monthly';
        update automatedPayment;
        objClass2.objAutomatedPayment = automatedPayment;
        objClass2.calculateRepaymentValue();
        objClass2.updateLoanAccount();
        }
        
    }
}
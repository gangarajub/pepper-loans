/*
This class is reference to peppepMakeOneOffPaymentsController
Created By Sudipta
Created On : 24-06-2016
*/
@isTest
public Class pepMakeOneOffPayments_Tracker
{
  
   static testMethod void testpepMakeOneOffPayments() 
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
        
        genesis__Applications__c objApplication;
         pepCmsSection__c  Sec_ReferAFriendSection1;
         pepCmsSection__c  Sec_ReferAFriendSection2;
         pepCmsPage__c objPage;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection1;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection2;
          pepCmsAnswer__c Ans_Sec_ReferAFriendSection2;
        pages_config__c objpageConfig;
        Pagereference pd1;
        peppepMakeOneOffPaymentsController objclass;
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            objpageConfig = new pages_config__c();
            objpageConfig = pepCommonTrackerController.createPagesConfig()[0];
            objpageConfig.Page_Label__c='MakeOneOffPayments';
            objpageConfig.Name='pepmakeoneoffpayments';
            update objpageConfig;
            
           pages_config__c objConfig = new pages_config__c();
           objConfig.Page_Label__c='ViewMyLoanPage';
           objConfig.Name='pepviewmyloanpage';
           insert objConfig;
           
           pages_config__c objConfig1 = new pages_config__c();
           objConfig1.Page_Label__c='TransactionHistory';
           objConfig1.Name='peptransactionhistory';
           insert objConfig1;
            
            //Page setup;            
            pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Make One Off Payment');
            
            
            Sec_ReferAFriendSection2= pepCommonTrackerController.createSection(objPage1);
            Sec_ReferAFriendSection2.pepSectionUniqueName__c='Contact Centre Section 6';
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
            
            objAccount=pepCommonTrackerController.createAccount1();
            objAccount.Referral_Code__c='a13';
            update objAccount;
            
            objAccount.Loan_Account_Id__c=pepCommonTrackerController.createLoanAccount().id;
            update objAccount;
            
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
            automatedPayment.loan__Transaction_Amount__c=1000;
            insert automatedPayment;
            
            BankApi=new pepBank_API_Details__c ();
            BankApi.pepBank_Name__c='Hello';
            insert BankApi;
            // loan.TestHelper.createSeedDataForTesting();
            
            objContact1=pepCommonTrackerController.createContact1();
            
            objuser = pepCommonTrackerController.createUser1();
            
            
        }
        
        system.runas(objUser)     
        {
            objclass=new peppepMakeOneOffPaymentsController();
            //objclass.strAmount=9.0;
            objclass.CreateBankAccount();
            objclass.getBankAPIDetails();
            objclass.CancelMethod();
            objclass.redirectOK();
            objclass.checkcookie();
            objclass.inputDate='8/13/2016';
            objclass.strBSB='8/13/2016';
            objclass.strDoB='8/13/2016';
            objclass.strAccountNumber='1234567789';
            objclass.strAccountHolderName='Test';
            
            objclass=new peppepMakeOneOffPaymentsController();
            objclass.strAmount=9.0;
            objclass.CreateBankAccount();
            objclass.getBankAPIDetails();
            objclass.CancelMethod();
            objclass.redirectOK();
            objclass.checkcookie();
             
        }
        test.stoptest();
    }
}
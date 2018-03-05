@isTest
public class pepPromisetopayController_Tracker 
{
    @isTest static void Method_1() 
    {
        Test.startTest();
        
        UserRole portalRole1;
        user objuser;
        Contact objCon;
        Account objAccount;
        loan__Automated_Payment_Setup__c automatedPayment;
        Loan__loan_Account__c objLoanAccount;
        Contact objContact1;
        pepBank_API_Details__c bankAPI;
        loan__Bank_Account__c loanbank;
        
        genesis__Applications__c objApplication;
         pepCmsSection__c  Sec_ReferAFriendSection1;
         pepCmsSection__c  Sec_ReferAFriendSection2;
         pepCmsPage__c objPage;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection1;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection2;
          pepCmsAnswer__c Ans_Sec_ReferAFriendSection2;
        
        Pagereference pd1;
        pepPromisetopayController objclass;
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
                        
             pages_config__c pg1 = new pages_config__c(Name='peppersonaldetails',Page_Label__c='PersonalDetails');
            insert pg1;
            pages_config__c pg11 = new pages_config__c(Name='peptransactionhistory',Page_Label__c='TransactionHistory');
            insert pg11;
            pages_config__c pg12 = new pages_config__c(Name='pepviewmyloanpage',Page_Label__c='ViewMyLoanPage');
            insert pg12;
            pages_config__c pg13 = new pages_config__c(Name='peppendingmakeoneoffpayment',Page_Label__c='PendingMakeOneOffPayment');
            insert pg13;
            pages_config__c pg14 = new pages_config__c(Name='peppromisetopay',Page_Label__c='PromiseToPay');
            insert pg14;
             pages_config__c pg15 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='ContactCentre');
            insert pg15;
            
            
            //Page setup;            
            pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Promise to pay');
            
            
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
            
            objAccount.Loan_Account_Id__c=pepCommonTrackerController.createLoanAccount1().id;
            update objAccount;
            
            loanbank= pepCommonTrackerController.createLoanBankAccount(objAccount.id);
            
            loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
            payMode.Name ='Direct Debit';
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
            
            bankAPI=new pepBank_API_Details__c ();
            bankAPI.pepBank_Name__c='Hello';
            insert bankAPI;
            // loan.testhelper.createSeedDataForTesting();
            
            objContact1=pepCommonTrackerController.createContact1();
            
            objuser = pepCommonTrackerController.createUser1();
            
            
        }
        
        system.runas(objUser)     
        {
            
            pd1=Page.pepcontactcentre;
            Test.setcurrentPagereference(pd1);
            objclass =new pepPromisetopayController();
            //objclass.selectedAccount='Create New...';
            objclass.inputDate='8/13/2016';
            objclass.strBSB='8/13/2016';
            objclass.strDoB='8/13/2016';
            objclass.strAccountNumber='1234567789';
            objclass.strAccountHolderName='Test';
            
            objclass.getBankAPIDetails();
            objclass.checkcookie();
            objclass.CancelMethod();
            objclass.redirectOK();
            objclass.CreateBankAccount();
            
            objclass.strAmount=0.0;
            objclass =new pepPromisetopayController();
        }
        Test.stopTest();
     }
}
@isTest
public class pepViewMyLoanController_Tracker 
{
    @isTest static void Method_1() 
    {
        
        UserRole portalRole1;
        user objuser;
        Contact objCon;
        Account objAccount;
        loan__Automated_Payment_Setup__c automatedPayment;
        Loan__loan_Account__c objLoanAccount;
        
         genesis__Applications__c objApplication;
         pepCmsSection__c  Sec_ReferAFriendSection1;
         pepCmsSection__c  Sec_ReferAFriendSection2;
         pepCmsPage__c objPage;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection1;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection2;
          pepCmsAnswer__c Ans_Sec_ReferAFriendSection2;
        pages_config__c objpageConfig;
        Pagereference pd1;
        pepViewMyLoanController objclass;
         
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            objpageConfig = new pages_config__c();
            objpageConfig = pepCommonTrackerController.createPagesConfig()[0];
            objpageConfig.Page_Label__c='pepviewmyloanpage';
            objpageConfig.Name='pepviewmyloanpage';
            update objpageConfig;
            
            //Page setup;
           pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('View My Loan Page');
           
           //Section Creation
           Sec_ReferAFriendSection1= pepCommonTrackerController.createSection(objPage1);
           Sec_ReferAFriendSection1.pepSectionUniqueName__c='SectionSeventeen(VMLP)';
           update Sec_ReferAFriendSection1;  
            
        Sec_ReferAFriendSection2= pepCommonTrackerController.createSection(objPage1);
        Sec_ReferAFriendSection2.pepSectionUniqueName__c='ReferAFriendSection2';
        update Sec_ReferAFriendSection2; 
        
        Ques_Sec_ReferAFriendSection2=pepCommonTrackerController.createCmsQuestion(objPage1,Sec_ReferAFriendSection2);
        Ques_Sec_ReferAFriendSection2.pepSObjectApiName__c ='Account';
        Ques_Sec_ReferAFriendSection2.pepFieldApiName__c ='LastName';
        Ques_Sec_ReferAFriendSection2.pepType__c ='Button';
        update Ques_Sec_ReferAFriendSection2;
        
        Ans_Sec_ReferAFriendSection2=pepCommonTrackerController.createCmsAnswer(Ques_Sec_ReferAFriendSection2);
        Ans_Sec_ReferAFriendSection2.pepDisplayText__c = 'Select other';
        update Ans_Sec_ReferAFriendSection2;
           
           objAccount=pepCommonTrackerController.createAccount1();
          objAccount.Referral_Code__c='a13';
          update objAccount;
          
          objAccount.Loan_Account_Id__c=pepCommonTrackerController.createLoanAccount1().id;
           update objAccount;
          
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
           
           pepCommonTrackerController.createContact1();
       
           objuser = pepCommonTrackerController.createUser1();
           
           
           //objWrapqUes .objCmsQuestion=Ques_Sec_ReferAFriendSection2;
           //objWrapqUes .objCmsAnswer=Ans_Sec_ReferAFriendSection2;
        }
        
         system.runas(objUser)     
        {
            test.startTest();
             pd1=Page.pepviewmyloanpage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            objclass.strName='Test';
            objclass.updateAccount();
            objclass.changeloanName();
            objclass.redirectToPage();

            objclass.disablelinks();
            
            pd1=Page.pepchangeProfile;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            pd1=Page.pepWelcomePage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            pd1=Page.pepContactCentre;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            
            pd1=Page.pepPaymentDetails;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            pd1=Page.pepTransactionHistory;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            
            pd1=Page.pepmakeoneoffpayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
          test.stopTest();
            pd1=Page.pepAdjustRepayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            pd1=Page.PepChangePaymentsFrequency;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            
            pd1=Page.PepPaymentHolidayDashBoard;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            
            pd1=Page.peppayoutloanpage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
            pd1=Page.pepReferAFriend;
            Test.setcurrentPagereference(pd1);
            objclass=new pepViewMyLoanController();
            
          
            
        }
        }
}
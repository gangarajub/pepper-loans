@isTest
public class pepContactCentreController_Tracker 
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
        
        genesis__Applications__c objApplication;
         pepCmsSection__c  Sec_ReferAFriendSection1;
         pepCmsSection__c  Sec_ReferAFriendSection2;
         pepCmsPage__c objPage;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection1;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection2;
          pepCmsAnswer__c Ans_Sec_ReferAFriendSection2;
        pages_config__c objpageConfig;
        Pagereference pd1;
        pepContactCentreController objclass;
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            objpageConfig = new pages_config__c();
            
            
             pages_config__c objConfig = new pages_config__c();
           objConfig.Page_Label__c='ViewMyLoanPage';
           objConfig.Name='pepviewmyloanpage';
           insert objConfig;
           
           
           pages_config__c objConfig1 = new pages_config__c();
           objConfig1.Page_Label__c='ContactCentre';
           objConfig1.Name='pepcontactcentre';
           insert objConfig1;
            
            //Page setup;            
            pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Contact Centre');
            
            
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
            pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
            objContact1=pepCommonTrackerController.createContact1();
            
            objuser = pepCommonTrackerController.createUser1();
        }
        
        system.runas(objUser)     
        {
            pd1=Page.pepcontactcentre;
            Test.setcurrentPagereference(pd1);
            objclass =new pepContactCentreController ();
            objclass.selectedEnquiryIssue='Hello';
            objclass.StrPreferredContact=objContact1.id;
            objclass.strPhone='1289483278';
            objclass.strEmail='tEST@gmail.com';
            objclass.selectedLoanAccount=objAccount.id;
            objclass.selectedBestTime='12:12 PM';
            objclass.updateAccount();
            objclass.Cancel();
            objclass.Saveenquiry();
            objclass.redirectToPage();
          
            pd1=Page.pepchangeProfile;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            pd1=Page.pepWelcomePage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            pd1=Page.pepContactCentre;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            
            pd1=Page.pepPaymentDetails;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            pd1=Page.pepTransactionHistory;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
           Test.StopTest();  
            pd1=Page.pepmakeoneoffpayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            pd1=Page.pepAdjustRepayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            pd1=Page.PepChangePaymentsFrequency;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            
            pd1=Page.PepPaymentHolidayDashBoard;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController ();
            
            
            pd1=Page.peppayoutloanpage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController  ();
            
            pd1=Page.pepReferAFriend;
            Test.setcurrentPagereference(pd1);
            objclass=new pepContactCentreController  ();
            pepContactCentreController objclass1 = new pepContactCentreController();
            objclass1.selectedLoanAccount = 'loan__Loan_Account__c';
            objclass1.removeEnquiryOptions();
            pepContactCentreController objclass2 = new pepContactCentreController();
            objclass2.selectedLoanAccount = 'collect__Loan_Account__c';
            
            
            objclass2.selectedEnquiryIssue = 'abcd';
            objclass2.strDescription = 'haaha';
            objclass2.selectedBestTime = 'Morning';
            objclass2.Saveenquiry();
            objclass2.removeEnquiryOptions();
            
        }
        
     }
}
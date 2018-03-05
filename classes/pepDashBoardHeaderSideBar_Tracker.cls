@isTest
public class pepDashBoardHeaderSideBar_Tracker 
{
    @isTest static void Method_1() 
    {
        test.starttest();
        UserRole portalRole1;
         user objuser;
         Contact objCon;
         Account objAccount;
          Pagereference pd1;
         loan__Automated_Payment_Setup__c automatedPayment;
         pepDashBoardHeaderSideBarController objclass; 
         
        Loan__loan_Account__c objLoanAccount;
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
           pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Adjust repayments');
        
           //Section Creation
           pepCmsSection__c objSection1 = new pepCmsSection__c();
           objSection1 = pepCommonTrackerController.createSection1(objPage1);
           objSection1.pepSectionUniqueName__c = 'LoanDetailsSection1';
           objSection1.pepSectionBodyRich__c='test story';
           update objSection1;
           
           pages_config__c objConfig = new pages_config__c();
           objConfig.Page_Label__c='ViewMyLoanPage';
           objConfig.Name='pepviewmyloanpage';
           insert objConfig;
           
           pages_config__c objConfig1 = new pages_config__c();
           objConfig1.Page_Label__c='changeProfile';
           objConfig1.Name='pepchangeprofile';
           insert objConfig1;
           
           pages_config__c objConfig2 = new pages_config__c();
           objConfig2.Page_Label__c='welcomepage';
           objConfig2.Name='pepwelcomepage';
           insert objConfig2;
           
           objAccount=pepCommonTrackerController.createAccount1();
      
           objLoanAccount = pepCommonTrackerController.createLoanAccount1();
          objLoanAccount.DocumentInbox__c= true;
           update objLoanAccount;
          
           objAccount.Loan_Account_Id__c=objLoanAccount.id;
           update objAccount;
          
           loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
           payMode.Name ='testPayMOde';
           insert payMode;
       
           automatedPayment = new loan__Automated_Payment_Setup__c();
           automatedPayment.loan__Active__c = true;
           automatedPayment.loan__Type__c = 'RECURRING';
           automatedPayment.loan__Debit_Date__c = system.today();
           automatedPayment.loan__CL_Contract__c = objLoanAccount.id;
           automatedPayment.loan__Frequency__c = 'weekly';
           automatedPayment.loan__Payment_Mode__c = payMode.id;
           automatedPayment.loan__Transaction_Amount__c=1000;
           insert automatedPayment;
           
           pepCommonTrackerController.createContact1();
       
           objuser = pepCommonTrackerController.createUser1();
        }
        system.runas(objUser)     
        {
            pd1=Page.pepchangeProfile;
            Test.setcurrentPagereference(pd1);
           objclass=new pepDashBoardHeaderSideBarController ();
           objclass.loadSidebarData();
           objclass.updateAccount();
           objLoanAccount.Loan_Name__c='fdsa';
           update objLoanAccount;
           objclass.changeloanName();
           
           pd1=Page.pepchangeProfile;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ('test');
            objclass.loadSidebarData();
            objclass.redirectToPage();
            
            pd1=Page.pepWelcomePage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            pd1=Page.pepReferAFriend;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            pd1=Page.peppromisetopay;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            pd1=Page.pepPendingMakeOneOffPayment;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            
            pd1=Page.pepPaymentDetails;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            pd1=Page.pepTransactionHistory;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            pd1=Page.pepmakeoneoffpayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            
            pd1=Page.pepAdjustRepayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            
            pd1=Page.pepChangePaymentsFrequency;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            pd1=Page.pepPaymentHolidayDashBoard;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
          test.stoptest();  
            pd1=Page.peppayoutloanpage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objclass.loadSidebarData();
            
            pd1=Page.pepDocumentInbox;
            Test.setcurrentPagereference(pd1);
            objclass=new pepDashBoardHeaderSideBarController ();
            objLoanAccount.DocumentInbox__c=true;
            update objLoanAccount;
            objclass.loadSidebarData();
            
            pd1=Page.pepChangePaymentsFrequency;
            Test.setcurrentPagereference(pd1);
            objclass.closedLoan=true;
            objClass.loadSidebarData();

        }
        
    }
}
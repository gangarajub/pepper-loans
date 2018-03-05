@isTest
public class pepReferAFriendController_Tracker 
{
    @isTest static void Method_1() 
    {
       
        UserRole portalRole1;
         user objuser;
         Contact objCon;
         Account objAccount;
         loan__Automated_Payment_Setup__c automatedPayment;
         pepReferAFriendController objclass; 
         
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
         ReferralCodeTemplateId__c cusonsett;
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
          pages_config__c pg2 = new pages_config__c(Name='pepwelcomepage',Page_Label__c='welcomepage');
            insert pg2;
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
        User usr = new User();
        system.runas(usr1)     
        {
            objpageConfig = new pages_config__c();
            objpageConfig = pepCommonTrackerController.createPagesConfig()[0];
            objpageConfig.Page_Label__c='pepreferafriend';
            objpageConfig.Name='pepreferafriend';
            update objpageConfig;
            
           objpageConfig = new pages_config__c();
            objpageConfig = pepCommonTrackerController.createPagesConfig()[0];
            objpageConfig.Page_Label__c='ReferAFriend';
            objpageConfig.Name='pepreferafriend';
            update objpageConfig;
            
            pages_config__c pg1 = new pages_config__c(Name='pepviewmyloanpage',Page_Label__c='ViewMyLoanPage');
            insert pg1;
            
            //Page setup;
           pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Refer A Friend');
           
           //Section Creation
           Sec_ReferAFriendSection1= pepCommonTrackerController.createSection(objPage1);
           Sec_ReferAFriendSection1.pepSectionUniqueName__c='ReferAFriendSection1';
           update Sec_ReferAFriendSection1;  
            
            Sec_ReferAFriendSection2= pepCommonTrackerController.createSection(objPage1);
            Sec_ReferAFriendSection2.pepSectionUniqueName__c='ReferAFriendSection2';
            update Sec_ReferAFriendSection2; 
            
            Ques_Sec_ReferAFriendSection2=pepCommonTrackerController.createCmsQuestion(objPage1,Sec_ReferAFriendSection2);
            Ques_Sec_ReferAFriendSection2.pepSObjectApiName__c ='Account';
            Ques_Sec_ReferAFriendSection2.pepFieldApiName__c ='Referral_Code__c';
            Ques_Sec_ReferAFriendSection2.pepType__c ='Text';
            update Ques_Sec_ReferAFriendSection2;
            
            Ans_Sec_ReferAFriendSection2=pepCommonTrackerController.createCmsAnswer(Ques_Sec_ReferAFriendSection2);
            Ans_Sec_ReferAFriendSection2.pepDisplayText__c = 'Select other';
            update Ans_Sec_ReferAFriendSection2;
           
            
           
           objAccount=pepCommonTrackerController.createAccount1();
            objAccount.Referral_Code__c='a13';
          update objAccount;
      
           objLoanAccount = pepCommonTrackerController.createLoanAccount1();
           objLoanAccount.DocumentInbox__c= true;
         //  update objLoanAccount;
          
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
           
           cusonsett=new ReferralCodeTemplateId__c();
           cusonsett.name='test';
           cusonsett.Referral_link__c='www.google.com';
           insert cusonsett;
        }
        system.runas(objUser)     
        {
            pd1=Page.pepreferafriend;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController();
            
            pepReferAFriendController.wrapperQuestion objWrapqUes = new  pepReferAFriendController.wrapperQuestion(Ques_Sec_ReferAFriendSection2,Ans_Sec_ReferAFriendSection2,'test@gmail.com');
            list<pepReferAFriendController.wrapperQuestion> lstWrapper=new list<pepReferAFriendController.wrapperQuestion>();
            lstWrapper.add(objWrapqUes);
            objclass.lstWrapperQuestionSection2=lstWrapper;
            
            objclass.isError=true;
            objclass.application=objApplication;
           
            objclass.cancel();
            objclass.updateAccount();
            objclass.updateAccount();
            objclass.referFriend();
            
            pd1=Page.pepchangeProfile;
            Test.setcurrentPagereference(pd1);
           objclass=new pepReferAFriendController ();
            
            pd1=Page.pepWelcomePage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            
            pd1=Page.pepContactCentre;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            
            
            pd1=Page.pepPaymentDetails;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            
            pd1=Page.pepTransactionHistory;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            
            
            pd1=Page.pepmakeoneoffpayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
        
         test.starttest();    
            pd1=Page.pepAdjustRepayments;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            
            pd1=Page.pepChangePaymentsFrequency;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            
            
            pd1=Page.pepPaymentHolidayDashBoard;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            
            
            pd1=Page.peppayoutloanpage;
            Test.setcurrentPagereference(pd1);
            objclass=new pepReferAFriendController ();
            test.stoptest();
        }
        
    }
}
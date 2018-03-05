@isTest(SeeAllData=False) private class pepHardshipController_Tracker{
    
    
    @isTest static void pepHardshipControllerTest(){
        
         UserRole portalRole1;
         user objuser;
         Contact objCon;
         Account objAccount;
         
         loan__Automated_Payment_Setup__c automatedPayment;
    Test.StartTest();     
        Loan__loan_Account__c objLoanAccount;
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
     Test.StopTest();   
        system.runas(usr1)     
        {
           pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Hardship');
        
           //Section Creation
           pepCmsSection__c objSection1 = new pepCmsSection__c();
           objSection1 = pepCommonTrackerController.createSection1(objPage1);
           objSection1.pepSectionUniqueName__c = 'Hardship Section 19';
           objSection1.pepSectionBodyRich__c='test story';
           update objSection1;
           
           objAccount=pepCommonTrackerController.createAccount1();
      
           objLoanAccount = pepCommonTrackerController.createLoanAccount1();
          // objLoanAccount.loan__Principal_Remaining__c = 2000000000;
           //update objLoanAccount;
          
           objAccount.Loan_Account_Id__c=objLoanAccount.id;
           update objAccount;
           
           pages_config__c objConfig2 = new pages_config__c();
           objConfig2.Page_Label__c='welcomepage';
           objConfig2.Name='pepwelcomepage';
           insert objConfig2;
           
          
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
             Pagereference pd=Page.pephardship;
            Test.setcurrentPagereference(pd);
        
            
            pages_config__c pg = new pages_config__c(Name='pephardship',Page_Label__c='pepHardship');
            insert pg;
            
            pages_config__c pg1 = new pages_config__c(Name='pepviewmyloanpage',Page_Label__c='ViewMyLoanPage');
            insert pg1;
            
            pages_config__c objConfig1 = new pages_config__c();
            objConfig1.Page_Label__c='welcomepage';
            objConfig1.Name='pepwelcomepage';
            insert objConfig1;
            
              
            pages_config__c pg3 = new pages_config__c(Name='pepreferafriend',Page_Label__c='referafriend');
            insert pg3;
            pages_config__c pg4 = new pages_config__c(Name='pepcontactcentre',Page_Label__c='contactcentre');
            insert pg4;
            pages_config__c pg5 = new pages_config__c(Name='pepchangeprofile',Page_Label__c='changeprofile');
            insert pg5;
            
            pagereference p = page.pepHardship;
            Test.SetcurrentPage(p);
            
            pepHardshipController obj = new pepHardshipController();
            obj.selectedBestTime='Morning (9am – 12pm)';
            obj.selectedHardshipReason='Under Employment';
            obj.selectedtype='Reduced Payments';
            obj.selectedassistance='Less than 1 month';
            obj.Step=1;
            obj.Saveenquiry();
            
            obj.updateAccount();
            obj.Cancel();
            obj.checkClosedLoan();
            obj.upload();
            
            integer a=obj.pageStepNumber('pepchangeProfile');
            integer a1=obj.pageStepNumber('pepWelcomePage');
            integer a2=obj.pageStepNumber('pepReferAFriend');
            integer a3=obj.pageStepNumber('pepPaymentDetails');
            integer a4=obj.pageStepNumber('pepTransactionHistory');
            integer a5=obj.pageStepNumber('pepmakeoneoffpayments');
            integer a6=obj.pageStepNumber('pepAdjustRepayments');
            integer a7=obj.pageStepNumber('pepChangePaymentsFrequency');
            integer a8=obj.pageStepNumber('pepPaymentHolidayDashBoard');
            integer a9=obj.pageStepNumber('peppayoutloanpage');
            
            obj.redirectToPage();
            
            
            
            
        
        }
        
        //pepAdjustRepaymentsController.data objWrapper = new pepAdjustRepaymentsController.data(1,2,1.1,2.2);
        
        
        
    }
    
    
    
    
}
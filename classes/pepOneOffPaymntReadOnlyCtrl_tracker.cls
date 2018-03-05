@isTest public class pepOneOffPaymntReadOnlyCtrl_tracker {
    
    @isTest static void pepOneOffPaymntReadOnlyCtrlTest(){
        
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
        system.runas(usr1)     
        {
           pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Make One Off Payments ReadOnly');
        
           //Section Creation
           pepCmsSection__c objSection1 = new pepCmsSection__c();
           objSection1 = pepCommonTrackerController.createSection1(objPage1);
           objSection1.pepSectionUniqueName__c = 'Make One Off Payments ReadOnly Section 4';
           objSection1.pepSectionBodyRich__c='test story';
           update objSection1;
           
           pepCmsQuestion__c objCmsQuestion = new pepCmsQuestion__c();
           objCmsQuestion = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);
           
           objAccount=pepCommonTrackerController.createAccount1();
      
           objLoanAccount = pepCommonTrackerController.createLoanAccount1();
          // objLoanAccount.loan__Principal_Remaining__c = 2000000000;
           //update objLoanAccount;
          
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
           
           pages_config__c objConfig = new pages_config__c();
           objConfig.Page_Label__c='PendingMakeOneOffPayment';
           objConfig.Name='peppendingmakeoneoffpayment';
           insert objConfig;
           
           pages_config__c pg1 = new pages_config__c(Name='pepviewmyloanpage',Page_Label__c='ViewMyLoanPage');
           insert pg1;
           
           pepCommonTrackerController.createContact1();
       
           objuser = pepCommonTrackerController.createUser1();
        }
        Test.StopTest();
         system.runas(objUser)     
        {
               pagereference p = page.pepHardship;
               p.getParameters().put('pagename','pepHardship');
               Test.SetcurrentPage(p);
               
               pepOneOffPaymentReadOnlyController objController = new pepOneOffPaymentReadOnlyController();
               objController.CancelMethod();
               objController.strAmount='1233';
               objcontroller.strPaymentDate=System.today();
        
              
            
        }
        
        
    }

}
@isTest(SeeAllData=False) private class pepPaymentSettingController_Tracker{
    
    
    @isTest static void pepPaymentSettingControllerTest(){
        
         UserRole portalRole1;
         user objuser;
         Contact objCon;
         Account objAccount;
         
         loan__Automated_Payment_Setup__c automatedPayment;
       
        Loan__loan_Account__c objLoanAccount;
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        
        system.runas(usr1)     
        {
           pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('PaymentSetting');
        
           //Section Creation
           pepCmsSection__c objSection1 = new pepCmsSection__c();
           objSection1 = pepCommonTrackerController.createSection1(objPage1);
           objSection1.pepSectionUniqueName__c = 'PaymentSetting';
           objSection1.pepSectionBodyRich__c='test story';
           update objSection1;
           
            pepCmsPage__c objPage11 = pepCommonTrackerController.createPage('pepPaymentDetails');
        
           //Section Creation
           pepCmsSection__c objSection11 = new pepCmsSection__c();
           objSection11 = pepCommonTrackerController.createSection1(objPage11);
           objSection11.pepSectionUniqueName__c = 'PaymentDetails_BanKDetails';
           objSection11.pepSectionBodyRich__c='test story';
           update objSection11;
           
           objAccount=pepCommonTrackerController.createAccount1();                    
           objLoanAccount = pepCommonTrackerController.createLoanAccount1();
           objLoanAccount.loan__Loan_Status__c='Closed - Obligations met';
           
           update objLoanAccount;
          
           objAccount.Loan_Account_Id__c=objLoanAccount.id;
           objAccount.name='Pepper Group Pty Limited';
           objAccount.pepBiller_Code__c='111';
           update objAccount;
           
           loan__Bank_Account__c objBankAccount = pepCommonTrackerController.createLoanBankAccount(objAccount.id);
           
           objLoanAccount.Default_Bank_Account__c=objBankAccount.id; 
           update objLoanAccount;
           pepBank_API_Details__c objBankApi = new pepBank_API_Details__c();
           objBankApi.pepBank_Name__c='test bank name';
           insert objBankApi;
          
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
            pages_config__c pg = new pages_config__c(Name='peppaymentdetails',Page_Label__c='PaymentDetails');
            insert pg;
            
            pagereference p = page.pepPaymentDetails;
            
            Test.SetcurrentPage(p);
           
            pepPaymentSettingController obj = new pepPaymentSettingController();
           Test.startTest();  
            obj.addNewAccount();
            obj.changeAccount();
          Test.stopTest();
            
          
            pepPaymentSettingController obj1 = new pepPaymentSettingController();
            obj1.SelectedAccount='New Account';
            obj1.addNewAccount();
            obj1.redirectToPage();
           // obj1.changeAccount();
          
            
        
        }
       
        //pepAdjustRepaymentsController.data objWrapper = new pepAdjustRepaymentsController.data(1,2,1.1,2.2);
        
        
        
    }
    
    
    
    
}
@isTest(SeeAllData=False) private class pepPayoutLoanPageController_Tracker{
    
    
    @isTest static void pepPayoutLoanPageControllerTest(){
        
        UserRole portalRole1;
        user objuser;
        Contact objCon;
        Account objAccount;
         
        loan__Automated_Payment_Setup__c automatedPayment;
   Test.startTest();      
        Loan__loan_Account__c objLoanAccount;
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
           pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Pay Off Your Loan');
        
           //Section Creation
           pepCmsSection__c objSection1 = new pepCmsSection__c();
           objSection1 = pepCommonTrackerController.createSection1(objPage1);
           objSection1.pepSectionUniqueName__c = 'Hardship Section 19';
           objSection1.pepSectionBodyRich__c='test story';
           update objSection1;
           
           pepCmsQuestion__c objQuestion1 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);
           
           objAccount=pepCommonTrackerController.createAccount1();
           
           loan__Bank_Account__c objBankAccount = pepCommonTrackerController.createLoanBankAccount(objAccount.id);
           
           pepBank_API_Details__c objBankApi = new pepBank_API_Details__c();
           objBankApi.pepBank_Name__c=objBankAccount.loan__Bank_Name__c ;
           insert objBankApi;
           
           loan__Payment_mode__c objloanPayment = new loan__Payment_mode__c(name='Direct Debit');
           insert objloanPayment ;
      
           objLoanAccount = pepCommonTrackerController.createLoanAccount1();                  
          
           objAccount.Loan_Account_Id__c=objLoanAccount.id;
           update objAccount;
          
           loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
           payMode.Name ='testPayMOde';
           insert payMode;
       
           automatedPayment = new loan__Automated_Payment_Setup__c();
           automatedPayment.loan__Active__c = true;
           automatedPayment.loan__Type__c = 'ONE TIME';
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
        Test.stopTest();
            pages_config__c pg = new pages_config__c(Name='peppayoutloanpage',Page_Label__c='PayoutLoanPage');
            insert pg;
            pages_config__c pg3 = new pages_config__c(Name='peptransactionhistory',Page_Label__c='TransactionHistory');
            insert pg3;
            pages_config__c pg1 = new pages_config__c(Name='pepviewmyloanpage',Page_Label__c='ViewMyLoanPage');
            insert pg1;
            pages_config__c pg11 = new pages_config__c(Name='peppendingmakeoneoffpayment',Page_Label__c='PendingMakeOneOffPayment');
            insert pg11;
            
            pagereference p = page.pepPayoutLoanPage;
            Test.SetcurrentPage(p);
            
            pepPayoutLoanPageController obj = new pepPayoutLoanPageController();
            obj.payoffAmount =2000;
            obj.inputDate = '1/12/2020';
            obj.checkcookie();
            obj.CancelMethod();
            obj.CreateBankAccount();
            
           
            obj.Calculate();
            obj.redirectOK();
            pepPayoutLoanPageController ob = new pepPayoutLoanPageController();
            ob.CreateBankAccount();
            pepPayoutLoanPageController obj1 = new pepPayoutLoanPageController();
            obj.payoffAmount =2000;
            obj1.selectedAccount='Create New...';
            obj1.RetrieveBankAccountData();
            obj1.strselectedBankName ='df';
            obj1.CreateBankAccount();
            obj1.Calculate();
        
        }
        
        //pepAdjustRepaymentsController.data objWrapper = new pepAdjustRepaymentsController.data(1,2,1.1,2.2);
        
        
        
    }
    
    
    
    
}
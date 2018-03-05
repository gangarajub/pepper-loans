@isTest(SeeAllData=False)

private class pepTransactionHistoryController_Tracker 
{
    public static User usr;
    private static  Account objAccount;
    private static loan__Loan_Account__c objLoanAccount;
    private static loan__Automated_Payment_Setup__c automatedPayment;
    
    @isTest static void PepChangePaymentsFrequencyTest0() {
        UserRole portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        system.runas(usr1)     
        {
            
            objAccount = pepCommonTrackerController.createAccount1();
            objLoanAccount = pepCommonTrackerController.createLoanAccount1();
            objAccount.Loan_Account_Id__c = objLoanAccount.Id;
            update objAccount;
            
            pepCommonTrackerController.createContact1();
            usr = pepCommonTrackerController.createUser1();
            test.startTest();
            createData();
            test.stopTest();
        }
        
        system.runas(usr)     
        {
            pepTransactionHistoryController objClass = new pepTransactionHistoryController ();
            objClass.hasNext = false;
            objClass.hasPrevious = false;
            objClass.numberBar(5);
            objClass.intPageNumber = 2;
            objClass.Total_Pages = 2;
            objClass.next();
            //objClass.previous();
            objClass.GoTo();
        }
       
    }
    
    private static void createData()
    {
        pepCommonTrackerController obj =new pepCommonTrackerController(); 
        pages_config__c pageconfig = pepCommonTrackerController.createPagesConfig()[24];
        
        loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
        payMode.Name ='testPayMOde';
        insert payMode;
       
        automatedPayment = new loan__Automated_Payment_Setup__c();
        automatedPayment.loan__Active__c = true;
        automatedPayment.loan__Type__c = 'RECURRING';
        automatedPayment.loan__Debit_Date__c = system.today();
        automatedPayment.loan__CL_Contract__c = objLoanAccount.id;
        automatedPayment.loan__Frequency__c = 'bi-weekly';
        automatedPayment.loan__Payment_Mode__c = payMode.id;
        automatedPayment.loan__Transaction_Amount__c = 200000;
        insert automatedPayment;
        
        loan__Loan_Payment_Transaction__c payTransaction = pepCommonTrackerController.createPaymentTransaction(payMode,objLoanAccount);
        
        payTransaction.loan__Cleared__c = false;
        payTransaction.loan__Automated_Payment_Setup__c = automatedPayment.id;
        payTransaction.loan__Balance__c = 1000;
        update payTransaction; 
    }
}
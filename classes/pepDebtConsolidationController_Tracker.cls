@isTest(SeeAllData=False) private class pepDebtConsolidationController_Tracker{
    
   @isTest static void pepDebtConsolidationController(){
   
   
        loan__Loan_Purpose__c objLoanPurpose = new loan__Loan_Purpose__c();
        objLoanPurpose.Name='New Car';
        objLoanPurpose.loan__Loan_Purpose_Code__c='VNC0001';
        objLoanPurpose.loan__Description__c='Vehicle New Car';
        insert objLoanPurpose;

        clcommon__CL_Purpose__c objClPurpose = new clcommon__CL_Purpose__c();
        objClPurpose.Name='a debt consolidation loan';
        objClPurpose.clcommon__Description__c='A loan for a new car.';
        //objClPurpose.Loan_Purpose__c=objLoanPurpose.id;
        objClPurpose.Serial_No__c=4;
        insert objClPurpose;
        
          pages_config__c pg11 = new pages_config__c(Name='pepfinaliserepayment',Page_Label__c='FinaliseRepayment');
            insert pg11;

        
        pepBank_API_Details__c objBankDetail = new pepBank_API_Details__c(pepBank_Name__c='hdfc');
        insert objBankDetail;
        
        pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Debt Consolidation');
       
        pepCmsSection__c objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c = 'DebtConsolidationAllExpenses';
        objSection1.pepHeader__c='DebtDescription';
        update objSection1;
       
        pepCmsQuestion__c objQuestion1 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);
        objQuestion1.pepLabelPriorQuestion__c='Financial Institution';
        objQuestion1.pepType__c ='Picklist';
        update objQuestion1;
        pepCmsAnswer__c objAnswer1 = new pepCmsAnswer__c();
        objAnswer1 = pepCommonTrackerController.createCmsAnswer(objQuestion1);
        
        
        //pepDebtConsolidationController.QuesAnsWrap objQuesWrap = new pepDebtConsolidationController.QuesAnsWrap();
        
       
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      
        genesis__Applications__c objApplication = new genesis__Applications__c();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Automated_Payment_Start_Date__c=System.Today();
        objApplication.genesis__Payment_Amount__c=2000;
        objApplication.Debit_Amount__c=2000;
        objApplication.genesis__CL_Purpose__c=objClPurpose.id;
        update objApplication;
        
        Expense_and_Debt__c objExpence = new Expense_and_Debt__c();
        objExpence.Application__c = objApplication.id;
        objExpence.Type__c='Debt';
        objExpence.Consolidate_As_A_Debt__c=True;
        objExpence.Type_of_Expense_Debt__c='Credit card1';
        objExpence.Amount_Remaining_as_Debt__c=20000;
        insert objExpence;
    
        Application__c objApp1 = new Application__c();
        objApp1=pepCommonTrackerController.createApplication();
        objApp1.Name='pepDebtConsolidation';
        objApp1.Navigation_Status__c='LoanSetup-DebtConsolidation';
        objApp1.RedirectPage__c='pepDebtConsolidation';
        update objApp1;

    
        Pagereference pd=Page.pepFinaliseRepayment;
        Test.setcurrentPagereference(pd);
    
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        pepDebtConsolidationController.expenseWrapper objwrap = new pepDebtConsolidationController.expenseWrapper();
        pepDebtConsolidationController.QuesAnsWrap objQue= new pepDebtConsolidationController.QuesAnsWrap();
        
        pepDebtConsolidationController objContoller = new pepDebtConsolidationController();
        objContoller.saveForLater();
        Application__c objApp2 = new Application__c();
        objApp2=pepCommonTrackerController.createApplication();   
        objQue.objInputValue='heyt';     
        //objContoller.saveData();
        objContoller.checkcookie();
        
        List<pepDebtConsolidationController.QuesAnsWrap> lstWrap = new List<pepDebtConsolidationController.QuesAnsWrap>();
        pepDebtConsolidationController.QuesAnsWrap objQue1 = new pepDebtConsolidationController.QuesAnsWrap();
        objQue1.objQues=objQuestion1;
        objQue1.objInputValue='hie';
        lstWrap.add(objQue1);
        pepDebtConsolidationController.expenseWrapper objwrap1 = new pepDebtConsolidationController.expenseWrapper();
        objwrap1.lstQAWrap=lstWrap;
        
        pepDebtConsolidationController objContoller1 = new pepDebtConsolidationController();
        objContoller1.saveData();
   }
   
}
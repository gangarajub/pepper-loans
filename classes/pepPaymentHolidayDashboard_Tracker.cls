@isTest
public class pepPaymentHolidayDashboard_Tracker 
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
        pepBank_API_Details__c BankApi;
        loan__Bank_Account__c loanbank;
        
        genesis__Applications__c objApplication;
         pepCmsSection__c  Sec_ReferAFriendSection1;
         pepCmsSection__c  Sec_ReferAFriendSection2;
         pepCmsPage__c objPage;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection1;
         pepCmsQuestion__c Ques_Sec_ReferAFriendSection2;
          pepCmsAnswer__c Ans_Sec_ReferAFriendSection2;
        pages_config__c objpageConfig;
        Pagereference pd1;
        pepPaymentHolidayDashboardController objclass;
        set<integer> setInt;
        List<String> lstMonthsNames;
        Map<String,Decimal> mapOfMonthsToDatas;
        list<loan__Automated_Payment_Setup__c >lstPayLoan;
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            objpageConfig = new pages_config__c();
            objpageConfig = pepCommonTrackerController.createPagesConfig()[0];
            objpageConfig.Page_Label__c='peppaymentholidaydashboard';
            objpageConfig.Name='peppaymentholidaydashboard';
            update objpageConfig;
            
            //Page setup;            
            pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Dashboard(Payment Holiday)');
            
            Sec_ReferAFriendSection1= pepCommonTrackerController.createSection(objPage1);
            Sec_ReferAFriendSection1.pepSectionUniqueName__c='PaymentHolidayDBSection1';
            Sec_ReferAFriendSection1.pepSectionBodyRich__c='Test';
            update Sec_ReferAFriendSection1;
            
            Sec_ReferAFriendSection2= pepCommonTrackerController.createSection(objPage1);
            Sec_ReferAFriendSection2.pepSectionUniqueName__c='PaymentHolidayDBSection2';
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
            
            objAccount.Loan_Account_Id__c=pepCommonTrackerController.createLoanAccount().id;
            update objAccount;
            
            loanbank= pepCommonTrackerController.createLoanBankAccount(objAccount.id);
            
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
            automatedPayment.loan__Transaction_Amount__c=0;
            automatedPayment.loan__Recurring_ACH_Start_Date__c=system.today();
            automatedPayment.loan__Recurring_ACH_End_Date__c=system.today()+10;
            insert automatedPayment;
            
            pages_config__c pg1 = new pages_config__c(Name='pepviewmyloanpage',Page_Label__c='ViewMyLoanPage');
            insert pg1;
            
            BankApi=new pepBank_API_Details__c ();
            BankApi.pepBank_Name__c='Hello';
            insert BankApi;
            // loan.TestHelper.createSeedDataForTesting();
            
            objContact1=pepCommonTrackerController.createContact1();
            
            objuser = pepCommonTrackerController.createUser1();
            
            
        }
        
        system.runas(objUser)     
        {
            pd1=Page.peppaymentholidaydashboard;
            Test.setcurrentPagereference(pd1);
            setInt=new set<Integer>();
            for(integer i=1;i<=12;i++)
            {
                setInt.add(i);
            }
            lstMonthsNames=new list<string>();
            lstMonthsNames.add('January');
            lstMonthsNames.add('March');
            
            mapOfMonthsToDatas=new Map<String,Decimal>();
            mapOfMonthsToDatas.put('January',1);
            mapOfMonthsToDatas.put('March',2);
            
           objclass=new pepPaymentHolidayDashboardController();
           objclass.setCheckedMonths=setInt;
           objclass.lstMonthsName=lstMonthsNames;
           objclass.mapOfMonthsToData=mapOfMonthsToDatas;
           pepPaymentHolidayDashboardController.wrapper objwrapper= new pepPaymentHolidayDashboardController.wrapper();
           objwrapper.strMonth='June';
           objwrapper.strYear='2017';
           objwrapper.decRepaymentAmount=10.90;
           objwrapper.StartDate=system.today();
           objwrapper.EndDate=system.today()+2;
         /*  EndDate */
           objwrapper.isDisabled=true;
           objwrapper.disableCounter=1;
           objwrapper.isChecked=true;
           list<pepPaymentHolidayDashboardController.wrapper> lstwrapper1=new list<pepPaymentHolidayDashboardController.wrapper>();
           lstwrapper1.add(objwrapper);
           objclass.lstWrapper=lstwrapper1;
           lstPayLoan=new list<loan__Automated_Payment_Setup__c >();
           lstPayLoan.add(automatedPayment);
           Apexpages.currentpage().getparameters().put('rowNo', '3');
           //objclass.selectedData();
           objclass.getHolidaySchedule(objAccount.Loan_Account_Id__c);
           objclass.redirectOK();
           objclass.cancelpaymentHoliday();
           objclass.SavepaymentHoliday();
           objclass.MakeChartData();
           objclass.calculateHolidayScheduleAPS(lstPayLoan);
           objclass.calculate();
           
           objclass=new pepPaymentHolidayDashboardController();
           objclass.intSize=1;
           objclass.strData='String';
           objclass.holidayError=true;
           objclass.selectedCheckbox='Yes';
        }
        test.stoptest();
    }
}
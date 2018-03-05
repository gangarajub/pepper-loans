public class CreateLoanAccountForLoanTypeHandler {
    loan__Loan_Product__c loanProduct = new loan__Loan_Product__c();
    loan__Loan_Account__c loanAccount = new loan__Loan_Account__c();
    genesis__Applications__c application = new genesis__Applications__c();
    genesis__Applications__c loanApplication;
    private loan.GlobalLoanUtilFacade loanUtil;
    private Date systemDate;
    private Date nextDay;
    public CreateLoanAccountForLoanTypeHandler(genesis__Applications__c application ,loan__Loan_Account__c loanAccount,loan__Loan_Product__c loanProduct){
        
        this.application = application;
        this.loanAccount = loanAccount;
        this.loanProduct = loanProduct;
        loanUtil = new loan.GlobalLoanUtilFacade();
        systemDate = loanUtil.getCurrentSystemDate();
    }
    
    private loan__Payment_Mode__c pmtMode = new loan__Payment_Mode__c();
    
    public String createLoanAccount(){
        loanApplication = this.application;   
        if(application.CL_Contract__c!=null){
            return 'Application already been converted into Contract';
        }
        if(application.genesis__Status__c.equalsIgnoreCase('APPROVED - DOCUMENT SIGNED')){
            
        }else{
            return 'Status of application should be APPROVED - DOCUMENT SIGNED to convert into Contract';
        } 
        
        Savepoint sp = Database.setSavepoint();
        if(loanApplication.genesis__Payment_Frequency__c==null){
            return 'Payment Frequency is null';
        }
        //nextDay = loanApplication.genesis__Expected_First_Payment_Date__c;
        nextDay = loan.DateUtil.getNextCycleDate(systemDate,
                                            systemDate.day(),
                                            loan.LoanConstants.LOAN_PAYMENT_FREQ_MONTHLY,
                                            systemDate,
                                            null,
                                            1);
        System.debug('nextDay'+nextDay);   
        if(loanApplication.genesis__Account__c!=null){
            loanAccount.loan__Account__c = loanApplication.genesis__Account__c;
        } 
        if(loanApplication.genesis__CL_Purpose__c!=null){
            List<clcommon__CL_Purpose__c> purpose = [select id,name,loan__Lending_Purpose__c from clcommon__CL_Purpose__c where id=:loanApplication.genesis__CL_Purpose__c];
            if(purpose.size()>0){
                if(purpose[0].loan__Lending_Purpose__c!=null){
                    loanAccount.loan__Loan_Purpose__c=purpose[0].loan__Lending_Purpose__c;    
                }else{
                    return 'Loan Purpose Mapping from Application to contract is missing';
                }
            }
        }else{
             return 'Loan Purpose is not present';
        }
        loanAccount.loan__Frequency_of_Loan_Payment__c = loanApplication.genesis__Payment_Frequency__c;
        loanAccount.loan__Loan_Amount__c = loanApplication.genesis__Loan_Amount__c;
        loanAccount.loan__Number_of_Installments__c = loanApplication.genesis__Term__c;
        loanAccount.loan__contractual_Interest_Rate__c = loanApplication.genesis__Interest_Rate__c;
        loanAccount.loan__Interest_Rate__c = loanApplication.genesis__Interest_Rate__c;
        loanAccount.loan__Product_Type__c = loanApplication.genesis__Product_Type__c;
        loanAccount.loan__Expected_Disbursal_Date__c = systemDate; 
        
        
        loanAccount.Application__c = loanApplication.Id;
        loanAccount.loan__Balloon_Payment__c = loanApplication.genesis__Balloon_Payment__c;
        loanAccount.loan__Payment_Amount__c = loanApplication.genesis__Payment_Amount__c;
        
        
        
        loanAccount.loan__Interest_Only_Period__c = loanApplication.genesis__Interest_Only_Period__c;
        
        loan.GlobalLoanUtilFacade info = new loan.GlobalLoanUtilFacade();
        
        loanAccount.loan__Approval_Date__c = systemDate;
        loanAccount.loan__Disbursal_Date__c = systemDate;  
        loanAccount.loan__Contractual_Due_Day__c = systemDate.day();
        loanAccount.loan__Expected_Repayment_Start_Date__c = nextDay;
        loanAccount.loan__Next_Installment_Date__c = nextDay;
        loanAccount.loan__First_Installment_Date__c = nextDay;
        loanAccount.loan__Due_Day__c = systemDate.day();
        loanAccount.loan__Term_Cur__c = loanApplication.genesis__Term__c;
        loanAccount.Default_Bank_Account__c = loanApplication.Default_Bank_Account__c; 
        loanAccount.loan__Application_Date__c = Date.valueOf(loanApplication.CreatedDate);
        list<loan__Payment_Mode__c> paymentMode = [Select Id from loan__Payment_Mode__c where Name='ACH'];
        if(paymentMode.size()==0){
            return 'Payment mode is null';
        }
        
        loanAccount.loan__Payment_Mode__c=paymentMode[0].Id ;
        
        
        
        
        List<RecordType> rT = [select Id,
                               Name,
                               SobjectType
                               from RecordType
                               where Name =: loanApplication.genesis__Product_Type__c 
                               and SObjectType =: 'loan__Loan_Account__c' ];
        
        if(rT.size()==0){
            return 'Record Type Loan does not exists';
        }
        
        loanAccount.RecordTypeId = rT[0].Id;                                        
        if(loanProduct.loan__Interest_Rate_Type__c!=null){
            System.debug('loanProduct.loan__Interest_Rate_Type__c'+loanProduct.loan__Interest_Rate_Type__c);
            if(loanProduct.loan__Interest_Rate_Type__c.equalsIgnoreCase('Floating')){
                if(loanProduct.loan__Floating_Rate_Index__c!=null){
                    System.debug('loanProduct.loan__Floating_Rate_Index__c'+loanProduct.loan__Floating_Rate_Index__c);
                    List<loan__Floating_Rate__c> floatingRate = [select id, loan__Floating_Rate_Index__c,loan__Rate_Effective_From__c,loan__Rate_Effective_To__c,name,loan__Rate_Percentage__c from loan__Floating_Rate__c where 
                                                                 loan__Floating_Rate_Index__c=:loanProduct.loan__Floating_Rate_Index__c];  
                    loanAccount.loan__Floating_Rate_Index__c=loanProduct.loan__Floating_Rate_Index__c;
                    System.debug('floatingRate'+floatingRate);
                    for(loan__Floating_Rate__c r :floatingRate){
                        System.debug('r.loan__Rate_Effective_From__c'+r.loan__Rate_Effective_From__c);
                        System.debug('r.loan__Rate_Effective_To__c'+r.loan__Rate_Effective_To__c);
                        
                        if(r.loan__Rate_Effective_From__c<systemDate && r.loan__Rate_Effective_To__c>systemDate ){
                            System.debug('systemDate'+systemDate); 
                            loanAccount.loan__Contractual_Index_Rate__c=r.loan__Rate_Percentage__c ;
                            loanAccount.loan__Index_Rate__c =r.loan__Rate_Percentage__c ; 
                            loanAccount.loan__Margin_Rate__c= loanApplication.genesis__Interest_Rate__c-r.loan__Rate_Percentage__c;  
                        }
                    }
                }
                
            }
            
        }
        
        
        
        //get Loan Product info to Loan Account...
        loanAccount.loan__Loan_Product_Name__c = loanProduct.id;
        loanAccount.loan__Interest_Calculation_Method__c = loanProduct.loan__Interest_Calculation_Method__c;            
        loanAccount.loan__Frequency_Of_Loan_Payment__c = loanProduct.loan__Frequency_Of_Loan_Payment__c;
        loanAccount.loan__Time_Counting_Method__c = loanProduct.loan__Time_Counting_Method__c;
        loanAccount.loan__Delinquency_Grace_Days__c = loanProduct.loan__Delinquency_Grace_Days__c;
        loanAccount.loan__Write_off_Tolerance_Amount__c = loanProduct.loan__Write_off_Tolerance_Amount__c;
        loanAccount.loan__Grace_Period_for_Repayments__c = loanProduct.loan__Late_Charge_Grace_Days__c;
        loanAccount.loan__LA_Amortized_Balance_Type__c = loanProduct.loan__Amortize_Balance_type__c;
        loanAccount.loan__LA_Amortization_Frequency__c = loanProduct.loan__Amortization_Frequency__c;
        loanAccount.loan__LA_Amortization_Enabled__c = loanProduct.loan__Amortization_Enabled__c;
        loanAccount.loan__LA_Amortization_Calculation_Method__c = loanProduct.loan__Amortization_Calculation_Method__c;
        loanAccount.loan__Term_Cur__c=loanAccount.loan__Number_Of_Installments__c;
        loanAccount.loan__Fee_Set__c = loanProduct.loan__Fee_Set__c;
        
        loanAccount.loan__Pre_Bill_Days__c = loanProduct.loan__Pre_Bill_Days__c;
        loanAccount.loan__Pmt_Amt_Cur__c = loanAccount.loan__Payment_Amount__c;
        loanAccount.loan__Write_off_Tolerance_Amount__c = loanProduct.loan__Write_off_Tolerance_Amount__c;
        loanAccount.loan__Interest_Only_Period__c = loanProduct.loan__Interest_Only_Period__c==null?0:loanProduct.loan__Interest_Only_Period__c;
        if(loanApplication.genesis__Company__r.Name!=null){
            String companyName = loanApplication.genesis__Company__r.Name;
            if(!Test.isRunningTest()){
                List<loan__Office_Name__c> off;
                // = [select Id from loan__Office_Name__c where Name=:companyName limit 1].Id;
                off= [select Id from loan__Office_Name__c where Name=:companyName];
                if(off.size()==0){
                    return 'branch name is missing';
                }
                loanAccount.loan__Branch__c = off[0].Id;
                
            }
        }else{
            return 'Company associated with Loan Application is missing';
            
        }
        
        
        
        loanAccount.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_PARTIAL_APPLICATION;
        loanAccount.loan__Interest_Type__c = 'Fixed';
        
        
        if(loanApplication.genesis__Days_Convention__c.equals('30/360')){
            loanAccount.loan__Time_Counting_Method__c = loan.LoanConstants.TIME_COUNTING_MONTH_AND_DAYS;
        }else if(loanApplication.genesis__Days_Convention__c.equals('365/365')){
            loanAccount.loan__Time_Counting_Method__c = loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS;
        }
        
        
        
        loanAccount.loan__Prepayment_Penalty_Indicator__c=true;
        loanAccount.loan__Prepayment_Method__c='Fixed';
        loanAccount.loan__Prepayment_Penalty_Periods__c= loanApplication.genesis__Term__c;
        loanAccount.Is_Secured__c = loanApplication.Is_Secured__c;
        loanAccount.loan__Prepayment_Value__c=loanProduct.Prepayment_Penalty_Value__c;
        loanAccount.loan__Interest_Posting_Frequency__c = loanProduct.loan__Interest_Posting_Frequency__c;
        loanAccount.loan__Is_Interest_Posting_Enabled__c = loanProduct.loan__Is_Interest_Posting_Enabled__c;
        loanAccount.loan__Is_Capitalization_Enabled__c = loanProduct.loan__Is_Capitalization_Enabled__c;
        loanAccount.loan__Capitalization_Frequency__c = loanProduct.loan__Capitalization_Frequency__c;
        loanAccount.loan__Next_Interest_Posting_Date__c = loanAccount.loan__Next_Installment_Date__c;
        loanAccount.loan__Next_Capitalization_Date__c = loanAccount.loan__Next_Installment_Date__c;
        loanAccount.loan__Interest_Posting_Day__c  = loanAccount.loan__Next_Interest_Posting_Date__c.day();
        
        boolean referral;
        boolean conversion = true;
        try{
            //if(!Test.isRunningTest())
            insert loanAccount;
            referral = false;
            
            System.debug('loanAccount='+loanAccount.name);
            System.debug('loanAccountid'+loanAccount.Id);
            
        }catch(Exception e){
            conversion = false;
            Database.Rollback(sp);
            System.debug('err'+e.getMessage());
            return e.getMessage();
        }
        
        
        loan.RegenerateAmortizationScheduleCtrl.regenerateAmortizationSchedule(loanAccount.id);
        loanAccount.loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_APPROVED;
        //loanAccount.loan__Interest_estimated__c = 0.0;
        loanAccount.loan__Last_Installment_Date__c =  loan.DateUtil.addCycle(loanAccount.loan__First_Installment_Date__c ,
                                                                             (Integer)loanAccount.loan__First_Installment_Date__c.day(),
                                                                             loanAccount.loan__Frequency_of_Loan_Payment__c,
                                                                             (Integer)(loanAccount.loan__Term_Cur__c-1) );
        loanAccount.loan__Maturity_Date_Current__c = loan.DateUtil.addCycle(loanAccount.loan__First_Installment_Date__c ,
                                                                            (Integer)loanAccount.loan__First_Installment_Date__c.day(),
                                                                            loanAccount.loan__Frequency_of_Loan_Payment__c,
                                                                            (Integer)(loanAccount.loan__Term_Cur__c-1) ); 
        loan__Loan_Account__c newLoan = [select id,name from loan__Loan_Account__c  where id=:loanAccount.Id];
        
        //contact and borrower from Loan Account
        list<loan__Loan_Account__c> ac= [select id,name,loan__Account__c,loan__Contact__c from loan__Loan_Account__c where id=:loanAccount.id];
        
        if(ac.size()==0){
            return 'Application has not been converted successfully';
        }
        List<contact> con = [select id,name,Email from Contact where Id=:ac[0].loan__Contact__c];
        if(con.size()==0){
            return 'Application does not have any contact associated with it';
        }
        //List<clcommon__Party_Type__c> partyType = [select id,name from clcommon__Party_Type__c where name ='Broker'];
        List<clcommon__Party_Type__c> type= [select id,name from clcommon__Party_Type__c where name='REFERRAL'];
        List<clcommon__Party_Type__c> Brokertype= [select id,name from clcommon__Party_Type__c where name='Broker'];
        List<String> recordType = new List<String>();
        recordType.add(type[0].Id);
        recordType.add(Brokertype[0].Id);
        if(type.size()==0 || Brokertype.size()==0){
            return 'Part Type REFERRAL or Broker does not exits';
        }
        List<clcommon__Party__c> party= [select id,name,clcommon__Account__c,clcommon__Contact__c,clcommon__Contact__r.AccountId,clcommon__Contact__r.Referral_code__c,clcommon__Account__r.Referral_Code__c from clcommon__Party__c where genesis__Application__c=:loanApplication.Id AND clcommon__Type__c IN : recordType];
        
        
        
        list<loan__Commission_Plan__c> comPlan = new List<loan__Commission_Plan__c>();
        //[select id,name from loan__Commission_Plan__c where  loan__Plan_Description__c='Referrer'];
        if(party.size()>0 ){
            //return 'Commission Plan does not exists for Referral';
            
            if(party[0].clcommon__Contact__C!=null){
                List<Broker_Junction__c> brokerJunc = [select id,Commission_Plan__c from Broker_Junction__c where Contact__c =:party[0].clcommon__Contact__c];
                if(brokerJunc.size()>0){
                    comPlan = [select id,loan__Calculation_Method__c,loan__Commission_Disbursement_Method__c,
                                loan__Enabled__c,loan__Factor__c,   loan__Flat_Amount__c,
                                loan__Maximum_Commission_Percentage__c,loan__Plan_Description__c,GST_Rate__c,
                                loan__Upfront_Percentage__c from loan__Commission_Plan__c 
                                where Id=:brokerJunc[0].Commission_Plan__c];
                    if(comPlan.size()==0){
                        return  'Commission Plan does not exist for this broker.';
                    }
                }
            }
        }
        loan__Broker__c br = new loan__Broker__c();
        if(party.size()>0 && comPlan.size()>0){
            System.debug('party'+party);
            
            
            
            
            if(party[0].clCommon__Account__c!=null){
                br.loan__Account__c=party[0].clcommon__Account__c;
            }else if(party[0].clCommon__Contact__c!=null){
                br.loan__Contact__c = party[0].clcommon__Contact__c;
                br.loan__Account__C = party[0].clcommon__Contact__r.AccountId;
            }
            
            Decimal commissionAmount = 0;
            
            if (comPlan[0].loan__Calculation_Method__c!=null && comPlan[0].loan__Flat_Amount__c!=null && comPlan[0].loan__Calculation_Method__c == loan.LoanConstants.FLAT){
                commissionAmount = comPlan[0].loan__Flat_Amount__c;
                br.loan__Flat_Amount__c = comPlan[0].loan__Flat_Amount__c;
            } 
            else if (comPlan[0].loan__Calculation_Method__c == loan.LoanConstants.PER_FIN_AMOUNT){
                commissionAmount = (((loanAccount.loan__loan_amount__c) * (comPlan[0].loan__Maximum_Commission_Percentage__c/100))*(comPlan[0].loan__Factor__c/100));
            } 
            
            br.loan__Commission_Plan__c=comPlan[0].Id;
            br.loan__Lending_Account__c=newLoan.Id;
            br.loan__Commission_Amount__c = commissionAmount;
            br.loan__Upfront_Commission_Amount__c = br.loan__Commission_Amount__c * ((comPlan[0].loan__Upfront_Percentage__c)/100);
            br.loan__Upfront_Percentage__c = comPlan[0].loan__Upfront_Percentage__c;
            br.loan__Maximum_Commission_Percentage__c = comPlan[0].loan__Maximum_Commission_Percentage__c;
            br.loan__Calculation_Method__c = comPlan[0].loan__Calculation_Method__c;
            br.loan__Commission_Disbursement_Method__c = comPlan[0].loan__Commission_Disbursement_Method__c;
            br.loan__Factor__c = comPlan[0].loan__Factor__c;
            br.loan__Plan_Description__c = comPlan[0].loan__Plan_Description__c;
            br.GST_Rate__c = comPlan[0].GST_Rate__c;
            loanAccount.Remaining_Commission_Amount__c = br.loan__Upfront_Commission_Amount__c;
            loanAccount.Upfront_Commission_Amount__c = br.loan__Upfront_Commission_Amount__c;
            loanAccount.Last_Amort_Commission_Date__c = systemDate;
            try{    
                insert br; 
                System.debug('br'+br.Id);
            }catch(Exception e){
                system.debug('exception'+e.getMessage());
                return 'Exception in insertion'+e.getMessage();
            }
            
            System.debug('party[0].clcommon__Account__r.Referral_Code__c'+party[0].clcommon__Account__r.Referral_Code__c);
            
            
        }
        
        GenerateRandomNumber c = new GenerateRandomNumber();
        
        System.debug('loanAccount'+newLoan.name);
        String newNumber = c.generateCRN(newLoan.Name);
        String refer = c.generateReferralCode(newLoan.Name);
        loanAccount.CRN__c   = newNumber ;
        
        
        
        loan__Automated_Payment_Setup__c aps=new loan__Automated_Payment_Setup__c();
        
        List<Account> accnt = [select id,Referral_Code__c from Account where id=:ac[0].loan__Account__c];
        if(accnt.size()==0){
            return 'No Referral Account exist for this Application';
        }
        
        accnt[0].Referral_Code__c=refer;
        
        list<loan__Bank_Account__c> bankAcc;
        if(ac.size()>0){
            bankAcc = [select id,name from loan__Bank_Account__c where loan__Account__c=:ac[0].loan__Account__c and loan__Active__c = true and loan__Account_Usage__c='Borrower/Investor Account']; 
            
            if(bankAcc.size()==0 || bankAcc==null){
                return 'No Active bank Account for this Application';
            }
            
            //automated payment setup
            
            aps.loan__Type__c = 'RECURRING';
            aps.loan__Amount_Type__c='FIXED AMOUNT';
            aps.loan__Transaction_Amount__c=loanApplication.Debit_Amount__c;
            aps.loan__CL_Contract__c=loanAccount.Id;
            aps.loan__Payment_Mode__c=paymentMode[0].Id;
            aps.loan__Active__c=true;
            if(loanAccount.Default_Bank_Account__c!=null){
                aps.loan__Bank_Account__c = loanAccount.Default_Bank_Account__c;
            }else{
                
                aps.loan__Bank_Account__c = bankAcc[0].Id;
                
            }
            Date debitDate = loanApplication.Automated_Payment_Start_Date__c;
            if(loanApplication.Automated_Payment_Start_Date__c<=systemDate){
                while(debitDate<=systemDate){
                    if(loanApplication.debit_frequency__c.equalsIgnoreCase('WEEKLY')){
                        debitDate = loan.DateUtil.getNextCycleDate(debitDate,
                                            debitDate.day(),
                                            loan.LoanConstants.LOAN_PAYMENT_FREQ_WEEKLY,
                                            debitDate,
                                            null,
                                            1);
                    }else if(loanApplication.debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
                        debitDate = loan.DateUtil.getNextCycleDate(debitDate,
                                            debitDate.day(),
                                            loan.LoanConstants.LOAN_PAYMENT_FREQ_BI_WEEKLY,
                                            debitDate,
                                            null,
                                            1);
                    }else{
                        debitDate = loan.DateUtil.getNextCycleDate(debitDate,
                                            debitDate.day(),
                                            loan.LoanConstants.LOAN_PAYMENT_FREQ_MONTHLY,
                                            debitDate,
                                            null,
                                            1);
                    }
                    
                }
                
            }
            loanApplication.Automated_Payment_Start_Date__c = debitDate;
            aps.loan__Debit_Date__c = debitDate;
            aps.loan__Frequency__c=loanApplication.Debit_Frequency__c;
            aps.loan__Setup_Date__c=systemDate;
            aps.loan__Recurring_ACH_Start_Date__c = debitDate;
            aps.loan__Recurring_ACH_End_Date__c = loanAccount.loan__Maturity_Date_Current__c;
            aps.loan__Retry__c = 'Disabled'; 
            loanAccount.loan__ACH_Debit_Amount__c = aps.loan__Transaction_Amount__c;
            loanAccount.loan__ACH_Frequency__c = aps.loan__Frequency__c;
            loanAccount.loan__ACH_Next_Debit_Date__c = debitDate;
            loanApplication.genesis__Expected_Start_Date__c = systemDate;
            loanApplication.genesis__Expected_First_Payment_Date__c = loanAccount.loan__Expected_Repayment_Start_Date__c;
        }
        try{
            //if(!Test.isRunningTest()){
            insert aps;       
            update loanAccount;
            
            loanApplication.CL_Contract__c = loanAccount.Id;
            loanApplication.genesis__Status__c='APPROVED - CONVERTED TO CONTRACT';
            loanApplication.Approved_Date__c = DateTime.newInstance(systemDate,datetime.now().time());
            update loanApplication;
            
            //}
        }catch(Exception e){
            Database.Rollback(sp);
            system.debug('errror '+e.getMessage());
            return e.getMessage()+ e.getLineNumber();
        }
        
        
        List<loan__Disbursement_Schedule__c> disbList = new List<loan__Disbursement_Schedule__c>();
        
        List<Expense_and_Debt__c> expAndDebt = [select id,name,Amount_Remaining_as_Debt__c,Bank_Account__c,reference__c from Expense_and_Debt__c where Application__c=:loanApplication.Id and Consolidate_As_A_Debt__c=true and Type_of_Expense_Debt__c!='Credit card'];
        
        Decimal valuation = 0;
        
        List<clcommon__Collateral__c> collateral = [select id,
                                                           Dealer_Disbursement_Amount__c,
                                                           clcommon__Year__c,
                                                           clcommon__Make__c, 
                                                           clcommon__Model__c,
                                                           ppsr_Search_Certificate_Number__c,
                                                           pep_User_Selected_Vehicle__c,
                                                           Asset_Class__c,
                                                           pep_Registration_Number__c
                                                    from clcommon__Collateral__c 
                                                    where genesis__Application__c=:loanApplication.id and Active__c=true];
        
        if(collateral.size() > 0 && loanAccount.Is_Secured__c){
            List<clcommon__Collateral_Valuation__c> collateralValuation = [select id,
                                                                        clcommon__Appraised_Value__c,
                                                                        Red_Book_Key__c 
                                                                 from clcommon__Collateral_Valuation__c 
                                                                 where clcommon__Collateral__c = :collateral[0].id 
                                                                 order by createddate desc];
            
            if(collateralValuation != null && collateralValuation.size() > 0){
                loanAccount.Red_Book_Key__c = collateralValuation[0].Red_Book_Key__c;
                loanAccount.Red_Book_Value__c = collateralValuation[0].clcommon__Appraised_Value__c;
            }
            
            valuation = collateral[0].Dealer_Disbursement_Amount__c;
            loan__Loan_Collateral__c loanCollt = new loan__Loan_Collateral__c();
            loanCollt.loan__Loan__c = loanAccount.id;
            loanCollt.Collateral__c = collateral[0].id;
            insert loanCollt;
            
            loanAccount.LVR_Percent__c = loanApplication.LVR_Percent__c;
            loanAccount.Asset_Year__c = collateral[0].clcommon__Year__c;
            loanAccount.Asset_Make__c = collateral[0].clcommon__Make__c;
            loanAccount.Asset_Model__c = collateral[0].clcommon__Model__c;
            loanAccount.Asset_Age_At_Settlement__c = systemDate.year() - Integer.valueOf(collateral[0].clcommon__Year__c);
            loanAccount.Asset_Age_at_End_Of_Term__c = loanAccount.Asset_Age_At_Settlement__c + (loanAccount.loan__Term_Cur__c/12);
            loanAccount.PPSR_Ref_Number__c = collateral[0].ppsr_Search_Certificate_Number__c;
            loanAccount.Asset_Type__c = collateral[0].pep_User_Selected_Vehicle__c;
            loanAccount.Asset_Class__c = collateral[0].Asset_Class__c;
            loanAccount.Asset_Reg_Num__c = collateral[0].pep_Registration_Number__c;
            
            update loanAccount;
        }
        
         Decimal totalExp = 0;
        List<loan__Bank_Account__c> dealerAccount = [select id from loan__bank_Account__C where loan__Account_usage__c='Dealer Account' and loan__Account__c=:loanAccount.loan__Account__c]; 
        if(dealerAccount.size()>0 && valuation!=0){
            loan__Disbursement_Schedule__c disbSch= new loan__Disbursement_Schedule__c();
                disbSch.loan__Active__c=true;
                disbSch.loan__Amount_Disbursed__c=0;
                disbSch.loan__Bank_Account__c=dealerAccount[0].id;
                disbSch.loan__Disbursal_Status__c='Pending Disbursal';
                disbSch.loan__Disbursement_Date__c=systemDate;
                disbSch.loan__Name_of_Entity__c = 'Loan Disbursement';
                disbSch.loan__Loan_Account__c=loanAccount.Id;
                disbSch.loan__Value__c= valuation;
                
                disbSch.loan__Reference__c = loanApplication.name;
                totalExp=totalExp+disbSch.loan__Value__c;
                disbList.add(disbSch); 
        }
        
       
        if(expAndDebt.size()>0){
            for(Expense_and_Debt__c exp : expAndDebt){
                loan__Disbursement_Schedule__c disbSch= new loan__Disbursement_Schedule__c();
                disbSch.loan__Active__c=true;
                disbSch.loan__Amount_Disbursed__c=0;
                disbSch.loan__Bank_Account__c=exp.Bank_Account__c;
                disbSch.loan__Disbursal_Status__c='Pending Disbursal';
                disbSch.loan__Disbursement_Date__c=Date.today();
                disbSch.loan__Name_of_Entity__c = 'Loan Disbursement';
                disbSch.loan__Loan_Account__c=loanAccount.Id;
                disbSch.loan__Value__c= exp.Amount_Remaining_as_Debt__c;
                if(exp.reference__c!=null){
                    disbSch.loan__Reference__c = exp.reference__c;
                }
                totalExp=totalExp+exp.Amount_Remaining_as_Debt__c;
                disbList.add(disbSch);                      
            }
        }
        
        if(loanAccount.loan__Loan_Amount__c>totalExp){
            loan__Disbursement_Schedule__c disbSch= new loan__Disbursement_Schedule__c();
            disbSch.loan__Active__c = true;
            disbSch.loan__Amount_Disbursed__c = 0;
            System.debug('bankAcc[0].Id'+bankAcc[0].Id);
            if(loanAccount.Default_Bank_Account__c!=null){
                
                disbSch.loan__Bank_Account__c=loanAccount.Default_Bank_Account__c;
            }else{
                
                disbSch.loan__Bank_Account__c = bankAcc[0].Id;
            }
            
            disbSch.loan__Disbursal_Status__c='Pending Disbursal';
            disbSch.loan__Disbursement_Date__c=Date.today();
            disbSch.loan__Name_of_Entity__c = 'Loan Disbursement';
            disbSch.loan__Loan_Account__c=loanAccount.Id;
            disbSch.loan__Value__c=loanAccount.loan__Loan_Amount__c-totalExp;
            disbList.add(disbSch);             
        }
        insert disbList;
        
        
        loan__Loan_Disbursal_Transaction__c disbursal =  new loan__Loan_Disbursal_Transaction__c();
        disbursal.loan__Disbursal_Date__c = systemDate; 
        disbursal.loan__Disbursed_Amt__c = loanAccount.loan__Loan_Amount__c;
        disbursal.loan__Loan_Account__c = loanAccount.id;
        disbursal.loan__Mode_of_Payment__c = paymentMode[0].Id;
        disbursal.loan__Bank_Account__c = bankAcc[0].Id;
        
        
        System.debug('disbursal'+disbursal); 
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disbursal);
        loan__loan_Account__c lAccount = action.disburseLoanAccount();
        
        loan__Payment_Mode__c pModeDR = [select id from loan__Payment_Mode__c where Name='Direct Credit'];
        List<loan__Broker_Transactions__c> bTxns = [select id,Payment_Mode__C from loan__Broker_Transactions__c where loan__Broker__C=:br.id];
        for(loan__broker_transactions__c btxn: bTxns){
            btxn.Payment_mode__c = pModeDR.id;
        }
        update bTxns;
        
        
        
          
        
        
        //if(!Test.isRunningTest())
        loanAccount = [select Id,Name,Is_Secured__c,loan__Loan_Purpose__c,loan__Loan_Purpose__r.name from loan__Loan_Account__c where Id=:loanAccount.id];
        //else
        //  loanAccount =  new loan__loan_Account__c();
        
        
        String msg = ' Successfuly '+loanAccount.Name;
        update accnt;
        
        LoanActions lAction = new LoanActions();
        List<LoanActions.HolidayPeriod> hPeriod = new List<LoanActions.HolidayPeriod>();
        Date startDate = systemDate.toStartOfMonth(); 
        Date endDate = systemDate.addMonths(14);
        lAction.saveScheduleWithHolidays(loanAccount.id, hPeriod, startDate,endDate, false);
        System.debug('conversion'+conversion);
        if(conversion){
            if(!loanAccount.Is_Secured__c || loanAccount.loan__Loan_Purpose__r.name.toUppercase().contains('A REFINANCE LOAN')){
                EmailUtil.sendEmail(con[0],false,loanApplication.Id);
            }
        }
        
        GenerateDirectDebitRequestDDP.generateDirectDebitDocument(loanAccount.Id);
        
        return 'Application converted to Loan ' + msg;        
        
    }
    
}
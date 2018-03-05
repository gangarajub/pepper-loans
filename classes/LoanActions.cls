public class LoanActions{
    
   
    public void LoanActions(){
        
    }

    public List<clcommon.FinancialCalculator.RepaymentSchedule> calculateSchedule(String loanAccountId, Decimal monthlyPaymentAmount){
        List<clcommon.FinancialCalculator.RepaymentSchedule> emiList = new List<clcommon.FinancialCalculator.RepaymentSchedule>();
        List<loan__Loan_Account__c> lAcc = [select id,loan__Loan_Amount__c,
                                        loan__Disbursal_Date__c,
                                        loan__Next_Installment_Date__c,
                                        loan__Interest_Rate__c,
                                        loan__Term_Cur__c,
                                        loan__Interest_Only_Period__c,
                                        loan__Pmt_Amt_Cur__c,
                                        loan__Balloon_Payment__c,
                                        loan__Frequency_of_Loan_Payment__c,
                                        loan__Time_Counting_Method__c
                                        
                                        from loan__Loan_Account__c where Id=:loanAccountId
                                        ];
        Decimal loanAmount = lAcc[0].loan__Loan_Amount__c;
        Date contractDate = lAcc[0].loan__Disbursal_Date__c;
        Date firstPaymentDate = lAcc[0].loan__Next_Installment_Date__c;
        Decimal rate = lAcc[0].loan__Interest_Rate__c;
        Integer term = Integer.valueOf(lAcc[0].loan__Term_Cur__c);
        Integer interestOnlyTerm = Integer.valueOf(lAcc[0].loan__Interest_Only_Period__c);
        Decimal paymentAmount = monthlyPaymentAmount;
        Decimal balloon = lAcc[0].loan__Balloon_Payment__c;
        String paymentFrequency = lAcc[0].loan__Frequency_of_Loan_Payment__c;
        
        String timeCountingMethod = CLConstants.TIME_COUNTING_ACTUAL_DAYS;
        String accrualBaseMethodCode = CLConstants.ACCRUAL_METHOD_CD_365_365;
        String billingMethodCode = CLConstants.REPAYMENT_INT_CALC_METHOD_DEC_BAL;
        String interestOnlyBehavior = 'Actual';

        Boolean orgRoundingOn = true;
        Integer orgDigitsAfterDecimals = 2;
        String  orgRoundMode = 'Nearest';

        Boolean orgSkipHolidays = false;
        Boolean orgAdjustRoundingInLastPayment = true;
        Boolean orgFinalPaymentDifference = true;
        Boolean orgEnableInterestCompounding = false;
        String orgInterestOnlyPeriodBehavior;

        Map<String, Object> orgInputs = new Map<String, Object>();
        Map<String, Object> calcInputs = new Map<String, Object>();


        Boolean calc3Failed;

        orgInputs.put('orgRoundingOn', orgRoundingOn);
        orgInputs.put('orgDigitsAfterDecimals', orgDigitsAfterDecimals);
        orgInputs.put('orgRoundMode', orgRoundMode);
        orgInputs.put('orgSkipHolidays', orgSkipHolidays);
        orgInputs.put('orgAdjustRoundingInLastPayment', orgAdjustRoundingInLastPayment);
        orgInputs.put('orgFinalPaymentDifference', orgFinalPaymentDifference);
        orgInputs.put('orgEnableInterestCompounding', orgEnableInterestCompounding);
        orgInputs.put('orgInterestOnlyPeriodBehavior', interestOnlyBehavior);

        calcInputs.put('Loan_Amt_c', loanAmount);
        calcInputs.put('Contract_Dt_c', contractDate);
        calcInputs.put('First_Payment_Dt_c', firstPaymentDate);
        calcInputs.put('Rate_c', rate);
        calcInputs.put('Term_c', 0);
        //calcInputs.put('Interest_Only_Period_c', interestOnlyTerm);
        calcInputs.put('Payment_Amt_c', paymentAmount);
        calcInputs.put('Balloon_Payment_Amt_c', balloon);
        calcInputs.put('Payment_Frequency_Cd_c', paymentFrequency);
        calcInputs.put('Time_Counting_Method_Cd_c', timeCountingMethod);
        calcInputs.put('Accrual_Base_Method_Cd_c', accrualBaseMethodCode);
        calcInputs.put('Billing_Method_Cd_c', billingMethodCode);
        calcInputs.put('Action_c','CALCULATE_TERM');

        clcommon.LoanCalculator_v3 fc3 = new clcommon.LoanCalculator_v3(orgInputs);

        try {
            clcommon.LoanCalculator_v3.LoanCalculatorInput lI = new clcommon.LoanCalculator_v3.LoanCalculatorInput(calcInputs);

            emiList = fc3.calculateEMI(lI, null, null);
        } catch (Exception e) {
              calc3Failed = true;
        }
        system.debug(emiList);
        system.debug(emiList.size());
        return emiList;
    }
    
    public Decimal calculateMonthlyPaymentAmount(Decimal loanAmount,Decimal interestRate,Decimal term, String loanApplicationId){
        List<clcommon.FinancialCalculator.RepaymentSchedule> emiList = new List<clcommon.FinancialCalculator.RepaymentSchedule>();
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanutilFacade();
        
        Date systemDate = util.getCurrentSystemDate();
        
        if(loanAmount == null){
            throw new MyException('Loan amount cannot be null.');
        }
        if(interestRate == null){
            throw new MyException('Interest rate cannot be null.');
        }
        
        if(term == null){
            throw new MyException('Term cannot be null.');
        }
        
       
        
       
        Date contractDate = systemDate;
        Date firstPaymentDate = systemDate.addMonths(1);
        Decimal rate = interestRate;
        
        //Integer interestOnlyTerm = Integer.valueOf(lAcc[0].loan__Interest_Only_Period__c);
        Decimal paymentAmount = 0;
        Decimal balloon = 0;
        String paymentFrequency = 'Monthly';
        
        String timeCountingMethod = CLConstants.TIME_COUNTING_ACTUAL_DAYS;
        String accrualBaseMethodCode = CLConstants.ACCRUAL_METHOD_CD_365_365;
        String billingMethodCode = CLConstants.REPAYMENT_INT_CALC_METHOD_DEC_BAL;
        String interestOnlyBehavior = 'Actual';

        Boolean orgRoundingOn = true;
        Integer orgDigitsAfterDecimals = 2;
        String  orgRoundMode = 'Nearest';

        Boolean orgSkipHolidays = false;
        Boolean orgAdjustRoundingInLastPayment = true;
        Boolean orgFinalPaymentDifference = true;
        Boolean orgEnableInterestCompounding = false;
        String orgInterestOnlyPeriodBehavior;

        Map<String, Object> orgInputs = new Map<String, Object>();
        Map<String, Object> calcInputs = new Map<String, Object>();


        Boolean calc3Failed;

        orgInputs.put('orgRoundingOn', orgRoundingOn);
        orgInputs.put('orgDigitsAfterDecimals', orgDigitsAfterDecimals);
        orgInputs.put('orgRoundMode', orgRoundMode);
        orgInputs.put('orgSkipHolidays', orgSkipHolidays);
        orgInputs.put('orgAdjustRoundingInLastPayment', orgAdjustRoundingInLastPayment);
        orgInputs.put('orgFinalPaymentDifference', orgFinalPaymentDifference);
        orgInputs.put('orgEnableInterestCompounding', orgEnableInterestCompounding);
        orgInputs.put('orgInterestOnlyPeriodBehavior', interestOnlyBehavior);

        calcInputs.put('Loan_Amt_c', loanAmount);
        calcInputs.put('Contract_Dt_c', contractDate);
        calcInputs.put('First_Payment_Dt_c', firstPaymentDate);
        calcInputs.put('Rate_c', rate);
        calcInputs.put('Term_c', Integer.valueOf(term));
        calcInputs.put('Interest_Only_Period_c', 0);
        calcInputs.put('Payment_Amt_c', paymentAmount);
        calcInputs.put('Balloon_Payment_Amt_c', balloon);
        calcInputs.put('Payment_Frequency_Cd_c', paymentFrequency);
        calcInputs.put('Time_Counting_Method_Cd_c', timeCountingMethod);
        calcInputs.put('Accrual_Base_Method_Cd_c', accrualBaseMethodCode);
        calcInputs.put('Billing_Method_Cd_c', billingMethodCode);
        calcInputs.put('Action_c','FIXED_AMOUNT');

        clcommon.LoanCalculator_v3 fc3 = new clcommon.LoanCalculator_v3(orgInputs);

        try {
            clcommon.LoanCalculator_v3.LoanCalculatorInput lI = new clcommon.LoanCalculator_v3.LoanCalculatorInput(calcInputs);

            emiList = fc3.calculateEMI(lI, null, null);
        } catch (Exception e) {
              calc3Failed = true;
        }
        
        return emiList[0].amount;
    }

    public loan__Automated_Payment_Setup__c changePaymentAmount(Decimal newAmount,String loanAccountId){
         loan.GlobalLoanUtilFacade loanUtil=new loan.GlobalLoanUtilFacade();
         
         Date systemDate = loanUtil.getCurrentSystemDate();
         loan__Loan_Account__c lAcc = [select id,loan__ACH_Debit_Amount__c,loan__Next_Installment_Date__c,loan__Maturity_Date_Current__c,loan__Payment_Mode__c,loan__ACH_Frequency__c,Default_bank_Account__c,Additional_Monthly_Debit_Amount__c,loan__Pmt_Amt_Cur__c from loan__Loan_Account__c 
                                         where Id=:loanAccountId];
         Decimal additionalAmount = newAmount - lAcc.loan__Pmt_Amt_Cur__c;
         List<loan__Automated_Payment_Setup__c> futureAPS = [select id,name,
                                                            loan__Transaction_Amount__c, 
                                                            loan__Amount_Type__c ,loan__Bank_Account__c ,
                                                            loan__CL_Contract__c,loan__Debit_Date__c,
                                                            loan__Debit_Day__c,loan__Frequency__c, 
                                                            loan__Payment_Mode__c, loan__Recurring_ACH_End_Date__c  ,
                                                            loan__Recurring_ACH_Start_Date__c,loan__Second_Debit_Date__c,
                                                            loan__Setup_Date__c,
                                                            loan__Type__c from loan__Automated_Payment_Setup__c where loan__CL_Contract__c=:loanAccountId and loan__active__c=false and loan__type__c='RECURRING' and loan__Recurring_ACH_Start_Date__c>:systemDate];
         
         List<loan__Automated_Payment_Setup__c> aps =  [select id,name,
                                                            loan__Transaction_Amount__c, 
                                                            loan__Amount_Type__c ,loan__Bank_Account__c ,
                                                            loan__CL_Contract__c,loan__Debit_Date__c,
                                                            loan__Debit_Day__c,loan__Frequency__c, 
                                                            loan__Payment_Mode__c, loan__Recurring_ACH_End_Date__c  ,
                                                            loan__Recurring_ACH_Start_Date__c,loan__Second_Debit_Date__c,
                                                            loan__Setup_Date__c,
                                                            loan__Type__c from loan__Automated_Payment_Setup__c where loan__CL_Contract__c=:loanAccountId and loan__active__c=true and loan__type__c='RECURRING'];
        loan__Automated_Payment_Setup__c newAps = new loan__Automated_Payment_Setup__c();
        
        /*->If payment amount changes for a recurring payment and a future recurring is present.
              ->current APS will be modified according to new amount and future APS will be modified
              according to new amount.
          ->if payment amount changes for a recurring payment and no future recurring setup present:
              ->update existing active APS with new amount.*/
              
        if(futureAPS.size()>0){
            //oldAPS = futureAPS[0];
            if(futureAPS[0].loan__Frequency__c.equalsignorecase('Weekly')){
                futureAPS[0].loan__Transaction_Amount__c=(newAmount*12)/48;
                        
            }else if(futureAPS[0].loan__Frequency__c.equalsignorecase('Monthly')){
                futureAPS[0].loan__Transaction_Amount__c=newAmount;
                
            }else if(futureAPS[0].loan__Frequency__c.equalsignorecase('Bi-weekly')){
                futureAPS[0].loan__Transaction_Amount__c=(newAmount*12)/24;
                
            }
            update futureAPS;
              
        }
        if (aps.size()>0){
            //oldAPS = aps[0];
            if(aps[0].loan__Frequency__c.equalsignorecase('Weekly')){
                aps[0].loan__Transaction_Amount__c=(newAmount*12)/48;
                lAcc.loan__ACH_Debit_Amount__c = aps[0].loan__Transaction_Amount__c;
            }else if(aps[0].loan__Frequency__c.equalsignorecase('Monthly')){
                aps[0].loan__Transaction_Amount__c=newAmount;
                lAcc.loan__ACH_Debit_Amount__c = aps[0].loan__Transaction_Amount__c;
            }else if(aps[0].loan__Frequency__c.equalsignorecase('Bi-weekly')){
                aps[0].loan__Transaction_Amount__c=(newAmount*12)/24;
                lAcc.loan__ACH_Debit_Amount__c = aps[0].loan__Transaction_Amount__c;
            }
            update aps;
        }
        
       
        
        if(futureAps.size() == 0 && aps.size()==0){
            Decimal debitAmount = 0;
            if(lAcc.loan__ACH_Frequency__c.equalsignorecase('Weekly')){
                debitAmount=(newAmount*12)/48;
                lAcc.loan__ACH_Debit_Amount__c = debitAmount;
            }else if(lAcc.loan__ACH_Frequency__c.equalsignorecase('Monthly')){
                debitAmount=newAmount;
                lAcc.loan__ACH_Debit_Amount__c = debitAmount;
            }else if(lAcc.loan__ACH_Frequency__c.equalsignorecase('Bi-weekly')){
                debitAmount=(newAmount*12)/24;
                lAcc.loan__ACH_Debit_Amount__c = debitAmount;
            }
            newAps.loan__Active__c = true;
            newAps.loan__Transaction_Amount__c=debitAmount;
            newAps.loan__Amount_Type__c = 'FIXED';
            newAps.loan__Bank_Account__c = lAcc.Default_Bank_Account__c ;
            newAps.loan__CL_Contract__c= lAcc.id;    
            newAps.loan__Frequency__c= lAcc.loan__ACH_Frequency__c;
            
            newAps.loan__Payment_Mode__c = lAcc.loan__Payment_Mode__c;
            newAps.loan__Recurring_ACH_End_Date__c  = lAcc.loan__Maturity_Date_Current__c;
            newAps.loan__Recurring_ACH_Start_Date__c= lAcc.loan__Next_Installment_Date__c;
            //newAps.loan__Second_Debit_Date__c= oldAPS.loan__Second_Debit_Date__c;
            newAps.loan__Setup_Date__c= systemDate ;
            newAps.loan__Debit_Date__c = lAcc.loan__Next_Installment_Date__c;
            newAps.loan__Type__c='RECURRING' ;
            newAps.loan__Retry__c = 'Disabled';
            insert newAPS;
        }
        List<Automated_Repayment_Schedule__c> aRS = [select id,Repayment_Amount__c,Repayment_Date__c from Automated_Repayment_Schedule__c where is_primary__c = true and CL_Contract__c=:loanAccountId];
        if(lAcc.Additional_Monthly_Debit_Amount__c==null){
            lAcc.Additional_Monthly_Debit_Amount__c = 0;
        }
        if(aRS.size()>0){
            for(Automated_Repayment_Schedule__c ar:aRS){
                if(ar.Repayment_Amount__c >0){
                    ar.Repayment_Amount__c = ar.Repayment_Amount__c - lAcc.Additional_Monthly_Debit_Amount__c + (newAmount - lAcc.loan__Pmt_Amt_Cur__c);
                }
            }
        }
        update aRS;
        
        lAcc.Additional_Monthly_Debit_Amount__c = additionalAmount;
        update lAcc;
        
        if(futureAPs.size()>0){
            newAps = futureAps[0];
        }
        if(aps.size()>0){
            newAps = aps[0];
        }
           
        
        return newAps;
    }
    
    public loan__Automated_Payment_Setup__c changeFrequency(Date debitDate,String newFrequency,String loanAccountId){
        loan.GlobalLoanUtilFacade loanUtil;
         loanUtil = new loan.GlobalLoanUtilFacade();
         Date systemDate; 
         systemDate = loanUtil.getCurrentSystemDate();
         
         loan__Loan_Account__c lAcc = [select Id ,loan__Maturity_Date_Current__c ,Default_Bank_Account__c, loan__ACH_Frequency__c,loan__ACH_Debit_Amount__c from loan__Loan_Account__c
                                         where Id=:loanAccountId];
         
         
         
         List<loan__Automated_Payment_Setup__c> futureAPS = [select id,name,
                                                            loan__Transaction_Amount__c, 
                                                            loan__Amount_Type__c ,loan__Bank_Account__c ,
                                                            loan__CL_Contract__c,loan__Debit_Date__c,
                                                            loan__Debit_Day__c,loan__Frequency__c, 
                                                            loan__Payment_Mode__c, loan__Recurring_ACH_End_Date__c  ,
                                                            loan__Recurring_ACH_Start_Date__c,loan__Second_Debit_Date__c,
                                                            loan__Setup_Date__c,
                                                            loan__Type__c from loan__Automated_Payment_Setup__c where loan__CL_Contract__c=:loanAccountId and loan__active__c=false and loan__type__c='RECURRING' and loan__Recurring_ACH_Start_Date__c>:systemDate];
         
         List<loan__Automated_Payment_Setup__c> aps =  [select id,name,
                                                            loan__Transaction_Amount__c, 
                                                            loan__Amount_Type__c ,loan__Bank_Account__c ,
                                                            loan__CL_Contract__c,loan__Debit_Date__c,
                                                            loan__Debit_Day__c,loan__Frequency__c, 
                                                            loan__Payment_Mode__c, loan__Recurring_ACH_End_Date__c  ,
                                                            loan__Recurring_ACH_Start_Date__c,loan__Second_Debit_Date__c,
                                                            loan__Setup_Date__c,
                                                            loan__Type__c from loan__Automated_Payment_Setup__c where loan__CL_Contract__c=:loanAccountId and loan__active__c=true and loan__type__c='RECURRING'];
        loan__Automated_Payment_Setup__c newAps = new loan__Automated_Payment_Setup__c();
        
        
        
        /*If payment frequency changes and no future recurring setup present:
          ->create a future APS, converting payment amount to respective frequency and 
          date of APS will be one frequency added to already scheduled payment.
        */
        
        /*
        if payment frequency changes for a recurring payment and a future recurring is present.
            ->future APS Date will be modified on the basis of current debit date.
        */
        Date nexDate;
        Decimal newDebitAmount = 0;
        if(futureAPS.size()>0 && aps.size()>0){
            newAPS = futureAPS[0];
            if(newFrequency != newAps.loan__Frequency__c){
                Decimal oldAmountAnually;
                if(newAPS.loan__Frequency__c.equalsignorecase('Weekly')){
                    oldAmountAnually = newAPS.loan__Transaction_Amount__c*48;
                }else if(newAPS.loan__Frequency__c.equalsignorecase('Bi-weekly')){
                    oldAmountAnually = newAPS.loan__Transaction_Amount__c*24;
                }else if(newAPS.loan__Frequency__c.equalsignorecase('Monthly')){
                    oldAmountAnually = newAPS.loan__Transaction_Amount__c*12;
                }
                
                if(newFrequency.equalsignorecase('Weekly')){
                    newDebitAmount = oldAmountAnually/48;
                    nexDate = debitDate;
                }else if(newFrequency.equalsignorecase('Bi-weekly')){
                    newDebitAmount =  oldAmountAnually/24;
                    nexDate = debitDate;
                }else if(newFrequency.equalsignorecase('Monthly')){
                    newDebitAmount = oldAmountAnually/12;
                    nexDate = debitDate;
                }
                Date endDate;
                if(newAPS.loan__Recurring_ACH_End_Date__c>=aps[0].loan__Recurring_ACH_End_Date__c){
                    endDate = newAPS.loan__Recurring_ACH_End_Date__c;
                }
                newAPS.loan__Transaction_Amount__c = newDebitAmount;
                newAPS.loan__Debit_Date__c = nexDate;
                newAPS.loan__Recurring_ACH_Start_Date__c = nexDate;
                aps[0].loan__Recurring_ACH_End_Date__c = nexDate.addDays(-1);
                newAPS.loan__Frequency__c = newFrequency;
                lAcc.loan__ACH_Frequency__c = newFrequency;
                lAcc.loan__ACH_Debit_Amount__c = newDebitAmount;
                update newAPS;
            }else{
                
                nexDate = debitDate;
                
                Date endDate;
                if(newAPS.loan__Recurring_ACH_End_Date__c>=aps[0].loan__Recurring_ACH_End_Date__c){
                    endDate = newAPS.loan__Recurring_ACH_End_Date__c;
                }
                
                newAPS.loan__Debit_Date__c = nexDate;
                newAPS.loan__Recurring_ACH_Start_Date__c = nexDate;
                aps[0].loan__Recurring_ACH_End_Date__c = nexDate.addDays(-1);
                update aps[0];
                update newAPS;
            }
            
            
        }else if(futureAps.size()==0 && aps.size()>0 && (newFrequency!=aps[0].loan__Frequency__c)){
                Decimal oldAmountAnually;
                if(aps[0].loan__Frequency__c.equalsignorecase('Weekly')){
                    oldAmountAnually = aps[0].loan__Transaction_Amount__c*48;
                }else if(aps[0].loan__Frequency__c.equalsignorecase('Bi-weekly')){
                    oldAmountAnually = aps[0].loan__Transaction_Amount__c*24;
                }else if(aps[0].loan__Frequency__c.equalsignorecase('Monthly')){
                    oldAmountAnually = aps[0].loan__Transaction_Amount__c*12;
                }
                
                if(newFrequency.equalsignorecase('Weekly')){
                    newDebitAmount = oldAmountAnually/48;
                    nexDate = debitDate;
                }else if(newFrequency.equalsignorecase('Bi-weekly')){
                    newDebitAmount =  oldAmountAnually/24;
                    nexDate = debitDate;
                }else if(newFrequency.equalsignorecase('Monthly')){
                    newDebitAmount = oldAmountAnually/12;
                    nexDate = debitDate;
                }
                
                aps[0].loan__Recurring_ACH_End_Date__c = nexDate.addDays(-1);
                newAps.loan__Active__c = false;
                newAps.loan__Transaction_Amount__c=newDebitAmount;
                newAps.loan__Amount_Type__c = 'FIXED';
                newAps.loan__Bank_Account__c = aps[0].loan__Bank_Account__c ;
                newAps.loan__CL_Contract__c= aps[0].loan__CL_Contract__c;    
                newAps.loan__Frequency__c= newFrequency;
                
                newAps.loan__Payment_Mode__c = aps[0].loan__Payment_Mode__c;
                newAps.loan__Recurring_ACH_End_Date__c  = lAcc.loan__Maturity_Date_Current__c  ;
                newAps.loan__Recurring_ACH_Start_Date__c= nexDate;
                //newAps.loan__Second_Debit_Date__c= oldAPS.loan__Second_Debit_Date__c;
                newAps.loan__Setup_Date__c= systemDate ;
                newAps.loan__Debit_Date__c = nexDate;
                newAps.loan__Type__c='RECURRING' ;
                lAcc.loan__ACH_Frequency__c = newFrequency;
                lAcc.loan__ACH_Debit_Amount__c = newDebitAmount;
                newAPS.loan__Retry__c = 'Disabled';
                insert newAPS;
            }
        
        update aps;
        //upsert newAPS;
        
        update lAcc;
        
     return newAps;    
    }
    
    public loan__Automated_Payment_Setup__c changeFrequency(String newFrequency,String loanAccountId){
        loan.GlobalLoanUtilFacade loanUtil;
         loanUtil = new loan.GlobalLoanUtilFacade();
         Date systemDate; 
         systemDate = loanUtil.getCurrentSystemDate();
         
         loan__Loan_Account__c lAcc = [select Id ,loan__Maturity_Date_Current__c ,Default_Bank_Account__c, loan__ACH_Frequency__c,loan__ACH_Debit_Amount__c from loan__Loan_Account__c
                                         where Id=:loanAccountId];
         
         
         
         List<loan__Automated_Payment_Setup__c> futureAPS = [select id,name,
                                                            loan__Transaction_Amount__c, 
                                                            loan__Amount_Type__c ,loan__Bank_Account__c ,
                                                            loan__CL_Contract__c,loan__Debit_Date__c,
                                                            loan__Debit_Day__c,loan__Frequency__c, 
                                                            loan__Payment_Mode__c, loan__Recurring_ACH_End_Date__c  ,
                                                            loan__Recurring_ACH_Start_Date__c,loan__Second_Debit_Date__c,
                                                            loan__Setup_Date__c,
                                                            loan__Type__c from loan__Automated_Payment_Setup__c where loan__CL_Contract__c=:loanAccountId and loan__active__c=false and loan__type__c='RECURRING' and loan__Recurring_ACH_Start_Date__c>:systemDate];
         
         List<loan__Automated_Payment_Setup__c> aps =  [select id,name,
                                                            loan__Transaction_Amount__c, 
                                                            loan__Amount_Type__c ,loan__Bank_Account__c ,
                                                            loan__CL_Contract__c,loan__Debit_Date__c,
                                                            loan__Debit_Day__c,loan__Frequency__c, 
                                                            loan__Payment_Mode__c, loan__Recurring_ACH_End_Date__c  ,
                                                            loan__Recurring_ACH_Start_Date__c,loan__Second_Debit_Date__c,
                                                            loan__Setup_Date__c,
                                                            loan__Type__c from loan__Automated_Payment_Setup__c where loan__CL_Contract__c=:loanAccountId and loan__active__c=true and loan__type__c='RECURRING'];
        loan__Automated_Payment_Setup__c newAps = new loan__Automated_Payment_Setup__c();
        
        
        
        /*If payment frequency changes and no future recurring setup present:
          ->create a future APS, converting payment amount to respective frequency and 
          date of APS will be one frequency added to already scheduled payment.
        */
        
        /*
        if payment frequency changes for a recurring payment and a future recurring is present.
            ->future APS Date will be modified on the basis of current debit date.
        */
        Date nexDate;
        Decimal newDebitAmount = 0;
        if(futureAPS.size()>0 && aps.size()>0){
            newAPS = futureAPS[0];
            if(newFrequency != newAps.loan__Frequency__c){
                Decimal oldAmountAnually;
                if(newAPS.loan__Frequency__c.equalsignorecase('Weekly')){
                    oldAmountAnually = newAPS.loan__Transaction_Amount__c*48;
                }else if(newAPS.loan__Frequency__c.equalsignorecase('Bi-weekly')){
                    oldAmountAnually = newAPS.loan__Transaction_Amount__c*24;
                }else if(newAPS.loan__Frequency__c.equalsignorecase('Monthly')){
                    oldAmountAnually = newAPS.loan__Transaction_Amount__c*12;
                }
                
                if(newFrequency.equalsignorecase('Weekly')){
                    newDebitAmount = oldAmountAnually/48;
                    nexDate = loan.DateUtil.getNextCycleDate(aps[0].loan__Debit_Date__c,1,'Weekly',null,null,1);
                }else if(newFrequency.equalsignorecase('Bi-weekly')){
                    newDebitAmount =  oldAmountAnually/24;
                    nexDate = loan.DateUtil.getNextCycleDate(aps[0].loan__Debit_Date__c,1,'Bi-weekly',null,null,1);
                }else if(newFrequency.equalsignorecase('Monthly')){
                    newDebitAmount = oldAmountAnually/12;
                    nexDate = loan.DateUtil.getNextCycleDate(aps[0].loan__Debit_Date__c,1,'Monthly',null,null,1);
                }
                Date endDate;
                if(newAPS.loan__Recurring_ACH_End_Date__c>=aps[0].loan__Recurring_ACH_End_Date__c){
                    endDate = newAPS.loan__Recurring_ACH_End_Date__c;
                }
                newAPS.loan__Transaction_Amount__c = newDebitAmount;
                newAPS.loan__Debit_Date__c = nexDate;
                newAPS.loan__Recurring_ACH_Start_Date__c = nexDate;
                aps[0].loan__Recurring_ACH_End_Date__c = nexDate;
                newAPS.loan__Frequency__c = newFrequency;
                lAcc.loan__ACH_Frequency__c = newFrequency;
                lAcc.loan__ACH_Debit_Amount__c = newDebitAmount;
                update newAPS;
            }
            
            
        }else if(futureAps.size()==0 && aps.size()>0 && (newFrequency!=aps[0].loan__Frequency__c)){
                Decimal oldAmountAnually;
                if(aps[0].loan__Frequency__c.equalsignorecase('Weekly')){
                    oldAmountAnually = aps[0].loan__Transaction_Amount__c*48;
                }else if(aps[0].loan__Frequency__c.equalsignorecase('Bi-weekly')){
                    oldAmountAnually = aps[0].loan__Transaction_Amount__c*24;
                }else if(aps[0].loan__Frequency__c.equalsignorecase('Monthly')){
                    oldAmountAnually = aps[0].loan__Transaction_Amount__c*12;
                }
                
                if(newFrequency.equalsignorecase('Weekly')){
                    newDebitAmount = oldAmountAnually/48;
                    nexDate = loan.DateUtil.getNextCycleDate(aps[0].loan__Debit_Date__c,1,'Weekly',null,null,1);
                }else if(newFrequency.equalsignorecase('Bi-weekly')){
                    newDebitAmount =  oldAmountAnually/24;
                    nexDate = loan.DateUtil.getNextCycleDate(aps[0].loan__Debit_Date__c,1,'Bi-weekly',null,null,1);
                }else if(newFrequency.equalsignorecase('Monthly')){
                    newDebitAmount = oldAmountAnually/12;
                    nexDate = loan.DateUtil.getNextCycleDate(aps[0].loan__Debit_Date__c,1,'Monthly',null,null,1);
                }
                
                aps[0].loan__Recurring_ACH_End_Date__c = nexDate;
                newAps.loan__Active__c = false;
                newAps.loan__Transaction_Amount__c=newDebitAmount;
                newAps.loan__Amount_Type__c = 'FIXED';
                newAps.loan__Bank_Account__c = aps[0].loan__Bank_Account__c ;
                newAps.loan__CL_Contract__c= aps[0].loan__CL_Contract__c;    
                newAps.loan__Frequency__c= newFrequency;
                
                newAps.loan__Payment_Mode__c = aps[0].loan__Payment_Mode__c;
                newAps.loan__Recurring_ACH_End_Date__c  = lAcc.loan__Maturity_Date_Current__c  ;
                newAps.loan__Recurring_ACH_Start_Date__c= nexDate;
                //newAps.loan__Second_Debit_Date__c= oldAPS.loan__Second_Debit_Date__c;
                newAps.loan__Setup_Date__c= systemDate ;
                newAps.loan__Debit_Date__c = nexDate;
                newAps.loan__Type__c='RECURRING' ;
                lAcc.loan__ACH_Frequency__c = newFrequency;
                lAcc.loan__ACH_Debit_Amount__c = newDebitAmount;
                insert newAPS;
            }
        
        update aps;
        //upsert newAPS;
        
        update lAcc;
        
     return newAps;    
    }
    
    public loan__Automated_Payment_Setup__c makeOneOffPayment(Decimal debitAmount, String bankAccountId,String loanId,String paymentModeId,Date debitDate,Boolean isDebitAuthorizationProvided, Boolean agreedtoTermsAndConditions){
        loan.GlobalLoanUtilFacade loanUtil=new loan.GlobalLoanUtilFacade();
        Date systemDate = loanUtil.getCurrentSystemDate();
        
        if(debitDate<=systemDate){
            throw new myException('Debit Date cannot be less than or equal to system date.');
        }
    
        
        List<loan__Automated_Payment_Setup__c> futureOneTimeAPS = [select id from loan__Automated_Payment_Setup__c
                                                        where loan__Type__c='ONE TIME' and loan__Debit_Date__c>:systemDate and loan__Active__c=false];
        if(futureOneTimeAPS.size()>0){
            delete futureOneTimeAPS;
        }
        
        loan__Automated_Payment_Setup__c newAps = new loan__Automated_Payment_Setup__c();
        if(paymentModeId==null){
            paymentModeId = [select id from loan__Payment_mode__c where Name= 'ACH'][0].id;
        }
        if(DebitAmount!=null && bankAccountId!=null && loanId!=null && paymentModeId!=null && debitDate!=null){
        
                System.debug('debitDate'+debitDate);
                newAps.loan__Active__c = true;
                newAps.loan__Transaction_Amount__c=debitAmount;
                newAps.loan__Bank_Account__c = bankAccountId;
                newAps.loan__CL_Contract__c= loanId;    
                newAps.loan__Payment_Mode__c= paymentModeId;
                newAps.loan__Setup_Date__c= systemDate;
                newAps.loan__Debit_Date__c = debitDate;
                newAps.loan__Type__c='ONE TIME';
                newAPS.Agreed_to_Terms_and_Conditions__c = agreedToTermsAndConditions;
                newAPS.loan__Retry__c = 'Disabled';
                newAPS.Is_Debit_Authorization_Provided__c = isDebitAuthorizationProvided;
            
        }
        try{
           insert newAps;
           return newAps;
        }catch(Exception e){
           
        } 
        return newAps;
        
       
        
    }
    
    public class HolidayPeriod{
        public Date startDate;
        public Date endDate;
        
        public HolidayPeriod(Date startDate, Date endDate){
            this.startDate = startDate;
            this.endDate = endDate;
        }
        
        public HolidayPeriod(){}
    }
    
    
    public List<Automated_Repayment_Schedule__c> generateScheduleWithHolidays(String loanAccountId,List<HolidayPeriod> hPeriod, Date schStartDate,Date schEndDate, Boolean isRecurring){
        
        List<loan__Loan_Account__c> loanAccounts = [select id ,On_payment_Holiday__c, loan__Maturity_Date_Current__c,Additional_Monthly_Debit_Amount__c,loan__Reserve_Amount_for_Next_Due__c,loan__First_Installment_Date__c, loan__Next_Installment_Date__c,loan__Pmt_Amt_Cur__c,(select id,loan__Debit_Date__c,loan__Frequency__c,
                                        loan__Recurring_ACH_End_Date__c,loan__Recurring_ACH_Start_Date__c,loan__Transaction_Amount__c,
                                        loan__Type__c from loan__Automated_Payment_Setup__r where loan__Active__c = true 
                                        and loan__Type__c = 'RECURRING' limit 1) from loan__Loan_Account__c where Id=:loanAccountId ];
        if(loanAccounts.size()==0){
            throw new MyException('Loan account with given Id not found.');
        }
        
        if(hPeriod.size()==0){
            loanAccounts[0].On_Payment_Holiday__c = false;
            
        }else{
            loanAccounts[0].On_Payment_Holiday__c = true;
            
        }
        List<HolidayPeriod> tempHolidayPeriod = new List<HolidayPeriod>();
        tempHolidayPeriod.addAll(hPeriod);
        if(hPeriod.size()>0){
            Integer numberofHolidayPeriod = hPeriod.size();
            for(Integer i=0;i<numberofHolidayPeriod;i++){
                hPeriod = new List<HolidayPeriod>();
                hPeriod.addAll(tempHolidayPeriod);
                tempHolidayPeriod = new List<HolidayPeriod>();
                for(Integer j=0; j<hPeriod.size() ;j++){
                    if((j+1)<hPeriod.size() && hPeriod[j].endDate.daysBetween(hPeriod[j+1].startDate)==1 ){
                        tempHolidayPeriod.add(new HolidayPeriod(hPeriod[j].startDate,hPeriod[j+1].endDate));
                        j++;
                    }else{
                        tempHolidayPeriod.add(hPeriod[j]);
                    }
                }
            }
            
        }
        hPeriod = new List<HolidayPeriod>();
        hPeriod.addAll(tempHolidayPeriod);
        system.debug(hPeriod);
        Decimal monthlyPaymentAmount = 0;
        Date nextDebitDate;
        Decimal numberOfHolidayPeriodsinAYear = 0;
        Decimal holidayAmountForAYear = 0;
        Decimal reserveAmount  = 0;
        Decimal additionalAmountPerMonth = 0;
        
        monthlyPaymentAmount = loanAccounts[0].loan__Pmt_Amt_Cur__c!=null?loanAccounts[0].loan__Pmt_Amt_Cur__c:0;
        additionalAmountPerMonth = loanAccounts[0].Additional_Monthly_Debit_Amount__c!=null?loanAccounts[0].Additional_Monthly_Debit_Amount__c:0;
        reserveAmount = loanAccounts[0].loan__Reserve_Amount_for_Next_Due__c!=null?loanAccounts[0].loan__Reserve_Amount_for_Next_Due__c:0;
        List<HolidayPeriod> compHolidaySch = new List<HolidayPeriod>();
               
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        
        if(hPeriod!=null && hPeriod.size()>0){
            compHolidaySch.addAll(hperiod);
            if(isRecurring){
                Decimal numberOfYearsToMaturity = loanAccounts[0].loan__Maturity_Date_Current__c.year() - hperiod[hPeriod.size()-1].endDate.year();
                for(Integer i = 1;i<= numberOfYearsToMaturity;i++){
                    for(HolidayPeriod hp:hPeriod){
                        if(hp.endDate>loanAccounts[0].loan__Maturity_Date_Current__c && hp.startDate< loanAccounts[0].loan__Maturity_Date_Current__c){
                            Integer numberOfDaysInMonth = Date.daysInMonth(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month());
                            Date hEndDate =  Date.newInstance(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month(),numberOfDaysInMonth);
                            compHolidaySch.add(new HolidayPeriod(hp.startDate.addyears(i),hEndDate));
                        }else if(hp.startDate > loanAccounts[0].loan__Maturity_Date_Current__c){
                            // do nothing
                        }else{
                            compHolidaySch.add(new HolidayPeriod(hp.startDate.addyears(i),hp.endDate.addyears(i)));
                        }
                        
                    }
                }
            }
            
            // Print holiday Schedule here
        }
        system.debug(compHolidaySch);
        List<Automated_Repayment_Schedule__c> aRSList = new List<Automated_Repayment_Schedule__c>();
        
        Date startDate = schStartDate;
        Date endDate;
        system.debug(schStartDate);
        Integer seq = 1;
        Automated_Repayment_Schedule__c aRS = new Automated_Repayment_Schedule__c();
        if(compHolidaySch!=null && compHolidaySch.size()>0){
            for(HolidayPeriod hp : compHolidaySch){
                system.debug(hp.startDate);
                system.debug(startDate);
                aRS = new Automated_Repayment_Schedule__c();
                if(loanAccounts[0].loan__Maturity_Date_Current__c<=hp.endDate){
                   Integer numberOfDaysInMonth = Date.daysInMonth(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month());
                   hp.endDate =  Date.newInstance(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month(),numberOfDaysInMonth);
                }
                if(startDate.monthsBetween(hp.startDate)>0){
                    Decimal numberOfMonthsExclHolidays = startDate.monthsBetween(hp.startDate);
                    Decimal numberOfMonths = startDate.monthsBetween(hp.endDate.addDays(1));
                    Decimal amountToBeDistributed = 0;
                    if((((monthlyPaymentAmount+additionalAmountPerMonth)* numberOfMonths )- reserveAmount)>0){
                        amountToBeDistributed =( (monthlyPaymentAmount+additionalAmountPerMonth)* numberOfMonths )- reserveAmount;
                    }
                    system.debug((monthlyPaymentAmount+additionalAmountPerMonth)* numberOfMonths);
                    system.debug(reserveAmount);
                    system.debug(numberOfMonthsExclHolidays);
                    
                    aRS.Repayment_Amount__c = Math.max(amountToBeDistributed/numberOfMonthsExclHolidays,monthlyPaymentAmount);
                    aRS.Repayment_Date__c = startDate;
                    aRS.Sequence__c = seq;
                    aRS.CL_Contract__c = loanAccountId;
                    aRS.Is_Primary__c = true;
                    aRS.Number_of_Payments__c = numberOfMonthsExclHolidays;
                    arsList.add(aRS);
                    seq++;    
                }
                if(hp.startDate.monthsBetween(hp.endDate.addDays(1))>0){
                    
                    aRS = new Automated_Repayment_Schedule__c();
                    aRS.Repayment_Amount__c = 0;
                    aRS.Repayment_Date__c = hp.startDate;
                    aRS.Sequence__c = seq;
                    aRS.CL_Contract__c = loanAccountId;
                    aRS.Is_Primary__c = true;
                    aRS.Number_of_Payments__c = hp.startDate.monthsBetween(hp.endDate.addDays(1));
                    aRSList.add(aRS);
                    seq++;
                    //reserveAmount = (monthlyPaymentAmount+additionalAmountPerMonth) * hp.startDate.monthsBetween(hp.endDate.addDays(1));
                    reserveAmount = 0;
                }
                startDate = hp.endDate.addDays(1);
            }
            
            if(isRecurring){
                Integer numberOfDaysInMonth = Date.daysInMonth(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month());
                endDate =  Date.newInstance(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month(),numberOfDaysInMonth);
                if(loanAccounts[0].loan__Maturity_Date_Current__c>=startDate){
                    aRS = new Automated_Repayment_Schedule__c();
                    aRS.Repayment_Amount__c = monthlyPaymentAmount+additionalAmountPerMonth;
                    aRS.Repayment_Date__c = startDate;
                    aRS.Sequence__c = seq;
                    aRS.CL_Contract__c = loanAccountId;
                    aRS.Is_Primary__c = true;
                    aRS.Number_of_Payments__c = startDate.monthsBetween(endDate.addDays(1));
                    aRSList.add(aRS);
                }
                
            }else{
                Integer numberOfDaysInMonth = Date.daysInMonth(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month());
                endDate =  Date.newInstance(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month(),numberOfDaysInMonth);
                if(endDate>=schEndDate){
                    endDate = schEndDate;
                }
                
                aRS = new Automated_Repayment_Schedule__c();
                aRS.Repayment_Amount__c = monthlyPaymentAmount+additionalAmountPerMonth;
                aRS.Repayment_Date__c = startDate;
                aRS.Sequence__c = seq;
                aRS.CL_Contract__c = loanAccountId;
                aRS.Is_Primary__c = true;
                aRS.Number_of_Payments__c = startDate.monthsBetween(endDate.addDays(1));
                aRSList.add(aRS);
            }
            
        }
        if(compHolidaySch==null || compHolidaySch.size()==0){
            if(isRecurring){
                Integer numberOfDaysInMonth = Date.daysInMonth(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month());
                endDate =  Date.newInstance(loanAccounts[0].loan__Maturity_Date_Current__c.year(),loanAccounts[0].loan__Maturity_Date_Current__c.month(),numberOfDaysInMonth);
            }else{
                endDate = schEndDate.addDays(1);
            }
            aRS = new Automated_Repayment_Schedule__c();
            aRS.Repayment_Amount__c = monthlyPaymentAmount+additionalAmountPerMonth;
            aRS.Repayment_Date__c = schStartDate;
            aRS.Sequence__c = seq;
            aRS.CL_Contract__c = loanAccountId;
            aRS.Is_Primary__c = true;
            aRS.Number_of_Payments__c = schStartDate.monthsBetween(endDate);
            aRSList.add(aRS);
        }
        
        return aRSList;
    }
    
    public void saveScheduleWithHolidays(String loanAccountId,List<HolidayPeriod> hPeriod, Date schStartDate,Date schEndDate, Boolean isRecurring){
        List<Automated_Repayment_Schedule__c> prevARS = [select id , Is_Primary__c from Automated_Repayment_Schedule__c where Cl_Contract__c=:loanAccountId];
        for(Automated_Repayment_Schedule__c prevAR:prevARS){
            prevAR.is_Primary__c =false;
        }
        update prevARS;
        system.debug(schStartDate);
        System.debug(schEndDate);
        List<Automated_Repayment_Schedule__c> aRS = generateScheduleWithHolidays(loanAccountId,hPeriod,schStartDate,schEndDate,isRecurring);
        insert aRS;
        List<loan__Loan_Account__c> lAcc = [select id,on_Payment_holiday__c,Payment_Holiday_Setup_Date__c,Additional_Monthly_Debit_Amount__c,loan__Pmt_Amt_Cur__c from loan__Loan_Account__c where Id=:loanAccountId];
        List<Holiday_Schedule__c> holidaySch = [select id from Holiday_Schedule__c where CL_Contract__c=:loanAccountId];
        delete holidaySch;
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate  = util.getCurrentSystemDate();
        if(hPeriod.size()==0){
            lAcc[0].on_payment_holiday__c = false;
        }else{
            lAcc[0].on_payment_holiday__c = true;
            List<Holiday_Schedule__c> holidayPeriod  = new List<Holiday_Schedule__c>();
            lAcc[0].Payment_Holiday_Setup_Date__c = systemDate;
            for(HolidayPeriod hp:hPeriod){
                holidayPeriod.add(new Holiday_Schedule__c(Start_Date__c = hp.startDate,End_Date__c = hp.endDate,CL_Contract__c = loanAccountId));
            }
            insert holidayPeriod;
        }
        update lAcc[0];
        List<loan__Automated_Payment_Setup__c> aps = [select id,loan__Transaction_Amount__c,loan__frequency__C from loan__Automated_Payment_Setup__c where loan__Active__c= true and loan__Type__c='RECURRING' and loan__CL_Contract__c=:loanAccountId];
        Decimal newDebitAmount = aps[0].loan__Transaction_Amount__c;
        if(inPaymentHoliday(lAcc[0].id) && aps.size()==1){
            for(Automated_Repayment_Schedule__c ar : aRS){
                Date startDate;
                Date monthEndDate = ar.Repayment_Date__c.addMonths((Integer)ar.Number_of_Payments__c);
                if(systemDate>=ar.Repayment_Date__c && systemDate <= monthEndDate.addDays(-1)){
                    
                    
                    if(aps[0].loan__Frequency__c.equalsignorecase('Weekly')){
                        Integer numberOfWeeks = 0;
                        if(lAcc[0].Payment_Holiday_Setup_Date__c >= ar.Repayment_Date__c){
                            numberOfWeeks = (lAcc[0].Payment_Holiday_Setup_Date__c.daysBetween(ar.Repayment_Date__c.addMonths((Integer)ar.Number_of_Payments__c)))/7;
                        }else{
                            numberOfWeeks = (ar.Repayment_Date__c.daysBetween(ar.Repayment_Date__c.addMonths((Integer)ar.Number_of_Payments__c)))/7;
                        }
                        
                        newDebitAmount = ar.Repayment_Amount__c/numberOfWeeks*ar.Number_of_Payments__c;
                        //numberOfCycles = loan.DateUtil.cyclesBetween(loanAccount.loan__Expected_Repayment_Start_Date__c , startDate ,loanAccount.loan__Ach_frequency__c)+1;
                        //startDate = loan.DateUtil.getNextCycleDate(loanAccount.loan__Expected_Repayment_Start_Date__c,numberOfCycles,loanAccount.loan__Ach_frequency__c,null,null,1);
                    }else if(aps[0].loan__Frequency__c.equalsignorecase('Bi-weekly')){
                        Integer numberOfBiWeeks = 0;
                        if(lAcc[0].Payment_Holiday_Setup_Date__c >= ar.Repayment_Date__c){
                            numberOfBiWeeks = (lAcc[0].Payment_Holiday_Setup_Date__c.daysBetween(ar.Repayment_Date__c.addMonths((Integer)ar.Number_of_Payments__c)))/14;
                        }else{
                            numberOfBiWeeks = (ar.Repayment_Date__c.daysBetween(ar.Repayment_Date__c.addMonths((Integer)ar.Number_of_Payments__c)))/14;
                        }
                        
                        newDebitAmount = ar.Repayment_Amount__c/numberOfBiWeeks*ar.Number_of_Payments__c;
                        
                        
                        //numberOfCycles = loan.DateUtil.cyclesBetween(loanAccount.loan__Expected_Repayment_Start_Date__c , startDate ,loanAccount.loan__Ach_frequency__c)+1;
                        //startDate = loan.DateUtil.getNextCycleDate(loanAccount.loan__Expected_Repayment_Start_Date__c,numberOfCycles,loanAccount.loan__Ach_frequency__c,null,null,1);
                    }else if(aps[0].loan__Frequency__c.equalsignorecase('Monthly')){
                        newDebitAmount = ar.Repayment_Amount__c;
                        //numberOfCycles = loan.DateUtil.cyclesBetween(loanAccount.loan__Expected_Repayment_Start_Date__c , startDate ,loanAccount.loan__Ach_frequency__c)+1;
                        //startDate = loan.DateUtil.getNextCycleDate(loanAccount.loan__Expected_Repayment_Start_Date__c,numberOfCycles,loanAccount.loan__Ach_frequency__c,null,null,1);
                    }
                    
                    
                    
                    aps[0].loan__Transaction_Amount__c=newDebitAmount;
                    
                    
                }
                
            }
        }else{
            if(lAcc[0].Additional_Monthly_Debit_Amount__c==null){
                lAcc[0].Additional_Monthly_Debit_Amount__c = 0;
            }
            if(aps[0].loan__Frequency__c.equalsignorecase('Weekly')){
                aps[0].loan__Transaction_Amount__c = (lAcc[0].Additional_Monthly_Debit_Amount__c+lAcc[0].loan__Pmt_Amt_Cur__c)/4;
            }else if(aps[0].loan__Frequency__c.equalsignorecase('Bi-weekly')){
                aps[0].loan__Transaction_Amount__c = (lAcc[0].Additional_Monthly_Debit_Amount__c+lAcc[0].loan__Pmt_Amt_Cur__c)/2;
            }else{
                aps[0].loan__Transaction_Amount__c = (lAcc[0].Additional_Monthly_Debit_Amount__c+lAcc[0].loan__Pmt_Amt_Cur__c);
            }
            
        }
        
        update aps;
    }
    
    public List<loan__Automated_Payment_Setup__c> getAPSHistory(String loanAccountId,Boolean isActive){
        List<loan__Automated_Payment_Setup__c> aPSList = new List<loan__Automated_Payment_Setup__c>();
        
        apsList = [select id , Name, loan__Active__c,loan__Amount_Type__c,loan__Bank_Account__c,
                    loan__CL_Contract__c,loan__Debit_Date__c,loan__Frequency__c,loan__Payment_Mode__c,
                    loan__Recurring_ACH_End_Date__c,loan__Recurring_ACH_Start_Date__c,
                    loan__Transaction_Amount__c,loan__Type__c from loan__Automated_Payment_Setup__c
                    where loan__CL_Contract__c=: loanAccountId and loan__Active__c=:isActive order by loan__debit_date__c desc];
        return aPSList;
    }
   
   
   public  loan__Loan_Account__c updateLoanAccount(String loanId,Map<String,String> fieldMap){
       Map<String, Schema.SObjectField> fieldMapSchema = Schema.SObjectType.loan__Loan_Account__c.fields.getMap();
       loan__Loan_Account__c loanAcc = new loan__Loan_Account__c();
       if(loanId!=null && fieldMap!=null){
       
       
      
       loanAcc = [select id,name from loan__Loan_Account__c where id=:loanId];
       
       
       for (String fieldName : fieldMap.keySet()){
           //System.debug('fieldName.substring(0,7)'+fieldName.substring(0,7));
           String packageField = fieldName.substring(0,6);
           System.debug('packageField'+packageField);
           if(packageField.equalsIgnoreCase('loan__')){
           
           }else{
              Schema.DisplayType fieldDataType = fieldMapSchema.get(fieldName).getDescribe().getType();   
              //loanAcc.put(fieldName,fieldMap.get(fieldName));
              if(fieldDataType == Schema.DisplayType.currency ) {
                  
                  loanAcc.put(fieldName, decimal.valueOf(fieldMap.get(fieldName)));
                  
              }else if(fieldDataType == Schema.DisplayType.double ) {
                  
                  loanAcc.put(fieldName, decimal.valueOf(fieldMap.get(fieldName)));
                  
              }else if(fieldDataType == Schema.DisplayType.percent) {
              
                  loanAcc.put(fieldName, decimal.valueOf(fieldMap.get(fieldName)));
                    
              }else if(fieldDataType == Schema.DisplayType.date) {
                    
                  loanAcc.put(fieldName, date.parse(fieldMap.get(fieldName)));
                  
              }else if(fieldDataType == Schema.DisplayType.boolean) {
                    
                  loanAcc.put(fieldName, Boolean.valueOf(fieldMap.get(fieldName)));
                  
              }else if(fieldDataType == Schema.DisplayType.Integer) {
                    
                  loanAcc.put(fieldName, Integer.valueOf(fieldMap.get(fieldName)));
                    
              }else if(fieldDataType == Schema.DisplayType.DateTime) {
              
                  loanAcc.put(fieldName, dateTime.valueOf(fieldMap.get(fieldName)));
                  
              }else { 
                    
                  loanAcc.put(fieldName,string.valueof(fieldMap.get(fieldName)));
                                                                                            
               }
           }
        }
        try{
            update loanAcc;
        }catch(Exception e){
            
        }
           
       }
       return loanAcc;
           
           
       
   }
   
   public collect__Promise_To_Pay__c makePromiseToPay(String accountId,String apsId, Decimal promisedAmount, Date promisedDate){
       collect__Promise_To_Pay__c ptp = new collect__Promise_To_Pay__c();
       loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
       Date systemDate = util.getCurrentSystemDate();
       List<Account> accs = [select id from Account where id=:accountId];
       if(accs.size()==0){
           throw new MyException('No account found with given account Id.');
       }
       
       List<loan__Automated_Payment_Setup__c> aps = [select id from loan__Automated_Payment_Setup__c where Id =: apsId];
       if(aps.size()==0){
           throw new MyException('No Automated payment setup found for given id.');
       }
       ptp.collect__Account__c = accountId;
       ptp.Automated_Payment_Setup__c = apsId;
       ptp.collect__Promise_Made_On__c = systemDate;
       ptp.collect__Promise_To_Pay_Amount__c = promisedAmount;
       ptp.collect__Promise_To_Pay_Date__c = promisedDate;
       
       insert  ptp;
       return ptp;
   }
   
   public Boolean inPaymentHoliday(Id loanId){
       loan.globalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
       Date systemDate = util.getCurrentSystemDate();
       List<Automated_Repayment_Schedule__c> arSchedule = [select id,Repayment_Amount__c,Repayment_Date__c,Number_Of_Payments__c from Automated_Repayment_Schedule__c where Repayment_Amount__c=0 and CL_Contract__c=:loanId and is_primary__c=true];
       for(Automated_Repayment_Schedule__c ars:arSchedule){
           Date monthEndDate = ars.Repayment_Date__c.addMonths((Integer)ars.Number_of_Payments__c);
           if(systemDate>=ars.Repayment_Date__c && systemDate <= monthEndDate.addDays(-1)){
               return true;
           }
           if(systemDate<ars.Repayment_Date__c){
               return true;
           }
       }
       return false;
       
   }
   
   public Date getLastPaymentDate(Id loanId){
       loan__Loan_Account__c lAcc = [select id,loan__Next_Interest_Posting_Date__c from loan__Loan_Account__c
                                   where id=:loanId];
       List<loan__Automated_Payment_Setup__c> aps = [select id ,loan__frequency__c, loan__Debit_Date__C,loan__Recurring_ACH_End_Date__c,
                                                       loan__Recurring_ACH_Start_Date__c, loan__Type__c
                                                       from loan__Automated_payment_setup__c
                                                       where loan__CL_Contract__C=:loanId and loan__Type__c='RECURRING' and loan__Active__c=true];
       Date nextIPDate = lAcc.loan__Next_Interest_Posting_Date__c; 
       Date nextDate;                                              
       if(aps.size()>0){
           loan__Automated_Payment_Setup__c ap = aps[0];
           Date debitDate = ap.loan__Debit_Date__c;
           nextDate= debitDate;
           while(debitDate<nextIPDate){
               nextDate = debitDate;
               debitDate = loan.DateUtil.getNextCycleDate(debitDate,
                                            debitDate.day(),
                                            ap.loan__frequency__c,
                                            debitDate,
                                            null,
                                            1);   
           
           }
       }
       return nextDate;
   }
    
}
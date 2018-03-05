global class AffordabilityCalcCtrl{
    String appId;
    genesis__Applications__c app = new genesis__Applications__c();
    Affordability_Configuration__c affConfig = new Affordability_Configuration__c();
    public AffordabilityCalcCtrl(String appId){
        this.appId = appId;
        // assuming genesis__Term__c will be number of periods
        // assuming geneiss__Interest_Rate__c will be annual interest rate
        app = [select id,pepP1__c, pepP2__c, pepP3__c, pepP4__c,DTI__c,pepNavigation_Status__c,Automated_Payment_Start_Date__c,Estimated_Credit_Rating__c,Manual_Override__c,Rent_Expense_Monthly__c,genesis__Account__r.Relationship_Status__c,genesis__Account__r.Number_of_Dependants__c,genesis__Loan_Amount__c,Total_Monthly_Debt__c,genesis__Credit_Rating__c,genesis__Term__c,Total_Expense_and_Debt__c,Total_Monthly_Income__c,
                genesis__Interest_Rate__c,genesis__CL_Product__r.Interest_Type__c,DDP_Processed__c,Total_Monthly_Expense_Excluding_Mortg_f__c,genesis__Expected_Start_date__c,genesis__Expected_First_Payment_Date__c,Percentage_of_Expense_Contribution__c,Expense_Contribution__c,debit_frequency__c,Total_Monthly_Expense__c,Total_Monthly_Expense_Exc_Mortgage__c,Servicability_Value__c,genesis__Payment_Frequency__c,Affordability_Status__c,genesis__CL_Purpose__C from genesis__Applications__c where id=:appId limit 1];
        affConfig = [select Id,Min_Loan_Amount_Percent__c, Decrease_Loan_Amount_By__c  , DTI_Threshold__c,
                    Rate_Buffer__c,Revolving_Credit_Percent_As_Expense__c from Affordability_Configuration__c
                    where Active__c = true limit 1];
    }
    
    public genesis__Applications__c doAffordabilityCalc(){
        try{
            LoanActions act = new LoanActions();
            Decimal servicability = 0;
            loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
            Date systemDate = util.getCurrentSystemDate();
            List<clcommon__CL_Product__c> clProduct  = [select id,Name from clcommon__CL_product__c where Interest_Type__c=:app.genesis__CL_Product__r.Interest_Type__c and is_secured__c = false];
            Id previousProductId = app.genesis__CL_product__c;
            if(clProduct.size()>0){
                 app.genesis__CL_product__c = clProduct[0].id;
            }
            
    
            Decimal interestRate = CommonUtil.getInterestRate(app);
            System.debug('Interest Rate 0 :' + interestRate);
            app.genesis__CL_product__c = previousProductId;
            Decimal paymentAmount = act.calculateMonthlyPaymentAmount(app.genesis__Loan_Amount__c,interestRate,app.genesis__Term__c,app.id);
            Decimal expense = 0;
            List<HEM__c> hems = new List<HEM__c>();
            app.genesis__Expected_Start_date__c = systemDate;
            app.genesis__Expected_First_Payment_Date__c = systemDate.addMonths(1);
            update app;
            app = [select id,DTI__c,pepNavigation_Status__c,Current_Veda_Score__c,Automated_Payment_Start_Date__c, Recalculated_Total_Score__c ,Bureau_Recalculated_Score__c,Estimated_Credit_Rating__c,DDP_Processed__c,Manual_override__c,Rent_Expense_Monthly__c,genesis__Account__r.Relationship_Status__c,genesis__Account__r.Number_of_Dependants__c,genesis__Loan_Amount__c,Total_Monthly_Debt__c,genesis__Credit_Rating__c,genesis__Term__c,Total_Expense_and_Debt__c,Total_Monthly_Income__c,
                    genesis__Interest_Rate__c,genesis__CL_product__c,Total_Monthly_Expense_Excluding_Mortg_f__c,genesis__Expected_Start_date__c,Percentage_of_Expense_Contribution__c,Expense_Contribution__c,debit_frequency__c,Total_Monthly_Expense__c,Total_Monthly_Expense_Exc_Mortgage__c,Servicability_Value__c,genesis__Payment_Frequency__c,Affordability_Status__c,genesis__CL_Purpose__C from genesis__Applications__c where id=:appId limit 1];
            List<Income__c> rentalIncomes = [select id , Monthly_Income__c from Income__c where Type__c = 'Rental Income' and Application__c =: appId];  
            Decimal rentalIncome = 0;
            if(rentalIncomes.size()>0){
                rentalIncome = rentalIncomes[0].Monthly_Income__c;
            } 
            app.genesis__Status__c = '';
            app.Decline_Reason__c ='';
            app.Unsecured_interest_rate__c = interestRate;
            app.Unsecured_Payment_Amount__c = paymentAmount.setScale(2); 
            Boolean singleHem = false;
            if(app.genesis__Account__r.RelationShip_Status__c!=null){
                if(app.genesis__Account__r.RelationShip_Status__c.equalsIgnoreCase('Married') || app.genesis__Account__r.RelationShip_Status__c.equalsIgnoreCase('De Facto')){
                    if(app.Percentage_of_Expense_contribution__c>50){
                        hems = [select id,Value_Per_Adult__c,Value_Per_Dependant__c from HEM__c where Type__c='Couple'];
                    }else{
                        singleHem = true;
                    }  
                }else{
                    singleHem = true;
                }
            }else{
                singleHEM =true;
            }  
            if(singleHem){
                hems = [select id,Value_Per_Adult__c,Value_Per_Dependant__c from HEM__c where Type__c='Single'];
    
            } 
            List<Expense_and_Debt__c> revolvingCredit = [select id, Credit_Limit__c from Expense_and_Debt__c where   Is_Revolving_Credit__c = true and Application__c=:appId];
            Decimal revolvingCreditAmount = 0;
            if(revolvingCredit.size()>0){
                for(Expense_and_Debt__c ed:revolvingCredit){
                    if(ed.Credit_limit__C!=null){
                        revolvingCreditAmount += ed.Credit_Limit__c;
                    }
                }
            }
            if(revolvingCreditAmount>0){
                revolvingCreditAmount = affConfig.Revolving_Credit_Percent_As_Expense__c*revolvingCreditAmount;
            }
            Decimal expExcludingMortgage = 0;
            Decimal dti = 0;
            Decimal hemExpenseValue = 0;
            
            Decimal totalDependantExpense =0;
            if(hems.size()>0){
                if(hems[0].Value_Per_Dependant__c!=null && app.genesis__Account__r.Number_of_Dependants__c!=null){
                    totalDependantExpense = hems[0].Value_Per_Dependant__c *app.genesis__Account__r.Number_of_Dependants__c;
                } 
                if(hems[0].Value_per_Adult__c!=null){
                    hemExpenseValue = totalDependantExpense + hems[0].Value_Per_Adult__c;
                }   
                
            }
            
            List<Expense_and_Debt__c> expensesExcludingMortgage  = [select Id ,Monthly_Expense__c from Expense_and_Debt__c where Type_of_Expense_Debt__c!='Rent or mortgage repayments' and Type__c!='Debt' and Application__c=:app.id];
            system.debug('exp--:'+ expensesExcludingMortgage);
            if(expensesExcludingMortgage.size()>0){
                for(Expense_and_Debt__c exp:expensesExcludingMortgage){
                    if(exp.Monthly_Expense__c!=null){
                         expExcludingMortgage+=exp.Monthly_Expense__C;
                    }
                   
                }
                
                if(app.Percentage_of_Expense_Contribution__c<50){
                    expExcludingMortgage = 0.5 * expExcludingMortgage;
                }
            }
            
            if(expExcludingMortgage!=null){
                expense = Math.max( hemExpenseValue, expExcludingMortgage);
            }else{
                expense = hemExpenseValue;
            }
            
            
            servicability = app.Total_Monthly_income__c-(0.2*rentalIncome)-app.Total_Monthly_Debt__c - expense - app.Rent_Expense_Monthly__c -revolvingCreditAmount-paymentAmount;
            app.Servicability_Value__c = servicability;
                
            
            
            /*if( servicability<affConfig.Rate_Buffer__c){
                expExcludingMortgage = Math.max(app.Percentage_of_Expense_contribution__c,50)*app.Total_Monthly_Expense_Exc_Mortgage__c;
                if(expExcludingMortgage!=null){
                    expense = Math.max( hemExpenseValue, expExcludingMortgage);
                }else{
                    expense = hemExpenseValue;
                }
                dti = (app.Total_Monthly_Debt__c+paymentAmount)/(app.Total_Monthly_Income__c - expense - revolvingCreditAmount - (app.Rent_Expense_Monthly__c*Math.max(app.Percentage_of_Expense_contribution__c,50)));
                app.DTI__c = dti;
                if(dti>affConfig.DTI_Threshold__c){
                    servicability = 0;
                    //app.Servicability_Value__c = servicability;
                }else{
                    servicability = app.Total_Monthly_income__c-(0.2*rentalIncome)-app.Total_Monthly_Debt__c - expense - (Math.max(app.Percentage_of_Expense_contribution__c,50)*app.Rent_Expense_Monthly__c) -revolvingCreditAmount-paymentAmount;
                    //app.Servicability_Value__c = servicability;
                    
                }
            }*/
            String rateCardType = '';
            if(app.pepNavigation_Status__c!=null && app.pepNavigation_Status__c.equalsIgnoreCase('Expense')){
                system.debug(servicability);
                if(servicability>=affConfig.Rate_Buffer__c){
                    app.Affordability_Status__c = 'Yes';
                }else if(servicability<affConfig.Rate_Buffer__c){
                    app.Affordability_Status__c = 'Maybe';
                }
                system.debug(app.Affordability_Status__c);
                app.genesis__Status__c = 'AWAITING PERSONAL INFORMATION';
                rateCardType = 'Pre Credit Check';
            }else{
                if(servicability>=affConfig.Rate_Buffer__c){
                    app.Post_Creditcheck_Affordability_Status__c = 'Yes';
                    app.genesis__Status__c = 'CONDITIONALLY APPROVED';
                    app.Serviceability_Status__c = 'Approved';
                }else if(servicability>0 && servicability<affConfig.Rate_Buffer__c){
                    app.Post_Creditcheck_Affordability_Status__c = 'Maybe';
                    
                }
                rateCardType = 'Post Credit Check';
                
                
                
            }
            
            app.genesis__Payment_Amount__c = paymentAmount;
            
            app.genesis__Expected_Start_date__c = systemDate;
            /*Id creditRatingId;
            if(!String.isBlank(app.Estimated_Credit_Rating__c)){
                creditRatingId = app.Estimated_Credit_Rating__c;
            }else{
                creditRatingId = app.genesis__Credit_Rating__c;
            }*/
            
            List<CL_Product_Purpose_Junction__c> productPurposeJnc = [select id,Max_Loan_Amount_Delta__c,Max_Term_Delta__c,
                                                                        Min_Loan_Amount_Delta__c,Min_Term_Delta__c
                                                                        from CL_Product_Purpose_Junction__c 
                                                                        where CL_Product__c=:app.genesis__CL_product__c
                                                                        and CL_Purpose__c=:app.genesis__Cl_Purpose__c];
            Decimal maxLoanAmountDelta=0;
            Decimal minLoanAmountDelta=0;
            Decimal maxTermDelta=0;
            Decimal minTermDelta=0;
            Decimal loanAmountAdjustedMaxLimit= 0;
            Decimal loanAmountAdjustedMinLimit = 0;
            Decimal termAdjustedMaxLimit = 0;
            Decimal termAdjustedMinLimit = 0;
            if(productPurposeJnc.size()>0){
                if(productPurposeJnc[0].Max_Loan_Amount_Delta__c!=null){
                    maxLoanAmountDelta = productPurposeJnc[0].Max_Loan_Amount_Delta__c;
                }
                if(productPurposejnc[0].Min_Loan_Amount_Delta__c!=null){
                    minLoanAmountDelta = productPurposejnc[0].Min_Loan_Amount_Delta__c;
                }
                if(productPurposeJnc[0].Max_Term_Delta__c!=null){
                    maxtermDelta = productPurposeJnc[0].Max_Term_Delta__c;
                }
                if(productPurposeJnc[0].Min_Term_Delta__c!=null){
                    minTermDelta = productPurposeJnc[0].Min_Term_Delta__c;
                }
                
            }
            //As productPurposeJnc[0].Max_Loan_Amount_Delta__c is -ve.
            loanAmountAdjustedMaxLimit = app.genesis__Loan_Amount__c-maxLoanAmountDelta;
            loanAmountAdjustedMinLimit = app.genesis__Loan_Amount__c-minLoanAmountDelta;
            termAdjustedMaxLimit  = app.genesis__Term__c - maxtermDelta;
            termAdjustedMinLimit  = app.genesis__Term__c - minTermDelta;
            
            List<genesis__Rate_Card_Setup_Detail__c> rateCard = [select id,genesis__Payment_Frequency__c,
                                    genesis__Credit_Rating__c,genesis__Enabled_Flag__c,genesis__Interest_Rate__c,
                                    genesis__Maximum_Financed_Amount__c,genesis__Max_Term__c,genesis__Minimum_Financed_Amount__c,
                                    genesis__Min_Term__c,genesis__Rate_Card_Setup_Header__r.CL_Purpose__c,
                                    genesis__Rate_Card_Setup_Header__r.genesis__Enabled_Flag__c,
                                    genesis__Rate_Card_Setup_Header__r.genesis__End_Date__c,genesis__Rate_Card_Setup_Header__r.genesis__Start_Date__c,
                                    genesis__Rate_Card_Setup_Header__r.Type__c from genesis__Rate_Card_Setup_Detail__c where genesis__Credit_Rating__c=:app.genesis__Credit_Rating__c and
                                    genesis__Enabled_Flag__c = true  and
                                    genesis__Maximum_Financed_Amount__c >=: loanAmountAdjustedMaxLimit and genesis__Minimum_Financed_Amount__c <=: loanAmountAdjustedMinLimit and
                                    genesis__Min_Term__c <=: termAdjustedMaxLimit and genesis__Max_Term__c >=: termAdjustedMinLimit and 
                                    genesis__Rate_Card_Setup_Header__r.CL_Purpose__c=:app.genesis__CL_Purpose__c and 
                                    genesis__Rate_Card_Setup_Header__r.genesis__Enabled_Flag__c = true and 
                                    genesis__Rate_Card_Setup_Header__r.genesis__End_Date__c >=: systemDate and 
                                    genesis__Rate_Card_Setup_Header__r.genesis__Start_Date__c <=: systemDate 
                                    and genesis__Rate_Card_Setup_Header__r.Type__c=:rateCardType limit 1];
            system.debug(app.Recalculated_Total_Score__c);
            
            try{
                List<Score_Status_Configuration__c> ssc = [select id, Reason__c,Status__c from score_Status_Configuration__c where Minimum_Score__c<=:app.Recalculated_Total_Score__c and Maximum_Score__c>=:app.Recalculated_Total_Score__c];
                if(ssc.size()>0 && !app.pepNavigation_Status__c.equalsIgnoreCase('Expense')){
                    if(ssc[0].Status__c!=null){
                        app.genesis__Status__c = ssc[0].Status__c;
                        if((!String.isBlank(ssc[0].Reason__c)) && (ssc[0].Status__c == 'DECLINED')){
                           if(app.Current_Veda_Score__c!=null){
                               app.Decline_Reason__c = ssc[0].Reason__c;
                               app.Post_Creditcheck_Affordability_Status__c = 'No';
                               app.Serviceability_Status__c = 'Declined';
                           }else{
                               app.Referred_Reason__c = ssc[0].Reason__c;
                               app.Serviceability_Status__c = 'Referred';
                               app.genesis__Status__c = 'REFERRED';
                           }
                           
                        }
                        if((!String.isBlank(ssc[0].Reason__c)) && (ssc[0].Status__c == 'REFERRED')){
                           app.Referred_Reason__c = ssc[0].Reason__c;
                           app.Serviceability_Status__c = 'Referred';
                        }
                    }
                    
                }
            }
            catch(Exception e){
                mfiflexUtil.VOLog voLogInstance = mfiflexUtil.VOLog.getInstance('Genesis');
                voLogInstance.logError(9001, '[AffordabilityCalcCtrl Internal] Exception : ' + e + ', for app : ' + app + ', stacktrace : ' + e.getStackTraceString());
                voLogInstance.committodb();
            }
            
            if(app.Post_Creditcheck_Affordability_Status__c=='Yes' && servicability>=affConfig.Rate_Buffer__c && app.Manual_Override__c==false && (app.genesis__Status__c!='DECLINED') && (app.genesis__Status__c!='REFERRED')){
                if(rateCard.size()==0){
                    app.genesis__Status__C = 'REFERRED';
                    app.Serviceability_Status__c = 'Referred';
                    app.Referred_Reason__c = 'RATE CARD NOT FOUND';
                }
                
            }
            
            
            
            system.debug(app.genesis__Status__c);
            Boolean isServicable = false;
            if((app.Affordability_Status__c!='Yes' || app.Post_Creditcheck_Affordability_Status__c!='Yes') && servicability<affConfig.Rate_Buffer__c && app.DDP_Processed__c==false && (app.genesis__Status__c!='DECLINED') && (app.genesis__Status__c!='REFERRED')){
                //query rate card detail for purpose,credit rating matrix and amount falling in that range.
                
                system.debug(rateCard);
                if(rateCard.size()==1){
                    Decimal nextTerm = app.genesis__Term__c;
                    Decimal previousTerm =0;
                    Decimal revisedMaxLimit = rateCard[0].genesis__Max_term__c - maxtermDelta;
                    while (nextTerm<= revisedMaxLimit && !isServicable){
                        system.debug(LoggingLevel.error,'nextTerm'+ nextTerm);
                        system.debug(LoggingLevel.error,termAdjustedMaxLimit);
                        System.debug('Interest Rate 1: ' + interestRate);
                        paymentAmount = act.calculateMonthlyPaymentAmount(app.genesis__Loan_Amount__c,interestRate,nextTerm,app.id);
                        servicability = app.Total_Monthly_income__c-(0.2*rentalIncome)-app.Total_Monthly_Debt__c - expense - app.Rent_Expense_Monthly__c - revolvingCreditAmount - paymentAmount;
                        //app.Servicability_Value__c = servicability;
                        dti = (app.Total_Monthly_Debt__c+paymentAmount + revolvingCreditAmount)/(app.Total_Monthly_Income__c - (0.2*rentalIncome) - expense - app.Rent_Expense_Monthly__c);
                        app.DTI__c = dti;
                        if(servicability>=affConfig.Rate_Buffer__c && dti<=affConfig.DTI_Threshold__c){
                            isServicable = true;
                            //app.genesis__Payment_Amount__c = paymentAmount;
                            app.genesis__Term__c = nextTerm;
                        }
                        previousTerm  = nextTerm;
                        nextTerm = getNextTermMovedByAYear(nextTerm,app.genesis__Payment_Frequency__c);
                    }
                    system.debug(LoggingLevel.error,'prevTerm'+ previousTerm);
                    Decimal nextLoanAmount = app.genesis__Loan_Amount__c;
                    Decimal revisedMinLoanAmountLimit = rateCard[0].genesis__Minimum_Financed_Amount__c + minLoanAmountDelta;
                    Decimal minLoanAmount = Math.max(revisedMinLoanAmountLimit, affConfig.Min_Loan_Amount_Percent__c * app.genesis__Loan_Amount__c);
                    while(nextLoanAmount>=minLoanAmount && !isServicable){
                        System.debug('Interest Rate 2 : ' + interestRate);
                        paymentAmount = act.calculateMonthlyPaymentAmount(nextLoanAmount,interestRate,previousTerm,app.id);
                        servicability = app.Total_Monthly_income__c-(0.2*rentalIncome)-app.Total_Monthly_Debt__c - expense - app.Rent_Expense_Monthly__c -revolvingCreditAmount-paymentAmount;
                        //app.Servicability_Value__c = servicability;
                        dti = (app.Total_Monthly_Debt__c+paymentAmount + revolvingCreditAmount)/(app.Total_Monthly_Income__c-(0.2*rentalIncome) - expense  - app.Rent_Expense_Monthly__c);
                        app.DTI__c = dti;
                        if(servicability>=affConfig.Rate_Buffer__c && dti<=affConfig.DTI_Threshold__c){
                            isServicable = true;
                            //app.genesis__Payment_Amount__c = paymentAmount;
                            app.genesis__Loan_Amount__c = nextLoanAmount;
                            app.genesis__Term__c = previousTerm;
                        }
                        nextLoanAmount = nextLoanAmount - affConfig.Decrease_Loan_Amount_By__c;
                    }
                }else{
                    //throw new MyException('No rate card found.');
                    system.debug('No rate card found.');
                    app.Serviceability_Status__c = 'Referred';
                    app.genesis__Status__c = 'REFERRED';
                    app.Referred_Reason__c = 'RATE CARD NOT FOUND';
                    
                }
            }
            dti = (app.Total_Monthly_Debt__c+paymentAmount + revolvingCreditAmount)/(app.Total_Monthly_Income__c-(0.2*rentalIncome) - expense  - app.Rent_Expense_Monthly__c);
            app.DTI__c = dti;
            paymentAmount = act.calculateMonthlyPaymentAmount(app.genesis__Loan_Amount__c,app.genesis__Interest_Rate__c,app.genesis__Term__c,app.id);
            app.genesis__Payment_Amount__c = paymentAmount;
            if(!(app.genesis__Status__c=='DECLINED') || !(app.genesis__Status__c=='REFERRED')){
                if(app.pepNavigation_Status__c!=null && app.pepNavigation_Status__c.equalsIgnoreCase('Expense') ){
                    if(servicability<affConfig.Rate_Buffer__c){
                        app.Affordability_Status__c = 'No';
                        app.genesis__Status__c = 'DECLINED';
                        app.Serviceability_Status__c = 'Declined';
                        app.Decline_Reason__c = 'NONSERVICEABLE';
                    }
                    
                    if(dti>affConfig.DTI_Threshold__c){
                        app.Affordability_Status__c = 'No';
                        app.genesis__Status__c = 'DECLINED';
                        app.Serviceability_Status__c = 'Declined';
                        app.Decline_Reason__c = 'NONSERVICEABLE';
                    }
                }else{
                    if(dti>affConfig.DTI_Threshold__c){
                        app.Post_Creditcheck_Affordability_Status__c = 'No';
                        app.genesis__Status__C = 'DECLINED';
                        app.Serviceability_Status__c = 'Declined';
                        app.Decline_Reason__c = 'NONSERVICEABLE';
                    }
                    if(servicability<affConfig.Rate_Buffer__c){
                        app.Post_Creditcheck_Affordability_Status__c = 'No';
                        app.genesis__Status__C = 'DECLINED';
                        app.Serviceability_Status__c = 'Declined';
                        app.Decline_Reason__c = 'NONSERVICEABLE';
                    }
                    if(isServicable){
                        app.genesis__Status__c = 'CONDITIONALLY APPROVED';
                        app.Serviceability_Status__c = 'Approved';
                    }
                }
        
            }
            
            
            if(app.Estimated_Credit_Rating__c==null){
                app.Estimated_Credit_Rating__c = app.genesis__Credit_Rating__c;
            }
            
            if(app.pepNavigation_Status__c!=null && app.pepNavigation_Status__c.equalsIgnoreCase('Expense')){
                app.Servicability_Value__c = servicability;
            }else{
                app.Post_Credit_Check_Serviceability_Value__c = servicability;
            }
            
            //app.Automated_Payment_Start_Date__c = util.getCurrentSystemDate().addMonths(1);
            system.debug(app.Affordability_Status__c );
            update app;
            genesis.SkuidNewApplication.generateSchedule(app.id);
            genesis__Applications__c appl = [select id, genesis__Payment_Amount__c,genesis__Expected_Start_date__c,debit_frequency__c,debit_amount__c,Unsecured_Payment_Amount__c  from genesis__Applications__c where Id = :app.Id];
            paymentAmount = appl.genesis__Payment_Amount__c;
            Decimal debitAmount = paymentAmount.setScale(2);
            System.debug(LoggingLevel.Error,'freq:' + appl.debit_frequency__c);
            Date debitDate;
            System.debug(app.Automated_Payment_Start_Date__c);
            if(app.Automated_Payment_Start_Date__c!=null){
                debitDate = app.Automated_Payment_Start_Date__c;
                system.debug(debitDate);
            }else{
                debitDate = systemDate;
            }
            if(debitDate<=systemDate){
                while(debitDate<=systemDate){
                    if(appl.debit_frequency__c.equalsIgnoreCase('WEEKLY')){
                        debitDate = loan.DateUtil.getNextCycleDate(debitDate,
                                            debitDate.day(),
                                            loan.LoanConstants.LOAN_PAYMENT_FREQ_WEEKLY,
                                            debitDate,
                                            null,
                                            1);
                    }else if(appl.debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
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
            System.debug(debitDate);
              if(appl.debit_frequency__c!=null && appl.debit_frequency__c.equalsIgnoreCase('WEEKLY')){
                //debitAmount = paymentAmount*12/52;
                debitAmount = paymentAmount / 4;
                appl.Unsecured_Payment_Amount__c = appl.Unsecured_Payment_Amount__c/4;
                //System.debug(debitAmount);
                //System.debug(appl.debit_frequency__c);
                //app.Automated_Payment_Start_Date__c = systemDate.addDays(7);
            }else if(appl.debit_frequency__c!=null && appl.debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
                System.debug(debitAmount);
                System.debug(appl.debit_frequency__c);
                //debitAmount = paymentAmount *12/26 ;
                debitAmount = paymentAmount/2;
                appl.Unsecured_Payment_Amount__c = appl.Unsecured_Payment_Amount__c/2;
                //appl.Automated_Payment_Start_Date__c = systemDate.addDays(14);
            }
            
            appl.Automated_Payment_Start_Date__c = debitDate;
            appl.Debit_Amount__c = debitAmount.setScale(2);
            update appl;
        
        
            genesis__Application_Pricing_Detail__c pricingOption = new genesis__Application_Pricing_Detail__c();
                
            pricingOption.genesis__Credit_Rating__c = app.genesis__Credit_Rating__c;
            //pricingOption.Days_Convention__c  =  rateCardDetail.Days_Convention__c;
            pricingOption.genesis__Payment_Amount_Per_Period__c  =  paymentAmount.setScale(2);
            pricingOption.genesis__Total_Payments_Derived__c  = pricingOption.genesis__Payment_Amount_Per_Period__c * app.genesis__Term__c;
            pricingOption.genesis__Payment_Frequency__c  =  app.genesis__Payment_Frequency__c;
            pricingOption.genesis__Term__c  =  app.genesis__Term__c;
            pricingOption.genesis__Interest_Rate__c = app.genesis__Interest_Rate__c;
            pricingOption.genesis__application__c  =  app.id; 
            pricingOption.genesis__Maximum_Financed_Amount__c  =  app.genesis__Loan_Amount__c;        
            
            insert pricingOption;
        }catch(Exception e){
             mfiflexUtil.VOLog voLogInstance = mfiflexUtil.VOLog.getInstance('Genesis');
             voLogInstance.logError(9001, '[AffordabilityCalcCtrl Overall] Exception : ' + e + ', for app : ' + app + ', stacktrace : ' + e.getStackTraceString());
             voLogInstance.committodb();
        }
        
        return app;
    }
    
    public Decimal getNextTermMovedByAYear(Decimal currentTerm,String frequency){
        Decimal term = 0;
        if(frequency != null && currentTerm!= null){
            if(frequency.equalsIgnoreCase('Daily')){               
                if(Math.mod(Date.today().year(),4)==0){
                    term = currentTerm + 366;
                }else{
                    term = currentTerm + 365;
                }
                
            } 
            if(frequency.equalsIgnoreCase('Quarterly')){      
                term   = currentTerm +4;
            } 
            if(frequency.equalsIgnoreCase('Monthly')){              
                term  = currentTerm+12;
            }
            if(frequency.equalsIgnoreCase('Weekly')){
                term = currentTerm +52;
            }       
            if(frequency.equalsIgnoreCase('Fortnightly')||frequency.equalsIgnoreCase('Bi-Weekly')){              
                term = currentTerm + 26;
            }
            if(frequency.equalsIgnoreCase('Annually')){              
                term = currentTerm +1;
            }   
        }
        return term;
    }
    
    public Decimal calculateMonthlyPaymentAmount(Decimal paymentAmount, String frequency){
        Decimal monthlyPmt = 0;
        if(frequency != null && paymentAmount!= null){
            if(frequency.equalsIgnoreCase('Daily')){               
                monthlyPmt  = paymentAmount*30.4167;
            } 
            if(frequency.equalsIgnoreCase('Quarterly')){      
                monthlyPmt   = paymentAmount/3;
            } 
            if(frequency.equalsIgnoreCase('Monthly')){              
                monthlyPmt = paymentAmount;
            }
            if(frequency.equalsIgnoreCase('Weekly')){
                //monthlyPmt = paymentAmount *4.33;
                monthlyPmt = paymentAmount *4;
            }       
            if(frequency.equalsIgnoreCase('Fortnightly')||frequency.equalsIgnoreCase('Bi-Weekly')){              
                //monthlyPmt  = paymentAmount*2.17;
                monthlyPmt  = paymentAmount*2;
            }
            if(frequency.equalsIgnoreCase('Annually')){              
                monthlyPmt  = paymentAmount/12;
            }   
        }
        return monthlyPmt;
    }
    
    public Decimal calculatePaymentAmount(Decimal loanAmount,Decimal rate, Decimal term, String frequency){
        Decimal intRate = calculateIntRateBasedOnPaymentFrequency(rate,frequency);
        Decimal paymentAmount = 0;
        if(loanAmount != null && intRate != null && term!=null)
        {
            paymentAmount  = (loanAmount*intRate*Math.pow(Double.valueOf((1+intRate)),Double.valueOf(term)))/(Math.pow(Double.valueOf(1+intRate),Double.valueOf(term))-1);
        }
        //Decimal term = convertTermToMonthlyPeriods(app.genesis__Term__c,app.genesis__Payment_Frequency__c);
        //Decimal paymentAmount = (app.genesis__Loan_Amount__c * (app.Monthly_Interest_Rate__c))/(1-Math.pow(Double.valueOf(1+(app.Monthly_Interest_rate__c)),Double.valueOf(-1*term)));
        
        //Decimal paymentAmount = app.Monthly_Interest_Rate__c / (Math.pow(Double.valueOf(1 + app.Monthly_interest_Rate__c), Double.valueOf(term)) - 1)* -(app.genesis__Loan_Amount__c * Math.pow(Double.valueOf(1 + app.Monthly_interest_Rate__c), Double.valueOf(term)));
        return paymentAmount;
    }
    
    Public Decimal calculateIntRateBasedOnPaymentFrequency(Decimal intRate,String frequency){
        Decimal intRateforPeriod;
        if(frequency != null && intRate!= null){
            if(frequency.equalsIgnoreCase('Daily')){               
                intRateforPeriod  = intRate/(365*100);
            } 
            if(frequency.equalsIgnoreCase('Quarterly')){      
                intRateForPeriod   = intRate/(4*100);
            } 
            if(frequency.equalsIgnoreCase('Monthly')){              
                intRateForPeriod  = intRate/(12*100);
            }
            if(frequency.equalsIgnoreCase('Weekly')){
                intRateForPeriod  = intRate/(52*100);
            }       
            if(frequency.equalsIgnoreCase('Fortnightly')||frequency.equalsIgnoreCase('Bi-Weekly')){              
                intRateForPeriod  = intRate/(26.07143*100);
            }
            if(frequency.equalsIgnoreCase('Annually')){              
                intRateForPeriod  = intRate/(1*100);
            }   
        }
        return intRateForPeriod;
    }
    
     webservice static String webServiceAffordability(String appId){
         
         AffordabilityCalcCtrl affrdCtrl = new AffordabilityCalcCtrl(appId);
         try{
             affrdCtrl.doAffordabilityCalc();
         }catch(Exception e){
             system.debug(LoggingLevel.error,e.getMessage() + e.getStackTraceString() + e.getLineNumber());
             return 'Affordability calculation has failed';
         }
         
         return 'Affordability calculation completed';
     
     }
    /*public Decimal convertTermToMonthlyPeriods(decimal term,String frequency){
        //changing term to monthly periods
        Decimal monthlyTerm = 0;
        if(frequency.equalsIgnoreCase('monthly')){
           monthlyTerm = term ;         
        }
        if(frequency.equalsIgnoreCase('Weekly')){
           monthlyTerm = term*52/12;
        }
        if(frequency.equalsIgnoreCase('Bi-Weekly')||frequency.equalsIgnoreCase('fortnightly')){
           monthlyTerm = term*26/12;
        }
        if(frequency.equalsIgnoreCase('Quarterly')){
            monthlyTerm = term*3;
        }
        
        return monthlyTerm;
    }*/
    
    public Decimal calculateServiceability(Decimal totalMonthlyDebt,Decimal paymentAmount,Decimal totalMonthlyIncome, Decimal expense,Decimal monthlyRentExpense,Decimal revolvingCreditAmount){
        Decimal serviceabilityValue = 0;
        serviceabilityValue = totalMonthlyIncome - paymentAmount - totalMonthlyDebt - expense - monthlyRentExpense - revolvingCreditAmount;
        return serviceabilityValue;
    }
    
    
    @InvocableMethod
    public static List<Boolean> postPricingAffordabilityCheck(List<Id> applicationIds){
        
         AffordabilityCalcCtrl affrdCtrl = new AffordabilityCalcCtrl(applicationIds[0]);
         try{
             affrdCtrl.doAffordabilityCalc();
         }catch(Exception e){
             system.debug(LoggingLevel.error,e.getMessage());
         }
        
        List<boolean> retVal = new List<boolean>();
            retVal.add(true);
            return retVal;
            
    }
}
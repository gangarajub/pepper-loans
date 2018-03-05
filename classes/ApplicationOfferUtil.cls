public class ApplicationOfferUtil{
    // As part of the API,
    //Loan amount will be decreased to reach LVR threshold
    //Payment amount and repayment amount is updated
    public genesis__Application_Pricing_Detail__c getSecuredOffer(String appId, Boolean applyOffer){
        List<genesis__Applications__c> app = [select id,DTI__c,genesis__Status__c,pepNavigation_Status__c,Current_Veda_Score__c,Automated_Payment_Start_Date__c, Recalculated_Total_Score__c ,Bureau_Recalculated_Score__c,Estimated_Credit_Rating__c,DDP_Processed__c,Manual_override__c,Rent_Expense_Monthly__c,genesis__Account__r.Relationship_Status__c,genesis__Account__r.Number_of_Dependants__c,genesis__Loan_Amount__c,Total_Monthly_Debt__c,genesis__Credit_Rating__c,genesis__Term__c,Total_Expense_and_Debt__c,Total_Monthly_Income__c,
                genesis__Interest_Rate__c,Unsecured_Interest_Rate__c,Unsecured_Payment_Amount__c,genesis__CL_product__c,Total_Monthly_Expense_Excluding_Mortg_f__c,genesis__Expected_Start_date__c,Percentage_of_Expense_Contribution__c,Expense_Contribution__c,debit_frequency__c,Total_Monthly_Expense__c,Total_Monthly_Expense_Exc_Mortgage__c,Servicability_Value__c,genesis__Payment_Frequency__c,Affordability_Status__c,genesis__CL_Purpose__C from 
                                            genesis__Applications__c where Id=:appId];
        genesis__Application_Pricing_Detail__c pricingDetail = new genesis__Application_Pricing_Detail__c();
        pricingDetail.Type__c = 'SECURED';
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate = util.getCurrentSystemDate();
        Decimal lvrThreshold = genesis.CustomSettingsUtil.getOrgParameters().LVR_Percent_Threshold__c;
        Integer maxVehicleAge = (Integer)genesis.CustomSettingsUtil.getOrgParameters().Max_Vehicle_Age__c;
        Integer currentyear = systemDate.year();
        
        List<clcommon__Collateral_Valuation__c> valuation = [select id, clcommon__Appraised_Value__c from clcommon__Collateral_Valuation__c where clcommon__Collateral__r.Active__c = true and clcommon__Collateral__r.genesis__Application__c =:appId order by createddate desc limit 1];
        List<clcommon__Collateral__c> collateral = [select id,clcommon__Year__c from clcommon__Collateral__c where genesis__Application__c=:app[0].id and active__c = true];
        Decimal desiredLoanAmount = Math.min(lvrThreshold * valuation[0].clcommon__Appraised_value__c/100,app[0].genesis__Loan_Amount__c);
        Integer vehicleYear = Integer.valueOf(collateral[0].clcommon__year__c);
        Integer currentAge = currentYear - vehicleYear;
        Integer remainingAge = (maxVehicleAge - currentAge)*12;
        
        List<CL_Product_Purpose_Junction__c> productPurposeJnc = [select id,Max_Loan_Amount_Delta__c,Max_Term_Delta__c,
                                                                    Min_Loan_Amount_Delta__c,Min_Term_Delta__c
                                                                    from CL_Product_Purpose_Junction__c 
                                                                    where CL_Product__c=:app[0].genesis__CL_product__c
                                                                    and CL_Purpose__c=:app[0].genesis__Cl_Purpose__c];
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
        loanAmountAdjustedMaxLimit = desiredLoanAmount-maxLoanAmountDelta;
        loanAmountAdjustedMinLimit = desiredLoanAmount-minLoanAmountDelta;
        termAdjustedMaxLimit  = app[0].genesis__Term__c - maxtermDelta;
        termAdjustedMinLimit  = app[0].genesis__Term__c - minTermDelta;
        String rateCardType = 'Post Credit Check';
        List<genesis__Rate_Card_Setup_Detail__c> rateCard = [select id,genesis__Payment_Frequency__c,
                                genesis__Credit_Rating__c,genesis__Enabled_Flag__c,genesis__Interest_Rate__c,
                                genesis__Maximum_Financed_Amount__c,genesis__Max_Term__c,genesis__Minimum_Financed_Amount__c,
                                genesis__Min_Term__c,genesis__Rate_Card_Setup_Header__r.CL_Purpose__c,
                                genesis__Rate_Card_Setup_Header__r.genesis__Enabled_Flag__c,
                                genesis__Rate_Card_Setup_Header__r.genesis__End_Date__c,genesis__Rate_Card_Setup_Header__r.genesis__Start_Date__c,
                                genesis__Rate_Card_Setup_Header__r.Type__c from genesis__Rate_Card_Setup_Detail__c where genesis__Credit_Rating__c=:app[0].genesis__Credit_Rating__c and
                                genesis__Enabled_Flag__c = true  and
                                genesis__Maximum_Financed_Amount__c >=: loanAmountAdjustedMaxLimit and genesis__Minimum_Financed_Amount__c <=: loanAmountAdjustedMinLimit and
                                genesis__Min_Term__c <=: termAdjustedMaxLimit and genesis__Max_Term__c >=: termAdjustedMinLimit and 
                                genesis__Rate_Card_Setup_Header__r.CL_Purpose__c=:app[0].genesis__CL_Purpose__c and 
                                genesis__Rate_Card_Setup_Header__r.genesis__Enabled_Flag__c = true and 
                                genesis__Rate_Card_Setup_Header__r.genesis__End_Date__c >=: systemDate and 
                                genesis__Rate_Card_Setup_Header__r.genesis__Start_Date__c <=: systemDate 
                                and genesis__Rate_Card_Setup_Header__r.Type__c=:rateCardType limit 1];
        Boolean validTerm  = true;
        if(app[0].genesis__Term__c>remainingAge){
            validterm = false;
        }
        if(rateCard.size()>0 && validTerm){
            pricingDetail.genesis__Credit_Rating__c = app[0].genesis__Credit_Rating__c;
            //pricingOption.Days_Convention__c  =  rateCardDetail.Days_Convention__c;
            LoanActions act = new LoanActions();
            Decimal paymentAmount = 0;
            Decimal debitAmount = 0;
            if(applyOffer){
                try{
                    app[0].genesis__Loan_Amount__c = desiredLoanAmount;
                    app[0].Unsecured_Payment_Amount__c = act.calculateMonthlyPaymentAmount(desiredLoanAmount,app[0].Unsecured_Interest_Rate__c,app[0].genesis__Term__c,app[0].id);
                    update app[0];
                    genesis.SkuidNewApplication.generateSchedule(app[0].id);
                    app = [select id,genesis__Loan_Amount__c, genesis__Payment_Amount__c,automated_Payment_Start_Date__c,genesis__Interest_Rate__c,genesis__Payment_Frequency__c,genesis__Term__c,genesis__Expected_Start_date__c,debit_frequency__c,debit_amount__c from genesis__Applications__c where Id = :app[0].Id];
                    paymentAmount = app[0].genesis__Payment_Amount__c;
                }catch(Exception e){
                    pricingDetail.message__c = 'OFFER NOT APPLIED';
                }
                
            }else{
                paymentAmount = act.calculateMonthlyPaymentAmount(desiredLoanAmount,app[0].genesis__interest_rate__c,app[0].genesis__Term__c,appid);
            }
            
            if(app[0].debit_frequency__c!=null && app[0].debit_frequency__c.equalsIgnoreCase('WEEKLY')){
            
                debitAmount = paymentAmount / 4;
            
            }else if(app[0].debit_frequency__c!=null && app[0].debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
                
                debitAmount = paymentAmount/2;
                
            }else{
                debitAmount  = paymentAmount;
            }
            pricingDetail.genesis__Payment_Amount_Per_Period__c  =  paymentAmount.setScale(2);
            pricingDetail.debit_Amount__c = debitAmount.setScale(2);
            //pricingDetail.genesis__Total_Payments_Derived__c  = pricingOption.genesis__Payment_Amount_Per_Period__c * app.genesis__Term__c;
            pricingDetail.genesis__Payment_Frequency__c  =   app[0].genesis__Payment_Frequency__c;
            pricingDetail.debit_Frequency__c = app[0].debit_frequency__c;
            pricingDetail.genesis__Term__c  =  app[0].genesis__Term__c;
            pricingDetail.genesis__Interest_Rate__c = app[0].genesis__Interest_Rate__c;
            pricingDetail.genesis__application__c  =  app[0].id; 
            pricingDetail.genesis__Maximum_Financed_Amount__c  =  desiredLoanAmount;
            Date debitDate;
            if(applyOffer && pricingDetail.message__c != 'OFFER NOT APPLIED'){
                try{
                    if(app[0].Automated_Payment_Start_Date__c!=null){
                        debitDate = app[0].Automated_Payment_Start_Date__c;
                        system.debug(debitDate);
                    }else{
                        debitDate = systemDate;
                    }
                    if(debitDate<=systemDate){
                        while(debitDate<=systemDate){
                            if(app[0].debit_frequency__c.equalsIgnoreCase('WEEKLY')){
                                debitDate = loan.DateUtil.getNextCycleDate(debitDate,
                                                    debitDate.day(),
                                                    loan.LoanConstants.LOAN_PAYMENT_FREQ_WEEKLY,
                                                    debitDate,
                                                    null,
                                                    1);
                            }else if(app[0].debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
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
                    pricingDetail.message__c = 'OFFER APPLIED';
                    app[0].Automated_Payment_Start_Date__c = debitDate;
                    app[0].Debit_Amount__c = debitAmount.setScale(2);
                    update app[0];
                }catch(Exception e){
                    pricingDetail.message__c = 'OFFER NOT APPLIED';
                }
                
            }else{
                if(pricingDetail.message__c != 'OFFER NOT APPLIED'){
                    pricingDetail.message__c = 'OFFER AVAILABLE';
                }  
                    
            }
             
        }else{
            pricingDetail.message__c = 'OFFER NOT AVAILABLE';
            pricingDetail.genesis__application__c  =  app[0].id;
            pricingDetail.genesis__Maximum_Financed_Amount__c  =  app[0].genesis__Loan_Amount__c;
        }
        insert pricingDetail;
        
        return pricingDetail;
    }
    
    public genesis__Application_Pricing_Detail__c getUnsecuredOffer(String appId , Boolean applyOffer){
        List<genesis__Applications__c> app = [select id,DTI__c,pepNavigation_Status__c,Current_Veda_Score__c,Automated_Payment_Start_Date__c, Recalculated_Total_Score__c ,Bureau_Recalculated_Score__c,Estimated_Credit_Rating__c,DDP_Processed__c,Manual_override__c,Rent_Expense_Monthly__c,genesis__Account__r.Relationship_Status__c,genesis__Account__r.Number_of_Dependants__c,genesis__Loan_Amount__c,Total_Monthly_Debt__c,genesis__Credit_Rating__c,genesis__Term__c,Total_Expense_and_Debt__c,Total_Monthly_Income__c,
                genesis__Interest_Rate__c,genesis__CL_product__c,genesis__CL_Product__r.Interest_Type__c,Total_Monthly_Expense_Excluding_Mortg_f__c,genesis__Expected_Start_date__c,Percentage_of_Expense_Contribution__c,Expense_Contribution__c,debit_frequency__c,Total_Monthly_Expense__c,Total_Monthly_Expense_Exc_Mortgage__c,Servicability_Value__c,genesis__Payment_Frequency__c,Affordability_Status__c,genesis__CL_Purpose__C from 
                                            genesis__Applications__c where Id=:appId];
        genesis__Application_Pricing_Detail__c pricingDetail = new genesis__Application_Pricing_Detail__c();
        pricingDetail.Type__c = 'UNSECURED';
        List<clcommon__CL_Product__c> clProduct  = [select id,Name from clcommon__CL_product__c where Interest_Type__c=:app[0].genesis__CL_Product__r.Interest_Type__c and is_secured__c = false];
        List<CL_Product_Purpose_Junction__c> productPurposeJnc = [select id,Max_Loan_Amount_Delta__c,Max_Term_Delta__c,
                                                                    Min_Loan_Amount_Delta__c,Min_Term_Delta__c
                                                                    from CL_Product_Purpose_Junction__c 
                                                                    where CL_Product__c=:clProduct[0].id
                                                                    and CL_Purpose__c=:app[0].genesis__Cl_Purpose__c];
        System.debug('App Term : ' + app[0].genesis__Term__c);
        Decimal maxLoanAmountDelta=0;
        Decimal minLoanAmountDelta=0;
        Decimal maxTermDelta=0;
        Decimal minTermDelta=0;
        Decimal loanAmountAdjustedMaxLimit= 0;
        Decimal loanAmountAdjustedMinLimit = 0;
        Decimal termAdjustedMaxLimit = 0;
        Decimal termAdjustedMinLimit = 0;
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Decimal desiredLoanAmount = app[0].genesis__Loan_Amount__C;
        List<HEM__c> hems = new List<HEM__c>();
        Affordability_Configuration__c affConfig = new Affordability_Configuration__c();
        affConfig = [select Id,Min_Loan_Amount_Percent__c, Decrease_Loan_Amount_By__c  , DTI_Threshold__c,
                    Rate_Buffer__c,Revolving_Credit_Percent_As_Expense__c from Affordability_Configuration__c
                    where Active__c = true limit 1];
        Decimal expense = 0;
        Date systemDate = util.getCurrentSystemDate();
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
        loanAmountAdjustedMaxLimit = desiredLoanAmount-maxLoanAmountDelta;
        loanAmountAdjustedMinLimit = desiredLoanAmount-minLoanAmountDelta;
        termAdjustedMaxLimit  = app[0].genesis__Term__c - maxtermDelta;
        termAdjustedMinLimit  = app[0].genesis__Term__c - minTermDelta;
        String rateCardType = 'Post Credit Check';
        System.debug('app[0].genesis__Credit_Rating__c:'  + app[0].genesis__Credit_Rating__c);
        System.debug('loanAmountAdjustedMaxLimit :' + loanAmountAdjustedMaxLimit );
        System.debug('loanAmountAdjustedMinLimit :' + loanAmountAdjustedMinLimit );
        System.debug('termAdjustedMaxLimit :' + termAdjustedMaxLimit);
        System.debug('termAdjustedMinLimit :' + termAdjustedMinLimit );
        System.debug('app[0].genesis__CL_Purpose__c' + app[0].genesis__CL_Purpose__c);
        System.debug('systemDate :' + systemDate );
        System.debug('rateCardType:' + rateCardType); 
        List<genesis__Rate_Card_Setup_Detail__c> rateCard = [select id,genesis__Payment_Frequency__c,
                                genesis__Credit_Rating__c,genesis__Enabled_Flag__c,genesis__Interest_Rate__c,
                                genesis__Maximum_Financed_Amount__c,genesis__Max_Term__c,genesis__Minimum_Financed_Amount__c,
                                genesis__Min_Term__c,genesis__Rate_Card_Setup_Header__r.CL_Purpose__c,
                                genesis__Rate_Card_Setup_Header__r.genesis__Enabled_Flag__c,
                                genesis__Rate_Card_Setup_Header__r.genesis__End_Date__c,genesis__Rate_Card_Setup_Header__r.genesis__Start_Date__c,
                                genesis__Rate_Card_Setup_Header__r.Type__c from genesis__Rate_Card_Setup_Detail__c where genesis__Credit_Rating__c=:app[0].genesis__Credit_Rating__c and
                                genesis__Enabled_Flag__c = true  and
                                genesis__Maximum_Financed_Amount__c >=: loanAmountAdjustedMaxLimit and genesis__Minimum_Financed_Amount__c <=: loanAmountAdjustedMinLimit and
                                genesis__Min_Term__c <=: termAdjustedMaxLimit and genesis__Max_Term__c >=: termAdjustedMinLimit and 
                                genesis__Rate_Card_Setup_Header__r.CL_Purpose__c=:app[0].genesis__CL_Purpose__c and 
                                genesis__Rate_Card_Setup_Header__r.genesis__Enabled_Flag__c = true and 
                                genesis__Rate_Card_Setup_Header__r.genesis__End_Date__c >=: systemDate and 
                                genesis__Rate_Card_Setup_Header__r.genesis__Start_Date__c <=: systemDate 
                                and genesis__Rate_Card_Setup_Header__r.Type__c=:rateCardType limit 1];
        System.debug('rateCard:' + rateCard );                         
        app[0].genesis__CL_Product__c   = clProduct[0].Id;
       
        app[0].genesis__Interest_Rate__c = CommonUtil.getInterestRate(app[0]);
        List<Income__c> rentalIncomes = [select id , Monthly_Income__c from Income__c where Type__c = 'Rental Income' and Application__c =: appId];  
        Decimal rentalIncome = 0;
        if(rentalIncomes.size()>0){
            rentalIncome = rentalIncomes[0].Monthly_Income__c;
        } 
        //app[0].genesis__Status__c = '';
        //app[0].Decline_Reason__c ='';
        Boolean singleHem = false;
        if(app[0].genesis__Account__r.RelationShip_Status__c!=null){
            if(app[0].genesis__Account__r.RelationShip_Status__c.equalsIgnoreCase('Married') || app[0].genesis__Account__r.RelationShip_Status__c.equalsIgnoreCase('De Facto')){
                if(app[0].Percentage_of_Expense_contribution__c>50){
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
            if(hems[0].Value_Per_Dependant__c!=null && app[0].genesis__Account__r.Number_of_Dependants__c!=null){
                totalDependantExpense = hems[0].Value_Per_Dependant__c *app[0].genesis__Account__r.Number_of_Dependants__c;
            } 
            if(hems[0].Value_per_Adult__c!=null){
                hemExpenseValue = totalDependantExpense + hems[0].Value_Per_Adult__c;
            }   
            
        }
        
        List<Expense_and_Debt__c> expensesExcludingMortgage  = [select Id ,Monthly_Expense__c from Expense_and_Debt__c where Type_of_Expense_Debt__c!='Rent or mortgage repayments' and Type__c!='Debt' and Application__c=:app[0].id];
        system.debug('exp--:'+ expensesExcludingMortgage);
        if(expensesExcludingMortgage.size()>0){
            for(Expense_and_Debt__c exp:expensesExcludingMortgage){
                if(exp.Monthly_Expense__c!=null){
                     expExcludingMortgage+=exp.Monthly_Expense__C;
                }
               
            }
            
            if(app[0].Percentage_of_Expense_Contribution__c<50){
                expExcludingMortgage = 0.5 * expExcludingMortgage;
            }
        }
        
        if(expExcludingMortgage!=null){
            expense = Math.max( hemExpenseValue, expExcludingMortgage);
        }else{
            expense = hemExpenseValue;
        }
        pricingDetail.genesis__Credit_Rating__c = app[0].genesis__Credit_Rating__c;
        if(rateCard.size()>0){
            
            //pricingOption.Days_Convention__c  =  rateCardDetail.Days_Convention__c;
            LoanActions act = new LoanActions();
            Decimal paymentAmount = 0;
            Decimal debitAmount = 0;
            Decimal servicability = 0;
            Boolean isServicable = false;
            if(rateCard.size()==1){
                Decimal nextTerm = app[0].genesis__Term__c;
                Decimal previousTerm =0;
                Decimal revisedMaxLimit = rateCard[0].genesis__Max_term__c - maxtermDelta;
                System.debug('App Term 1 : ' + nextTerm);
                System.debug('revisedMaxLimit 1 : ' + revisedMaxLimit);
                while (nextTerm<=revisedMaxLimit && !isServicable){
                    
                    paymentAmount = act.calculateMonthlyPaymentAmount(app[0].genesis__Loan_Amount__c,app[0].genesis__Interest_rate__c,nextTerm,app[0].id);
                    servicability = app[0].Total_Monthly_income__c-(0.2*rentalIncome)-app[0].Total_Monthly_Debt__c - expense - app[0].Rent_Expense_Monthly__c - revolvingCreditAmount - paymentAmount;
                    //app.Servicability_Value__c = servicability;
                    dti = (app[0].Total_Monthly_Debt__c+paymentAmount + revolvingCreditAmount)/(app[0].Total_Monthly_Income__c - (0.2*rentalIncome) - expense - app[0].Rent_Expense_Monthly__c);
                    app[0].DTI__c = dti;
                    System.debug('Service :' + servicability );
                    System.debug('dti : ' + dti);
                    System.debug('affConfig.Rate_Buffer__c : ' + affConfig.Rate_Buffer__c);
                    System.debug('affConfig.DTI_Threshold__c : ' + affConfig.DTI_Threshold__c);
                    if(servicability>=affConfig.Rate_Buffer__c && dti<=affConfig.DTI_Threshold__c){
                        isServicable = true;
                        app[0].genesis__Payment_Amount__c = paymentAmount;
                        app[0].genesis__Term__c = nextTerm;
                    }
                    previousTerm  = nextTerm;
                    nextTerm = getNextTermMovedByAYear(nextTerm,app[0].genesis__Payment_Frequency__c);
                }
                Decimal nextLoanAmount = app[0].genesis__Loan_Amount__c;
                Decimal revisedMinLoanAmountLimit = rateCard[0].genesis__Minimum_Financed_Amount__c + minLoanAmountDelta;
                Decimal minLoanAmount = Math.max(revisedMinLoanAmountLimit, affConfig.Min_Loan_Amount_Percent__c * app[0].genesis__Loan_Amount__c);
                while(nextLoanAmount>=minLoanAmount && !isServicable){
                    
                    paymentAmount = act.calculateMonthlyPaymentAmount(nextLoanAmount,app[0].genesis__Interest_rate__c,previousTerm,app[0].id);
                    servicability = app[0].Total_Monthly_income__c-(0.2*rentalIncome)-app[0].Total_Monthly_Debt__c - expense - app[0].Rent_Expense_Monthly__c -revolvingCreditAmount-paymentAmount;
                    //app.Servicability_Value__c = servicability;
                    dti = (app[0].Total_Monthly_Debt__c+paymentAmount + revolvingCreditAmount)/(app[0].Total_Monthly_Income__c-(0.2*rentalIncome) - expense  - app[0].Rent_Expense_Monthly__c);
                    app[0].DTI__c = dti;
                    if(servicability>=affConfig.Rate_Buffer__c && dti<=affConfig.DTI_Threshold__c){
                        isServicable = true;
                        app[0].genesis__Payment_Amount__c = paymentAmount;
                        app[0].genesis__Loan_Amount__c = nextLoanAmount;
                        app[0].genesis__Term__c = previousTerm;
                        break;
                    }
                    nextLoanAmount = nextLoanAmount - affConfig.Decrease_Loan_Amount_By__c;
                }
                dti = (app[0].Total_Monthly_Debt__c+paymentAmount + revolvingCreditAmount)/(app[0].Total_Monthly_Income__c-(0.2*rentalIncome) - expense  - app[0].Rent_Expense_Monthly__c);
                if(applyOffer){
                   // try{
                        update app[0];
                        genesis.SkuidNewApplication.generateSchedule(app[0].id);
                        app = [select id, genesis__Payment_Amount__c,genesis__Loan_Amount__c,genesis__Interest_Rate__c,genesis__Payment_Frequency__c,genesis__Term__c,genesis__Expected_Start_date__c,debit_frequency__c,debit_amount__c from genesis__Applications__c where Id = :app[0].Id];
                        paymentAmount = app[0].genesis__Payment_Amount__c;
                        system.debug(servicability);
                        system.debug(dti);
                        system.debug(paymentAmount);
                        if(servicability<affConfig.Rate_Buffer__c ||dti>affConfig.DTI_Threshold__c){
                            app[0].Affordability_Status__c = 'No';
                            app[0].genesis__Status__c = 'DECLINED';
                            app[0].Serviceability_Status__c = 'Declined';
                            app[0].Decline_Reason__c = 'NONSERVICEABLE';
                        }else{
                            
                            app[0].genesis__Status__c = 'CONDITIONALLY APPROVED';
                            app[0].Serviceability_Status__c = 'Approved';
                        }
                    //}catch(Exception e){
                     //   system.debug(e.getMessage());
                     //   pricingDetail.message__c = 'OFFER NOT APPLIED';
                   // }
                    system.debug('Status:'+ app[0].genesis__Status__c);
                }else{
                    if(servicability<affConfig.Rate_Buffer__c ||dti>affConfig.DTI_Threshold__c){
                        pricingDetail.message__c = 'OFFER NOT AVAILABLE';
                        pricingDetail.genesis__application__c  =  app[0].id;
                        pricingDetail.genesis__Maximum_Financed_Amount__c  =  app[0].genesis__Loan_Amount__c;
                        
                        
                    }else{
                        pricingDetail.message__c = 'OFFER AVAILABLE';
                        pricingDetail.genesis__application__c  =  app[0].id;
                        
                    }
                }
                
                
            }else{
                //throw new MyException('No rate card found.');
                system.debug('No rate card found.');
                if(applyOffer){
                    app[0].Serviceability_Status__c = 'Referred';
                    app[0].genesis__Status__c = 'REFERRED';
                    app[0].Referred_Reason__c = 'RATE CARD NOT FOUND';
                }else{
                    pricingDetail.message__c = 'OFFER NOT AVAILABLE';
                    pricingDetail.genesis__Maximum_Financed_Amount__c  =  app[0].genesis__Loan_Amount__c;
                    pricingDetail.genesis__application__c  =  app[0].id;
                }
                
            }
            
            
            
            if(app[0].debit_frequency__c!=null && app[0].debit_frequency__c.equalsIgnoreCase('WEEKLY')){
            
                debitAmount = paymentAmount / 4;
            
            }else if(app[0].debit_frequency__c!=null && app[0].debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
                
                debitAmount = paymentAmount/2;
                
            }else{
                debitAmount  = paymentAmount;
            }
            pricingDetail.genesis__Payment_Amount_Per_Period__c  =  paymentAmount.setScale(2);
            pricingDetail.debit_Amount__c = debitAmount.setScale(2);
            //pricingDetail.genesis__Total_Payments_Derived__c  = pricingOption.genesis__Payment_Amount_Per_Period__c * app.genesis__Term__c;
            pricingDetail.genesis__Payment_Frequency__c  =   app[0].genesis__Payment_Frequency__c;
            pricingDetail.debit_Frequency__c = app[0].debit_frequency__c;
            pricingDetail.genesis__Term__c  =  app[0].genesis__Term__c;
            pricingDetail.genesis__Interest_Rate__c = app[0].genesis__Interest_Rate__c;
            pricingDetail.genesis__application__c  =  app[0].id; 
            pricingDetail.genesis__Maximum_Financed_Amount__c  =  app[0].genesis__Loan_Amount__c;
            system.debug(pricingDetail);
            Date debitDate;
            if(applyOffer && pricingDetail.message__c != 'OFFER NOT APPLIED'){
                try{
                    if(app[0].Automated_Payment_Start_Date__c!=null){
                        debitDate = app[0].Automated_Payment_Start_Date__c;
                        system.debug(debitDate);
                    }else{
                        debitDate = systemDate;
                    }
                    if(debitDate<=systemDate){
                        while(debitDate<=systemDate){
                            if(app[0].debit_frequency__c.equalsIgnoreCase('WEEKLY')){
                                debitDate = loan.DateUtil.getNextCycleDate(debitDate,
                                                    debitDate.day(),
                                                    loan.LoanConstants.LOAN_PAYMENT_FREQ_WEEKLY,
                                                    debitDate,
                                                    null,
                                                    1);
                            }else if(app[0].debit_frequency__c.equalsIgnoreCase('BI-WEEKLY')){
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
                    pricingDetail.message__c = 'OFFER APPLIED';
                    app[0].Automated_Payment_Start_Date__c = debitDate;
                    app[0].Debit_Amount__c = debitAmount.setScale(2);
                    update app[0];
                    
                    List<clcommon__Collateral__c> collateral = [select id,active__c from clcommon__Collateral__c where genesis__Application__c=:app[0].id and active__c = true];
                    if(collateral != null && collateral.size() > 0){
                        for(clcommon__Collateral__c coc : collateral){
                            coc.active__c = false;
                        }                    
                        update collateral;
                    }
                }catch(Exception e){
                    system.debug(e.getMessage());
                    pricingDetail.message__c = 'OFFER NOT APPLIED';
                }
                
            }else{
                if(pricingDetail.message__c != 'OFFER NOT APPLIED'){
                    pricingDetail.message__c = 'OFFER AVAILABLE';
                }  
                    
            }
             
        }else{
            pricingDetail.message__c = 'OFFER NOT AVAILABLE';
            pricingDetail.genesis__application__c  =  app[0].id;
            pricingDetail.genesis__Maximum_Financed_Amount__c  =  app[0].genesis__Loan_Amount__c;
        }
        insert pricingDetail;
        
        return pricingDetail;
        
        
        
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
    
}
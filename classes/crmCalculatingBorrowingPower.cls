public class crmCalculatingBorrowingPower{
    
    static decimal rentRate = 0 ;
    static decimal calculatedRent = 0 ;
    static decimal grossRentRate = 0;
    
    static List<CRM_Borrowing_Power_Other__c> lstMainBorrowingPowerOther = new List<CRM_Borrowing_Power_Other__c>();
    static List<CRM_Tax_Rates__c> lstCrmTaxRates = new List<CRM_Tax_Rates__c>();
    static List<Party__c> lstParty = new List<Party__c>();
    static List<CRM_Borrowing_Power_Rate__c> lstBorrowingPowerRate = new List<CRM_Borrowing_Power_Rate__c>();
    static List<Lead> lstLead = new List<Lead>();
    static decimal LoanAmountForlvr = 0;
    static Decimal Security = 0;
    static Decimal PropertyValue = 0;
    static decimal lvr = 0;
    static decimal AnnualIncomeBorr1AndBorr2 = 0;
    static boolean creditImpaired = false;
    static boolean selfEmployed = false;
    static decimal responseTax = 0 ;
    static decimal responseLivingExpense = 0;
    static decimal responseMaxRepayment = 0;
    static decimal BorrowingPower = 0;
    
    public class CalculationResponse{
        public decimal wrapRent {get;set;}
        public decimal wrapTax {get;set;}
        public decimal wrapLivingExpense {get;set;}
        public decimal wrapMaxRepayment {get;set;}
        public decimal wrapRate {get;set;}
        public decimal wrapBorrPower {get;set;}
        public decimal wrapLoanAmount {get;set;}
        public boolean wrapQualify {get;set;}
    }
    
    public static CalculationResponse fetchBorrowingPower(id LeadID ,id PartyID){
       system.debug('inside handler');
       
       if(LeadID != null){
            lstLead = [select id,CRM_Est_Rent_Income__c,CRM_Gross_Income_Borrower_1__c,
                      CRM_Borrower_Count__c,CRM_Gross_Rent_Income__c,CRM_Tax__c,CRM_Dependants__c,CRM_Purchase_Price__c,
                      CRM_Refinance_Amount__c,CRM_Deposit_Amount__c,CRM_Living_Expenses__c,CRM_Property_Value__c,CRM_Employment_Type_Borrower_1__c,
                      CRM_Credit_Impairment_Borrower_1__c,CRM_Maximum_Repayment__c,CRM_Months_Self_Employed_Borrower_1__c,CRM_Loan_Purpose__c,CRM_Credit_Card_Limit__c,CRM_Claimed_Living_Expenses__c,CRM_Monthly_Repayments__c,CRM_Preferred_Contact_Method__c,
                      CRM_Years_Self_Employed_Borrower_1__c,CRM_Rate__c,CRM_Maximum_Borrow__c,CRM_Other_Annual_Mortgage__c,CRM_Other_Annual_Liabilities__c
                      from Lead where id = :LeadID];
       }
       else{
           return null ;
       }
       if(PartyID != null){
           lstParty = [select id,CRM_Employment_Type__c,CRM_Gross_Income__c,CRM_Gross_Income_Frequency__c,CRM_Months_Self_Employed__c,CRM_Type__c,       CRM_Years_Self_Employed__c,CRM_Credit_Impairment__c
                        from Party__c where id = : PartyID];
        }
       
        // Fetch Tax Rates
        lstCrmTaxRates = [select id,CRM_Bracket_Amount__c,CRM_Bracket_Max__c,CRM_Bracket_Min__c,CRM_Bracket_Rate__c,
                          CRM_End_Date__c,CRM_Start_Date__c,CRM_Type__c,CRM_Type_Description__c from CRM_Tax_Rates__c
                          where CRM_Start_Date__c < Today And (CRM_End_Date__c > Today OR CRM_End_Date__c = null)];
                          
        // Fetch Borrowing Other Power
        lstMainBorrowingPowerOther = [select id,Name,CRM_Credit_Card_Multiplier__c,CRM_DSR__c,CRM_End_Date__c,CRM_NSR__c,CRM_Rent_Rate__c,
                              CRM_Start_Date__c,CRM_Term_Years__c,CRM_Mortgage_Debt_Rate__c,CRM_Max_Lend__c,CRM_Qualifying_LVR__c,CRM_Qualifying_Borrowing_Power__c
                              from CRM_Borrowing_Power_Other__c
                              where CRM_Start_Date__c < Today and (CRM_End_Date__c > Today OR CRM_End_Date__c = null)];
                          
        rentRate = CalculatingRentRate(lstMainBorrowingPowerOther);

        CalculationResponse objWrap ;
        List<Lead> lstToUpdateLeadWithUpdatedValue = new List<Lead>();  
         
        if(lstLead != null && lstLead.size()>0){
            for(Lead objLead : lstLead){
                objWrap = new CalculationResponse();
                
                if(objLead.CRM_Est_Rent_Income__c == null){
                    objLead.CRM_Est_Rent_Income__c = 0.0;
                }
                if(objLead.CRM_Gross_Income_Borrower_1__c == null){
                    objLead.CRM_Gross_Income_Borrower_1__c = 0;
                }
                decimal PartyIncome = 0;
                if(lstParty.size()>0){
                    if(lstParty[0].CRM_Gross_Income__c != null){
                        PartyIncome = lstParty[0].CRM_Gross_Income__c ;
                    }
                }
                AnnualIncomeBorr1AndBorr2 = objLead.CRM_Gross_Income_Borrower_1__c + PartyIncome;
                //------------------------Calculating Rent -----------------------------------------------------------------------------  
                
                //grossRentRate = objLead.CRM_Est_Rent_Income__c * 12 * rentRate;
                grossRentRate = objLead.CRM_Est_Rent_Income__c * 12;
                objLead.CRM_Gross_Rent_Income__c = grossRentRate;
                objWrap.wrapRent = grossRentRate ;
                system.debug('grossRentRate******'+grossRentRate);
            
                //--------------------------Calculating Tax---------------------------------------------------------------------------------

                decimal calculatedTaxBorr1 = 0;
                decimal calculatedTaxBorr2 = 0;
                if(objLead.CRM_Borrower_Count__c != null ){  
                    responseTax = CalculateTAX(objLead.CRM_Gross_Income_Borrower_1__c,grossRentRate/objLead.CRM_Borrower_Count__c)
                                    + CalculateTAX(PartyIncome ,grossRentRate/objLead.CRM_Borrower_Count__c);
                }
                else{
                    responseTax = 0;
                }
                objLead.CRM_Tax__c = responseTax;
                objWrap.wrapTax = responseTax;
                system.debug('responseTax******'+responseTax);
                
                // ------------------------------- Calculate Living Expenses --------------------------------------------------------------
                
                if(objLead.CRM_Borrower_Count__c == null){
                    objLead.CRM_Borrower_Count__c = 0;
                }
                if(objLead.CRM_Dependants__c == null){
                    objLead.CRM_Dependants__c = 0;
                }
                if(objLead.CRM_Purchase_Price__c == null){
                    objLead.CRM_Purchase_Price__c = 0;
                }
                if(objLead.CRM_Refinance_Amount__c == null){
                    objLead.CRM_Refinance_Amount__c = 0;
                }
                if(objLead.CRM_Deposit_Amount__c == null){
                    objLead.CRM_Deposit_Amount__c = 0;
                }
                if(objLead.CRM_Claimed_Living_Expenses__c == null){
                    objLead.CRM_Claimed_Living_Expenses__c = 0;
                }
                 //objLead.CRM_Living_Expenses__c
                 responseLivingExpense = calculateLivingExpenses(integer.valueOf(objLead.CRM_Borrower_Count__c), integer.valueOf(objLead.CRM_Dependants__c), objLead.CRM_Purchase_Price__c, objLead.CRM_Refinance_Amount__c, objLead.CRM_Deposit_Amount__c);
                
                if((objLead.CRM_Claimed_Living_Expenses__c * 12) > responseLivingExpense){
                    responseLivingExpense = objLead.CRM_Claimed_Living_Expenses__c * 12 ;
                }
                
                objLead.CRM_Living_Expenses__c = responseLivingExpense;
                objWrap.wrapLivingExpense = responseLivingExpense;
                system.debug('responseLivingExpense******'+responseLivingExpense);
        //--------------------------------------------- Calculate Living Expenses -----------------------------------------------------
                if(objLead.CRM_Property_Value__c == null){
                    objLead.CRM_Property_Value__c = 0;
                }
                
                if(objLead.CRM_Loan_Purpose__c == 'Purchase'){
                    
                    LoanAmountForlvr = objLead.CRM_Purchase_Price__c - objLead.CRM_Deposit_Amount__c;
                    if(LoanAmountForlvr < 0){
                        LoanAmountForlvr = 0;
                    }
                    Security = objLead.CRM_Purchase_Price__c;
                }
                else{
                    LoanAmountForlvr = objLead.CRM_Refinance_Amount__c;
                    Security = objLead.CRM_Property_Value__c ;
                }
                
                if(Security == 0){
                    lvr = 0;
                }
                else{
                    lvr = LoanAmountForlvr / Security;
                }
                
                try{
                    responseMaxRepayment = calculateMaximumRepayment(AnnualIncomeBorr1AndBorr2 ,lvr , objLead);
                }
                catch(exception e){
                    system.debug(e);
                }
                objLead.CRM_Maximum_Repayment__c = responseMaxRepayment;
                objWrap.wrapMaxRepayment = responseMaxRepayment;
                system.debug('responseMaxRepayment******'+responseMaxRepayment);
        //-----------------------------------------------------------------------------------------------------------------------------
                boolean creditImpairedParty = false;
                boolean boolSelfEmployment = false;
                if(lstParty.size()>0){
                    
                    creditImpairedParty = lstParty[0].CRM_Credit_Impairment__c ;
                    
                    if(lstParty[0].CRM_Employment_Type__c != null && lstParty[0].CRM_Employment_Type__c == 'Self Employed'){
                        boolSelfEmployment = true;  
                    }
                    else{
                        boolSelfEmployment = false;
                    }
                }
                
                if(objLead.CRM_Credit_Impairment_Borrower_1__c == true || creditImpairedParty == true){
                    creditImpaired = true;
                }
                
                boolean boolSelfEmploymentLead = false;
                if(objLead.CRM_Employment_Type_Borrower_1__c != null && objLead.CRM_Employment_Type_Borrower_1__c == 'Self Employed'){
                    boolSelfEmploymentLead = true;
                }
            
                if(boolSelfEmploymentLead == true || boolSelfEmployment == true ){
                    selfEmployed = true;        
                }
                
                decimal selfEmployedYears1 = 0.0;
                decimal selfEmployedMonths1 = 0;
                if(objLead.CRM_Years_Self_Employed_Borrower_1__c != null){
                    selfEmployedYears1 = decimal.valueof((objLead.CRM_Years_Self_Employed_Borrower_1__c)) ;
                }
                if(objLead.CRM_Months_Self_Employed_Borrower_1__c != null){
                    selfEmployedMonths1 = decimal.valueof((objLead.CRM_Months_Self_Employed_Borrower_1__c)) ;
                }
                Decimal finalSelfEmployedMonths1 = selfEmployedYears1 * 12 + selfEmployedMonths1 ;
                
                decimal selfEmployedYears2 = 0;
                decimal selfEmployedMonths2 = 0;
                if(lstParty.Size() > 0){
                    if(lstParty[0].CRM_Years_Self_Employed__c != null){
                        selfEmployedYears2 = decimal.valueof((lstParty[0].CRM_Years_Self_Employed__c)) ;
                    }
                    if(lstParty[0].CRM_Months_Self_Employed__c != null){
                        selfEmployedMonths2 = decimal.valueof(lstParty[0].CRM_Months_Self_Employed__c) ;
                    }
                    
                }
                
                Decimal finalSelfEmployedMonths2 = selfEmployedYears2 * 12 + selfEmployedMonths2 ;
                
                Decimal finalSelfEmployedMonths = 0;
                if(finalSelfEmployedMonths1 > finalSelfEmployedMonths2){
                     finalSelfEmployedMonths = finalSelfEmployedMonths1;
                }
                else{
                    finalSelfEmployedMonths = finalSelfEmployedMonths2;
                }
                
                decimal rate = 0 ;
                if(selfEmployed == false){
                    
                    rate = [select CRM_Rate__c,CRM_End_Date__c,CRM_Credit_Impairment__c,CRM_Self_Employed__c,CRM_Start_Date__c,CRM_Type__c,CRM_Type_Detail__c from CRM_Borrowing_Power_Rate__c
                            where CRM_Credit_Impairment__c = :creditImpaired and CRM_Self_Employed__c = :selfEmployed and CRM_Start_Date__c < Today and 
                            (CRM_End_Date__c > Today Or CRM_End_Date__c = null)].CRM_Rate__c;
                    
                }
                else if(creditImpaired){
                    rate = [select CRM_Rate__c,CRM_End_Date__c,CRM_Credit_Impairment__c,CRM_Self_Employed__c,CRM_Start_Date__c,CRM_Type__c,CRM_Type_Detail__c from CRM_Borrowing_Power_Rate__c
                            where CRM_Credit_Impairment__c = :creditImpaired and CRM_Self_Employed__c = :selfEmployed and CRM_Start_Date__c < Today and 
                            (CRM_End_Date__c > Today Or CRM_End_Date__c = null)].CRM_Rate__c;
                }
                else{
                    lstBorrowingPowerRate =[select CRM_Rate__c from CRM_Borrowing_Power_Rate__c where 
                                            ((CRM_Credit_Impairment__c = :creditImpaired and CRM_Self_Employed__c = :selfEmployed and CRM_Self_Employed_Months__c <= :finalSelfEmployedMonths) OR 
                                            (CRM_Self_Employed__c = :selfEmployed and CRM_Self_Employed_Months__c <= :finalSelfEmployedMonths)) and CRM_Start_Date__c < Today and
                                            (CRM_End_Date__c > Today Or CRM_End_Date__c = null)];

                    if(lstBorrowingPowerRate.Size()>0){
                        rate = lstBorrowingPowerRate[0].CRM_Rate__c;
                        for(CRM_Borrowing_Power_Rate__c objBorrwerRate : lstBorrowingPowerRate){
                            if(rate > objBorrwerRate.CRM_Rate__c){
                                rate = objBorrwerRate.CRM_Rate__c;
                            }
                        }                   
                    }                                       
                }
                objLead.CRM_Rate__c = rate;
                objWrap.wrapRate = rate;
                system.debug('rate******'+rate);
                
                decimal term = 0;
                if(lstMainBorrowingPowerOther.size()>0){
                     term = lstMainBorrowingPowerOther[0].CRM_Term_Years__c;
                }
                else{
                     term = 0;
                }
                
                BorrowingPower = BorrowingPowerCalculator(responseMaxRepayment,rate,term);
                
                decimal qualifylvr = 0;
                decimal qualifyBorrowingPower = 0;
                if(lstMainBorrowingPowerOther.size() > 0 && lstMainBorrowingPowerOther[0].CRM_Qualifying_LVR__c != null){
                    qualifylvr = lstMainBorrowingPowerOther[0].CRM_Qualifying_LVR__c;
                }
                else{
                    qualifylvr = 0.95;
                }
                
                if(lstMainBorrowingPowerOther.size() > 0 && lstMainBorrowingPowerOther[0].CRM_Qualifying_Borrowing_Power__c != null){
                    qualifyBorrowingPower = lstMainBorrowingPowerOther[0].CRM_Qualifying_Borrowing_Power__c;
                }
                else{
                    qualifyBorrowingPower = 100000;
                }
                
                
                boolean qualify = false;
                if(lvr > 0.95){
                    qualify = false;
                }
                else{
                    if(BorrowingPower < qualifyBorrowingPower){
                        qualify = false;
                    }
                    else{
                        qualify = true;
                    }
                }
                objWrap.wrapQualify = qualify;
                
                // logic to set status as 'Active-Refer'
                if(qualify){
                    objLead.Status = 'Active';
                }
                else{
                    objLead.Status = 'Active-Refer';
                }
                
                // Logic to set status as 'Lead Nurture'
                if(objLead.CRM_Preferred_Contact_Method__c.trim() == 'No Contact' || objLead.CRM_Preferred_Contact_Method__c.trim() == 'Not Provided'){
                    objLead.Status = 'Lead Nurture';
                }
                
                decimal maxLend = 0;
                decimal finalLoanAmount = 0;
                if(lstMainBorrowingPowerOther.size() > 0 && lstMainBorrowingPowerOther[0].CRM_Max_Lend__c == null){
                    maxLend = 2500000.00;
                }
                else{
                    maxLend = lstMainBorrowingPowerOther[0].CRM_Max_Lend__c;
                }
                
                if(BorrowingPower > maxLend){
                    BorrowingPower = maxLend;
                }
                
                objLead.CRM_Maximum_Borrow__c = BorrowingPower;
                //objLead.CRM_Final_Loan_Amount__c = finalLoanAmount;
                objWrap.wrapBorrPower = BorrowingPower;
                objWrap.wrapLoanAmount = finalLoanAmount;
                system.debug('BorrowingPower******'+BorrowingPower);
                
                lstToUpdateLeadWithUpdatedValue.add(objLead);
            }
        }
        if(lstToUpdateLeadWithUpdatedValue != null && lstToUpdateLeadWithUpdatedValue.Size()>0){
            update lstToUpdateLeadWithUpdatedValue;
        }
        
        return objWrap; 
    }
    
    // ------------------------ Method for Calculating NSR ---------------------------------------------------------
    public static decimal BorrowingPowerCalculator(decimal maxRepaymentForBorrCal,decimal rate,decimal term){
        
        double monthRate = (rate / 12).setScale(4);
        integer monthTerm = integer.valueOf(term * 12);
        decimal tempMonth = 1 + monthRate ;
        
        decimal maxBorr = (maxRepaymentForBorrCal/12) * ((1 - (1/tempMonth.pow(monthTerm)))/monthRate);
        
        decimal newValue = maxBorr/1000;
        
        decimal result = math.floor(newValue) * 1000;
        
        return result;
    } 
    static decimal maxRepayment = 0;
    static decimal NSR = 0;
    static decimal otherRepaymentsYearly = 0;
    public static decimal calculateMaximumRepayment(decimal annualIncome , decimal calculatedlvr, lead objLead){
        if(calculatedlvr > 0.90){
            NSR = 1.25;
        }
        else{
            NSR = lstMainBorrowingPowerOther[0].CRM_NSR__c;
        }
        
        if(objLead.CRM_Other_Annual_Mortgage__c == null){
            objLead.CRM_Other_Annual_Mortgage__c = 0;
        }
        if(objLead.CRM_Other_Annual_Liabilities__c == null){
            objLead.CRM_Other_Annual_Liabilities__c = 0;
        }
        if(objLead.CRM_Monthly_Repayments__c == null){
            objLead.CRM_Monthly_Repayments__c = 0;
        }
        
        if(lstMainBorrowingPowerOther.size() > 0 && lstMainBorrowingPowerOther[0].CRM_Mortgage_Debt_Rate__c != null){
            otherRepaymentsYearly = objLead.CRM_Monthly_Repayments__c * 12 * lstMainBorrowingPowerOther[0].CRM_Mortgage_Debt_Rate__c;
        }
        
        maxRepayment = ((annualIncome + grossRentRate - responseTax - responseLivingExpense) / NSR) - 
                     (objLead.CRM_Credit_Card_Limit__c * ((lstMainBorrowingPowerOther != null && lstMainBorrowingPowerOther[0].CRM_Credit_Card_Multiplier__c != null) ? lstMainBorrowingPowerOther[0].CRM_Credit_Card_Multiplier__c : 0) * 12 + otherRepaymentsYearly + objLead.CRM_Other_Annual_Mortgage__c + objLead.CRM_Other_Annual_Liabilities__c);
        
        
        if(maxRepayment < 0){
            
            maxRepayment = 0;
        }
        
        return maxRepayment;
    }
    
    // ------------------------- Method to calculate Living Expenses --------------------------------------------------
    
    public Static Decimal calculateLivingExpenses(integer borrowerCount , integer dependantCount, decimal purchasePrice, decimal refinanceAmount, decimal depositAmount){
        List<CRM_Borrowing_Power_Living_Expense__c> lstBPLivingExpenses = [Select Id, CRM_Couple_Base__c, CRM_Couple_Increment__c, CRM_Dependant_Base__c,
                                                                            CRM_Dependant_Increment__c, CRM_Lower_Threshold__c, CRM_Single_Adult_Base__c,
                                                                            CRM_Single_Adult_Increment__c
                                                                            from CRM_Borrowing_Power_Living_Expense__c
                                                                            where CRM_Start_Date__c < Today and (CRM_End_Date__c > Today OR CRM_End_Date__c = null)];
                                                                            
        integer singleCount = 0;
        integer coupleCount = 0;
        if(borrowerCount == 2){
            singleCount = 0;
            coupleCount = 1;
        }
        else{
            singleCount = 1;
            coupleCount = 0;
        }
        
        decimal livingExpenses = 
        singleCount * ((lstBPLivingExpenses != null && lstBPLivingExpenses[0].CRM_Single_Adult_Base__c != null) ? lstBPLivingExpenses[0].CRM_Single_Adult_Base__c : 0) +
        coupleCount * ((lstBPLivingExpenses != null && lstBPLivingExpenses[0].CRM_Couple_Base__c != null) ? lstBPLivingExpenses[0].CRM_Couple_Base__c : 0) +
        dependantCount * ((lstBPLivingExpenses != null && lstBPLivingExpenses[0].CRM_Dependant_Base__c != null) ? lstBPLivingExpenses[0].CRM_Dependant_Base__c : 0);
                                    
                                    
        // ---- setup Loan Amount -------
        
        decimal loanAmount = 0;
        if(lstBPLivingExpenses != null && lstBPLivingExpenses[0].CRM_Lower_Threshold__c != null){
            if(purchasePrice > lstBPLivingExpenses[0].CRM_Lower_Threshold__c){
                loanAmount = purchasePrice - depositAmount;
            }
            else if(refinanceAmount > lstBPLivingExpenses[0].CRM_Lower_Threshold__c){
                loanAmount = refinanceAmount;
            }
            else{
                loanAmount = 0;
            }
        }
        
        // ---- setup living expense increment ---
        
        decimal livingExpenseIncrement = 0;
        if(lstBPLivingExpenses != null && lstBPLivingExpenses[0].CRM_Lower_Threshold__c != null){
            if(loanAmount > lstBPLivingExpenses[0].CRM_Lower_Threshold__c + 1000){
                livingExpenseIncrement = ((lstBPLivingExpenses[0].CRM_Single_Adult_Increment__c != null ? lstBPLivingExpenses[0].CRM_Single_Adult_Increment__c : 0) * singleCount * ((loanAmount - lstBPLivingExpenses[0].CRM_Lower_Threshold__c)/1000)) +
                                        ((lstBPLivingExpenses[0].CRM_Couple_Increment__c != null ? lstBPLivingExpenses[0].CRM_Couple_Increment__c : 0) * coupleCount * ((loanAmount - lstBPLivingExpenses[0].CRM_Lower_Threshold__c)/1000)) +
                                        ((lstBPLivingExpenses[0].CRM_Dependant_Increment__c != null ? lstBPLivingExpenses[0].CRM_Dependant_Increment__c : 0) * dependantCount * ((loanAmount - lstBPLivingExpenses[0].CRM_Lower_Threshold__c)/1000));
            }
            else{
                livingExpenseIncrement = 0;
            }
        }
        
        livingExpenses = livingExpenses + livingExpenseIncrement;
        
        return livingExpenses;
    }
    
    // ------------------------- End Section --------------------------------------------------------------------------
    
    // ---------------------- Method to calculate Rent Rate -----------------------------------------------------------
    public Static Decimal CalculateTAX(decimal annualIncome , decimal annualRentIncome){
    
        decimal totalGross = annualIncome + annualRentIncome;
    
        //--Calculate tax below marginal tax rate
        decimal bracketMin = 0 ;
        decimal bracketRate = 0 ;
        decimal tax = 0;
        decimal medicarBracketMax =0 ;
        decimal medicareBracketMin =0;
        decimal medicareBracketRate =0;
        decimal totalMarginalBelowTax = 0;
        decimal totalMarginalTax =0;
        decimal totalMedicareTax = 0;
        boolean checkIfOccurs = true;
        
// -------------------------- seperate query for bracket min ---------------------------------------------------        
        list<CRM_Tax_Rates__c> lstnewBracketMinTax = new List<CRM_Tax_Rates__c>();
        lstnewBracketMinTax = [select id,CRM_Bracket_Amount__c,CRM_Bracket_Max__c,CRM_Bracket_Min__c,CRM_Bracket_Rate__c,
                          CRM_End_Date__c,CRM_Start_Date__c,CRM_Type__c,CRM_Type_Description__c from CRM_Tax_Rates__c
                          where CRM_Type__c = 1 And CRM_Bracket_Min__c < : totalGross ];
        
        if(lstnewBracketMinTax!= null && lstnewBracketMinTax.Size()>0){
            for(CRM_Tax_Rates__c objTaxRate : lstnewBracketMinTax ){
                if(objTaxRate.CRM_Bracket_Min__c > bracketMin ){                
                    bracketMin = objTaxRate.CRM_Bracket_Min__c; 
                    bracketRate = objTaxRate.CRM_Bracket_Rate__c;              
                }   
            }
        }
        List<CRM_Tax_Rates__c> newListTaxRateForMedicare = new List<CRM_Tax_Rates__c>();
        if(lstCrmTaxRates != null && lstCrmTaxRates.Size()>0){
            for(CRM_Tax_Rates__c objTaxRate : lstCrmTaxRates ){
                // --Calculate tax below marginal tax rate
                if(objTaxRate.CRM_Type__c == 1 && objTaxRate.CRM_Bracket_Max__c != null && objTaxRate.CRM_Bracket_Max__c < totalGross ){
                
                    totalMarginalBelowTax += objTaxRate.CRM_Bracket_Amount__c;
                    
                }
                // MEdicare-----------------------------------------------
                if((objTaxRate.CRM_Bracket_Max__c == null || objTaxRate.CRM_Bracket_Max__c > totalGross) && objTaxRate.CRM_Bracket_Min__c < totalGross && objTaxRate.CRM_Type__c == 3 && checkIfOccurs == True ){
                    medicarBracketMax = objTaxRate.CRM_Bracket_Max__c;
                    medicareBracketMin = objTaxRate.CRM_Bracket_Min__c;
                    medicareBracketRate = objTaxRate.CRM_Bracket_Rate__c;
                    checkIfOccurs = false;
                }     
            }
        }
        
        // ---- marginal tax rate -------
        totalMarginalTax = (totalGross - bracketMin) * bracketRate ;
        
        //Medicare----------------------------------------------
        if(medicarBracketMax != null){
     
                 totalMedicareTax = (totalGross - medicareBracketMin ) * medicareBracketRate ;
   
        }
        else{                    
              totalMedicareTax = totalGross * medicareBracketRate ;
        }
    
        tax = totalMarginalBelowTax + totalMarginalTax + totalMedicareTax;
    
       return tax ;
    }
    
    
    
     public Static Decimal CalculatingRentRate(List<CRM_Borrowing_Power_Other__c> lstBorrowingPowerOther){
        system.debug(lstBorrowingPowerOther);
        if(lstBorrowingPowerOther != null && lstBorrowingPowerOther.Size()>0){
            if(lstBorrowingPowerOther[0].CRM_Rent_Rate__c != null){
            
                return lstBorrowingPowerOther[0].CRM_Rent_Rate__c;
            }
            else 
                return 1.0;
        
        }
        
        return 1.0;
    
    }
}
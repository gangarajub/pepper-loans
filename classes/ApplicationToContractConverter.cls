global class ApplicationToContractConverter implements ints.IProcessContract{
    public genesis__Applications__c application = new genesis__Applications__c();
    public loan__Loan_Account__c loanAccount = new loan__Loan_Account__c();
    private Map<String,String> paymentFrequencyMap = new Map<String,String>();
    
    
    global virtual void setContracts(Map<SObject,SObject> objectMap){
        Set<SObject> applicationSet = objectMap.keySet();
        for(SObject obj:applicationSet){
            application = (genesis__Applications__c)obj;
        }
        this.loanAccount = (loan__Loan_Account__c)objectMap.get(application);
       
        paymentFrequencyMap.put('MONTHLY','Monthly');
        paymentFrequencyMap.put('QUARTERLY','Quarterly');
        paymentFrequencyMap.put('ANNUAL','Annual');
        paymentFrequencyMap.put('WEEKLY','Weekly');
        paymentFrequencyMap.put('BI-WEEKLY','Bi-Weekly');
        
    }
    global virtual String processContract(){
        try{
            String retMsg = '';
            //genesis__Applications__c app = [select genesis__Product_Type__c,genesis__Lending_Product__r.Name from genesis__Applications__c where Id=:application.Id limit 1];
            genesis__Applications__c app = getApplicationDetails(application.id);
            String productType = app.genesis__Product_Type__c;
            String lendingProductId = app.genesis__CL_Product__c;
            
            loan__Loan_Product__c product = getLoanProductDetails(lendingProductId);
            if(productType.equals('LOAN')){
                CreateLoanAccountForLoanTypeHandler loanHandler = new CreateLoanAccountForLoanTypeHandler(app,loanAccount,product);
               retMsg = loanHandler.createLoanAccount();
            }
            
            return retMsg;
        }catch(Exception e){
        system.debug('e.getLineNumber()'+e.getLineNumber()+'msg'+e.getMessage()+'stack'+e.getStackTraceString());
            return 'message:'+e.getMessage() +',line number:'+e.getLineNumber(); 
        }
            
    }
    
    public static genesis__Applications__c getApplicationDetails(String appId){
        genesis__Applications__c application = [select id,RecordTypeId,CreatedDate,
                                                        genesis__Status__c,
                                                        Approved_Date__c,
                                                        Expiry_Date__c,
                                                        is_secured__c,
                                                        genesis__CL_Purpose__r.loan__Lending_Purpose__c,
                                                        genesis__Lending_Product__r.Name,
                                                        genesis__Company__r.Name,genesis__Loan_Amount__c,
                                                        genesis__Account__c,genesis__Contact__c,
                                                        genesis__Term__c,genesis__Credit_Limit__c,
                                                        genesis__Payment_Frequency__c,genesis__Draw_Term__c,
                                                        genesis__Interest_Rate__c,genesis__Product_Type__c,
                                                        genesis__Lending_Product__c,genesis__Days_Convention__c,
                                                        genesis__Expected_First_Payment_Date__c  ,
                                                        genesis__Expected_Start_Date__c,
                                                        genesis__Balloon_Payment__c,
                                                        genesis__Interest_Only_Period__c,
                                                        genesis__Bank_Account_Number__c,
                                                        genesis__Bank_Account_Type__c,
                                                        genesis__Bank_Name__c,
                                                        genesis__CL_Product__c,
                                                        Payment_Mode__c,
                                                        CL_Contract__c,
                                                        Automated_Payment_Start_Date__c,
                                                        Default_Bank_Account__c,
                                                        genesis__Routing_Number__c,
                                                        genesis__Payment_Amount__c,
                                                        genesis__Financed_Amount__c,
                                                        Debit_Frequency__c,
                                                        Debit_Amount__c,
                                                        LVR_Percent__c
                                                        from genesis__Applications__c where Id=:appId];
                                                        
        
        return application;
    }
    
     public static loan__Loan_Product__c getLoanProductDetails(String loanProductId) {
     system.debug('loanProductId'+loanProductId);
        list<clcommon__CL_Product__c> cl= [select id,name,loan__Lending_Product__c from clcommon__CL_Product__c where id=:loanProductId limit 1];
        if(cl.size()==0){
           throw new MyException('Origination Product does not exist');
        }
        String lendingProductId=cl[0].loan__Lending_Product__c;
        list<loan__Loan_Product__c> product = [select ID, Name,
            loan__Default_Interest_Rate__c,
            loan__Default_Number_of_Installments__c,
            loan__Interest_Posting_Frequency__c,
            loan__Is_Interest_Posting_Enabled__c,
            loan__Is_Capitalization_Enabled__c,
            loan__Capitalization_Frequency__c,
            loan__Fee_Set__c,
            loan__Draw_Term_Payment_Percent__c,
            loan__Repayment_Billing_Method__c,
            loan__Repayment_Term_Payment_Percent__c,
            loan__Maximum_Draw_Amount__c,
            loan__Minimum_Draw_Amount__c,
            loan__Default_Overdue_Interest_Rate__c,
            loan__Loan_Cycle_Setup__c,
            loan__Loan_Product_Type__c,
            loan__Repayment_Procedure__c,
            loan__Interest_Calculation_Method__c,
            loan__Frequency_Of_Loan_Payment__c,
            loan__Funder__c,
            loan__Funding_in_Tranches__c,
            loan__Interest_Only_Period__c,
            loan__Draw_Billing_Method__c,
            loan__Time_Counting_Method__c,
            loan__Write_off_Tolerance_Amount__c,
            loan__Pre_Bill_Days__c,
            loan__Delinquency_Grace_Days__c,
            loan__Late_Charge_Grace_Days__c,
            loan__Amortize_Balance_type__c,
            loan__Amortization_Frequency__c,
            loan__Amortization_Enabled__c,
            loan__Amortization_Calculation_Method__c,
            loan__Grace_Period_for_Repayments__c,
            Prepayment_Penalty_Value__c,
            loan__Interest_Rate_Type__c,
            loan__Floating_Rate_Index__c,
            (select ID,Name,
            loan__Default_Interest_Rate__c,
            loan__Default_Number_of_Installments__c,
            loan__Default_Overdue_Interest_Rate__c,
            loan__Fee_Set__c,
            loan__Cycle_Number__c 
            from loan__Loan_Product_Cycle__r)
            from loan__Loan_Product__c where Id=:lendingProductId];
        system.debug(Logginglevel.INFO,'Loan product '+ product );   
        
        if(product.size()==0){
           throw  new MyException('CL Loan Product does not exist');
        }
        return product[0];                             

    }      
    
    
}
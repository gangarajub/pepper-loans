/*
This Class is used to handle the pepLoandetailsPage.
Code Refactoring by Varun on August 26,2017
*/
public  class pepLoanDetailsController
{               
                      
    public String sectionValue {get;set;}       
    public boolean strSelectedValue1  {get;set;}       
    public String strSelectedValue   { get; set;}      
    public List<wrapperSection> lstWrapperSection{get;set;}
    public Integer sectionNumber{get;set;}
    public Integer questionNo   {get;set;}
    Public Id parameterMapping;
    public Integer intRequestedTerm {get;set;}
    @TestVisible private List<selectOption> lstclPurposeSelectOption; 
    public decimal decIndicativeInterestrate{get;set;}
    public String decEMI{get;set;}
    Public string googleclientip{get;set;}   
    public decimal calculatedEMI;
    public String strPaymentFrequencyLabel{get;set;}
    @TestVisible private List<selectOption> lstTermSelectOption;
    @TestVisible private List<selectOption> lstPaymentFrequency;
    @TestVisible private List<SelectOption> lstRateTypeSelectOption;
    @TestVisible private List<selectOption> lstCreditRating;
    @TestVisible public string strurl;
    @TestVisible Id idClProduct;
    public boolean isError{get;set;}  
    public genesis__Applications__c objApplication{get;set;} 
    public decimal decMinLoanAmount{get;set;}
    public decimal decmaxLoanAmount{get;set;} 
    public pepCmsModelContainer  modelConInstance{get;set;}
    public pepCmsModelContainer_new  modelConInstance_new{get;set;}
    public Integer IntcookiePageNo {get;set;}
    
    public String purposeName {get;set;}
    Public Pagereference  objNextPage; 
    public String pageName {get;set;}
    public String sectionName {get;set;}
    public Integer intNoOfPeriods;
    public Integer intCurrentPageNumber{get;set;}
    public Integer intPreviousPageNumber{get;set;}
    //For Showing Section Story On 3rd Page
    public decimal decLoanAmount{get;set;}
    public String  strLoanTenure{get;set;}
    public String  strSectionStory{get;set;}
    public String  strSectionHeader{get;set;}
    public String  strPurposeName{get;set;}
    public Id IdDefaultCompany;
    public id idBusinessAccount;
    @TestVisible private String  ReturnValue;
    @TestVisible private String referralCode;
    
    @TestVisible private Map<Id,String> MapOfPurposeIdToPurposeName;
    @TestVisible private Map<String,CL_Product_Purpose_Junction__c> productPurposeName;
    @TestVisible private Map<String,list<CL_Product_Purpose_Junction__c>> interestTypeMap;
    @TestVisible List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail;
    
    public String StrMinLoanAmount{get;set;}
    public String StrMaxLoanAmount{get;set;}
    
    public String Page_Name{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    public String decAmountPlaceHolder{get;set;}
    public String clPurposeName{get;set;}
    public String p4;
    //This class is used to fetch the cms content corresponding to the  Loan details page to render the fields on the  loan details page.

    public pepLoanDetailsController()
    {
        strurl = ApexPages.currentPage().getUrl();          
                                                                 
        if(strurl.contains('?'))
        {
            strurl = strurl.substringBefore('?');
        }
        
        strurl = strurl.split('apex/')[1];
        page_Name=ApexPages.currentPage().getUrl();//Added by KG
        page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());//Added by KG
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
        
        if(ApexPages.currentPage().getcookies().get('param4')!= null && ApexPages.currentPage().getcookies().get('param4').getvalue() != null && ApexPages.currentPage().getcookies().get('param4').getvalue()!='')
            p4 = ApexPages.currentPage().getcookies().get('param4').getvalue();
        else
            p4 = label.SecuredLabel ;  
        
                                      
        objApplication = new  genesis__Applications__c(); 
        MapOfPurposeIdToPurposeName = new Map<id,String>(); 
        productPurposeName = new Map<String,CL_Product_Purpose_Junction__c>();  
        interestTypeMap = new Map<String,list<CL_Product_Purpose_Junction__c>>();        
                                                                 
        referralCode= apexpages.currentpage().getparameters().get('Ref');
        modelConInstance_new = new pepCmsModelContainer_new();
        if(ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')!=null)
        {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); 
                                                             
        }    
        
        lstRateCardSetupDetail = new List<genesis__Rate_Card_Setup_Detail__c>();
        modelConInstance = new pepCmsModelContainer();         
        if( ApexPages.currentPage().getParameters().get('redirectFromPageNo') != null 
           &&  ApexPages.currentPage().getParameters().get('redirectFromPageNo') !='')
        {
            intPreviousPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('redirectFromPageNo'));     
            
        }
        
        intCurrentPageNumber =  1;                               
        sectionNumber=1;                                     
        lstWrapperSection = new List<wrapperSection>();
        getCookieData();
        fetchApplication();
        loadClPurpose(); 
        loadCMSContent();

        if(strurl == 'pepLoanDetails')
        {    
            FilterValues();
            fetchAllRateCard();
            loadCMSContentForLoanDetails();
            if(objApplication.id != null)
            { 
                FilterValues();
                fetchAllRateCard();
                                                  
                loadCMSContentForLoanDetails();
            }   
        } 
        loadDefaultCompany();     
                
    }
    
    //This method is used to get the value from the cookie.
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');      
        
        if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
            objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }   
    }
    //This method is used to fetch the Application corresponding to the cookie. 
    public void fetchApplication()
    {
        //hardcode application Id
                                          
        Map<string,string> childobjects = new Map<string,string>();       
        String[] lstTypes = new String[]{'Expense_and_Debt__c'};
            if(objApplication != null && objApplication.Id !=null)
        {
            
            List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
                                                                        
            if(lstApplication != null && (!lstApplication.isEmpty()))
            {        
                objApplication = lstApplication[0];
                if(objApplication.Is_Secured__c == True)
                    p4 ='SECURED' ;
                else
                    p4 =label.SecuredLabel ;
                       
            }    
        }
    }
    //This method is used to fetch the default company(Pepper Account)
    public void loadDefaultCompany()
    {
        pepDefaultCompany__c  objDefaultCompany = pepDefaultCompany__c.getInstance('Company Id');
        IdDefaultCompany = objDefaultCompany.pepDefault_Company_Id__c;
        idBusinessAccount = objDefaultCompany.pepBusinessAccount__c;
    }
    //This method is used to fetch the CL Purpose from the cloud Lending  objects.
    public void loadClPurpose()
    {
                                            
        List<clcommon__CL_Product__c> productsList = [select id,Pl_Product__c, Interest_Type__c from clcommon__CL_Product__c where PL_Product__c=:p4];
        
        lstclPurposeSelectOption = new List<selectOption>(); 
        Set<SelectOption> lstclPurposeSelectOptionSet = new Set<SelectOption>();  
        lstclPurposeSelectOptionSet.add(new SelectOption('', 'choose one'));
        
        for(CL_Product_Purpose_Junction__c objProductPurpose : [select id,CL_Product__c,CL_Product__r.Interest_Type__c,CL_Purpose__c,CL_Purpose__r.Name,Max_Loan_Amount_Delta__c,Max_Term_Delta__c,Min_Loan_Amount_Delta__c,Min_Term_Delta__c from CL_Product_Purpose_Junction__c where CL_Product__c in:productsList limit 1000])
        {                
            lstclPurposeSelectOptionSet.add(new SelectOption(objProductPurpose.CL_Purpose__c, objProductPurpose.CL_Purpose__r.Name));
            MapOfPurposeIdToPurposeName.put(objProductPurpose.CL_Purpose__c,objProductPurpose.CL_Purpose__r.Name);
            productPurposeName.put(objProductPurpose.CL_Purpose__c+':'+objProductPurpose.CL_Product__c,objProductPurpose);
            if(!interestTypeMap.containskey(objProductPurpose.CL_Purpose__c))
            {
                interestTypeMap.put(objProductPurpose.CL_Purpose__c,new List<CL_Product_Purpose_Junction__c>());
            }
            interestTypeMap.get(objProductPurpose.CL_Purpose__c).add(objProductPurpose);
        }   
        lstclPurposeSelectOption.addAll(lstclPurposeSelectOptionSet);      
    }
    
    
    //This method queries data on rate card setup detail
    //based on CL Purpose selected
    //when we fill amount it identifies the exact rate card setup details
    //Then it fetches interest rate and calculate emi.
    
    public void querydata()
    {
        
        decIndicativeInterestrate = null;
        
        decEmi =null;  
        calculatedEMI = null;
        isError = false;
        
        if(lstWrapperSection.size() >= sectionNumber && lstWrapperSection[sectionNumber-1].lstWrapperQuestion.size() >= questionNo)
        { 
            Id idClPurpose =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;                                                                     
            Integer QuesSequence = 1; 
            decimal decBorrowedAmount ;

            if(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[2].strAnswer !=null 
               && lstWrapperSection[sectionNumber-1].lstWrapperQuestion[2].strAnswer.trim() !='')
                try
            {
                decBorrowedAmount = Decimal.valueOf(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[2].strAnswer);
                             
            }
            catch(Exception exp)
            {
                pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('pepLoanDetailsController',exp)}) ;
            } 
            
            if(decBorrowedAmount >= 0 && idClPurpose != null)
            { 
                
                List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail = FilterValues();
                
                if(!(decBorrowedAmount >= decMinLoanAmount && decBorrowedAmount <= decMaxLoanAmount))
                        
                {
                    clearvalues();
                    isError = true;                                              
                } 
                                                                       
                if(lstRateCardSetupDetail != null && (!lstRateCardSetupDetail.isEmpty()))
                {          
                    for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                    {
                        if(objWrapper.objQuestion.pepFieldApiName__c =='Requested_Term__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist' 
                           && QuesSequence  > questionNo )
                        {                                                            
                            objWrapper.lstSelectOption = lstTermSelectOption;                                                                                             
                        }
                        
                        if(objWrapper.objQuestion.pepFieldApiName__c =='Debit_Frequency__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist'  
                           && QuesSequence  > questionNo )
                        {                                                        
                            objWrapper.lstSelectOption = lstPaymentFrequency;                                                                                        
                        }
                        
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__Credit_Rating__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist'  
                           && QuesSequence  > questionNo)
                        {                                                    
                            objWrapper.lstSelectOption = lstCreditRating;                                                                                         
                        }
                        
                        QuesSequence++;
                    }
                    if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c') != null && ApexPages.currentPage().getcookies().get('Requested_Term__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c') != null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c') != null){
                        
                        if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getValue() != null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getValue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getValue() != null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getValue() != null){
                            
                            FetchRateCardandCalculateEMI();
                        }
                        
                    }
                }
                else
                {              
                    isError = true;                 
                }                                                                      
                                                                                        
            }
            else
            {                                    
                clearValues();  
            }
        }
        
        if(sectionNumber == 1&& questionNo==3)
            querydata1();
                                          
    }                                                                            
    
    
    
    //This method is used to clear the selected values upon the change of the CL purpose.
    public void clearValues()
    {
                                                                
        if(sectionNumber != null && lstWrapperSection.size() >=sectionNumber)
        {
            decIndicativeInterestrate = null;
            if(ApexPages.currentPage().getcookies().get('genesisinterestrate') != null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue() != null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue() != ''){
                Cookie genesisinterestrate  = new cookie('genesisinterestrate','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{genesisinterestrate});
            }
            decEmi =null;
            if(ApexPages.currentPage().getcookies().get('debitAmount') != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue()!=null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != ''){  
                Cookie debitAmount = new cookie('debitAmount','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{debitAmount});
            }
            calculatedEMI =null;
            
            idClProduct =null;
            
            isError = false;
            for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
            {
                if(objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Purpose__c'  && objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Product__c')
                {
                                                                 
                    objWrapper.lstSelectOption = null;
                    if(questionNo != 3)
                    {                
                                                                                                 
                        objWrapper.strAnswer = null;
                    }                                 
                }                                                          
                
            }
            
        }
    }
    
    
    
    //This method is used to fetch the rate card and calculate the Int    erest.
    public void FetchRateCardandCalculateEMI()
    {
        decimal decAmount;
        decimal decyear;
        String strpaymentFreQuency;
        string strcreditRating;
        Id idClPurpose;
        String strrateType;
        
        if(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c')!= null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue() != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue()!='')
            decAmount = decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getValue().replace(',',''));
        else
            decAmount = objApplication.Requested_Loan_Amount__c;
        if(ApexPages.currentPage().getcookies().get('Requested_Term__c')!= null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue() != null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue()!='')
            decyear = decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Term__c').getValue())*12;
        else
            decyear = (objApplication.Requested_Term__c)*12;    
        if(ApexPages.currentPage().getcookies().get('Debit_Frequency__c')!= null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue() != null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue()!='')
            strpaymentFreQuency=ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getValue();
        else
            strpaymentFreQuency = objApplication.Debit_Frequency__c;    
        if(ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c')!= null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue()!='')
            strcreditRating =ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getValue();
        else
            strcreditRating = objApplication.genesis__Credit_Rating__c;    
        if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c')!= null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue()!='')
            idClPurpose = id.ValueOf(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue());
        else
            idClPurpose = objApplication.genesis__CL_Purpose__c;  
        if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c')!= null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue()!='')
            strrateType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
        else
            strrateType = objApplication.genesis__CL_Product__c;   
        
        
        if(strrateType != null && decAmount != null && decYear != null && strcreditRating != null && idClPurpose != null)
        {                                                                 
            genesis__Applications__c appObject = new genesis__Applications__c();
            //added by sushant to load some additional cookies
            appObject = loadParametersFromCookies(appObject);
            //ends here -- Sushant Kumar
            appObject.genesis__CL_Product__c = strrateType;
            appObject.genesis__CL_Purpose__c = idClPurpose;
            appObject.genesis__Credit_Rating__c = strcreditRating;
            if(ApexPages.currentPage().getcookies().get('param1')!= null && ApexPages.currentPage().getcookies().get('param1').getvalue() != null && ApexPages.currentPage().getcookies().get('param1').getvalue()!='')
                appObject.pepP1__c = ApexPages.currentPage().getcookies().get('param1').getvalue();
            if(ApexPages.currentPage().getcookies().get('param2')!= null && ApexPages.currentPage().getcookies().get('param2').getvalue() != null && ApexPages.currentPage().getcookies().get('param2').getvalue()!='')
                appObject.pepP2__c = ApexPages.currentPage().getcookies().get('param2').getvalue();
            if(ApexPages.currentPage().getcookies().get('param3')!= null && ApexPages.currentPage().getcookies().get('param3').getvalue() != null && ApexPages.currentPage().getcookies().get('param3').getvalue()!='')
                appObject.pepP3__c = ApexPages.currentPage().getcookies().get('param3').getvalue();
            if(ApexPages.currentPage().getcookies().get('param4')!= null && ApexPages.currentPage().getcookies().get('param4').getvalue() != null && ApexPages.currentPage().getcookies().get('param4').getvalue()!='')
                appObject.pepP4__c = ApexPages.currentPage().getcookies().get('param4').getvalue();
            decIndicativeInterestrate = CommonUtil.getInterestRate(appObject);
            
            if(decIndicativeInterestrate != null)
            {
                strPurposeName = MapOfPurposeIdToPurposeName.get(idClPurpose);
                
                if(decAmount != null && decIndicativeInterestrate != null
                   && decYear != null && strpaymentFreQuency != null)
                {                 
                                                                                                                                                  
                    LoanActions action = new LoanActions();
                                                                  
                    if(!Test.isRunningTest())
                        calculatedEMI   = action.calculateMonthlyPaymentAmount(decAmount, decIndicativeInterestrate ,decYear, null);
                    else{
                        calculatedEMI = 200;
                    }
                                                                                
                    if(calculatedEMI  != null)
                    {
                                                                          
                        if(strpaymentFreQuency=='weekly')
                        {
                            calculatedEMI   = ((calculatedEMI)/4) ;
                            
                        }
                        
                        else if(strpaymentFreQuency=='fortnightly')
                        {
                            calculatedEMI   = ((calculatedEMI)/2);
                            
                        }
                        
                        Decimal dollars;
                        Decimal cents;
                        dollars = calculatedEMI.intValue();
                        cents = calculatedEMI- calculatedEMI.intValue();
                        cents = cents.setScale(2);                        
                        decEMI = dollars.format() + cents.toPlainString().substring(1);
                    }
                    
                    intNoOfPeriods = pepUtilityClass.calculateNoOfPaymentsBasedOnpaymentFrequency(decYear/12 ,strpaymentFreQuency);
                                                                           
                }
                                                                                                                           
                idClProduct = strrateType;    
                                                                                  
                    
            }
            else
            {
                decEMI  =null;
                calculatedEMI  = null;
                decIndicativeInterestrate  =0;
                idClProduct =null;
                intNoOfPeriods =null;
            }
        }
        
        
    }
    //This method is used for inserting the Application. 
    public void CommonMethodForInsertingApplication()
    {
                                                             
        Decimal decAmount;
        decimal decyear;
        String strpaymentFreQuency;
        string strcreditRating;
        Id idClPurpose;
        String strProductType;
        boolean isFormFilledFully =true;
                                                                           
        if(sectionNumber != null  && lstWrapperSection.size() >= sectionNumber) 
        {     
                                                                           
            for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
            {                   
                                                                                   
                if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Purpose__c' )
                {
                    idClPurpose = objWrapper.strAnswer;                 
                                                                                             
                    if(idClPurpose  != null)
                    {                    
                        objApplication.put('genesis__CL_Purpose__c',idClPurpose);
                                                      
                    }
                    else
                    {
                        isFormFilledFully =false;
                                    
                    }
                    
                }
                
                if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' )
                {
                                                                                    
                    if(objWrapper.strAnswer!=null)
                    {
                        objApplication.put('genesis__CL_Product__c',objWrapper.strAnswer);
                                                      
                    }
                    
                    else
                    {
                        isFormFilledFully = false;            
                    }
                }            
                
                                                                         
                if(objWrapper.objQuestion.pepFieldApiName__c =='Requested_Term__c' )
                {
                    if(objWrapper.strAnswer != null &&  objWrapper.strAnswer.trim() != '' )
                    {
                        decyear = Decimal.valueof(objWrapper.strAnswer);
                        objApplication.put('Requested_Term__c',decyear);
                          
                        intNoOfPeriods = Integer.valueOf(decyear)*12;
                        objApplication.put('genesis__Term__c',intNoOfPeriods);
                        cookie yearterm=new cookie('yearterm',String.valueof(intNoOfPeriods),null,-1,false);
                        ApexPages.currentPage().setcookies(new cookie[]{yearterm});
                                                       
                    }
                    else
                    {
                        isFormFilledFully = false;           
                    }
                    
                }
                if(objWrapper.objQuestion.pepFieldApiName__c =='Requested_Loan_Amount__c' )
                {
                    if(objWrapper.strAnswer != null && objWrapper.strAnswer.trim() != '' )
                    {
                        decAmount = Decimal.valueof(objWrapper.strAnswer);
                        objApplication.put('Requested_Loan_Amount__c',decAmount);
                        objApplication.put('genesis__Loan_Amount__c',decAmount);                                
                    }
                    else
                    {
                        isFormFilledFully = false;      
                    }
                }
                
                if(objWrapper.objQuestion.pepFieldApiName__c =='Debit_Frequency__c' )
                {
                    if(objWrapper.strAnswer != null && objWrapper.strAnswer.trim() != '')
                    {                                                               
                        strpaymentFreQuency = objWrapper.strAnswer;
                        if(strpaymentFrequency.tolowercase() =='fortnightly')
                        {
                            strpaymentFrequency ='BI-WEEKLY';
                        }
                        objApplication.put('Debit_Frequency__c',strpaymentFreQuency);
                        Cookie debitFrequency=new cookie('debitFrequency',strpaymentFreQuency,null,-1,false);
                        ApexPages.currentPage().setcookies(new cookie[]{debitFrequency}); 
                    }
                    else
                    {
                        isFormFilledFully = false;
                                    
                    }
                }
                if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__Credit_Rating__c' )
                {
                    if(objWrapper.strAnswer != null &&  objWrapper.strAnswer.trim() != '')
                    {
                        strcreditRating = objWrapper.strAnswer;
                        objApplication.put('genesis__Credit_Rating__c',strcreditRating);                             
                    }
                    else
                    {
                        isFormFilledFully = false;         
                    }
                } 
            } 
        }
                                                       
                                                 
        if(isFormFilledFully == true  && objApplication.Id == null)
        {  
                                                       
            Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();
            Map<String,SObject> relatedObjects = new Map<String,SObject>();  
            objApplication.genesis__Account__c = createDummyAccount();
            objApplication.GoogleClientIP__c=googleclientip;
            if(ReturnValue!=null && ReturnValue!='')
                objApplication.IP_Address__c =  ReturnValue;
            
                                                                                   
            if(IdDefaultCompany != null)
            {
                objApplication.genesis__Company__c = IdDefaultCompany;                                                                       
            } 
            objApplication.put('genesis__Product_Type__c','Loan');
            cookie genesisproducttype=new cookie('genesisproducttype','Loan',null,-1,false);
            ApexPages.currentPage().setcookies(new cookie[]{genesisproducttype});
            objApplication.put('genesis__Interest_Rate__c',decIndicativeInterestrate);
            cookie genesisinterestrate=new cookie('genesisinterestrate',String.valueof(decIndicativeInterestrate),null,-1,false);
            ApexPages.currentPage().setcookies(new cookie[]{genesisinterestrate});
                                                  
            if(decEmi != null)
            {
                
                objApplication.put('Debit_Amount__c',calculatedEMI); // Added by IJ
                cookie debitAmount=new cookie('debitAmount',String.valueof(calculatedEMI),null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{debitAmount});
            }
            if(parameterMapping != null){
                objApplication.put('Parameters_and_Interest_Mapping__c',parameterMapping);
            }
             
            try{
                loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
                Date systemDate = util.getCUrrentSystemDate();  
                objApplication.genesis__Expected_Start_Date__c  = systemDate ;  
                objApplication.genesis__Expected_First_Payment_Date__c = systemDate.addMonths(1);  
                
                //added by : Sushant Kumar, purpose : to include apllication source information on creation of new application
                objApplication = pepUtilityClass.fillApplicationSourceInfo(objApplication);
                
                
                objApplication =  pepInvokeCLMethodHelper.insertApplication(objApplication,relatedObjects ,childObjects );
                cookie ApplicationId =new cookie('ApplicationId',objApplication.id,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{ApplicationId});
                                                                       
            }
            catch(Exception ex){
                                      
                
            }                               
            //Insert Party  
            if(objApplication !=null && objApplication.Id!=null)
            {
                // fetch business account from Custom setting
                
                clcommon__Party__c objParty =  new clcommon__Party__c(clcommon__Account__c= idBusinessAccount , genesis__Application__c= objApplication.Id);
                insert objParty;    
                if(ApexPages.currentPage().getcookies().get('param2')!= null && ApexPages.currentPage().getcookies().get('param2').getvalue() != null && ApexPages.currentPage().getcookies().get('param2').getvalue()!='')
                {
                      String partyParameter = ApexPages.currentPage().getcookies().get('param2').getvalue();
                      AddParty p = new AddParty();
                      clcommon__Party__c party = p.add(partyParameter,objApplication.Id);
                }                                                             
            }     
        }
        
        else
        {
            if(objApplication.Id != null)
            {
                // Added by IJ
                
                objApplication.put('genesis__Interest_Rate__c',decIndicativeInterestrate);
                cookie genesisinterestrate=new cookie('genesisinterestrate',String.valueof(decIndicativeInterestrate),null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{genesisinterestrate});
                objApplication.put('Debit_Amount__c',calculatedEMI);
                cookie debitAmount=new cookie('debitAmount',String.valueof(calculatedEMI),null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{debitAmount});                  
                // Added by IJ
                
                Map<String,SObject> relatedObjects = new Map<String,SObject>();
                Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();      

                //added by : Sushant Kumar, purpose : to include apllication source information on creation of new application
                objApplication = pepUtilityClass.fillApplicationSourceInfo(objApplication);
                
                objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
            }
        }

    }
    
   
    //This method creates dummy person Account
    public Id createDummyAccount()
    {
        if(referralCode!=null && referralCode!='')
        {
            List<Account> acc=[select id from account where Referred_By_Code__c=:referralCode];
            return acc[0].id;
        }
        else
        {
            list<Portal_OwnerId__c> LstPortalOwner = Portal_OwnerId__c.getAll().Values();
            Id TemplateId = Id.valueOf(LstPortalOwner[0].Owner_Id__c);
            Account objAccount = new Account();            
            objAccount.LastName ='DUMMY';
            objAccount.OwnerId = TemplateId ;
            objAccount.recordTypeId = pepUtilityClass.getRecordTypeId('Account','Person Account');
            insert objAccount;
            return objAccount.Id;
        }
        return null;
        
    }
    
    
    
    
    @TestVisible  private void loadCMSContentForLoanDetails()
    {
        if(objApplication.id == null)
            loadapplicationfromcookie();
        strurl = 'peploandetails';
        
                                                                                                                                 
        lstWrapperSection = new List<WrapperSection>();
         
        List<pepCmsSection__c> lstlandingPageCmsSection =[select id,pepHeader__c,pepSectionUniqueName__c,
                                                          pepSectionStory__c,
                                                          (select id,pepLabelAfterQuestion__c,
                                                           pepLabelPriorQuestion__c,
                                                           pepSequence__c,
                                                           pepType__c,
                                                           pepGenericErrorMessage__c,
                                                           pepIsRequired__c,
                                                           pepSObjectApiName__c,
                                                           pepFieldApiName__c
                                                           from pepQuestion__r order by pepSequence__c asc) 
                                                          from pepCmsSection__c where pepPage__r.pepPageName__c ='Loan Details' order by pepSequence__c];           
        
                                                                                   
        
        if(lstlandingPageCmsSection != null && (!lstlandingPageCmsSection.isEmpty()))
        {
            strSectionStory  =  lstlandingPageCmsSection[0].pepSectionStory__c;
            strSectionHeader =  lstlandingPageCmsSection[0].pepHeader__c;
            for(pepCmsSection__c objSection :lstlandingPageCmsSection)
            {
                if(objSection.pepQuestion__r != null && (!objSection.pepQuestion__r.isEmpty()))
                {                      
                                                                                                                  
                    wrapperSection objWrapperSection = new wrapperSection();
                    objWrapperSection.objSection = objSection ;
                    objWrapperSection.lstWrapperQuestion = new List<wrapperApplication>();
                    for(pepCmsQuestion__c objQues : objSection.pepQuestion__r)
                    { 
                        
                        wrapperApplication objWrapper = new  wrapperApplication ();
                        objWrapper.objQuestion = objQues;
                               
                        if(objQues.pepFieldApiName__c =='Requested_Loan_Amount__c' 
                           && objApplication != null 
                           && objQues.pepType__c == 'Currency' 
                           && objApplication.Requested_Loan_Amount__c != null) 
                            
                        {
                            objwrapper.strAnswer = String.valueOf(objApplication.Requested_Loan_Amount__c); 
                        }
                              
                        if(objQues.pepFieldApiName__c =='Requested_Term__c' &&  objQues.pepType__c == 'Picklist')
                        {
                                      
                            if(lstTermSelectOption != null)
                            {   
                                list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                                lstSOTemp  = lstTermSelectOption; 
                                lstTermSelectOption =new list<SelectOption>(); 
                                
                                for (SelectOption so : lstSOTemp  ){
                                    
                                    if (so.getValue() == '' || so.getValue() == 'choose one' ){
                                        so.setLabel('choose one');
                                        so.setValue('');
                                    }
                                    lstTermSelectOption.add(so);
                                }
                                                                                                                                   
                                objWrapper.lstSelectOption = lstTermSelectOption ;
                            }
                            if(objApplication != null && objApplication.Requested_Term__c != null )
                            {                                                                                                 
                                intRequestedTerm = Integer.valueOF(objApplication.Requested_Term__c);
                                objwrapper.strAnswer = String.valueOf(intRequestedTerm);
                            }
                            
                        }
                        
                        if(objQues.pepFieldApiName__c =='Debit_Frequency__c' &&  objQues.pepType__c == 'Picklist' )
                        {                                                                     
                            list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                            if(lstPaymentFrequency!=null)
                            {
                                lstSOTemp  = lstPaymentFrequency;
                                lstPaymentFrequency =new list<SelectOption>(); 
                                for (SelectOption so : lstSOTemp  ){
                                                                                                 
                                    if (so.getValue() == '' ||  so.getValue() == 'choose one'){
                                        so.setLabel('choose one');
                                        so.setValue('');
                                    }
                                    lstPaymentFrequency.add(so);
                                }
                            }
                            objWrapper.lstSelectOption = lstPaymentFrequency;
                            if(objApplication != null && objApplication.Debit_Frequency__c != null) 
                            {
                                //modified by : sushant kumar
                                objwrapper.strAnswer = (objApplication.Debit_Frequency__c == 'BI-WEEKLY')?
                                                        'fortnightly' : objApplication.Debit_Frequency__c.tolowercase();
                                
                                                                                                   
                            } 
                                        
                        }
                        
                        if(objQues.pepFieldApiName__c =='genesis__Credit_Rating__c' && objQues.pepType__c == 'Picklist' )
                        {
                                                                                                 
                            list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                            if(lstCreditRating!=null)
                            {
                                lstSOTemp  = lstCreditRating;
                                lstCreditRating=new list<SelectOption>();
                                for (SelectOption so : lstSOTemp  ){
                                                                                                 
                                    if (so.getValue() == ''){
                                        so.setLabel('choose one');
                                    }
                                    lstCreditRating.add(so);
                                }
                            }
                            objWrapper.lstSelectOption = lstCreditRating;
                            if(objApplication != null && objApplication.genesis__Credit_Rating__c != null)
                                objwrapper.strAnswer = objApplication.genesis__Credit_Rating__c; 
                        }
                        
                        if(objQues.pepFieldApiName__c =='genesis__CL_Purpose__c' && objQues.pepType__c == 'Picklist' )
                        {
                                                                                                          
                            list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                            if(lstclPurposeSelectOption!=null)
                            {
                                lstSOTemp  = lstclPurposeSelectOption;
                                lstclPurposeSelectOption=new list<SelectOption>();
                                for (SelectOption so : lstSOTemp  ){
                                                                                                 
                                    if (so.getValue() == ''){
                                        so.setLabel('choose one');
                                    }
                                    lstclPurposeSelectOption.add(so);
                                }
                            }
                            objWrapper.lstSelectOption = lstclPurposeSelectOption; 
                            if(objApplication != null && objApplication.genesis__CL_Purpose__c != null)
                                objwrapper.strAnswer = objApplication.genesis__CL_Purpose__c;                                 
                        }
                        
                        if(objQues.pepFieldApiName__c =='genesis__CL_Product__c' && objQues.pepType__c == 'Picklist' )
                        {                                                                            
                            list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                            if(lstRateTypeSelectOption!=null)
                            {
                                lstSOTemp  = lstRateTypeSelectOption;
                                lstRateTypeSelectOption=new list<SelectOption>();
                                for (SelectOption so : lstSOTemp  ){
                                                                                                 
                                    if (so.getValue() == ''){
                                        so.setLabel('choose one');
                                    }
                                    lstRateTypeSelectOption.add(so);
                                }
                                
                            }
                            objWrapper.lstSelectOption = lstRateTypeSelectOption;
                            if(objApplication != null && objApplication.genesis__CL_Product__c != null)
                            {  
                                objwrapper.strAnswer = objApplication.genesis__CL_Product__c;
                            }                                 
                        }
                        objWrapperSection.lstWrapperQuestion.add(objWrapper);                                                    
                    }         
                    lstWrapperSection.add(objWrapperSection);
                }
                   
            }    
        }                                                                 
         
    }
    //This class is used to hold the single instance of the Section for the Loan Details page which require inputs from the user. 
    public class wrapperApplication
    {
        public pepCmsQuestion__c objQuestion{get;set;} 
        public List<wrapperAnswer> lstExpectedAnswers {get; set;}//answer of question    
                                               
        public List<selectoption> lstSelectOption{get;set;}
        public String strAnswer
        {
            get { return strAnswer; }
            
            set {
                strAnswer = (objQuestion.pepType__c =='Currency' && value != null)? strAnswer= value.replace(',','') : value;                                         
            }
                         
        }
        
    }
    
    public class wrapperSection
    {
        public pepCmsSection__c  objSection{get;set;}
        public List<wrapperApplication> lstWrapperQuestion{get;set;}
    }
    
    public class wrapperAnswer
    {
        public pepCmsAnswer__c objCmsAnswer {get; set;}
    }
    //This method is used to query dynamically  the rate card. 
    public List<genesis__Rate_Card_Setup_Detail__c > FilterValues()
    {
           
                                   
        Decimal decAmount;
        decimal decyear;
        String strpaymentFreQuency;
        string strcreditRating;
        Id idClPurpose;
        String strProductType;
        string strPageName;
        map<id, pepCmsSection__c> mapSections;
        List<pepCmsQuestion__c> lstQuestions;
        list<clcommon__CL_Product__c> lstCLProd;
        
        lstCLProd = [select id,clcommon__Product_Name__c,Interest_Type__c from clcommon__CL_Product__c where PL_Product__c=:p4];
        
                                                                  
        lstPaymentFrequency = new List<selectOption>(); 
        
        if(strurl == 'peplandingpage' )
        {                                                            
            strPageName = 'Landing Page';
            lstPaymentFrequency.add(new selectOption('',''));  
        }                
        else
        {                                                                                        
            strPageName = 'Loan Details';                                                                      
        }
                                                                                                                                       
        if(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != '')
            idClPurpose =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;
        if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() !=''){  
            idClPurpose = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue();
            lstWrapperSection[0].lstWrapperQuestion[0].strAnswer= ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue();
            
        }
        
        mapSections = new map<id, pepCmsSection__c>([SELECT pepHeader__c,pepPage__c, pepSectionBody__c, Name, pepSectionUniqueName__c, pepType__c, 
                                                                               pepSectionStory__c , Page_Name__c  ,pepSectionStoryRich__c,pepSectionBodyRich__c
                                                                               from pepCmsSection__c
                                                                               where pepPage__r.pepPageName__c=: strPageName
                                                                               order by pepSequence__c]);
        
        lstQuestions = [SELECT Id,Is_Date_to_Birth__c, pepSection__c,pepSection__r.Name ,pepSection__r.pepSectionUniqueName__c , pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, pepRecordSequence__c,
                                                pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, pepNumbersOnly__c, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, 
                                                pepGoogleApi__c,                                                
                                                (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                 FROM pepCmsAnswer__r order by pepSequence__c ASC)
                                                
                                                FROM pepCmsQuestion__c
                                                WHERE pepSection__c in: mapSections.values()
                                                
                                                ORDER BY pepSequence__c ASC];
        
        
                                                          
                                                         
        if(lstQuestions!=null && (!lstQuestions.isEmpty()))
        {
            for(pepCmsQuestion__c objCMSQ: lstQuestions)
            {
                                                                                                                
                if((objCMSQ.pepSection__r.pepSectionUniqueName__c == 'LandingPageSection1'|| objCMSQ.pepSection__r.pepSectionUniqueName__c == 'LoanDetailsSection1') &&  objCMSQ.pepFieldApiName__c == 'Debit_Frequency__c')
                {
                                                              
                    for(pepCmsAnswer__c objAns: objCMSQ.pepCmsAnswer__r)
                    {
                        if(!(strurl == 'peplandingpage' && objAns.pepDisplayText__c.tolowerCase()== 'choose one' ))
                        {// do nothing 
                                 
                             
                            if(objAns.pepDisplayText__c.tolowerCase()== 'choose one')
                                lstPaymentFrequency.add(new selectOption('',objAns.pepDisplayText__c));
                            else
                                lstPaymentFrequency.add(new selectOption(objAns.pepDisplayText__c,objAns.pepDisplayText__c));
                        }
                    }
                }           
            }
            
        }
        
        if(lstWrapperSection[0].lstWrapperQuestion[1].strAnswer != null 
           && lstWrapperSection[0].lstWrapperQuestion[1].strAnswer.trim() !=''
           || (1 < questionNo ) || (ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c') != null && strPageName == 'Loan Details') )
        {           
            if(lstWrapperSection[0].lstWrapperQuestion[2].strAnswer !=null && lstWrapperSection[0].lstWrapperQuestion[2].strAnswer !=''){
                decAmount =  Decimal.ValueOF(lstWrapperSection[0].lstWrapperQuestion[2].strAnswer);
                decLoanAmount = decAmount;
            }
            else if(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c') != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue() != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue()!=''){
                decAmount=Decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue().replace(',','')); 
                decLoanAmount = decAmount;
                lstWrapperSection[0].lstWrapperQuestion[2].strAnswer=ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue();
            }
        }
        if(lstWrapperSection[0].lstWrapperQuestion[1].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[1].strAnswer != '')
            strProductType =  lstWrapperSection[0].lstWrapperQuestion[1].strAnswer;
        else if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c')!=null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue()!=null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue()!=''){
            strProducttype=ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue();
            lstWrapperSection[0].lstWrapperQuestion[1].strAnswer=ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue();
        }
        
        if(lstWrapperSection[0].lstWrapperQuestion[3].strAnswer != null && (3 < questionNo ))
        {
            
            if(lstWrapperSection[0].lstWrapperQuestion[3].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[3].strAnswer !=''){
                decyear =  Decimal.valueOf(lstWrapperSection[0].lstWrapperQuestion[3].strAnswer)*12;
                strLoanTenure = String.ValueOf(decyear/12);
            }
            else if(ApexPages.currentPage().getcookies().get('Requested_Term__c')!=null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue()!=null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue()!=''){
                decyear =  Decimal.valueOf(ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue())*12;
                strLoanTenure = String.ValueOf(decyear/12);
                lstWrapperSection[0].lstWrapperQuestion[3].strAnswer=ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue();
            }
        }
        
        if(lstWrapperSection[0].lstWrapperQuestion[4].strAnswer != null && 4 < questionNo )
        {
            strpaymentFreQuency =  lstWrapperSection[0].lstWrapperQuestion[4].strAnswer;
        }
        else if(ApexPages.currentPage().getcookies().get('Debit_Frequency__c') != null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue() != ''){
            strpaymentFreQuency =ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue();
            lstWrapperSection[0].lstWrapperQuestion[4].strAnswer=ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue();
        }
        if(lstWrapperSection[0].lstWrapperQuestion[5].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[5].strAnswer !='' && 5 < questionNo  )
        {
            strcreditRating =  lstWrapperSection[0].lstWrapperQuestion[5].strAnswer;
        }
        else if(ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c') != null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue() != ''){
            strcreditRating =ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue();
            lstWrapperSection[0].lstWrapperQuestion[5].strAnswer=ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue();
        }    
        
        string strQuery =  'Select Id , genesis__Minimum_Financed_Amount__c, genesis__Min_Term__c, genesis__Max_Term__c, genesis__Credit_Rating__c,'; 
        strQuery += 'genesis__Credit_Rating__r.Name,genesis__Maximum_Financed_Amount__c, genesis__Payment_Frequency__c, genesis__Interest_Rate__c '; 
        strQuery += ' from genesis__Rate_Card_Setup_Detail__c where id !=null';
        
                                                             
                                                                
        strQuery += ' AND genesis__Rate_Card_Setup_Header__r.Type__c = '+'\''+'Pre Credit Check'+'\'';
        if(idCLPurpose != null)
        {
            strQuery += ' and genesis__Rate_Card_Setup_Header__r.CL_Purpose__c  =:idClPurpose';
        }
        
        if(decAmount != null)
        {
            strQuery += ' and genesis__Minimum_Financed_Amount__c <=:decAmount';
            strQuery += ' and genesis__Maximum_Financed_Amount__c >=:decAmount';
        }
        
        if(strpaymentFreQuency  != null)
        {
            string str= 'monthly';
            strQuery += ' and genesis__Payment_Frequency__c   =:str';
        }
        if(decYear != null)
        {
            strQuery += ' and genesis__Min_Term__c  <=:decYear';
            strQuery += ' and genesis__Max_Term__c  >=:decYear';
        }
                      
        strQuery +=  ' order by genesis__Credit_Rating__r.Serial_No__c asc limit 50000';  
                                                                                                             
        lstRateCardSetupDetail = database.query(strQuery);
        
                                                                                          
        if(lstRateCardSetupDetail != null && (!lstRateCardSetupDetail.isEmpty()))
        {
            //make year picklist
                                                      
            lstTermSelectOption = new List<selectOption>();
            if(strurl == 'peplandingpage' )
                lstTermSelectOption.add(new selectOption('',''));                        
            else
                lstTermSelectOption.add(new selectOption('','choose one'));
                          
                                                                                                         
            lstCreditRating = new List<selectOption>(); 
            if(strurl == 'peplandingpage' )
                lstCreditRating.add(new selectOption('',''));                         
            else
                lstCreditRating.add(new selectOption('','choose one'));  
            set<String> struniquepaymentfrequecnySet = new set<String>();
            set<String> struniquecreditratingSet = new set<String>();
            
            Integer intMinYear;
            Integer intMaxYear;    
            
                                                                                               
            for(genesis__Rate_Card_Setup_Detail__c objratecardDetail : lstRateCardSetupDetail)
            {                                                                                                                                    
                if(objratecardDetail.genesis__Min_Term__c != null 
                   && objratecardDetail.genesis__Max_Term__c != null) 
                {                                                                                 
                    if(intMinYear == null && intMaxYear == null)
                    {
                                                                                                         
                        intMinYear = Integer.valueOF(objratecardDetail.genesis__Min_Term__c/12);
                        intmaxYear = Integer.valueOf(objratecardDetail.genesis__Max_Term__c/12);
                    }
                    
                    else
                    {
                        if(objratecardDetail.genesis__Min_Term__c < intMinYear )
                        {
                            intMinYear = Integer.valueOF(objratecardDetail.genesis__Min_Term__c/12);
                        }
                        
                        if(objratecardDetail.genesis__Max_Term__c > intmaxYear)
                        {
                            intmaxYear  = Integer.valueOF(objratecardDetail.genesis__Max_Term__c/12 );
                        }
                    }
                }
                
                if(objratecardDetail.genesis__Credit_Rating__c != null)
                {
                    if((ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '') ||(objApplication.id!=null))
                    {
                        if((!struniquecreditratingSet.contains(objratecardDetail.genesis__Credit_Rating__c)))
                            lstCreditRating.add(new selectOption(objratecardDetail.genesis__Credit_Rating__c,objratecardDetail.genesis__Credit_Rating__r.name));
                        //lstCreditRating.sort();
                    }
                }
                struniquepaymentfrequecnySet.add(objratecardDetail.genesis__Payment_Frequency__c);
                struniquecreditratingSet.add(objratecardDetail.genesis__Credit_Rating__c);
            }
            if((ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null) ||(objApplication.id!=null))
            {
                if(intMinYear != null && intmaxYear != null)
                {                                                               
                    String purposeId;
                    String interestType;
                    if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '')
                        purposeId = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue();
                    else
                        purposeId = objApplication.genesis__CL_Purpose__c;
                    if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '')
                        interestType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
                    else
                        interestType = objApplication.genesis__CL_Product__c;    
                    
                    if(productPurposeName.containsKey(purposeId+':'+interestType) && productPurposeName.get(purposeId+':'+interestType).Min_Term_Delta__c!=null)
                        intMinYear = intMinYear + integer.valueOf(productPurposeName.get(purposeId+':'+interestType).Min_Term_Delta__c);
                    if(productPurposeName.containsKey(purposeId+':'+interestType) && productPurposeName.get(purposeId+':'+interestType).Max_Term_Delta__c!=null)
                        intmaxYear = intmaxYear + integer.valueOf(productPurposeName.get(purposeId+':'+interestType).Max_Term_Delta__c);
                    for(integer i = intMinYear ; i <=intmaxYear ; i++)
                    {
                        lstTermSelectOption.add(new selectOption(String.valueOf(i),String.ValueOf(i)));
                    }
                    
                }
                
            }   
        }       
        return  lstRateCardSetupDetail;
    }
    
    
    
    
    //This method is used to call the Apply now Page on the click of back link on 3rd page.   
    public PageReference BackOnApplyPage() {
        //try catch added by sushant kumar to handle the redirection on Exception Page.
        try
        {
            string redircetPageName= pages_config__c.getinstance('pepapplynow').Page_Label__c;
        
            pageReference objPreviousPage = new Pagereference('/'+redircetPageName); 
            objPreviousPage.setRedirect(false);
            return objPreviousPage ;
        }
        catch(Exception ex)
        {
            return pepUtilityClass.handlePageException(ex);
        }
        
    }    
    
    //This method is used to save application on Loan Details page on the click of Continue button    
    public pageReference continueOnIncomePage()
    {
        //try catch added by sushant kumar
        try {
            // Added by IJ
            if(ApexPages.currentPage().getcookies().get('param1')!= null && ApexPages.currentPage().getcookies().get('param1').getvalue() != null && ApexPages.currentPage().getcookies().get('param1').getvalue()!='')
                objApplication.pepP1__c = ApexPages.currentPage().getcookies().get('param1').getvalue();
            if(ApexPages.currentPage().getcookies().get('param2')!= null && ApexPages.currentPage().getcookies().get('param2').getvalue() != null && ApexPages.currentPage().getcookies().get('param2').getvalue()!='')
                objApplication.pepP2__c = ApexPages.currentPage().getcookies().get('param2').getvalue();
            if(ApexPages.currentPage().getcookies().get('param3')!= null && ApexPages.currentPage().getcookies().get('param3').getvalue() != null && ApexPages.currentPage().getcookies().get('param3').getvalue()!='')
                objApplication.pepP3__c = ApexPages.currentPage().getcookies().get('param3').getvalue();
            if(ApexPages.currentPage().getcookies().get('param4')!= null && ApexPages.currentPage().getcookies().get('param4').getvalue() != null && ApexPages.currentPage().getcookies().get('param4').getvalue()!='')
                objApplication.pepP4__c = ApexPages.currentPage().getcookies().get('param4').getvalue();
            
            //Code block ends - IJ      
            FetchRateCardandCalculateEMI();
            String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepIncomePage');
            objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
            objApplication.Apply_page_policy__c =  true;
            if(objApplication.Apply_page_policy_time_stamp__c==null)
                objApplication.Apply_page_policy_time_stamp__c =  dateTime.Now();
            
            
            if(objApplication.pepCurrent_Page__c == null)
            {
                objApplication.pepCurrent_Page__c = 2;
            }                                     
            CommonMethodForInsertingApplication();
            Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
            objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false); 
            
            string redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
            pageReference objNextPage = new Pagereference('/'+redircetPageName);
            objNextPage.setCookies(new Cookie[]{objCookie}); 
            
            objNextPage.setRedirect(true); 
            return objNextPage;
        }
        catch(Exception ex) {
            
            return pepUtilityClass.handlePageException(ex);
        }        
    }
    //This method is used to redirect to RetrieveApp page.
    public pageReference retrieveAppCode()
    {
        //try catch added by sushant kumar
        try
        {
            string redircetPageName= pages_config__c.getinstance('pepretrieveapp').Page_Label__c;
            pageReference p1 = new Pagereference('/'+redircetPageName);
            p1.setRedirect(true); 
            return p1; 
        }
        catch(Exception ex)
        {
            return pepUtilityClass.handlePageException(ex);
        }
             
    }
    //This method is used to fetch the rare cards.
    public void fetchAllRateCard()
    {
        
                                                   
        if((ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null
            && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '' && 
            ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '' )
           ||(objApplication.Id !=null && questionNo!=1 && questionNo!=2))
        { 
            
            Id idCLPurpose;
            if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '')
                idClPurpose = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue();
            else
                idClPurpose = objApplication.genesis__CL_Purpose__c;
            clPurposeName  =  MapOfPurposeIdToPurposeName.get(idClPurpose);
                                                      
            decMinLoanAmount = 0;
            decmaxLoanAmount = 0; 
            decAmountPlaceHolder ='';
            StrMinLoanAmount ='';
            StrMaxLoanAmount ='';
            List<AggregateResult> lstRateCardSetupDetail =[select 
                                                           MIN(genesis__Minimum_Financed_Amount__c) minVal,  
                                                           MAX(genesis__Maximum_Financed_Amount__c) maxVal                                                              
                                                           
                                                           from genesis__Rate_Card_Setup_Detail__c
                                                           where genesis__Rate_Card_Setup_Header__r.CL_Purpose__c =:idClPurpose
                                                           AND genesis__Rate_Card_Setup_Header__r.Type__c = 'Pre Credit Check' 
                                                          ];
            
            
            if(lstRateCardSetupDetail != null && (!lstRateCardSetupDetail.isEmpty()))
            {
                String interestType;
                                                                                        
                if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '')
                    interestType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
                else
                    interestType = objApplication.genesis__CL_Product__c;
                decMinLoanAmount=(decimal)lstRateCardSetupDetail[0].get('minVal');
                decmaxLoanAmount=(decimal)lstRateCardSetupDetail[0].get('maxVal');
                if(productPurposeName.containsKey(idClPurpose+':'+interestType) && productPurposeName.get(idClPurpose+':'+interestType).Min_Loan_Amount_Delta__c!=null)
                    decMinLoanAmount = decMinLoanAmount +(productPurposeName.get(idClPurpose+':'+interestType).Min_Loan_Amount_Delta__c); 
                if(productPurposeName.containsKey(idClPurpose+':'+interestType) && productPurposeName.get(idClPurpose+':'+interestType).Max_Loan_Amount_Delta__c!=null)
                    decmaxLoanAmount = decmaxLoanAmount +(productPurposeName.get(idClPurpose+':'+interestType).Max_Loan_Amount_Delta__c);
                if(decMinLoanAmount==null)
                    decMinLoanAmount=0;
                if(decmaxLoanAmount==null)
                    decmaxLoanAmount=0;
                                                                                
                StrMinLoanAmount =String.ValueOf(decMinLoanAmount.format());
                StrMaxLoanAmount =String.ValueOf(decmaxLoanAmount.format());
                decAmountPlaceHolder = StrMinLoanAmount +'-'+StrMaxLoanAmount;
                
            }
            if(questionNo!=2)
            {
                Set<SelectOption> lstRateTypeSelectOptionSet = new Set<SelectOption>();
                lstRateTypeSelectOption = new List<SelectOption>(); 
                lstRateTypeSelectOptionSet.add(new SelectOption('', 'choose one'));
                for(CL_Product_Purpose_Junction__c objProductPurpose : interestTypeMap.get(idClPurpose))
                {
                    lstRateTypeSelectOptionSet.add(new selectOption(objProductPurpose.CL_Product__c,objProductPurpose.CL_Product__r.Interest_Type__c));
                }
                lstRateTypeSelectOption.addAll(lstRateTypeSelectOptionSet);
                for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                {
                                                                           
                                                                                                    
                    if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                       && objWrapper.objQuestion.pepType__c == 'Picklist') 
                        
                    {
                                                                                                
                        objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                        if(lstRateTypeSelectOption != null && (!lstRateTypeSelectOption.isEmpty())){
                            objWrapper.strAnswer = lstRateTypeSelectOption[0].getvalue();  
                        }                              
                    }   
                } 
            }     
            clearValues();
        }
        
        else
        {
            if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '')
            {
                
                String  purposeId = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue();
                
                Set<SelectOption> lstRateTypeSelectOptionSet = new Set<SelectOption>();
                lstRateTypeSelectOption = new List<SelectOption>(); 
                lstRateTypeSelectOptionSet.add(new SelectOption('', 'choose one'));
                for(CL_Product_Purpose_Junction__c objProductPurpose : interestTypeMap.get(purposeId))
                {
                    lstRateTypeSelectOptionSet.add(new selectOption(objProductPurpose.CL_Product__c,objProductPurpose.CL_Product__r.Interest_Type__c));
                }
                lstRateTypeSelectOption.addAll(lstRateTypeSelectOptionSet);
                for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                {
                                                                           
                                                                                                    
                    if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                       && objWrapper.objQuestion.pepType__c == 'Picklist') 
                        
                    {                                                                     
                        objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                        if(lstRateTypeSelectOption != null && (!lstRateTypeSelectOption.isEmpty())){
                            objWrapper.strAnswer = lstRateTypeSelectOption[0].getvalue();  
                        }                              
                    }   
                }
            }
            else
            {
                lstRateTypeSelectOption = new List<SelectOption>();
                lstRateTypeSelectOption.add(new SelectOption('', 'choose one'));
                for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                {                                                                          
                    if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                       && objWrapper.objQuestion.pepType__c == 'Picklist') 
                        
                    {                                                                     
                        objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                        if(lstRateTypeSelectOption != null && (!lstRateTypeSelectOption.isEmpty())){
                            objWrapper.strAnswer = lstRateTypeSelectOption[0].getvalue();  
                        }                              
                    }   
                }
            }
            decAmountPlaceHolder ='';
            clearValues();
        }
        
    }
    
    
    //This method is used to  render the SectionStory.
    public void renderSectionStory()
    {
        
        List<pepCmsSection__c> lstlandingPageCmsSection =[select id,pepHeader__c,pepSectionUniqueName__c,
                                                          pepSectionStory__c,
                                                          (select id,pepLabelAfterQuestion__c,
                                                           pepLabelPriorQuestion__c,
                                                           pepSequence__c,
                                                           pepType__c,
                                                           pepGenericErrorMessage__c,
                                                           pepIsRequired__c,
                                                           pepSObjectApiName__c,
                                                           pepFieldApiName__c
                                                           from pepQuestion__r order by pepSequence__c asc) 
                                                          from pepCmsSection__c where pepPage__r.pepPageName__c ='Loan Details'and 
                                                          pepSectionUniqueName__c='LoanDetailsSection1'];           
        
        
        
        if(lstlandingPageCmsSection != null && (!lstlandingPageCmsSection.isEmpty()))
        {
            strSectionStory  =  lstlandingPageCmsSection[0].pepSectionStory__c;
        }
        if(objApplication.genesis__CL_Purpose__c != null)
        { 
            strPurposeName =  MapOfPurposeIdToPurposeName.get(objApplication.genesis__CL_Purpose__c);
        }
        
        if(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != null)
        {
            strPurposeName =  MapOfPurposeIdToPurposeName.get(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer);
        }
        
        if(lstWrapperSection[0].lstWrapperQuestion[4].strAnswer != null)
        {
            strPaymentFrequencyLabel = lstWrapperSection[0].lstWrapperQuestion[4].strAnswer;
          
          
        }
        else if(objApplication.Debit_Frequency__c != null)
        {
            strPaymentFrequencyLabel = (objApplication.Debit_Frequency__c == 'BI-WEEKLY')? 'fortnightly' : objApplication.Debit_Frequency__c.tolowercase();
        }
        
        if(lstWrapperSection[0].lstWrapperQuestion[3].strAnswer != null)
        {
            strLoanTenure =  lstWrapperSection[0].lstWrapperQuestion[3].strAnswer;
        }          
        
        else if(objApplication.Requested_Term__c != null)
        {
            strLoanTenure = String.valueOf(objApplication.Requested_Term__c);
        }
        if(decLoanAmount != null)
        {
            strSectionStory = strSectionStory.replace('{loanAmount}', String.valueOf(decLoanAmount.format()));
        }
        
        if(strPurposeName != null)
        {
            strSectionStory = strSectionStory.replace('{loanPurpose}',strPurposeName);
        }
        if(strPaymentFrequencyLabel != null)
        {
            strSectionStory = strSectionStory.replace('{loanFrequency}',strPaymentFrequencyLabel);
        }
        if(strLoanTenure != null)
        {
            strSectionStory = strSectionStory.replace('{loanTenure}', strLoanTenure);
        }
        
        
    }
    
    
    //This method is used to redirect to generic redirection page if cookie does not exist.
    Public Static Pagereference checkCookieAndRedirect(){
        //try catch added by sushant kumar
        try {
            if(ApexPages.currentPage().getcookies().get('ApplicationId') != null){
            
                if(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != null && ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != '')
                {
                    string redircetPageName= pages_config__c.getinstance('pepcontract').Page_Label__c;
                    Pagereference pg=new Pagereference('/'+redircetPageName);
                    pg.setRedirect(true);
                    return pg;
                }
                
            } 
            return null;
        }
        catch(Exception ex) 
        {
            return pepUtilityClass.handlePageException(ex);
        }
    }
    //This method is used  to load the application from the cookie.
    Public  void loadApplicationfromcookie(){
        if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() != '')
            objApplication.genesis__CL_Purpose__c=ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue();
        if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue() != '')
            objApplication.genesis__CL_Product__c=ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getvalue();
        if(ApexPages.currentPage().getcookies().get('Requested_Term__c') != null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue() != null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue() != '')
            objApplication.Requested_Term__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Term__c').getvalue());
        if(ApexPages.currentPage().getcookies().get('yearterm') != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != '')
            objApplication.genesis__Term__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('yearterm').getvalue());
        if(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c') != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue() != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue() != ''){
            objApplication.Requested_Loan_Amount__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue().replace(',',''));
            objApplication.genesis__Loan_Amount__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue().replace(',',''));
        } 
        if(ApexPages.currentPage().getcookies().get('Debit_Frequency__c') != null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue() != null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue() != '')
            objApplication.Debit_Frequency__c=ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getvalue();
        if(ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c') != null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue() != '')
            objApplication.genesis__Credit_Rating__c=ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getvalue();
        if(ApexPages.currentPage().getcookies().get('genesisinterestrate') != null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue() != null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue() != '')
            objApplication.genesis__Interest_Rate__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue());
        if(ApexPages.currentPage().getcookies().get('genesisproducttype') != null && ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue() != null && ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue() != '')
            objApplication.genesis__Product_Type__c=ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue();
        if(ApexPages.currentPage().getcookies().get('debitAmount') != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != '')
            objApplication.Debit_Amount__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('debitAmount').getvalue());
        if(ApexPages.currentPage().getcookies().get('ipAddress') != null && ApexPages.currentPage().getcookies().get('ipAddress').getvalue() != null && ApexPages.currentPage().getcookies().get('ipAddress').getvalue() != '')
            objApplication.IP_Address__c=ApexPages.currentPage().getcookies().get('ipAddress').getvalue();
        if(ApexPages.currentPage().getcookies().get('existingcustomer') != null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue() != null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue() != '')
            objApplication.Existing_Customer__c=ApexPages.currentPage().getcookies().get('existingcustomer').getvalue();
        
        //Added By : Sushant kumar
        //if genesis application field values are provided via parameters on applyNow page and/or source information
        //of application is provided on applyNow page or landing page, below method will load data.
        objApplication = loadParametersFromCookies(objApplication);
        
    }
    //This method is used to render the section on the LoanDetails Page.
    private void loadCMSContent()
    {                  
        List<pepCmsSection__c> lstlandingPageCmsSection =[select id,pepHeader__c,pepSectionUniqueName__c,
                                                          (select id,pepLabelAfterQuestion__c,
                                                           pepLabelPriorQuestion__c,
                                                           pepSequence__c,
                                                           pepType__c,
                                                           pepGenericErrorMessage__c,
                                                           pepSObjectApiName__c,
                                                           pepFieldApiName__c,
                                                           pepLabel_After_Question_New__c
                                                           from pepQuestion__r order by pepSequence__c asc) 
                                                          from pepCmsSection__c where pepPage__r.pepPageName__c ='Landing Page' order by pepSequence__c asc];   
        
        
        if(lstlandingPageCmsSection != null && (!lstlandingPageCmsSection.isEmpty()))
        { 
            for(pepCmsSection__c objSection :lstlandingPageCmsSection)
            {
                                                                    
                if(objSection.pepQuestion__r != null && (!objSection.pepQuestion__r.isEmpty()))
                {                      
                                                                                                                  
                    wrapperSection  objWrapperSection = new wrapperSection();
                    objWrapperSection.objSection = objSection ;
                    objWrapperSection.lstWrapperQuestion = new List<wrapperApplication>();
                    for(pepCmsQuestion__c objQues : objSection.pepQuestion__r)
                    { 
                        
                        wrapperApplication objWrapper = new  wrapperApplication ();
                        objWrapper.objQuestion = objQues;
                        if(objQues.pepFieldApiName__c =='genesis__CL_Purpose__c' && objQues.pepType__c == 'Picklist')
                        {
                            objWrapper.lstSelectOption = lstclPurposeSelectOption; 
                            if(lstclPurposeSelectOption != null && (!lstclPurposeSelectOption.isEmpty()))
                                objWrapper.strAnswer = lstclPurposeSelectOption[0].getValue();                                 
                        }
                        if(objQues.pepFieldApiName__c =='genesis__CL_Product__c' && objQues.pepType__c == 'Picklist')
                        {
                            objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                            if(lstRateTypeSelectOption != null && (!lstRateTypeSelectOption.isEmpty()))
                                objWrapper.strAnswer = lstRateTypeSelectOption[0].getValue();                                  
                        } 
                        objWrapperSection.lstWrapperQuestion.add(objWrapper);                                                    
                    }         
                    lstWrapperSection.add(objWrapperSection);
                                                                                     
                } 
            }        
        }     
    }
    //This method is used to clear the value from the wrapperQuestions list for fields other than CL Purpose,CL Product and Requested Amount.
    public void querydata1()
    {
        for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
        {
            if(objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Purpose__c' && objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Product__c' && objWrapper.objQuestion.pepFieldApiName__c !='Requested_Loan_Amount__c')
            {                                                                                    
                objWrapper.strAnswer = null;
            }                                  
               
        }
      
    }     
    
    /**
     * @Created by : Sushant Kumar
     * @Param : A genesis application object
     * @Description : This method will load url parameter values of (application source) ApplyNow page and Landing page from cookies.
     **/
    public genesis__Applications__c loadParametersFromCookies(genesis__Applications__c applicationObj) {
        
        if(applicationObj != null) {
            
            Map<String, Cookie> cookiesMap = ApexPages.currentPage().getcookies();
            
            if(cookiesMap.containsKey('utm_source') && String.isNotBlank(cookiesMap.get('utm_source').getValue()))
                applicationObj.Web_Analytics_Source__c = cookiesMap.get('utm_source').getValue();
            
            if(cookiesMap.containsKey('utm_medium') && String.isNotBlank(cookiesMap.get('utm_medium').getValue()))
                applicationObj.Web_Analytics_Medium__c = cookiesMap.get('utm_medium').getValue();
            
            if(cookiesMap.containsKey('utm_campaign') && String.isNotBlank(cookiesMap.get('utm_campaign').getValue()))
                applicationObj.Web_Analytics_Campaign__c = cookiesMap.get('utm_campaign').getValue();
            
            if(cookiesMap.containsKey('utm_content') && String.isNotBlank(cookiesMap.get('utm_content').getValue()))
                applicationObj.Web_Analytics_Content__c = cookiesMap.get('utm_content').getValue();
            
            if(cookiesMap.containsKey('utm_term') && String.isNotBlank(cookiesMap.get('utm_term').getValue()))
                applicationObj.Web_Analytics_Term__c = cookiesMap.get('utm_term').getValue();
            
            if(cookiesMap.containsKey('utm_referrer') && String.isNotBlank(cookiesMap.get('utm_referrer').getValue()))
                applicationObj.Web_Analytics_Referrer__c = cookiesMap.get('utm_referrer').getValue();
            
        }
        
        return applicationObj;
    }
       
}
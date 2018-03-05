/*
This class is used to handle the landing page of the Application(Both for Secured/Unsecured Loan)
Code Refactoring and comments added by Varun Arora on August 26,2017
*/
public  class pepLandingPagecontroller
{               
    //added on 2nd august 
    // end of code
    public String sectionValue {get;set;}       
    public boolean strSelectedValue1  {get;set;}       
    public String strSelectedValue   { get; set;}      
    public List<wrapperSection> lstWrapperSection{get;set;}
    public Integer sectionNumber{get;set;}
    public Integer questionNo   {get;set;}
    Public Id parameterMapping;
    Public String googleclientip{get;set;}
    public Integer intRequestedTerm {get;set;}
    @TestVisible private List<selectOption> lstclPurposeSelectOption; 
    public decimal decIndicativeInterestrate{get;set;}
    public String decEMI{get;set;}
    
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
    // map<Id,string> mpCLProductIdToProductName;
    public String StrMinLoanAmount{get;set;}
    public String StrMaxLoanAmount{get;set;}
    
    public String Page_Name{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    public String decAmountPlaceHolder{get;set;}
    public String clPurposeName{get;set;}
    public Boolean securedLoan{get;set;}
    //Added by IJ These parameters would be fetched from the URL and saved against the application for staff loans and other purposes
    public string p1;
    public string p2;
    public string p3;
    public string p4;
    // Code block ends - IJ
    //Loaidng All Clpurposes as well as their respective rate card details.
    public pepLandingPagecontroller()
    {
        strurl = ApexPages.currentPage().getUrl(); 
        securedLoan = false;            
        if(strurl.contains('?'))
        {
            strurl = strurl.substringBefore('?');
        }
        
        strurl = strurl.split('apex/')[1]; 
        
        page_Name=ApexPages.currentPage().getUrl();//Added by KG
        page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());//Added by KG
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
        
        //Added by IJ
        p4='';
        p1 = ApexPages.currentPage().getParameters().get('p1'); 
        p2 = ApexPages.currentPage().getParameters().get('p2');         
        p3 = ApexPages.currentPage().getParameters().get('p3');
        p4 = ApexPages.currentPage().getParameters().get('p4');
        if(p4==null || p4=='')
            p4=label.SecuredLabel;
        else if(p4.toLowerCase()=='secured')
            securedLoan = true;
        
        
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
        //questionNo  =  1;
        
        lstWrapperSection = new List<wrapperSection>();
        loadClPurpose(); 
        
        loadCMSContent();
        loadDefaultCompany();     
        
    }
    //This method is used to query the default company(Pepper Account) 
    public void loadDefaultCompany()
    {
        pepDefaultCompany__c  objDefaultCompany = pepDefaultCompany__c.getInstance('Company Id');
        IdDefaultCompany = objDefaultCompany.pepDefault_Company_Id__c;
        idBusinessAccount = objDefaultCompany.pepBusinessAccount__c;
        
    }
    //This method is used to load the CLPurpose according to the landing page opened for Secured/Unsecured Loan.
    public void loadClPurpose()
    {
        List<clcommon__CL_Product__c> productsList = [select id,Pl_Product__c, Interest_Type__c from clcommon__CL_Product__c where PL_Product__c=:p4];
               
        
        lstclPurposeSelectOption = new List<selectOption>(); 
        Set<SelectOption> lstclPurposeSelectOptionSet = new Set<SelectOption>();
        lstclPurposeSelectOptionSet.add(new SelectOption('', ''));
        
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
                pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('pepLandingPagecontroller',exp)}) ;
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
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist' 
                           && QuesSequence  > questionNo )
                        {
                            objWrapper.lstSelectOption = lstRateTypeSelectOption;                                
                        }
                        
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
                        
                        if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getValue() != null && ApexPages.currentPage().getcookies().get('Requested_Term__c').getValue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getValue() != null && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getValue() != null &&
                           ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '' && ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getValue() != '' && ApexPages.currentPage().getcookies().get('Requested_Term__c').getValue() != '' && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '' && ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getValue() != '' && ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getValue() != ''){
                               
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
    //This method is used to clear all the values in all fields if the CL Purpose selected changes.                                                                     
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
                if(objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Purpose__c' && objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Product__c')
                {
                    objWrapper.lstSelectOption = null;
                    if(questionNo !=3)
                    {
                        objWrapper.strAnswer = null;
                    }                                 
                }                                                          
                
            }
            
        }
    }
    
    
    
    //This method is used to fetch the rate card corresponding to the CL purpose selected and also to show the interest rate to the customer dependiong upon the selected values in the picklist by the customer.
    public void FetchRateCardandCalculateEMI()
    {
        decimal decAmount = decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getValue().replace(',',''));
        decimal decyear = decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Term__c').getValue())*12;
        String strpaymentFreQuency=ApexPages.currentPage().getcookies().get('Debit_Frequency__c').getValue();
        string strcreditRating =ApexPages.currentPage().getcookies().get('genesis__Credit_Rating__c').getValue();
        Id idClPurpose = id.ValueOf(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue());
        String strrateType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
        
        
        if(strrateType != null && decAmount != null && decYear != null && strcreditRating != null && idClPurpose != null)
        {                                                                    
            genesis__Applications__c appObject = new genesis__Applications__c();
			
            appObject.genesis__CL_Product__c = strrateType;
            appObject.genesis__CL_Purpose__c = idClPurpose;
            appObject.genesis__Credit_Rating__c = strcreditRating;
            if(p1!=null && p1!='')
                appObject.pepP1__c =  p1; 
            if(p2!=null && p2!='')
                appObject.pepP2__c =  p2;
            if(p3!=null && p3!='')
                appObject.pepP3__c =  p3; 
            if(p4!=null && p4!='')
                appObject.pepP4__c =  p4;
            
             Parameters_and_Interest_Mapping__c objInterestMapping;
            if(p1!=null && p1!='' && p1.toLowerCase()=='plstaffoffer')
                objInterestMapping = [Select id,Interest_Rate__c from Parameters_and_Interest_Mapping__c where Active__c=true and Name=:p1.toLowerCase() limit 1];
                if(objInterestMapping !=null && objInterestMapping.id !=null && objInterestMapping.Interest_Rate__c !=null)     
                    decIndicativeInterestrate = objInterestMapping.Interest_Rate__c;
                else
                   decIndicativeInterestrate = CommonUtil.getInterestRate(appObject);
               
            if(decIndicativeInterestrate != null)
            {
                strPurposeName = MapOfPurposeIdToPurposeName.get(idClPurpose);
                   
                if(decAmount != null && decIndicativeInterestrate != null
                   && decYear != null && strpaymentFreQuency != null)
                {                 
                    //calculatedEMI  = pepUtilityClass.calculateLoanEmi(decAmount,decIndicativeInterestrate ,decYear/12,strpaymentFreQuency); 
                    LoanActions action = new LoanActions();
                    if(!Test.isRunningTest())
                        calculatedEMI   = action.calculateMonthlyPaymentAmount(decAmount, decIndicativeInterestrate ,decYear, null);
                    else{
                        calculatedEMI = 2000;
                    }
                    if(calculatedEMI  != null)
                    {
                        // calculatedEMI = Math.round(calculatedEMI);
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
                        renderSectionStory();
                    }
                    intNoOfPeriods = pepUtilityClass.calculateNoOfPaymentsBasedOnpaymentFrequency(decYear/12 ,strpaymentFreQuency);
                }
                idClProduct = strrateType;
                decIndicativeInterestrate  = decIndicativeInterestrate.setScale(2);
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
    //This method is used for creating the Application record.
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
                        //cookie requestedterm=new cookie('requestedterm',string.valueof(decyear),null,-1,false);
                        //ApexPages.currentPage().setcookies(new cookie[]{requestedterm});
                        
                        intNoOfPeriods = Integer.valueOf(decyear)*12;
                        objApplication.put('genesis__Term__c',intNoOfPeriods);
                        cookie yearterm=new cookie('yearterm',String.valueof(intNoOfPeriods),null,-1,false);
                        ApexPages.currentPage().setcookies(new cookie[]{yearterm});
                        
                        //isFormFilledFully = true;
                    }
                    else
                    {
                        isFormFilledFully = false;
                        //break;
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
            objApplication.GoogleClientIP__c=GoogleClientIP;
            
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
                cookie ApplicationId =new cookie('ApplicationId',PepEncryptDecryptData.EncryptData(objApplication.id),null,-1,false);
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
                Map<string,string> childobjectss = new Map<string,string>(); 
                List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjectss );
                if(lstApplication != null && (!lstApplication.isEmpty()))
                {  
                    genesis__Applications__c appObj = new genesis__Applications__c (); 
                    appObj = lstApplication[0];
                    
                    if(appObj.OBS_Contract_Check__c==true) 
                    {  
                        AddParty p = new AddParty();
                        clcommon__Party__c   party = p.add(p2,objApplication.Id);
                    }
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
                if(!test.isRunningTest()){
					//added by : Sushant Kumar, purpose : to include apllication source information on creation of new application
					objApplication = pepUtilityClass.fillApplicationSourceInfo(objApplication);
					objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
				}                

            }
            else{
                
                //Added By : Sushant Kumar, Description : This application source parameters are pushed in the cookies
                //because genessis application is not created in this case. Cookies value will be used on 
                //lonadetails page for loading application and feeling application source information
                pepUtilityClass.setParametersInCookie();
                //Modification ends here--
                
                if(p1 != null && p1!='')
                {
                    if(p1.length()>255)
                    {
                        p1 = p1.substring(0,255);
                    }
                    Cookie param1 = new cookie('param1',p1,null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{param1});
                }
                
                if(p2 != null && p2!='')
                {
                    if(p2.length()>255)
                    {
                        p2 = p2.substring(0,255);
                    }
                    Cookie param2 = new cookie('param2',p2,null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{param2});
                }
                
                
                if(p3 != null && p3!='')
                {
                    if(p3.length()>255)
                    {
                        p3 = p3.substring(0,255);
                    }
                    Cookie param3 = new cookie('param3',p3,null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{param3});
                }
                
                
                if(p4 != null && p4!='')
                {
                    if(p4.length()>255)
                    {
                        p4 = p4.substring(0,255);
                    }
                    Cookie param4 = new cookie('param4',p4,null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{param4});
                }
                
            }
            
        }
    }       
    
    
    
    
    //This method creates dummy person Account
    public Id createDummyAccount()
    {
        if(referralCode!=null && referralCode!='')
        {
            List<Account> acc=[select id from account where Referred_By_Code__c=:referralCode];
            //modified by : sushant kumar
            return (acc != null && (!acc.isEmpty()))?  acc[0].id : null;
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
    //This method is used to render the fields on the peplandingPage depending upon the CMS Object setted up against the page getting loaded. 
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
   
    //This wrapper is used to hold the single instance of the Section with their corresponding Question and answers.
    public class wrapperApplication
    {
        public pepCmsQuestion__c objQuestion{get;set;} 
        public List<wrapperAnswer> lstExpectedAnswers {get; set;}//answer of question    
        public List<selectoption> lstSelectOption{get;set;}
        public String strAnswer
        {
            get { return strAnswer; }
            
            set {
                //modified by : Sushant Kumar
                strAnswer = (objQuestion.pepType__c =='Currency' && value != null) ? value.replace(',','') : value;
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
    //This method is used to return the rate card depending upon the the values provided on the parameters entered via the page.
    public List<genesis__Rate_Card_Setup_Detail__c > FilterValues()
    {
        Decimal decAmount;
        decimal decyear;
        String strpaymentFreQuency;
        string strcreditRating;
        Id idClPurpose;
        String strProductType;
        string strPageName;
        list<clcommon__CL_Product__c> lstCLProd = [select id,clcommon__Product_Name__c,Interest_Type__c from clcommon__CL_Product__c where PL_Product__c=:p4];
        
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
        else if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() !=''){  
            idClPurpose = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue();
            lstWrapperSection[0].lstWrapperQuestion[0].strAnswer= ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue();
            
        }
        map<id, pepCmsSection__c> mapSections = new map<id, pepCmsSection__c>([SELECT pepHeader__c,pepPage__c, pepSectionBody__c, Name, pepSectionUniqueName__c, pepType__c, 
                                                                               pepSectionStory__c , Page_Name__c  ,pepSectionStoryRich__c,pepSectionBodyRich__c
                                                                               from pepCmsSection__c
                                                                               where pepPage__r.pepPageName__c=: strPageName
                                                                               order by pepSequence__c]);
        
        List<pepCmsQuestion__c> lstQuestions = [SELECT Id,Is_Date_to_Birth__c, pepSection__c,pepSection__r.Name ,pepSection__r.pepSectionUniqueName__c , pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, pepRecordSequence__c,
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
                        //modified by : sushant kumar 
                        if(!(strurl == 'peplandingpage' && objAns.pepDisplayText__c.tolowerCase()== 'choose one' ))
                        {
                            if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null)
                            {
                                if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '' )
                                {
                                    if(objAns.pepDisplayText__c.tolowerCase()== 'choose one')
                                        lstPaymentFrequency.add(new selectOption('',objAns.pepDisplayText__c));
                                    else
                                        lstPaymentFrequency.add(new selectOption(objAns.pepDisplayText__c,objAns.pepDisplayText__c));
                                }
                            }
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
                decAmount=Decimal.valueof(ApexPages.currentPage().getcookies().get('Requested_Loan_Amount__c').getvalue()); 
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
                    if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null)
                    {
                        if((!struniquecreditratingSet.contains(objratecardDetail.genesis__Credit_Rating__c)) && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '' )
                            lstCreditRating.add(new selectOption(objratecardDetail.genesis__Credit_Rating__c,objratecardDetail.genesis__Credit_Rating__r.name));
                        //lstCreditRating.sort();
                    } 
                }
                
                struniquepaymentfrequecnySet.add(objratecardDetail.genesis__Payment_Frequency__c);
                struniquecreditratingSet.add(objratecardDetail.genesis__Credit_Rating__c);
            }
            
            if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null)
            {
                if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '' && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '')
                {            
                    if(intMinYear != null && intmaxYear != null)
                    {
                        String purposeId = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue();
                        String interestType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
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
        }          
        return  lstRateCardSetupDetail;
    }
    //This method is used to save application on Landing page on the click of Apply Now button    
    public pageReference ApplyNow()
    {
        try
        {
            
            try
            {
                validateData();
                if(isError == true)
                {
                    return null;
                }
                if(ReturnValue!=null && ReturnValue!=''){
                    objApplication.IP_Address__c =  ReturnValue;
                    Cookie ipAddress = new Cookie('idAddress',String.valueof(objApplication.IP_Address__c),null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{ipAddress});
                }
                if(p1!=null && p1!='')
                    objApplication.pepP1__c =  p1;    
                if(p2!=null && p2!='')
                    objApplication.pepP2__c =  p2; 
                if(p3!=null && p3!='')
                    objApplication.pepP3__c =  p3;
                if(p4!=null && p4!='')
                    objApplication.pepP4__c =  p4;
                
                CommonMethodForInsertingApplication();
                modelConInstance.objApplication = objApplication; 
            }
            catch(Exception exp)
            {
                pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('Application',exp)}) ;
            }
            
            string redircetPageName= pages_config__c.getinstance('pepapplynow').Page_Label__c;
            objNextPage=new Pagereference('/'+redircetPageName);               
            
            objNextPage.setRedirect(true); 
            return objNextPage;
        }
        catch(Exception ex)
        {
            return pepUtilityClass.handlePageException(ex);
        }
        
    }
    
    public pageReference retrieveAppCode()
    {
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
    public void fetchAllRateCard()
    {
        
        if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null ){
            if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '' && 
               ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '' ){
                   
                   Id idCLPurpose;
                   if(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[0].strAnswer !='')
                   {
                       idClPurpose    =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer; 
                       clPurposeName  =  MapOfPurposeIdToPurposeName.get(idClPurpose);
                       
                   }
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
                       
                       String interestType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
                       decMinLoanAmount=(decimal)lstRateCardSetupDetail[0].get('minVal');
                       decmaxLoanAmount=(decimal)lstRateCardSetupDetail[0].get('maxVal');
                       if(productPurposeName.containsKey(idClPurpose+':'+interestType) && productPurposeName.get(idClPurpose+':'+interestType).Min_Loan_Amount_Delta__c!=null)
                           decMinLoanAmount = decMinLoanAmount +(productPurposeName.get(idClPurpose+':'+interestType).Min_Loan_Amount_Delta__c); 
                       if(productPurposeName.containsKey(idClPurpose+':'+interestType) && productPurposeName.get(idClPurpose+':'+interestType).Max_Loan_Amount_Delta__c!=null)
                           decmaxLoanAmount = decmaxLoanAmount +(productPurposeName.get(idClPurpose+':'+interestType).Max_Loan_Amount_Delta__c);
                       StrMinLoanAmount =String.ValueOf(decMinLoanAmount.format());
                       StrMaxLoanAmount =String.ValueOf(decmaxLoanAmount.format());
                       decAmountPlaceHolder = StrMinLoanAmount +'-'+StrMaxLoanAmount;
                       
                   }
                   if(questionNo==1)
                   {
                       Set<SelectOption> lstRateTypeSelectOptionSet = new Set<SelectOption>();
                       lstRateTypeSelectOption = new List<SelectOption>(); 
                       lstRateTypeSelectOptionSet.add(new selectOption('',''));
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
        } 
        else
        {
            if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '')
            {
                String purposeId = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue();
                Set<SelectOption> lstRateTypeSelectOptionSet = new Set<SelectOption>();
                lstRateTypeSelectOption = new List<SelectOption>(); 
                lstRateTypeSelectOptionSet.add(new selectOption('',''));
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
                lstRateTypeSelectOption.add(new selectOption('',''));
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
    //This method is used to validatre the amount entered is valid.
    public boolean validateData()
    {
        Id idClPurpose;
        decimal decBorrowedAmount ;        
        idClPurpose = lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;
         
        if(lstWrapperSection[0].lstWrapperQuestion[2].strAnswer !=null 
           && lstWrapperSection[0].lstWrapperQuestion[2].strAnswer.trim() !='')
        {
            try
            {
                decBorrowedAmount = Decimal.valueOf(lstWrapperSection[0].lstWrapperQuestion[2].strAnswer);
            }
            catch(Exception e)
            {
                isError = true;
                return isError;
            }
        }
        
        
        
        if(idClpurpose != null && decBorrowedAmount != null)
        {
            List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail =[select id,
                                                                              genesis__Interest_Rate__c,
                                                                              genesis__Rate_Card_Setup_Header__r.genesis__CL_Product__c
                                                                              from genesis__Rate_Card_Setup_Detail__c
                                                                              where genesis__Rate_Card_Setup_Header__r.CL_Purpose__c =:idClPurpose
                                                                              AND genesis__Minimum_Financed_Amount__c <=:decBorrowedAmount 
                                                                              AND genesis__Maximum_Financed_Amount__c >=:decBorrowedAmount
                                                                              AND genesis__Rate_Card_Setup_Header__r.Type__c = 'Pre Credit Check' ];
            
            
            isError = (lstRateCardSetupDetail != null  && (!lstRateCardSetupDetail.isEmpty()))?false:true;                                                                       
        }
        return isError;
    }
    
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
            if(objApplication.Debit_Frequency__c == 'BI-WEEKLY') 
            {
                strPaymentFrequencyLabel = 'fortnightly';               
            }else
                strPaymentFrequencyLabel = objApplication.Debit_Frequency__c.tolowercase();
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
    
    public void querydata1()
    {
        for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
        {
            if(objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Purpose__c' && objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Product__c'&& objWrapper.objQuestion.pepFieldApiName__c !='Requested_Loan_Amount__c')
            {                   
                objWrapper.strAnswer = null;
            }                                 
            
        }
        
    }
}
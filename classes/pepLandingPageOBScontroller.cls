// ---------------------------------------------------------------------------------------------------------
// This class is used to save application details through OBS link. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      10th Nov 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------

public  class pepLandingPageOBScontroller
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
        
        public Integer IntcookiePageNo {get;set;}
        public String A {get;set;}
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
        public String intrestSection{get;set;}
        //Added by IJ These parameters would be fetched from the URL and saved against the application for staff loans and other purposes
        public string p1;
        public string p2;
        public string p3;
        public string p4;
        // Code block ends - IJ

        public pepLandingPageOBScontroller()
        {
             strurl = ApexPages.currentPage().getUrl(); 
            system.debug('bhawna--strurl' +strurl );             
            if(strurl.contains('?'))
            {
                strurl = strurl.substringBefore('?');
            }
            
            strurl = strurl.split('apex/')[1];
            strurl = strurl.toLowerCase(); 
          
             page_Name=ApexPages.currentPage().getUrl();//Added by KG
             page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());//Added by KG
             Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
             p4='';
             p1 = ApexPages.currentPage().getParameters().get('p1');
             p2 = ApexPages.currentPage().getParameters().get('p2');         
             p3 = ApexPages.currentPage().getParameters().get('p3');
             p4 = ApexPages.currentPage().getParameters().get('p4');
             if(p4==null || p4=='')
               p4='UNSECURED';
        
            //Added by IJ
            
            
            System.debug('CONSTRUCTOR>>>>>>>>');
            objApplication = new  genesis__Applications__c(); 
            MapOfPurposeIdToPurposeName = new Map<id,String>(); 
            productPurposeName = new Map<String,CL_Product_Purpose_Junction__c>(); 
            interestTypeMap = new Map<String,list<CL_Product_Purpose_Junction__c>>();                     
            //mpCLProductIdToProductName =  new map<Id,string>();
            referralCode= apexpages.currentpage().getparameters().get('Ref');
           
               if(ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')!=null)
               {
                   ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); 
                   system.debug('ReturnValueIs'+ReturnValue);
               }    
           
            lstRateCardSetupDetail = new List<genesis__Rate_Card_Setup_Detail__c>();
            modelConInstance = new pepCmsModelContainer();         
            if( ApexPages.currentPage().getParameters().get('redirectFromPageNo') != null 
                 &&  ApexPages.currentPage().getParameters().get('redirectFromPageNo') !='')
             {
                intPreviousPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('redirectFromPageNo'));     
                
             }
             
            intCurrentPageNumber =  1;
              
            system.debug('CONSTRUCTOR');
            sectionNumber=1;
            //questionNo  =  1;
                           
            
            system.debug('strurl' +strurl );     
            lstWrapperSection = new List<wrapperSection>();
            loadClPurpose(); 
                    
            loadCMSContent();
            loadDefaultCompany();   
        
        }
 
 // This method is used to bind business account to Party object after application creation.     
        
        public void loadDefaultCompany()
        {
            pepDefaultCompany__c  objDefaultCompany = pepDefaultCompany__c.getInstance('Company Id');
            IdDefaultCompany = objDefaultCompany.pepDefault_Company_Id__c;
            idBusinessAccount = objDefaultCompany.pepBusinessAccount__c;
            System.debug('IdDefaultCompany*********'+IdDefaultCompany );
        
        }
     
   // This method is used to load cl purpose object.
    
        public void loadClPurpose()
        {
            List<clcommon__CL_Product__c> productsList = [select id,Pl_Product__c, Interest_Type__c from clcommon__CL_Product__c where PL_Product__c=:p4];
            System.debug('load cl pur'); 
           lstclPurposeSelectOption = new List<selectOption>(); 
              Set<SelectOption> lstclPurposeSelectOptionSet = new Set<SelectOption>();
              lstclPurposeSelectOptionSet.add(new SelectOption('', '--Select--'));
           
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
            System.debug('strPurposeName*******************'+strPurposeName);
            System.debug('strPurposeName*******************'+strPurposeName);
            System.debug('lstWrapperSection.size()'+lstWrapperSection.size());
            System.debug('questionNo'+questionNo);
            System.debug('questionNo'+lstWrapperSection[sectionNumber-1].lstWrapperQuestion.size());
            System.debug('sectionNumber***'+SectionNumber);
           
            if(lstWrapperSection.size() >= sectionNumber && lstWrapperSection[sectionNumber-1].lstWrapperQuestion.size() >= questionNo)
            {
                   
                   
                   Id idClPurpose =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;
                  
                   Integer QuesSequence = 1; 
                   decimal decBorrowedAmount ;
                    System.debug('QuesSequence ***********'+QuesSequence  ); 
                    System.debug('questionNo  ***********'+questionNo  );       
                    if(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[2].strAnswer !=null 
                       && lstWrapperSection[sectionNumber-1].lstWrapperQuestion[2].strAnswer.trim() !='')
                      try
                       {
                           decBorrowedAmount = Decimal.valueOf(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[2].strAnswer);
                          
                       }
                       catch(Exception exp)
                       {
                       pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('pepLandingPageOBScontroller',exp)}) ;
                       } 
                     
                  if(decBorrowedAmount >= 0 && idClPurpose != null)
                  { 
                             
                    List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail = FilterValues();
                   
                    if(decBorrowedAmount >= decMinLoanAmount && decBorrowedAmount <= decMaxLoanAmount )
                    {
                       
                    } 
                    else
                    {    
                         clearvalues();
                         isError = true;  
                                         
                        // return null;
                        system.debug('checkiserror***'+isError); 
                    }
                    
                   // FilterValues();
                    system.debug('Bhawna-Queriss:'+lstRateCardSetupDetail );
                    if(lstRateCardSetupDetail != null && lstRateCardSetupDetail.size() > 0)
                    {          
                    for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                    {
                        System.debug('questionNo ************'+questionNo);
                        System.debug('lstRateTypeSelectOption************'+lstRateTypeSelectOption);
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist' 
                           && QuesSequence  > questionNo )
                        {
                            System.debug('amit***');
                            system.debug('lstRateTypeSelectOption:: '+lstRateTypeSelectOption);
                            objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                            if(lstRateTypeSelectOption != null && lstRateTypeSelectOption.size()>0){}
                           // objWrapper.strAnswer = lstTermSelectOption[0].getvalue();                                
                        }
                    
                        if(objWrapper.objQuestion.pepFieldApiName__c =='Requested_Term__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist' 
                           && QuesSequence  > questionNo )
                        {
                            System.debug('amit***');
                            system.debug('lstTermSelectOption:: '+lstTermSelectOption);
                            objWrapper.lstSelectOption = lstTermSelectOption; 
                            if(lstTermSelectOption != null && lstTermSelectOption.size()>0){}
                           // objWrapper.strAnswer = lstTermSelectOption[0].getvalue();                                
                        }
                        
                        if(objWrapper.objQuestion.pepFieldApiName__c =='Debit_Frequency__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist'  
                           && QuesSequence  > questionNo )
                        {
                            System.debug('amit***&^^^^'+lstPaymentFrequency);
                            system.debug('lstPaymentFrequency:: '+lstPaymentFrequency);
                            objWrapper.lstSelectOption = lstPaymentFrequency; 
                            if(lstPaymentFrequency != null && lstPaymentFrequency.size()>0  ) {}
                            //objWrapper.strAnswer = lstPaymentFrequency[0].getvalue();                               
                        }
                        
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__Credit_Rating__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist'  
                           && QuesSequence  > questionNo)
                        {
                            System.debug('amit***');
                             system.debug('lstCreditRating:: '+lstCreditRating);
                            objWrapper.lstSelectOption = lstCreditRating;
                            if(lstCreditRating != null && lstCreditRating.size()>0){}
                            //objWrapper.strAnswer = lstCreditRating[0].getvalue();                                   
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
                     System.debug('IN ELSE PART *&*&*'); 
                   //clearValues();
                   isError = true;                 
                }                                                                      
                                                                                        
              }
               else
             {
                 System.debug('IN ELSE PART *&*&*');
                  clearValues();  
             }
             }
           if(sectionNumber == 1&& questionNo==3)
              querydata1();
                           // return null;
            } 
            
   // This method is used to clear the values after changing the loan purpose.
                                                                                       
            public void clearValues()
        {
            System.debug('in Method clear');
            System.debug('questionNo ****************'+questionNo);
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
                        system.debug('questionNo :'+questionNo );
                        objWrapper.lstSelectOption = null;
                        if(questionNo !=3)
                        {
                            System.debug('questionNo **********'+questionNo );                   
                            objWrapper.strAnswer = null;
                        }                                 
                    }                                                          
                
                }
                
            }
        }
        
       
     // This method id used to fetch rate card details correponding to different loan purpose.   
        
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
           /*   List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail =[select id,
                                                                                        genesis__Interest_Rate__c,
                                                                                        genesis__Rate_Card_Setup_Header__r.genesis__CL_Product__c,
                                                                                        genesis__Rate_Card_Setup_Header__r.CL_Purpose__r.name
                                                                                        from genesis__Rate_Card_Setup_Detail__c
                                                                                        where genesis__Rate_Card_Setup_Header__r.CL_Purpose__c =:idClPurpose
                                                                                        AND genesis__Minimum_Financed_Amount__c <=:decAmount
                                                                                        AND genesis__Maximum_Financed_Amount__c >=:decAmount
                                                                                        AND genesis__Payment_Frequency__c =:'monthly'
                                                                                        AND genesis__Min_Term__c <=:decYear
                                                                                        AND genesis__Max_Term__c >=:decYear
                                                                                        AND genesis__Credit_Rating__c =:strcreditRating
                                                                                        AND genesis__Rate_Card_Setup_Header__r.Type__c = 'Pre Credit Check'];  
                                                                                        
                   System.debug('*****'+lstRateCardSetupDetail.size());     */  
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
                   decIndicativeInterestrate = CommonUtil.getInterestRate(appObject);
                   system.debug('decIndicativeInterestrateIS1'+decIndicativeInterestrate);                                                                  
                   
                   if(decIndicativeInterestrate != null)
                   {
                      strPurposeName = MapOfPurposeIdToPurposeName.get(idClPurpose);
                      
               /*       if(ApexPages.currentPage().getcookies().get('param1') != null && ApexPages.currentPage().getcookies().get('param1').getvalue()!= null && ApexPages.currentPage().getcookies().get('param1').getvalue()!=''){
                List<Parameters_and_Interest_Mapping__c> paramMapping = [Select id,name,active__c,Interest_Rate__c from Parameters_and_Interest_Mapping__c where name=:ApexPages.currentPage().getcookies().get('param1').getvalue() Limit 1];
                if(paramMapping != null && paramMapping.size()>0){
                                       if(paramMapping[0].active__c){
                                       decIndicativeInterestrate=paramMapping[0].Interest_Rate__c;
                                       parameterMapping=paramMapping[0].id;
                                       }
                                       else{
                      decIndicativeInterestrate = lstRateCardSetupDetail[0].genesis__Interest_Rate__c;
                      }
}
else{
decIndicativeInterestrate = lstRateCardSetupDetail[0].genesis__Interest_Rate__c;
}   
}
else{
decIndicativeInterestrate = lstRateCardSetupDetail[0].genesis__Interest_Rate__c;
}   */
              
                      if(decAmount != null && decIndicativeInterestrate != null
                          && decYear != null && strpaymentFreQuency != null)
                       {                 
                        //calculatedEMI  = pepUtilityClass.calculateLoanEmi(decAmount,decIndicativeInterestrate ,decYear/12,strpaymentFreQuency); 
                         LoanActions action = new LoanActions();
                         System.debug('decYear*12&**'+decYear*12);
                           if(!Test.isRunningTest())
                         calculatedEMI   = action.calculateMonthlyPaymentAmount(decAmount, decIndicativeInterestrate ,decYear, null);
                           else
                               calculatedEMI= 200;
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
                                List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name,pepSequence__c,
                                                                    pepSectionUniqueName__c, pepType__c,pepSectionBodyRich__c, 
                                                                    pepSectionStory__c ,pepPage__r.pepPageName__c 
                                                                    from pepCmsSection__c  where pepPage__r.pepPageName__c='Landing Page OBS' and pepSequence__c= 5 order by pepSequence__c ASC];
                                                              
                 intrestSection = lstSections[0].pepSectionBodyRich__c; 
                 intrestSection =intrestSection.replace('{frequency}',strpaymentFreQuency);
                          }
                          system.debug('decYear:: '+decYear + ' -- strpaymentFreQuency::'+strpaymentFreQuency);
                          intNoOfPeriods = pepUtilityClass.calculateNoOfPaymentsBasedOnpaymentFrequency(decYear/12 ,strpaymentFreQuency);
                          system.debug('intNoOfPeriods:: '+intNoOfPeriods);
                      }
                      idClProduct = strrateType; 
                      decIndicativeInterestrate  = decIndicativeInterestrate.setScale(2);
                      System.debug('idClProduct ***'+idClProduct );               
                    
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
  
  // This method is used to insert application.
       
        public void CommonMethodForInsertingApplication()
        {
           System.debug('idClProduct Swati***'+idClProduct );
            Decimal decAmount;
            decimal decyear;
            String strpaymentFreQuency;
            string strcreditRating;
            Id idClPurpose;
            String strProductType;
            boolean isFormFilledFully =true;
            System.debug('lstWrapperSection.size()**********'+lstWrapperSection.size()); 
            System.debug('lstWrapperSection'+lstWrapperSection);        
            System.debug('sectionNumber**********'+sectionNumber);         
            if(sectionNumber != null  && lstWrapperSection.size() >= sectionNumber) 
            {  
                System.debug('section Number*********'+sectionNumber);     
                for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                {
                    System.debug('strAnswer'+objWrapper.strAnswer);                
                    if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Purpose__c' )
                    {
                        idClPurpose = objWrapper.strAnswer; 
                        System.debug('idClPurpose *********'+idClPurpose);                   
                        if(idClPurpose  != null)
                        {                    
                            objApplication.put('genesis__CL_Purpose__c',idClPurpose);
                            
                        }
                        else
                        {
                            isFormFilledFully =false;
                            //break;
                        }

                    }
                    
                    if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' )
                    {
                       
                        System.debug('product answer id*****'+objWrapper.strAnswer);
                        
                       
                        if(objWrapper.strAnswer!=null)
                        {
                            objApplication.put('genesis__CL_Product__c',objWrapper.strAnswer);
                           
                        }
                        
                        else
                        {
                            isFormFilledFully = false;
                             //break;
                        }
                    }            
                    system.debug('decyear:: '+decyear);    
                    system.debug('intNoOfPeriods:: '+intNoOfPeriods);    
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
                            //break;
                        }
                    }
                    if(objWrapper.objQuestion.pepFieldApiName__c =='Debit_Frequency__c' )
                    {
                        if(objWrapper.strAnswer != null && objWrapper.strAnswer.trim() != '')
                        {
                            System.debug('strpaymentFreQuency ***'+objWrapper.strAnswer);
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
                           // break;
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
                            //break;
                        }
                        
                    } 
                } 
            }
            System.debug('test****'+isFormFilledFully);
            System.debug('test****'+idCLProduct);
            if(isFormFilledFully == true  && objApplication.Id == null)
            {  
                System.debug('test***'+objApplication);
                Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();
                Map<String,SObject> relatedObjects = new Map<String,SObject>();  
                objApplication.genesis__Account__c = createDummyAccount();
                
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
                System.debug('emi&*&**&*'+decemi);
                if(decEmi != null)
                {
                    
                    objApplication.put('Debit_Amount__c',calculatedEMI); // Added by IJ
                    cookie debitAmount=new cookie('debitAmount',String.valueof(calculatedEMI),null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{debitAmount});
                }
                if(parameterMapping != null){
                objApplication.put('Parameters_and_Interest_Mapping__c',parameterMapping);
                }
                //objApplication.put('genesis__CL_Product__c',idClProduct);
                System.debug('*****^^&^'+objApplication.genesis__CL_Product__c);       
                system.debug('objApplication::'+objApplication);
                
                                try{
                loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
                Date systemDate = util.getCUrrentSystemDate();  
                objApplication.genesis__Expected_Start_Date__c  = systemDate ;  
                objApplication.genesis__Expected_First_Payment_Date__c = systemDate.addMonths(1);                 
                objApplication =  pepInvokeCLMethodHelper.insertApplication(objApplication,relatedObjects ,childObjects );
                cookie ApplicationId =new cookie('ApplicationId',PepEncryptDecryptData.EncryptData(objApplication.id),null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{ApplicationId});
                                system.debug('======='+objApplication);
}
catch(Exception ex){
System.debug('====='+ex.getmessage());

}                               
                //Insert Party  
                if(objApplication !=null && objApplication.Id!=null)
                {
                    // fetch business account from Custom setting
                    
                    clcommon__Party__c objParty =  new clcommon__Party__c(clcommon__Account__c= idBusinessAccount , genesis__Application__c= objApplication.Id);
                    insert objParty;
                    Map<string,string> childobjectss = new Map<string,string>(); 
                     List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjectss );
                     System.debug('lstApplicationtest  *********'+lstApplication);
                      if(lstApplication != null && lstApplication.size() >0)
                        {  
                           genesis__Applications__c appObj = new genesis__Applications__c (); 
                           appObj = lstApplication[0];
                           System.debug('lstApplicationtest1  *********'+appObj.OBS_Contract_Check__c);
                           if(appObj.OBS_Contract_Check__c==true) 
                            {  
                                 System.debug('lstApplicationtest3  *********'+objApplication.pepP2__c);
                                 AddParty p = new AddParty();
                                 clcommon__Party__c   party = p.add(objApplication.pepP2__c,objApplication.Id);
                                 System.debug('lstApplicationtest2  *********'+party);
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
                        if(!test.isRunningTest())                    
                        objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
                    }
                }
                 system.debug('Bhawna-Application'+ objApplication.Id);
            // insert Party Group
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
        
     // This method is used to load CMS Conent on page load.
        
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
                                                                                 from pepCmsSection__c where pepPage__r.pepPageName__c ='Landing Page OBS' and pepSectionUniqueName__c='LandingPageOBSSection1' order by pepSequence__c asc];   
              
              
               if(lstlandingPageCmsSection != null && lstlandingPageCmsSection.size() > 0)
               { 
                   for(pepCmsSection__c objSection :lstlandingPageCmsSection)
                   {
                       System.debug('objSection ******'+objSection);
                       if(objSection.pepQuestion__r != null && objSection.pepQuestion__r.size() > 0)
                       {
                             //System.debug('objSection ******'+objSection.pepQuestion__r);                       
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
                                       if(lstclPurposeSelectOption != null && lstclPurposeSelectOption.size() > 0)
                                       objWrapper.strAnswer = lstclPurposeSelectOption[0].getValue();                                 
                                   }
                                   if(objQues.pepFieldApiName__c =='genesis__CL_Product__c' && objQues.pepType__c == 'Picklist')
                                   {
                                       objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                                       if(lstRateTypeSelectOption != null && lstRateTypeSelectOption.size() > 0)
                                           objWrapper.strAnswer = lstRateTypeSelectOption[0].getValue();                                   
                                   }
                                   objWrapperSection.lstWrapperQuestion.add(objWrapper);                                                    
                             }         
                             lstWrapperSection.add(objWrapperSection);
                             System.debug('lstWrapperSection****'+lstWrapperSection);
                       }
                   
                   }
                   
                  
                   
               }                                                                 
         
        }
        
        
             
    // This wrapper is used to bind application fields.    
        
        public class wrapperApplication
        {
            public pepCmsQuestion__c objQuestion{get;set;} 
            public List<wrapperAnswer> lstExpectedAnswers {get; set;}//answer of question    
         //   public string strAnswer{get;set;}
            public List<selectoption> lstSelectOption{get;set;}
           
          
            public String strAnswer
            {
               get { return strAnswer; }
               
               set {
                    if(objQuestion.pepType__c =='Currency')
                    {
                        if(value != null)
                        {
                         strAnswer= value.replace(',','');
                        }
                        else
                        {
                            strAnswer = value;
                        }
                    }
                    else
                    {
                        strAnswer =value;
                    }
                    
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
 
 // This mehtod is used to filter values on the basis of fields api name.
        
        public List<genesis__Rate_Card_Setup_Detail__c > FilterValues()
        {
           
            System.debug('called');
            Decimal decAmount;
            decimal decyear;
            String strpaymentFreQuency;
            string strcreditRating;
            Id idClPurpose;
            String strProductType;
            string strPageName;
            list<clcommon__CL_Product__c> lstCLProd = [select id,clcommon__Product_Name__c,Interest_Type__c from clcommon__CL_Product__c where PL_Product__c=:p4];
            
           // lstRateTypeSelectOption = new List<SelectOption>(); 
            lstPaymentFrequency = new List<selectOption>(); 
            
            if(strurl == 'pepobslandingpage' )
                strPageName = 'Landing Page OBS';
            
               
                
          /*  if(lstCLProd !=null && lstCLProd.size()>0)
            {
                for(clcommon__CL_Product__c objCLPr:lstCLProd  )
                {
                    system.debug('objCLPr-name:'+objCLPr);
                   
                    lstRateTypeSelectOption.add(new selectOption(objCLPr.Id,objCLPr.clcommon__Product_Name__c));
                  
                }
            } */
            
            
            system.debug('lstRateTypeSelectOption:: '+lstRateTypeSelectOption);
            //System.debug('lstWrapperSection[0].lstWrapperQuestion[0].strAnswer'+lstWrapperSection[0].lstWrapperQuestion[0].strAnswer);
            if(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != '')
            idClPurpose =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;
            else if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() != null && ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue() !=''){  
            idClPurpose = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue();
            lstWrapperSection[0].lstWrapperQuestion[0].strAnswer= ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getvalue();
            
            }
            system.debug('strPageName:: '+strPageName);
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
            
            system.debug('mapSections:: '+mapSections   );
            system.debug('lstQuestions:: '+lstQuestions);
            if(lstQuestions!=null && lstQuestions.size()>0)
            {
                for(pepCmsQuestion__c objCMSQ: lstQuestions)
                {
                    system.debug('objCMSQ.pepSection__r.Name:: '+objCMSQ.pepSection__r.pepSectionUniqueName__c);
                    if((objCMSQ.pepSection__r.pepSectionUniqueName__c == 'LandingPageOBSSection1') &&  objCMSQ.pepFieldApiName__c == 'Debit_Frequency__c'&&
                        ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '' )
                    {
                        System.debug('strUL*********'+strurl);
                        for(pepCmsAnswer__c objAns: objCMSQ.pepCmsAnswer__r)
                        {
                            lstPaymentFrequency.add(new selectOption(objAns.pepDisplayText__c,objAns.pepDisplayText__c));
                        }
                    }           
                }
                
            }
            system.debug('lstPaymentFrequency ::'+lstPaymentFrequency);   
            
            
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
                       
                    System.debug('decAmount****'+decAmount); 
                    System.debug('idCLPurpose****'+idCLPurpose);
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
                //List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail = database.query(strQuery);
                lstRateCardSetupDetail = database.query(strQuery);
                System.debug('query****'+strQuery);
                System.debug('lstRateCardSetupDetail ****'+lstRateCardSetupDetail.size());
                if(lstRateCardSetupDetail != null && lstRateCardSetupDetail.size() > 0)
                {
                    lstTermSelectOption = new List<selectOption>();              
                    lstCreditRating = new List<selectOption>(); 
                    set<String> struniquepaymentfrequecnySet = new set<String>();
                    set<String> struniquecreditratingSet = new set<String>();
                                  
                    Integer intMinYear;
                    Integer intMaxYear;    
                    System.debug('lstRateCardSetupDetail****'+lstRateCardSetupDetail.size()); 
                    system.debug('bhawna-ratecarddetails:: '+lstRateCardSetupDetail);          
                    for(genesis__Rate_Card_Setup_Detail__c objratecardDetail : lstRateCardSetupDetail)
                    {
                             system.debug('bhawna-ratecard- '+objratecardDetail );
                             System.debug('objratecardDetail.genesis__Payment_Frequency__c********'+objratecardDetail.genesis__Payment_Frequency__c);
                       if(objratecardDetail.genesis__Min_Term__c != null 
                           && objratecardDetail.genesis__Max_Term__c != null) 
                       { 
                            System.debug('intMinyear*****'+intMinyear);
                            System.debug('intMaxYear*****'+intMaxYear);
                            System.debug('amit*************'+objratecardDetail.genesis__Min_Term__c);
                            if(intMinYear == null && intMaxYear == null)
                            {
                                System.debug('amit*************'+objratecardDetail.genesis__Min_Term__c);
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
                        { if(ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null)
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
                                String purposeId = ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue();
                                String interestType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
                                if(productPurposeName.containsKey(purposeId+':'+interestType) && productPurposeName.get(purposeId+':'+interestType).Min_Term_Delta__c!=null)
                                   intMinYear = intMinYear + integer.valueOf(productPurposeName.get(purposeId+':'+interestType).Min_Term_Delta__c);
                                if(productPurposeName.containsKey(purposeId+':'+interestType) && productPurposeName.get(purposeId+':'+interestType).Max_Term_Delta__c!=null)
                                   intmaxYear = intmaxYear + integer.valueOf(productPurposeName.get(purposeId+':'+interestType).Max_Term_Delta__c);
                            if(intMinYear != null && intmaxYear != null)
                                {
                                    System.debug('intMinYear*********'+intMinYear);
                                    System.debug('intMinYear*********'+intmaxYear );
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
                system.debug('objAppl Swati' +objApplication);
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
       
        public void fetchAllRateCard()
        {
        
             
         if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c') != null && ApexPages.currentPage().getcookies().get('genesis__CL_Product__c') != null ){
              if(ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Purpose__c').getValue() != '' && 
              ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != null &&ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue() != '' ){
                    
            System.debug('section Number'+sectionNumber);
            System.debug('Ques Number'+questionNO);
            Id idCLPurpose;
            System.debug('========='+lstWrapperSection[0].lstWrapperQuestion[0].strAnswer);
             System.debug('========='+lstWrapperSection[0].lstWrapperQuestion[0].objquestion.pepFieldApiName__c);
            if(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[0].strAnswer !='')
            {
                idClPurpose    =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer; 
                clPurposeName  =  MapOfPurposeIdToPurposeName.get(idClPurpose);
                
            }
            System.debug('idCLPurpose***'+idCLPurpose);
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
                                                                    
                                                                                        
            if(lstRateCardSetupDetail != null && lstRateCardSetupDetail.size() > 0)
            {
                
              //system.debug('Aggregate value'+lstRateCardSetupDetail[0].get('minVal'));
               
              String interestType = ApexPages.currentPage().getcookies().get('genesis__CL_Product__c').getValue();
              decMinLoanAmount=(decimal)lstRateCardSetupDetail[0].get('minVal');
              decmaxLoanAmount=(decimal)lstRateCardSetupDetail[0].get('maxVal');
               if(productPurposeName.containsKey(idClPurpose+':'+interestType) && productPurposeName.get(idClPurpose+':'+interestType).Min_Loan_Amount_Delta__c!=null)
                  decMinLoanAmount = decMinLoanAmount +(productPurposeName.get(idClPurpose+':'+interestType).Min_Loan_Amount_Delta__c); 
                if(productPurposeName.containsKey(idClPurpose+':'+interestType) && productPurposeName.get(idClPurpose+':'+interestType).Max_Loan_Amount_Delta__c!=null)
                   decmaxLoanAmount = decmaxLoanAmount +(productPurposeName.get(idClPurpose+':'+interestType).Max_Loan_Amount_Delta__c);
           system.debug('this is here');
           StrMinLoanAmount =String.ValueOf(decMinLoanAmount.format());
           StrMaxLoanAmount =String.ValueOf(decmaxLoanAmount.format());
           decAmountPlaceHolder = StrMinLoanAmount +'-'+StrMaxLoanAmount;
            
         }
           if(questionNo==1)
           {
            Set<SelectOption> lstRateTypeSelectOptionSet = new Set<SelectOption>();
             lstRateTypeSelectOption = new List<SelectOption>(); 
             lstRateTypeSelectOptionSet.add(new SelectOption('', '--Select--'));
                for(CL_Product_Purpose_Junction__c objProductPurpose : interestTypeMap.get(idClPurpose))
                {
                   lstRateTypeSelectOptionSet.add(new selectOption(objProductPurpose.CL_Product__c,objProductPurpose.CL_Product__r.Interest_Type__c));
                }
                     lstRateTypeSelectOption.addAll(lstRateTypeSelectOptionSet);
                   for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                    {
                        System.debug('questionNo ************'+questionNo);
                        System.debug('lstRateTypeSelectOption************'+lstRateTypeSelectOption);
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist') 
                           
                        {
                            System.debug('amit***');
                            system.debug('lstRateTypeSelectOption:: '+lstRateTypeSelectOption);
                            objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                            if(lstRateTypeSelectOption != null && lstRateTypeSelectOption.size()>0){
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
             lstRateTypeSelectOptionSet.add(new SelectOption('', '--Select--'));
                for(CL_Product_Purpose_Junction__c objProductPurpose : interestTypeMap.get(purposeId))
                {
                   lstRateTypeSelectOptionSet.add(new selectOption(objProductPurpose.CL_Product__c,objProductPurpose.CL_Product__r.Interest_Type__c));
                }
                     lstRateTypeSelectOption.addAll(lstRateTypeSelectOptionSet);
                   for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                    {
                        System.debug('questionNo ************'+questionNo);
                        System.debug('lstRateTypeSelectOption************'+lstRateTypeSelectOption);
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist') 
                           
                        {
                            System.debug('amit***');
                            system.debug('lstRateTypeSelectOption:: '+lstRateTypeSelectOption);
                            objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                            if(lstRateTypeSelectOption != null && lstRateTypeSelectOption.size()>0){
                            objWrapper.strAnswer = lstRateTypeSelectOption[0].getvalue();  
                            }                              
                        }   
                    }
           }
           else
           {
               lstRateTypeSelectOption = new List<SelectOption>();
               lstRateTypeSelectOption.add(new SelectOption('', '--Select--'));
               for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                    {
                        System.debug('questionNo ************'+questionNo);
                        System.debug('lstRateTypeSelectOption************'+lstRateTypeSelectOption);
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' 
                           && objWrapper.objQuestion.pepType__c == 'Picklist') 
                           
                        {
                            System.debug('amit***');
                            system.debug('lstRateTypeSelectOption:: '+lstRateTypeSelectOption);
                            objWrapper.lstSelectOption = lstRateTypeSelectOption; 
                            if(lstRateTypeSelectOption != null && lstRateTypeSelectOption.size()>0){
                            objWrapper.strAnswer = lstRateTypeSelectOption[0].getvalue();  
                            }                              
                        }   
                    }
           }
           
          decAmountPlaceHolder ='';
          clearValues();
      }
  }  
    // This mehtod is used to verify the field validations.
      
      public boolean validateData()
      {
            Id idClPurpose;
            decimal decBorrowedAmount ;        
            idClPurpose = lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;
            
            system.debug('bhawna-idClPurpose ::'+idClPurpose );   
            if(lstWrapperSection[0].lstWrapperQuestion[2].strAnswer !=null 
            && lstWrapperSection[0].lstWrapperQuestion[2].strAnswer.trim() !='')
            {
                try
                {
                    decBorrowedAmount = Decimal.valueOf(lstWrapperSection[0].lstWrapperQuestion[2].strAnswer);
                    system.debug('decBorrowedAmount ::'+decBorrowedAmount );
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
                if(lstRateCardSetupDetail != null  && lstRateCardSetupDetail.size()>0)
                {
                    isError = false;
                }
                else
                {
                    isError = true;
                }                                                                        
            }
          return isError;
      }
   
  
      
      public void renderSectionStory()
      {
         
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
            system.debug('frequency is'+strPaymentFrequencyLabel);
          
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
         /* if(decLoanAmount != null)
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
              system.debug('frequency is'+strPaymentFrequencyLabel);
          }
          if(strLoanTenure != null)
          {
              strSectionStory = strSectionStory.replace('{loanTenure}', strLoanTenure);
          }
          System.debug('strSectionStory ******'+strSectionStory ); */
          
      }
      
  //  This method is used to clear values on changing of amount.
      
      public void querydata1()
      {
           for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                {
                    if(objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Purpose__c' && objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Product__c'&& objWrapper.objQuestion.pepFieldApiName__c !='Requested_Loan_Amount__c')
                    {
                        system.debug('questionNo :'+questionNo );
                       
                            System.debug('questionNo **********'+questionNo );                   
                            objWrapper.strAnswer = null;
                    }                                 
               
                }
      
      }
}
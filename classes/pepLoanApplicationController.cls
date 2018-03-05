public  class pepLoanApplicationController
    {               //added on 2nd august 
           // list <FiscalYearSettings> l = [SELECT id , name, StartDate, WeekStartDay,YearType FROM FiscalYearSettings];
            // end of code
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
        public pepCmsModelContainer_new  modelConInstance_new{get;set;}
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
        @TestVisible List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail;
       // map<Id,string> mpCLProductIdToProductName;
        public String StrMinLoanAmount{get;set;}
        public String StrMaxLoanAmount{get;set;}
        
        public String Page_Name{get;set;}//Added by KG
        public String Page_Label{get;set;}//Added by KG
        public String decAmountPlaceHolder{get;set;}
        public String clPurposeName{get;set;}
        //Added by IJ These parameters would be fetched from the URL and saved against the application for staff loans and other purposes
        public string p1;
        public string p2;
        public string p3;
        public string p4;
        // Code block ends - IJ

        public pepLoanApplicationController()
        {
             strurl = ApexPages.currentPage().getUrl(); 
            system.debug('bhawna--strurl' +strurl );             
            if(strurl.contains('?'))
            {
                strurl = strurl.substringBefore('?');
            }
            
            strurl = strurl.split('apex/')[1]; 
            if(strurl !='pepLoanDetails' && strurl !='pepApplyNow' || (strurl=='pepApplyNow' && ApexPages.currentPage().getparameters().get('p1')!=null)){
            clearcookies();
            }
             page_Name=ApexPages.currentPage().getUrl();//Added by KG
             page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());//Added by KG
            Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
        
            //Added by IJ
            
            
            System.debug('CONSTRUCTOR>>>>>>>>');
            objApplication = new  genesis__Applications__c(); 
            MapOfPurposeIdToPurposeName = new Map<id,String>();                      
            //mpCLProductIdToProductName =  new map<Id,string>();
            referralCode= apexpages.currentpage().getparameters().get('Ref');
            modelConInstance_new = new pepCmsModelContainer_new();
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
              
            
            
            if(strurl == 'pepLoanDetails')
            {
                System.debug('HIIIIIIIIIIIi'+ApexPages.currentPage().getcookies());
                getCookieData();
                fetchApplication();
                FilterValues();
                fetchAllRateCard();
                loadCMSContentForLoanDetails();
               if(objApplication.id != null)
               { 
                    FilterValues();
                    fetchAllRateCard();
                    System.debug('HIIIIIIIIIIIi');
                    loadCMSContentForLoanDetails();
               }
                
                 
            } 
            
            if(strurl == 'pepApplyNow')
            { 
                //entered by varun to load the Application through cookies.
                System.debug('entered'+ApexPages.currentPage().getcookies());
                loadApplicationfromcookie();
                system.debug('========'+objApplication);
                loadCMSContentForApplyPage();
                p1 = ApexPages.currentPage().getParameters().get('p1');
            p2 = ApexPages.currentPage().getParameters().get('p2');         
            p3 = ApexPages.currentPage().getParameters().get('p3');
            p4 = ApexPages.currentPage().getParameters().get('p4');
            
            if(p1 != null)
            {
                if(p1.length()>255)
                {
                    p1 = p1.substring(0,255);
                }
                Cookie param1 = new cookie('param1',p1,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param1});
            }
            else
            {
                p1 = '';
                if(ApexPages.currentPage().getcookies().get('param1') != null && ApexPages.currentPage().getcookies().get('param1').getvalue()!= null && ApexPages.currentPage().getcookies().get('param1').getvalue()!= ''){
                Cookie param1 = new cookie('param1','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param1});
                }
            }
            
            
            if(p2 != null)
            {
                if(p2.length()>255)
                {
                    p2 = p2.substring(0,255);
                }
                Cookie param2 = new cookie('param2',p2,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param2});
            }
            
            else
            {
                p2 = '';
                if(ApexPages.currentPage().getcookies().get('param2') != null && ApexPages.currentPage().getcookies().get('param2').getvalue()!= null && ApexPages.currentPage().getcookies().get('param2').getvalue()!= ''){
                Cookie param2 = new cookie('param2','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param2});
                }
                
            }            
            
            if(p3 != null)
            {
                if(p3.length()>255)
                {
                    p3 = p3.substring(0,255);
                }
                Cookie param3 = new cookie('param3',p3,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param3});
            }
            else
            {
                p3 = '';
                if(ApexPages.currentPage().getcookies().get('param3') != null && ApexPages.currentPage().getcookies().get('param3').getvalue()!= null && ApexPages.currentPage().getcookies().get('param3').getvalue()!= ''){
                Cookie param3 = new cookie('param3','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param3});
                }
            }            
            
            if(p4 != null)
            {
                if(p4.length()>255)
                {
                    p4 = p4.substring(0,255);
                }
                Cookie param4 = new cookie('param4',p4,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param4});
            }
            else
            {
                p4 = '';
                if(ApexPages.currentPage().getcookies().get('param4') != null && ApexPages.currentPage().getcookies().get('param4').getvalue()!= null && ApexPages.currentPage().getcookies().get('param4').getvalue()!= ''){
                Cookie param4 = new cookie('param4','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param4});
                }
            }            
            // Code block ends - IJ
                
            }
            loadDefaultCompany();     
                
        }
        
        
        public void getCookieData()
        {
            Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
            System.debug('cookieApplicationId **************'+cookieApplicationId);      
            if (cookieApplicationId == null)
            {
                //cookieApplicationId = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
                
            }        
            else if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
            {                           
               objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
            }
            
            
            
        }
        
        public void fetchApplication()
        {
            //hardcode application Id
            System.debug('method called');
            Map<string,string> childobjects = new Map<string,string>();       
            String[] lstTypes = new String[]{'Expense_and_Debt__c'};
            if(objApplication != null && objApplication.Id !=null)
            {
                
               List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
               System.debug('lstApplication  *********'+lstApplication);
                if(lstApplication != null && lstApplication.size() >0)
                {        
                    objApplication = lstApplication[0];
                }
                
                
            }
        }
        public void loadDefaultCompany()
        {
            pepDefaultCompany__c  objDefaultCompany = pepDefaultCompany__c.getInstance('Company Id');
            IdDefaultCompany = objDefaultCompany.pepDefault_Company_Id__c;
            idBusinessAccount = objDefaultCompany.pepBusinessAccount__c;
            System.debug('IdDefaultCompany*********'+IdDefaultCompany );
        
        }
       
        public void loadClPurpose()
        {
            System.debug('load cl pur'); 
            lstclPurposeSelectOption = new List<selectOption>(); 
           // lstclPurposeSelectOption.add(new SelectOption('', ''));   
           if(strurl == 'peplandingpage')
               lstclPurposeSelectOption.add(new SelectOption('', ''));
           else
               lstclPurposeSelectOption.add(new SelectOption('', 'choose one'));
            for(clcommon__CL_Purpose__c objPurpose : [select id,name from clcommon__CL_Purpose__c order by Serial_No__c asc limit 1000])
            {                
                lstclPurposeSelectOption.add(new SelectOption(objPurpose.Id, objPurpose.Name));
                MapOfPurposeIdToPurposeName.put(objPurpose.Id,objPurpose.name);
            }        
            
        }
        
        
        //This method queries data on rate card setup detail
        //based on CL Purpose selected
        //when we fill amount it identifies the exact rate card setup details
        //Then it fetches interest rate and calculate emi.
        
        public void querydata()
        {
            clearfieldcookies();
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
                   Cookie clpurpose = new cookie('clpurpose',idClPurpose,null,-1,false);
                   ApexPages.currentPage().setcookies(new cookie[]{clpurpose});
                   Integer QuesSequence = 1; 
                   decimal decBorrowedAmount ;
                    System.debug('QuesSequence ***********'+QuesSequence  ); 
                    System.debug('questionNo  ***********'+questionNo  );       
                    if(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[1].strAnswer !=null 
                       && lstWrapperSection[sectionNumber-1].lstWrapperQuestion[1].strAnswer.trim() !='')
                      try
                       {
                           decBorrowedAmount = Decimal.valueOf(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[1].strAnswer);
                           Cookie requestedLoanamount = new cookie('requestedLoanamount',string.valueof(decBorrowedAmount),null,-1,false);
                           ApexPages.currentPage().setcookies(new cookie[]{requestedLoanamount});
                           System.debug('kkkkkkkkkkkkkkkkkk88'+lstWrapperSection[sectionNumber-1].lstWrapperQuestion[1].strAnswer);
                          
                       }
                       catch(Exception exp)
                       {
                       pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('pepLoanApplicationController',exp)}) ;
                       } 
                     
                  if(decBorrowedAmount >= 0 && idClPurpose != null)
                  { 
                             
                    List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail = FilterValues();
                    System.debug('decBorrowedAmount ***'+decBorrowedAmount );
                    System.debug('decMinLoanAmount ***'+decMinLoanAmount );
                    System.debug('decMaxLoanAmount ***'+decMaxLoanAmount);
                    System.debug('lstRateCardSetupDetail  *******'+lstRateCardSetupDetail );
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
                    
                    FetchRateCardandCalculateEMI();
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
            
                           // return null;
            }                                                                            
            
        
       
        
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
                    if(objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Purpose__c')
                    {
                        system.debug('questionNo :'+questionNo );
                        objWrapper.lstSelectOption = null;
                        if(questionNo !=2  )
                        {
                            System.debug('questionNo **********'+questionNo );                   
                            objWrapper.strAnswer = null;
                        }                                 
                    }                                                          
                
                }
                
            }
        }
        
        public void clearValues1()
        {
            System.debug('in Method clear');
            if(sectionNumber != null && lstWrapperSection.size() >=sectionNumber)
            {
                decIndicativeInterestrate = null;
                decEmi =null;
                calculatedEMI =null;
                idClProduct =null;
                isError = false;
                
                 decimal decBorrowedAmount ; 
                 lstPaymentFrequency = new List<selectOption>(); 
                   // lstPaymentFrequency.add(new selectOption('','Choose one'));                           
                  //  lstCreditRating = new List<selectOption>(); 
                   // lstCreditRating.add(new selectOption('','')); 
                 Id idClPurpose =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;  
                    if(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[1].strAnswer !=null 
                       && lstWrapperSection[sectionNumber-1].lstWrapperQuestion[1].strAnswer.trim() !='')
                    try
                    {
                       decBorrowedAmount = Decimal.valueOf(lstWrapperSection[sectionNumber-1].lstWrapperQuestion[1].strAnswer);
                    }
                    catch(Exception exp)
                   {
                     pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('pepLoanApplicationController',exp)}) ;
                  }
                system.debug('decBorrowedAmount ::'+decBorrowedAmount );
                for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                {
                    if(objWrapper.objQuestion.pepFieldApiName__c !='genesis__CL_Purpose__c')
                    {
                        system.debug('questionNo :'+questionNo );
                        objWrapper.lstSelectOption = null; // commented by bhawna
                        if(questionNo !=2  )                   
                        objWrapper.strAnswer = null;  
                        
                        if(objWrapper.objQuestion.pepFieldApiName__c =='Requested_Term__c' &&  objWrapper.objQuestion.pepType__c == 'Picklist')
                        {
                          System.debug('bhawna*******'+objApplication.Requested_Term__c);
                          List<selectOption> lstSelectOption = new List<selectOption>();                                 
                          objWrapper.lstSelectOption = lstTermSelectOption;     
                          objWrapper.strAnswer= null;
                        } 
                        
                         if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__Payment_Frequency__c' &&  objWrapper.objQuestion.pepType__c == 'Picklist' )
                         {
                             string strQuery =  'Select Id , genesis__Minimum_Financed_Amount__c, genesis__Min_Term__c, genesis__Max_Term__c, genesis__Credit_Rating__c,'; 
                                        strQuery += 'genesis__Credit_Rating__r.Name,genesis__Maximum_Financed_Amount__c, genesis__Payment_Frequency__c, genesis__Interest_Rate__c '; 
                                        strQuery += ' from genesis__Rate_Card_Setup_Detail__c where id !=null';
                                       
                                    System.debug('decBorrowedAmount ****'+decBorrowedAmount ); 
                                    System.debug('idCLPurpose****'+idCLPurpose);
                                    if(idCLPurpose != null)
                                    {
                                         strQuery += ' and genesis__Rate_Card_Setup_Header__r.CL_Purpose__c  =:idClPurpose';
                                    }
                                    
                                   // if(decBorrowedAmount != null)
                                  //  {
                                  //       strQuery += ' and genesis__Minimum_Financed_Amount__c <=:decBorrowedAmount ';
                                  //       strQuery += ' and genesis__Maximum_Financed_Amount__c >=:decBorrowedAmount ';
                                   //}
                                    
                                   // if(strpaymentFreQuency  != null)
                                   // {
                                    //     strQuery += ' and genesis__Payment_Frequency__c   =:strpaymentFreQuency ';
                                   // }
                                    //if(decYear != null)
                                    //{
                                     //    strQuery += ' and genesis__Min_Term__c  <=:decYear';
                                     //    strQuery += ' and genesis__Max_Term__c  >=:decYear';
                                    //}
                                    //if(strcreditRating != null)
                                    //{
                                    //     strQuery += ' and genesis__Credit_Rating__c =:strcreditRating';
                                    //}
                                strQuery +=  ' order by genesis__Credit_Rating__r.Serial_No__c asc limit 50000'; 
                                lstRateCardSetupDetail = database.query(strQuery); 
                                
                                system.debug('Rate card setup details:: '+lstRateCardSetupDetail );
                            /* if(lstRateCardSetupDetail != null && lstRateCardSetupDetail.size() > 0)
                             {
                                  set<String> struniquepaymentfrequecnySet = new set<String>();
                                 for(genesis__Rate_Card_Setup_Detail__c objratecardDetail : lstRateCardSetupDetail)
                                 {
                                     if(objratecardDetail.genesis__Payment_Frequency__c != null )
                                     {
                                         system.debug('Frequency:: '+objratecardDetail.genesis__Payment_Frequency__c);
                                            if(!struniquepaymentfrequecnySet.contains(objratecardDetail.genesis__Payment_Frequency__c))
                                            {   //Changes
                                                if(objratecardDetail.genesis__Payment_Frequency__c.tolowercase() =='bi-weekly') 
                                                {
                                                    //objratecardDetail.genesis__Payment_Frequency__c = 'fortnightly';
                                                    lstPaymentFrequency.add(new selectOption(objratecardDetail.genesis__Payment_Frequency__c,'fortnightly'));
                                                }
                                                else{
                                                    lstPaymentFrequency.add(new selectOption(objratecardDetail.genesis__Payment_Frequency__c,objratecardDetail.genesis__Payment_Frequency__c));
                                                }
                                            }
                                            //lstPaymentFrequency.sort();
                                     }
                                     struniquepaymentfrequecnySet.add(objratecardDetail.genesis__Payment_Frequency__c);
                                     
                                 }
                                 
                                  objWrapper.lstSelectOption = lstPaymentFrequency;
                                   objWrapper.strAnswer= null;
                             }*/
                             
                             
                         }
                         
                        if(objWrapper.objQuestion.pepFieldApiName__c =='Debit_Frequency__c' && objWrapper.objQuestion.pepType__c == 'Picklist' )
                        {                           
                           objWrapper.lstSelectOption = lstPaymentFrequency;                        
                           objwrapper.strAnswer = null; 
                        }
                        
                        
                        // if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__Payment_Frequency__c' &&  objWrapper.objQuestion.pepType__c == 'Picklist' )
                         //{
                             //  System.debug('bhawna*******'+objApplication.genesis__Payment_Frequency__c);                       
                         ////      objWrapper.lstSelectOption = lstPaymentFrequency;
                            //   objWrapper.strAnswer= null;
                        //}  
                        
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__Credit_Rating__c' && objWrapper.objQuestion.pepType__c == 'Picklist' )
                        {
                           
                           objWrapper.lstSelectOption = lstCreditRating;                        
                           objwrapper.strAnswer = null; 
                        }
                          
                        if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' && objWrapper.objQuestion.pepType__c == 'Picklist' )
                        {
                           
                           objWrapper.lstSelectOption = lstRateTypeSelectOption;                        
                           objwrapper.strAnswer = null; 
                        }                    
                    }                                                          
                
                }
            }
        }
        
        
        public void FetchRateCardandCalculateEMI()
        {
            Decimal decAmount;
            decimal decyear;
            String strpaymentFreQuency;
            string strcreditRating;
            Id idClPurpose;
            String strrateType;
            if(sectionNumber != null && lstWrapperSection.size()>=sectionNumber) 
            {       
                for(wrapperApplication objWrapper:  lstWrapperSection[sectionNumber-1].lstWrapperQuestion)
                {
                       System.debug('strAnswer'+objWrapper.strAnswer);
                    
                       if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Purpose__c' )
                       {
                           idClPurpose = objWrapper.strAnswer;
                       }
                       
                       if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' )
                       {
                           strrateType = objWrapper.strAnswer;
                       }
                       
                       if(objWrapper.objQuestion.pepFieldApiName__c =='Requested_Term__c' )
                       {
                           if(objWrapper.strAnswer != null && objWrapper.strAnswer.trim()!='' )
                           decyear = Decimal.valueof(objWrapper.strAnswer)*12;
                           System.debug(decYEAr);
                       }
                       if(objWrapper.objQuestion.pepFieldApiName__c =='Requested_Loan_Amount__c' )
                       {
                          if(objWrapper.strAnswer != null && objWrapper.strAnswer.trim()!='')
                          decAmount = Decimal.valueof(objWrapper.strAnswer);
                       }
                       if(objWrapper.objQuestion.pepFieldApiName__c =='Debit_Frequency__c' )
                       {
                           strpaymentFreQuency = objWrapper.strAnswer;
                           strPaymentFrequencyLabel = strpaymentFreQuency ;
                       }
                       if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__Credit_Rating__c' )
                       {
                           strcreditRating = objWrapper.strAnswer;
                       } 
                   } 
              }
              system.debug('idClPurpose:: '+idClPurpose);
              system.debug('decAmount:: '+decAmount);
              system.debug('strpaymentFreQuency:: '+strpaymentFreQuency);
              system.debug('decYear:: '+decYear);
              system.debug('strcreditRating:: '+strcreditRating);
            system.debug('strcreditRating:: '+strrateType);
              
              if(strrateType != null)
              {   
              List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail =[select id,
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
                                                                                        
                   System.debug('*****'+lstRateCardSetupDetail.size());                                                                       
                   
                   if(lstRateCardSetupDetail != null && lstRateCardSetupDetail.size() > 0)
                   {
                      strPurposeName =lstRateCardSetupDetail[0].genesis__Rate_Card_Setup_Header__r.CL_Purpose__r.name;
                      
                      if(ApexPages.currentPage().getcookies().get('param1') != null && ApexPages.currentPage().getcookies().get('param1').getvalue()!= null && ApexPages.currentPage().getcookies().get('param1').getvalue()!=''){
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
}                 
                      if(decAmount != null && decIndicativeInterestrate != null
                          && decYear != null && strpaymentFreQuency != null)
                       {                 
                        //calculatedEMI  = pepUtilityClass.calculateLoanEmi(decAmount,decIndicativeInterestrate ,decYear/12,strpaymentFreQuency); 
                         LoanActions action = new LoanActions();
                         System.debug('decYear*12&**'+decYear*12);
                         calculatedEMI   = action.calculateMonthlyPaymentAmount(decAmount, decIndicativeInterestrate ,decYear, null);
                          if(calculatedEMI  != null)
                          {
                             // calculatedEMI = Math.round(calculatedEMI);
                                 if(strpaymentFreQuency=='weekly')
                                   {
                                      calculatedEMI   = ((calculatedEMI)*12/52) ;
                                      
                                   }
                                  
                                  else if(strpaymentFreQuency=='fortnightly')
                                  {
                                      calculatedEMI   = ((calculatedEMI)*12/26);
                                     
                                  }
                                  
                                Decimal dollars;
                                Decimal cents;
                                dollars = calculatedEMI.intValue();
                                cents = calculatedEMI- calculatedEMI.intValue();
                                cents = cents.setScale(2);                        
                                decEMI = dollars.format() + cents.toPlainString().substring(1);
                          }
                          system.debug('decYear:: '+decYear + ' -- strpaymentFreQuency::'+strpaymentFreQuency);
                          intNoOfPeriods = pepUtilityClass.calculateNoOfPaymentsBasedOnpaymentFrequency(decYear/12 ,strpaymentFreQuency);
                          system.debug('intNoOfPeriods:: '+intNoOfPeriods);
                      }
                      idClProduct = lstRateCardSetupDetail[0].genesis__Rate_Card_Setup_Header__r.genesis__CL_Product__c; 
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
                            cookie clpurpose=new cookie('clpurpose',idClPurpose,null,-1,false);
                            ApexPages.currentPage().setcookies(new cookie[]{clpurpose});
                           // isFormFilledFully = true;
                        }
                        else
                        {
                            isFormFilledFully =false;
                            //break;
                        }

                    }
                    
                    if(objWrapper.objQuestion.pepFieldApiName__c =='genesis__CL_Product__c' )
                    {
                       // strProductType = objWrapper.strAnswer;
                        System.debug('product answer id*****'+objWrapper.strAnswer);
                        
                        //if(strProductType != null && strProductType.trim()!= '')
                        if(objWrapper.strAnswer!=null)
                        {
                            objApplication.put('genesis__CL_Product__c',objWrapper.strAnswer);
                            cookie clproduct=new cookie('clproduct',objWrapper.strAnswer,null,-1,false);
                            ApexPages.currentPage().setcookies(new cookie[]{clproduct});
                           //objApplication.put('pep_Loan_Type__c',strProductType);
                           //isFormFilledFully = true;
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
                            cookie requestedterm=new cookie('requestedterm',string.valueof(decyear),null,-1,false);
                            ApexPages.currentPage().setcookies(new cookie[]{requestedterm});

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
                            cookie requestedLoanamount=new cookie('requestedLoanamount',String.valueof(decAmount),null,-1,false);
                            ApexPages.currentPage().setcookies(new cookie[]{requestedLoanamount});        
                            //isFormFilledFully = true;
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
                            cookie debitFrequency=new cookie('debitFrequency',strpaymentFreQuency,null,-1,false);
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
                             cookie creditRating=new cookie('creditRating',strcreditRating,null,-1,false);
                            ApexPages.currentPage().setcookies(new cookie[]{creditRating}); 
                            //isFormFilledFully = true;
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
                Cookie genesisaccount=new cookie('genesisaccount',String.valueof(objApplication.genesis__Account__c),null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{genesisaccount});
                if(IdDefaultCompany != null)
                {
                    objApplication.genesis__Company__c = IdDefaultCompany;
                    cookie genesiscompany=new cookie('genesiscompany',String.valueof(objApplication.genesis__Company__c),null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{genesiscompany});
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
                    //objApplication.put('genesis__Payment_Amount__c',calculatedEMI);
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
                objApplication =  pepInvokeCLMethodHelper.insertApplication(objApplication,relatedObjects ,childObjects );
                cookie applicationid1 =new cookie('applicationid1',objApplication.id,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{applicationid1});
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
                                       objWrapper.lstSelectOption = null;                                  
                                   }
                                   objWrapperSection.lstWrapperQuestion.add(objWrapper);                                                    
                             }         
                             lstWrapperSection.add(objWrapperSection);
                             System.debug('lstWrapperSection****'+lstWrapperSection);
                       }
                   
                   }
                   
                  
                   
               }                                                                 
         
        }
        
        private void loadCMSContentForApplyPage()
        {
        
           
                               
               List<pepCmsSection__c> lstlandingPageCmsSection =[select id,pepHeader__c,pepSectionUniqueName__c,
                                                                         (select id,pepLabelAfterQuestion__c,
                                                                                 pepLabelPriorQuestion__c,
                                                                                 pepSequence__c,pepIsRequired__c,
                                                                                 pepType__c,pepSubType__c,
                                                                                 pepGenericErrorMessage__c,
                                                                                 pepSObjectApiName__c,
                                                                                 pepFieldApiName__c
                                                                                 from pepQuestion__r order by pepSequence__c asc) 
                                                                                 from pepCmsSection__c where pepPage__r.pepPageName__c ='Apply Page'];   
              
             map<id,pepCmsQuestion__c> mapAllQuestions = new map<id,pepCmsQuestion__c>( [SELECT  pepSection__c,pepRecordSequence__c,pepSection__r.Name ,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                                    pepIsRequired__c, pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                                    pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, Id, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,
                                                                    (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                                            FROM pepCmsAnswer__r order by pepSequence__c ASC ), 
                                                                     (SELECT  pepSection__c,pepRecordSequence__c,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c ,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                                                              pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepRelatedCSS__c
                                                                            FROM CmsQuestion__r
                                                                            ORDER BY pepSequence__c ASC) 
                                                                    FROM pepCmsQuestion__c where pepPage__r.pepPageName__c ='Apply Page'
                                                                    ORDER BY pepSequence__c ASC]);
              
             
              
              system.debug('list is'+lstlandingPageCmsSection);
              
               if(lstlandingPageCmsSection != null && lstlandingPageCmsSection.size() > 0)
               { 
                   for(pepCmsSection__c objSection :lstlandingPageCmsSection)
                   {
                       if(objSection.pepQuestion__r != null && objSection.pepQuestion__r.size() > 0)
                       {                       
                             wrapperSection objWrapperSection = new wrapperSection();
                             objWrapperSection.objSection = objSection ;
                             objWrapperSection.lstWrapperQuestion = new List<wrapperApplication>();
                             for(pepCmsQuestion__c objQues : objSection.pepQuestion__r)
                             { 
                                   system.debug('objQues  is'+objQues ); 
                                   wrapperApplication objWrapper = new  wrapperApplication ();
                                   objWrapper.objQuestion = objQues;
                                   objWrapper.lstExpectedAnswers = new list<wrapperAnswer> ();
                                   for(pepCmsAnswer__c objAnswer : mapAllQuestions.get(objQues.Id).pepCmsAnswer__r)
                                   {
                                       wrapperAnswer objwrapperAnswer = new  wrapperAnswer();
                                       objwrapperAnswer.objCmsAnswer = objAnswer;                                       
                                       objWrapper.lstExpectedAnswers.add(objwrapperAnswer); 
                                   }
                                   objWrapperSection.lstWrapperQuestion.add(objWrapper);                                                    
                             }         
                             lstWrapperSection.add(objWrapperSection);
                       }
                   
                   }
                   
                  
                   
               }    system.debug('lstWrapperSection is'+lstWrapperSection);                                                             
         
        }
             
        private void loadCMSContentForLoanDetails()
        {
        
          //  FilterValues();
               if(objApplication.id == null)
               loadapplicationfromcookie();
               strurl = 'peploandetails';
               system.debug('objApplication'+ objApplication); 
               System.debug('objApplication.Requested_Loan_Amount__c&*******'+objApplication.Requested_Loan_Amount__c);          
               lstWrapperSection = new List<WrapperSection>();
               //if(objApplication != null)          
               //makePickListValues(objApplication.genesis__CL_Purpose__c,objApplication.Requested_Loan_Amount__c);
               
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
                                                                                 
               system.debug('lstlandingPageCmsSection '+lstlandingPageCmsSection );
              
               if(lstlandingPageCmsSection != null && lstlandingPageCmsSection.size() > 0)
               {
                   strSectionStory  =  lstlandingPageCmsSection[0].pepSectionStory__c;
                   strSectionHeader =  lstlandingPageCmsSection[0].pepHeader__c;
                   for(pepCmsSection__c objSection :lstlandingPageCmsSection)
                   {
                       if(objSection.pepQuestion__r != null && objSection.pepQuestion__r.size() > 0)
                       {      
                             system.debug('objSection.pepQuestion__r'+objSection.pepQuestion__r);                 
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
                                      System.debug('amit*******'+objApplication.Requested_Term__c);                                     
                                      System.debug('lstTermSelectOption****'+lstTermSelectOption); 
                                      
                                      //lstTermSelectOption.add(new SelectOption('', 'Choose one'));
                                      
                                      if(lstTermSelectOption != null)
                                      {   
                                          list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                                          lstSOTemp  = lstTermSelectOption; 
                                          lstTermSelectOption =new list<SelectOption>(); 
                                             
                                          for (SelectOption so : lstSOTemp  ){
                                              system.debug('so.getValue():: '+so.getValue());
                                            if (so.getValue() == '' || so.getValue() == 'choose one' ){
                                                so.setLabel('choose one');
                                                so.setValue('');
                                            }
                                            lstTermSelectOption.add(so);
                                         }
                                         system.debug('lstSOTemp::'+lstTermSelectOption);
                                          //objWrapper.lstSelectOption = new list<SelectOption>();
                                         // objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));                        
                                          objWrapper.lstSelectOption = lstTermSelectOption ;
                                      }
                                     
                                      if(objApplication != null && objApplication.Requested_Term__c != null )
                                      {
                                         
                                          System.debug('objApplication.Requested_Term__c******'+objApplication.Requested_Term__c);
                                          intRequestedTerm = Integer.valueOF(objApplication.Requested_Term__c);
                                          objwrapper.strAnswer = String.valueOf(intRequestedTerm);
                                          System.debug('objwrapper.strAnswer***'+objwrapper.strAnswer);
                                          
                                      }
                                       
                                   }
                                   
                                   if(objQues.pepFieldApiName__c =='Debit_Frequency__c' &&  objQues.pepType__c == 'Picklist' )
                                   {
                                       System.debug('swati*******'+objApplication.Debit_Frequency__c);
                                       system.debug('bhawna--lstPaymentFrequency'+lstPaymentFrequency);
                                       
                                      // lstPaymentFrequency.add(new SelectOption('', 'Choose one'));
                                       list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                                      if(lstPaymentFrequency!=null)
                                      {
                                          lstSOTemp  = lstPaymentFrequency ;
                                          lstPaymentFrequency =new list<SelectOption>(); 
                                          for (SelectOption so : lstSOTemp  ){
                                                  system.debug('so.getValue():: '+so.getValue());
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
                                           if(objApplication.Debit_Frequency__c == 'BI-WEEKLY') 
                                           {
                                               objwrapper.strAnswer = 'fortnightly'; 
                                               System.debug('swati1*******'+ objwrapper.strAnswer);
                                           }
                                           else if(objApplication.Debit_Frequency__c != 'BI-WEEKLY') 
                                           { 
                                               System.debug('bhawna--lstPaymentFrequency'+objApplication.Debit_Frequency__c);                              
                                               objwrapper.strAnswer = objApplication.Debit_Frequency__c.tolowercase();
                                           }
                                       } 
                                   }
                                   
                                   if(objQues.pepFieldApiName__c =='genesis__Credit_Rating__c' && objQues.pepType__c == 'Picklist' )
                                   {
                                       //lstCreditRating.add(new SelectOption('', 'Choose one'));
                                        list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                                      if(lstCreditRating!=null)
                                      {
                                          lstSOTemp  = lstCreditRating;
                                         lstCreditRating=new list<SelectOption>();
                                          for (SelectOption so : lstSOTemp  ){
                                                  system.debug('so.getValue():: '+so.getValue());
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
                                      // lstclPurposeSelectOption.add(new SelectOption('', 'Choose one'));
                                       list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                                      if(lstclPurposeSelectOption!=null)
                                      {
                                           lstSOTemp  = lstclPurposeSelectOption;
                                       lstclPurposeSelectOption=new list<SelectOption>();
                                          for (SelectOption so : lstSOTemp  ){
                                                  system.debug('so.getValue():: '+so.getValue());
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
                                       System.debug('lstRateTypeSelectOption*********'+lstRateTypeSelectOption);
                                       System.debug('objApplication.pep_Loan_Type__c*********'+objApplication.pep_Loan_Type__c);
                                       //lstRateTypeSelectOption.add(new SelectOption('', 'Choose one'));
                                        list<SelectOption> lstSOTemp  = new list<SelectOption>(); 
                                       if(lstRateTypeSelectOption!=null)
                                      {
                                          lstSOTemp  = lstRateTypeSelectOption;
                                          lstRateTypeSelectOption=new list<SelectOption>();
                                          for (SelectOption so : lstSOTemp  ){
                                                  system.debug('so.getValue():: '+so.getValue());
                                                if (so.getValue() == ''){
                                                    so.setLabel('choose one');
                                                }
                                                lstRateTypeSelectOption.add(so);
                                         }
                                         
                                      }
                                       objWrapper.lstSelectOption = lstRateTypeSelectOption;
                                       System.debug('objApplication.genesis__CL_Product__c'+lstRateTypeSelectOption); 
                                       System.debug('objApplication.genesis__CL_Product__c'+objApplication.genesis__CL_Product__c ); 
                                       if(objApplication != null && objApplication.genesis__CL_Product__c != null)
                                       {  
                                           objwrapper.strAnswer = objApplication.genesis__CL_Product__c;//mpCLProductIdToProductName.get(objApplication.genesis__CL_Product__c); 
                                       }                                 
                                   }
                                   objWrapperSection.lstWrapperQuestion.add(objWrapper);                                                    
                             }         
                             lstWrapperSection.add(objWrapperSection);
                       }
                   
                   }
                   
                  
                   
               }                                                                 
         
        }
        
        public class wrapperApplication
        {
            public pepCmsQuestion__c objQuestion{get;set;} 
            public List<wrapperAnswer> lstExpectedAnswers {get; set;}//answer of question    
           // public string strAnswer{get;set;}
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
            list<clcommon__CL_Product__c> lstCLProd = [select id,clcommon__Product_Name__c from clcommon__CL_Product__c];
            
            lstRateTypeSelectOption = new List<SelectOption>(); 
            lstPaymentFrequency = new List<selectOption>(); 
            
            if(strurl == 'peplandingpage' )
            {
                lstRateTypeSelectOption.add(new selectOption('',''));
                strPageName = 'Landing Page';
                lstPaymentFrequency.add(new selectOption('',''));  
            }                
            else
            {
                lstRateTypeSelectOption.add(new selectOption('','choose one'));                
                    strPageName = 'Loan Details';
                    //lstPaymentFrequency.add(new selectOption('','Choose one')); 
            }
               
                
            if(lstCLProd !=null && lstCLProd.size()>0)
            {
                for(clcommon__CL_Product__c objCLPr:lstCLProd  )
                {
                    system.debug('objCLPr-name:'+objCLPr);
                    lstRateTypeSelectOption.add(new selectOption(objCLPr.Id,objCLPr.clcommon__Product_Name__c));
                   // mpCLProductIdToProductName.put(objCLPr.Id, objCLPr.clcommon__Product_Name__c);
                    //lstRateTypeSelectOption.add(new selectOption('variable','variable'));
                }
            }
            
            
            system.debug('lstRateTypeSelectOption:: '+lstRateTypeSelectOption);
            //System.debug('lstWrapperSection[0].lstWrapperQuestion[0].strAnswer'+lstWrapperSection[0].lstWrapperQuestion[0].strAnswer);
            if(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != '')
            idClPurpose =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;
            else if(ApexPages.currentPage().getcookies().get('clpurpose') != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() !=''){  
            idClPurpose = ApexPages.currentPage().getcookies().get('clpurpose').getvalue();
            lstWrapperSection[0].lstWrapperQuestion[0].strAnswer= ApexPages.currentPage().getcookies().get('clpurpose').getvalue();
            
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
                    if((objCMSQ.pepSection__r.pepSectionUniqueName__c == 'LandingPageSection1'|| objCMSQ.pepSection__r.pepSectionUniqueName__c == 'LoanDetailsSection1') &&  objCMSQ.pepFieldApiName__c == 'Debit_Frequency__c')
                    {
                        System.debug('strUL*********'+strurl);
                        for(pepCmsAnswer__c objAns: objCMSQ.pepCmsAnswer__r)
                        {
                            if(strurl == 'peplandingpage' && objAns.pepDisplayText__c.tolowerCase()== 'choose one' )
                            {// do nothing                                
                            }else
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
            system.debug('lstPaymentFrequency ::'+lstPaymentFrequency);   
            /*if(modelConInstance.objApplication.genesis__CL_Purpose__c!=null)
            {    
                idClPurpose =  modelConInstance.objApplication.genesis__CL_Purpose__c;//lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;   
            }else
            {
                idClPurpose =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer; 
            }*/
           /* if( modelConInstance!=null &&  modelConInstance.objApplication!=null &&  
                modelConInstance.objApplication.Requested_Loan_Amount__c!=null && modelConInstance.objApplication.Requested_Loan_Amount__c>0)
            {
                    decAmount =  modelConInstance.objApplication.Requested_Loan_Amount__c;
                    decLoanAmount = decAmount;
            }*/
            
           if(lstWrapperSection[0].lstWrapperQuestion[1].strAnswer != null 
               && lstWrapperSection[0].lstWrapperQuestion[1].strAnswer.trim() !=''
               || (1 < questionNo ) || (ApexPages.currentPage().getcookies().get('requestedLoanamount') != null && strPageName == 'Loan Details') )
           {           
               if(lstWrapperSection[0].lstWrapperQuestion[1].strAnswer !=null && lstWrapperSection[0].lstWrapperQuestion[1].strAnswer !=''){
               decAmount =  Decimal.ValueOF(lstWrapperSection[0].lstWrapperQuestion[1].strAnswer);
               decLoanAmount = decAmount;
               }
               else if(ApexPages.currentPage().getcookies().get('requestedLoanamount') != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue()!=''){
               decAmount=Decimal.valueof(ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue()); 
               decLoanAmount = decAmount;
               lstWrapperSection[0].lstWrapperQuestion[1].strAnswer=ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue();
               }
           }
           if(lstWrapperSection[0].lstWrapperQuestion[2].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[2].strAnswer != '')
           strProductType =  lstWrapperSection[0].lstWrapperQuestion[2].strAnswer;
           else if(ApexPages.currentPage().getcookies().get('clproduct')!=null && ApexPages.currentPage().getcookies().get('clproduct').getvalue()!=null && ApexPages.currentPage().getcookies().get('clproduct').getvalue()!=''){
           strProducttype=ApexPages.currentPage().getcookies().get('clproduct').getvalue();
           lstWrapperSection[0].lstWrapperQuestion[2].strAnswer=ApexPages.currentPage().getcookies().get('clproduct').getvalue();
           }
           
           if(lstWrapperSection[0].lstWrapperQuestion[3].strAnswer != null && (3 < questionNo ))
           {
               
               if(lstWrapperSection[0].lstWrapperQuestion[3].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[3].strAnswer !=''){
               decyear =  Decimal.valueOf(lstWrapperSection[0].lstWrapperQuestion[3].strAnswer)*12;
               strLoanTenure = String.ValueOf(decyear/12);
           }
               else if(ApexPages.currentPage().getcookies().get('requestedterm')!=null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue()!=null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue()!=''){
                decyear =  Decimal.valueOf(ApexPages.currentPage().getcookies().get('requestedterm').getvalue())*12;
                strLoanTenure = String.ValueOf(decyear/12);
                lstWrapperSection[0].lstWrapperQuestion[3].strAnswer=ApexPages.currentPage().getcookies().get('requestedterm').getvalue();
               }
           }
           
           if(lstWrapperSection[0].lstWrapperQuestion[4].strAnswer != null && 4 < questionNo )
           {
               strpaymentFreQuency =  lstWrapperSection[0].lstWrapperQuestion[4].strAnswer;
           }
           else if(ApexPages.currentPage().getcookies().get('debitFrequency') != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != ''){
              strpaymentFreQuency =ApexPages.currentPage().getcookies().get('debitFrequency').getvalue();
              lstWrapperSection[0].lstWrapperQuestion[4].strAnswer=ApexPages.currentPage().getcookies().get('debitFrequency').getvalue();
           }
           if(lstWrapperSection[0].lstWrapperQuestion[5].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[5].strAnswer !='' && 5 < questionNo  )
           {
               strcreditRating =  lstWrapperSection[0].lstWrapperQuestion[5].strAnswer;
           }
           else if(ApexPages.currentPage().getcookies().get('creditRating') != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != ''){
           strcreditRating =ApexPages.currentPage().getcookies().get('creditRating').getvalue();
           lstWrapperSection[0].lstWrapperQuestion[5].strAnswer=ApexPages.currentPage().getcookies().get('creditRating').getvalue();
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
                    /*if(strcreditRating != null)
                    {
                         strQuery += ' and genesis__Credit_Rating__c =:strcreditRating';
                    }*/
                strQuery +=  ' order by genesis__Credit_Rating__r.Serial_No__c asc limit 50000';  
                //List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail = database.query(strQuery);
                lstRateCardSetupDetail = database.query(strQuery);
                System.debug('query****'+strQuery);
                System.debug('lstRateCardSetupDetail ****'+lstRateCardSetupDetail.size());
                if(lstRateCardSetupDetail != null && lstRateCardSetupDetail.size() > 0)
                {
                    //make year picklist
                    system.debug('strurl ::'+strurl );
                    lstTermSelectOption = new List<selectOption>();
                    if(strurl == 'peplandingpage' )
                        lstTermSelectOption.add(new selectOption('',''));                        
                    else
                         lstTermSelectOption.add(new selectOption('','choose one'));
                    //lstPaymentFrequency = new List<selectOption>(); 
                    //if(strurl == 'peplandingpage' )
                     //   lstPaymentFrequency.add(new selectOption('',''));                          
                   // else     
                    //       lstPaymentFrequency.add(new selectOption('','Choose one'));                 
                    lstCreditRating = new List<selectOption>(); 
                    if(strurl == 'peplandingpage' )
                        lstCreditRating.add(new selectOption('',''));                         
                    else
                        lstCreditRating.add(new selectOption('','choose one'));  
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
                        
                      
                        /*if(objratecardDetail.genesis__Payment_Frequency__c != null )
                        {
                            System.debug('objratecardDetail.genesis__Payment_Frequency__c********'+objratecardDetail.genesis__Payment_Frequency__c);
                            System.debug('struniquepaymentfrequecnySet********'+struniquepaymentfrequecnySet);
                            if(!struniquepaymentfrequecnySet.contains(objratecardDetail.genesis__Payment_Frequency__c))
                            {   //Changes
                                if(objratecardDetail.genesis__Payment_Frequency__c.tolowercase() =='bi-weekly') 
                                {
                                    //objratecardDetail.genesis__Payment_Frequency__c = 'fortnightly';
                                    lstPaymentFrequency.add(new selectOption(objratecardDetail.genesis__Payment_Frequency__c,'fortnightly'));
                                }
                                else{
                                lstPaymentFrequency.add(new selectOption(objratecardDetail.genesis__Payment_Frequency__c,objratecardDetail.genesis__Payment_Frequency__c));
                                }
                            }
                            system.debug('Bhawna-payment frequency:;'+lstPaymentFrequency);
                            
                            
                            //lstPaymentFrequency.sort();
                        }*/
                        
                        if(objratecardDetail.genesis__Credit_Rating__c != null)
                        {
                             if(!struniquecreditratingSet.contains(objratecardDetail.genesis__Credit_Rating__c))
                             lstCreditRating.add(new selectOption(objratecardDetail.genesis__Credit_Rating__c,objratecardDetail.genesis__Credit_Rating__r.name));
                             //lstCreditRating.sort();
                        }
                        struniquepaymentfrequecnySet.add(objratecardDetail.genesis__Payment_Frequency__c);
                        struniquecreditratingSet.add(objratecardDetail.genesis__Credit_Rating__c);
                    }
                    
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
                 return  lstRateCardSetupDetail;
        }
        //This method is used to update application from 2nd page.
         public PageReference ContinueApply()
         {
            System.debug('strSelectedValue*****************'+strSelectedValue1);
            if(objApplication != null)
            {
                //objApplication.Existing_Customer__c =  modelConInstance.objApplication.Existing_Customer__c;
                if(ReturnValue!=null && ReturnValue!='')
                   objApplication.IP_Address__c =  ReturnValue;        
                
                System.debug('modelConInstance.objApplication***'+modelConInstance.objApplication.Existing_Customer__c);
                if(objApplication.id != null || ApexPages.currentPage().getcookies().get('applicationid1') != null)
                {
                    Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
                    if(objApplication.id != null)
                    objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
                    else if(ApexPages.currentPage().getcookies().get('applicationid1').getvalue() != null)
                    objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(ApexPages.currentPage().getcookies().get('applicationid1').getvalue())),null,-1,false);
                   
                    //objCookie = new Cookie('ApplicationId',objApplication.Id,null,-1,false);
                    Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();
                    Map<String,SObject> relatedObjects = new Map<String,SObject>();
                    String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepIncomePage');
                    Map<string,string> childobjects1 = new Map<string,string>();       
          
            if(ApexPages.currentPage().getcookies().get('applicationid1') != null &&  ApexPages.currentPage().getcookies().get('applicationid1').getvalue() != null)
            {
                
               List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,ApexPages.currentPage().getcookies().get('applicationid1').getvalue(),null,null,childobjects1 );
               System.debug('lstApplication  *********'+lstApplication);
                if(lstApplication != null && lstApplication.size() >0)
                {        
                    objApplication = lstApplication[0];
                }
                
                
            }
                    objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                    
                    // Added by IJ
                    objApplication.pepP1__c = P1; 
                    objApplication.pepP2__c = P2; 
                    objApplication.pepP3__c = P3; 
                    objApplication.pepP4__c = P4; 
                    loadApplicationfromcookie();
                    //Code block ends - IJ                               
                    objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
                    system.debug('strSelectedValueIncome' + strSelectedValue);
                    string redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
                    objNextPage =new Pagereference('/'+redircetPageName);
                    setcookies();
                    objNextPage.setCookies(new Cookie[]{objCookie}); 
                    objNextPage.setRedirect(true);
                    return objNextPage;
                }
                
                else
                {
                    system.debug('strSelectedValue*************' + strSelectedValue);
                    loadCMSContentForLoanDetails();
                    String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepLoanDetails');
                    objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                    string redircetPageName= pages_config__c.getinstance('peploandetails').Page_Label__c;
                    objNextPage =new Pagereference('/'+redircetPageName);                      
                  //pageReference objNextPage = Page.pepLoanDetails;
                    objNextPage.setRedirect(false);
                    return objNextPage;
                }
            }
            
            
            return null;
        }

        //This method is used to call the Landing Page on the click of Edit link on second page.   
        public PageReference BackOnLandingPage() {
            string redircetPageName= pages_config__c.getinstance('peplandingpage').Page_Label__c;
            pageReference objPreviousPage = new Pagereference('/'+redircetPageName); 
            objPreviousPage.setRedirect(false);
            return objPreviousPage ;
        } 
        
        //This method is used to call the Apply now Page on the click of back link on 3rd page.   
        public PageReference BackOnApplyPage() {
            string redircetPageName= pages_config__c.getinstance('pepapplynow').Page_Label__c;
            
            pageReference objPreviousPage = new Pagereference('/'+redircetPageName); 
            objPreviousPage.setRedirect(false);
            return objPreviousPage ;
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
                CommonMethodForInsertingApplication();
                modelConInstance.objApplication = objApplication; 
                system.debug('objAppl Swati' +objApplication);
            }
            catch(Exception exp)
            {
            pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('Application',exp)}) ;
            }
            loadCMSContentForApplyPage();
            string redircetPageName= pages_config__c.getinstance('pepapplynow').Page_Label__c;
            objNextPage=new Pagereference('/'+redircetPageName);               
            setcookies();
            objNextPage.setRedirect(true); 
            return objNextPage;        
        }
        //This method is used to save application on Loan Details page on the click of Continue button    
        public pageReference ContinueOnIncomePage()
        {
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
                                     
  
            if(objApplication.pepCurrent_Page__c == null)
            {
                objApplication.pepCurrent_Page__c = 2;
            }                                     
            CommonMethodForInsertingApplication();
            Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
            objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false); 
            //objCookie = new Cookie('ApplicationId',objApplication.Id,null,-1,false); 
            system.debug('objCookieeee***********'+objCookie);
            
            
            string redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
            pageReference objNextPage = new Pagereference('/'+redircetPageName);
            objNextPage.setCookies(new Cookie[]{objCookie}); 
            
            objNextPage.setRedirect(true); 
            return objNextPage;        
        }
        public pageReference retrieveAppCode()
        {
            string redircetPageName= pages_config__c.getinstance('pepretrieveapp').Page_Label__c;
            pageReference p1 = new Pagereference('/'+redircetPageName);
            p1.setRedirect(true); 
            return p1;      
        }
        public void fetchAllRateCard()
        {
            System.debug('section Number'+sectionNumber);
            System.debug('Ques Number'+questionNO);
            Id idCLPurpose;
            System.debug('========='+lstWrapperSection[0].lstWrapperQuestion[0].strAnswer);
             System.debug('========='+lstWrapperSection[0].lstWrapperQuestion[0].objquestion.pepFieldApiName__c);
            if(lstWrapperSection[0].lstWrapperQuestion[0].strAnswer != null && lstWrapperSection[0].lstWrapperQuestion[0].strAnswer !='')
            {
                idClPurpose    =  lstWrapperSection[0].lstWrapperQuestion[0].strAnswer; 
                clPurposeName  =  MapOfPurposeIdToPurposeName.get(idClPurpose);
                cookie clpurpose=new cookie('clpurpose',lstWrapperSection[0].lstWrapperQuestion[0].strAnswer,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{clpurpose});
                System.debug('@@@@@'+ApexPages.currentPage().getcookies().get('clpurpose'));
            }
            System.debug('idCLPurpose***'+idCLPurpose);
            decMinLoanAmount = 0;
            decmaxLoanAmount = 0; 
            decAmountPlaceHolder ='';
            StrMinLoanAmount ='';
            StrMaxLoanAmount ='';
            List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail =[select id,genesis__Interest_Rate__c,
                                                                                    genesis__Minimum_Financed_Amount__c,  
                                                                                    genesis__Maximum_Financed_Amount__c,                                                               
                                                                                    genesis__Rate_Card_Setup_Header__c ,
                                                                                    genesis__Rate_Card_Setup_Header__r.genesis__CL_Product__c,
                                                                                    genesis__Rate_Card_Setup_Header__r.CL_Purpose__r.name
                                                                                    from genesis__Rate_Card_Setup_Detail__c
                                                                                    where genesis__Rate_Card_Setup_Header__r.CL_Purpose__c =:idClPurpose
                                                                                    AND genesis__Rate_Card_Setup_Header__r.Type__c = 'Pre Credit Check'
                                                                                    ];
                                                                    
                                                                                        
            if(lstRateCardSetupDetail != null && lstRateCardSetupDetail.size() > 0)
            {
                
                for(genesis__Rate_Card_Setup_Detail__c objratecardDetail :lstRateCardSetupDetail)
                {                                                                          
                    if(objratecardDetail.genesis__Minimum_Financed_Amount__c != null 
                    && objratecardDetail.genesis__Maximum_Financed_Amount__c != null) 
                    { 
                    if(decMinLoanAmount == 0 && decmaxLoanAmount == 0)
                    {
                        decMinLoanAmount = objratecardDetail.genesis__Minimum_Financed_Amount__c;
                        decmaxLoanAmount = objratecardDetail.genesis__Maximum_Financed_Amount__c;
                    }
                    
                    else
                    {
                        if(objratecardDetail.genesis__Minimum_Financed_Amount__c < decMinLoanAmount)
                        {
                            decMinLoanAmount = objratecardDetail.genesis__Minimum_Financed_Amount__c;
                        }
                        
                        if(objratecardDetail.genesis__Maximum_Financed_Amount__c >= decmaxLoanAmount)
                        {
                            decmaxLoanAmount  = objratecardDetail.genesis__Maximum_Financed_Amount__c;
                        }
                    }
                    
                   
                    
                    System.debug('decMinLoanAmount***'+decMinLoanAmount);
                    System.debug('decmaxLoanAmount***'+decmaxLoanAmount);
                }
            }
           
           StrMinLoanAmount =String.ValueOf(decMinLoanAmount.format());
           StrMaxLoanAmount =String.ValueOf(decmaxLoanAmount.format());
           decAmountPlaceHolder = StrMinLoanAmount +'-'+StrMaxLoanAmount;
            
        }
        System.debug('decMinLoanAmount***'+decMinLoanAmount);
        System.debug('decmaxLoanAmount***'+decmaxLoanAmount); 
        clearValues();
      }
      
      public boolean validateData()
      {
            Id idClPurpose;
            decimal decBorrowedAmount ;        
            idClPurpose = lstWrapperSection[0].lstWrapperQuestion[0].strAnswer;
            
            system.debug('bhawna-idClPurpose ::'+idClPurpose );   
            if(lstWrapperSection[0].lstWrapperQuestion[1].strAnswer !=null 
            && lstWrapperSection[0].lstWrapperQuestion[1].strAnswer.trim() !='')
            {
                try
                {
                    decBorrowedAmount = Decimal.valueOf(lstWrapperSection[0].lstWrapperQuestion[1].strAnswer);
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
                                                                                 
               system.debug('lstlandingPageCmsSection '+lstlandingPageCmsSection );
              
           if(lstlandingPageCmsSection != null && lstlandingPageCmsSection.size() > 0)
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
          System.debug('strSectionStory ******'+strSectionStory );
          
      }
      
      public void test()
      {
         String strSelected = ApexPages.currentPage().getParameters().get('text');
         String rowNo = ApexPages.currentPage().getParameters().get('rowIndex');
         system.debug('strSelected Swati' +strSelected );
         system.debug('rowNo  Swati' +rowNo  );
         if(rowNo != null)
         {
             Integer intRowNo = Integer.valueOf(rowNo);
             for(WrapperApplication objWrapper: lstWrapperSection[intRowNo -1].lstWrapperQuestion)
             {
                 system.debug('objWrapper.objQuestion.pepFieldApiName__cSwati'+objWrapper.objQuestion.pepFieldApiName__c);
                 system.debug('objWrapper.objQuestion.pepType__cSwati'+ objWrapper.objQuestion.pepType__c);
             
                 if(objWrapper.objQuestion.pepFieldApiName__c =='Existing_Customer__c' && objWrapper.objQuestion.pepType__c == 'Button' )
                 {
                      objApplication.put(objWrapper.objQuestion.pepFieldApiName__c,strSelected);
                      Cookie existingcustomer = new cookie('existingcustomer',strSelected,null,-1,false);
                      ApexPages.currentPage().setcookies(new cookie[]{existingcustomer});
                      system.debug('objWrapper.objQuestion.pepFieldApiName__c' +objWrapper.objQuestion.pepFieldApiName__c);
                 }
             }
             
         }
         
        
         
      }
      
 Public Static Pagereference checkCookieAndRedirect(){
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
      Public  void loadApplicationfromcookie(){
      if(ApexPages.currentPage().getcookies().get('clpurpose') != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != '')
      objApplication.genesis__CL_Purpose__c=ApexPages.currentPage().getcookies().get('clpurpose').getvalue();
      if(ApexPages.currentPage().getcookies().get('clproduct') != null && ApexPages.currentPage().getcookies().get('clproduct').getvalue() != null && ApexPages.currentPage().getcookies().get('clproduct').getvalue() != '')
      objApplication.genesis__CL_Product__c=ApexPages.currentPage().getcookies().get('clproduct').getvalue();
      if(ApexPages.currentPage().getcookies().get('requestedterm') != null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue() != null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue() != '')
      objApplication.Requested_Term__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('requestedterm').getvalue());
      if(ApexPages.currentPage().getcookies().get('yearterm') != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != '')
      objApplication.genesis__Term__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('yearterm').getvalue());
      if(ApexPages.currentPage().getcookies().get('requestedLoanamount') != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != ''){
      objApplication.Requested_Loan_Amount__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue());
      objApplication.genesis__Loan_Amount__c=Decimal.valueof(ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue());
      } 
      if(ApexPages.currentPage().getcookies().get('debitFrequency') != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != '')
      objApplication.Debit_Frequency__c=ApexPages.currentPage().getcookies().get('debitFrequency').getvalue();
      if(ApexPages.currentPage().getcookies().get('creditRating') != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != '')
      objApplication.genesis__Credit_Rating__c=ApexPages.currentPage().getcookies().get('creditRating').getvalue();
      if(ApexPages.currentPage().getcookies().get('genesisaccount') != null && ApexPages.currentPage().getcookies().get('genesisaccount').getvalue() != null && ApexPages.currentPage().getcookies().get('genesisaccount').getvalue() != '')
      objApplication.genesis__Account__c=ApexPages.currentPage().getcookies().get('genesisaccount').getvalue();
      if(ApexPages.currentPage().getcookies().get('genesiscompany') != null && ApexPages.currentPage().getcookies().get('genesiscompany').getvalue() != null && ApexPages.currentPage().getcookies().get('genesiscompany').getvalue() != '')
      objApplication.genesis__Company__c=ApexPages.currentPage().getcookies().get('genesiscompany').getvalue();
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
       
      }
      Private void  setcookies(){
      if(ApexPages.currentPage().getcookies().get('clpurpose') != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue()!=null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != ''){  
            Cookie clpurpose = new cookie('clpurpose',ApexPages.currentPage().getcookies().get('clpurpose').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{clpurpose});
            }
            if(ApexPages.currentPage().getcookies().get('clproduct') != null && ApexPages.currentPage().getcookies().get('clproduct').getvalue()!=null && ApexPages.currentPage().getcookies().get('clproduct').getvalue() != ''){  
            Cookie clproduct = new cookie('clproduct',ApexPages.currentPage().getcookies().get('clproduct').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{clproduct});
            }
            if(ApexPages.currentPage().getcookies().get('requestedterm') != null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue()!=null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue() != ''){  
            Cookie requestedterm = new cookie('requestedterm',ApexPages.currentPage().getcookies().get('requestedterm').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{requestedterm});
            }
            if(ApexPages.currentPage().getcookies().get('yearterm') != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue()!=null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != ''){  
            Cookie yearterm = new cookie('yearterm',ApexPages.currentPage().getcookies().get('yearterm').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{yearterm});
            }
            if(ApexPages.currentPage().getcookies().get('requestedLoanamount') != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue()!=null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != ''){  
            Cookie requestedLoanamount = new cookie('requestedLoanamount',ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{requestedLoanamount});
            }
            if(ApexPages.currentPage().getcookies().get('debitFrequency') != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue()!=null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != ''){  
            Cookie debitFrequency = new cookie('debitFrequency',ApexPages.currentPage().getcookies().get('debitFrequency').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{debitFrequency});
            }
            if(ApexPages.currentPage().getcookies().get('creditRating') != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue()!=null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != ''){  
            Cookie creditRating = new cookie('creditRating',ApexPages.currentPage().getcookies().get('creditRating').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{creditRating});
            }
            if(ApexPages.currentPage().getcookies().get('genesisaccount') != null && ApexPages.currentPage().getcookies().get('genesisaccount').getvalue()!=null && ApexPages.currentPage().getcookies().get('genesisaccount').getvalue() != ''){  
            Cookie genesisaccount = new cookie('genesisaccount',ApexPages.currentPage().getcookies().get('genesisaccount').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{genesisaccount});
            }
            if(ApexPages.currentPage().getcookies().get('genesiscompany') != null && ApexPages.currentPage().getcookies().get('genesiscompany').getvalue()!=null && ApexPages.currentPage().getcookies().get('genesiscompany').getvalue() != ''){  
            Cookie genesiscompany = new cookie('genesiscompany',ApexPages.currentPage().getcookies().get('genesiscompany').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{genesiscompany});
            }
            if(ApexPages.currentPage().getcookies().get('genesisproducttype') != null && ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue()!=null && ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue() != ''){  
            Cookie genesisproducttype = new cookie('genesisproducttype',ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{genesisproducttype});
            }
            if(ApexPages.currentPage().getcookies().get('genesisinterestrate') != null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue()!=null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue() != ''){  
            Cookie genesisinterestrate = new cookie('genesisinterestrate',ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{genesisinterestrate});
            }
            if(ApexPages.currentPage().getcookies().get('debitAmount') != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue()!=null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != ''){  
            Cookie debitAmount = new cookie('debitAmount',ApexPages.currentPage().getcookies().get('debitAmount').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{debitAmount});
            }
            if(ApexPages.currentPage().getcookies().get('ipAddress') != null && ApexPages.currentPage().getcookies().get('ipAddress').getvalue()!=null && ApexPages.currentPage().getcookies().get('ipAddress').getvalue() != ''){  
            Cookie ipAddress = new cookie('ipAddress',ApexPages.currentPage().getcookies().get('ipAddress').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{ipAddress});
            }
            if(ApexPages.currentPage().getcookies().get('applicationid1') != null && ApexPages.currentPage().getcookies().get('applicationid1').getvalue()!=null && ApexPages.currentPage().getcookies().get('applicationid1').getvalue() != ''){  
            Cookie applicationid1 = new cookie('applicationid1',ApexPages.currentPage().getcookies().get('applicationid1').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{applicationid1});
            }
            if(ApexPages.currentPage().getcookies().get('existingcustomer') != null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue()!=null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue() != ''){  
            Cookie existingcustomer = new cookie('existingcustomer',ApexPages.currentPage().getcookies().get('existingcustomer').getvalue(),null,-1,false);
            objNextPage.setcookies(new cookie[]{existingcustomer});
            }
            
      }
      Public void clearcookies(){
        if(ApexPages.currentPage().getcookies().get('clpurpose') != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != ''){
      Cookie clpurpose = new cookie('clpurpose','',null,0,false);
      ApexPages.currentPage().setcookies(new cookie[]{clpurpose});
    }
      if(ApexPages.currentPage().getcookies().get('clproduct') != null && ApexPages.currentPage().getcookies().get('clproduct').getvalue() != null && ApexPages.currentPage().getcookies().get('clproduct').getvalue() != ''){
       Cookie clproduct = new cookie('clproduct','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{clproduct});
      }
      if(ApexPages.currentPage().getcookies().get('requestedterm') != null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue() != null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue() != ''){
       Cookie requestedterm  = new cookie('requestedterm','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{requestedterm});
      }
      if(ApexPages.currentPage().getcookies().get('yearterm') != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != ''){
       Cookie yearterm  = new cookie('yearterm','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{yearterm});
      }
      if(ApexPages.currentPage().getcookies().get('requestedLoanamount') != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != ''){
       Cookie requestedLoanamount  = new cookie('requestedLoanamount','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{requestedLoanamount});
      } 
      if(ApexPages.currentPage().getcookies().get('debitFrequency') != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != ''){
       Cookie debitFrequency  = new cookie('debitFrequency','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{debitFrequency});
      }
      if(ApexPages.currentPage().getcookies().get('creditRating') != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != ''){
       Cookie creditRating  = new cookie('creditRating','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{creditRating});
      }
      if(ApexPages.currentPage().getcookies().get('genesisaccount') != null && ApexPages.currentPage().getcookies().get('genesisaccount').getvalue() != null && ApexPages.currentPage().getcookies().get('genesisaccount').getvalue() != ''){
       Cookie genesisaccount  = new cookie('genesisaccount','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{genesisaccount});
      }
      if(ApexPages.currentPage().getcookies().get('genesiscompany') != null && ApexPages.currentPage().getcookies().get('genesiscompany').getvalue() != null && ApexPages.currentPage().getcookies().get('genesiscompany').getvalue() != ''){
       Cookie genesiscompany  = new cookie('genesiscompany','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{genesiscompany});
      }
      if(ApexPages.currentPage().getcookies().get('genesisinterestrate') != null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue() != null && ApexPages.currentPage().getcookies().get('genesisinterestrate').getvalue() != ''){
       Cookie genesisinterestrate  = new cookie('genesisinterestrate','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{genesisinterestrate});
      }
      if(ApexPages.currentPage().getcookies().get('genesisproducttype') != null && ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue() != null && ApexPages.currentPage().getcookies().get('genesisproducttype').getvalue() != ''){
       Cookie genesisproducttype  = new cookie('genesisproducttype','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{genesisproducttype});
      }
     if(ApexPages.currentPage().getcookies().get('debitAmount') != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != ''){
       Cookie debitAmount  = new cookie('debitAmount','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{debitAmount});
     }
     if(ApexPages.currentPage().getcookies().get('idAddress') != null && ApexPages.currentPage().getcookies().get('idAddress').getvalue() != null && ApexPages.currentPage().getcookies().get('idAddress').getvalue() != ''){
       Cookie idAddress= new cookie('idAddress','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{idAddress});
     }
      
     if(ApexPages.currentPage().getcookies().get('existingcustomer') != null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue() != null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue() != ''){
       Cookie existingcustomer  = new cookie('existingcustomer','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{existingcustomer});
    }
     if(ApexPages.currentPage().getcookies().get('ApplicationId') != null && ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != null && ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != ''){
       Cookie ApplicationId = new cookie('ApplicationId','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{ApplicationId});
    }
    if(ApexPages.currentPage().getcookies().get('applicationid1') != null && ApexPages.currentPage().getcookies().get('applicationid1').getvalue() != null && ApexPages.currentPage().getcookies().get('applicationid1').getvalue() != ''){
       Cookie applicationid1= new cookie('applicationid1','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{applicationid1});
    }  
      if(ApexPages.currentPage().getcookies().get('param1') != null && ApexPages.currentPage().getcookies().get('param1').getvalue()!= null && ApexPages.currentPage().getcookies().get('param1').getvalue()!= ''){
                Cookie param1 = new cookie('param1','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param1});
                }
            
            
            
            
                if(ApexPages.currentPage().getcookies().get('param2') != null && ApexPages.currentPage().getcookies().get('param2').getvalue()!= null && ApexPages.currentPage().getcookies().get('param2').getvalue()!= ''){
                cookie param2 = new cookie('param2','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param2});
                }
                
               
          
                if(ApexPages.currentPage().getcookies().get('param3') != null && ApexPages.currentPage().getcookies().get('param3').getvalue()!= null && ApexPages.currentPage().getcookies().get('param3').getvalue()!= ''){
                cookie param3 = new cookie('param3','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param3});
                }
       
            
               
                if(ApexPages.currentPage().getcookies().get('param4') != null && ApexPages.currentPage().getcookies().get('param4').getvalue()!= null && ApexPages.currentPage().getcookies().get('param4').getvalue()!= ''){
                Cookie param4 = new cookie('param4','',null,0,false);
                ApexPages.currentPage().setcookies(new cookie[]{param4});
                }  
      } 
    Public void clearfieldcookies(){
       if(ApexPages.currentPage().getcookies().get('clproduct') != null && ApexPages.currentPage().getcookies().get('clproduct').getvalue() != null && ApexPages.currentPage().getcookies().get('clproduct').getvalue() != ''){
       Cookie clproduct = new cookie('clproduct','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{clproduct});
      }
      if(ApexPages.currentPage().getcookies().get('requestedterm') != null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue() != null && ApexPages.currentPage().getcookies().get('requestedterm').getvalue() != ''){
       Cookie requestedterm  = new cookie('requestedterm','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{requestedterm});
      }
      if(ApexPages.currentPage().getcookies().get('yearterm') != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != null && ApexPages.currentPage().getcookies().get('yearterm').getvalue() != ''){
       Cookie yearterm  = new cookie('yearterm','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{yearterm});
      }
      if(ApexPages.currentPage().getcookies().get('requestedLoanamount') != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != null && ApexPages.currentPage().getcookies().get('requestedLoanamount').getvalue() != ''){
       Cookie requestedLoanamount  = new cookie('requestedLoanamount','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{requestedLoanamount});
      } 
      if(ApexPages.currentPage().getcookies().get('debitFrequency') != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != null && ApexPages.currentPage().getcookies().get('debitFrequency').getvalue() != ''){
       Cookie debitFrequency  = new cookie('debitFrequency','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{debitFrequency});
      }
      if(ApexPages.currentPage().getcookies().get('creditRating') != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != null && ApexPages.currentPage().getcookies().get('creditRating').getvalue() != ''){
       Cookie creditRating  = new cookie('creditRating','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{creditRating});
      }
      if(ApexPages.currentPage().getcookies().get('debitAmount') != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != null && ApexPages.currentPage().getcookies().get('debitAmount').getvalue() != ''){
       Cookie debitAmount  = new cookie('debitAmount','',null,0,false);
       ApexPages.currentPage().setcookies(new cookie[]{debitAmount});
     }
    }
}
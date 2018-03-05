public class pepWelcomePageController 
{
    public string AccountId{get;set;}
    public Integer Step{get;set;}
    public List<loan__Loan_Account__c> lstLoanAccount{get;set;}
    public loan__Loan_Account__c objLoanAccount{get;set;}
    public List<Account> lstAccount{get;set;}
    public string PageLoanId{get;set;}
    public Account objAccount{get;set;}
    public loan__Automated_Payment_Setup__c objAutomatedPayment {get;set;}
    public String nextRepaymentAmount{get;set;}
    public String nextRepaymentDate{get;set;}
    public List<loan__Loan_Account__c> lstloancontract{get;set;}
    public String idLoanAccount{get;set;}
    public List<Attachment> lstAttachment{get;set;}
    public list<pepCmsSection__c> lstSection{get;set;}
    public string strAccountName {get;set;}
    public map<Id,loan__Automated_Payment_Setup__c >mapLoanAccountIdToAPS{get;set;}
    public List<loan__Automated_Payment_Setup__c> APSList;
    public List<date> apsDateList;
    public Map<date,loan__Automated_Payment_Setup__c> apsMap;
    public List<welcomePageWrapper> lstwelcomePageWrapper{get;set;}
    public string strsectionstory{get;set;}
    public String Page_Name{get;set;}
    public String Page_Label{get;set;}
    
    public List<pepCmsSection__c> lstLeftSideBarSections{get;set;}
    @testvisible Set<String> contractStatusSet ; 
    Public Map<String,String> retUrlMap{get;set;}
    Public String jsonretUrlMap{get{return JSON.serialize(retUrlMap);}set;}
    
    public class welcomePageWrapper
    {
        public loan__Loan_Account__c objLoanAccount;
        public Transient Date apsDate{get;set;}
        public Transient Decimal apsAmount{get;set;}
        public Boolean closedLoan{get;set;}
        public Transient String loanNumber{get;set;}
        public Transient String principlePaid{get;set;}
        public Transient String principleRemaining{get;set;}
        public Transient String lonaName{get;set;}
        public String loanId{get;set;}
        public Transient String progressBarWidth{get;set;}
        public Date settleDate;
    }
    
    public pepWelcomePageController ()
    {
        retUrlMap=new Map<String,String>();
        retUrlMap.put('pepwelcomepage',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepwelcomepage').Page_Label__c);
        retUrlMap.put('pepreferafriend',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepreferafriend').Page_Label__c);
        retUrlMap.put('pepcontactcentre',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepcontactcentre').Page_Label__c);
        retUrlMap.put('pepchangeprofile',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepchangeprofile').Page_Label__c);
        contractStatusSet = New Set<String> ();
        contractStatusSet.addall(Label.CLContractStatus.split(','));
        page_Name = 'pepWelcomePage';
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
        string pageName=ApexPages.currentPage().getUrl();
        pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        Step=pageStepNumber(pageName);
        lstAttachment = new List<Attachment> (); 
        APSList = new List<loan__Automated_Payment_Setup__c>();
        apsDateList = new list<date>();
        apsMap = new Map<date,loan__Automated_Payment_Setup__c>(); 
        lstLoanAccount = new List<loan__Loan_Account__c> ();
        lstSection = new list<pepCmsSection__c> ();
        strSectionStory = '';
        objLoanAccount = new loan__Loan_Account__c();
        lstAccount = new List<Account> ();
        mapLoanAccountIdToAPS = new map<Id,loan__Automated_Payment_Setup__c >();
        AccountId = pepUtilityClass.getAccountId();    
        system.debug('accountid' +AccountId);
        objAutomatedPayment = new loan__Automated_Payment_Setup__c ();
        objAccount = new Account();
        lstwelcomePageWrapper = new list<welcomePageWrapper>();
        getLoanAccountInformation();
        LoadMarketingAdInformation();    
    }
    
    public void getLoanAccountInformation()
    {
         
         Set<id> contractPAF  = new Set<id>();
         String  contractPLId = '';
        lstSection = [Select id,pepSectionBodyRich__c,pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Welcome' and pepSectionUniqueName__c = 'Welcome Section 1'limit 1];
        
        lstLeftSideBarSections =[select id,pepHeader__c,pepCss_Class__c,pepRedirect_to_Page__c from pepCmsSection__c where Page_Name__c='DashboardSideBarTemplate' order by pepSequence__c asc];

        if(lstSection != null && lstSection.size() > 0)
        {
           strSectionStory = lstSection[0].pepSectionBodyRich__c;
                      
        }
       
       system.debug('strSectionStory Swati' + strSectionStory); 
       
    //   added by Rishabh(for PAF) 
    
        if(AccountId != null)
        {
          // fetch accounts(with Pl contract and Party object) contains same five values(firstname,lastname,dob,email,moblieno) as loggedin user account.
              lstAccount = [Select id,pafss_Duplication_Check_Key__c,Name from Account where id=: AccountId limit 1];

               if(lstAccount != null && lstAccount.size() > 0)
               {
                   strSectionStory = strSectionStory.replace('AccountName',lstAccount[0].Name);
               }
                DashboardPAFSetting__c PAFSetting= DashboardPAFSetting__c.getValues('PAFDashboardSetting'); // maintain custom setting to show or hide PAF Contract on Dashbord       
       list<account> listAccount = new List<account> ();
       if(String.isNotBlank(lstAccount[0].pafss_Duplication_Check_Key__c)) 
           listAccount = [select id,name,(select id,pafss_Is_Individual_Loan__c,collect__CL_Contract__c,pafss_Contract_Type__c from clcommon__Parties__r where ScCollection_Contract_Source_System__c='PAF'),(select id from loan__Loan_Accounts__r) from Account where isPersonaccount=true and Is_Portal_User_Created__c=true and pafss_Duplication_Check_Key__c=:lstAccount[0].pafss_Duplication_Check_Key__c]; 
       else
           listAccount = [select id,name,(select id,pafss_Is_Individual_Loan__c,collect__CL_Contract__c,pafss_Contract_Type__c from clcommon__Parties__r where ScCollection_Contract_Source_System__c='PAF'),(select id from loan__Loan_Accounts__r) from Account where isPersonaccount=true and Is_Portal_User_Created__c=true and id=:lstAccount[0].id];
           
                   
         for(Account objAccount:listAccount)
          {
               if(PAFSetting.PAF_Dashboard_Checkbox__c==true)
               {
                    
                     for(clcommon__Party__c objParty :objAccount.clcommon__Parties__r )  // iterate over parties and hold PAF contract in a set.
                     {
                        if((objParty.pafss_Is_Individual_Loan__c==true && objParty.pafss_Contract_Type__c=='Consumer Loan') || (objParty.pafss_Contract_Type__c!='Consumer Loan')) 
                        {
                           contractPAF.add(objParty.collect__CL_Contract__c);
                        }
                     }
               }      
                     
                     for(loan__Loan_Account__c objLoanAccount : objAccount.loan__Loan_Accounts__r)  // iterate over Pl contract and hold the respective account id.
                     {
                          contractPLId = objAccount.id;
                     }
           }
                       
            if(contractPAF.size()>0 && contractPAF.size()!=null)   // iterate over PAF contract
            {
                       
                        collect.API api = collect.APIFactory.getAPI();     // use Api to get the values of PAF contract.
                        Map<Id,SObject> mapObjectData = new Map<Id,SObject>();
                        mapObjectData = api.getContracts(contractPAF);
                        for(Id contractId : mapObjectData.keySet())
                        {
                                collect__Loan_Account__c objclcontract = (collect__Loan_Account__c) mapObjectData.get(contractId);
                                welcomePageWrapper objwelcomePageWrapper = new welcomePageWrapper();  // initialize wrapper class and assigned the values of PAF contract.
                                objwelcomePageWrapper.loanId = objclcontract.id;
                                objwelcomePageWrapper.lonaName = objclcontract.pafss_Loan_Name_Formula__c ;   
                                objwelcomePageWrapper.loanNumber = objclcontract.name;
                                if(objclcontract.ScCollection_Settled_Date__c!=null)
                                objwelcomePageWrapper.settleDate = objclcontract.ScCollection_Settled_Date__c;
                                if(objclcontract.ScCollection_All_Cash_Received__c!=null)
                                objwelcomePageWrapper.principlePaid =  ((objclcontract.ScCollection_All_Cash_Received__c).setscale(2)).format();
                                if(objclcontract.ScCollection_Current_Principal__c!=null)
                                objwelcomePageWrapper.principleRemaining = ((objclcontract.ScCollection_Current_Principal__c).setscale(2)).format();
                                if(objclcontract.ScCollection_Next_Installment_Date__c!=null)
                                objwelcomePageWrapper.apsDate = objclcontract.ScCollection_Next_Installment_Date__c;
                                 if(objclcontract.ScCollection_Minimum_Monthly_Installment__c!=null)
                                objwelcomePageWrapper.apsAmount = objclcontract.ScCollection_Minimum_Monthly_Installment__c;
                                objwelcomePageWrapper.progressBarWidth ='0';
                                if(objclcontract.ScCollection_All_Cash_Received__c!=null && objclcontract.ScCollection_Current_Principal__c!=null && (objclcontract.ScCollection_All_Cash_Received__c+objclcontract.ScCollection_Current_Principal__c)>0)
                                  {
                                     objwelcomePageWrapper.progressBarWidth=String.valueof((objclcontract.ScCollection_All_Cash_Received__c/(objclcontract.ScCollection_All_Cash_Received__c+objclcontract.ScCollection_Current_Principal__c))*100);
                                  }
                                if(objclcontract.collect__Loan_Status__c =='Early payout' || objclcontract.collect__Loan_Status__c == 'Payout' || objclcontract.collect__Loan_Status__c == 'Early payout – Sale of Asset')
                                  { 
                                     objwelcomePageWrapper.closedLoan= true;
                                  }
                                else
                                 {
                                     objwelcomePageWrapper.closedLoan= false;
                                 } 
                                lstwelcomePageWrapper.add(objwelcomePageWrapper);  
                          
                        }
            }
          
                
        }
     // End here      
        Map<String,String> ChildObjectMap = new Map<String,String>();
        String Child = 'loan__Transaction_Amount__c,loan__Debit_Date__c,loan__Active__c,loan__Type__c,loan__CL_Contract__c ';
        ChildObjectMap.put('loan__Automated_Payment_Setup__r',child);
        
        If (string.isNotBlank(contractPLId))
        {
            system.debug('loanTestis'+contractPLId);
            system.debug('loanTestiss'+AccountId);
            lstLoanAccount  = RetrieveLoanAccounts.getLoanContracts(contractPLId,null,null,null,ChildObjectMap);
        }
         system.debug('lstLoanAccount' +lstLoanAccount);
        
        if(lstLoanAccount.size() > 0)
        {
            for (loan__Loan_Account__c objLoanAccount : lstLoanAccount)
            {
                welcomePageWrapper objwelcomePageWrapper = new welcomePageWrapper();
                objwelcomePageWrapper.objLoanAccount = objLoanAccount;
                objwelcomePageWrapper.lonaName = objLoanAccount.Loan_Name__c;   
                objwelcomePageWrapper.loanNumber = objLoanAccount.Name ;
                objwelcomePageWrapper.principlePaid =  ((objLoanAccount.loan__Principal_Paid__c).setscale(2)).format();
                objwelcomePageWrapper.principleRemaining = ((objLoanAccount.loan__Principal_Remaining__c).setscale(2)).format();
                objwelcomePageWrapper.loanId = objLoanAccount.id;
                objwelcomePageWrapper.progressBarWidth ='0';
                DateTime creationDate = objLoanAccount.createdDate;
                Date contractDate = date.newinstance(creationDate.year(), creationDate.month(), creationDate.day());
                objwelcomePageWrapper.settleDate = contractDate;

             if(objLoanAccount.loan__Principal_Paid__c!=null && objLoanAccount.loan__Principal_Remaining__c!=null && (objLoanAccount.loan__Principal_Paid__c+objLoanAccount.loan__Principal_Remaining__c)>0)
              {
                objwelcomePageWrapper.progressBarWidth=String.valueof((objLoanAccount.loan__Principal_Paid__c/(objLoanAccount.loan__Principal_Paid__c+objLoanAccount.loan__Principal_Remaining__c))*100);
              } 
                        
                Date MinimumDate;
                if(contractStatusSet.contains(objLoanAccount.loan__Loan_Status__c))
                { 
                   objwelcomePageWrapper.closedLoan= true;
                }
                else
                {
                    objwelcomePageWrapper.closedLoan= false;
                }
                for(loan__Automated_Payment_Setup__c objAutomatedPaymentSetup : objLoanAccount.loan__Automated_Payment_Setup__r)
                {
                    If(objAutomatedPaymentSetup.loan__Active__c == true && objAutomatedPaymentSetup.loan__Type__c == 'RECURRING')
                    {
                        MinimumDate = objAutomatedPaymentSetup.loan__Debit_Date__c;
                        objwelcomePageWrapper.apsDate = objAutomatedPaymentSetup.loan__Debit_Date__c;
                        objwelcomePageWrapper.apsAmount = objAutomatedPaymentSetup.loan__Transaction_Amount__c;
                    }
                }
                            
                for(loan__Automated_Payment_Setup__c objAutomatedPaymentSetup : objLoanAccount.loan__Automated_Payment_Setup__r)
                {
                    if(objAutomatedPaymentSetup.loan__Active__c == true && objAutomatedPaymentSetup.loan__Type__c == 'RECURRING' && MinimumDate > objAutomatedPaymentSetup.loan__Debit_Date__c)
                    {
                        MinimumDate = objAutomatedPaymentSetup.loan__Debit_Date__c;
                        objwelcomePageWrapper.apsDate = objAutomatedPaymentSetup.loan__Debit_Date__c;
                        objwelcomePageWrapper.apsAmount = objAutomatedPaymentSetup.loan__Transaction_Amount__c;
                    }
                }            
                lstwelcomePageWrapper.add(objwelcomePageWrapper);
            }
        }
        
        // added by Rishabh(for PAF)
        
              if(lstwelcomePageWrapper.size()>0)  // iterate over wrapper list to create a map
                                                 // to sort this list on the basis of settle date.
                 { 
                         Map<date,list<welcomePageWrapper>> cotractMap = new Map<date,list<welcomePageWrapper>>();
                         List<date>sortList = new List<date>() ;
                        for(welcomePageWrapper objContract:lstwelcomePageWrapper)
                        {
                             if(!cotractMap.containskey(objContract.settleDate))
                               {
                                  cotractMap.put(objContract.settleDate,new List<welcomePageWrapper>());
                               }
                                  cotractMap.get(objContract.settleDate).add(objContract);
                                  
                        }
                         if(cotractMap.keySet().size()>0)                       // iterate over map
                              {
                                   sortList.addAll(cotractMap.keySet());        // create a list of all settle date
                                   sortList.sort();                             // sort list in ascending order.
                                   lstwelcomePageWrapper.clear();
                              }
                       if(sortList.size()>0)                                    // iterate over the ascending order list
                       {   
                                   List<date>finalList= new List<date>() ;
                                  for(Integer i = sortList.size()-1; i>=0;i--)
                                    {
                                        finalList.add(sortList.get(i));            // sort list in descending over.
                                    }
                                  for(date dateValue : finalList)                 // iterate over the descending order list
                                  {
                                     for(welcomePageWrapper contractObj:cotractMap.get(dateValue))
                                     {
                                        lstwelcomePageWrapper.add(contractObj);   // add the of wrappper object in wrapper list.
                                     } 
                                  }
                       }
                 }  
              // end here 
    }
          
    
    public void loadMarketingAdInformation()
    {
        lstSection = [select Id, pepType__c, Sub_Type__c,Marketing_Link_1__c,Marketing_Link_2__c, 
                        (Select id, Name,ContentType FROM Attachments) 
                            from pepCmsSection__c where  pepPage__r.pepPageName__c =: 'Welcome' 
                                and pepType__c =: 'Marketing Ad' 
                                    order by pepSequence__c asc];      
    }
    
    public pagereference ViewMyLoan()
    {
        PageLoanId = System.currentPageReference().getParameters().get('LoanAccountId');
        system.debug('PageLoanId ' +PageLoanId );
        
        if(PageLoanId  != null && PageLoanId != '')
        {
                    objAccount = [Select id from Account where id=: AccountId];
                    objAccount.Loan_Account_Id__c = PageLoanID;        
                    update objAccount;
                    
                      String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(PageLoanId);
                     if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
                     {
    
                        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                     }
                   else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c')
                   {
                        string redircetPageName= pages_config__c.getinstance('pafviewmyassetloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                   }  
       } 
       return null;
        
    }
    
    public pageReference updateAccount()
    {
        if(string.isNotBlank(AccountId) && string.isNotBlank(idLoanAccount))
        {
            Account objAccount = new Account(id =AccountId);
            objAccount.Loan_Account_Id__c = idLoanAccount;
            update  objAccount;
            String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(idLoanAccount);
                     if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
                     {
    
                        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                     }
                   else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c')
                   {
                        string redircetPageName= pages_config__c.getinstance('pafviewmyassetloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                   }  
         }   
         return null; 
    }
    
    private Integer pageStepNumber(String pageName)
    {
        system.debug('pageIS'+pageName);
      //  FriendlyUrlRedirection__c friendlyURL = FriendlyUrlRedirection__c.getValues(pageName);
     //   pageName = friendlyURL.OriginalPageName__c;
        Integer intStep=0;
        if(pageName =='pepchangeProfile')
        {
            intStep = -3;
        }
        
        if(pageName =='pepWelcomePage')
        {
            intStep = -1;
        }
        
        if(pageName ==' pepReferAFriend')
        {
            intStep = -2;
        }
        
        if(pageName =='pepContactCentre')
        {
            intStep = -4;
        }
        
        if(pageName=='pepPaymentDetails')
        {
            intStep=1;
        }        
        
        else if(pageName =='pepTransactionHistory')
        {
            intStep =2;
        }
        
        else if(pageName =='pepmakeoneoffpayments')
        {
            intStep =3;
        }
        
        else if(pageName =='pepAdjustRepayments')
        {
            intStep =4;
        }
        
        else if(pageName =='pepChangePaymentsFrequency')
        {
            intStep =5;
        }
        
        else if(pageName =='pepPaymentHolidayDashBoard')
        {
            intStep =6;
        }
        
        else if(pageName =='peppayoutloanpage')
        {
            intStep =7;
        }
        return intStep;
    }
    
    public pageReference redirectToPage()
    {
       String pageName = Apexpages.currentPage().getParameters().get('pageNameValue');
       String redircetPageName= pages_config__c.getinstance(pageName).Page_Label__c;  
       Pagereference ref = new Pagereference('/'+redircetPageName); 
       Return ref.setRedirect(true);
    }
}
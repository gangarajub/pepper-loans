public class pepContactCentreController {

public String strPhone { get; set; }
public String strEmail { get; set; }
public Boolean successMsg{get;set;}
public String selectedLoanAccount { get; set; }
public String selectedBestTime { get; set; }
public String selectedEnquiryIssue { get; set; }
public string AccountId{get;set;}
public Integer Step{get;set;}
public List<pepUtilityClass.contractWrapper> sideBarList{get;set;}
public String idLoanAccount{get;set;}
public list<pepCmsSection__c>lstSection;
public string strsectionstory{get;set;}
public string loanAccountId{get;set;}
public List<pepCmsQuestion__c> lstQuestion{get;set;} 
public List<wrappperQuestion> lstWrapperQuestion{get;set;}
//public List<loan__Loan_Account__c> loanContractList;
public list<Account> lstAccount{get;set;}
public Case objCase{get;set;}
public string strFirstName{get;set;}
public string strLastName{get;set;} 
public string strDescription{get;set;} 
public list<selectOption> lstOptions {get; set;}
public list<selectOption> lstEnquiryOptions {get; set;}
public list<selectOption> lstBestTimeOptions {get; set;}
public String StrPreferredContact{get;set;}
public boolean boolBestTime{get;set;}
public String Page_Name{get;set;}
public String Page_Label{get;set;}
//public list<pepUtilityClass.sideBarWrapper> sideBarList{get;set;}
public List<pepCmsSection__c> lstLeftSideBarSections{get;set;}
Public Map<String,String> retUrlMap{get;set;}
Public String jsonretUrlMap{get{return JSON.serialize(retUrlMap);}set;}

public pepContactCentreController()
{
     retUrlMap=new Map<String,String>();
     retUrlMap.put('pepwelcomepage',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepwelcomepage').Page_Label__c);
     retUrlMap.put('pepreferafriend',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepreferafriend').Page_Label__c);
     retUrlMap.put('pepcontactcentre',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepcontactcentre').Page_Label__c);
     retUrlMap.put('pepchangeprofile',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepchangeprofile').Page_Label__c);
     page_Name = 'pepContactCentre';
     Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
     boolBestTime = true;
     selectedLoanAccount = '';
     lstQuestion = new List<pepCmsQuestion__c>();
     lstWrapperQuestion = new List<wrappperQuestion>();
     lstSection = new list<pepCmsSection__c> ();
     lstOptions = new list<selectOption>();
    // sideBarList = new list<pepUtilityClass.sideBarWrapper>();
     lstEnquiryOptions = new list<selectOption>();
     lstBestTimeOptions = new list<selectOption>();
     successMsg = false;
     strSectionStory = '';
     objCase = new Case ();
     lstAccount = new list<Account>();
     AccountId = pepUtilityClass.getAccountId();    
     system.debug('accountid' +AccountId);
     sideBarList = new List<pepUtilityClass.contractWrapper>();

     Map<String,String> ChildObjectMap = new Map<String,String>();
     String Child = 'loan__Transaction_Amount__c,loan__Debit_Date__c,loan__Active__c,loan__Type__c ';
     ChildObjectMap.put('loan__Automated_Payment_Setup__r',child);
     
     If (AccountId != null)
     {
         lstAccount = [Select id, FirstName, lastname from account where id=: AccountId];
         strFirstName = lstAccount[0].FirstName;
         strLastName = lstAccount[0].LastName;
         
         system.debug('lstAccount '+lstAccount );
         
         pepUtilityClass.contractWrapper objWrapper = new pepUtilityClass.contractWrapper(); // intilalize the contractwapper class object of  utility class
         sideBarList = objWrapper.getContract(AccountId);   // after passing accountId add all contract(both PAF and PL) in sidebar list to show in sidebar menu.
     } 
    // system.debug('lstLoanAccount' +lstLoanAccount);
     
     
     if(string.isNotBlank(AccountId))
     {
        loanAccountId = pepUtilityClass.getLoanAccountId(AccountId);
     } 
    
     system.debug('loanAccountId Swati' +loanAccountId );
     
    /* if(string.isNotBlank(loanAccountId))
     {
        loanContractList = pepUtilityClass.getLoanContract(loanAccountId);                
     } */
    
     loadCMSContent();
     
     if(selectedEnquiryIssue == '' || selectedEnquiryIssue == null)
     {
         RetrieveLoanAccounts();
     }
     removeEnquiryOptions();
     string pageName=ApexPages.currentPage().getUrl();
     pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
     Step=pageStepNumber(pageName);
}
    
    public void loadCMSContent()
    {
       lstSection = [Select id,pepSectionBodyRich__c,pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Contact Centre' and pepSectionUniqueName__c = 'Contact Centre Section 6'limit 1];
       
       lstLeftSideBarSections =[select id,pepHeader__c,pepCss_Class__c,pepRedirect_to_Page__c from pepCmsSection__c where Page_Name__c='DashboardSideBarTemplate' order by pepSequence__c asc];

     /*  if(lstSection != null && lstSection.size() > 0)
       {
           strSectionStory = lstSection[0].pepSectionBodyRich__c;
           
           if(loanContractList != null && loanContractList[0].Name != null)
           {
               strSectionStory = strSectionStory.replace('LoanNumber',loanContractList[0].Name);
           }
       } */
       
       system.debug('strSectionStory Swati' + strSectionStory ); 
                       lstEnquiryOptions.add(new selectOption('Fee Inquiry','Fee Inquiry'));
                       lstEnquiryOptions.add(new selectOption('Documents Request','Documents Request'));
                       lstEnquiryOptions.add(new selectOption('Lump Sum Payment','Lump Sum Payment'));
                       lstEnquiryOptions.add(new selectOption('Transactions','Transactions'));
                       lstBestTimeOptions.add(new selectOption('Morning','Morning'));
                       lstBestTimeOptions.add(new selectOption('Afternoon','Afternoon'));
                       lstBestTimeOptions.add(new selectOption('Evening','Evening'));
                       lstEnquiryOptions.add(new selectOption('Change Payment Details','Change Payment Details'));
                       lstEnquiryOptions.add(new selectOption('Payout Figure','Payout Figure'));
                       lstEnquiryOptions.add(new selectOption('Statement Request','Statement Request'));
                       lstEnquiryOptions.add(new selectOption('Other','Other'));
       
         
      for(pepCmsQuestion__c objQuestion:[select id,pepLabelPriorQuestion__c,pepType__c,pepIsRequired__c,pepKeyPressNumbersOnly__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c,
      (select id,pepActualValue__c,pepCmsQuestion__c,pepDisplayText__c,pepSequence__c from pepCMSAnswer__r) from pepCmsQuestion__c  where pepPage__r.pepPageName__c = 'Contact Centre' order by pepSequence__c])
      {  
          lstWrapperQuestion.add(new wrappperQuestion(objQuestion));
      }
      
      
    }
  
     public class wrappperQuestion
     {
           public pepCmsQuestion__c objCmsQuestion {get; set;} //main question             
     
            public wrappperQuestion(pepCmsQuestion__c objQuestion)
            {
               objCmsQuestion = objQuestion;                                                          
            }
     }
     
     public void RetrieveLoanAccounts()
     {
         
         
         if(sideBarList != null && sideBarList.size() > 0)
         {
             if(selectedEnquiryIssue != 'Other')
             {
                 if(selectedEnquiryIssue != '' && selectedEnquiryIssue != null)
                 {
                     lstOptions.clear();
                 }
             
             // added by Rishabh (for PAF)
                 for(pepUtilityClass.contractWrapper  objLoan :sideBarList)  // iterate over sidebar list created from utility class.
                 {
                           //fetch using the common method whether it is PAF contract or PL contract
                         String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(objLoan.loanid);
                         
                         if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c') // For PL Contract
                          {
                               if((objLoan.loanStatus == 'Active - Good Standing') || (objLoan.loanStatus== 'Active - Bad Standing'))
                               {
                                  if(string.isBlank(selectedLoanAccount))
                                     selectedLoanAccount = objLoan.loanId;
                                     // add Pl contarct in list
                                  lstOptions.add(new selectOption(objLoan.loanId,objLoan.loanName+ ' ' + '(' + objLoan.loanNumber+ ')'));
                               }
                         }
                        else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c') // For PAF Contract
                         {
                             if(objLoan.loanStatus != 'Early payout' && objLoan.loanStatus != 'Payout' && objLoan.loanStatus != 'Early payout – Sale of Asset')
                               {
                                  if(string.isBlank(selectedLoanAccount))
                                     selectedLoanAccount = objLoan.loanId;
                                      // add PAF contarct in list
                                  lstOptions.add(new selectOption(objLoan.loanId,objLoan.loanName+ ' ' + '(' + objLoan.loanNumber+ ')'));
                               }
                         } 
                }
              // end here  
                
                 
             }
         }
     }
     
// This method is used to update the contract id in account object after clicked from sidebar menu list.

    public pageReference updateAccount()
    {
       // String idLoanAccount = Apexpages.currentPage().getParameters().get('loanContractid');
        System.debug('idLoanAccount ****** '+idLoanAccount);
        if(string.isNotBlank(AccountId) && string.isNotBlank(idLoanAccount))
        {
            Account objAccount = new Account(id =AccountId);
            objAccount.Loan_Account_Id__c = idLoanAccount;
            update  objAccount;
            // Added by Rishabh (for PAF)
            //fetch using the common method whether it is PAF contract or PL contract
            String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(idLoanAccount);  
                     if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
                     {
                         // redirect to PL view my loan page if user clicked on PL contract 
                        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                     }
                   else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c')
                   {
                         // redirect to PAF view my loan page if user clicked on PAF contract 
                        string redircetPageName= pages_config__c.getinstance('pafviewmyassetloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                   }  
           // end here        
         }  
         return null; 

    }
    
    private Integer pageStepNumber(String pageName)
    {
        Integer intStep=0;
        if(pageName =='pepchangeProfile' )
        {
            
            intStep = -3;
        }
        
        if(pageName =='pepWelcomePage')
        {
            intStep = -1;
        }
        
        if(pageName =='pepReferAFriend')
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
    
    public pagereference Cancel()
    {
        string redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;
        pageReference objPageRef = new pageReference('/'+redircetPageName);
        objPageRef.setredirect(true);
        return objPageRef ;
        
    }
    
    

    public pagereference Saveenquiry()
    {
        objCase.PepPreferred_Contact__c =  StrPreferredContact;
        if(selectedEnquiryIssue != null && strDescription != null)
        {
            if(selectedBestTime != null && StrPreferredContact=='Telephone')
            {
                objCase.Best_Time_to_call__c = selectedBestTime ;
            }
            
            if(selectedLoanAccount != null)
            {
                String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(selectedLoanAccount);
                if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
                 {
                   objCase.CL_Contract__c = selectedLoanAccount ;
                 }
                 else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c')
                  {
                      objCase.pafss_Contract__c = selectedLoanAccount ;
                  }
            }
            
            objCase.AccountId = AccountId;
            objCase.Reason = selectedEnquiryIssue ;
            objCase.Description = strDescription;
            objCase.RecordTypeId = [Select Id From RecordType where sobjecttype = 'Case' and name = 'Customer Service' limit 1].id;
            objCase.pepCreatedfromportal__c = true;
            
            if(objCase != null)
            {
                insert objCase;
            }
            
            if(objCase.id != null)
            {
                 successMsg = true;
            }
            
            
        }
        return null;
    }
    
 // added by Rishabh (for PAF)
  
 
 //   This method is used to hide and show some values of enquiry optionon the 
 //   basis of contract(whether it is PAF contract or PL contract)
    public void removeEnquiryOptions()
    {
        system.debug('loanAccount'+selectedLoanAccount);
       if(selectedLoanAccount != null && selectedLoanAccount !='')
            {
                lstEnquiryOptions = new list<selectOption>();
                
                //fetch using the common method whether it is PAF contract or PL contract
                String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(selectedLoanAccount); 
                
                 if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c') // add all enquiry option for PL contract.
                 {
                       system.debug('strObjectName'+strObjectName);
                       
                       lstEnquiryOptions.add(new selectOption('Fee Inquiry','Fee Inquiry'));
                       lstEnquiryOptions.add(new selectOption('Documents Request','Documents Request'));
                       lstEnquiryOptions.add(new selectOption('Lump Sum Payment','Lump Sum Payment'));
                       lstEnquiryOptions.add(new selectOption('Transactions','Transactions'));
                       lstEnquiryOptions.add(new selectOption('Change Payment Details','Change Payment Details'));
                       lstEnquiryOptions.add(new selectOption('Payout Figure','Payout Figure'));
                       lstEnquiryOptions.add(new selectOption('Statement Request','Statement Request'));
                       lstEnquiryOptions.add(new selectOption('Other','Other'));
                 }
                else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c')  // remove some enquiry option for PAF contract 
                                                                                                        // which is already exist in PAF view my loan Page.
                  { 
                       system.debug('strObjectName'+strObjectName);
                       lstEnquiryOptions.add(new selectOption('Fee Inquiry','Fee Inquiry'));
                       lstEnquiryOptions.add(new selectOption('Documents Request','Documents Request'));
                       lstEnquiryOptions.add(new selectOption('Lump Sum Payment','Lump Sum Payment'));
                       lstEnquiryOptions.add(new selectOption('Transactions','Transactions'));
                       
                       lstEnquiryOptions.add(new selectOption('Other','Other'));
                  }
            }
         else
            
            system.debug('lstEnquiryOptionsIs'+lstEnquiryOptions);
    }
    
 //  end here
  
    public pageReference redirectToPage()
    {
       String pageName = Apexpages.currentPage().getParameters().get('pageNameValue');
       String redircetPageName= pages_config__c.getinstance(pageName).Page_Label__c;  
       Pagereference ref = new Pagereference('/'+redircetPageName); 
       Return ref.setRedirect(true);
    }
}
// ---------------------------------------------------------------------------------------------------------
// This class is used to show the basic details of loan and to redirect on different loan pages. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      5th May 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
public class pepViewMyLoanController
{ 
  
  public Integer Step{get;set;}
  public String strName{get;set;}
  @testvisible String redirectPageName;
  public Transient String nextRepaymentAmount{get;set;}
  public Transient String nextRepaymentDate{get;set;}
  public Transient String amountPaid{get;set;}
  public Transient String amountRemaining{get;set;}
  public Transient String progressBarWidth{get;set;}
  public String headerInput{get;set;}
  public Transient string headerLoanNo{get;set;}
  public boolean hideHeader{get;set;}
  public boolean successMsg{get;set;}
  public boolean dontShowAlert{get;set;}
  public loan__Loan_Account__c objLoanAccount;
  public loan__Automated_Payment_Setup__c objAutomatedPayment;
  public List<loan__Loan_Account__c> lstloancontract;
  @testvisible List<loan__Loan_Account__c> loanContractList;
  public List<pepCmsQuestion__c> lstQuestions{get;set;}
  public String idLoanAccount{get;set;}
  @testvisible List<loan__Automated_Payment_Setup__c> APSList;
  @testvisible List<date> apsDateList;
  @testvisible Map<date,loan__Automated_Payment_Setup__c> apsMap;
  @testvisible String idAccount;
  public String loanAccountId{get;set;}
  public boolean boolopenpopup{get;set;}
  public boolean closedLoan{get;set;} 
  @testvisible Set<String> contractStatusSet ; 
  public String Page_Name{get;set;}
  public String Page_Label{get;set;}
  public list<pepUtilityClass.contractWrapper> sideBarList{get;set;}
  public List<pepCmsSection__c> lstLeftSideBarSections{get;set;}
  Public Map<String,String> retUrlMap{get;set;}
  Public String jsonretUrlMap{get{return JSON.serialize(retUrlMap);}set;}
  
 
  
  
  // This method is used to fetch contract and their child object automated payment setup and  assign their values to dfferent variables to create dynamic header.
  
  public pepViewMyLoanController()
  {
        retUrlMap=new Map<String,String>();                    // create map to return the friendly name of page for redirection.
        for(pages_config__c objPages: pages_config__c.getall().values())     // fetch page name from custom setting.
        {
                retUrlMap.put(objPages.name,Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance(objPages.name).Page_Label__c);
              //  retUrlMap.put('pepmakeoneoffpayments',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepmakeoneoffpayments').Page_Label__c);
        }
     page_Name = 'pepViewMyLoanPage';
     Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
     boolopenpopup = false;
     closedLoan = false;
     contractStatusSet = New Set<String> ();
     contractStatusSet.addall(Label.CLContractStatus.split(','));
     string pageName=ApexPages.currentPage().getUrl();
     pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
     Step=pageStepNumber(pageName);
     redirectPageName='';
     objLoanAccount = new loan__Loan_Account__c();
     objAutomatedPayment = new loan__Automated_Payment_Setup__c();
     loanContractList = new List<loan__Loan_Account__c>();
     APSList = new List<loan__Automated_Payment_Setup__c>();
     apsDateList = new list<date>();
     apsMap = new Map<date,loan__Automated_Payment_Setup__c>();
     sideBarList = new list<pepUtilityClass.contractWrapper>();
     lstQuestions = new List<pepCmsQuestion__c>();
     successMsg = false;
     dontShowAlert = false;
     progressBarWidth = '0';
     idAccount = pepUtilityClass.getAccountId();
   
     if(string.isNotBlank(idAccount))
     {
           pepUtilityClass.contractWrapper objWrapper = new pepUtilityClass.contractWrapper();   // intilalize the contractwapper class object of  utility class
           sideBarList = objWrapper.getContract(idAccount);                                     // after passing accountId add all contract(both PAF and PL) in sidebar list to show in sidebar menu.
           loanAccountId = pepUtilityClass.getLoanAccountId(idAccount);
           lstloancontract = pepUtilityClass.getAllLoanContract(idAccount);
     }  
     if(string.isNotBlank(loanAccountId))
        loanContractList = pepUtilityClass.getLoanContract(loanAccountId);  // fetch PL Contract 
        system.debug('listValueIs'+loanContractList);
        loadCmsData();
     
      
     
   if(loanContractList.size()>0)     // iterate over PL contract to get the values
     {
          for (loan__Loan_Account__c instanceLoanAccount:loanContractList)
            {
               
                    objLoanAccount = instanceLoanAccount;
                    system.debug('loanAccountIs'+objLoanAccount);
                    for(loan__Automated_Payment_Setup__c automated : instanceLoanAccount.loan__Automated_Payment_Setup__r) 
                     {
                         if(automated.loan__Type__c =='RECURRING' && automated.loan__Active__c==True)
                            apsMap.put(automated.loan__Debit_Date__c,automated); 
                     }
                    
            }
            
                if(apsMap.keySet().size()>0)
                  {
                       apsDateList.addAll(apsMap.keySet());
                       apsDateList.sort();
                  }
                   
                 if(apsDateList.size()>0)
                  {
                      objAutomatedPayment  =  apsMap.get(apsDateList.get(0));
                  }
         // asigned values of pl conract to variables for showing in page.     
            if(objAutomatedPayment.loan__Transaction_Amount__c!=null)
               nextRepaymentAmount = ((objAutomatedPayment.loan__Transaction_Amount__c).setScale(2)).format();
            if(objAutomatedPayment.loan__Debit_Date__c!=null)
               nextRepaymentDate = (objAutomatedPayment.loan__Debit_Date__c).format();
            if(objLoanAccount.loan__Principal_Paid__c!=null)
               amountPaid = ((objLoanAccount.loan__Principal_Paid__c).setScale(2)).format();
            if(objLoanAccount.loan__Principal_Remaining__c!=null)
               amountRemaining = (objLoanAccount.loan__Principal_Remaining__c).format();
            if(string.isNotBlank(objLoanAccount.Loan_Name__c))
               headerInput = objLoanAccount.Loan_Name__c;
               headerLoanNo = objLoanAccount.Name;
            if(objLoanAccount.loan__Principal_Paid__c!=null && objLoanAccount.loan__Principal_Remaining__c!=null && (objLoanAccount.loan__Principal_Paid__c+objLoanAccount.loan__Principal_Remaining__c)>0)
            {
               progressBarWidth=String.valueof((objLoanAccount.loan__Principal_Paid__c/(objLoanAccount.loan__Principal_Paid__c+objLoanAccount.loan__Principal_Remaining__c))*100);
              // progressBarWidth =String.valueof(70);
            }    
             if(contractStatusSet.contains(objLoanAccount.loan__Loan_Status__c)) 
                closedLoan = true;      
     }
  } 

  
// This method is used to load CMS data.

public void loadCmsData()
{
    lstQuestions = [select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c
                    from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='View My Loan Page' and pepSection__r.pepSectionUniqueName__c='SectionSeventeen(VMLP)' and pepType__c='Button' order by pepSequence__c];
    
    lstLeftSideBarSections =[select id,pepHeader__c,pepCss_Class__c,pepRedirect_to_Page__c from pepCmsSection__c where Page_Name__c='DashboardSideBarTemplate' order by pepSequence__c asc];
       
} 
  
// This method is used to update the loan name of contract.
  
  public void changeloanName()
  {
     successMsg = false;
     dontShowAlert = false;
    if(string.isNotBlank(headerInput))       //check the null value for loan name.
     {
     
             if(string.isNotBlank(loanAccountId))
             {
                      
                       if(loanContractList !=null && loanContractList.size()>0)
                       {
                                   if(loanContractList[0].Loan_Name__c == headerInput)          // check entered loan name is equal to already exist loan name.
                                   {
                                      dontShowAlert = true;                                    // no change required.  
                                   }
                                 
                                             
                                  else
                                  {
                                        Map<String, String> mapnew = new Map<String, String>();
                                        mapnew.put('Loan_Name__c',headerInput);
                                        LoanActions loanAc = new LoanActions();
                                        system.debug('comeIs');
                                        loan__Loan_Account__c loanAcc = loanAc.updateLoanAccount(loanAccountId,mapnew);  // use API to update loan name.
                                        system.debug('loanAccIs'+loanAcc); 
                                        
                                        if(loanAcc!=null && loanAcc.id != null)
                                              successMsg = true;
                                        else
                                        {
                                              successMsg = false;
                                             
                                        }         
                                       
                                  }
                       }     
           }
    }
    
     else{
                 successMsg = false; 
                 
         }
  }
  
// This method is used to update the contract id in account object after clicked from sidebar menu list. 

   public pageReference updateAccount()
    {
       // String idLoanAccount = Apexpages.currentPage().getParameters().get('loanContractid');
        System.debug('idLoanAccount ****** '+idLoanAccount);
        
        if(string.isNotBlank(idAccount) && string.isNotBlank(idLoanAccount))
        {
                Account objAccount = new Account(id=idAccount);
                objAccount.Loan_Account_Id__c = idLoanAccount;
                update  objAccount;                            // update account with selected contract.
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
        }   
           return null;       
    }
    
 // This method is used to highlight tab in which tab the user clicked. 
    
  private Integer pageStepNumber(String pageName)
    {
        Integer intStep=0;
        // compare api name of all pages
        if(pageName =='pepchangeProfile' )
        {
            hideHeader = true;
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
        
        else if(pageName =='pepDocumentInbox')
        {
            intStep =8;
            if(objLoanAccount.DocumentInbox__c==True)
                {
                        system.debug('Isssss');
                        Map<String, String> mapnew = new Map<String, String>();
                        mapnew.put('DocumentInbox__c','false');
                        LoanActions loanAc = new LoanActions();
                        loan__Loan_Account__c loanAcc = loanAc.updateLoanAccount(loanAccountId,mapnew);
                        if(loanAcc!=null && loanAcc.id!=null)
                           objLoanAccount.DocumentInbox__c=false;
                        system.debug('loanAccIs'+loanAcc);
                }
        }
        
    return intStep;
    }
    
    public void disablelinks()
    {
        if(loanContractList != null && loanContractList.size() > 0)
        {
            if(loanContractList[0].loan__Amount_to_Current__c == 0.0)
            {
                boolOpenPopup = true;
                system.debug('swati'+boolOpenPopup );
            }
            
        }
    }
    
  // This method is used to redirect in different pages after getting the page name clicked by user.
  
    public pageReference redirectToPage()
    {
       String pageName = Apexpages.currentPage().getParameters().get('pageNameValue');
       String redircetPageName= pages_config__c.getinstance(pageName).Page_Label__c;  
       Pagereference ref = new Pagereference('/'+redircetPageName); 
       Return ref.setRedirect(true);
    }
}
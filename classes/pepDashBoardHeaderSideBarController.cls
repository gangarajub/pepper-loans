public class pepDashBoardHeaderSideBarController
{
      public Integer Step{get;set;}
      public String strName{get;set;}
      public String nextRepaymentAmount{get;set;}
      public String nextRepaymentDate{get;set;}
      public String amountPaid{get;set;}
      public String amountRemaining{get;set;}
      public String progressBarWidth{get;set;}
      public String headerInput{get;set;}
      public string headerLoanNo{get;set;}
      public boolean hideHeader{get;set;}
      public boolean hideLoanServicesSideBar{get;set;}
      public boolean hideLoanDetailsSideBar{get;set;}
      public boolean successMsgHeader{get;set;}
      public boolean dontShowAlertHeader{get;set;}
      Public Map<String,String> retUrlMap{get;set;}
      Public String jsonretUrlMap{get{return JSON.serialize(retUrlMap);}set;}
      public loan__Loan_Account__c objLoanAccount;
      public loan__Automated_Payment_Setup__c objAutomatedPayment{get;set;}
      public List<loan__Loan_Account__c> loanContractList {get;set;}
      public List<loan__Loan_Account__c> lstloancontract{get;set;}
      public String loanAccountId{get;set;}
      String idAccount;
      public String idLoanAccount{get;set;}
      public List<pepCmsSection__c> lstLeftSideBarSections{get;set;}
      public List<pepCmsSection__c> lstLoanDetailsSideBarSections{get;set;}
      public List<pepCmsSection__c> lstLoanserviceSideBarSections{get;set;}
      public List<pepUtilityClass.contractWrapper> sideBarList{get;set;}
      List<loan__Automated_Payment_Setup__c> APSList;
      List<date> apsDateList;
      Map<date,loan__Automated_Payment_Setup__c> apsMap;
      public boolean closedLoan{get;set;} 
      Set<String> contractStatusSet ;
      public Integer intStep{get;set;}
      
     
    public pepDashBoardHeaderSideBarController()
    {
      //  assignedPageName='pepmakeoneoffpayments';
        retUrlMap=new Map<String,String>();
        for(pages_config__c objPages: pages_config__c.getall().values())
        {
                retUrlMap.put(objPages.name,Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance(objPages.name).Page_Label__c);
            //  retUrlMap.put('pepmakeoneoffpayments',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepmakeoneoffpayments').Page_Label__c);
        }
        hideLoanServicesSideBar = false;
        closedLoan = false;
       
        contractStatusSet = New Set<String> ();
        objLoanAccount = new loan__Loan_Account__c();
        APSList = new List<loan__Automated_Payment_Setup__c>();
        apsDateList = new list<date>();
        apsMap = new Map<date,loan__Automated_Payment_Setup__c>();
        sideBarList = new List<pepUtilityClass.contractWrapper>();
        successMsgHeader = false;
        dontShowAlertHeader = false;
        progressBarWidth = '0';
        intStep=0;
        String strObjectName;
        objAutomatedPayment = new loan__Automated_Payment_Setup__c();
        loanContractList = new List<loan__Loan_Account__c>();
        idAccount = pepUtilityClass.getAccountId(); // To get account id of currently logged in user.
        if(string.isNotBlank(idAccount))
          loanAccountId = pepUtilityClass.getLoanAccountId(idAccount); // To get the id of current contract.
        if(string.isNotBlank(loanAccountId))
        {
           strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(loanAccountId);
           if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
               loanContractList = pepUtilityClass.getLoanContract(loanAccountId); // To get data corresponding to current contract id.
        }   
        System.debug('listValueIs'+loanContractList);
        if(string.isNotBlank(idAccount) && string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
           lstloancontract = pepUtilityClass.getAllLoanContract(idAccount );  // To get all contract id corresponding to logged in account.
       loadLeftSideBarSection();
       contractStatusSet.addall(Label.CLContractStatus.split(','));
       pepUtilityClass.contractWrapper objWrapper = new pepUtilityClass.contractWrapper();  // intilalize the contractwapper class object of  utility class
       sideBarList = objWrapper.getContract(idAccount);    // after passing accountId add all contract(both PAF and PL) in sidebar list to show in sidebar menu.
     
       
     if(loanContractList.size()>0)
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
              
              
                if(objAutomatedPayment.loan__Transaction_Amount__c!=null)
                {
                    Decimal dollars;
                    Decimal cents;
                    dollars = objAutomatedPayment.loan__Transaction_Amount__c.intValue();
                    cents = objAutomatedPayment.loan__Transaction_Amount__c - objAutomatedPayment.loan__Transaction_Amount__c.intValue();
                    cents = cents.setScale(2);  
                    nextRepaymentAmount= dollars.format() + cents.toPlainString().substring(1);
                  // nextRepaymentAmount = ((objAutomatedPayment.loan__Transaction_Amount__c).setScale(2)).format();
                }
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
    
    
    
    public void loadLeftSideBarSection()
    {
        lstLeftSideBarSections =[select id,pepHeader__c,pepCss_Class__c,pepRedirect_to_Page__c from pepCmsSection__c where Page_Name__c='DashboardSideBarTemplate' order by pepSequence__c asc];
    }
    
    public pageReference loadSidebarData()
    {
         String pageName=ApexPages.currentPage().getUrl();
         pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
         pageName = pageName.toLowerCase();
         if(closedLoan == true && pageName!='peppaymentdetails' && pageName!='pepdocumentinbox' && pageName!='peptransactionhistory' &&  pageName!='pepchangeprofile')
         {
                   
                   String redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;  
                   Pagereference ref = new Pagereference('/'+redircetPageName); 
                   Return ref.setRedirect(true);
         
         }
         else
         {  
                Step=pageStepNumber(pageName);
         }
         return null;
    }
 // This method is used to update the contract id in account object after clicked from sidebar menu list.   
 
    public pageReference updateAccount()
    {
       // String idLoanAccount = Apexpages.currentPage().getParameters().get('loanContractid');
        System.debug('idLoanAccount ****** '+idLoanAccount);
       if(string.isNotBlank(idAccount) && string.isNotBlank(idLoanAccount))
        {
            Account objAccount = new Account(id =idAccount);
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
    
    public pepDashBoardHeaderSideBarController(String str)
    {
    
        strName = str;
        System.debug('strName************'+strName);
    
    }
    
    
    private Integer pageStepNumber(String pageName)
    {
        
      //  FriendlyUrlRedirection__c friendlyURL = FriendlyUrlRedirection__c.getValues(pageName);
     //   pageName = friendlyURL.OriginalPageName__c;      
         
        if(pageName =='pepchangeProfile' || pageName =='pepWelcomePage')
        {
            hideHeader = true;
            hideLoanServicesSideBar = true;
            hideLoanDetailsSideBar = true;
            intStep = -3;
        }
        
        if(pageName =='pepWelcomePage')
        {
            intStep = 1;
        }
        
        if(pageName =='pepReferAFriend')
        {
            intStep = 3;
        }
        if(pageName =='peppromisetopay')
        {
            hideLoanServicesSideBar = true;
        }
        
       
        
        if(pageName=='pepPendingMakeOneOffPayment')
        {
           String strpageName =  apexpages.currentpage().getparameters().get('pagename');
           if(strpageName == 'Pay Off Your Loan')
           {
                intStep =7;
           }
           
           if(strpageName == 'Make one-off payments')
           {
                intStep =3;
           }
        }
        
       
        
        else if(pageName=='pepPaymentDetails' || pageName=='pepPaymentSetting')
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
    
 // This method is used to update the loan name displayed in dashboard header.     
  
 public void changeloanName()
  {
     successMsgHeader= false;
     dontShowAlertHeader = false;
    if(string.isNotBlank(headerInput)) 
     {
     
             if(string.isNotBlank(loanAccountId))
             {
                      
                       if(loanContractList !=null && loanContractList.size()>0)
                       {
                                   if(loanContractList[0].Loan_Name__c == headerInput)
                                   {
                                      dontShowAlertHeader = true;
                                   }
                                 
                                             
                                  else
                                  {
                                        Map<String, String> mapnew = new Map<String, String>();
                                        mapnew.put('Loan_Name__c',headerInput);
                                        LoanActions loanAc = new LoanActions();
                                        system.debug('comeIs');
                                        loan__Loan_Account__c loanAcc = loanAc.updateLoanAccount(loanAccountId,mapnew);
                                        system.debug('loanAccIs'+loanAcc);
                                        
                                        if(loanAcc!=null && loanAcc.id != null)
                                              successMsgHeader = true;
                                        else
                                        {
                                              successMsgHeader = false;
                                        }         
                                       
                                  }
                       }     
           }
    }
    
     else{
                 successMsgHeader = false; 
                 
         }
  }
  
  public pageReference redirectToPage()
    {
       String pageName = Apexpages.currentPage().getParameters().get('pageNameValue');
       String redircetPageName= pages_config__c.getinstance(pageName).Page_Label__c;  
       Pagereference ref = new Pagereference('/'+redircetPageName); 
       Return ref.setRedirect(true);
    }
  
}
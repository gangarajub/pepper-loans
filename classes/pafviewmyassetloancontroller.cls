// ---------------------------------------------------------------------------------------------------------
// This class is used to show the basic details of PAF loan on portal.
// ---------------------------------------------------------------------------------------------------------
// Date : 04 Dec 2016                       Author : Pawan Mudgal               
// ---------------------------------------------------------------------------------------------------------
public class pafviewmyassetloancontroller
{ 
    public Integer Step{get;set;}
    public String strName{get;set;}
    @testvisible String redirectPageName;
    public Transient String nextRepaymentAmount{get;set;}
    public Transient String nextRepaymentDate{get;set;}
    public Transient String amountPaid{get;set;}
    public Transient String amountRemaining{get;set;}
    public Transient String progressBarWidth{get;set;}
    public Transient String startDate{get;set;}
    public Transient String endDate{get;set;}
    public Transient String lastPayment{get;set;}
    public Transient String assetDescription{get;set;}
    public Transient String currentBalance{get;set;}
    public Transient String balloanPayment{get;set;}
    public Transient String balloanPaymentAsOf{get;set;}
    public Transient String registeredInsurer{get;set;}
    public Transient String introducerDetails{get;set;}
    public Transient String loanNumber{get;set;}
    public Transient String loanName{get;set;}
    public Transient String loanStatus{get;set;}
    public  Integer minDay{get;set;}
    public  Integer maxDay{get;set;}
   // public Transient String assetDescription{get;set;}
   // public Transient String currentBalance{get;set;}
    public String headerInput{get;set;}
    public Transient string headerLoanNo{get;set;}
    public boolean hideHeader{get;set;}
    public boolean successMsg{get;set;}
    public boolean dontShowAlert{get;set;}
    public List<pepCmsQuestion__c> lstQuestions{get;set;}
    public String idLoanAccount{get;set;}
    @testvisible String idAccount;
    public String loanAccountId{get;set;}
    public boolean boolopenpopup{get;set;}
    public boolean closedLoan{get;set;} 
    @testvisible Set<String> contractStatusSet ; 
    public String Page_Name{get;set;}
    public String Page_Label{get;set;}
    public collect__Loan_Account__c objclcontract;
    public String caseDate{get;set;}
    Public String caseMonth{get;set;}
    public String caseNumber{get;set;}
    public String assignedPage{get;set;}
    public Boolean showEachPopup{get;set;}
    public Boolean showCommonPopup{get;set;}
    public Boolean errorPopup{get;set;}
    public Boolean alreadyProcess{get;set;}
    Map <String,String> contractMap;
    public list<pepUtilityClass.contractWrapper> sideBarList{get;set;}
    public List<pepCmsSection__c> lstLeftSideBarSections{get;set;}
    public Map<String,String> retUrlMap{get;set;}
    public String jsonretUrlMap{get{return JSON.serialize(retUrlMap);}set;}
    public Account objAccount;
    
    
    public pafviewmyassetloancontroller()
    {
        retUrlMap = new Map<String,String>();   // create map to return the friendly name of page for redirection.
        
        for(pages_config__c objPages : pages_config__c.getall().values())   // fetch page name from custom setting.
        {
            retUrlMap.put(objPages.name,Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance(objPages.name).Page_Label__c);
        }
        
        page_Name = 'pafviewmyassetloanpage';
        Page_Label = pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
        contractMap = New Map <String,String>();
        objAccount = new Account();
        boolopenpopup = false;
        closedLoan = false;
        contractStatusSet = New Set<String> ();
        contractStatusSet.addall(Label.CLContractStatus.split(','));
        string pageName=ApexPages.currentPage().getUrl();
        pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
       // Step=pageStepNumber(pageName);
        redirectPageName='';
        sideBarList = new list<pepUtilityClass.contractWrapper>();
        lstQuestions = new List<pepCmsQuestion__c>();
        successMsg = false;
        dontShowAlert = false;
        progressBarWidth = '0';
        idAccount = pepUtilityClass.getAccountId();   // fetch account id of currently logged in user.
        
       if(string.isNotBlank(idAccount))
        {
           objAccount = [select id,name,personEmail from account where id=:idAccount];
           pepUtilityClass.contractWrapper objWrapper = new pepUtilityClass.contractWrapper();
           sideBarList = objWrapper.getContract(idAccount);                                    // fetch contract from utility class to show all contract in sidebar.
           loanAccountId = pepUtilityClass.getLoanAccountId(idAccount);    // fetch contract id stored in account.
           List<Case> caseList = new List<Case>();
           caseList = [select id,accountid,subject,caseNumber,pafss_Contract__c from Case where accountid=:idAccount and pafss_Contract__c=:loanAccountId and status !='Closed'] ;
           for(case objCase:caseList)
           {
              contractMap.put(objCase.subject,objCase.caseNumber);    // crate a map of case subject and correponding case number.
           } 
            collect.API api = collect.APIFactory.getAPI();            // Use API to fetch the all details values of PAF contract.
            Map<Id,SObject> mapObjectData = new Map<Id,SObject>();
            Set<id> contratctIdSet = New Set<id> ();
            contratctIdSet.add(loanAccountId);
            mapObjectData = api.getContracts(contratctIdSet);
                        for(Id contractId : mapObjectData.keySet())     // Using for loop assgining the contract values to variables.
                        {
                                         
                                         objclcontract = (collect__Loan_Account__c) mapObjectData.get(contractId);
                                         headerInput = objclcontract.pafss_Loan_Name_Formula__c; 
                                         if(objclcontract.ScCollection_Minimum_Monthly_Installment__c !=null)
                                         nextRepaymentAmount = ((objclcontract.ScCollection_Minimum_Monthly_Installment__c).setScale(2)).format();
                                         if(objclcontract.ScCollection_Next_Installment_Date__c !=null)
                                         nextRepaymentDate = (objclcontract.ScCollection_Next_Installment_Date__c).format();
                                          if(objclcontract.ScCollection_All_Cash_Received__c !=null)
                                         amountPaid = ((objclcontract.ScCollection_All_Cash_Received__c).setscale(2)).format();
                                          if(objclcontract.ScCollection_Current_Principal__c !=null)
                                         amountRemaining = ((objclcontract.ScCollection_Current_Principal__c).setscale(2)).format();
                                          if(objclcontract.ScCollection_Settled_Date__c !=null)
                                         startDate = (objclcontract.ScCollection_Settled_Date__c).format();
                                          if(objclcontract.ScCollection_Contract_End_Date__c !=null)
                                         endDate = (objclcontract.ScCollection_Contract_End_Date__c).format();
                                          if(objclcontract.collect__Last_Payment_Amount__c !=null)
                                         lastPayment = ((objclcontract.collect__Last_Payment_Amount__c).setscale(2)).format();
                                          if(objclcontract.ScCollection_Current_Principal__c !=null)
                                         currentBalance = ((objclcontract.ScCollection_Current_Principal__c).setScale(2)).format();
                                          if(objclcontract.ScCollection_Residual_Amount__c !=null)
                                         balloanPayment = ((objclcontract.ScCollection_Residual_Amount__c).setScale(2)).format();
                                          if(objclcontract.ScCollection_Introducer__c !=null)
                                         introducerDetails = objclcontract.ScCollection_Introducer__c;
                                          if(objclcontract.ScCollection_Contract_End_Date__c !=null)
                                         balloanPaymentAsOf = objclcontract.ScCollection_Contract_End_Date__c.format();
                                         loanNumber = objclcontract.Name;
                                         loanName = objclcontract.pafss_Loan_Name_Formula__c;
                                         if(objclcontract.collect__Loan_Status__c!=null)
                                         loanStatus = (objclcontract.collect__Loan_Status__c).toLowerCase();
                                         progressBarWidth = '0';    // find progress bar with to show on page.
                                         if(objclcontract.ScCollection_All_Cash_Received__c!=null && objclcontract.ScCollection_Current_Principal__c!=null && (objclcontract.ScCollection_All_Cash_Received__c+objclcontract.ScCollection_Current_Principal__c)>0)
                                          {
                                            progressBarWidth =String.valueof((objclcontract.ScCollection_All_Cash_Received__c/(objclcontract.ScCollection_All_Cash_Received__c+objclcontract.ScCollection_Current_Principal__c))*100);
                                          }
                                        if(objclcontract.ScCollection_Next_Installment_Date__c !=null)  
                                        {
                                                // find min day and max day to show date on payout figure pop up.
                                                
                                                if(system.today().addDays(2)<objclcontract.ScCollection_Next_Installment_Date__c) 
                                                {
                                                   minDay = 2;
                                                   maxDay = system.today().daysBetween(objclcontract.ScCollection_Next_Installment_Date__c);
                                                }
                                                else
                                                {
                                                   minDay =3;
                                                   maxDay = system.today().daysBetween(objclcontract.ScCollection_Next_Installment_Date__c.addmonths(1));
                                                }
                                                
                                        }
                          
                        } 
        }  
        
      
        loadCmsData();
        
  }   
  
// This method is used to load CMS data.

public void loadCmsData()
{
    lstQuestions = [select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c
                    from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='PAFLoanDetails' and pepSection__r.pepSectionUniqueName__c='PAFLoanDetailsSection11' and pepType__c='Button' order by pepSequence__c];
    
    lstLeftSideBarSections =[select id,pepHeader__c,pepCss_Class__c,pepRedirect_to_Page__c from pepCmsSection__c where Page_Name__c='DashboardSideBarTemplate' order by pepSequence__c asc];
       
} 
  
// This method is used to update the loan name of contract.
  
  public void changeloanName()
  {
       try
       {
                  successMsg = false;
                  dontShowAlert = false;
                  
                if(string.isNotBlank(headerInput))  //check the null value for loan name.
                 {
                 
                         if(string.isNotBlank(loanAccountId))
                         {
                                  
                                   if(objclcontract !=null)
                                   {
                                               if(objclcontract.pafss_Loan_Name_Formula__c == headerInput)  // check entered loan name is equal to already exist loan name.
                                               {
                                                  dontShowAlert = true;                       // no change required.
                                               } 
                                             
                                                         
                                              else
                                              {
                                                     objclcontract.pafss_Loan_Name__c = headerInput;   // update new loan name value to database.
                                                     update objclcontract;
                                                     successMsg = true;
                                              }
                                   }     
                       }
                }
                
                 else{
                             successMsg = false; 
                             
                     } 
            } 
        catch(Exception ex)   
        {
           successMsg = false; 
        } 
               
  }
  
 // This method is used to update account and to redirect on page after click from sidebar.
 
   public pageReference updateAccount()
    {
       // String idLoanAccount = Apexpages.currentPage().getParameters().get('loanContractid');
        System.debug('idLoanAccount ****** '+idLoanAccount);
        if(string.isNotBlank(idAccount) && string.isNotBlank(idLoanAccount))
        {
                Account objAccount = new Account(id=idAccount);
                objAccount.Loan_Account_Id__c = idLoanAccount;
                update  objAccount;
                String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(idLoanAccount); // check the contract id(it is of PAF contract or PL contract) 
                     if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')   // redirection for PL contract
                     {
    
                        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                     }
                   else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c')    // redirection for PAF contract
                   {
                        string redircetPageName= pages_config__c.getinstance('pafviewmyassetloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                   } 
        }   
        return null;     
   }
    
    
 /* private Integer pageStepNumber(String pageName)
    {
        Integer intStep=0;
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
    } */
    public pageReference checkCase()
    {
            showEachPopup = false;
            showCommonPopup = false;
            errorPopup = false;
            alreadyProcess = false;
            
         // This logic is used to check whether there is already a case exist with these sunject    
         
            if((assignedPage=='updatePayment' && contractMap.containsKey('Bank and Payment Details Request')) || 
            (assignedPage=='RequestStatement' && contractMap.containsKey('Statement Request')) || (assignedPage=='payoutFigure' && contractMap.containsKey('Payout Figure Request')))
              { 
              
                 // if already a case exist then fetch the case number for it.
                 
                 if(assignedPage=='updatePayment')  
                  {
                     caseNumber = contractMap.get('Bank and Payment Details Request') ;  
                  }
                 else if(assignedPage=='RequestStatement')
                  {
                     caseNumber = contractMap.get('Statement Request') ;
                  }
                 else if(assignedPage=='payoutFigure')
                  {
                     caseNumber = contractMap.get('Payout Figure Request') ;
                  }
                    alreadyProcess = true;
                    return null; 
              }  
              
               if(assignedPage=='updatePayment')
              {
                createCase();         // for upadate payment details create case.
              }
             else if(assignedPage=='RequestStatement')
              {
                 showEachPopup = true;               // for Request Statement open pop up to enter the months detail.
                 return null;
              }
             else if(assignedPage=='payoutFigure')
              {
                 showEachPopup = true;                   // for payout Figure open pop up to eneter the date.
                 return null;
              }
         return null; 
    }   
    
   // This method is used to create case. 
    
    public pageReference createCase()
    {
      
            system.debug('buttonClickedIs'+assignedPage);
            showEachPopup = false;
            showCommonPopup = false;
            errorPopup = false;
            alreadyProcess = false;
        try
        {    
                            //Fetching the assignment rules on case
                                AssignmentRule AR = new AssignmentRule();
                                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                                
                                //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                               
                             Case objCase = new Case();
                             objCase.setOptions(dmlOpts);   //Setting the DMLOption on Case instance
                             objCase.pafss_Contract__c = loanAccountId;
                             objCase.accountId = idAccount;
                             objCase.SuppliedEmail = objAccount.personEmail;               
                             objCase.status = 'New';
                             objCase.PepCreatedfromPortal__c = true;
                             showCommonPopup = true;
                             
                  // check the request for which subject and recored type the case should be created.
                             
                    if(assignedPage=='updatePayment')
                     {
                             
                             objCase.subject = 'Bank and Payment Details Request';
                             objCase.description = 'Customer Name -'+' '+objAccount.name+', Time of enquiry -'+' '+dateTime.Now().format()+', Enquiry Type -'+' '+'Update Payment Details';
                             objCase.RecordTypeId= Schema.SObjectType.case.getRecordTypeInfosByName().get('Payment Detail Change Request – PAF').getRecordTypeId();
                             insert objCase;
                             case caseObject = [select id,CaseNumber from case where id=:objCase.id];
                             caseNumber =caseObject.CaseNumber; 
                             
                             return null;
                     }
                    else if(assignedPage=='RequestStatement')
                     {
                             
                             objCase.subject = 'Statement Request';
                             objCase.description = 'Customer Name -'+' '+objAccount.name+', Time of enquiry -'+' '+dateTime.Now().format()+', Enquiry Type -'+' '+'Statement Request'+', Additional Information for request -'+' '+caseMonth;
                             objCase.RecordTypeId= Schema.SObjectType.case.getRecordTypeInfosByName().get('Loan Statement Request – PAF').getRecordTypeId();
                             insert objCase;
                             case caseObject = [select id,CaseNumber from case where id=:objCase.id];
                             caseNumber =caseObject.CaseNumber; 
                             
                             return null;
                     }
                    else if(assignedPage=='payoutFigure')
                     {    
                            
                             objCase.subject = 'Payout Figure Request';
                             objCase.description = 'Customer Name -'+' '+objAccount.name+', Time of enquiry -'+' '+dateTime.Now().format()+', Enquiry Type -'+' '+'Payout Figure Request'+', Additional Information for request -'+' '+caseDate;
                             objCase.RecordTypeId= Schema.SObjectType.case.getRecordTypeInfosByName().get('Payout Figure Request - PAF').getRecordTypeId();
                             insert objCase;
                             case caseObject = [select id,CaseNumber from case where id=:objCase.id];
                             caseNumber =caseObject.CaseNumber; 
                     
                     }
         }    
         catch(exception ex)
         {
             errorPopup = true;
         }
             return null;
    }
    
  
}
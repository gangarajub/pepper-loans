public class pepOneOffPaymentReadOnlyController {
public string strAmount{get;set;}
public date strPaymentDate{get;set;}
public List<pepCmsQuestion__c> lstQuestion{get;set;} 
public List<wrappperQuestion> lstWrapperQuestion{get;set;}
public string AccountId;
public string loanAccountId ;
public list<loan__Automated_Payment_Setup__c> lstActiveAPS{get;set;}
public string strSection4{get;set;}
public List<loan__Loan_Account__c> loanContractList;
public list<pepCmsSection__c>lstSection;
public string strpagename{get;set;}
public string strvalidpagename{get;set;}
public String Page_Name{get;set;}
public String Page_Label{get;set;}

public pepOneOffPaymentReadOnlyController()
{
    page_Name = 'pepPendingMakeOneOffPayment';
    Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
    lstQuestion = new List<pepCmsQuestion__c>();
    lstSection = new list<pepCmsSection__c> ();
    lstWrapperQuestion = new List<wrappperQuestion>();    
    lstActiveAPS = new list<loan__Automated_Payment_Setup__c > ();
    AccountId = pepUtilityClass.getAccountId();
    system.debug('AccountId Swati' +AccountId);
    strpagename = ApexPages.currentPage().getParameters().get('pagename');
    system.debug('strpagename' +strpagename);
    
    if(strpagename.contains('pep'))
    {
        strvalidpagename = strpagename;
        
    }
    if(string.isNotBlank(AccountId))
    {
        loanAccountId = pepUtilityClass.getLoanAccountId(AccountId);
    }
    
    system.debug('loanAccountId Swati' +loanAccountId );
    
    if(string.isNotBlank(loanAccountId))
    {
        lstActiveAPS = pepUtilityClass.getActiveAutomatedPaymentSetup(loanAccountId);
        system.debug('listValueIs Swati'+lstActiveAPS);
        
        loanContractList = pepUtilityClass.getLoanContract(loanAccountId);
        system.debug('listValueIs Swati'+loanContractList);
    } 
                   
    if(lstActiveAPS != null && lstActiveAPS.size() > 0)
    {
        strAmount = (lstActiveAPS[0].loan__Transaction_Amount__c).format();
        strPaymentDate = lstActiveAPS[0].loan__Debit_Date__c;
    }
    
    loadCMSContent();
                    
    
}
    
    public void loadCMSContent()
    { 
         
      for(pepCmsQuestion__c objQuestion:[select id,pepLabelPriorQuestion__c,pepType__c,pepIsRequired__c,pepKeyPressNumbersOnly__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c,
      (select id,pepActualValue__c,pepCmsQuestion__c,pepDisplayText__c,pepSequence__c from pepCMSAnswer__r) from pepCmsQuestion__c  where pepPage__r.pepPageName__c = 'Make One Off Payments ReadOnly' order by pepSequence__c])
      {  
          lstWrapperQuestion.add(new wrappperQuestion(objQuestion));
      }
      
      lstSection = [Select id,pepSectionBodyRich__c,pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Make One Off Payments ReadOnly' and pepSectionUniqueName__c = 'Make One Off Payments ReadOnly Section 4' limit 1];
       
       if(lstSection != null && lstSection.size() > 0)
       {
           strSection4 = lstSection[0].pepSectionBodyRich__c;
           
           if(loanContractList != null && loanContractList[0].Name != null)
           {
               strSection4 = strSection4.replace('LoanNumber','<span>'+loanContractList[0].Name+'</span>');
           }
       }
       
       system.debug('strSectionStory Swati' + strSection4);
      
      
    }
  
 public class wrappperQuestion
 {
       public pepCmsQuestion__c objCmsQuestion {get; set;} //main question             
 
        public wrappperQuestion(pepCmsQuestion__c objQuestion)
        {
           objCmsQuestion = objQuestion;                                                          
        }
 }
    
    
    
    public PageReference CancelMethod() {
        pageReference ref;
        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
        ref = new pageReference('/'+redircetPageName);
      //  ref = new pageReference('/apex/pepViewMyLoanPage');
        ref.setRedirect(true);
        return ref;
    }


    
}
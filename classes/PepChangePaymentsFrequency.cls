// ---------------------------------------------------------------------------------------------------------
// This class is  used to update the payment frequency of users. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      25th Apr 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
public class PepChangePaymentsFrequency
{
   
    public String calculatedRepayment{get;set;}
    public String selectedFrequency{get;set;}
    public Decimal monthlyAmount{get;set;}
    public Boolean successMsg{get;set;}
    public Boolean activeHoliday{get;set;}
    public String Section3{get;set;}
    public String inputDate{get;set;}
    String duplicateSection3;
    public loan__Loan_Account__c objLoanAccount;
    public loan__Automated_Payment_Setup__c objAutomatedPayment;
    List<loan__Loan_Account__c> loanContractList;
    List<loan__Automated_Payment_Setup__c> APSList;
    list<date> apsDateList ;
    Map<date,loan__Automated_Payment_Setup__c> apsMap = new Map<date,loan__Automated_Payment_Setup__c>();
    String loanAccountId;
    public String Page_Name{get;set;}
    public String Page_Label{get;set;}
    public String nextInterestChargeDate{get;set;}

// This is used to fetch the contract object record of specific record id and their child objects.

 public PepChangePaymentsFrequency()
 {
 
         page_Name = 'pepChangePaymentsFrequency';
         Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
         loanContractList  = new List<loan__Loan_Account__c>();
         APSList = new List<loan__Automated_Payment_Setup__c>();
         apsDateList = new list<date>();
         objLoanAccount = new loan__Loan_Account__c();
         objAutomatedPayment = new loan__Automated_Payment_Setup__c();
         successMsg = false;
         activeHoliday = false;
         monthlyAmount = 0;
         calculatedRepayment = '';
         Section3 ='';
         duplicateSection3 = '';
         inputDate = '';
         loadCmsData();
         String idAccount = pepUtilityClass.getAccountId();
         if(string.isNotBlank(idAccount))
           loanAccountId = pepUtilityClass.getLoanAccountId(idAccount);
         if(string.isNotBlank(loanAccountId))
         {
             Boolean inPaymentHoliday = false;
             loanContractList = pepUtilityClass.getLoanContract(loanAccountId);
             LoanActions act = new LoanActions();
             inPaymentHoliday = act.inPaymentHoliday(loanAccountId);
             if(inPaymentHoliday==true)
             {
                activeHoliday = true;
             }
             
         }
        
    if(loanContractList!=null  && !loanContractList.isEmpty() )
     {
           
            for (loan__Loan_Account__c instanceLoanAccount:loanContractList)
                {
                        objLoanAccount = instanceLoanAccount;
                        if(objLoanAccount.loan__Next_Interest_Posting_Date__c!=null)
                           nextInterestChargeDate = (objLoanAccount.loan__Next_Interest_Posting_Date__c).format();
                        system.debug('loanAccountIs'+objLoanAccount);
                        for(loan__Automated_Payment_Setup__c automated : instanceLoanAccount.loan__Automated_Payment_Setup__r) 
                         {
                              if(automated.loan__Type__c =='RECURRING')
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
                objAutomatedPayment  =  apsMap.get(apsDateList.get(apsDateList.size()-1));
           }
           
           
            if(objAutomatedPayment.loan__Transaction_Amount__c!=null)
               calculatedRepayment = ((objAutomatedPayment.loan__Transaction_Amount__c).setScale(2)).format();
            if(string.isnotblank(objAutomatedPayment.loan__Frequency__c))
            {
               selectedFrequency = (objAutomatedPayment.loan__Frequency__c).tolowercase();
               if(selectedFrequency == 'bi-weekly')
                  selectedFrequency = 'fortnightly';
               Section3=Section3.replace('{frequency}',selectedFrequency);
            }
            
            if(string.isnotblank(selectedFrequency) && string.isnotblank(calculatedRepayment))
            {
               if(selectedFrequency=='weekly')
                  monthlyAmount= (loanContractList[0].loan__ACH_Debit_Amount__c)*4;
              else if(selectedFrequency=='fortnightly')
                  monthlyAmount= (loanContractList[0].loan__ACH_Debit_Amount__c)*2;
              else if(selectedFrequency=='monthly')
                  monthlyAmount= (loanContractList[0].loan__ACH_Debit_Amount__c);
           }
     }
        
 } 
 
 // This is used to create option list of frequency like weekly,monthly and fortnightly.
  
 public List<SelectOption> getFrequency() 
   {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('weekly','weekly'));
            options.add(new SelectOption('fortnightly','fortnightly'));
            options.add(new SelectOption('monthly','monthly'));
            return options;
  }
  
 // This method id used to load CMS data for  this page.
    
 public void loadCmsData()
  {
       List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name,pepSequence__c,
                                                                    pepSectionUniqueName__c, pepType__c,pepSectionBodyRich__c, 
                                                                    pepSectionStory__c ,pepPage__r.pepPageName__c 
                                                                    from pepCmsSection__c  where pepPage__r.pepPageName__c='Change payments frequency' order by pepSequence__c DESC];
                                                                    
                 Section3 = lstSections[0].pepSectionBodyRich__c; 
                 duplicateSection3 = Section3 ;
  }  
  
  // This method id used to calculate the repayment amount on the basis of frequency.
  
   public void calculateRepaymentValue()
    {
       
            if(monthlyAmount !=null && monthlyAmount>0)
            {
                                 
                                  if(selectedFrequency=='weekly')
                                   {
                                      calculatedRepayment = (((monthlyAmount)/4).setScale(2)).format() ;
                                      Section3 = duplicateSection3;
                                      Section3=Section3.replace('{frequency}',selectedFrequency);
                                   }
                                  
                                  else if(selectedFrequency=='fortnightly')
                                  {
                                      calculatedRepayment = (((monthlyAmount)/2).setScale(2)).format() ;
                                      Section3 = duplicateSection3;
                                      Section3=Section3.replace('{frequency}',selectedFrequency);
                                  }
                                  
                                  else  if(selectedFrequency=='monthly')
                                  {
                                      calculatedRepayment = ((monthlyAmount).setScale(2)).format() ;
                                      Section3 = duplicateSection3;
                                      Section3=Section3.replace('{frequency}',selectedFrequency);
                                  }
             }
        
     } 
     
 // This method is used to update the frequency in database after hitting API.  
    
   public void updateLoanAccount()
   {
      try{
              
                  system.debug(''+loanAccountId);
                  Date debitDate = date.parse(inputDate);
                  LoanActions action = new LoanActions();
                  loan__Automated_Payment_Setup__c aps;
                  if(selectedFrequency=='fortnightly')
                  {
                    
                     aps = action.changeFrequency(debitDate, 'Bi-weekly', loanAccountId);
                  }
                  
                  else
                  {
                      // system.debug('loanAccountIdIs'+loanAccountId);
                     //  system.debug('selectedFrequencyIs'+selectedFrequency);
                       aps = action.changeFrequency(debitDate, selectedFrequency, loanAccountId);
                      
                  }
                  system.debug('updateFrequencyIs'+aps);
                  
                  if(aps.id!=null){
                        successMsg = true;
                       // system.debug('idIssssssss'+aps.id);
                       // system.debug('successMsgIssssssss'+successMsg);
                  }
       }
        catch(Exception e)
        {
            successMsg = false; 
        }
   }  
   
   
 
 // This method is used to redirect on home page after click on cancel button.
  
  public pageReference cancelRedirection()
  {
          string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
          Pagereference pr = new pageReference('/'+redircetPageName).setredirect(True);
        //  Pagereference pr = new Pagereference('/apex/pepViewMyLoanPage').setredirect(True);
          return pr;
  }

}
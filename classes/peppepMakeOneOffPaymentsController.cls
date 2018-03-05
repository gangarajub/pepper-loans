public class peppepMakeOneOffPaymentsController {
public List<pepCmsQuestion__c> lstQuestion{get;set;} 
public List<wrappperQuestion> lstWrapperQuestion{get;set;}
public String strselectedBankName { get; set; }
public String strBSB{ get; set; }
public String strACH {get;set;}
public String strAccountNumber{ get; set; }
public String strAccountHolderName{ get; set; }
public decimal strAPSTxnAmt { get; set; }
public date strAPSDebitDt{ get; set; }
public list<selectOption> lstOptions {get; set;}
public string selectedAccount{get;set;}
public boolean boolCreateNew{get;set;}
public boolean boolstrAmount {get;set;}
public decimal strAmount{get;set;}
public List<loan__Bank_Account__c> LstBankAccounts{get;set;}
public loan__Bank_Account__c objBankAccount{get;set;} 
public list<pepBank_API_Details__c> lstBankAPIDetails{get;set;} 
public List<loan__Bank_Account__c> lstFetchedBankAccounts {get;set;} 
public List<loan__Bank_Account__c> lstNewBankAccounts {get;set;} 
public string AccountId;
public string loanAccountId ;
public List<loan__Loan_Account__c> loanContractList;
public map<id,loan__Bank_Account__c>mapIdToBankAccount{get; set;}
public list<selectOption> lstBankName{get; set;}  
public string inputDate { get; set; }
public loan__Automated_Payment_Setup__c objAPS{get;set;}
public list<loan__Automated_Payment_Setup__c> lstAPS{get;set;}
public list<loan__Automated_Payment_Setup__c> lstActiveAPS{get;set;}
public list<loan__Automated_Payment_Setup__c> lstPaymentSetup{get;set;} 
public date dt;
public string pagename;
public Boolean successMsg{get;set;}
public string strDOB{get;set;}
public String Page_Name{get;set;}
public String Page_Label{get;set;}
public boolean boolBSCallBWebserviceError{get;set;}
List<loan__Bank_Account__c>   LstValidBankAccounts;
public peppepMakeOneOffPaymentsController()
{
page_Name = 'pepMakeOneOffPayments';
Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
pagename = 'Make one-off payments';
lstQuestion = new List<pepCmsQuestion__c>();
lstWrapperQuestion = new List<wrappperQuestion>();
lstBankAPIDetails = new list<pepBank_API_Details__c> ();
LstBankAccounts  = new List<loan__Bank_Account__c> ();
LstValidBankAccounts = new List<loan__Bank_Account__c>(); 
objBankAccount = new loan__Bank_Account__c();
lstActiveAPS = new list<loan__Automated_Payment_Setup__c > (); 
dt = system.today();
lstFetchedBankAccounts = new List<loan__Bank_Account__c> ();
lstNewBankAccounts = new List<loan__Bank_Account__c> ();
strselectedBankName  = '';
boolstrAmount  = false;
successMsg = false;
boolBSCallBWebserviceError = false;
objAPS = new loan__Automated_Payment_Setup__c ();
lstAPS = new list<loan__Automated_Payment_Setup__c > ();
lstPaymentSetup = new list<loan__Automated_Payment_Setup__c > ();
lstOptions = new list<selectOption>();
boolCreateNew = false;
mapIdToBankAccount = new map<id,loan__Bank_Account__c> ();
lstBankName = new list<selectOption>();

    AccountId = pepUtilityClass.getAccountId();
    //AccountId ='001N000000j7vTQ';
    system.debug('AccountId' +AccountId);
    
    if(string.isNotBlank(AccountId))
    {
        loanAccountId = pepUtilityClass.getLoanAccountId(AccountId);
    }
    system.debug('loanAccountId ' +loanAccountId );
    
    if(string.isNotBlank(loanAccountId))
    {
        loanContractList = pepUtilityClass.getLoanContract(loanAccountId);
          
        
    }
    
        loadCMSContent();

}


public void loadCMSContent()
  {  
      for(pepCmsQuestion__c objQuestion:[select id,pepLabelPriorQuestion__c,pepType__c,pepIsRequired__c,pepKeyPressNumbersOnly__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c,
      (select id,pepActualValue__c,pepCmsQuestion__c,pepDisplayText__c,pepSequence__c from pepCMSAnswer__r) from pepCmsQuestion__c  where pepPage__r.pepPageName__c = 'Make One Off Payment' order by pepSequence__c])
      {  
          lstWrapperQuestion.add(new wrappperQuestion(objQuestion));
      }
      
      if(AccountId != null)
      {
            BankParserService bankParser = new BankParserService ();
            LstBankAccounts = bankParser.getBankAccountsForAccount(AccountId);
            system.debug('objApplication.genesis__Account__c' + AccountId);
            system.debug('LstBankAccounts '+LstBankAccounts );
             if(LstBankAccounts != null && LstBankAccounts.size() > 0)
            {
                for(loan__Bank_Account__c objBankAccount : LstBankAccounts)
                {
                    
                    if(objBankAccount.Invalid__c == false)
                    {
                        LstValidBankAccounts.add(objBankAccount );
                    }
                }
            }
            
            
      }
      
      if(LstValidBankAccounts != null && LstValidBankAccounts.size() > 0)
      {
           for(loan__Bank_Account__c objBankAccount : LstValidBankAccounts)
           {
               if(objBankAccount.Bank_Account_Number__c != null && objBankAccount.loan__Bank_Name__c != null && objBankAccount.loan__Account_Usage__c == 'Borrower/Investor Account')
               {
                    
                    lstOptions.add(new selectOption(objBankAccount.id,objBankAccount.loan__Bank_Name__c + '-' + objBankAccount.BSB__c + '-' + objBankAccount.Bank_Account_Number__c ));
                    lstNewBankAccounts.add(objBankAccount);                                                          
               }
           }
           
           
           
      }
      
      
      
      lstOptions.add(new selectOption('Create New...', 'Create New...'));
      RetrieveBankAccountData();
      
      system.debug('selectedaccount' +selectedAccount);
      system.debug('LstBankAccounts ****' +LstBankAccounts );
      system.debug('LstBankAccounts ****' +lstOptions);
      
  
      
  }
  
 public class wrappperQuestion
 {
       public pepCmsQuestion__c objCmsQuestion {get; set;} //main question      
       public String inputDateValue{get;set;}
       
 
        public wrappperQuestion(pepCmsQuestion__c objQuestion)
        {
           objCmsQuestion = objQuestion;
           inputDateValue = '';                                                           
        }
 }
 
 public void RetrieveBankAccountData()
     {
     system.debug('lstNewBankAccounts'+lstNewBankAccounts);
     
         if(selectedAccount == null)
         {
             if(lstNewBankAccounts != null && lstNewBankAccounts.size() > 0)
             {
                 selectedAccount = lstNewBankAccounts[0].id;
             }
             
             else if(LstValidBankAccounts.size() == 0)
             {
                 getBankAPIDetails();
             }
         }
         
         system.debug('selectedAccount' +selectedAccount );
         
         if(selectedAccount != '' && selectedAccount != 'Create New...')
         {
             if(lstNewBankAccounts != null && lstNewBankAccounts.size() > 0)
             {
                 for(loan__Bank_Account__c objBA: lstNewBankAccounts)
                 {
                     if(objBA.id == selectedAccount)
                     {
                         lstFetchedBankAccounts.clear();
                         lstFetchedBankAccounts.add(objBA);
                         strAccountHolderName = lstFetchedBankAccounts[0].Account_Holder_Name__c;
                         strAccountNumber = lstFetchedBankAccounts[0].Bank_Account_number__c;
                         strBSB = lstFetchedBankAccounts[0].BSB__c;
                         strselectedBankName = lstFetchedBankAccounts[0].loan__Bank_Name__c;
                         boolCreateNew = false;  
                     }
                      
                 }                                                 
             }
         }
         
         if(selectedAccount == 'Create New...' )
         {
             strAccountHolderName = '';
             strAccountNumber = '';
             strBSB = '';
             strselectedBankName = '';
             getBankAPIDetails();
             boolCreateNew = true;
             
         }
         system.debug('lstFetchedBankAccounts ' +lstFetchedBankAccounts);
     }
     
     public void getBankAPIDetails()
     {
         lstBankAPIDetails = [Select id,pepBank_Name__c from pepBank_API_Details__c limit 50000];
             
             system.debug('lstBankAPIDetails**' +lstBankAPIDetails );
             
             if(lstBankAPIDetails != null && lstBankAPIDetails.size() > 0)
             {
                 for(pepBank_API_Details__c  objAPIDetails : lstBankAPIDetails )
                 {
                     lstBankName.add(new selectOption(((objAPIDetails.pepBank_Name__c).toLowerCase()),objAPIDetails.pepBank_Name__c));
                     lstBankName.sort();
                 }
             }
     }
     
     public pagereference CreateBankAccount()
     {
         system.debug('selectedAccount Swa' + loanContractList[0].loan__Principal_Remaining__c);
         System.debug('@@@@@@@'+strAmount);
          boolstrAmount = false;
         if(strAmount != null && ((strAmount > loanContractList[0].loan__Principal_Remaining__c) || strAmount == 0))
         {
             boolstrAmount = true;
             return null;
         }
         
         
         
         if(selectedAccount == null)
         {
             if(lstNewBankAccounts != null && lstNewBankAccounts.size() > 0)
             {
                 selectedAccount = lstNewBankAccounts[0].id;
             }
             
         }
         
         system.debug('selectedAccount' +selectedAccount );
         BankApi bankapi = new BankApi();
         WrapperBankAccount  bankAcc = new WrapperBankAccount();
         List< WrapperBankAccount > listacc = new List< WrapperBankAccount >();
         
         
         if(inputDate != null && inputDate != '' )
         {        
             list<String> lstDOB = inputDate.split('/');
             system.debug('inputDate' +lstDOB);
             dt = date.newInstance(Integer.valueOf(lstDOB[2]),Integer.valueOf(lstDOB[1]),Integer.valueOf(lstDOB[0]));
             system.debug('dt' +dt);
         }
         
         if(selectedAccount != '' && selectedAccount != 'Create New...')
         {
             BankApi.Response strresponse = bankapi.activateBankAccount(selectedAccount,null,loanAccountId);
             //system.debug('Response for activation' + strresponse.status);
             //system.debug('Response for activation id' + strresponse.bankAccount);
             if(lstNewBankAccounts != null && lstNewBankAccounts.size() > 0)
             {
                 for(loan__Bank_Account__c objBA: lstNewBankAccounts)
                 {
                     system.debug('Response for activation' + objBA.id);
                     
                     if(objBA.id == selectedAccount)
                     {
                         
                         LoanActions la = new LoanActions();
                          Date debitDate = dt;
                          
                          if(stramount != null && stramount != 0)
                          {
                              objAPS = la.makeOneOffPayment(strAmount,objBA.id,loanAccountId,null,debitDate,true,true);
                              system.debug('idIssssssss'+objAPS.id);
                              
                              if(objAPS.id != null)
                              {
                                  strAPSTxnAmt = objAPS.loan__Transaction_Amount__c;
                                  strAPSDebitDt = objAPS.loan__Debit_Date__c;
                              }
                          }
                          
                     }
                      
                 }                                                 
             }
             
             
             
         }
         
         
         
         else if(selectedAccount != '' && selectedAccount == 'Create New...')
         {
             
             system.debug('Response for activation' + strAccountNumber);
             system.debug('Response for activation' + strBSB);
             system.debug('Response for activation' + strselectedBankName);
             system.debug('Response for activation' + strAccountHolderName);
             //----- Code Added by Amit kumar 09/09/2016 -----------------------
            //------ This code validates BSB through web service---------------- 
             if(strBSB != null && strBSB !='' && strBSB.length() ==6)
             {
                 String strBSBfromResponse = strbsb.substring(0, 3) + '-' + strbsb.substring(3, strbsb.length());
                 String strBsbValidationResponse = pepUtilityClass.callBSBvalidationWebService(strBSB);
                 System.debug('strBsbValidationResponse*****'+strBsbValidationResponse);
                 pepBSBWebserviceResponse objResponse = pepUtilityClass.readBSBXMlResponse(strBsbValidationResponse);
                if(objResponse.BSB == null || (objResponse.BSB != null && objResponse.BSB.trim() != strBSBfromResponse.trim()))
                {
                
                System.debug('strBsbValidationResponse*****'+strBsbValidationResponse);
                boolBSCallBWebserviceError = true;                
                return null;
                }
                else
                {
                boolBSCallBWebserviceError = false;
                strselectedBankName = objResponse.FinancialInstitutionCode;
                }
                 
             }
           //---------------------------------------------------------------------- 
             bankAcc.Set(AccountId,'Borrower/Investor Account', strAccountNumber, strBSB, strselectedBankName,null,strAccountHolderName,loanAccountId,false,null,true,true);
             Listacc.add(bankAcc);
             list<BankApi.Response> lstresp = bankapi.addNewBanks(Listacc);
             system.debug('Response for adding' + strAmount);
             //system.debug('Response for adding id' + resp.bankAccount);
             LoanActions la = new LoanActions();
             Date debitDate = dt;
             
             if(stramount != null && stramount != 0)
              {
                  objAPS = la.makeOneOffPayment(strAmount,lstresp[0].bankaccount.id,loanAccountId,null,debitDate,true,true);
                  system.debug('idIssssssss'+objAPS.id);
                  
                  if(objAPS.id != null)
                  {
                      strAPSTxnAmt = objAPS.loan__Transaction_Amount__c;
                      strAPSDebitDt = objAPS.loan__Debit_Date__c;
                  }
              } 
             
             
         }
         
         if(objAPS.id!=null)
         {
                    successMsg = true;
                    system.debug('idIssssssss'+objAPS.id);
                    system.debug('successMsgIssssssss'+successMsg);
          }
          
          Map<string, string> mapnew = new Map<string, string>();
                        string currentDate = string.valueOf(dateTime.now());
                        mapnew.put('Make_one_off_payments_time_stamp__c',currentDate);
                        LoanActions loanAc = new LoanActions();
                        loan__Loan_Account__c loanAcc = loanAc.updateLoanAccount(loanAccountId,mapnew);
                        
         return null;
         
         
     }
     
     
     
Public Pagereference checkcookie(){

        lstActiveAPS = pepUtilityClass.getActiveAutomatedPaymentSetup(loanAccountId);
        system.debug('listValueIs'+lstActiveAPS); 
        
        if(lstActiveAPS != null && lstActiveAPS.size() > 0)
        {
            string redircetPageName= pages_config__c.getinstance('peppendingmakeoneoffpayment').Page_Label__c;
            Pagereference objNextPage  = new Pagereference('/'+redircetPageName);
          //  pageReference objNextPage = Page.pepPendingMakeOneOffPayment;
            objNextPage.getParameters().put('pagename', pagename );
            objNextPage.setRedirect(true);
            return objNextPage;
            
        }
return null;
}


Public Pagereference CancelMethod()
{
    pageReference ref;
    string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
    ref = new pageReference('/'+redircetPageName);
    ref.setRedirect(true);
    return ref;
}

Public Pagereference redirectOK()
{
    pageReference ref;
    string redircetPageName= pages_config__c.getinstance('peptransactionhistory').Page_Label__c;
    ref = new pageReference('/'+redircetPageName);
    ref.setRedirect(true);
    return ref;
}


}
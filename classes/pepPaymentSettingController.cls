/**
* @author  Krishnanand Gupta(SaaSfocus)
* @version 1.0
* @since   2016-05-10 
* @Desc this class is used to show/edit loan account's bank details
*/
public class pepPaymentSettingController {
public List<pepCmsSection__c> lstSection{get;set;}
public List<pepCmsSection__c> lstSectionDetails{get;set;}
public String pageName{get;set;}
public List<loan__Bank_Account__c>   LstBankAccounts{get;set;}

public String SelectedAccount{get;set;}
public String SelectedBank{get;set;}
public String strAccountName{get;set;}
public String strAccountNumber{get;set;}
public String strBSB{get;set;}
public String strBillerCode{get;set;}
public String strRefNumber{get;set;}

public String AccountId{get;set;}
public String strSectionType{get;set;}

public list<selectOption> lstOptions {get; set;}
public list<selectOption> lstBankName{get; set;} 
public String ID_Contract;
public boolean closedLoan{get;set;} 
Set<String> contractStatusSet ;

Map<Id,loan__Bank_Account__c> mpBankAccount;
public String Page_Name{get;set;}
public String Page_Label{get;set;}
public boolean boolBSCallBWebserviceError{get;set;}
public pepPaymentSettingController()
{
  page_Name = ApexPages.currentPage().getUrl();
  page_Name = page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());
  Page_Label = pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
  lstSection=new List<pepCmsSection__c>();
  lstSectionDetails = new List<pepCmsSection__c>();
  lstOptions=new list<selectOption>();
  lstBankName=new list<selectOption>();
  closedLoan = false;
  boolBSCallBWebserviceError = false;
  contractStatusSet = New Set<String> ();
  strSectionType='view';
  contractStatusSet.addall(Label.CLContractStatus.split(','));

        pageName=ApexPages.currentPage().getUrl();
        pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        lstSection=[select id,pepHeader__c,pepSectionUniqueName__c,pepSectionStory__c,pepSectionBodyRich__c,pepSectionBody__c,pepSectionStoryRich__c,(Select id,pepLabelPriorQuestion__c,pepLabelAfterQuestion__c,pepType__c,pepSequence__c,pepGenericErrorMessage__c from pepQuestion__r order by pepSequence__c asc)  from pepCmsSection__c where Page_Name__c= 'PaymentSetting' and pepSectionUniqueName__c='PaymentSetting'];
        lstSectionDetails = [select id,pepHeader__c,pepSectionUniqueName__c,pepSectionStory__c,pepSectionBodyRich__c,pepSectionBody__c,pepSectionStoryRich__c,(Select id,pepLabelPriorQuestion__c,pepLabelAfterQuestion__c,pepType__c,pepSequence__c,pepGenericErrorMessage__c from pepQuestion__r order by pepSequence__c asc)  from pepCmsSection__c where Page_Name__c= 'pepPaymentDetails' and pepSectionUniqueName__c='PaymentDetails_BanKDetails'];
  
    ID_Contract=pepUtilityClass.getLoanAccountId(pepUtilityClass.getAccountId());
     if(ID_Contract==null || ID_Contract=='')
     ID_Contract=apexpages.currentpage().getParameters().get('id');//a3iN0000000gzpv
  
  List<Account> lstAccount=[select id,pepBiller_Code__c from  Account where name=:Label.Pepper_Business_Account];
  if(lstAccount!=null && lstAccount.size()>0)
     strBillerCode=lstAccount[0].pepBiller_Code__c;
  
  AccountId=pepUtilityClass.getAccountId();
  
   if(ID_Contract!=null){
       List<loan__Loan_Account__c>  lstLoanAccount=pepUtilityClass.getLoanContract(ID_Contract);
       if(contractStatusSet.contains(lstLoanAccount[0].loan__Loan_Status__c)) 
          closedLoan = true;
  
    // peer.BorrowerAPI12 b = peer.FractionalizationAPIFactory.getBorrowerAPI12();
    // loan__Loan_Account__c  loanAccount = b.getLoanAccountWithStatements(ID_Contract, 'loan__Account__c,CRN__c',new Set<String>{'Active - Good Standing'}, '','','', '','');
     // if(loanAccount!=null)
     // strRefNumber=loanAccount.CRN__c;
  
 
    BankParserService bankParser = new BankParserService ();
    LstBankAccounts = bankParser.getBankAccountsForAccount(lstLoanAccount[0].loan__Account__c);
    List<loan__Bank_Account__c>   LstValidBankAccounts = new List<loan__Bank_Account__c>();
    
    for(loan__Bank_Account__c objBankAccount : LstBankAccounts)
    {
    
        if(objBankAccount.Invalid__c == false)
        {
            LstValidBankAccounts.add(objBankAccount );
        }
    }
    
    mpBankAccount=new Map<Id,loan__Bank_Account__c>(LstValidBankAccounts);
    
    
    List<loan__Loan_Account__c> loanAcc = new list<loan__Loan_Account__c>();
    Map<String,String> ChildObjectMap = new Map<String,String>();
    loanAcc=RetrieveLoanAccounts.getLoanContracts(null,ID_Contract,null,'Default_Bank_Account__c,CRN__c',ChildObjectMap);
    if(loanAcc!=null)
    strRefNumber=loanAcc[0].CRN__c;

  if(mpBankAccount!=null && mpBankAccount.get(loanAcc[0].Default_Bank_Account__c)!=null)
   {
    SelectedAccount=loanAcc[0].Default_Bank_Account__c;
    strAccountName=mpBankAccount.get(loanAcc[0].Default_Bank_Account__c).Account_Holder_Name__c;
    SelectedBank=mpBankAccount.get(loanAcc[0].Default_Bank_Account__c).loan__Bank_Name__c;
    strAccountName=mpBankAccount.get(loanAcc[0].Default_Bank_Account__c).Account_Holder_Name__c;
    strAccountNumber=mpBankAccount.get(loanAcc[0].Default_Bank_Account__c).Bank_Account_Number__c;
    strBSB=mpBankAccount.get(loanAcc[0].Default_Bank_Account__c).BSB__c;
  }


      
  
  /*for(loan__Bank_Account__c  objBank:mpBankAccount.values())
  {
   if(objBank.loan__Active__c)
   {
    SelectedAccount=objBank.id;
    strAccountName=objBank.Account_Holder_Name__c;
    SelectedBank=objBank.loan__Bank_Name__c;
    strAccountName=objBank.Account_Holder_Name__c;
    strAccountNumber=objBank.Bank_Account_Number__c;
    strBSB=objBank.BSB__c;
    
    break;
   }
  }*/
  

    lstOptions.add(new selectOption('New Account','New Account'));
     for(loan__Bank_Account__c objBankAccount : LstValidBankAccounts)
           {
               if(objBankAccount.Bank_Account_Number__c != null && objBankAccount.loan__Bank_Name__c != null && objBankAccount.loan__Account_Usage__c=='Borrower/Investor Account')
               {
                    lstOptions.add(new selectOption(objBankAccount.id,objBankAccount.loan__Bank_Name__c + '-' + objBankAccount.BSB__c + '-' + objBankAccount.Bank_Account_Number__c ));
                }
            }                
    
           for(pepBank_API_Details__c  objAPIDetails : [Select id,pepBank_Name__c from pepBank_API_Details__c limit 50000])
            {
            lstBankName.add(new selectOption(objAPIDetails.pepBank_Name__c,objAPIDetails.pepBank_Name__c));
            
            }
         } 
          
     
}
public Pagereference addNewAccount()
{
 BankApi bankapi = new BankApi();
    if(SelectedAccount=='New Account')
    {
    
     //----- Code Added by Amit kumar 09/08/2016 -----------------------
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
            SelectedBank = objResponse.FinancialInstitutionCode;
        }
         
     }    
    
     strSectionType='edit';
     WrapperBankAccount  bankAcc = new WrapperBankAccount();
     List< WrapperBankAccount > listacc = new List<WrapperBankAccount>();
     bankAcc.Set(AccountId,'Borrower/Investor Account', strAccountNumber, strBSB, SelectedBank,null,strAccountName,ID_Contract,true,null,true,true);//null, false, objApplication.Id,true,true
     Listacc.add(bankAcc);
     list<BankApi.Response> lstresp = bankapi.addNewBanks(Listacc);
     System.debug('loanCOntract*****'+ID_Contract);
     System.debug('lstresp *****'+lstresp );
     }
    else
    {
     System.debug(SelectedAccount+'----'+ID_contract);
      BankApi.Response strresponse = bankapi.activateBankAccount(SelectedAccount,NULL,ID_contract);
    }  
    
       Map<string, string> mapnew = new Map<string, string>();
        string currentDate = string.valueOf(dateTime.now());
        mapnew.put('Payment_setting_time_stamp__c',currentDate);
        LoanActions loanAc = new LoanActions();
        loan__Loan_Account__c loanAcc = loanAc.updateLoanAccount(ID_Contract,mapnew);
        
      string redircetPageName= pages_config__c.getinstance('peppaymentdetails').Page_Label__c;
      PageReference  pg = new pageReference('/'+redircetPageName);
   //   PageReference  pg=new PageReference('/apex/pepPaymentDetails');
      pg.setRedirect(true);
      return pg;

}


public void changeAccount()
{
     if(SelectedAccount=='New Account')
    {
    strAccountName='';
    SelectedBank='';
    strAccountName='';
    strAccountNumber='';
    strBSB='';
    strSectionType='edit';
    }
    else
    {
    loan__Bank_Account__c objBank=new loan__Bank_Account__c();
    objBank=mpBankAccount.get(SelectedAccount);
  
    strAccountName=objBank.Account_Holder_Name__c;
    SelectedBank=objBank.loan__Bank_Name__c;
    strAccountName=objBank.Account_Holder_Name__c;
    strAccountNumber=objBank.Bank_Account_Number__c;
    strBSB=objBank.BSB__c;
     strSectionType='view';
    }

}
   public pageReference redirectToPage()
    {
     
       String pageName = Apexpages.currentPage().getParameters().get('pageNameValue');
       System.debug('PageIs'+pageName);
       String redircetPageName= pages_config__c.getinstance(pageName).Page_Label__c;  
       Pagereference ref = new Pagereference('/'+redircetPageName); 
       Return ref.setRedirect(true);
    }



}
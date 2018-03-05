public class pepPaymentSetupController {
public String strselectedBankName { get; set; }
public String strBSB{ get; set; }
public String strAccountNumber{ get; set; }
public String strAccountHolderName{ get; set; }
public List<pepCmsQuestion__c> lstQuestion{get;set;} 
public List<wrappperQuestion> lstWrapperQuestion{get;set;}
public string selectedAccount{get;set;}
public genesis__Applications__c objApplication{get;set;}
public List<loan__Bank_Account__c> LstBankAccounts{get;set;}
public loan__Bank_Account__c objBankAccount{get;set;} 
public list<pepBank_API_Details__c> lstBankAPIDetails{get;set;} 
public List<loan__Bank_Account__c> lstFetchedBankAccounts {get;set;} 
public List<loan__Bank_Account__c> lstNewBankAccounts {get;set;} 
public list<selectOption> lstOptions {get; set;}
public list<selectOption> lstBankName{get; set;}  
public map<id,loan__Bank_Account__c>mapIdToBankAccount{get; set;}
public boolean boolCreateNew{get;set;}
//Added by Varun to check if any of the returned accounts from bank statement contains BSB or not
Public Boolean bsbAvailable;
public boolean boolBSCallBWebserviceError{get;set;}
public boolean boolBSCallBWebserviceErrorDealer{get;set;}
public boolean dealerAmountError{get;set;}
public Boolean successSaveForLater{get;set;}
public String dealerName { get; set; }
public String dealerAccountName{ get; set; }
public String dealerAccountNumber{ get; set; }
public String dealerBSB{ get; set; }
public String dealerAmount{get; set;} 
private clcommon__Collateral__c assetDetail;
Private String dealerFinancialCode;
public boolean dealerCheck{get;set;}


    public pepPaymentSetupController() {
        bsbAvailable=False;
        lstQuestion = new List<pepCmsQuestion__c>();
        lstWrapperQuestion = new List<wrappperQuestion>();
        objBankAccount = new loan__Bank_Account__c();
        objApplication = new genesis__Applications__c ();
        assetDetail = new clcommon__Collateral__c ();
        boolCreateNew = false;
        boolBSCallBWebserviceError = false;
        boolBSCallBWebserviceErrorDealer = false;
        dealerAmountError = false;
        dealerCheck = false;
        strselectedBankName  = '';
        lstOptions = new list<selectOption>();
        lstBankAPIDetails = new list<pepBank_API_Details__c> ();
        lstBankName = new list<selectOption>();
        LstBankAccounts  = new List<loan__Bank_Account__c> (); 
        lstNewBankAccounts = new List<loan__Bank_Account__c> (); 
        lstFetchedBankAccounts = new List<loan__Bank_Account__c> ();
        mapIdToBankAccount = new map<id,loan__Bank_Account__c> ();
        
        getCookieData();
        fetchApplication();
        loadCMSContent();
       
    }
    
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
       if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
           objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
    }
    
  public void fetchApplication()
        {
            //hardcode application Id
            System.debug('method called');
            Map<string,string> childobjects = new Map<string,string>();       
            String[] lstTypes = new String[]{''};
            if(objApplication != null && objApplication.Id !=null)
            {
               String[] lstTypesColletral = new String[]{'clcommon__Collateral__c'};
               List<genesis__Applications__c> lstApplication = pepUtilityClass.fetchApplicationAndChild(lstTypesColletral ,'CollateralFieldSet',null,objApplication.Id,null); 
             //  List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(lstTypes ,objApplication.Id,null,null,childobjects );
                if(lstApplication != null && lstApplication.size() >0)
                {        
                    objApplication = lstApplication[0];
                   
                }
                if(lstApplication[0].genesis__Collaterals__r !=null && lstApplication[0].genesis__Collaterals__r.size()>0) 
                 
                    {  
                                 for(clcommon__Collateral__c objColletral : lstApplication[0].genesis__Collaterals__r) 
                                   {
                                        if(objColletral.active__c == true)
                                        {
                                            assetDetail = objColletral;
                                            break;
                                        }   
                                   }
                             if(assetDetail!=null && assetDetail.id!=null)
                              {     
                                 if(string.isNotBlank(assetDetail.Is_Dealer_Purchased__c))
                                 {
                                     if(assetDetail.Is_Dealer_Purchased__c.toLowerCase()=='yes')
                                     dealerCheck = true; 
                                 }
                              } 
                    }     
             }
        }
    
  public void loadCMSContent()
  {  
      for(pepCmsQuestion__c objQuestion:[select id,pepLabelPriorQuestion__c,pepType__c,pepIsRequired__c,pepKeyPressNumbersOnly__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c,
      (select id,pepActualValue__c,pepCmsQuestion__c,pepDisplayText__c,pepSequence__c from pepCMSAnswer__r) from pepCmsQuestion__c  where pepPage__r.pepPageName__c = 'Payment Setup' order by pepSequence__c])
      {  
          lstWrapperQuestion.add(new wrappperQuestion(objQuestion));
      }
      
      if(objApplication.Id != null)
      {
            BankParserService bankParser = new BankParserService ();
            LstBankAccounts = bankParser.getBankAccountsForAccount(objApplication.genesis__Account__c);
            system.debug('objApplication.genesis__Account__c' +objApplication.genesis__Account__c);
            system.debug('LstBankAccounts '+LstBankAccounts );
            
            
      }
      
      if(LstBankAccounts != null && LstBankAccounts.size() > 0)
      {
           for(loan__Bank_Account__c objBankAccount : LstBankAccounts)
           {
               if(objBankAccount.Bank_Account_Number__c != null && objBankAccount.loan__Bank_Name__c != null && objBankAccount.loan__Account_Usage__c == 'Borrower/Investor Account' && objBankAccount.BSB__c != null && String.valueof(objBankAccount.BSB__c) != '')
               {
   
                    if(mapIdToBankAccount == null)
                    {
                        mapIdToBankAccount.put(objBankAccount.id,objBankAccount);
                    }
                    
                    String strBSB ='';
                    if(objBankAccount.BSB__c != null)
                    {
                        bsbAvailable=True;
                        strBSB =objBankAccount.BSB__c;
                    }
                    
                    lstOptions.add(new selectOption(objBankAccount.id,objBankAccount.loan__Bank_Name__c + '-' + strBSB  + '-' + objBankAccount.Bank_Account_Number__c ));
                    lstNewBankAccounts.add(objBankAccount);                                                          
               }
           }
           //Removed the following line by CJJOYA 11120161222
           //lstOptions.add(new selectOption('Create New...', 'Create New...'));
           if(bsbAvailable==false){
           lstOptions.add(new selectOption('Create New...', 'Create New...'));
           }
           RetrieveBankAccountData();
      }
      
       
      
      else if(LstBankAccounts.size() == 0)
      {
          lstOptions.add(new selectOption('Create New...', 'Create New...'));
          RetrieveBankAccountData();
      }
      
      system.debug('selectedaccount' +selectedAccount);
      system.debug('LstBankAccounts ****' +LstBankAccounts );
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
         if(selectedAccount == null)
         {
             if(lstNewBankAccounts != null && lstNewBankAccounts.size() > 0)
             {                   
                 selectedAccount = lstNewBankAccounts[0].id;
                 if(bsbAvailable==False){
                 getBankAPIDetails();
                 }
             }
             
             else if(lstBankAccounts.size() == 0)
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
                         boolCreateNew = false;  
                     }
                      
                 }                                                 
             }
             
         }
         
         if(selectedAccount == 'Create New...' )
         {
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
         system.debug('selectedAccount Swa' + strselectedBankName);
         system.debug('selectedAccount Swa' + strselectedBankName);
         dealerAmountError = false;
          //----- Code Added by Amit kumar 09/08/2016 -----------------------
        //------ This code validates BSB through web service---------------- 
         if(strBSB != null && strBSB !='' && strBSB.length() ==6)
         {
             String strBSBfromResponse = strbsb.substring(0, 3) + '-' + strbsb.substring(3, strbsb.length());
             String strBsbValidationResponse = pepUtilityClass.callBSBvalidationWebService(strBSB);
             System.debug('strBsbValidationResponse*****'+strBsbValidationResponse);
             pepBSBWebserviceResponse objResponse = pepUtilityClass.readBSBXMlResponse(strBsbValidationResponse);
             System.debug('objResponse****'+objResponse.BSB);
             System.debug('objResponse****'+objResponse);
             System.debug('strBSBfromResponse****'+strBSBfromResponse);
             
             if(objResponse.BSB == null || (objResponse.BSB != null && objResponse.BSB.trim() != strBSBfromResponse.trim()))
             {
                 System.debug('strBsbValidationResponse*****'+strBsbValidationResponse);
                 boolBSCallBWebserviceError = true;
                 return null;
                
             }
             else
             {
                 boolBSCallBWebserviceError = false;
                 strselectedBankName =objResponse.FinancialInstitutionCode;
             }
             
         }
         
         if(dealerBSB != null && dealerBSB !='' && dealerBSB.length() ==6)
         {
             String strBSBfromResponse = dealerBSB.substring(0, 3) + '-' + dealerBSB.substring(3, dealerBSB.length());
             String strBsbValidationResponse = pepUtilityClass.callBSBvalidationWebService(dealerBSB);
             System.debug('strBsbValidationResponse*****'+strBsbValidationResponse);
             pepBSBWebserviceResponse objResponse = pepUtilityClass.readBSBXMlResponse(strBsbValidationResponse);
             System.debug('objResponse****'+objResponse.BSB);
             System.debug('objResponse****'+objResponse);
             System.debug('strBSBfromResponse****'+strBSBfromResponse);
             
             if(objResponse.BSB == null || (objResponse.BSB != null && objResponse.BSB.trim() != strBSBfromResponse.trim()))
             {
                 System.debug('strBsbValidationResponse*****'+strBsbValidationResponse);
                 boolBSCallBWebserviceErrorDealer = true;
                 return null;
                
             }
             else
             {
                 boolBSCallBWebserviceErrorDealer = false;
                 dealerFinancialCode = objResponse.FinancialInstitutionCode;
             }
             
         } 
         if(String.isNotBlank(dealerAmount) && (objApplication.genesis__Loan_Amount__c < decimal.valueOf(dealerAmount) || decimal.valueOf(dealerAmount)<(objApplication.genesis__Loan_Amount__c/2)))
         {
            dealerAmountError = true;
            return null;
         } 
         BankApi bankapi = new BankApi();
         WrapperBankAccount  bankAcc = new WrapperBankAccount();
         List< WrapperBankAccount > listacc = new List< WrapperBankAccount >();
         
         if(selectedAccount != '' && selectedAccount != 'Create New...')
         {
             BankApi.Response strresponse = bankapi.activateBankAccount(selectedAccount,objApplication.Id,null);
             //system.debug('Response for activation' + strresponse.status);
             //system.debug('Response for activation id' + strresponse.bankAccount);
         }
         
         else if(selectedAccount != '' && selectedAccount == 'Create New...')
         {
             system.debug('Response for activation' + objApplication.genesis__Account__c);
             system.debug('Response for activation' + strAccountNumber);
             system.debug('Response for activation' + strBSB);
             system.debug('Response for activation' + strselectedBankName);
             system.debug('Response for activation' + strAccountHolderName);
             bankAcc.Set(objApplication.genesis__Account__c,'Borrower/Investor Account', strAccountNumber, strBSB, strselectedBankName,null,strAccountHolderName, null, true, objApplication.Id,false,true);
             Listacc.add(bankAcc);
             list<BankApi.Response> lstresp = bankapi.addNewBanks(Listacc);
             system.debug('Response for adding' + lstresp );
             //system.debug('Response for adding id' + resp.bankAccount);
         }
         
          BankApi bankapidealer = new BankApi();
          WrapperBankAccount  bankAccdealer = new WrapperBankAccount();
          List<WrapperBankAccount> listaccdealer = new List< WrapperBankAccount >();
         
         if(string.isNotBlank(dealerAccountName) && string.isNotBlank(dealerAccountNumber) && string.isNotBlank(dealerBSB))
         {
             
             
             bankAccdealer.Set(objApplication.genesis__Account__c,'Dealer Account', dealerAccountNumber, dealerBSB, dealerFinancialCode ,null,dealerAccountName, null, true, objApplication.Id,false,true);
             listaccdealer.add(bankAccdealer);
             list<BankApi.Response> lstrespdealer = bankapidealer.addNewBanks(listaccdealer);
             system.debug('Response for adding' + lstrespdealer);
             //system.debug('Response for adding id' + resp.bankAccount);
         }
         
         Id idClPurpose = objApplication.genesis__CL_Purpose__c;
         List<clcommon__CL_Purpose__c> lstCLPurpose = new List<clcommon__CL_Purpose__c>  ();
         lstCLPurpose = [select id ,name,Is_Debt_Con__c,Number_of_Debts__c from clcommon__CL_Purpose__c where id =:idClPurpose and Is_Debt_Con__c = True];
         
         Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
         myCookies = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
         system.debug('cookieApplicationId2--'+myCookies);
         pageReference ref;
         
        Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
        Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
        Map<string,string> childobjects = new Map<string,string>();
        if(objApplication != null && objApplication.id != null)
        {
            List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.id,null,null,childobjects );
            if(lstApplication != null && lstApplication.size() > 0)
            {
             
                 objApplication = lstApplication[0];
                 if(assetDetail !=null && assetDetail.id!=null && String.isNotBlank(dealerAmount))
                 {
                     list<clcommon__Collateral__c> objassetDetailList = new list<clcommon__Collateral__c>();
                     assetDetail.Dealer_Disbursement_Amount__c  = decimal.valueOf(dealerAmount);
                     objassetDetailList.add(assetDetail);
                     Map<String,List<SObject>> mapChildObjectss = new Map<String,List<SObject>>();
                     Map<String,SObject> mapRelatedObjectss = new Map<String,SObject>(); 
                     mapChildObjectss.PUT('clcommon__collateral__c',objassetDetailList);
                     genesis__Applications__c  objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjectss,mapChildObjectss);
                 }
                 objApplication.Payment_setup_time_stamp__c = DateTime.now();
                 objApplication.Dealer_Name__c = dealerName;
            }
        }
         if(lstCLPurpose.size()>0)
         {
         
                  pepUtilityClass.SaveContinueStatus(objApplication,'pepDebtConsolidation') ;
                  String redircetPageName= pages_config__c.getinstance('pepdebtconsolidation').Page_Label__c;
                  ref = new pageReference('/'+redircetPageName);
         }
         
         else
         {
         
                pepUtilityClass.SaveContinueStatus(objApplication,'pepFinaliseRepayment') ;
                String redircetPageName= pages_config__c.getinstance('pepfinaliserepayment').Page_Label__c;
                ref = new pageReference('/'+redircetPageName);
         } 
        
         ref.setCookies(new Cookie[]{myCookies }); 
         ref.setRedirect(true);
         return ref;
     }
  
    //  This method is used to save the page name of current page in navigation status of application and sent notification(retrieval code)
   //  through SMS and Email to related account of respected application.

     public void saveForLater()
     {
            successSaveForLater=false;
           if(objApplication!=null && objApplication.id!=null)  
             {
                         genesis__Applications__c objApplicationReturn = new  genesis__Applications__c ();
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepPaymentSetup') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                  
                         }    
               }                                  
      
     }
     //
     
    Public Pagereference checkcookie(){
    Pagereference pr=Peputilityclass.checkCookieAndRedirect();
    return pr;
    }
}
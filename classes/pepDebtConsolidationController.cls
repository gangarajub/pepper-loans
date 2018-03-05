// created by Bhawna - completed  - 7-APR-2016
// last changes-- 
// This class build business logic for Debt consolidation page
public class pepDebtConsolidationController {

genesis__Applications__c objApplication;
public list<genesis__Applications__c> lstApplication;
public static final string EXPENSE_TYPE= 'Debt';
public static final string EXPENSE_SUB_CREDIT = 'Credit card';
public string strCreditCardAmount{get;set;}
public list<expenseWrapper> lstExpenseWrapper{get;set;}
public boolean IsRequest{get;set;}
public boolean IsAccept{get;set;}
public list<QuesAnsWrap> lstQuesAnsWrap;
map<Id,string> mpFinInstIdToString;
public string strCCDesc{get;set;}
list<pepBank_API_Details__c> lstBankAPIDetails;
list<selectOption> lstBankName{get; set;} 
public decimal dcmlCreditCardAmountRemaining{get;set;}
public List<pepCmsQuestion__c> lstQuestions;
public Boolean successSaveForLater{get;set;}
public list<Expense_and_Debt__c> debtList;
// constructor
public pepDebtConsolidationController()
{
    objApplication =  new genesis__Applications__c(); 
    lstApplication = new list<genesis__Applications__c>();
    lstExpenseWrapper =  new list<expenseWrapper>();
    lstQuesAnsWrap = new list<QuesAnsWrap>();
    lstQuestions = new List<pepCmsQuestion__c>();
    mpFinInstIdToString =  new map<Id,string>();
    lstBankAPIDetails =  new list<pepBank_API_Details__c>();
    lstBankName =  new list<selectOption>();
    debtList = new list<Expense_and_Debt__c> ();
    IsRequest = false;
    IsAccept =  false;
    getCookieData();
    fetchApplications();
    fetchApplication();
    getBankAPIDetails();
    fetchExpenses();
}

//fetch cookies
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
    String[] lstTypes = new String[]{'genesis__Applications__c', 'Expense_and_Debt__c'};    
    String FieldSetName='pepGeneral';
    if(objApplication.Id !=null)
    {
        lstApplication=pepUtilityClass.fetchApplicationAndChild(lstTypes,FieldSetName,null,objApplication.Id,null);
        system.debug('lstApplication:: '+lstApplication);
        system.debug('Bhawna-Debt-Purpose:: '+lstApplication[0].genesis__CL_Purpose__c); 
      /*  if(lstApplication != null && lstApplication.size() >0)
           {        
               objApplication = lstApplication[0];
                   
           }   */
    }
}
      public void fetchApplications()
        {
            //hardcode application Id
            System.debug('method called');
            Map<string,string> childobjects = new Map<string,string>();       
            String[] lstTypes = new String[]{''};
            if(objApplication != null && objApplication.Id !=null)
            {
                
               List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
               System.debug('lstApplication  *********'+lstApplication);
                if(lstApplication != null && lstApplication.size() >0)
                {        
                    objApplication = lstApplication[0];
                   
                }
                
                
            }
        }

private void fetchExpenses()
{
    lstQuestions = fetchQuestions();
    system.debug('lstQuesAnsWrap:: '+lstQuesAnsWrap);
    string strExpenseHeader='';
    string strCCHeader='';
    list<pepCmsSection__c> lstSection = [select id, pepHeader__c,pepSectionBodyRich__c,pepSectionUniqueName__c from pepCmsSection__c where Page_Name__c= 'Debt Consolidation'];
    if(lstSection!=null && lstSection.size()>0)
    {
        for(pepCmsSection__c objSection :lstSection)
        {
            if(objSection.pepSectionUniqueName__c == 'DebtConsolidationAllExpenses')
                strExpenseHeader = objSection.pepHeader__c;
            
            if(objSection.pepSectionUniqueName__c == 'DebtConsolidationCreditCards')
                strCCHeader = objSection.pepHeader__c;
        }
    }
    
    if(lstApplication!=null && lstApplication.size()>0 && lstApplication[0].Purpose_Name__c !=null && lstApplication[0].Purpose_Name__c!='')
    {
    
        system.debug('bhawna-Expenses-size-'+lstApplication[0].Expenses_and_Debts__r.size());
    
        //fetch Expenses
        if(lstApplication[0].Expenses_and_Debts__r != null && lstApplication[0].Expenses_and_Debts__r.size() > 0)
        {   
           dcmlCreditCardAmountRemaining = 0; 
           integer intCount=0; 
           integer intCountCC = 0;                     
           for(Expense_and_Debt__c objExpense : lstApplication[0].Expenses_and_Debts__r)
           {
               system.debug('bhanwa-expense type:: '+ objExpense.Type__c.toLowerCase() + ' -- '+ EXPENSE_TYPE.toLowerCase());
                if(objExpense.Type__c.toLowerCase()  == EXPENSE_TYPE.toLowerCase() && objExpense.Consolidate_As_A_Debt__c == true)// if expense if of type debt
                {
                    system.debug('objExpense.Amount_Remaining_as_Debt__c:: '+objExpense.Amount_Remaining_as_Debt__c);
                    system.debug('bhanwa-expense type:: '+ objExpense.Type_of_Expense_Debt__c.toLowerCase() + ' -- '+ EXPENSE_SUB_CREDIT.toLowerCase());
                    // if expense type is credit card
                    if(objExpense.Type_of_Expense_Debt__c.toLowerCase() == EXPENSE_SUB_CREDIT.toLowerCase())// if expense sub type is credit card
                    {
                        dcmlCreditCardAmountRemaining+= objExpense.Amount_Remaining_as_Debt__c;
                        ++intCountCC;
                    }                    
                    // if expense type is not credit card
                    else
                    {
                       //debtList
                        expenseWrapper objWrap =  new expenseWrapper();
                        objWrap.objExpense = objExpense;
                       // objWrap.strExpenseType = objExpense.Type_of_Expense_Debt__c;
                        Decimal dcml= objExpense.Amount_Remaining_as_Debt__c.setScale(2);
                        string strFormat=  dcml.format();                         
                        objWrap.strAmountRemaining = '$'+strFormat; 
                        //objWrap.strCount = string.valueOf(++intCount);
                        objWrap.strSectionHeader = strExpenseHeader.replace('{DebtDescription}', objExpense.Type_of_Expense_Debt__c );
                        objWrap.strSectionHeader = objWrap.strSectionHeader.replace('{DebtType}',string.valueOf(++intCount));
                        
                        list<QuesAnsWrap> lstQuesAnsWrap1 = new list<QuesAnsWrap>();
                        for(pepCmsQuestion__c objTempQ :lstQuestions )
                        {
                            QuesAnsWrap objChildWrap =  new QuesAnsWrap();
                            objChildWrap.objQues = objTempQ ;   
                            
                            // get it from Financial institution
                            objChildWrap.lstOptions.add(new SelectOption('null','choose one'));
                            objChildWrap.lstOptions.addAll(lstBankName);                        
                            
                            
                            lstQuesAnsWrap1.add(objChildWrap);     
                        }                                     
                        objWrap.lstQAWrap = lstQuesAnsWrap1 ;
                        lstExpenseWrapper.add(objWrap);
                    }
                    
                    
                }                 
           }
               
           // format credit crad amount remaining                
           Decimal rounded= dcmlCreditCardAmountRemaining.setScale(2);
           string strFormat=  rounded.format();
           strCreditCardAmount =  '$'+strFormat; 
           strCCDesc = strCCHeader.replace('{DebtDescription}',  string.valueOf(intCountCC)+ ' x' );    
        }  
            
       
    }
}

// wrapper class for expenses other than credit card
public class expenseWrapper
{
    public Expense_and_Debt__c objExpense{get;set;}
    //public string strCount{get;set;}
    //public string strExpenseType{get;set;}
    public list<QuesAnsWrap> lstQAWrap{get;set;}
    public string strAmountRemaining{get;set;}
    public integer intAccountNumber{get;set;}
    public string strFinancialInstitution{get;set;}
    public string strBSB{get;set;}
    public string strSectionHeader{get;set;}
   
    
    public expenseWrapper()
    {
        lstQAWrap=  new list<QuesAnsWrap>(); 
        objExpense =  new Expense_and_Debt__c();
    }
}

public class QuesAnsWrap
{
    public pepCmsQuestion__c objQues{get;set;}
    public string objInputValue{get;set;}
    public boolean boolBSCallBWebserviceError{get;set;}
    public list<SelectOption> lstOptions {get; set;}
    
    public QuesAnsWrap()
    {
        objQues =  new pepCmsQuestion__c();
        boolBSCallBWebserviceError = false;
        lstOptions = new list<SelectOption>();
    }
}

public pageReference saveData()
{    
     system.debug('-IsAccept::'+IsAccept + ' -IsRequest- '+ IsRequest);
    debtList = new list<Expense_and_Debt__c> ();
    system.debug('Bhawna-lstExpenseWrapper::'+lstExpenseWrapper);
    List<WrapperBankAccount> listacc;
    if(lstExpenseWrapper!=null && lstExpenseWrapper.size()>0)
    {
        listacc = new List<WrapperBankAccount>();
        boolean boolIsFailure = false;
        
        for(expenseWrapper objParentWrap: lstExpenseWrapper)
        { 
                   
            if(objParentWrap.lstQAWrap !=null && objParentWrap.lstQAWrap.size()>0)
            {
                WrapperBankAccount  bankAcc = new WrapperBankAccount();
                string strAccNo;
                string strAccName;
                string strBSB;
                string strFI;
                string strCR;
                System.debug('objParentWrap.lstQAWrap******'+objParentWrap.lstQAWrap);
               
                for(QuesAnsWrap objChildWrap: objParentWrap.lstQAWrap)
                {
                    system.debug('Question:: '+objChildWrap.objQues.pepLabelPriorQuestion__c );
                    system.debug('Answer:: '+objChildWrap.objInputValue);
                    system.debug('AccountId:'+lstApplication[0].genesis__Account__c);
                    
                    if(objChildWrap.objQues.pepLabelPriorQuestion__c == 'Account Name')
                        strAccName = objChildWrap.objInputValue;
                    if(objChildWrap.objQues.pepLabelPriorQuestion__c == 'Account Number')
                        strAccNo = objChildWrap.objInputValue;
                    if(objChildWrap.objQues.pepLabelPriorQuestion__c == 'BSB')
                    {
                        strBSB= objChildWrap.objInputValue;
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
                                objChildWrap.boolBSCallBWebserviceError = true;
                                boolIsFailure = true;
                            
                            }
                            else
                            {
                                objChildWrap.boolBSCallBWebserviceError = false;
                                strFI = objResponse.FinancialInstitutionCode;
                            }
                            
                        }
                    }
                    if(objChildWrap.objQues.pepLabelPriorQuestion__c == 'Creditor Reference')
                    {
                        strCR= objChildWrap.objInputValue; 
                        
                    }
                    if(objChildWrap.objQues.pepLabelPriorQuestion__c == 'Financial Institution' && objChildWrap.objQues.pepType__c == 'Picklist')
                    {
                        strFI = objChildWrap.objInputValue; 
                        //system.debug('FT::'+mpFinInstIdToString.get(objChildWrap.objInputValue));
                        //strFI = mpFinInstIdToString.get(objChildWrap.objInputValue);
                    }    
                   
                    // bankAcc.Set(accountId,‘Debt Consolidation', accountNo, bsbNo, financialIns, expense Id);
                    System.debug('strAccNo********'+strAccNo);
                    
                    
                }
                
               
                if(boolIsFailure ==false)
                {
                   
                
                        bankAcc.Set(lstApplication[0].genesis__Account__c,'Debt Consolidation', strAccNo , strBSB, strFI , objParentWrap.objExpense.Id, strAccName,  null, false, lstApplication[0].Id,true,true);
                        Expense_and_Debt__c debt =new Expense_and_Debt__c(id=objParentWrap.objExpense.id,Reference__c=strCR); 
                        debtList.add(debt);
                   
                }
                 Listacc.add(bankAcc);
            }
           
        }
         if(boolIsFailure ==true)
         {
             return null;
         }
    }
    
     BankApi bankapi = new BankApi();
     boolean isSuccessful = true;
     System.debug('ListAcc******'+ListAcc);
   //  System.debug('ListAcc******'+ListAcc.size());
     if(Listacc!=null && Listacc.size()>0)
     {   
         list<BankApi.Response> lstresp = new list<BankApi.Response>();
         if(test.isRunningTest()==false)
         lstresp= BankApi.addNewBanks(Listacc);
        // system.debug('Response:: '+lstresp);
         if(lstresp!=null && lstresp.size()>0)
         {
             Map<String,SObject> relatedObjects = new Map<String,SObject>();
             Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>(); 
             system.debug('IsAccept::'+IsAccept + ' -IsRequest- '+ IsRequest);
             system.debug('lstApplication[0]'+lstApplication[0].Id);
             lstApplication[0].Is_Accept__c = IsAccept;
             lstApplication[0].Is_Request__c= IsRequest;                   
             pepInvokeCLMethodHelper.updateApplication(lstApplication[0],relatedObjects ,childObjects);
             update debtList;
             //for(BankApi.Response objResp:lstresp)
             //{
             //    if(objResp.status !='Successful')
             //        isSuccessful = false;
             //}
         }
         
         //system.debug('Status::'+resp.status);
     }
    // if(isSuccessful == true)
     //{
         system.debug('lstApplication[0].Id:: '+lstApplication[0].Id);
         Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
         myCookies = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(lstApplication[0].Id)),null,-1,false);
         system.debug('cookieApplicationId2--'+myCookies);
         pepUtilityClass.SaveContinueStatus(objApplication,'pepFinaliseRepayment') ;
         String redircetPageName= pages_config__c.getinstance('pepfinaliserepayment').Page_Label__c;
         pageReference ref = new pageReference('/'+redircetPageName);
         ref.setCookies(new Cookie[]{myCookies }); 
         ref.setRedirect(true);
         return ref;
     //}else
     //{
     //    return null;
     //}
}

private List<pepCmsQuestion__c> fetchQuestions()
{  
    List<pepCmsQuestion__c> lstQuestions = [SELECT Id,Is_Date_to_Birth__c, pepSection__c,pepSection__r.Name , pepSection__r.pepSectionUniqueName__c, CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                pepRecordSequence__c, pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, 
                                                pepGoogleApi__c,
                                                
                                                (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                FROM pepCmsAnswer__r order by pepSequence__c ASC)                                         
                                             
                                                FROM pepCmsQuestion__c
                                                WHERE pepSection__r.pepSectionUniqueName__c ='DebtConsolidationAllExpenses'
                                                and pepSection__r.Page_Name__c= 'Debt Consolidation'
                                                ORDER BY pepSequence__c ASC];
    system.debug('lstQuestions :: '+lstQuestions );
    list<SelectOption> lstSO =  new list<SelectOption>();
    //list<pepCmsQuestion__c> lstQues=  new list<pepCmsQuestion__c>();
    for(pepCmsQuestion__c objTempQ :lstQuestions )
    {
       QuesAnsWrap objChildWrap =  new QuesAnsWrap();
       objChildWrap.objQues = objTempQ ;   
       
       // get it from Financial institution
       objChildWrap.lstOptions.add(new SelectOption('null','choose one'));
       objChildWrap.lstOptions.addAll(lstBankName);
       
      /* for(pepCmsAnswer__c A : objTempQ .pepCmsAnswer__r)
       {              
                 if(A.pepDisplayText__c == 'Choose one')
                 {
                     objChildWrap.lstOptions.add(new SelectOption('null', A.pepDisplayText__c));
                 }
                 else
                 {
                     objChildWrap.lstOptions.add(new SelectOption(A.ID, A.pepDisplayText__c));
                     mpFinInstIdToString.put(A.ID,A.pepDisplayText__c);
                 }                   
       }*/
       
       lstQuesAnsWrap.add(objChildWrap);     
    }                                               
    return  lstQuestions;
}

private void getBankAPIDetails()
{
         lstBankAPIDetails = [Select id,pepBank_Name__c from pepBank_API_Details__c limit 50000];
             
         system.debug('lstBankAPIDetails**' +lstBankAPIDetails );
             
         if(lstBankAPIDetails != null && lstBankAPIDetails.size() > 0)
         {
             for(pepBank_API_Details__c  objAPIDetails : lstBankAPIDetails )
             {
                 lstBankName.add(new selectOption(((objAPIDetails.pepBank_Name__c).toLowerCase()),objAPIDetails.pepBank_Name__c));
                 lstBankName.sort();
                // mpFinInstIdToString.put(A.ID,A.pepDisplayText__c);
             }
         }
}

//  This method is used to save the page name of current page in navigation status of application and sent notification(retrieval code)
  //  through SMS and Email to related account of respected application.

     public void saveForLater()
     {
            successSaveForLater=false;
           if(objApplication!=null && objApplication.id!=null)  
             {
                         genesis__Applications__c objApplicationReturn = new  genesis__Applications__c ();
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepDebtConsolidation') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                  
                         }     
               }                                  
      
     }

Public Pagereference checkcookie(){
Pagereference pr=Peputilityclass.checkCookieAndRedirect();
return pr;
}

}
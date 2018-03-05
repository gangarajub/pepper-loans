public class pepBankInformationDetails 
{
    //public properties
    public string strBankSlugName{get;set;}
    Public string strBankName {get;set;}
    public string strUserName{get;set;}
    Public string mystatecode{get;set;}
    public string strPassword{get;set;}
    Public string RCCfield0{get;set;}
    Public string RCCfield1{get;set;}
    Public string RCCfield2{get;set;}
    Public string RCCfield3{get;set;}
    Public string RCCfield4{get;set;}
    Public string RCCfield5{get;set;}
    Public string RCCfield6{get;set;}
    Public string RCCfield7{get;set;}
    Public string fieldname{get;set;} 
    Public string fieldvalue{get;set;}
    public string loginType{get;set;}
    Public string loginselected{get;set;}
    Public Map<string,string> fieldtovalue{get;set;}
    Public List<Profilewrapper> pepprofilewrapper{get;set;}
    Public List<pepProfileHandler.cls_fields> handlerfields{get;set;}
    Public string strSelectedOption {get;set;}
    public list<AllAccountsClass> lstBankAccounts {get; set;}
    public list<pepBank_API_Details__c> lstbank;
    public List<pepBankInstitution.Credential> lstCredentials {get;set;}
    Public string captchaImgUrl {get;set;}
    Public string userenteredname{get;set;}
    Public string strotpcredential{get;set;}
    Public string strmemorableAnswer{get;set;} 
    Public string strnetcode{get;set;}
    public string strErrorMsg {get;set;}
    public list<string> lstUserCredentials;
    public list<string> lstUserQuearyType;
    public list<string> lstWaterMarkText;
    public pepBankStatementResponse.bankSatementResponseSuccessorFailure bnk_stmt_success_failure;
    public integer intStepNumber{get;set;}
    public  Id idApplication;
    Public String profiletitle{get;set;}
    public string strProfileId {get;set;}
    public string UserToken;
    public genesis__Applications__c objApplication;
    //Constructor
    public pepBankInformationDetails() 
    {
     
        objApplication = new genesis__Applications__c();     
        loginselected='device';
        strSelectedOption ='1';
        getCookieData();
        handlerfields=new List<pepProfileHandler.cls_fields>();
        pepprofilewrapper=new List<Profilewrapper>();
        fieldtovalue=new Map<string,string>();
    }
    
    //This method is used to select the bank name and populate the required fields on screen for login 
    public void SelectBankName()
    {
       try{
       if(strBankSlugName != null && strBankSlugName <> '')
       {
            pepBankStatementRequest objRequest = new pepBankStatementRequest();
            pepBankInstitution objBankLoginDetail = objRequest.FetchInstitutionDetails(strBankSlugName);
            If(objBankLoginDetail != null && objBankLoginDetail.credentials != null && objBankLoginDetail.credentials.size()>0)
            {
                lstCredentials = objBankLoginDetail.credentials.clone();
                If(objBankLoginDetail.requires_preload == '1')
                {
                    captchaImgUrl = objRequest.PreloadFetchCaptcha(strBankSlugName);
                }
                system.debug('NRAC:::INSTITUTIONS:::'+objBankLoginDetail);
                
                for(integer i=0;i<lstCredentials.size();i++)
                {
                    lstWaterMarkText.add(lstCredentials[i].name);
                }
                intStepNumber = 2;
            }
            else
            {
             intStepNumber=4;
             PeputilityClass.CreateExceptionRecord('Bank Statement Bank Select not give proper response','Bank Select');
            }
          }else {
                    strErrorMsg = 'Please select bank';
                }
        }
        catch(Exception ex){
        string str='';
        str=ex.getmessage();
        PeputilityClass.createExceptionRecord(str,'Bank Statements(Bank Select Point)');
        intStepNumber=4;

        } 
        
           
    }
     
    //This method is used to log into the selected bank and desplay the list of associated account
    public void BankLogin()
    {
        try{
        strErrorMsg = '';
        for(integer i=0;i<lstCredentials.size();i++){
            lstUserCredentials.add(lstCredentials[i].name);
            lstUserQuearyType.add(lstCredentials[i].fieldID);
        }
       
        if(lstUserCredentials != null && lstUserQuearyType != null && lstUserQuearyType.size()>0 && lstUserCredentials.size()>0)
        {
            pepBankStatementRequest obj = new pepBankStatementRequest();
            bnk_stmt_success_failure = obj.loginRequest(strBankSlugName,lstUserCredentials,lstUserQuearyType, false);
            
            if(bnk_stmt_success_failure.success == true)
            {                        
                if(bnk_stmt_success_failure.ismfa==false){
                pepBankStmtAPIResponse.cls_accounts bnk_stmt_cls_account = new pepBankStmtAPIResponse.cls_accounts();
               // pepBankStmtAPIResponse bnk_stmt_response = new pepBankStmtAPIResponse();
               // bnk_stmt_response.accounts = bnk_stmt_success_failure.response.accounts;
                
                //system.debug('bnk_stmt_cls_account true==========='+bnk_stmt_cls_account);
                
                if(lstBankAccounts != null){
                    lstBankAccounts.clear();
                    intStepNumber = 3;
                }
                
                for(pepBankStmtAPIResponse.cls_accounts bnk_cls_account : bnk_stmt_success_failure.response.accounts)
                {                   
                    AllAccountsClass all_account = new AllAccountsClass();
                    all_account.accountHolder = bnk_cls_account.accountHolder;
                    all_account.name = bnk_cls_account.name;
                    all_account.id = bnk_cls_account.id;
                    all_account.available = bnk_cls_account.available;
                    all_account.balance = bnk_cls_account.balance;
                    all_account.bsb = bnk_cls_account.bsb;
                    all_account.accountNumber = bnk_cls_account.accountNumber;
                    all_account.chk_box = false;
                    
                    lstBankAccounts.add(all_account); 
                }
               system.debug('NRAC::::'+lstBankAccounts); 
              }
              if(bnk_stmt_success_failure.ismfa==True){
              
                 intStepNumber = 5;
              profiletitle=bnk_stmt_success_failure.responseProfile.mfa.title;
              usertoken=bnk_stmt_success_failure.responseProfile.user_token;
              System.debug('##########'+usertoken);
              if(bnk_stmt_success_failure.responseProfile.mfa.fields !=  null && bnk_stmt_success_failure.responseProfile.mfa.fields.size()>0){
               for(pepProfileHandler.cls_fields fld:bnk_stmt_success_failure.responseProfile.mfa.fields){
                  
                 if(fld.options != null)
                 pepprofilewrapper.add(new profilewrapper(fld,fld.options));
                 else
                  pepprofilewrapper.add(new profilewrapper(fld,null));
             
               }
             }
              }
                
            }else{
                 strErrorMsg = 'Please enter valid credentials';
              //strErrorMsg  = bnk_stmt_success_failure.Message;
                for(integer i=0;i<lstCredentials.size();i++){
                    lstCredentials[i].name = lstWaterMarkText[i];
                } 
            }
        }else{
                strErrorMsg = 'Please enter valid credentials';   
                for(integer i=0;i<lstCredentials.size();i++){
                    lstCredentials[i].name = lstWaterMarkText[i];
                }    
             }
        }
       Catch(Exception ex){
       String str='';
       str=ex.getmessage();
       PeputilityClass.createExceptionRecord(str,'Bank Statement');
       intStepNumber=4;
       
       }        
     }
    
    //This method is used to fetch bank statements for the selected accounts
    public pagereference FetchStatements()
    {
        try{
        string strSelectedAccounts = '';
        if(lstBankAccounts.size() > 0)
        {           
            //Adding selected account ids in strSelectedAccounts to fetch bank details
            for(AllAccountsClass all_account : lstBankAccounts)
            {
                if(all_account.chk_box == true)
                {
                    if(strSelectedAccounts == '')
                        strSelectedAccounts = all_account.id;
                    else
                        strSelectedAccounts = strSelectedAccounts + ',' + all_account.id;
                }
            }
          if(strSelectedAccounts != null && strSelectedAccounts <> '')
          {
            //TODO: Convert to dynamic
            if(lstUserCredentials != null && lstUserQuearyType != null && lstUserQuearyType.size()>0 && lstUserCredentials.size()>0)
            {
                pepBankStatementRequest obj = new pepBankStatementRequest();
                system.debug('@@@@@@@test'+bnk_stmt_success_failure);
                obj.statementRequest(bnk_stmt_success_failure,idApplication,false,strSelectedAccounts,strBankSlugName);
                intStepNumber = 4;
                Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
                myCookies = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
                pepUtilityClass.SaveContinueStatus(objApplication,'pepLoanSetupUploadedDocs') ;   
                 pageReference pagerf;
                 string redircetPageName= pages_config__c.getinstance('peploansetupuploadeddocs').Page_Label__c;     
                 pagerf = new pagereference('/'+redircetPageName);
                 pagerf.setCookies(new Cookie[]{myCookies }); 
                 pagerf.setRedirect(true);
                 return pagerf;
            }

          }else{
                strErrorMsg = 'Please select account(s)';
          }
        }
        return null;
        }
        Catch(Exception ex){
        String str='';
        str=ex.getmessage();
        Peputilityclass.CreateExceptionRecord(str,'Bank statement');
        intstepNumber=4;
        
        return null;
        }
    }
    
    //This is the Wrapper class for binding the account details on VF Page
    public class AllAccountsClass
    {
        public boolean chk_box {get; set;}
        public String accountHolder {get; set;}
        public String name {get; set;} 
        public String accountNumber {get; set;} 
        public String id {get; set;} 
        public String bsb {get; set;} 
        public String balance {get; set;}  
        public String available {get; set;}  
    }
    
    //This is the Wrapper class for binding the ERROR message
    public class ErrorMessage
    {
        public string error {set; get;} 
        public integer errorcode {set; get;}
        public string user_token {set; get;}
    }
   //For Go Back
   Public pagereference gobackmethod()
   {
     getCookieData();
     System.debug('go back');
     string redircetPageName= pages_config__c.getinstance('pepuploadfinancialdoc').Page_Label__c;    
     PageReference p = new pagereference('/'+redircetPageName);
     p.setRedirect(true);
     
     return p;
   } 
   //to redirect to next page
   public pagereference redirectToNextPage()
   {
         Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
         myCookies = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
         pepUtilityClass.SaveContinueStatus(objApplication,'pepLoanSetupUploadedDocs') ; 
         pageReference pagerf;
         string redircetPageName= pages_config__c.getinstance('peploansetupuploadeddocs').Page_Label__c;     
             
         pagerf = new pagereference('/'+redircetPageName);  
         pagerf.setCookies(new Cookie[]{myCookies }); 
         pagerf.setRedirect(true);
         return pagerf;
   } 
   
   public void getCookieData()
   {
        intStepNumber = 1;
        strBankName = ''; 
        strBankSlugName = '';
        strUserName = 'Card / Access Number';
        strPassword = 'Security Number';
        strErrorMsg = '';
        lstWaterMarkText = new list<string>();
        lstUserCredentials = new list<string>();
        lstUserQuearyType = new list<string>();
        // 1 : Username and Password
        // 2 : Username, Password and Captcha
        // 3 : Card number, Security Number, Internet Password and Issue Number
        
        lstBankAccounts = new list<AllAccountsClass>(); 
        lstCredentials = new List<pepBankInstitution.Credential>();
       
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
        
        if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
               idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));    
               objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));                  
               
        }
    }
    @RemoteAction
    public static List<pepBank_API_Details__c> AutoCompleteBanklList(string strFilter)
    {  
         system.debug('@@@test!@#'+strFilter);
        If(strFilter!=null && strFilter <> '')
        {
            List<pepBank_API_Details__c> lstBank = [select id,pepBank_Name__c,pepBank_Slug_Name__c,pepBank_Short_Name__c,pepImage_URL__c from pepBank_API_Details__c 
                                                    where pepBank_Name__c like: strFilter+'%' OR pepBank_Short_Name__c like: strFilter+'%'];
            return lstBank;
        }
        else 
           return new List<pepBank_API_Details__c>();
    }
    //MFA authentication
    public pagereference mfaAuthentication()
    {
        
        //Get Bankstmt Api from Custom setting
        pepBank_Statement_Credential__c objBankstmtCredential = pepBank_Statement_Credential__c.getValues('Credential');   
        String strEndpoint = objBankstmtCredential.pepEndPoint_Url__c;
        String strApiKey = objBankstmtCredential.pepX_API_KEY__c;
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(strEndpoint+'/mfa');
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json');
            req.setHeader('Accept-Language', 'en-US,en;q=0.8');
            req.setHeader('Accept-Encoding', 'gzip,deflate,sdch');
            req.setHeader('Content-Encoding', 'gzip'); 
            req.setHeader('Accept-Encoding', 'gzip');
            req.setHeader('Accept', '*/*');
            req.setHeader('X-API-KEY',strApiKey);
            req.setTimeout(120000);
            String strbody= createJsonBody();//'{"user_token": "'+UserToken+'","profile": "'+strProfileId+'"}';
            system.debug('======'+strbody);
            req.setbody(strBody);
            Httpresponse res=http.send(req);
            if(res.getstatuscode()==200){
            intstepnumber=3;
            String jsonreturned =res.getbody();
            system.debug('@@@@@'+jsonreturned);
            pepBankStmtAPIResponse bankstresponse=(pepBankStmtAPIResponse)System.JSON.deserialize(jsonreturned,pepBankStmtAPIResponse.Class);
             for(pepBankStmtAPIResponse.cls_accounts bnk_cls_account : bankstresponse.accounts)
                {                   
                    AllAccountsClass all_account = new AllAccountsClass();
                    all_account.accountHolder = bnk_cls_account.accountHolder;
                    all_account.name = bnk_cls_account.name;
                    all_account.id = bnk_cls_account.id;
                    all_account.available = bnk_cls_account.available;
                    all_account.balance = bnk_cls_account.balance;
                    all_account.bsb = bnk_cls_account.bsb;
                    all_account.accountNumber = bnk_cls_account.accountNumber;
                    all_account.chk_box = false;
                    
                    lstBankAccounts.add(all_account); 
                }
           }
           else{
           intstepnumber=4;
           }
     
    return null;
}
Private string createJsonBody(){


System.debug('weeeeeeeeeeeee'+userenteredname);
if((userenteredname == 'westpac' && strBankSlugName=='bank_of_mfa')|| (userenteredname == 'cba' && strBankSlugName=='bank_of_mfa') || (strBankSlugName=='cba' || strBankSlugName=='Westpac')){
System.debug('chatter'+Json.serialize(new JsonResponsecreator(usertoken,userenteredname=='westpac'?StrProfileid:strnetcode,'handling',userenteredname=='westpac'?True:False)));
return Json.serialize(new JsonResponsecreator(usertoken,(userenteredname == 'westpac' && strBankSlugName=='bank_of_mfa')||(strBankSlugName=='Westpac')?StrProfileid:strnetcode,'handling',(userenteredname == 'westpac' && strBankSlugName=='bank_of_mfa')||(strBankSlugName=='Westpac')?True:False));
}
if((userenteredname=='hsbc-device' && strBankSlugName=='bank_of_mfa') || (strBankSlugName=='hsbc') || (userenteredname=='hsbc-passwords' && strBankSlugName=='bank_of_mfa')){

system.debug('!!!!!!!!!!!!!!!'+fieldtovalue);
if((strBankSlugName=='hsbc' && loginselected=='passwords') || (userenteredname=='hsbc-passwords'&& strbankslugname=='bank_of_mfa')){
if(strBankSlugName=='hsbc')
return Json.serialize(new JsonResponsecreator(usertoken,strmemorableAnswer,Rccfield0,Rccfield1,rccfield2,rccfield3,rccfield4,rccfield5,rccfield6,rccfield7));
return Json.serialize(new JsonResponsecreatortestbank(usertoken,strmemorableAnswer,Rccfield0,Rccfield1,rccfield2,rccfield3,rccfield4,rccfield5,rccfield6,rccfield7));
}
return Json.serialize(new JsonResponsecreator(usertoken,strmemorableAnswer,strotpcredential));
}
if((userenteredname=='mystate' && strbankslugname=='bank_of_mfa') || strbankslugname=='mystate'){
return Json.serialize(new Jsonresponsecreator(usertoken,mystatecode));
}
return Json.serialize(new JsonResponsecreator());


}
Private Boolean runningInASandbox() {
  return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
}
Public class Profilewrapper{
    Public pepProfileHandler.cls_fields fields{get;set;}
    Public Map<string,string> profileIdtoName{get;set;}
    Public Profilewrapper(pepProfileHandler.cls_fields flds,Map<String,String> profileIdtoName){
    this.fields=flds;
    this.profileIdtoName=profileIdtoName;
    }
  }
  Public Class JsonResponsecreator{
  Public String user_token;
  Public String profile;
  Public string seq;
  Public string RCCfield0;
  Public string RCCfield1;
  Public string RCCfield2;
  Public string RCCfield3;
  Public string RCCfield4;
  Public string RCCfield5;
  Public string RCCfield6;
  Public string RCCfield7;
  Public string memorableAnswer;
  Public String idv_OtpCredential;
  Public string netcode;
  Public JsonResponsecreator(string usertoken,string Profile,string temp,Boolean callprofile){
  this.user_token=usertoken;
  if(callprofile==True)
  this.Profile=Profile;
  else
  this.netcode=Profile;
 }
  Public JsonResponsecreator(String user_token,string memorableAnswer,string idv_OtpCredential){
  this.user_token=user_token;
  this.memorableAnswer=memorableAnswer;
  this.idv_OtpCredential=idv_OtpCredential;
  }
  Public JsonResponsecreator(String user_token,string memorableAnswer,string field0,string field1,string field2,string field3,string field4,string field5,string field6,string field7){
  this.user_token=user_token;
  this.memorableAnswer=memorableAnswer;
  this.Rccfield0=field0;
  this.Rccfield1=field1;
  this.Rccfield2=field2;
  this.Rccfield3=field3;
  this.Rccfield4=field4;
  this.Rccfield5=field5;
  this.Rccfield6=field6;
  this.Rccfield7=field7;
  
  }
  Public JsonResponsecreator(String usertoken,string seq){
  this.user_token=usertoken;
  this.seq=seq;
  }
  Public JsonResponsecreator(){
  }
 }
  Public Class JsonResponsecreatortestbank{
  Public String user_token;
  Public String profile;
  Public string RCCField0;
  Public string RCCField1;
  Public string RCCField2;
  Public string RCCField3;
  Public string RCCField4;
  Public string RCCField5;
  Public string RCCField6;
  Public string RCCField7;
  Public string memorableAnswer;
  Public String idv_OtpCredential;
  Public string netcode;

  Public JsonResponsecreatortestbank(String user_token,string memorableAnswer,string field0,string field1,string field2,string field3,string field4,string field5,string field6,string field7){
  this.user_token=user_token;
  this.memorableAnswer=memorableAnswer;
  this.RCCField0=field0!=''?field0:null;
  this.RCCField1=field1!=''?field1:null;
  this.RCCField2=field2!=''?field2:null;
  this.RCCField3=field3!=''?field3:null;
  this.RCCField4=field4!=''?field4:null;
  this.RCCField5=field5!=''?field5:null;
  this.RCCField6=field6!=''?field6:null;
  this.RCCField7=field7!=''?field7:null;
  
  }
  
 }
 Public pagereference fillMap(){
 fieldtoValue.put(fieldname,fieldvalue);
 return null;
}
}
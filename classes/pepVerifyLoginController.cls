/**
 *This Class is a controller of 'pepVerifyLogin' page. 
 *It verifies Users, Generate and send OTP for users
 *And lock Account if user verification is faild multiple times
**/

public class pepVerifyLoginController {
    
    public String Newpassword { get; set; }
    public String Changepassword { get; set; }
    public boolean boolEnable { get; set; }
    public boolean boolChangePassword { get; set; }
    public boolean boolAccountLocked{ get; set; }
    public boolean boolOTPDuration { get; set; }    
    public String password { get; set; }
    public String strPostCode { get; set; }
    public string strDOB { get; set; }
    public List<pepCmsQuestion__c> lstQuestion{get;set;} 
    public List<wrappperQuestion> lstWrapperQuestion{get;set;}
    public list<Account> lstAccount{get;set;}
    public list<Residential_Address__c> lstResidentialAddress{get;set;}
    public list<Second_OTP_Template__c> LstOTPTemplate;
    public list<DashboardProfileId__c> lstDashboardProfileId{get;set;}
    public Account objAccount;
    public list<String> lstEmailAddress;
    public String PIN;
    public date dt;
    public string AccountId;
    public boolean boolWrongDOB{get;set;}
    public boolean boolWrongPostCode{get;set;}
    public String objAccountId {get;set;}
    public string encryptedContractId;
    public string loanAccountId;
    public list< loan__Loan_Account__c > loanContractList;
    public list<Account> lstAcc{get;set;}
    public boolean boolRenderForm{get;set;}
    public integer intWrongOTP;
    public List<pepCmsQuestion__c> lstQuestions{get;set;}
    public Account objAccount2;
    public String PageName{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    Public string page_Name{get;set;}
    Public String accountidHolder; 
    public clcommon__Party__c objParty;
    public String strObjectName;
    
    public pepVerifyLoginController()
    {
        lstQuestion = new List<pepCmsQuestion__c>();
        lstWrapperQuestion = new List<wrappperQuestion>();
        lstAccount = new list<Account> ();
        lstAcc = new list <Account> ();
        objAccount = new Account();
        objAccount2 = new Account();
        pageName=ApexPages.currentPage().getUrl();
        pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        page_Name=pageName;
        Page_Label=pages_config__c.getValues(pageName.toLowerCase()).Page_Label__c;//Added by KG
        encryptedContractId = ApexPages.currentPage().getParameters().get('id');
        
        if(encryptedContractId != null)
        {
            encryptedContractId = encryptedContractId.replace(' ','+');
            encryptedContractId.trim();
            loanAccountId = pepEncryptDecryptData.DecryptData(encryptedContractId);
            cookie loancontractid = new cookie('loancontractid',loanAccountId,null,-1,false);
            ApexPages.currentPage().setcookies(new cookie[]{loancontractid});       
        }
        lstEmailAddress = new list<String> ();
        lstResidentialAddress = new list<Residential_Address__c>();
        LstOTPTemplate = Second_OTP_Template__c.getAll().Values(); 
        LstDashboardProfileId = DashboardProfileId__c.getAll().Values(); 
        boolEnable = true;
        intWrongOTP = 0;
        boolOTPDuration = true;
        boolAccountLocked = false;
        boolChangePassword = true;
        boolWrongDOB = true;
        boolWrongPostCode = true;
        boolRenderForm = true;
        
        //added by Rishabh (for PAF)
        if(string.isNotBlank(loanAccountId))
        {
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(loanAccountId); //Find the Id in url(it is of Cl contract or Party)
            if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
            {
                loanContractList = pepUtilityClass.getLoanContract(loanAccountId);   // fetch contract values from utility class
                objAccountId = loanContractList[0].loan__Account__c;                // fetch account
                cookie accountId = new cookie('accountId',objAccountId,null,-1,false);  // set account id in cooikes
                ApexPages.currentPage().setcookies(new cookie[]{accountId}); 
            }
            else if(string.isnotBlank(strObjectName) && strObjectName=='clcommon__Party__c')
            {
                objParty =[select id,clcommon__Account__c,collect__CL_Contract__c,ScCollection_Customer_Birth_Date__c,ScCollection_Customer_Post_Code__c from clcommon__Party__c where id=:loanAccountId];
                objAccountId  = objParty.clcommon__Account__c;                         // fetch account from party
                cookie accountId = new cookie('accountId',objAccountId,null,-1,false);   // set account id in cooikies
                ApexPages.currentPage().setcookies(new cookie[]{accountId}); 
            }
            
        }
        // End here 
        
        //Added by : Sushant Kumar, Date : 6/11/2017
        //if this is a SecondOtp page and account id is not available in cookies look for account id in parameters
        if(Page_Label == 'SecondOtp' && !(ApexPages.currentPage().getcookies().get('accountId') != null && String.isNotBlank(ApexPages.currentPage().getcookies().get('accountId').getvalue()))) {
            String accId = ApexPages.currentPage().getParameters().get('accId');
            if(String.isNotBlank(accId)) {
                
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('accountId', accId, null, -1, false)});
                
                //fetching loan contract id with help of accid, only for PAF records
                String loanContractId ='';
                List<clcommon__Party__c> parties = [select Id, Name from clcommon__Party__c where clcommon__Account__c=:accId AND collect__CL_Contract__r.collect__Source_System__r.Name='PAF'];
                if(!parties.isEmpty()) {
                    loanContractId = parties[0].Id;
                    ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('loancontractid', loanContractId, null, -1, false)});
                }
                
            }
        }
         
        if(ApexPages.currentPage().getcookies().get('accountId') != null && ApexPages.currentPage().getcookies().get('accountId').getvalue() != null && ApexPages.currentPage().getcookies().get('accountId').getvalue() !=''){  
            accountidHolder=ApexPages.currentPage().getcookies().get('accountId').getvalue();
        }
        loadCmsData();
    }
    
    //Method is created for Loading CMS data of 'Set Password' page
    public void loadCmsData()
    {
        lstQuestions = [select id,pepLabelPriorQuestion__c,pepType__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c
                        from pepCmsQuestion__c  where pepPage__r.pepPageName__c ='Set Password' and pepSection__r.pepSectionUniqueName__c='Set Password Section 3' and pepType__c='Text' order by pepSequence__c];
    }
    
    //This method redirects user to Login page if Portal User is created or in case account is locked
    public pagereference RedirectToLoginPage()
    {
        
        //Modified By : Sushant Kumar (30/08/2017)
        //Added code for Technical Exception handling
        try {
            
            if(objAccountId != null)
            {
                lstAcc = [Select id, Is_Portal_User_Created__c, Is_Account_Locked__c from Account where id=: objAccountId];
                
                if(lstAcc != null && (!lstAcc.isEmpty()))
                {
                    if((lstAcc[0].Is_Portal_User_Created__c == true) || (lstAcc[0].Is_Account_Locked__c == true))
                    {
                        string redircetPageName= pages_config__c.getinstance('peploginpage').Page_Label__c;
                        Pagereference objNextPage = new pageReference('/'+redircetPageName);
                        objNextPage.setRedirect(true);
                        return objNextPage;              
                    }
                    else
                    {
                        if(ApexPages.currentPage().getcookies().get('accountId') != null && ApexPages.currentPage().getcookies().get('accountId').getvalue() != null && ApexPages.currentPage().getcookies().get('accountId').getvalue() != '')
                            loadCMSContent();
                        else
                            return new Pagereference(''+Label.cookieRedirect); 
                    }
                }
            } 
            else
            {
                return new Pagereference(''+Label.cookieRedirect); 
            }
            
            return null;
        }
        catch(Exception ex) {
            return pepUtilityClass.handlePageException(ex, getCurrentStateOfClass());
        }
    }
    
    // This method verifies DOB and post code through Account and On the basis of result generate OTP and send it
    public pagereference verifyMe()
    {
        //Modified By : Sushant Kumar (30/08/2017)
        //Added code for Technical Exception handling
        try {
            
            if(strDOB != null && strDOB != '')
            {        
                list<String> lstDOB = strDOB.split('/');
                dt = date.newInstance(Integer.valueOf(lstDOB[2]),Integer.valueOf(lstDOB[1]),Integer.valueOf(lstDOB[0]));
            }
            
            if(strDOB != null && strPostCode  != null && strPostCode != '' && strDOB!='' && encryptedContractId != '')
            {
                lstAccount = [Select id,FirstName,LastName,PersonEmail,PersonMobilePhone,collect__External_ID__c,personmailingpostalcode,PersonContactId,RecordTypeId,OwnerId,Phone,PersonBirthDate,Second_OTP__c,PepSecond_OTP__c,Second_OTP_Generation_Time__c from account where id=: accountidHolder limit 1];                   
                
                if(lstAccount != null && (!lstAccount.isEmpty()))
                {
                    AccountId = lstAccount[0].id;
                    String pafExternalId ='';
                    if(string.isNotBlank(lstAccount[0].collect__External_ID__c))
                        pafExternalId = lstAccount[0].collect__External_ID__c;
                    
                    if(strObjectName=='loan__Loan_Account__c')  
                    {
                        lstResidentialAddress = [select id,PostCode__c from Residential_Address__c where Contact__c =: lstAccount[0].PersonContactId and PostCode__c =: strPostCode limit 1];

                        if(dt != lstAccount[0].PersonBirthDate && ((lstResidentialAddress.isEmpty() && String.isBlank(pafExternalId)) || (String.isNotBlank(pafExternalId) && lstAccount[0].personmailingpostalcode!=strPostCode)))
                        {
                            boolWrongDOB = false;
                            boolWrongPostCode = false;
                            boolEnable = true;
                            boolOTPDuration = true;
                            boolChangePassword = true;
                        }
                        
                        if(dt != lstAccount[0].PersonBirthDate && (((!lstResidentialAddress.isEmpty()) && String.isBlank(pafExternalId)) || (String.isNotBlank(pafExternalId) && lstAccount[0].personmailingpostalcode==strPostCode)))
                        {
                            boolWrongDOB = false;
                            boolWrongPostCode = true;
                            boolEnable = true;
                            boolOTPDuration = true;
                            boolChangePassword = true;
                        }
                        
                        if(((lstResidentialAddress.isEmpty() && String.isBlank(pafExternalId)) || (String.isNotBlank(pafExternalId) && lstAccount[0].personmailingpostalcode!=strPostCode)) && (dt == lstAccount[0].PersonBirthDate))
                        {
                            boolWrongPostCode = false;
                            boolWrongDOB = true;
                            boolEnable = true;
                            boolOTPDuration = true;
                            boolChangePassword = true;
                        }
                        
                        else if(((lstResidentialAddress != null && (!lstResidentialAddress.isEmpty()) && String.isBlank(pafExternalId)) || (String.isNotBlank(pafExternalId) && lstAccount[0].personmailingpostalcode==strPostCode)) && ((dt == lstAccount[0].PersonBirthDate)))
                        {
                            
                            generateOTP();
                            Map<string, string> mapnew = new Map<string, string>();
                            string currentDate = string.valueOf(dateTime.now());
                            mapnew.put('pep_Pre_logged_Electronic_Consent__c',currentDate);
                            LoanActions loanAc = new LoanActions();
                            loan__Loan_Account__c loanAcc = loanAc.updateLoanAccount(loanAccountId,mapnew); 
                            
                            Cookie accountId = new cookie('accountId',accountidholder,null,-1,false);
                            string redircetPageName= pages_config__c.getinstance('pepsecondotp').Page_Label__c;
                            Pagereference objNextPage = new pageReference('/'+redircetPageName);
                            objNextPage.setcookies(new cookie[]{accountId});
                            objNextPage.setRedirect(false);
                            return objNextPage;
                            
                        }
                    }   
                    
                    // added by Rishabh (for PAF)
                    
                    else if(strObjectName=='clcommon__Party__c')    
                    {
                        // if entered dob is not equal to actual dob and entered postal code is not equal to entered postal code
                        
                        if(dt != objParty.ScCollection_Customer_Birth_Date__c && (strPostCode!=objParty.ScCollection_Customer_Post_Code__c))
                        {
                            boolWrongDOB = false;         
                            boolWrongPostCode = false;
                            boolEnable = true;
                            boolOTPDuration = true;
                            boolChangePassword = true;
                        }
                        // if enetred dob is not equal to actual dob and entered postal code is equal to entered postal code
                        
                        if(dt != objParty.ScCollection_Customer_Birth_Date__c && (strPostCode==objParty.ScCollection_Customer_Post_Code__c))
                        {
                            boolWrongDOB = false;
                            boolWrongPostCode = true;
                            boolEnable = true;
                            boolOTPDuration = true;
                            boolChangePassword = true;
                        }
                        // if entered dob is  equal to actual dob and entered postal code is not equal to entered postal code  
                        
                        if((strPostCode!=objParty.ScCollection_Customer_Post_Code__c) && (dt == objParty.ScCollection_Customer_Birth_Date__c))
                        {
                            boolWrongPostCode = false;
                            boolWrongDOB = true;
                            boolEnable = true;
                            boolOTPDuration = true;
                            boolChangePassword = true;
                        }
                        // if entered dob is  equal to actual dob and entered postal code is  equal to entered postal code    
                        
                        else if((strPostCode==objParty.ScCollection_Customer_Post_Code__c) && (dt == objParty.ScCollection_Customer_Birth_Date__c))
                        {
                            
                            generateOTP();
                            clcommon__Party__c partyObj = new clcommon__Party__c();
                            partyObj.id = objParty.id;
                            partyObj.pafss_Pre_logged_Electronic_Consent__c = dateTime.Now();
                            update partyObj;
                            Cookie accountId = new cookie('accountId',accountidholder,null,-1,false);
                            string redircetPageName= pages_config__c.getinstance('pepsecondotp').Page_Label__c;
                            Pagereference objNextPage = new pageReference('/'+redircetPageName);
                            objNextPage.setcookies(new cookie[]{accountId});
                            objNextPage.setRedirect(false);
                            return objNextPage;
                            
                        }
                    }                   
                    // End here      
                }
            }
            
            return null;            
        }
        catch(Exception ex) {
            
            return pepUtilityClass.handlePageException(ex, getCurrentStateOfClass());
        }
    }
    
    //This method is created for generating OTP
    public void generateOTP()
    {    
        // Modified By : Sushant Kumar (30/08/2017)
        // removed unnecessary Query on Email Templates
        
        //Modified by : Sushant Kumar
        //Purpose : To add email id to PersonEmail field from page url 'sendTo' parameter, if PersonEmail is empty or null
        
        String encSendToEmail = ApexPages.currentPage().getParameters().get('sendTo');
        String sendToEmail = '';
        if(String.isNotBlank(encSendToEmail)) {
            encSendToEmail = encSendToEmail.replace(' ', '+');
            encSendToEmail.trim();
            sendToEmail = pepEncryptDecryptData.DecryptData(encSendToEmail);
        }
        
        PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
        objAccount = [Select id, FirstName, LastName, PersonEmail, PersonMobilePhone, PersonContactId, RecordTypeId,
                        OwnerId, Phone, PersonBirthDate, Second_OTP__c, PepSecond_OTP__c, Second_OTP_Generation_Time__c, pepOTP_Email__c from account 
                        where id=:accountidHolder limit 1];
        
        if((objAccount.PersonEmail == null || objAccount.PersonEmail == '') && encSendToEmail !=null && encSendToEmail != '' ) {
            objAccount.PersonEmail = sendToEmail;
            objAccount.pepOTP_Email__c = sendToEmail;
        }
        
        if(objAccount.PersonEmail != null)
        {
            if(PIN != '')
            {
                
                objAccount2.id = objAccount.id;
                objAccount2.Second_OTP__c = PIN;
                objAccount2.PepSecond_OTP__c = PIN;
                objAccount2.Second_OTP_Generation_Time__c = System.now();
                objaccount2.Personemail = objaccount.Personemail;
                objaccount2.pafss_Account_Locked_Counter__c = 0;
                update objAccount2;
                
            }
        }
    }
    
    //This method Loads CMS content (Questions) for 'verify Login' page and section 'Verify Login Section 3'
    public void loadCMSContent()
    { 
        for(pepCmsQuestion__c objQuestion:[select id,pepLabelPriorQuestion__c,pepType__c,pepIsRequired__c,pepKeyPressNumbersOnly__c,pepLabelAfterQuestion__c,pepGenericErrorMessage__c,pepSequence__c,pepFieldApiName__c,pepSObjectApiName__c,Is_Date_to_Birth__c
                                           from pepCmsQuestion__c  where pepPage__r.pepPageName__c = 'Verify Login' and pepSection__r.pepSectionUniqueName__c = 'Verify Login Section 3' order by pepSequence__c])
        {  
            lstWrapperQuestion.add(new wrappperQuestion(objQuestion));
        }
    }
    
    public class wrappperQuestion
    {
        public pepCmsQuestion__c objCmsQuestion {get; set;} //main question   
        public wrappperQuestion(pepCmsQuestion__c objQuestion)
        {
            objCmsQuestion = objQuestion;
            
        }
    }
    
    //This method is created for resending OTP (second time)
    public Pagereference ResendNow() {
       
        //Modified By : Sushant Kumar (30/08/2017)
        //Added technical Exception handling
        try {
            
            boolEnable = true;
            boolOTPDuration = true;
            boolChangePassword = true;
            generateOTP();
            
            cookie accountId = new cookie('accountId',accountidholder,null,-1,false);
            Pagereference pref = new Pagereference('/'+Pages_config__c.getinstance('pepsecondotp').Page_Label__c).setRedirect(True);
            if(accountidholder != null){
                pref.setcookies(new cookie[]{accountId});
            }
            return pref;
        }
        catch(Exception ex) {
            return pepUtilityClass.handlePageException(ex, getCurrentStateOfClass());
        }
    }
    
    
    // This method is created for verifying OTP. If correct OTP is entered This method redirect for changing password
    // If Entered OTP is incorrect for 2 times then it lockes the user Account
    public PageReference setOTP() 
    {
        //Modified By : Sushant Kumar (30/8/2017)
        //added exception handling for technical exceptions
        try {
            
            Id idAccount;
            if(accountidholder  != null)  
                idAccount = accountidholder;  
            if(string.isNotBlank(idAccount))
                objAccount2=[select id,Second_OTP_Generation_Time__c,Is_Account_Locked__c ,pafss_Account_Locked_Counter__c,Second_OTP__c from Account where id=:idAccount];
            
            if(objAccount2.Is_Account_Locked__c==false)
            {    
                if(string.isBlank(password))
                    return null;   
                if(objAccount2.Second_OTP_Generation_Time__c != null)
                {
                    Integer Minutes = math.mod(Integer.valueOf(((System.now()).getTime() - (objAccount2.Second_OTP_Generation_Time__c).getTime())/(1000*60)),60);
                    LstOTPTemplate = Second_OTP_Template__c.getAll().Values();
                    Integer OTPDuration = Integer.valueOf(LstOTPTemplate[0].OTP_Duration__c);
                    
                    if(minutes <= OTPDuration)
                    {
                        
                        if(objAccount2.Second_OTP__c != null )
                        {
                            if(objAccount2.Second_OTP__c == password.trim())
                            {
                                string redircetPageName= pages_config__c.getinstance('pepsetpassword').Page_Label__c;
                                Pagereference objNextPage = new pageReference('/'+redircetPageName);
                                Cookie accountId= new cookie('accountId',idAccount,null,-1,false);
                                objNextPage.setcookies(new cookie[]{accountId});
                                objNextPage.setRedirect(false);
                                return objNextPage;
                            }
                            else
                            {
                                Account objAccountCounter = new Account();
                                objAccountCounter = objAccount2;
                                objAccountCounter.pafss_Account_Locked_Counter__c = integer.valueof(objAccount2.pafss_Account_Locked_Counter__c)+1;
                                update objAccountCounter;
                                boolEnable = false;
                                boolOTPDuration = true;
                                boolChangePassword = true;
                                
                                account accountLocker = [select id,pafss_Account_Locked_Counter__c from Account where id=:idAccount];
                                if(accountLocker.pafss_Account_Locked_Counter__c== 2)
                                { 
                                    Account objAccountLocked = new Account();
                                    objAccountLocked = objAccount2;
                                    objAccountLocked.Is_Account_Locked__c = true;
                                    objAccountLocked.pafss_Account_Locked_Counter__c = 0;
                                    update objAccountLocked;
                                    boolAccountLocked = true;
                                    boolEnable = true;
                                }  
                            }
                        }
                    }
                    
                    else
                    {
                        boolOTPDuration = false;
                        boolEnable = true;
                        boolChangePassword= true;
                    }
                }
            }
            else
            {
                boolEnable = true;
                boolOTPDuration = true;
                boolAccountLocked = true;
            }  
            return null;

        }
        catch(Exception ex) {
            return pepUtilityClass.handlePageException(ex, getCurrentStateOfClass());
        }
        
    }
    
    // This method is created for password change and creation of External users
    public PageReference ChangePassword() {
        //Modified By : Sushant Kumar(30/08/2017)
        // Added Exception handling for technical exceptions
        try {
            
                Id idAccount;
                if(accountidholder!=null)  
                    idAccount =accountidholder;
                if(string.isNotBlank(idAccount))
                    objAccount2=[select id,FirstName,LastName,PersonEmail,Second_OTP_Generation_Time__c,Second_OTP__c from Account where id=:idAccount];
                if(objAccount2 != null)
                {
                    if(Changepassword == Newpassword)
                    {
                        if(ApexPages.currentPage().getcookies().get('loancontractid') != null && ApexPages.currentPage().getcookies().get('loancontractid').getvalue()!='')
                            loanAccountId = ApexPages.currentPage().getcookies().get('loancontractid').getvalue();
                        if(string.isnotblank(loanAccountId))
                        {       
                            User objUser = new User();
                            Profile objProfile = new Profile();
                            String strProfile = LstDashboardProfileId[0].Name;
                            objProfile = [Select id from Profile where id=: strProfile limit 1];
                            
                            // added by Rishabh (for PAF)
                            
                            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(loanAccountId);  //Find the Id in url(it is of Cl contract or Party)
                            
                            if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
                            {
                                loanContractList = pepUtilityClass.getLoanContract(ApexPages.currentPage().getcookies().get('loancontractid').getvalue());
                                objUser.Username = loanContractList[0].pepUser_Name__c;   // fetch userName from CL Contract
                            }
                            else if(string.isnotBlank(strObjectName) && strObjectName=='clcommon__Party__c')
                            {
                                clcommon__Party__c objParty =[select id,ScCollection_User_Name__c from clcommon__Party__c where id=:loanAccountId];
                                objUser.Username = objParty.ScCollection_User_Name__c;        // fetch userName from party
                            }           
                            
                            // End here
                            
                            objUser.FirstName = objAccount2.FirstName;
                            objUser.LastName = objAccount2.LastName;
                            if(objAccount2.FirstName == null)
                                objAccount2.FirstName ='';
                            objUser.Email = objAccount2.PersonEmail;
                            if(!Test.isRunningTest())
                                objUser.ProfileId = objProfile.id;
                            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
                            objUser.TimeZoneSidKey = 'Australia/Sydney';  
                            
                            String pwdd = Changepassword;
                            String userId;
                            
                            try{
                                userId = Site.createExternalUser(objUser,objAccount2.id,pwdd);
                            } catch(Site.ExternalUserCreateException ex)
                            {
                                return pepUtilityClass.handlePageException(ex, getCurrentStateOfClass());
                            }
                    
                            if(string.isNotBlank(idAccount) && userId != null)
                                updateAccount(idAccount);
                            
                            if(accountidholder != null){
                                cookie accountId= new cookie('accountId','',null,0,false);
                                ApexPages.currentPage().setcookies(new cookie[]{accountId});
                            }  
                            if(ApexPages.currentPage().getcookies().get('loancontractid') != null && ApexPages.currentPage().getcookies().get('loancontractid').getvalue()!='' ){
                                cookie loancontractid= new cookie('loancontractid','',null,0,false);
                                ApexPages.currentPage().setcookies(new cookie[]{loancontractid});
                            }
                            string redircetPageName= pages_config__c.getinstance('peploginpage').Page_Label__c;
                            Pagereference objNextPage = new pageReference(Label.LoginURL+redircetPageName);
                            objNextPage.setRedirect(true);
                            return objNextPage;
                        }      
                    }
                }
                
                else
                {
                    boolChangePassword = false;
                    boolOTPDuration = true;
                    boolEnable = true;
                }
                return null;

        }
        catch(Exception ex) {
            return pepUtilityClass.handlePageException(ex, getCurrentStateOfClass());
        }
        
    }
    
    //This method update an account when portal user is created
    @future
    public static void updateAccount(id AccountId) {
        
        //Modified By : Sushant Kumar (30/08/2017)
        //Removed unnecessary variables 
        list<Account> lstAccount = new list<Account>();
        lstAccount = [Select id,Is_Portal_User_Created__c from Account where id=: AccountId limit 1];
        
        if(lstAccount != null && (!lstAccount.isEmpty()))
        {
            for(Account objAcc : lstAccount)
            {
                objAcc.Is_Portal_User_Created__c = true;
            }
            update lstAccount;
        }
        
    }
    
    // This method checks for cookies on pepVerifyLogin page. If cookies found return to the same page
    //other wise redirects to 'GenericRedirection' page
    Public Pagereference checkcookie(){
        
        //Modified By : Sushant Kumar (30/08/2017)
        //Added exception handling for Technical Exceptions
        try {
            
            if(ApexPages.currentPage().getcookies().get('accountId') != null 
                && ApexPages.currentPage().getcookies().get('accountId').getvalue() != null 
                && ApexPages.currentPage().getcookies().get('accountId').getvalue() != '' 
                && ApexPages.currentPage().getcookies().get('loancontractid')!= null 
                && ApexPages.currentPage().getcookies().get('loancontractid').getvalue()!= '')
                
                    return null;
            return new Pagereference(''+Label.CookieRedirect);
        }
        catch(Exception ex) {
             return pepUtilityClass.handlePageException(ex, getCurrentStateOfClass());
        }
    }
    
    /**
     * @Created By : Sushant Kumar
     * @Description : This method is created for recording current status of the class
     **/
    @testVisible
    private String getCurrentStateOfClass() {
        
        String controllerStateStr = 'pageName : '+pageName+'\naccountid : '+accountidHolder
            + '\nloanAccountId (loancontractid id of cookie): '+loanAccountId +'\nstrObjectName : '+strObjectName + '\n';
        return controllerStateStr;
    }
}
@isTest

public class pepCommonTrackerController {

    public static Account objAccount1; 
    public static Account objBusinessAcc;
    public static Contact objContact;
    public static User objUser;
    public static Residential_Address__c residentialAddress;
    private static Profile p ;
    private static UserRole portalRole1;
    private static user objUser1;
    private static Account objAcc;
    private static Contact objContact1;
    private static loan__Loan_Account__c objLoanAcc;
    private static List<loan__Loan_Account__c> lstLoanAcount;
    
    //Creating person Account
    public static Account createAccount()
    {
        objAccount1= new Account();
        objAccount1.LastName = 'Last';
        objAccount1.FirstName ='First';
        objAccount1.PersonEmail ='test@email.com';
        objAccount1.PersonBirthDate = System.Today()-665;
        objAccount1.PersonMobilePhone = '0434567890';
        objAccount1.RecordTypeid=[Select id from RecordType where SobjectType='Account' and IsPersonType=True limit 1].id;
        insert objAccount1;
        User thisUser = [select Id from User where Profile.Name='System Administrator' and isActive=true and userroleid != null order by createdDate ASC Limit 1];
        objAccount1.ownerid=thisUser.id;
        update objAccount1;
        return objAccount1;
    }
    
    //create Residential Address
    
    public static Residential_Address__c createResidential()
    {
        residentialAddress = new Residential_Address__c();
        residentialAddress.Address__c = 'testArea';
        residentialAddress.Current_Address__c = true;
        insert residentialAddress;
        return residentialAddress;
    }
    
    //Create Busines Account
    public static Account CreateBusinessAcc()
    {
        objBusinessAcc = new Account();
        objBusinessAcc.Name = 'Test business';
        insert objBusinessAcc;
        return objBusinessAcc;
    }
   
    //create Contact
    public static Contact createContact()
    {
        CreateBusinessAcc();
        //Account acc = createAccount();
        objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.Lastname = 'test';
        //objContact.AccountId = acc.id;
        objContact.AccountId = objBusinessAcc.Id;
        objContact.Email ='test@test.com';
        insert objContact;
        User thisUser = [select Id from User where Profile.Name='System Administrator' and isActive=true and userroleid != null order by createdDate ASC Limit 1];
        contact con1 = new contact (id=objContact.id,ownerid=thisUser.id);
        update con1;
        
        return con1;
   }
   
   //create user
   public static User createuser()
   { 
   
       createAccount();
       createContact();
   
       Profile profileid  = [SELECT Id FROM Profile WHERE Name='Custom Customer Community Login user'];
       UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
   
        objUser = new User();
        objUser.email='CA-Test@gmail.com'; 
        objUser.profileid = profileid.id;   
        objUser.UserName='test-user@fakeemail.com';
        //objUser.ContactId = pepcommontrackercontroller.createaccount().PersonContactid;
         
        objUser.ContactId=[Select id from Contact where Accountid=:createAccount().id].id;
        objUser.alias='tuser1';
        objUser.CommunityNickName='tuser1'; 
        objUser.TimeZoneSidKey='America/New_York'; 
        objUser.LocaleSidKey='en_US'; 
        objUser.EmailEncodingKey='ISO-8859-1'; 
        objUser.LanguageLocaleKey='en_US';
        objUser.FirstName = 'Sunny';
        objUser.LastName = 'Sharma' ;
        objUser.Phone='8989898989';
        objUser.MobilePhone='9889823456';
        objUser.IsActive = true;
        insert objUser; 
       /* String userId=Site.createExternalUser(objAccount1,objAccount1.id);*/
        system.debug('User++++++ '+objUser); 
        return objUser;
   }




//Method For Creating Page.

public static pepCmsPage__c createPage(String pageName){
pepCmsPage__c objCmsPage = new pepCmsPage__c(pepPageName__c = pageName);
insert objCmsPage;
return objCmsPage;
}

//Method for Creating Section.
public static pepCmsSection__c createSection(pepCmsPage__c objCmsPage){
pepCmsSection__c objCmsSection = new pepCmsSection__c();
objCmsSection.pepPage__c = objCmsPage.id;
objCmsSection.pepSequence__c = 1;
//objCmsSection.pepSectionUniqueName__c = 'abc';
insert objCmsSection;
return objCmsSection;
} 
public static pepCmsSection__c createSection1(pepCmsPage__c objCmsPage){
pepCmsSection__c objCmsSection1 = new pepCmsSection__c();
objCmsSection1.pepPage__c = objCmsPage.id;
objCmsSection1.pepSequence__c = 10;
objCmsSection1.pepSectionUniqueName__c = 'Household'; // DONT make it Test Household.
insert objCmsSection1;    
return objCmsSection1;
}

    
//Method for Creating Question which has noo parent Question and no parent Answer.

public static pepCmsQuestion__c createCmsQuestion(pepCmsPage__c objCmsPage,pepCmsSection__c objCmsSection ){
pepCmsQuestion__c objCmsQuestion = new pepCmsQuestion__c();
objCmsQuestion.pepSection__c = objCmsSection.id;
objCmsQuestion.pepPage__c=objCmsPage.id;
objCmsQuestion.Is_Date_to_Birth__c = true; 
objCmsQuestion.pepType__c = 'Picklist'; 
objCmsQuestion.pepFieldApiName__c='genesis__CL_Purpose__c';
objCmsQuestion.pepSequence__c=30; 
objCmsQuestion.pepSObjectApiName__c='Expense_and_Debt__c';
//objCmsQuestion.pepFieldApiName__c='Expense_Debt_Value__c';
insert objCmsQuestion;
return objCmsQuestion;
}



//Method for Creating Answer.

public static pepCmsAnswer__c createCmsAnswer(pepCmsQuestion__c objCmsQuestion ){
pepCmsAnswer__c objCmsAnswer = new pepCmsAnswer__c ();
objCmsAnswer.Name='Test Answer';
objCmsAnswer.pepCmsQuestion__c=objCmsQuestion.id;
objCmsAnswer.pepActualValue__c='test value';
objCmsAnswer.pepDisplayText__c='This is Display';
objCmsAnswer.pepSequence__c=1;
insert objCmsAnswer ;
return objCmsAnswer;
}

public static pepCmsAnswer__c createCmsAnswer1(pepCmsQuestion__c objCmsQuestion ){
pepCmsAnswer__c objCmsAnswer1 = new pepCmsAnswer__c ();
objCmsAnswer1.Name='Test Answer1';
objCmsAnswer1.pepCmsQuestion__c=objCmsQuestion.id;
objCmsAnswer1.pepActualValue__c='test value1';
objCmsAnswer1.pepDisplayText__c='This is Display1';
objCmsAnswer1.pepSequence__c=2;
insert objCmsAnswer1 ;
return objCmsAnswer1;
}

//Method for Creating Question which has parent Question.

public static pepCmsQuestion__c createCmsChildQuestion(pepCmsPage__c objCmsPage ,pepCmsSection__c objCmsSection,pepCmsQuestion__c parentQuestion){
pepCmsQuestion__c objCmsChildQuestion = new pepCmsQuestion__c();
objCmsChildQuestion.pepPage__c=objCmsPage.id;
objCmsChildQuestion.pepSection__c = objCmsSection.id;
objCmsChildQuestion.pepQuestion__c=parentQuestion.id;
objCmsChildQuestion.Is_Date_to_Birth__c = true; 
objCmsChildQuestion.pepType__c = 'Date';
objCmsChildQuestion.pepSequence__c=2; 
insert objCmsChildQuestion ;
return objCmsChildQuestion ;
}

//Method for Creating Question which has parent Answer.

public static pepCmsQuestion__c createCmsChildQuestionOfAnswer(pepCmsPage__c objCmsPage,pepCmsSection__c objCmsSection,pepCmsAnswer__c objCmsAnswer){
pepCmsQuestion__c objCmsChildQuestionOfAnswer = new pepCmsQuestion__c();
objCmsChildQuestionOfAnswer.pepPage__c=objCmsPage.id;
objCmsChildQuestionOfAnswer.pepSection__c = objCmsSection.id;
objCmsChildQuestionOfAnswer.pepCMSAnswer__c=objCmsAnswer.id;
objCmsChildQuestionOfAnswer.Is_Date_to_Birth__c = true; 
objCmsChildQuestionOfAnswer.pepType__c = 'Date'; 
objCmsChildQuestionOfAnswer.pepSequence__c=2; 
insert objCmsChildQuestionOfAnswer ;
return objCmsChildQuestionOfAnswer ;
}

public static loan__Bank_Account__c createLoanBankAccount(String acctId)
{
    loan__Bank_Account__c objloanBnkAcc = new loan__Bank_Account__c();
    objloanBnkAcc.loan__Account__c = acctId ;
    objloanBnkAcc.loan__Account_Usage__c = 'Borrower/Investor Account' ;
    objloanBnkAcc.loan__Bank_Name__c = 'test bank name';
    objloanBnkAcc.Bank_Account_Number__c = 'Ac02984565';
    objloanBnkAcc.BSB__c = '123456' ;
    objloanBnkAcc.loan__Bank_Account_Number__c = 'num1234' ;
    insert objloanBnkAcc;
    return objloanBnkAcc ;
    
} 



//*******************************************
//********* Create Custom Settings **********
//*******************************************

//////// pages_config //////////////
public static List<pages_config__c> createPagesConfig() {
    List<pages_config__c> configlist = new List<pages_config__c>();
    pages_config__c pageConfig = new pages_config__c(
        Name          = 'pepexpensepage', 
        Page_Label__c = 'Expense Page'
    );
    configlist.add(pageConfig );
    
     pages_config__c pageConfig1 = new pages_config__c(
        Name          = 'peplandingpage', 
        Page_Label__c = 'peplandingpage'
    );
     configlist.add(pageConfig1);
     
     pages_config__c pageConfig2 = new pages_config__c(
        Name          = 'pepapplynow', 
        Page_Label__c = 'PepApplyNow'
    );
     configlist.add(pageConfig2);
     
     pages_config__c pageConfig3 = new pages_config__c(
        Name          = 'pepcongratulations', 
        Page_Label__c = 'pepCongratulations'
    );
     configlist.add(pageConfig3);
     
     pages_config__c pageConfig4 = new pages_config__c(
        Name          = 'pepcontract', 
        Page_Label__c = 'pepContract'
    );
     configlist.add(pageConfig4);
     
      pages_config__c pageConfig5 = new pages_config__c(
        Name          = 'pepdebtconsolidation', 
        Page_Label__c = 'pepDebtConsolidation'
    );
     configlist.add(pageConfig5);
     
      pages_config__c pageConfig6 = new pages_config__c(
        Name          = 'peplandingpageclone', 
        Page_Label__c = 'peplandingpageclone'
    );
     configlist.add(pageConfig6);
     
      pages_config__c pageConfig7 = new pages_config__c(
        Name          = 'pepfinaliserepayment', 
        Page_Label__c = 'pepFinaliseRepayment'
    );
     configlist.add(pageConfig7);
     
     pages_config__c pageConfig8 = new pages_config__c(
        Name          = 'pepincomepage', 
        Page_Label__c = 'Income Page'
    );
     configlist.add(pageConfig8);
     
     pages_config__c pageConfig9 = new pages_config__c(
        Name          = 'peploandetails', 
        Page_Label__c = 'peploandetails'
    );
     configlist.add(pageConfig9);
     
     pages_config__c pageConfig10 = new pages_config__c(
        Name          = 'peploanmanualupload', 
        Page_Label__c = 'peploanmanualupload'
    );
     configlist.add(pageConfig10);
     
     pages_config__c pageConfig11 = new pages_config__c(
        Name          = 'peploansetupcreditpolicy', 
        Page_Label__c = 'pepLoanSetupCreditPolicy'
    );
     configlist.add(pageConfig11);
     
     pages_config__c pageConfig12 = new pages_config__c(
        Name          = 'peploansetupuploadanotherimage', 
        Page_Label__c = 'pepLoanSetupUploadAnotherImage'
    );
     configlist.add(pageConfig12);
     
     pages_config__c pageConfig13 = new pages_config__c(
        Name          = 'peploansetupuploadeddocs', 
        Page_Label__c = 'pepLoanSetupUploadedDocs'
    );
     configlist.add(pageConfig13);
     
     pages_config__c pageConfig14 = new pages_config__c(
        Name          = 'peploansetupverifyid', 
        Page_Label__c = 'peploansetupverifyid'
    );
     configlist.add(pageConfig14);
     
     pages_config__c pageConfig15 = new pages_config__c(
        Name          = 'peppaymentsetup', 
        Page_Label__c = 'pepPaymentSetup'
    );
     configlist.add(pageConfig15);
     
     pages_config__c pageConfig16 = new pages_config__c(
        Name          = 'peppersonaldetails', 
        Page_Label__c = 'pepPersonalDetails'
    );
     configlist.add(pageConfig16);
     
     pages_config__c pageConfig17 = new pages_config__c(
        Name          = 'pepserviceabilitynegative', 
        Page_Label__c = 'pepServiceabilityNegative'
    );
     configlist.add(pageConfig17);
     
     pages_config__c pageConfig18 = new pages_config__c(
        Name          = 'pepserviceabilitynegative2', 
        Page_Label__c = 'pepServiceabilityNegative2'
    );
     configlist.add(pageConfig18);
     
     pages_config__c pageConfig19 = new pages_config__c(
        Name          = 'pepserviceabilitypositve', 
        Page_Label__c = 'pepServiceabilityPositve'
    );
     configlist.add(pageConfig19);
     
     pages_config__c pageConfig20 = new pages_config__c(
        Name          = 'pepthankyou', 
        Page_Label__c = 'pepThankYou'
    );
     configlist.add(pageConfig20);
     
     pages_config__c pageConfig21 = new pages_config__c(
        Name          = 'pepuploadfinancialdoc', 
        Page_Label__c = 'pepUploadFinancialDoc'
     );
     configlist.add(pageConfig21);
     
     pages_config__c pageConfig22 = new pages_config__c(
        Name          = 'pepdocumentinbox', 
        Page_Label__c = 'pepDocumentInbox'
     );
     configlist.add(pageConfig22);
     
     pages_config__c pageConfig23 = new pages_config__c(
        Name          = 'pepchangepaymentsfrequency', 
        Page_Label__c = 'pepChangePaymentsFrequency'
     );
     configlist.add(pageConfig23);
     
     pages_config__c pageConfig24 = new pages_config__c(
        Name          = 'peptransactionhistory', 
        Page_Label__c = 'pepTransactionHistory'
     );
     configlist.add(pageConfig24);
     
     pages_config__c pageConfig25 = new pages_config__c(
        Name          = 'pepwelcomepage', 
        Page_Label__c = 'pepwelcomepage'
     );
     configlist.add(pageConfig25);
     
     pages_config__c pageConfig26 = new pages_config__c(
        Name          = 'pepchangeprofile', 
        Page_Label__c = 'pepchangeProfile'
     );
     configlist.add(pageConfig26);
  
    insert configlist;
    return configlist;
}

public static Portal_OwnerId__c createPortalOwnerID(user u){
   Portal_OwnerId__c objPortalID = new Portal_OwnerId__c(Name='First',Owner_Id__c=u.id);
   insert objPortalId;
   return objPortalId;

}

    public static OTP_Template__c createOTPTemplate(){
        List<Folder> folderLst = new List<Folder>();
        EmailTemplate e;
        folderLst = [Select Id,Name from Folder where Name =: 'PepperHTML' limit 1];
        User usr = [Select id from User where Id =: UserInfo.getUserId()];
        System.RunAs(usr){
            e = new EmailTemplate (developerName = 'test', IsActive=True , FolderId = folderLst.get(0).Id, TemplateType= 'Text', Name = 'test'); 
            insert e;
        }
        OTP_Template__c objOtpTemplate = new OTP_Template__c(Name='First',Template_Id__c=e.id);
        insert objOtpTemplate;
        return objOtpTemplate;
    }
    
    public static RetrieveCode__c createRetrieveCode(){
        RetrieveCode__c obj = new RetrieveCode__c();
        obj.Code__c='AAB35315';
        insert obj;
        return obj;
    }
    
public static pepDefaultCompany__c createPageDefaultCompany() {
        pepDefaultCompany__c pepDefaultCompany = new pepDefaultCompany__c(
        Name          = 'Company Id',
        pepBusinessAccount__c= '001N000000f7m25',
        pepDefault_Company_Id__c= 'a5aN000000004EC'
    );
    
    insert pepDefaultCompany  ;
    return pepDefaultCompany ;
}

//Create Captcha_Settings__c custom setting
public static Captcha_Settings__c createCaptchaSetting(){
 
    Captcha_Settings__c captchaSetting = new Captcha_Settings__c(Name = 'Google recaptcha' , Secret_Key__c = '6Lf9Xh4TAAAAADxvlksoRBbYZL3OwFqceJ3CskwV' , Site_Key__c = '6Lf9Xh4TAAAAAHGa8IGBs71IbMxQpLTUwVEwFQYN',Url__c = 'https://www.google.com/recaptcha/api/siteverify');
    insert captchaSetting;
    return captchaSetting;
}
public static Application__c createApplication() {
     
    
     Application__c pepApplication = new Application__c(Name= 'pepFinaliseRepayment',Navigation_Status__c='LoanSetup-FinaliseRepayment',RedirectPage__c='pepFinaliseRepayment');
     insert pepApplication;
     return pepApplication;
         }

public static RetrievalApplicationStatus__c createRetrievApplication()
{
    RetrievalApplicationStatus__c retrievalApp = new RetrievalApplicationStatus__c(Name = 'Retrieval Status' , Retrieval_Status__c = 'APPROVED - DOCUMENT SIGNED,APPROVED - CONVERTED TO CONTRACT,REJECTED,DECLINED,CLOSED');
    insert retrievalApp;
    return retrievalApp;
}
 public static genesis__Applications__c createGenesisApplication(Account objAccount)
 {
    Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();
    Map<String,SObject> relatedObjects = new Map<String,SObject>(); 
    genesis__Applications__c objApplication = new genesis__Applications__c();
    objApplication.genesis__Account__c = objAccount.id;
    objApplication.genesis__Loan_Amount__c = 14000;
    objApplication.pepNavigation_Status__c = 'Expense';
    objApplication =  pepInvokeCLMethodHelper.insertApplication(objApplication,relatedObjects ,childObjects ); 
    return objApplication ;
 
 }
    
    
 
 
 //Insert Product------------------------------------------------------------------------------------------
public static loan__Loan_Product__c createLoanProduct(){
 loan__Loan_Product__c objLoanProduct = new loan__Loan_Product__c();
 objLoanProduct.Name = 'Test Product';
 objLoanProduct.loan__Interest_Calculation_Method__c ='Flat';
 objLoanProduct.loan__Frequency_of_Loan_Payment__c='Weekly';
 objLoanProduct.loan__Loan_Product_Type__c='Loan';
 objLoanProduct.loan__Time_Counting_Method__c='Actual Days';
 insert objLoanProduct;
 return objLoanProduct;
} 

//Insert Office(Branch)------------------------------------------------------------------------------------
public static loan__Office_Name__c createOffice(){
 loan__Office_Name__c objOfficeName =  new loan__Office_Name__c();
 objOfficeName.loan__Office_Short_Name__c ='TestCompany';
 insert objOfficeName;
 return objOfficeName;
} 
 
 
//Insert LoanAccount---------------------------------------------------------------------------------------
public static loan__Loan_Account__c createLoanAccount2(loan__Office_Name__c objOfficeName,loan__Loan_Product__c objLoanProduct){
 loan__Loan_Account__c objLoanAccount = new loan__Loan_Account__c();
 objLoanAccount.loan__Loan_Product_Name__c = objLoanProduct.id;
 objLoanAccount.loan__Branch__c=objOfficeName.id;
 objLoanAccount.loan__Loan_Amount__c=5000000;
 objLoanAccount.loan__Number_of_Installments__c=30;
 objLoanAccount.loan__Due_Day__c=20;
 objLoanAccount.loan__Interest_Rate__c=10;
 insert objLoanAccount;
 return objLoanAccount;
} 
 
//Insert PaymentMode------------------------------------------------------------------------------------------
public static loan__Payment_Mode__c createPaymentMode(){
 loan__Payment_Mode__c objPaymentMode = new loan__Payment_Mode__c();
 objPaymentMode.Name='Cash';
 insert objPaymentMode;
 return objPaymentMode;
} 
 
//Insert PaymentTransaction------------------------------------------------------------------------------------------
public static loan__Loan_Payment_Transaction__c createPaymentTransaction(loan__Payment_Mode__c objPaymentMode , loan__Loan_Account__c loanAcc){
 loan__Loan_Payment_Transaction__c objLoanPaymentTransaction = new loan__Loan_Payment_Transaction__c();
 objLoanPaymentTransaction.loan__Fees__c=200000;
 objLoanPaymentTransaction.loan__Interest__c = 2000;
 objLoanPaymentTransaction.loan__Principal__c=30000;    
 objLoanPaymentTransaction.loan__Excess__c=5000;
 objLoanPaymentTransaction.loan__Reversed__c = true;
 objLoanPaymentTransaction.loan__Transaction_Amount__c=5000;
 objLoanPaymentTransaction.loan__Transaction_Date__c=System.Today();
 objLoanPaymentTransaction.loan__Payment_Mode__c=objPaymentMode.id;
 objLoanPaymentTransaction.loan__Rejected__c=false;
 objLoanPaymentTransaction.loan__Loan_Account__c = loanAcc.Id;
 insert objLoanPaymentTransaction;
 return objLoanPaymentTransaction;
} 
 
//Insert disbursalTransaction------------------------------------------------------------------------------------------ 

public static loan__Loan_Disbursal_Transaction__c createDisbursalTransaction(loan__Loan_Account__c objLoanAccount,loan__Payment_Mode__c objPaymentMode){
 loan__Loan_Disbursal_Transaction__c objLoanDisbursalTransaction = new loan__Loan_Disbursal_Transaction__c();
 objLoanDisbursalTransaction.loan__Cleared__c = true;
 objLoanDisbursalTransaction.loan__Disbursal_Date__c=System.Today();
 objLoanDisbursalTransaction.loan__Disbursed_Amt__c = 5000;
 objLoanDisbursalTransaction.loan__Mode_of_Payment__c = objPaymentMode.id;
 objLoanDisbursalTransaction.loan__Loan_Account__c=objLoanAccount.id;
 insert objLoanDisbursalTransaction;
 return objLoanDisbursalTransaction;
} 

//Insert LoanOtherTransaction------------------------------------------------------------------------------------------ 
public static loan__Other_Transaction__c createOtherTransaction(loan__Loan_Account__c objLoanAccount){
 loan__Other_Transaction__c objOtherTransaction = new loan__Other_Transaction__c();
 objOtherTransaction.loan__Loan_Account__c=objLoanAccount.id;
 objOtherTransaction.loan__Txn_Date__c=System.Today();
 insert objOtherTransaction;
 return objOtherTransaction;
} 

//Insert LoanFee------------------------------------------------------------------------------------------ 
public static loan__Fee__c createLoanFee(){
 loan__Fee__c objFee = new loan__Fee__c();
 objFee.Name='TestFee';
 objFee.loan__Fee_Category__c='Loan';
 objFee.loan__Time_of_charge__c='Other';
 objFee.loan__Fee_Calculation_Method__c='Fixed';
 insert objFee;
 return objFee;
}

//Insert LoanCharge------------------------------------------------------------------------------------------ 
public static loan__Charge__c createLoanCharge(loan__Loan_Account__c objLoanAccount,loan__Fee__c objFee ){
 loan__Charge__c objCharges = new loan__Charge__c();
 objCharges.loan__Loan_Account__c = objLoanAccount.id;
 objCharges.loan__Fee__c = objFee.id;
 objCharges.loan__Date__c=System.Today();
 objCharges.loan__Original_Amount__c=200000;
 insert objCharges;
 return objCharges;
} 


//Create Custom setting of CreateJumioCredential
public static pepJumio_Credentials__c  createJumioCredential()
{  
    pepJumio_Credentials__c objJumioCred = new pepJumio_Credentials__c();
    objJumioCred.Name = 'Credential';
    objJumioCred.pepMerchant_API_token__c = '26ecb510-5d33-4b25-822f-ab8c6baf8d1b';
    objJumioCred.pepActive_API_secret_c__c = '2RslQEASMgyoUMyGZzHVvmYWUXVI1BuC';
    objJumioCred.pepEnd_Point__c = 'https://netverify.com/api/netverify/v2/initiateNetverify';
    insert objJumioCred;
    return objJumioCred;
}     


public static genesis__Application_Document_Category__c createApplicationDocCat(){
     genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c(Name = 'AppDocCatTest' ,genesis__Status__c = 'CLEARED' ,genesis__Active__c = true );
     insert appDocCat;
     return appDocCat;
 }
 
 //Create Bank Account()
 public static loan__Bank_Account__c  createLoanBankAccount()
 {
     createContact();
     createAccount();
     loan__Bank_Account__c  objBankLoanAcc = new loan__Bank_Account__c ();
     objBankLoanAcc.loan__Account_Type__c = 'Saving';
     objBankLoanAcc.loan__Contact__c = objContact.id;
     objBankLoanAcc.loan__Account__c = objAccount1.id;
     objBankLoanAcc.loan__Bank_Account_Number__c = 'GYYH0986544';
     objBankLoanAcc.loan__Bank_Name__c = 'NAB';
     return objBankLoanAcc;
 }
 
 //create employment Information
 public static genesis__Employment_Information__c employmentInformation()
 {
     genesis__Employment_Information__c empInfo = new genesis__Employment_Information__c(Name = 'Test Emp Info',pepCompany_Address__c = 'TestAddress',Sequence__c = 5);
     insert empInfo;
     return empInfo; 
 }
 
 //create ServiceabilityNegativeTask custom setting
 public static ServiceabilityNegativeTask__c createServiceabilityNegativeTask(){
     ServiceabilityNegativeTask__c serviceabilityTask = new ServiceabilityNegativeTask__c();
     serviceabilityTask.Name = 'userIdtoTask';
     serviceabilityTask.User_Id__c = '00GN0000001fgfm';
     insert serviceabilityTask;
     return serviceabilityTask;
 }
 
 // create Cl Product
 
 public static clcommon__CL_Product__c createClProduct(){
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'productName';
        insert clProduct;
        return clProduct;
 }
 
 public static clcommon__CL_Purpose__c createClPurpose(){

        clcommon__CL_Purpose__c clPurpose = new clcommon__CL_Purpose__c();
        clPurpose.Serial_No__c = 5;
        clPurpose.Name = 'ClPurposeTest';
        insert  clPurpose;
        return clPurpose;
}


 public static loan__Loan_Account__c createLoanAccount(){
 
        loan.testhelper.createSeedDataForTesting();
                  
        loan__Office_Name__c ObjLoanOffice = loan.TestHelper.createOffice();
        
        loan__MF_Account__c  objLoanMFAccount = loan.TestHelper.createMFAccount('TestName','TestType');
        loan__Currency__c objloanCurrency = loan.TestHelper.createCurrency();
        
        loan__Fee__c objFee = loan.TestHelper.createFee(objloanCurrency );
        
        
        loan__Fee_Set__c objLoanFeeSet = loan.TestHelper.createFeeSet();
        objLoanFeeSet.loan__Fee_Set_Category__c='Loan';
        update objLoanFeeSet ;
        
        loan__Fee_Junction__c objJunction =loan.TestHelper.createFeeJunction(objFee,objLoanFeeSet);
        
        loan__Client__c objClient = loan.TestHelper.createClient(ObjLoanOffice);
        loan__Loan_Purpose__c objPurpose = loan.TestHelper.createLoanPurpose();
        
        loan__Loan_Product__c objLoanProduct = loan.TestHelper.createLoanProduct(ObjLoanOffice,objLoanMFAccount,objloanCurrency,objLoanFeeSet);
    
        
        loan__Loan_Account__c objLoanAccount = loan.TestHelper.createLoanAccount(objLoanProduct,objClient,objLoanFeeSet,objPurpose,ObjLoanOffice);
        objLoanAccount.loan__Delinquent_Amount__c =20;
        objLoanAccount.loan__Delinquent_Amount__c=12;
        objLoanAccount.loan__Fees_Remaining__c=12;
        update objLoanAccount ;
       return objLoanAccount ;
 
 }
 
 //This method is used to call the account and loan account related to user
 public static void loadData()
    { 
        createAccount1();
        createLoanAccount1();
        createContact1();
        createUser1();
        
    }
    
    //This method creates account
   public static Account createAccount1()
   {     
     objAcc =  new Account();
     objAcc.name ='AccountNameTest';
     //objAcc.PersonEmail='test@gmail.com';
     insert objAcc; 
     return objAcc;  
       
   }
   
   public static loan__Loan_Account__c createLoanAccount1()
    {
       objLoanAcc = createLoanAccount();
       objLoanAcc.loan__Account__c = objAcc.id;
       objLoanAcc.loan__Principal_Paid__c=12;
       objLoanAcc.loan__Principal_Remaining__c=12;
       objLoanAcc.DocumentInbox__c=True;
       update objLoanAcc;
       return objLoanAcc;
       
       /*loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
       payMode.Name ='testPayMOde';
       insert payMode;
       
       loan__Automated_Payment_Setup__c automatedPayment = new loan__Automated_Payment_Setup__c();
       automatedPayment.loan__Active__c = true;
       automatedPayment.loan__Type__c = 'RECURRING';
       automatedPayment.loan__Debit_Date__c = system.today();
       automatedPayment.loan__CL_Contract__c = objLoanAcc.id;
       automatedPayment.loan__Frequency__c = 'Bi-Monthly';
       automatedPayment.loan__Payment_Mode__c = payMode.id;
       insert automatedPayment;*/
    }
    
   
   public static Contact createContact1()
   {
     objContact1 = new Contact(); 
     objContact1.LastName ='test';
     objContact1.accountId = objAcc.id;
     insert objContact1;
     return objContact1;
   }
   
   public static void createRoleAndProfile()
   {
       Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner','Custom Customer Community Login user', 'PowerCustomerSuccess',   'CustomerSuccess'};
       p = [select Id,name from Profile where name in :customerUserTypes limit 1];
   }
   public static User createUser1()
   {  
        createRoleAndProfile();
        objuser1 = new User();
        objUser1.profileId = p.id;
        objuser1.userName ='newUser@yahoo.com';
        objUser1.email ='amit@test.com';
        objUser1.emailencodingkey ='UTF-8';
        objUser1.localesidkey ='en_US';
        objUser1.languagelocalekey ='en_US';
        objUser1.timezonesidkey ='America/Los_Angeles';
        objUser1.alias ='ak';
        objUser1.lastname ='kumar';
        objUser1.contactId =objContact1.Id;
        insert objUser1;
        return objUser1;        
     
    }
    
 

}
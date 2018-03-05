@isTest(SeeAllData=False)

private class pepDocumentInboxController_Tracker 
{    
    public static User usr;
    public static List<Attachment> lstAccWr;
    private static Profile p ;
    private static UserRole portalRole1;
    private static user objUser;
    private static  Account objAccount;
    private static Contact objContact;
    private static loan__Loan_Account__c objLoanAccount;
    private static List<loan__Loan_Account__c> lstLoanAcount;
    public static genesis__Applications__c objApplication;
    
    
    
    public static void loadData()
    { 
        Account acc = createAccount();
        loan__Loan_Account__c accLoan = createLoanAccount();
        createSectionAndPage();
        accLoan.Application__c = objApplication.id;
        update accLoan;
        acc.Loan_Account_Id__c = accLoan.Id;
        update acc;
        createContact();
        createUser();
        
        
        
    }
    
    
    public static loan__Loan_Account__c createLoanAccount()
    {
       objLoanAccount = pepCommonTrackerController.createLoanAccount();
       objLoanAccount.loan__Account__c = objAccount.id;
       update objLoanAccount;
       
       loan__Payment_Mode__c payMode = new loan__Payment_Mode__c();
       payMode.Name ='testPayMOde';
       insert payMode;
       
       loan__Automated_Payment_Setup__c automatedPayment = new loan__Automated_Payment_Setup__c();
       automatedPayment.loan__Active__c = true;
       automatedPayment.loan__Type__c = 'RECURRING';
       automatedPayment.loan__Debit_Date__c = system.today();
       automatedPayment.loan__CL_Contract__c = objLoanAccount.id;
       automatedPayment.loan__Frequency__c = 'Bi-Monthly';
       automatedPayment.loan__Payment_Mode__c = payMode.id;
       insert automatedPayment;
       
       return objLoanAccount;
    }
    
    
    //This method creates account
   public static Account createAccount()
   {     
     objAccount=  new Account();
     objAccount.name ='AccountNameTest';
     insert objAccount; 
     return objAccount;  
       
   }
   
   private static void createContact()
   {
     objContact = new Contact(); 
     objContact.LastName ='test';
     objContact.accountId = objAccount.id;
     insert objContact;
   }
   
   private static void createRoleAndProfile()
   {
       Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner','Custom Customer Community Login user', 'PowerCustomerSuccess',   'CustomerSuccess'};
       p = [select Id,name from Profile where name in :customerUserTypes limit 1];
       //portalRole1 = [Select Id From UserRole Where PortalType = 'None' Limit 1];
   }
   private static void createUser()
   {  
        createRoleAndProfile();
        objuser = new User();
        objUser.profileId = p.id;
        //objuser.userroleid = portalRole1.id;
        objuser.userName ='newUser@yahoo.com';
        objUser.email ='amit@test.com';
        objUser.emailencodingkey ='UTF-8';
        objUser.localesidkey ='en_US';
        objUser.languagelocalekey ='en_US';
        objUser.timezonesidkey ='America/Los_Angeles';
        objUser.alias ='ak';
        objUser.lastname ='kumar';
        objUser.contactId =objContact.Id;
        insert objUser;
               
     
    }
          
    private static void createSectionAndPage()
    {    
        pepCommonTrackerController obj =new pepCommonTrackerController();
        
        Account accObj = pepCommonTrackerController.createAccount();
         
        objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.genesis__Account__c = accObj.id;
        update objApplication;
        
        Pagereference pd=Page.pepUploadFinancialDoc;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat = pepCommonTrackerController.createApplicationDocCat();
        appDocCat.Name = 'Credit Contract';
        appDocCat.genesis__Application__c = objApplication.Id;
        update appDocCat;
        
        lstAccWr = new List<Attachment>();
        Attachment attach = new Attachment();     
        attach.Name ='Unit Test Attachment';
        attach.ContentType = 'image/jpeg';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId=appDocCat.id;
        insert attach;
        
        Attachment attach1 = new Attachment();     
        attach1.Name ='Unit Test Attachment1';
        attach1.ContentType = 'image/jpeg';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body = bodyBlob1;
        attach1.parentId=appDocCat.id;
        insert attach1;
        lstAccWr.add(attach1);
        
        pages_config__c pageconfig = pepCommonTrackerController.createPagesConfig()[22];
        
        CL_Contract_Document_Junction__c clContDoc = new CL_Contract_Document_Junction__c();
        clContDoc.CL_Contract__c = objLoanAccount.id;
        clContDoc.Document_Category__c = 'DDR';
        clContDoc.Attachment_ID__c = attach.Id;
        insert clContDoc;
        
        genesis__AppDocCatAttachmentJunction__c appDocCatJun = new genesis__AppDocCatAttachmentJunction__c();
        appDocCatJun.genesis__Application_Document_Category__c = appDocCat.id;
        appDocCatJun.genesis__AttachmentId__c = attach.Id;
        insert appDocCatJun;
    
    }
    
    
    
    
    @isTest static void pepDocumentInboxControllerTest0() {
        
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        
        system.runas(usr1)     
        {
           test.startTest();
            loadData();
           test.stopTest();
        }
        
        
        system.runas(objUser)     
        {   
        pepDocumentInboxController objClass = new pepDocumentInboxController();
        objClass.lstSetController = lstAccWr;
        objClass.hasNext = false;
        objClass.hasPrevious = false;
        PepDocumentInboxPagination docInboxPag = new PepDocumentInboxPagination(lstAccWr);
        objClass.selectedPageSize = '1';
        docInboxPag.setPageSize = 1;
        //objClass.next();
        objClass.intPageNumber = 6;
        //objClass.previous();
        //objClass.GoTo();
        //objClass.numberBar(5);
        objClass.updateDocument();
        
       
        }
    }
}
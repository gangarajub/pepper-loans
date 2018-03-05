@isTest(SeeAllData=False)
Private class Postsandboxscript_Test{
Public static Account acc;
    
    Public testmethod static void scheduleemailscript(){
        
        createdata();
        Test.startTest();
        // Using any Ids as orgId and sandboxId for test, e.g. Account Ids 
        // Id possible pass valid id
        Test.testSandboxPostCopyScript(new Postsandboxscript(),acc.id,acc.id, 'sandboxName');
        
        Test.stopTest();
    }
    
    public testmethod static void testScrambleData(){
        createData();
        Test.startTest();
        
        Postsandboxscript_Utility.ScrambleCustomerData();
        
        Test.stopTest();
        
    }
    
    //AH - written by SAASFocus in early 2017
    //updated in Dec 17 to include TestContactDetailsForSandboxes__c, Lead creation
    Private static void  createdata(){
        
        TestContactDetailsForSandboxes__c testDetails = new TestContactDetailsForSandboxes__c(Name='Test', EmailAddress__c='testme@pepper.com.au', PhoneNumber__c = '80087355');
		insert testDetails;
        
        ExcludeEmailaddresses__c ex = new ExcludeEmailaddresses__c(Name='defaultemail@pepper.com.au');
        insert ex;
        	
        acc= ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Contact contact = ScCollection_CommonTrackerClass.createTestContact();
        Lead thisLead = ScCollection_CommonTrackerClass.createTestLead();
        
        collect__Source_System__c sourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('Mortgage');
        collect__Bank_Account__c collectBankAccount = ScCollection_CommonTrackerClass.createTestBankAccount(sourceSystem.Id);
            
        loan.testhelper.createSeedDataForTesting();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        genesis__Applications__c objApplication= genesis.TestHelper.createApplication();
        objApplication.genesis__Account__c=acc.id;
        update objApplication;
        
        loan__Bank_Account__c loanBankAccount = ScCollection_CommonTrackerClass.createTestLoanBankAccount(acc.id);
        Property_Insurance__c prop = ScCollection_CommonTrackerClass.createTestPropertyInsurance();
        
        collect__Loan_Account__c objLoanAcc = ScCollection_CommonTrackerClass.createTestContract(sourceSystem.id);
        objLoanAcc.ScCollection_FP_Group_Name__c = 'Consumer Loan';
        update objLoanAcc;

        clcommon__Party_Type__c objPartyType = new clcommon__Party_Type__c();
        objPartyType.Name = 'Primary Borrower';
        objPartyType.ScCollection_is_ATP__c = true;
        objPartyType.pafss_Is_Individual_Loan__c = true;
        objPartyType.ScCollection_Only_For_ESB__c = true;
        insert objPartyType;        
        
        clcommon__Party__c objParty = new clcommon__Party__c();
        objParty.clcommon__Type__c = objPartyType.id;
        objParty.clcommon__Account__c = acc.id;
        objParty.collect__CL_Contract__c = objLoanAcc.id;
        objParty.pafss_Send_PAF_Portal_Email__c =true;
        objParty.pepATP_Name__c = 'Test Name';
        objParty.pepATPContactNumber__c = '097087986';
        
        insert objParty;
        
        
    }

    //AH - 12/09/17 - This test method tests Seed Data Creation.
    public TestMethod static void testCreateDefaultPepCorp(){
        
        
        //first disable the triggers on Auto PAyment Config...
        loan__Org_Parameters__c orgParams = new loan__Org_Parameters__c (loan__Disable_Triggers__c = true, SetupOwnerId = UserInfo.getOrganizationId());
        loan__Trigger_Parameters__c trgParams = new loan__Trigger_Parameters__c(loan__Disable_Automated_Payment_Config_Trigger__c = true, loan__Disable_Automated_Payment_Setup_Trigger__c = true, SetupOwnerId = UserInfo.getOrganizationId());
        
        insert orgParams;
        insert trgParams;
        
        Test.startTest();
        
        Postsandboxscript_Utility.createDefaultPepCorp();
        
        Test.stopTest();
        
        //check that the Default Account exists
        List<Account> DefaultAccounts = [select Id from Account where name = 'Pepper Finance Corporation Limited'];
        Integer iDefaultAccount = DefaultAccounts.size();
        System.debug('iDefaultAccount: ' + iDefaultAccount);
        System.assert(iDefaultAccount == 1);
        
        //check the Bank Accounts exist
        Integer iDefaultBankAccounts = [select Id from loan__Bank_Account__c where loan__Account__c =: DefaultAccounts[0].Id].size();
        System.debug('iDefaultBankAccounts: ' + iDefaultBankAccounts);
        System.assert(iDefaultBankAccounts==3);
        
        //check the Payment Modes exist
        Integer iDefaultPayModes = [select Id from loan__Payment_Mode__c].size();
        System.debug('iDefaultPayModes: ' + iDefaultPayModes);
        System.assert(iDefaultPayModes==16);
        
        //check the Auto Payment Configs exist
        Integer iDefaultAutoPayConfigs = [select Id from loan__Automated_Payment_Configuration__c where Organization_Name__c = 'Pepper Money'].size();
        System.debug('iDefaultAutoPayConfigs: ' + iDefaultAutoPayConfigs);
        System.assert(iDefaultAutoPayConfigs == 3);
        
        
    }
    
    public TestMethod static void testCreateDDPUser(){
        Test.startTest();
        Postsandboxscript_Utility.createDrawLoopUser();
        Test.stopTest();
        
        //check that the DDP User and Contact exists
        List<User> lUser = [select Id, username, ContactId, Contact.FirstName from User where FirstName = 'Drawloop Contract'];
        System.debug('lUser size = ' + lUser.size());
        if(lUser!=null && lUser.size()>0){
            System.debug('lUser[0].Contact.FirstName: ' + lUser[0].Contact.FirstName);
            System.assert(lUser[0].ContactId != null);
        }else{
            System.assert(false);
        }
    }


}
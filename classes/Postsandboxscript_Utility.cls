/*
 * Author: 		Alex Humby
 * Created: 	28/03/2017
 * Description:	Contains methods to create Seed Data in a new Sandbox
 * 				1) createDrawLoopUser - creates the Drawloop Community User, and associated Account/Contact (if they dont exist)
 * 				2) createDefaultPepCorp - main method for creating other seed objects
 * 				3) createPaymentModes - creates Seed Data Payment Modes (if they dont exist)
 * 				3) createDefaultAccount - creates an Account called Pepper Finance Corporation Limited, if it doesnt exist
 *				4) createBankAccounts - seed pepper bank accounts for the Default Account (if they dont exist)
 *				5) createAutomatedPaymentConfigs - sets up the automated payment configurations - dependant on the other methods
 *				
 */

global class Postsandboxscript_Utility {
    
        Final Static String DEFAULT_ACCOUNT_NAME = 'Pepper Finance Corporation Limited';    
        static Id defaultAccountId;
		static Id pmACHId;
		Static Id pmDCId;
		static Id pmDDId;
		static Id acc1Id;
		static Id acc2Id;
		Static List<loan__Payment_Mode__c> lPayModes;
    	static Map<String, loan__Payment_Mode__c> mapPayModes = new Map<String, loan__Payment_Mode__c>();
    	static List<loan__Bank_Account__c> listofBAs;
    	static Map<String, loan__Bank_Account__c> mapBankAccounts = new Map<String, loan__Bank_Account__c>();
    	Static Id defaultAccountOwnerId = [select Id from User where alias = 'sfcoe' limit 1].Id;

    
    global static void ScrambleCustomerData(){
      ScrambleAccountDetails scrambleAccounts = new ScrambleAccountDetails();
      Database.executeBatch(scrambleAccounts,1000);
      
      ScrambleLeadDetails scrambleLeads = new ScrambleLeadDetails();
      Database.executeBatch(scrambleLeads, 1000);
      
      ScramblePartyDetails scramblePartyDetails = new ScramblePartyDetails();
      Database.executeBatch(scramblePartyDetails, 1000);
      
      ScrambleCollectBankAccountsDetails scrambleCollectBankAccounts = new ScrambleCollectBankAccountsDetails();
      Database.executeBatch(scrambleCollectBankAccounts, 1000);
      
      ScrambleLoanBankAccountsDetails scrambleLoanBankAccounts = new ScrambleLoanBankAccountsDetails();
      Database.executeBatch(scrambleLoanBankAccounts, 1000);
     
      ScrambleInsuranceDetails scrambleInsuranceDetails = new ScrambleInsuranceDetails();
      Database.executeBatch(scrambleInsuranceDetails, 1000);        
    }
    
    
    global static void createDrawLoopUser(){
        //System.debug('****************START DDP USER*******************');
        Profile ddpProfile = [select Id, Name from Profile where name = 'Drawloop User Profile' limit 1];
        
        
        //System.debug('ddpProfile: ' + ddpProfile.Name);
        
        List<Account> listDDPAccount = [select Id, Name, RecordTypeId from Account where Name = 'Drawloop Contract User Account' limit 1];
        Account ddpAccount;
        if(listDDPAccount==null || listDDPAccount.size() == 0){
            ddpAccount = new Account(
                Name = 'Drawloop Contract User Account',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                OwnerId = defaultAccountOwnerId
                
            );
            insert ddpAccount;
        }else{
            ddpAccount = listDDPAccount[0];
        }
        
        List<Contact> listDDPContact = [select Id, LastName, AccountId from Contact where LastName = 'Contract Contact' limit 1];
        Contact ddpContact;
        if(listDDPContact==null || listDDPContact.size()==0){            
            ddpContact = new Contact(
				FirstName = 'Drawloop',
                LastName = 'Contract Contact',
                AccountId = ddpAccount.Id
            );
            insert ddpContact;
          //  System.debug('New Contact Id Inserted');
        }else{
            //System.debug('Update existing DDP Contact');

            ddpContact = new Contact (
            	FirstName = 'Drawloop',
            	LastName = 'Contract Contact',
            	AccountId = ddpAccount.Id,
                
                Id = listDDPContact[0].Id
            );
            update ddpContact;

        }
       // System.debug('DDP Contact Id: ' + ddpContact.Id);
        
		insertPortalUser(ddpContact.Id, ddpProfile.Id);
		//System.debug('************************************************');
    }
    
	@future
    global static void insertPortalUser(Id ddpContactId, Id ddpProfileId){
        List<User> listDDPUser = [select Id, Username, ContactId from User where FirstName = 'Drawloop Contract' limit 1];
        //System.debug('listDDPUser size: ' + listDDPUser.size());
        if(listDDPUser==null || listDDPUser.size()==0){
                User ddpUser = new User(
                    FirstName = 'Drawloop Contract',
                    LastName = 'User',
                    Username = 'ddp_user@pepper.com',
                    ContactId = ddpContactId,
                    ProfileId = ddpProfileId,
                    Email = 'salesforcecoe@pepper.com.au',
                    CommunityNickname = 'ddp_user',
                    Alias = 'draw', 
                    TimeZoneSidKey = 'Australia/Sydney', 
                    LocaleSidKey = 'en_AU', 
                    EmailEncodingKey = 'ISO-8859-1', 
                    LanguageLocaleKey = 'en_US',
                    IsActive = True
                );
                insert ddpUser;
		//	System.debug('New User Inserted');
           // System.debug('ddpUser.ContactId: ' + ddpUser.ContactId);
        }else{
         //   System.debug('Existing DDP User Contact Id: ' + listDDPUser[0].ContactId);            
        }        
        
    }
    
    global static void createDefaultPepCorp(){
        //System.debug('Started createDefaultPepCorp');

        createPaymentModes();

        createDefaultAccount();        
    
		createBankAccounts();
        
        createAutomatedPaymentConfigs();
    }
    
    public static void createPaymentModes(){
		
        lPayModes = [select id, Name from loan__Payment_Mode__c]; 
        Integer iPM = lPayModes.size(); 
        if(iPM==0){
	        String stringPayModeNames = 'ACH-BPAY-Cash-Check-Credit Card-Direct Credit-Direct Debit-Excess-Mobile-OFF BSB-RCC-Refinancing-Trust-Waived-Wire-WRITE OFF';
            String[] sPayModes = stringPayModeNames.split('-');
            
            for(String s : sPayModes){
                loan__Payment_Mode__c payMode = new loan__Payment_Mode__c(
                    Name = s
                );
                
                lPayModes.add(payMode);
                mapPayModes.put(s, payMode);
            }
            
            upsert lPayModes;
        }else{
            for(loan__Payment_Mode__c p : lPayModes){
                mapPayModes.put(p.name, p);
            }            
        }
        
    }
       
    public static void createDefaultAccount(){
        
        Integer defaultAccountExists = [select Id from Account where Name =: DEFAULT_ACCOUNT_NAME].size();
        if(defaultAccountExists == 0){
            Account defaultAccount = new Account(
                Name = DEFAULT_ACCOUNT_NAME,
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                OwnerId  = defaultAccountOwnerId
            );
            insert defaultAccount;
        }else{
            system.debug('Default Account Already Exists');
        }        
        defaultAccountId = [select Id from Account where Name =: DEFAULT_ACCOUNT_NAME limit 1].Id;
        //System.debug('defaultAccountId: ' + defaultAccountId);

    }    

	public static void createBankAccounts(){
        //create bank account 1        
        listofBAs = new List<loan__Bank_Account__c>();
        
        Integer numAccs = [select Id from loan__Bank_Account__c where loan__Account__r.name =: DEFAULT_ACCOUNT_NAME limit 1].size();
        if(numAccs==0 && numAccs != null){
            loan__Bank_Account__c acc1 = new loan__Bank_Account__c(
                loan__Account__c = defaultAccountId,
                Account_Holder_Name__c = 'Pepper',
                loan__Account_Type__c = 'Saving',
                loan__Account_Usage__c = 'Advance Trust Account',
                loan__Active__c = true,
                loan__Bank_Account_Number__c = '000000',
                Bank_Account_Number__c = '00000000',
                loan_Bank_Account_Name__c = 'NAB',
                loan__Bank_Name__c = '125652',
                BSB__c = '000000'
            );
            listofBAs.add(acc1); 
            mapBankAccounts.put('SavingsTrustAccount', acc1);
 
            //2 bank accounts the same exist
            loan__Bank_Account__c acc2 = new loan__Bank_Account__c(
                loan__Account__c = defaultAccountId,
                Account_Holder_Name__c = 'Pepper',
                loan__Account_Type__c = 'Checking',
                loan__Account_Usage__c = 'Advance Trust Account',
                loan__Active__c = true,
                loan__Bank_Account_Number__c = '000000',
                Bank_Account_Number__c = '00000000',
                loan_Bank_Account_Name__c = 'NAB',
                loan__Bank_Name__c = '125652',
                BSB__c = '000000'
            );
            listofBAs.add(acc2);//2 bank accounts the same exist
            mapBankAccounts.put('CheckTrustAccount', acc2);
    
            loan__Bank_Account__c acc3 = new loan__Bank_Account__c(
                loan__Account__c = defaultAccountId,
                Account_Holder_Name__c = 'Pepper',
                loan__Account_Type__c = 'Saving',
                loan__Account_Usage__c = 'Collections Trust Account',
                loan__Active__c = true,
                loan__Bank_Account_Number__c = '00000000',
                Bank_Account_Number__c = '000000',
                loan_Bank_Account_Name__c = '',
                loan__Bank_Name__c = 'Westpac',
                BSB__c = '000000'
            );        
            listofBAs.add( acc3);
            mapBankAccounts.put('CollectionsTrustAccount', acc3);

	        insert listofBAs;
        }

	}
 
    public static void createAutomatedPaymentConfigs(){
		String sOrgName = 'Pepper Money';
        String sFileType = 'TEXT';
        String sUsername = 'PEPPER MONEY PERSONAL LOAN';
        String sRetry = 'Disabled';
        String sFinInst = 'WBC';
        //System.debug('createAutomatedPaymentConfigs...');
        List<loan__Automated_Payment_Configuration__c> lAutoPayConfigs = [select Id, Name from loan__Automated_Payment_Configuration__c];
        
        if (lAutoPayConfigs.size() == 0 ){
            loan__Automated_Payment_Configuration__c autoPayConfig1 = new loan__Automated_Payment_Configuration__c(
                loan__Filegen_Class__c = 'LoanDisbursalTxnPepperFileGen',
                loan__Folder_Name__c = 'Disbursal File',
                loan__Event__c = 'LOAN DISBURSAL',
                loan__Payment_Mode__c = mapPayModes.get('ACH').Id,
                Organization_Name__c = sOrgName,
                Name_of_User_Supplying_File__c = sUsername,
                Number_of_User_Supplying_file__c = '496794',
                Name_of_User_Financial_Institution__c = sFinInst,
                loan__Bank_Account__c = mapBankAccounts.get('CheckTrustAccount').Id,
                Trace_Account_Number__c = '207629',
                Trace_BSB__c = '032797',
                loan__File_Type__c = sFileType,
                loan__BatchId__c = 0,
                loan__Active__c = true,
                loan__Retry__c = sRetry
            );
        	lAutoPayConfigs.add(autoPayConfig1);
            
            loan__Automated_Payment_Configuration__c autoPayConfig2 = new loan__Automated_Payment_Configuration__c(
                loan__Filegen_Class__c = 'LoanPaymentTxnPepperFileGen',
                loan__Folder_Name__c = 'Payment File',
                loan__Event__c = 'LOAN PAYMENT',
                loan__Payment_Mode__c = mapPayModes.get('ACH').Id,
                Organization_Name__c = sOrgName,
                Name_of_User_Supplying_File__c = sUsername,
                Number_of_User_Supplying_file__c = '500145',
                Name_of_User_Financial_Institution__c = sFinInst,
                loan__Bank_Account__c = mapBankAccounts.get('CollectionsTrustAccount').Id,
                Trace_Account_Number__c = '208496',
                Trace_BSB__c = '032797',
                loan__File_Type__c = sFileType,
                loan__BatchId__c = 0,
                loan__Active__c = true,
                loan__Retry__c = sRetry
            );
        	lAutoPayConfigs.add(autoPayConfig2);
            
            loan__Automated_Payment_Configuration__c autoPayConfig3 = new loan__Automated_Payment_Configuration__c(
                loan__Filegen_Class__c = 'BrokerTxnPepperFileGen',
                loan__Folder_Name__c = 'Disbursal File',
                loan__Event__c = 'BROKER TRANSACTION',
                loan__Payment_Mode__c = mapPayModes.get('Direct Credit').Id,
                Organization_Name__c = sOrgName,
                Name_of_User_Supplying_File__c = sUsername,
                Number_of_User_Supplying_file__c = '509139',
                Name_of_User_Financial_Institution__c = sFinInst,
                loan__Bank_Account__c = mapBankAccounts.get('SavingsTrustAccount').Id,
                Trace_Account_Number__c = '604387',
                Trace_BSB__c = '032099',
                loan__File_Type__c = sFileType,
                loan__BatchId__c = 0,
                loan__Active__c = true,
                loan__Retry__c = sRetry
            );
        	lAutoPayConfigs.add(autoPayConfig3);
            
            insert lAutoPayConfigs;
        }        
        
        
        
        
    }
   
}
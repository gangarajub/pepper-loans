// ----------------------------------------------------------------------------------------------------
// This class would be used as a common tracker class to create test data.
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest
public class ScCollection_CommonTrackerClass
{
    public static collect__Queue__c objQueue;
    public static collect__Queue_User__c objQueueUser;
    public static collect__Source_System__c objsourcesystem;
    public static collect__Loan_Account__c objcontract;
    public static Account objpersonaccount;
    public static Account objbusinessaccount;
    public static Contact objcontact;
    public static collect__Queue_Contract__c objqueuecontract;
    public static collect__Collection_Activity__c objactivity;
    public static collect__Interaction_Log__c objlog;
    public static collect__Action_Code__c objcode;
    public static collect__Action_Code_Config__c objcodeconfig;
    public static collect__Status_Config__c objstatusconfig;
    public static ScCollection_Status_Counter_Settings__c objcustomsettings;
    public static ScCollection_Settings__c objsettings;
    public static collect__Collection_Settings__c objcollsettings;
    public static ScCollection_ContractSettings__c objconsetting;
    public static ScCollection_TriggerExecutionSettings__c objtriggersettings;
    public static collect__Bank_Account__c objCollectBank;
    public static loan__Bank_Account__c objLoanBankAc;
    public static ScCollection_Bucket_Configuration__c objBucketCustomSetting;
    public static ScCollection_Targer_Arrears_Index__c objTargetCustomSetting;
    public static User objUser;
    public static Lead thisLead;
    public static Property_Insurance__c objPropIns;
    
    // Insert object of collect__Queue__c
    public static collect__Queue__c createTestQueue(String strqueuename) 
    {
        objQueue = new collect__Queue__c();
        objQueue.Name = strqueuename;
        insert objQueue;
        return objQueue;
    }
    
    // insert object of collect__Queue_User__c 
    public static collect__Queue_User__c createTestQueueUser(String strqueueid, String struserid)
    {
        objQueueUser = new collect__Queue_User__c();
        objQueueUser.Name = 'Test User';
        objQueueUser.collect__Queue__c = strqueueid;
        objQueueUser.collect__User__c = struserid;
        insert objQueueUser;
        return objQueueUser;
    }
    
    // insert object of collect__Source_System__c
    public static collect__Source_System__c createTestSourceSystem(String strsourcename)
    {
        objsourcesystem = new collect__Source_System__c();
        objsourcesystem.Name = strsourcename;
        insert objsourcesystem;
        return objsourcesystem;
    }
    
    // insert object of collect__Loan_Account__c 
    public static collect__Loan_Account__c createTestContract(String strsourceid)
    {
        objcontract = new collect__Loan_Account__c();
        objcontract.Name = '1234';
        objcontract.collect__External_ID__c = 'PAF:1234';
        objcontract.collect__Source_System__c = strsourceid;
        objcontract.collect__Delinquent_Amount__c = 8000;
        insert objcontract;
        return objcontract;
    }

    // insert object of collect__Bank_Account__c 
    public static collect__Bank_Account__c createTestBankAccount(String strsourceid)
    {
        objCollectBank = new collect__Bank_Account__c();
        objCollectBank.Name = 'TestBank';
        objCollectBank.collect__Source_System__c = strsourceid;
        objCollectBank.collect__External_ID__c = 'TESTBANKID';
        
        objCollectBank.ScCollection_Account_Name__c = 'Test Account Name'; 
        objCollectBank.collect__Bank_Account_Number__c = '12345678'; 
        objCollectBank.ScCollection_BSB_Code__c = '123456'; 
        objCollectBank.collect__Routing_Number__c = '132456';
        
        insert objCollectBank;
        return objCollectBank;
    }

    public static loan__Bank_Account__c createTestLoanBankAccount(Id aAccount)
    {
        objLoanBankAc = new loan__Bank_Account__c();
        
        objLoanBankAc.loan__Account__c = aAccount;
        objLoanBankAc.Account_Holder_Name__c = 'Test Account Name';
        
        objLoanBankAc.loan_Bank_Account_Name__c = 'Test Account Name'; 
        objLoanBankAc.loan__Bank_Account_Number__c = '12345678'; 
        objLoanBankAc.Bank_Account_Number__c = '12345678'; 
        objLoanBankAc.loan__Bank_Name__c = 'Test Bank'; 
        objLoanBankAc.BSB__c = '132456';
        objLoanBankAc.loan__Routing_Number__c = '132456';
        
        insert objLoanBankAc;
        return objLoanBankAc;
    }
    
    // insert object of person account
    public static Account createTestPersonAccount()
    {
        RecordType personAccountRecordType = [select Id from RecordType where DeveloperName = 'ScCollection_Person_Account_CL' and SObjectType = 'Account'];
        
        objpersonaccount = new Account();
        objpersonaccount.lastName = 'Test Accnt';
        objpersonaccount.RecordType = personAccountRecordType;
        objpersonaccount.Salutation = 'Ms';
        objpersonaccount.PersonMobilePhone = '9867436729' ;
        objpersonaccount.PersonHomePhone = '01207428737' ;
        objpersonaccount.FirstName='Test FName';
        objpersonaccount.PersonMailingStreet='test@yahoo.com';
        objpersonaccount.PersonMailingPostalCode='12345';
        objpersonaccount.PersonMailingCity='SFO';
        objpersonaccount.PersonEmail='test@yahoo.com';
        objpersonaccount.PersonHomePhone='1234567';
        objpersonaccount.PersonMobilePhone='12345678';
        objpersonaccount.Phone='0414136952';
        objpersonaccount.pepOTP_Email__c='test@yahoo.com';
        objpersonaccount.CRM_Mtg_Email__c='test@yahoo.com';
        objpersonaccount.ScCollection_Home_Email__pc='test@yahoo.com';
        objpersonaccount.PersonAssistantPhone='0414136952';
        objpersonaccount.PersonOtherPhone='0414136952';
        objpersonaccount.Phone1__c='0414136952';
        objpersonaccount.ScCollection_Next_of_Kin_Email__pc='test@gmail.com';
        objpersonaccount.ScCollection_Power_of_Attorney_Email__pc='test@gmail.com';
        objpersonaccount.ScCollection_Main_Bus_Phone__pc='0414136952';
        objpersonaccount.ScCollection_Next_of_Kin_Home_Phone__pc='0414136952';
        objpersonaccount.ScCollection_Next_of_Kin_Mobile__pc='0414136952';
        objpersonaccount.ScCollection_Power_Attorney_Home_Ph_No__pc='0414136952';
        objpersonaccount.ScCollection_Power_Attorney_Mobile_No__pc='0414136952';
        objpersonaccount.ScCollection_Previous_Mobile__pc='0414136952';
        objpersonaccount.ScCollection_Work_Phone__pc='0414136952';
        
        
        insert objpersonaccount;
        return objpersonaccount;
    }
    
    // insert object of business account
    public static Account createTestBusinessAccount()
    {
        RecordType AccountRecordType = [select Id from RecordType where DeveloperName = 'ScCollection_Business_Account_CL' and SObjectType = 'Account'];
        
        objbusinessaccount = new Account();
        objbusinessaccount.lastName = 'Test Accnt';
        objbusinessaccount.RecordType = AccountRecordType;
        insert objbusinessaccount;
        return objbusinessaccount;
    }
    
    // insert object of contact
    public static Contact createTestContact()
    {
        objcontact = new Contact();
        objcontact.Account = objbusinessaccount;
        objcontact.Salutation = 'Ms';
        objcontact.LastName = 'Test Contact';
        objcontact.MobilePhone = '9867436729';
        objcontact.HomePhone = '01207428737' ;
        objcontact.Email='tyu@gmail.com';
        objcontact.FirstName = 'abc';
        objcontact.Phone = '0414136952';
        objcontact.HomePhone = '0414136952';
        objcontact.MobilePhone = '0414136952';
        insert objcontact;
        return objcontact;
    }
    
    // insert object of queue contract
    public static collect__Queue_Contract__c createTestQueueContract(String strqueueid, String strcontractid, String struserid)
    {
        objqueuecontract = new collect__Queue_Contract__c();
        objqueuecontract.Name = 'sampleQueConttTest';
        objqueuecontract.collect__Queue__c = strqueueid;
        objqueuecontract.collect__Loan_Account_Id__c = strcontractid;
        objqueuecontract.collect__Status__c = 'Open';
        objqueuecontract.collect__User__c = struserid;
        insert objqueuecontract;
        return objqueuecontract;
    }
    
    // insert object of collection activity
    public static collect__Collection_Activity__c createTestActivity(String strcontractid)
    {
        objactivity = new collect__Collection_Activity__c();
        objactivity.collect__Activity_Date__c = System.Now();
        objactivity.collect__Action__c = 'Follow Up' ;
        objactivity.collect__Completed__c = false ;
        objactivity.collect__Dev_Contract__c = strcontractid;
        insert objactivity;
        return objactivity;
    }
    
    // insert object of interaction log
    public static collect__Interaction_Log__c createTestLog(String strcontractid)
    {
        objlog = new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = strcontractid ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        insert objlog;
        return objlog;
    }
    
    // insert object of action code
    public static collect__Action_Code__c createTestActionCode(String strcodename)
    {
        objcode = new collect__Action_Code__c();
        objcode.Name = strcodename;
        objcode.ScCollection_Status_Fiels_Api_Name__c = 'ScCollection_Arrears__c';
        insert objcode;
        return objcode;
    }
    
    //inserts object of code config
    public static collect__Action_Code_Config__c createTestCodeConfig(String strcodeid, String strsourceid)
    {
        objcodeconfig = new collect__Action_Code_Config__c();
        objcodeconfig.collect__Action_Code__c = strcodeid;
        objcodeconfig.collect__Source_System__c = strsourceid;
        insert objcodeconfig;
        return objcodeconfig;
    }
    
    //inserts object of status config
    public static collect__Status_Config__c createTestStatusConfig(String strsourceid)
    {
        objstatusconfig = new collect__Status_Config__c();
        objstatusconfig.collect__Source_System__c  = strsourceid ;
        objstatusconfig.collect__Status_API_Name__c = 'ScCollection_Arrears__c';
        objstatusconfig.collect__Allowed_Statuses__c = 'First Payment Default; New Work';
        insert objstatusconfig;
        return objstatusconfig;
    }
    
    //inserts object of custom status counter settings
    public static ScCollection_Status_Counter_Settings__c createTestCustomSettings()
    {
        objcustomsettings = new ScCollection_Status_Counter_Settings__c();
        objcustomsettings.ScCollection_Include__c = true;
        objcustomsettings.scCollection_Object_Api_Name__c = 'collect__Contract_Status__c';
        objcustomsettings.ScCollection_Date_Field_Api_Name__c = 'NA';
        objcustomsettings.ScCollection_Counter_Field_Api_Name__c = 'ScCollection_hardship_Acceptance_Counter__c';
        objcustomsettings.ScCollection_Values__c= 'INBOUND - PTP - One-off,INBOUND - PTP Arrangement,OUTBOUND - PTP Arrangement,OUTBOUND PTP - one-off';
        objcustomsettings.Name = 'Max Days Setting' ;
        insert objcustomsettings;
        return objcustomsettings;
    }
    
    //inserts object of custom settings
    public static ScCollection_Settings__c createTestSettings()
    {
        objsettings = new ScCollection_Settings__c();
        objsettings.ScCollection_MaxDaysNoPromise__c = 4;
        objsettings.ScCollection_MaxDaysWithPromise__c = 5;
        insert objsettings;
        return objsettings;
    }
    
    //inserts object of collect__Collection_Settings__c
    public static collect__Collection_Settings__c createTestCollectionSettings()
    {
        objcollsettings = new collect__Collection_Settings__c();
        objcollsettings.collect__Enable_Loan_Integration__c = true;
        objcollsettings.collect__Enable_Third_Party_Integration__c = true;
        objcollsettings.collect__Save_Dunning_Letters__c = true;
        objcollsettings.collect__Activate_Broken_Promise_Alerts__c = true;
        objcollsettings.collect__Namespace_Prefix_Collections__c = 'collect';
        insert objcollsettings;
        return objcollsettings;
    }
    
    //inserts object of collect__Collection_Settings__c
    public static ScCollection_ContractSettings__c createTestContractSettings()
    {
        objconsetting = new ScCollection_ContractSettings__c();
        insert objconsetting;
        return objconsetting;
    }
    
    //inserts object of trigger execution custom settings
    public static ScCollection_TriggerExecutionSettings__c createTestTriggerSettings()
    {
        objtriggersettings = new ScCollection_TriggerExecutionSettings__c();
        objtriggersettings.Name = 'All Trigger Execution';
        objtriggersettings.ScCollection_BankAccountTrigger__c = true;
        objtriggersettings.ScCollection_ContractSettingTrigger__c = true;
        objtriggersettings.ScCollection_ContractStatusTrigger__c = true;
        objtriggersettings.ScCollection_CollectionContractTrigger__c = true;
        objtriggersettings.ScCollection_PromiseToPayTrigger__c = true;
        objtriggersettings.ScCollectionQueueContractTrigger__c = true;
        insert objtriggersettings;
        return objtriggersettings;
    }

    // insert object of ScCollection_Bucket_Configuration__c 
    public static ScCollection_Bucket_Configuration__c createTestBucketConfig()
    {
        objBucketCustomSetting = new ScCollection_Bucket_Configuration__c();
        objBucketCustomSetting.ScCollection_MaxDPD1__c = 30;
        objBucketCustomSetting.ScCollection_MinDPD1__c = 1;
        objBucketCustomSetting.ScCollection_Max2__c = 60;
        objBucketCustomSetting.ScCollection_Min2__c = 31;
        objBucketCustomSetting.ScCollection_Max3__c = 90;
        objBucketCustomSetting.ScCollection_Min3__c = 61;
        objBucketCustomSetting.ScCollection_Max4__c = 120;
        objBucketCustomSetting.ScCollection_Min4__c = 91;
        objBucketCustomSetting.ScCollection_Min5__c = 121;
        objBucketCustomSetting.ScCollection_Number_of_Buckets__c = 5;
        insert objBucketCustomSetting;
        return objBucketCustomSetting;
    }

    // insert object of ScCollection_Targer_Arrears_Index__c 
    public static ScCollection_Targer_Arrears_Index__c createTestTargetIndex()
    {
        objTargetCustomSetting = new ScCollection_Targer_Arrears_Index__c();
        objTargetCustomSetting.name = 'CL Loan';
        objTargetCustomSetting.ScCollection_April_Target_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_August_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_Dec_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_Feb_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_Jan_Target__c = 10;
        objTargetCustomSetting.ScCollection_July_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_June_Arrears_Index_Target__c = 10;
        objTargetCustomSetting.ScCollection_March_Target_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_May_Target_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_Nov_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_Oct_Arrears_Index__c = 10;
        objTargetCustomSetting.ScCollection_Sep_Arrears_Index__c = 10;
        insert objTargetCustomSetting;
        return objTargetCustomSetting;
    }
    
    // Insert object of User
    public static User createTestUser(String strusername, String strprofileid) 
    {
        
        
        objUser = new User();
        objUser.UserName = strusername;
        objUser.ProfileId = strprofileid;
        objUser.email = 'CA-Test@gmail.com'; 
        objUser.alias = 'tuser1';
        objUser.TimeZoneSidKey = 'America/New_York'; 
        objUser.LocaleSidKey = 'en_US'; 
        objUser.EmailEncodingKey = 'ISO-8859-1'; 
        objUser.LanguageLocaleKey = 'en_US';
        objUser.FirstName = 'Sunny';
        objUser.LastName = 'Sharma' ;
        objUser.Phone='8989898989';
        objUser.MobilePhone='9889823456';
        objUser.IsActive = true;
        insert objUser;
        return objUser;
    }
    
    // Insert object of User
    public static User createTestUserRole(String strusername, String strprofileid,Id roleId) 
    {
        
        UserRole  r = [Select Id from UserRole where developername='CEO' limit 1];
        objUser = new User();
        objUser.UserName = strusername;
        objUser.ProfileId = strprofileid;
        objUser.email = 'CA-Test@gmail.com'; 
        objUser.alias = 'tuser1';
        objUser.TimeZoneSidKey = 'America/New_York'; 
        objUser.LocaleSidKey = 'en_US'; 
        objUser.EmailEncodingKey = 'ISO-8859-1'; 
        objUser.LanguageLocaleKey = 'en_US';
        objUser.FirstName = 'Sunny';
        objUser.LastName = 'Sharma' ;
        objUser.Phone='8989898989';
        objUser.MobilePhone='9889823456';
        objUser.IsActive = true;
        objUser.UserRoleId = roleId;
        insert objUser;
        return objUser;
    }
    
    public static User createTestUser(String strusername, String strprofileid, string contactId) 
    {
        objUser = new User();
        objUser.UserName = strusername;
        objUser.ProfileId = strprofileid;
        objUser.email = 'CA-Test@gmail.com'; 
        objUser.alias = 'tuser1';
        objUser.TimeZoneSidKey = 'America/New_York'; 
        objUser.LocaleSidKey = 'en_US'; 
        objUser.EmailEncodingKey = 'ISO-8859-1'; 
        objUser.LanguageLocaleKey = 'en_US';
        objUser.FirstName = 'Sunny';
        objUser.LastName = 'Sharma' ;
        objUser.Phone='8989898989';
        objUser.MobilePhone='9889823456';
        objUser.IsActive = true;
        objUser.ContactId = contactId;
        insert objUser;
        return objUser;
    }
    
    public static Lead createTestLead(){
        thisLead = new Lead(
        
        	FirstName = 'Lea', 
            LastName = 'DTest',
            MiddleName = 'Bob', 
            Email = 'test@gmail.com', 
            Fax = '1004634254254', 
            MobilePhone = '348434384354', 
            Phone = '354533434354354', 
            CRM_DOB__c = Date.newInstance(1977, 12, 07),
            CRM_Email__c = 'test@gmail.com', 
            CRM_Work_Phone__c = '653545254035403'
        );
        insert thisLead;
        return thisLead;
    }
    
    public static Property_Insurance__c createTestPropertyInsurance(){
        objPropIns = new Property_Insurance__c (
        
        	Mobile_Phone__c = '43453545321'
        
        
        );
        
        insert objPropIns;
        return objPropIns;
    }
}
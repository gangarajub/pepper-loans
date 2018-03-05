// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CollectionContractHanler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestCollectionContractHan
{


    // code added by deepak on nov 11
    static testMethod void createContractStatus_Mortgate() 
    {
        test.StartTest();
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            CRM_Mtg_Unique_Id__c =111245
            );   
            
        insert u; 
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;
        
        Date dt = System.Today();
        
        CRM_Mtg_BDM_Target__c objBdmTarget = 
            new CRM_Mtg_BDM_Target__c(
            Name = '123456-Mar-2017',
            CRM_Mtg_BDM_Unique_Id__c = 111245,
            CRM_Mtg_Month__c = 'Mar',
            CRM_Mtg_Year__c = String.valueOf(System.Today().Year()),
            CRM_Mtg_Default_Record__c = true);
            
            insert objBdmTarget;
            
            CRM_Mtg_Application_Target__c objAppTarget = 
            new CRM_Mtg_Application_Target__c(
            CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
            CRM_Mtg_Channel__c = 'White Label',
            CRM_Mtg_Product__c = 'Prime',
            CRM_Mtg_Target_Applications_Amt__c = 0.0,
            CRM_Mtg_Target_Applications__c = 0.0,
            CRM_Mtg_Unique_Identifier__c = '123111');
            insert objAppTarget;
            
            CRM_Mtg_Settlement_Target__c objSettTarget = 
            new CRM_Mtg_Settlement_Target__c(
            CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
            CRM_Mtg_Channel__c = 'White Label',
            CRM_Mtg_Product__c = 'Prime',
            CRM_Mtg_Target_Settlements_Amt__c = 0.0,
            CRM_Mtg_Target_Settlements__c = 0.0);
            insert objSettTarget;
            
            CRM_Mortgage_Application_Data__c objMortData = 
                new CRM_Mortgage_Application_Data__c(
                Name = '600040',
                CRM_Mtg_Doc_Header_Id__c = '123549',
                CRM_Mtg_Application_Target__c = objAppTarget.Id,
                CRM_Mtg_Settlement_Target__c = objSettTarget.Id,
                CRM_Mtg_Aggregator_Id__c = '1211',
                CRM_Mtg_Application_Date__c = Date.newInstance(dt.Year(),dt.Month(),dt.Day()-10),
                CRM_Mtg_Application_Id__c = '123456',
                CRM_Mtg_Broker_Id__c = '1213',
                CRM_Mtg_Total_Loan_Amount__c = 1141000.0,
                CRM_Mtg_Channel__c = 'Retail',
                CRM_Mtg_Product__c = 'product');

            insert objMortData;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem1.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Settled';
        objContract.ScCollection_Application_Id__c = '123456';
        insert objContract;
        
        test.StopTest();
    }
    
    
    // code added by deepak on nov 11
    static testMethod void createContractStatus_Mortgate_SUB_Status_Discpending() 
    {
    test.StartTest();
         Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem1.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Dis Pending';
        insert objContract;
        
        test.StopTest();
    }
    
  
    // code added by deepak on nov 11
    static testMethod void createContractStatus_Mortgate_SUB_Status_Discharged() 
    {
    test.StartTest();  
         Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem1.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Misc Status';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Discharged';
        insert objContract;
        test.StopTest();
    }
    
    
    // code added by deepak on nov 11
    static testMethod void createContractStatus_DefaultOfficer() 
    {
    test.StartTest();
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Arrears';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Default - Collections Officer';
        insert objContract;
        test.StopTest();
    }
    
    
    // code added by deepak on nov 11
    static testMethod void createContractStatus_Remarketing_Case1() 
    {
    test.StartTest();
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Remarketing';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Default - Collections Officer';
        insert objContract;
        test.StopTest();
    }
    
   
    // code added by deepak on nov 11
    static testMethod void createContractStatus_Remarketing_Case2() 
    {
    test.StartTest(); 
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Remarketing';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Repossessed';
        insert objContract;
        test.StopTest();
    }
    
    
    // code added by deepak on nov 11
    static testMethod void createContractStatus_Remarketing_Case3() 
    {
    test.StartTest();
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Remarketing';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Redemption Expired';
        insert objContract;
        test.StopTest();
    }
    
   
    // code added by deepak on nov 11
    static testMethod void createContractStatus_Remarketing_Case4() 
    {
    test.StartTest(); 
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Remarketing';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Early Payout-Sale of Asset';
        insert objContract;
        test.StopTest();
    }
    
   
    static testMethod void myUnitTest() 
    {
     
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestBusinessAccount();
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();

        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Source_System__c objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        collect__Bank_Account__c objBankacc = new collect__Bank_Account__c();
        objBankacc.collect__Account__c = objAccount.id;
        insert objBankAcc;
        
        collect__Bank_Account__c objBankacc1 = new collect__Bank_Account__c();
        objBankacc1.collect__Contact__c = objContact.id;
        insert objBankAcc1;

        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name = 'Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c = 80;
        objContract.collect__Account__c = objAccount.id;
        objContract.ScCollection_Loan_Status_Description__c = 'Arrears';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Overdue';
        objContract.ScCollection_Bucket__c = 0;
        insert objContract;
         
        collect__Loan_Account__c objContract2 = new collect__Loan_Account__c();
        objContract2.Name = 'Contract-001';
        objContract2.collect__Source_System__c = objSourceSystem.id ;
        objContract2.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract2.collect__Delinquent_Amount__c = 80;
        objContract2.collect__Contact__c = objContact.id;
        insert objContract2 ;
        test.StartTest(); 
        collect__Loan_Account__c objContract1 = new collect__Loan_Account__c();
        objContract1.Name = 'Contract-001';
        objContract1.collect__Source_System__c = objSourceSystem1.id ;
        objContract1.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract1.collect__Delinquent_Amount__c = 80;
        objContract1.collect__Contact__c = objContact.id;
        insert objContract1 ;

        objContract.ScCollection_Loan_Sub_status_description__c = 'Default-Collection Officer';
        update objContract;
        
        objContract.ScCollection_Loan_Status_Description__c = 'Remarketing';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Default-External Agent';
        update objContract;
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Repossessed';
        update objContract;
        objContract.ScCollection_Loan_Sub_status_description__c = 'Redemption Expired';
        update objContract;
        objContract.ScCollection_Loan_Sub_status_description__c = 'Early Payout-Sale of Asset';
        update objContract;
        objContract.ScCollection_Loan_Status_Description__c = 'Misc Status';
        update objContract;
        
        objContract.ScCollection_Loan_Sub_status_description__c = 'Current';
        update objContract;
        objContract.ScCollection_Loan_Sub_status_description__c = 'Closed - Early Payout';
        update objContract;
        objContract.ScCollection_Loan_Sub_status_description__c = 'Closed - Maturity';
        update objContract;
        
        ScCollection_CollectionContractHanler  objCollectionContractHanler = new ScCollection_CollectionContractHanler();
        objContract.ScCollection_Loan_Status_Description__c = 'Arrears';
        objContract.ScCollection_Loan_Sub_status_description__c = 'Default-Collection Officer';
        objContract.ScCollection_Bucket__c = 1;
        update objContract;
        test.StopTest();
    } 
    
      
    @isTest static void test0(){
    test.StartTest();
        collect__Queue__c objQueue;
        collect__Source_System__c  obSource;
        collect__Loan_Account__c  objClContract;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(
              Alias = 'testuaa',
              Email = 'testaaaa@unitingambition.com',
              EmailEncodingKey = 'UTF-8',
              LastName = 'Test',
              LanguageLocaleKey = 'en_US',
              LocaleSidKey = 'en_US',
              TimeZoneSidKey='America/Los_Angeles',
              ProfileId = p.Id,
              UserName='tesaaaaat@unitingambition.com',
              ScCollection_UserType__c = 'Manager'
            );

    
       
        insert u;
        
        system.RunAs(u){
            
            objQueue = ScCollection_CommonTrackerClass.createTestQueue('MORTGAGE HARDSHIP QUEUE TEST');
            objQueue.collect__Permanent__c = true;
            objQueue.collect__Enabled__c = true;
            update objQueue;
            obSource = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
            objClContract=  ScCollection_CommonTrackerClass.createTestContract(obSource.id);
            
            objClContract.ScCollection_MDO__c = true;
            update objClContract;
            collect__Queue_Contract__c objQueueCon = ScCollection_CommonTrackerClass.createTestQueueContract(objQueue.id,objClContract.id,u.id);
            objClContract.ScCollection_MDO__c = false;
            update objClContract;
            
            
            collect__Loan_Account__c  objcontract = new collect__Loan_Account__c();
            objcontract.Name = '1234_0';
            objcontract.collect__External_ID__c = 'MORTGAGE:123';
            objcontract.collect__Source_System__c = obSource.Id;
            objcontract.collect__Delinquent_Amount__c = 1;
            objcontract.ScCollection_Daily_Contact_Counter__c =1;
            objcontract.ScCollection_Counter_Processed_Date__c = System.today();
            insert objcontract;
            
           
            objcontract.ScCollection_Daily_Contact_Counter__c = 5;
            update objcontract;
            collect__Source_System__c  obSourceMortgage = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
            collect__Loan_Account__c  objcontract1 = new collect__Loan_Account__c();
            objcontract1.Name = '12314_0';
            objcontract1.collect__External_ID__c = 'MORTGAGE:12311';
            objcontract1.collect__Source_System__c = obSourceMortgage.Id;
            objcontract1.collect__Delinquent_Amount__c = 1;
            objcontract1.ScCollection_Letter_Produced_Code__c ='a';
            objcontract1.ScCollection_Counter_Processed_Date__c = System.today();
            insert objcontract1;
            
            
            objcontract.ScCollection_Letter_Produced_Code__c = 'b';
            
            update objcontract;
        }
        
        u.ScCollection_UserType__c ='CO';
        //update u;
        
        system.RunAs(u){
            collect__Queue_Contract__c objQueueCon = ScCollection_CommonTrackerClass.createTestQueueContract(objQueue.id,objClContract.id,u.id);
            objClContract.ScCollection_MDO__c = true;
            update objClContract;
            objClContract.ScCollection_MDO__c = false;
            update objClContract;
            
        } 
        test.StopTest();
    }
    
    @isTest static void testContract(){
       test.StartTest(); 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(
              Alias = 'testuaa',
              Email = 'testaaaadsdss@unitingambition.com',
              EmailEncodingKey = 'UTF-8',
              LastName = 'Test',
              LanguageLocaleKey = 'en_US',
              LocaleSidKey = 'en_US',
              TimeZoneSidKey='America/Los_Angeles',
              ProfileId = p.Id,
              UserName='tesaaaaasdfdft@unitingambition.com'
            );

    
       
        insert u;
        
        system.RunAs(u){
            collect__Queue__c objQueue = ScCollection_CommonTrackerClass.createTestQueue('MORTGAGE HARDSHIP QUEUE TEST');
            objQueue.collect__Permanent__c = true;
            objQueue.collect__Enabled__c = true;
            update objQueue;
        
            collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
            
            collect__Contract_Status__c objStatus = new collect__Contract_Status__c ();
            insert objStatus ;
             
            Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
            
            collect__Loan_Account__c objContract = new collect__Loan_Account__c();
            objContract.Name = 'Contract-0011';
            objContract.collect__Source_System__c = objSourceSystem.id ;
            objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
            objContract.collect__Delinquent_Amount__c = 80;
            objContract.collect__Account__c = objAccount.id;
            objContract.ScCollection_Loan_Status_Description__c = 'Arrears';
            objContract.ScCollection_Loan_Sub_status_description__c = 'Overdue';
            objContract.ScCollection_Bucket__c = 0;
            objContract.ScCollection_Management_Notes__c ='hahah';
            objContract.collect__Collection_Status__c = objStatus.id;
            objContract.ScCollection_Exclude_from_strategy__c  = false;
            insert objContract;
            
            objContract.ScCollection_Exclude_from_strategy__c = true;
            update objContract;
        }
         test.StopTest();
    }
    @isTest Static void testCounter(){
        
        List<collect__Collections_Metrics_Settings__c> thresholds = new List<collect__Collections_Metrics_Settings__c>();
        collect__Collections_Metrics_Settings__c t1 = new collect__Collections_Metrics_Settings__c(
        	Name = 'Weekly',
            collect__Contact_Count_Threshold__c = 10,
            collect__Threshold_Days__c = 7            
        );
        thresholds.add(t1);
        collect__Collections_Metrics_Settings__c t2 = new collect__Collections_Metrics_Settings__c(
        	Name = 'Monthly',
            collect__Contact_Count_Threshold__c = 30,
            collect__Threshold_Days__c = 30            
        );
        thresholds.add(t2);
		insert thresholds;        
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Source_System__c objSourceSystemMortgage = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        List<collect__Loan_Account__c> lst = new List<collect__Loan_Account__c>();
        collect__Loan_Account__c  objcontract = new collect__Loan_Account__c();
        objcontract.Name = '1234';
        objcontract.collect__External_ID__c = 'PAF:123';
        objcontract.collect__Source_System__c = objSourceSystem.Id;
        objcontract.collect__Delinquent_Amount__c = 1;
        objcontract.ScCollection_Daily_Contact_Counter__c =1;
        objcontract.ScCollection_Counter_Processed_Date__c = System.today();
        lst.add(objcontract);
        collect__Loan_Account__c  objcontract1 = new collect__Loan_Account__c();
        objcontract1.Name = '12_0';
        objcontract1.collect__External_ID__c = 'MORTGAGE:12';
        objcontract1.collect__Source_System__c = objSourceSystemMortgage.Id;
        objcontract1.collect__Delinquent_Amount__c = 1;
        objcontract1.ScCollection_Daily_Contact_Counter__c =1;
        objcontract1.ScCollection_Counter_Processed_Date__c = System.today();
        lst.add(objcontract1);
        
        insert lst;
        
        objcontract.ScCollection_Daily_Contact_Counter__c = 1;
        objcontract.ScCollection_Counter_Processed_Date__c = System.today() + 2;
        update objcontract;
        objcontract1.ScCollection_Daily_Contact_Counter__c = 1;
        objcontract1.ScCollection_Counter_Processed_Date__c = System.today() + 2;
        update objcontract1;
    }
}
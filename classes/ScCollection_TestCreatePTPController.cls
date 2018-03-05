// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CreatePTPController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestCreatePTPController 
{
    public static collect__Source_System__c objSourceSystem;
    public static collect__Source_System__c objSourceSystem1;
    public static collect__Loan_Account__c objContract;
    public static loan__Loan_Account__c objplcontract;
    public static ScCollection_Settings__c objCollectionSetting;
    public static collect__Contract_Status__c objStatus;
    public static collect__Bank_Account__c objBankAcc;
    
    public static void loaddata(String ss)
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem(ss);
        objSourceSystem1 = ScCollection_CommonTrackerClass.createTestSourceSystem('CL LOAN');
        
        objStatus = new collect__Contract_Status__c();
        objStatus.ScCollection_Promise_Hold_From__c = System.Today() + 1;
        objStatus.ScCollection_Promise_Hold_To__c = System.Today() + 4;
        insert objStatus;
        
        objBankAcc = new collect__Bank_Account__c();
        objBankAcc.Name = 'test BankAcc';
        objBankAcc.ScCollection_BSB_Code__c = '1234';
        objBankAcc.ScCollection_Account_Name__c = 'Acc Name';
        insert objBankAcc;
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.collect__Amount_to_Current__c = 5000;
        objContract.ScCollection_Current_Principal__c = 3000;
        objContract.ScCollection_Account_Number__c = '222212233222'; 
        objContract.collect__Collection_Status__c = objStatus.Id;
        objContract.ScCollection_Arrears__c = 2000;
        objContract.ScCollection_Rental_Amount__c = 2000;
        objContract.ScCollection_Account_Keeping_Fees__c = 200;
        objContract.ScCollection_Bank_Account__c = objBankAcc.Id;
        update objContract;
        
        
        //insert custom settings        
        objCollectionSetting = ScCollection_CommonTrackerClass.createTestSettings();
        objCollectionSetting.ScCollection_MaxPromiseDaysCount__c = 120;
        objCollectionSetting.ScCollection_MaxPromiseDaysCountPromise1__c = 40;
        objCollectionSetting.ScCollection_MinAcceptCommitment__c = 12;
        update objCollectionSetting;
    }
    
    @isTest
    static void testConstructor()
    {
        loaddata('PAF');           
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='One-Off';
        objarr.ScCollection_Payment_Method__c='Direct Debit';
        insert objarr;
          
        collect__Promise_To_Pay__c objpr = new collect__Promise_To_Pay__c();
        objpr.collect__Promise_To_Pay_Date__c = System.Today();
        objpr.ScCollection_Promise_To_Pay_Date__c = System.Today();
        objpr.collect__Promise_To_Pay_Amount__c = 2000;
        objpr.collect__Payment_Arrangement__c = objarr.Id;
        objpr.collect__Dev_Contract__c = objContract.Id;
        insert objpr;   
        
        //Test 1
        System.currentPageReference().getParameters().put('id', objContract.Id);
        System.currentPageReference().getParameters().put('tabid', 's001');
        System.currentPageReference().getParameters().put('refresh', '1');
        System.currentPageReference().getParameters().put('ptpid',objpr.Id );
        ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
        
        System.assertEquals(objCollection.strTotalArrears,String.valueOf(objContract.ScCollection_Arrears__c.setScale(2)),'Success 1');
        
        objContract.ScCollection_Current_Principal__c = 0;
        objContract.ScCollection_Arrears__c = 0;
        update objContract;
        
        objarr.ScCollection_PTP_Type__c='Recurring';
        update objarr;
        
        //Test 2
        System.currentPageReference().getParameters().put('id', objContract.Id);
        System.currentPageReference().getParameters().put('ptpid',objpr.Id );
        ScCollection_CreatePTPController objCollection1 = new ScCollection_CreatePTPController();
        
        System.assertEquals(objCollection1.strTotalArrears,'0.00','Success 2');
        
        
        //Test 3
        
        
        //insert pl contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
        objplcontract.loan__ACH_Routing_Number__c = '1234523542';
        objplcontract.loan__ACH_Account_Number__c = '1234523542';
        objplcontract.loan__ACH_Bank_Name__c = 'Test Bank';
        objplcontract.loan__Delinquent_Amount__c = 2000;
        objplcontract.loan__Loan_Balance__c = 2000;
        
        update objplcontract;
        
        collect__Collection_Settings__c objcollsetting = ScCollection_CommonTrackerClass.createTestCollectionSettings();
        System.currentPageReference().getParameters().put('id', objplcontract.Id);
        System.currentPageReference().getParameters().put('ptpid',objpr.Id );
        ScCollection_CreatePTPController objCollection2 = new ScCollection_CreatePTPController();
        
        System.assertEquals(objCollection2.strBSBNo,objplcontract.loan__ACH_Routing_Number__c,'Success 3');
        
        //Test 4
        objplcontract.loan__Delinquent_Amount__c = 0;
        objplcontract.loan__Loan_Balance__c = 0;
        
        update objplcontract;
        
        System.currentPageReference().getParameters().put('id', objplcontract.Id);
        System.currentPageReference().getParameters().put('ptpid','' );
        ScCollection_CreatePTPController objCollection3 = new ScCollection_CreatePTPController();
        System.assertEquals(objCollection3.strTotalBalance,'0.00','Success 4');
    }
    
    @isTest
    static void testProcessData(){
        loaddata('PAF');
        Integer mth = System.Today().month();
        Integer numberOfDays = Date.daysInMonth(System.Today().year(), mth);
        Date dtLastdate = Date.newInstance(System.Today().year(), mth, numberOfDays);
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='Recurring';
        objarr.ScCollection_Payment_Method__c='Direct Debit';
        objarr.collect__Frequency__c = 3;
        objarr.collect__Occurence__c = 'Monthly';
        objarr.collect__Start_Date__c = dtLastdate;
        objarr.collect__Arrangement_Amount__c = 5000;
        
        //Test 1
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
        
        objCollection.strPaymentAmount = '5000';
        objCollection.objarrangement = objarr;
        objCollection.ProcessData();
        
        system.assertEquals(objCollection.lstptp.Size(),3,'Success 1');
        
        
        //Test 2
        objarr.collect__Start_Date__c = dtLastdate + 3;
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection1 = new ScCollection_CreatePTPController();
        objCollection1.strPaymentAmount = '5000';
        objCollection1.objarrangement = objarr;
        objCollection1.ProcessData();
        system.assertEquals(objCollection1.lstptp.Size(),3,'Success 2');
        
        //Test 3
        objarr.collect__Start_Date__c = dtLastdate +1;
        objarr.collect__Occurence__c = 'Fortnightly';
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection2 = new ScCollection_CreatePTPController();
        objCollection2.strPaymentAmount = '5000';
        objCollection2.objarrangement = objarr;
        objCollection2.ProcessData();
        system.assertEquals(objCollection2.lstptp.Size(),3,'Success 3');
        
        //Test 4
        objarr.collect__Start_Date__c = dtLastdate +1;
        objarr.collect__Occurence__c = 'Weekly';
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection3 = new ScCollection_CreatePTPController();
        objCollection3.strPaymentAmount = '5000';
        objCollection3.objarrangement = objarr;
        objCollection3.ProcessData();
        system.assertEquals(objCollection3.lstptp.Size(),3,'Success 4');
        
        //Test 5 Error
        objarr.collect__Start_Date__c = dtLastdate + 50;
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection4 = new ScCollection_CreatePTPController();
        objCollection4.strPaymentAmount = '5000';
        objCollection4.objarrangement = objarr;
        objCollection4.ProcessData();
        system.assertEquals(objCollection4.lstptp.Size(),0,'Success 5');
        
        //Test 6 Error
        objarr.collect__Frequency__c = 0;
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection5 = new ScCollection_CreatePTPController();
        objCollection5.strPaymentAmount = '5000';
        objCollection5.objarrangement = objarr;
        objCollection5.ProcessData();
        system.assertEquals(objCollection5.lstptp.Size(),0,'Success 6');
    }
    
    @isTest
    static void testSubmitData(){
        loaddata('PAF');
        Integer mth = System.Today().month();
        Integer numberOfDays = Date.daysInMonth(System.Today().year(), mth);
        Date dtLastdate = Date.newInstance(System.Today().year(), mth, numberOfDays);
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='Recurring';
        objarr.ScCollection_Payment_Method__c='Direct Debit';
        objarr.collect__Frequency__c = 3;
        objarr.collect__Occurence__c = 'Monthly';
        objarr.collect__Start_Date__c = dtLastdate;
        objarr.collect__Arrangement_Amount__c = 5000;
        
        ScCollection_TriggerExecutionSettings__c objTrigExec = new ScCollection_TriggerExecutionSettings__c();
        objTrigExec.Name = 'All Trigger Execution';
        objTrigExec.ScCollection_Hold_Direct_Debit__c = true;
        objTrigExec.ScCollection_Create_Direct_Debit__c = false;
        insert objTrigExec;
        
        ScCollection_PaymentAPIParameters__c objCredential = new ScCollection_PaymentAPIParameters__c();
        objCredential.Name='HoldDirectDebitPAF';
        objCredential.Username__c = 'testuser';
        objCredential.Password__c = 'testpassword';
        objCredential.Endpoint__c = 'www.google.com';
        insert objCredential;
        
        //Test 1
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
        
        objCollection.strPaymentAmount = '5000';
        objCollection.objarrangement = objarr;
        objCollection.ProcessData();
        system.assertEquals(objCollection.lstptp.Size(),3,'Success 1');
        
        objCollection.objStatus.ScCollection_Promise_Hold_From__c = System.Today() + 3;
        
        
        
        test.startTest();
        ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','',null);
        Test.setMock(HttpcalloutMock.class,successMortgageTest);
        objCollection.SubmitData();
        objTrigExec.ScCollection_Hold_Direct_Debit__c = false;
        update objTrigExec;
        objCollection.SubmitData();
        
        insert objCollection.objarrangement;
        insert objCollection.lstptp;
        objCollection.UpdateData();
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest()
    {
        loaddata('MORTGAGE');           
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='One-Off';
        objarr.ScCollection_Payment_Method__c='BPAY';
        insert objarr;
          
        collect__Promise_To_Pay__c objpr = new collect__Promise_To_Pay__c();
        objpr.collect__Promise_To_Pay_Date__c = System.Today();
        objpr.collect__Promise_To_Pay_Amount__c = 2000;
        objpr.collect__Payment_Arrangement__c = objarr.Id;
        objpr.collect__Dev_Contract__c = objContract.Id;
        insert objpr;          
          
        System.currentPageReference().getParameters().put('id', objContract.Id);
        System.currentPageReference().getParameters().put('tabid', 's001');
        System.currentPageReference().getParameters().put('refresh', '1');
        ScCollection_CreatePTPController objCollection=new ScCollection_CreatePTPController();
        objCollection.objarrangement.ScCollection_PTP_Type__c='One-Off';
        objCollection.objarrangement.ScCollection_Payment_Method__c='BPAY';
        
        objCollection.SubmitData(); 
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(-1);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection.SubmitData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(100);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection.SubmitData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection.strTotalArrears='78943';
        objCollection.strPromiseAmount='878';
        objCollection.SubmitData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9;
        objCollection.strTotalArrears='78943';
        objCollection.strPromiseAmount='878';
        objCollection.SubmitData();
        
        objCollection.strTotalArrears='78943';
        objCollection.strPromiseAmount='878'; 
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today();
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection.strContractId = objContract.id;
          
        objCollection.SubmitData(); 
        objCollection.changePTPType();
        objCollection.objarrangement.ScCollection_Payment_Method__c = 'BPAY';
        objCollection.objptp.collect__Promise_Kept__c = true;
        
        objCollection.DeleteData();
        
        objCollection.objptp.collect__Promise_Kept__c = false;
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c = System.Today();
        objCollection.objarrangement.ScCollection_Payment_Method__c = 'BPAY';
        objCollection.DeleteData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c = System.Today().addDays(2);
        objCollection.objarrangement.ScCollection_Payment_Method__c = 'Direct Debit';
        objCollection.DeleteData();
         
        System.currentPageReference().getParameters().put('ptpid', objpr.Id);
        ScCollection_CreatePTPController objCollection1 = new ScCollection_CreatePTPController();
        objCollection1.objarrangement.ScCollection_PTP_Type__c='One-Off';
        objCollection1.objarrangement.ScCollection_Payment_Method__c='BPAY';
        
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(-1);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(100);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection1.strTotalArrears='78943';
        objCollection1.strPromiseAmount='878'; 
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9;
        objCollection1.strTotalArrears='78943';
        objCollection1.strPromiseAmount='878'; 
        objCollection1.UpdateData();
        
        objCollection1.strTotalArrears='78943';
        objCollection1.strPromiseAmount='878'; 
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today();
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection1.strContractId = objContract.id;
          
        objCollection1.UpdateData();
    }
      
    static testMethod void myUnitTest1()
    {
        loaddata('MORTGAGE');
          
        System.currentPageReference().getParameters().put('id', objContract.Id);
        ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
        
        objCollection.ProcessData();          
        objCollection.SubmitData();
        
        objCollection.objarrangement.ScCollection_PTP_Type__c='Recurring';
        objCollection.objarrangement.ScCollection_Payment_Method__c='BPAY';
        objCollection.strTotalArrears='78943';
        objCollection.strPromiseAmount='878'; 
        objCollection.strContractId = objContract.id;
        
        objCollection.ProcessData();          
        objCollection.SubmitData();
        
        objCollection.objarrangement.collect__Frequency__c = 12;
        objCollection.strPaymentAmount = '5';
        objCollection.objarrangement.collect__Occurence__c = 'Weekly';
        objCollection.objarrangement.collect__Start_Date__c = System.Today().addDays(-1);
        
        objCollection.ProcessData();          
        objCollection.SubmitData();
        
        objCollection.objarrangement.collect__Start_Date__c = System.Today().addDays(10);
        objCollection.ProcessData();          
        objCollection.SubmitData();
        
        objCollection.objarrangement.collect__Frequency__c = 2;
        objCollection.objarrangement.collect__Start_Date__c = System.Today();
        objCollection.ProcessData();          
        objCollection.SubmitData();
        
        objCollection.strPaymentAmount = '5000';
        objCollection.ProcessData();          
        objCollection.SubmitData();
        objCollection.objarrangement.ScCollection_Payment_Method__c = 'Direct Debit';
        objCollection.strIndex = '1';
        objCollection.DeletePTP();
        objCollection.changePTPType();
        objCollection.objarrangement.ScCollection_Payment_Method__c = 'BPAY';
        objCollection.DeleteData();
    }
      
    static testMethod void myUnitTest2()
    {
        loaddata('MORTGAGE');
          
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='Recurring';
        objarr.ScCollection_Payment_Method__c='BPAY';
        objarr.collect__Frequency__c = 2;
        objarr.collect__Arrangement_Amount__c = 5000;
        objarr.collect__Occurence__c = 'Weekly';
        objarr.collect__Start_Date__c = System.Today();
        insert objarr;
          
        collect__Promise_To_Pay__c objpr1 = new collect__Promise_To_Pay__c();
        objpr1.collect__Promise_To_Pay_Date__c = System.Today();
        objpr1.ScCollection_Promise_To_Pay_Date__c = System.Today();
        objpr1.collect__Promise_To_Pay_Amount__c = 2500;
        objpr1.ScCollection_Promise_To_Pay_Amount__c= 2500;
        objpr1.collect__Payment_Arrangement__c = objarr.Id;
        objpr1.collect__Dev_Contract__c = objContract.Id;
        insert objpr1;
          
        collect__Promise_To_Pay__c objpr2 = new collect__Promise_To_Pay__c();
        objpr2.collect__Promise_To_Pay_Date__c = System.Today().addDays(7);
        objpr2.collect__Promise_To_Pay_Amount__c = 2500;
        objpr2.ScCollection_Promise_To_Pay_Date__c = System.Today().addDays(7);
        objpr2.ScCollection_Promise_To_Pay_Amount__c= 2500;
        objpr2.collect__Payment_Arrangement__c = objarr.Id;
        objpr2.collect__Dev_Contract__c = objContract.Id;
        insert objpr2;
          
        System.currentPageReference().getParameters().put('id', objContract.Id);
        System.currentPageReference().getParameters().put('ptpid', objpr1.Id);
        ScCollection_CreatePTPController objCollection=new ScCollection_CreatePTPController();
        objCollection.strContractId = objContract.id;
        
        objpr1.ScCollection_Promise_To_Pay_Amount__c= 5000;
        objpr2.ScCollection_Promise_To_Pay_Amount__c= 5000;
        
        objCollection.strTotalArrears='943';
        objCollection.strPromiseAmount='878'; 
        
        objCollection.UpdateData();
        objCollection.strIndex = '1';
        objCollection.DeletePTP();
        objCollection.strTotalArrears='78943';
        objCollection.UpdateData();
    }
    
    static testMethod void myUnitTest3()
    {
        loaddata('MORTGAGE');           
        
        
        //insert pl contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
        objplcontract.loan__ACH_Routing_Number__c = '1234523542';
        objplcontract.loan__ACH_Account_Number__c = '1234523542';
        objplcontract.loan__ACH_Bank_Name__c = 'Test Bank';
        objplcontract.loan__Delinquent_Amount__c = 2000;
        objplcontract.loan__Loan_Balance__c = 2000;
        
        update objplcontract;
        
        
        //insert custom settings for loan integration
        collect__Collection_Settings__c objcollsetting = ScCollection_CommonTrackerClass.createTestCollectionSettings();
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='One-Off';
        objarr.ScCollection_Payment_Method__c='BPAY';
        insert objarr;
          
        collect__Promise_To_Pay__c objpr = new collect__Promise_To_Pay__c();
        objpr.collect__Promise_To_Pay_Date__c = System.Today();
        objpr.collect__Promise_To_Pay_Amount__c = 2000;
        objpr.collect__Payment_Arrangement__c = objarr.Id;
        objpr.collect__Loan_Account_Id__c = objplContract.Id;
        insert objpr;     
        
        System.currentPageReference().getParameters().put('id', objplContract.Id);
        ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
        
        objCollection.objarrangement.ScCollection_PTP_Type__c='One-Off';
        objCollection.objarrangement.ScCollection_Payment_Method__c='BPAY';
        
        objCollection.SubmitData(); 
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(-1);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection.SubmitData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(100);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection.SubmitData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection.strTotalArrears='78943';
        objCollection.strPromiseAmount='878';
        objCollection.SubmitData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9;
        objCollection.strTotalArrears='78943';
        objCollection.strPromiseAmount='878';
        objCollection.SubmitData();
        
        objCollection.strTotalArrears='78943';
        objCollection.strPromiseAmount='878'; 
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today();
        objCollection.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection.strContractId = objplContract.id;
          
        objCollection.SubmitData(); 
        objCollection.changePTPType();
        
        objCollection.objptp.collect__Promise_Kept__c = true;
        objCollection.DeleteData();
        
        objCollection.objptp.collect__Promise_Kept__c = false;
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c = System.Today();
        objCollection.objarrangement.ScCollection_Payment_Method__c='BPAY';
        objCollection.DeleteData();
        
        objCollection.objptp.ScCollection_Promise_To_Pay_Date__c = System.Today().addDays(2);
        objCollection.objarrangement.ScCollection_Payment_Method__c='BPAY';
        objCollection.DeleteData();
         
        System.currentPageReference().getParameters().put('ptpid', objpr.Id);
        ScCollection_CreatePTPController objCollection1 = new ScCollection_CreatePTPController();
        objCollection1.objarrangement.ScCollection_PTP_Type__c='One-Off';
        objCollection1.objarrangement.ScCollection_Payment_Method__c='BPAY';
        
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(-1);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(100);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection1.strTotalArrears='0';
        objCollection1.strPromiseAmount='878'; 
        objCollection1.UpdateData();
        
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today().addDays(1);
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9;
        objCollection1.strTotalArrears='78';
        objCollection1.strPromiseAmount='0'; 
        objCollection1.UpdateData();
        
        objCollection1.strTotalArrears='78943';
        objCollection1.strPromiseAmount='878'; 
        objCollection1.objptp.ScCollection_Promise_To_Pay_Date__c=System.Today();
        objCollection1.objptp.ScCollection_Promise_To_Pay_Amount__c=9400;
        objCollection1.strContractId = objplContract.id;
          
        objCollection1.UpdateData();
    }
    
    @isTest
    static void testSyncPTP(){
        loaddata('PAF');
        Integer mth = System.Today().month();
        Integer numberOfDays = Date.daysInMonth(System.Today().year(), mth);
        Date dtLastdate = Date.newInstance(System.Today().year(), mth, numberOfDays);
        
        ScCollection_TriggerExecutionSettings__c objTrigExec = new ScCollection_TriggerExecutionSettings__c();
        objTrigExec.Name = 'All Trigger Execution';
        objTrigExec.ScCollection_Hold_Direct_Debit__c = true;
        objTrigExec.ScCollection_Create_Direct_Debit__c = false;
        insert objTrigExec;
        
        ScCollection_PaymentAPIParameters__c objCredential = new ScCollection_PaymentAPIParameters__c();
        objCredential.Name='CreateDirectDebitPAF';
        objCredential.Username__c = 'testuser';
        objCredential.Password__c = 'testpassword';
        objCredential.Endpoint__c = 'www.google.com';
        insert objCredential;
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='Recurring';
        objarr.ScCollection_Payment_Method__c='Direct Debit';
        objarr.collect__Frequency__c = 3;
        objarr.collect__Occurence__c = 'Monthly';
        objarr.collect__Start_Date__c = dtLastdate;
        objarr.collect__Arrangement_Amount__c = 5000;
        insert objarr;
          
        collect__Promise_To_Pay__c objpr = new collect__Promise_To_Pay__c();
        objpr.collect__Promise_To_Pay_Date__c = System.Today();
        objpr.collect__Promise_To_Pay_Amount__c = 2000;
        objpr.collect__Payment_Arrangement__c = objarr.Id;
        objpr.collect__Dev_Contract__c = objContract.Id;
        insert objpr; 
        ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
        test.startTest();
            
            
            ScCollection_CollectionContractMock  successtest = new ScCollection_CollectionContractMock (200,'complete','',null);
            Test.setMock(HttpcalloutMock.class,successtest);
            String str1 = objCollection.SyncDirectDebit(objarr,new List<collect__Promise_To_Pay__c>{objpr});
            
            ScCollection_CollectionContractMock  error2 = new ScCollection_CollectionContractMock (504,'complete','',null);
            Test.setMock(HttpcalloutMock.class,error2);
            String str2 = objCollection.SyncDirectDebit(objarr,new List<collect__Promise_To_Pay__c>{objpr});
            
            ScCollection_CollectionContractMock  error3 = new ScCollection_CollectionContractMock (404,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
            Test.setMock(HttpcalloutMock.class,error3);
            String str3 = objCollection.SyncDirectDebit(objarr,new List<collect__Promise_To_Pay__c>{objpr});
            
            ScCollection_CollectionContractMock  error4 = new ScCollection_CollectionContractMock (400,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
            Test.setMock(HttpcalloutMock.class,error4);
            String str4 = objCollection.SyncDirectDebit(objarr,new List<collect__Promise_To_Pay__c>{objpr});
            
            Savepoint sp = Database.setSavepoint();
            ScCollection_CollectionContractMock  strExc = new ScCollection_CollectionContractMock (200,'complete','',null);
            Test.setMock(HttpcalloutMock.class,strExc);
            String str5 = objCollection.SyncDirectDebit(objarr,new List<collect__Promise_To_Pay__c>{objpr});
            Database.rollback(sp);
            delete objCredential;
            
            ScCollection_CollectionContractMock  strError = new ScCollection_CollectionContractMock (200,'complete','',null);
            Test.setMock(HttpcalloutMock.class,strError);
            String str6 = objCollection.SyncDirectDebit(objarr,new List<collect__Promise_To_Pay__c>{objpr});
            
        test.stopTest();
        
        system.assertEquals(str1,'ok','Success');
        system.assertEquals(str2,'Critical Error – Sync Failure','Success Error');
        system.assertEquals(str3,'404 resource not found.','Success Error 1');
    }
    
    @isTest 
    static void testDeletePTP(){
        loaddata('PAF');
        
        ScCollection_TriggerExecutionSettings__c objTrigExec = new ScCollection_TriggerExecutionSettings__c();
        objTrigExec.Name = 'All Trigger Execution';
        objTrigExec.ScCollection_Delete_Direct_Debit_Paf__c = true;
        objTrigExec.ScCollection_Create_Direct_Debit__c = false;
        insert objTrigExec;
        
        ScCollection_PaymentAPIParameters__c objCredential = new ScCollection_PaymentAPIParameters__c();
        objCredential.Name='DeleteDirectDebitPAF';
        objCredential.Username__c = 'testuser';
        objCredential.Password__c = 'testpassword';
        objCredential.Endpoint__c = 'www.google.com';
        insert objCredential;
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='Recurring';
        objarr.ScCollection_Payment_Method__c='Direct Debit';
        objarr.collect__Frequency__c = 2;
        objarr.collect__Occurence__c = 'Monthly';
        objarr.collect__Start_Date__c = date.newinstance(2022,01,31);
        objarr.collect__Arrangement_Amount__c = 5000;
        insert objarr;
          
        collect__Promise_To_Pay__c objpr = new collect__Promise_To_Pay__c();
        objpr.collect__Promise_To_Pay_Date__c = date.newinstance(2022,01,31);
        objpr.collect__Promise_To_Pay_Amount__c = 2000;
        objpr.collect__Payment_Arrangement__c = objarr.Id;
        objpr.collect__Dev_Contract__c = objContract.Id;
        insert objpr; 
        
        collect__Promise_To_Pay__c objpr1 = new collect__Promise_To_Pay__c();
        objpr1.collect__Promise_To_Pay_Date__c = date.newinstance(2022,02,28);
        objpr1.collect__Promise_To_Pay_Amount__c = 2000;
        objpr1.collect__Payment_Arrangement__c = objarr.Id;
        objpr1.collect__Dev_Contract__c = objContract.Id;
        insert objpr1;
        
        List<collect__Promise_To_Pay__c> lstptp = new List<collect__Promise_To_Pay__c>();
        lstptp.add(objpr);
        lstptp.add(objpr1);
        ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
        
        test.starttest();
            
            ScCollection_CollectionContractMock  successtest = new ScCollection_CollectionContractMock (207,'complete','[{"paymentDate": "2022-01-31","success": true,"errorType": "providerError","errors": [{"category": "Invalid Business Rule.","description": "Payment amount and Effective date does not exist in the system.","pointerToViolation": ""}]},{"paymentDate": "2022-02-31","success": true,"errorType": "providerError","errors": [{"category": "Malformed Request.","description": "Provided XML is in invalid format or structure.","pointerToViolation": ""}]}]',null);
            Test.setMock(HttpcalloutMock.class,successtest);
            ScCollection_CreatePTPController.ErrorResponse str1 = objCollection.deleteDirectDebit(objarr,lstptp);
            
            ScCollection_CollectionContractMock  successtest1 = new ScCollection_CollectionContractMock (207,'complete','[{"paymentDate": "2022-01-31","success": false,"errorType": "providerError","errors": [{"category": "Invalid Business Rule.","description": "Payment amount and Effective date does not exist in the system.","pointerToViolation": ""}]},{"paymentDate": "2022-02-31","success": true,"errorType": "providerError","errors": [{"category": "Malformed Request.","description": "Provided XML is in invalid format or structure.","pointerToViolation": ""}]}]',null);
            Test.setMock(HttpcalloutMock.class,successtest1);
            ScCollection_CreatePTPController.ErrorResponse str2 = objCollection.deleteDirectDebit(objarr,lstptp);
            
            ScCollection_CollectionContractMock  fail = new ScCollection_CollectionContractMock (207,'complete','[{"paymentDate": "2022-01-31","success": false,"errorType": "providerError","errors": [{"category": "Invalid Business Rule.","description": "Payment amount and Effective date does not exist in the system.","pointerToViolation": ""}]},{"paymentDate": "2022-02-31","success": false,"errorType": "providerError","errors": [{"category": "Malformed Request.","description": "Provided XML is in invalid format or structure.","pointerToViolation": ""}]}]',null);
            Test.setMock(HttpcalloutMock.class,fail);
            ScCollection_CreatePTPController.ErrorResponse str3 = objCollection.deleteDirectDebit(objarr,lstptp);
            
            ScCollection_CollectionContractMock  fail1 = new ScCollection_CollectionContractMock (504,'complete','[{"paymentDate": "2022-01-31","success": false,"errorType": "providerError","errors": [{"category": "Invalid Business Rule.","description": "Payment amount and Effective date does not exist in the system.","pointerToViolation": ""}]},{"paymentDate": "2022-02-31","success": false,"errorType": "providerError","errors": [{"category": "Malformed Request.","description": "Provided XML is in invalid format or structure.","pointerToViolation": ""}]}]',null);
            Test.setMock(HttpcalloutMock.class,fail1);
            ScCollection_CreatePTPController.ErrorResponse str4 = objCollection.deleteDirectDebit(objarr,lstptp);
            
            ScCollection_CollectionContractMock  fail2 = new ScCollection_CollectionContractMock (404,'complete','[{"paymentDate": "2022-01-31","success": false,"errorType": "providerError","errors": [{"category": "Invalid Business Rule.","description": "Payment amount and Effective date does not exist in the system.","pointerToViolation": ""}]},{"paymentDate": "2022-02-31","success": false,"errorType": "providerError","errors": [{"category": "Malformed Request.","description": "Provided XML is in invalid format or structure.","pointerToViolation": ""}]}]',null);
            Test.setMock(HttpcalloutMock.class,fail2);
            ScCollection_CreatePTPController.ErrorResponse str5 = objCollection.deleteDirectDebit(objarr,lstptp);
            
            ScCollection_CollectionContractMock  fail3 = new ScCollection_CollectionContractMock (400,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
            Test.setMock(HttpcalloutMock.class,fail3);
            ScCollection_CreatePTPController.ErrorResponse str6 = objCollection.deleteDirectDebit(objarr,lstptp);
            
            Savepoint sp = Database.setSavepoint();
            ScCollection_CollectionContractMock  fail4 = new ScCollection_CollectionContractMock (404,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
            Test.setMock(HttpcalloutMock.class,fail4);
            ScCollection_CreatePTPController.ErrorResponse str7 = objCollection.deleteDirectDebit(objarr,lstptp);
            Database.rollback(sp);
            
            delete objCredential;
            ScCollection_CollectionContractMock  fail5 = new ScCollection_CollectionContractMock (404,'complete','{"errorType": "providerError","errors": [{"pointerToViolation": "","category": "Invalid Setup Code.","description": "Contract Number doesn’t exist in CMS."}]}',null);
            Test.setMock(HttpcalloutMock.class,fail5);
            ScCollection_CreatePTPController.ErrorResponse str8 = objCollection.deleteDirectDebit(objarr,lstptp);
        test.stoptest();
        system.assertEquals(str1.message,'ok','Success test');
        system.assertEquals(str5.message,'404 resource not found.','Fail test');
        
    }
    
    @isTest
    static void teetDeleteMethod(){
        loaddata('PAF');
        
        ScCollection_TriggerExecutionSettings__c objTrigExec = new ScCollection_TriggerExecutionSettings__c();
        objTrigExec.Name = 'All Trigger Execution';
        objTrigExec.ScCollection_Delete_Direct_Debit_Paf__c = true;
        objTrigExec.ScCollection_Create_Direct_Debit__c = false;
        insert objTrigExec;
        
        ScCollection_PaymentAPIParameters__c objCredential = new ScCollection_PaymentAPIParameters__c();
        objCredential.Name='DeleteDirectDebitPAF';
        objCredential.Username__c = 'testuser';
        objCredential.Password__c = 'testpassword';
        objCredential.Endpoint__c = 'www.google.com';
        insert objCredential;
        
        collect__Payment_Arrangement__c objarr = new collect__Payment_Arrangement__c();
        objarr.ScCollection_PTP_Type__c='Recurring';
        objarr.ScCollection_Payment_Method__c='Direct Debit';
        objarr.collect__Frequency__c = 2;
        objarr.collect__Occurence__c = 'Monthly';
        objarr.collect__Start_Date__c = date.newinstance(2022,01,31);
        objarr.collect__Arrangement_Amount__c = 4000;
        insert objarr;
          
        collect__Promise_To_Pay__c objpr = new collect__Promise_To_Pay__c();
        objpr.collect__Promise_To_Pay_Date__c = date.newinstance(2022,01,31);
        objpr.collect__Promise_To_Pay_Amount__c = 2000;
        objpr.ScCollection_Promise_To_Pay_Amount__c=2000;
        objpr.collect__Payment_Arrangement__c = objarr.Id;
        objpr.collect__Dev_Contract__c = objContract.Id;
        insert objpr; 
        
        collect__Promise_To_Pay__c objpr1 = new collect__Promise_To_Pay__c();
        objpr1.collect__Promise_To_Pay_Date__c = date.newinstance(2022,02,28);
        objpr1.collect__Promise_To_Pay_Amount__c = 2000;
        objpr1.ScCollection_Promise_To_Pay_Amount__c=2000;
        objpr1.collect__Payment_Arrangement__c = objarr.Id;
        objpr1.collect__Dev_Contract__c = objContract.Id;
        insert objpr1;
        
        List<collect__Promise_To_Pay__c> lstptp = new List<collect__Promise_To_Pay__c>();
        lstptp.add(objpr);
        lstptp.add(objpr1);
        
        test.startTest();
            System.currentPageReference().getParameters().put('id', objContract.Id);
            ScCollection_CreatePTPController objCollection = new ScCollection_CreatePTPController();
            objCollection.objarrangement = objarr;
            objCollection.lstptp = lstptp;
            ScCollection_CollectionContractMock  successtest = new ScCollection_CollectionContractMock (207,'complete','[{"paymentDate": "2022-01-31","success": true,"errorType": "providerError","errors": [{"category": "Invalid Business Rule.","description": "Payment amount and Effective date does not exist in the system.","pointerToViolation": ""}]},{"paymentDate": "2022-02-28","success": false,"errorType": "providerError","errors": [{"category": "Malformed Request.","description": "Provided XML is in invalid format or structure.","pointerToViolation": ""}]}]',null);
            Test.setMock(HttpcalloutMock.class,successtest);
            objCollection.DeleteData();
            
            List<collect__Promise_To_Pay__c> lstptp1 = new List<collect__Promise_To_Pay__c>();
            lstptp1.add(objpr);
            List<collect__Promise_To_Pay__c> lstptp2 = new List<collect__Promise_To_Pay__c>();
            lstptp2.add(objpr1);
            objCollection.objarrangement = objarr;
            objCollection.lstptp = lstptp1;
            objCollection.lstptpToRemove = lstptp2;
            ScCollection_CollectionContractMock  successtes1 = new ScCollection_CollectionContractMock (207,'complete','[{"paymentDate": "2022-02-28","success": true,"errorType": "providerError","errors": [{"category": "Malformed Request.","description": "Provided XML is in invalid format or structure.","pointerToViolation": ""}]}]',null);
            Test.setMock(HttpcalloutMock.class,successtes1);
            objCollection.UpdateData();
            
            
        test.stopTest();
        
        system.assertEquals(objCollection.lspPTPNotDeleted.size(),1,'Success test');
    }
      
}
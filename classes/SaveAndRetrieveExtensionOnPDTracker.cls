/**
 * @Created By : Sushant Kumar (14/09/2017)
 * @Description : Class is created for code coverage of SaveAndRetrieveExtensionOnPD class
 **/
@isTest(seeAllData=false)
public class SaveAndRetrieveExtensionOnPDTracker {

    	
    Static Account newAcc;
    Static PageReference pageRef;
    
    private static void createTestData() {
        
        pages_config__c pg1 = new pages_config__c(Name='peppersonaldetails',Page_Label__c='PersonalDetails');
        insert pg1;
        pages_config__c pg2 = new pages_config__c(Name='pepTechnicalException',Page_Label__c='TechnicalException');
        insert pg2;
        
        pepCommonTrackerController.createCaptchaSetting();
        loan.testhelper.createSeedDataForTesting();
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        //Creating Account
        newAcc = new Account();
        newAcc.RecordType = personAccountRecordType;
        newAcc.PersonEmail = 'sushant.kumar@saasfocus.com';
        newAcc.PersonMobilePhone = '8285035896';
        newAcc.FirstName = 'sushant';
        newAcc.LastName = 'srivastava';
        newAcc.PersonBirthdate = (System.today()).addMonths(-10);
        insert newAcc;
        
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
                
        //setting current page as Income page
        pageRef = Page.pepPersonalDetails;
        pageRef.getHeaders().put('X-Salesforce-SIP','1');
        pageRef.getParameters().put('redirectFromPageNo','1');
        Test.setCurrentPagereference(pageRef);
    }
    
    public static Account createSecondAccount(){
        
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        //Creating Account
        newAcc = new Account();
        newAcc.RecordType = personAccountRecordType;
        newAcc.PersonEmail = 'sushant.kumar@saasfocus.com';
        newAcc.PersonMobilePhone = '8285035896';
        newAcc.FirstName = 'sushant';
        newAcc.LastName = 'srivastava';
        newAcc.PersonBirthdate = (System.today()).addMonths(-10);
        insert newAcc;
        return newAcc;
    }
    
    public static TestResult  testMethod1(String inputValue, String email, String phone, String genessisStatus) {
        
        TestResult resultObj = new TestResult();
        
        createTestData();
        //Creating Genessis application
        genesis__Applications__c objApplication;
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Automated_Payment_Start_Date__c=System.Today();
        objApplication.genesis__Payment_Amount__c=2000;
        objApplication.Debit_Amount__c=2000;
        objApplication.pepCurrent_Page__c=1;
        objApplication.genesis__Account__c = newAcc.Id;
        objApplication.genesis__Status__c = genessisStatus;
        update objApplication;
        
        pepPersonalDetailsController personalDetailControolerObj = new pepPersonalDetailsController();
        personalDetailControolerObj.objModelContainer.objApplication = objApplication;
        personalDetailControolerObj.objModelContainer.objAccount = newAcc;
        SaveAndRetrieveExtensionOnPD saveAndRetrieveExtOnPdObj = new SaveAndRetrieveExtensionOnPD(personalDetailControolerObj);
        saveAndRetrieveExtOnPdObj.inputValue = inputValue;
        saveAndRetrieveExtOnPdObj.inputValueemail = email;
        saveAndRetrieveExtOnPdObj.inputValuephone = phone;
        resultObj.saveOnContinueResult = saveAndRetrieveExtOnPdObj.saveOnContinue();
        saveAndRetrieveExtOnPdObj.retrieveYes();
        resultObj.retrieveApplicationResult = saveAndRetrieveExtOnPdObj.retrieveApplication();
        saveAndRetrieveExtOnPdObj.resendCode();
        saveAndRetrieveExtOnPdObj.retrieveNoOnContinue();
        saveAndRetrieveExtOnPdObj.retrieveNo();
        saveAndRetrieveExtOnPdObj.saveControl2(personalDetailControolerObj.objModelContainer, createSecondAccount());
        saveAndRetrieveExtOnPdObj.strFlag = true;
        saveAndRetrieveExtOnPdObj.save();
        resultObj.isError = saveAndRetrieveExtOnPdObj.isError;
        return resultObj;
    }

    public static TestResult  testMethod2(String inputValue, String email, String phone) {
        
        TestResult resultObj = new TestResult();
        
        createTestData();
        //Creating Genessis application
        genesis__Applications__c objApplication;
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Automated_Payment_Start_Date__c=System.Today();
        objApplication.genesis__Payment_Amount__c=2000;
        objApplication.Debit_Amount__c=2000;
        objApplication.pepCurrent_Page__c=1;
        objApplication.genesis__Account__c = newAcc.Id;
        objApplication.genesis__Status__c = 'NEW - ENTERED';
        update objApplication;
        
        genesis__Applications__c objApplication1;
        objApplication1 = genesis.TestHelper.createApplication();
        objApplication1.Debit_Frequency__c ='bi-weekly';
        objApplication1.Automated_Payment_Start_Date__c=System.Today();
        objApplication1.genesis__Payment_Amount__c=2000;
        objApplication1.Debit_Amount__c=2000;
        objApplication1.pepCurrent_Page__c=1;
        objApplication1.genesis__Account__c = newAcc.Id;
        objApplication1.genesis__Status__c = 'NEW - ENTERED';
        update objApplication1;
        
        pepPersonalDetailsController personalDetailControolerObj = new pepPersonalDetailsController();
        personalDetailControolerObj.objModelContainer.objApplication = objApplication;
        SaveAndRetrieveExtensionOnPD saveAndRetrieveExtOnPdObj = new SaveAndRetrieveExtensionOnPD(personalDetailControolerObj);
        saveAndRetrieveExtOnPdObj.inputValue = inputValue;
        saveAndRetrieveExtOnPdObj.inputValueemail = email;
        saveAndRetrieveExtOnPdObj.inputValuephone = phone;
        resultObj.saveOnContinueResult = saveAndRetrieveExtOnPdObj.saveOnContinue();
        saveAndRetrieveExtOnPdObj.retrieveYes();
        resultObj.retrieveApplicationResult = saveAndRetrieveExtOnPdObj.retrieveApplication();
        saveAndRetrieveExtOnPdObj.resendCode();
        saveAndRetrieveExtOnPdObj.retrieveNoOnContinue();
        saveAndRetrieveExtOnPdObj.objApplicationOld = objApplication1;
        saveAndRetrieveExtOnPdObj.retrieveNo();
        resultObj.isError = saveAndRetrieveExtOnPdObj.isError;
        return resultObj;
    }    
    
    public static TestResult  testMethod4(String inputValue, String email, String phone) {
        
        TestResult resultObj = new TestResult();
        
        createTestData();
        //Creating Genessis application
        genesis__Applications__c objApplication;
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Automated_Payment_Start_Date__c=System.Today();
        objApplication.genesis__Payment_Amount__c=2000;
        objApplication.Debit_Amount__c=2000;
        objApplication.pepCurrent_Page__c=1;
        objApplication.genesis__Account__c = newAcc.Id;
        objApplication.genesis__Status__c = 'NEW - ENTERED';
        update objApplication;
        
        pepPersonalDetailsController personalDetailControolerObj = new pepPersonalDetailsController();
        personalDetailControolerObj.objModelContainer.objAccount = newAcc;
        SaveAndRetrieveExtensionOnPD saveAndRetrieveExtOnPdObj = new SaveAndRetrieveExtensionOnPD(personalDetailControolerObj);
        saveAndRetrieveExtOnPdObj.inputValue = inputValue;
        saveAndRetrieveExtOnPdObj.inputValueemail = email;
        saveAndRetrieveExtOnPdObj.inputValuephone = phone;
        saveAndRetrieveExtOnPdObj.saveOnContinue();
        saveAndRetrieveExtOnPdObj.retrieveYes();
        resultObj.retrieveApplicationResult = saveAndRetrieveExtOnPdObj.retrieveApplication();
        saveAndRetrieveExtOnPdObj.resendCode();
        resultObj.saveOnContinueResult = saveAndRetrieveExtOnPdObj.retrieveNoOnContinue();
        saveAndRetrieveExtOnPdObj.retrieveNo();
        resultObj.isError = saveAndRetrieveExtOnPdObj.isError;
        return resultObj;
    }
    
    public static TestResult  testMethod3(String inputValue, String email, String phone) {
        
        TestResult resultObj = new TestResult();
        createTestData();
        //Creating Genessis application
        genesis__Applications__c objApplication;
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        objApplication.Automated_Payment_Start_Date__c=System.Today();
        objApplication.genesis__Payment_Amount__c=2000;
        objApplication.Debit_Amount__c=2000;
        objApplication.pepCurrent_Page__c=1;
        objApplication.genesis__Account__c = newAcc.Id;
        objApplication.genesis__Status__c = 'NEW - ENTERED';
        update objApplication;
        
        pepPersonalDetailsController personalDetailControolerObj = new pepPersonalDetailsController();
        personalDetailControolerObj.objModelContainer.objApplication = objApplication;
        newAcc.LastName = null;
        personalDetailControolerObj.objModelContainer.objAccount = newAcc;
        SaveAndRetrieveExtensionOnPD saveAndRetrieveExtOnPdObj = new SaveAndRetrieveExtensionOnPD(personalDetailControolerObj);
        saveAndRetrieveExtOnPdObj.inputValue = inputValue;
        saveAndRetrieveExtOnPdObj.inputValueemail = email;
        saveAndRetrieveExtOnPdObj.inputValuephone = phone;
        resultObj.saveOnContinueResult = saveAndRetrieveExtOnPdObj.saveOnContinue();
        saveAndRetrieveExtOnPdObj.retrieveYes();
        resultObj.retrieveApplicationResult = saveAndRetrieveExtOnPdObj.retrieveApplication();
        saveAndRetrieveExtOnPdObj.resendCode();
        saveAndRetrieveExtOnPdObj.retrieveNoOnContinue();
        saveAndRetrieveExtOnPdObj.retrieveNo();
        resultObj.isError = saveAndRetrieveExtOnPdObj.isError;
        return resultObj;
    }
    
    public static testMethod void runTest1() {
        
        TestResult resultObj = testMethod1('email', 'sushant.kumar@saasfocus.com', '8285035896', 'NEW - ENTERED');
        System.assertEquals(false, resultObj.isError);
		System.assertEquals(null, resultObj.saveOnContinueResult);
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
    public static testMethod void runTest2() {
        
        TestResult resultObj = testMethod2('email', 'sushant.kumar@saasfocus.com', '8285035896');
        System.assertEquals(false, resultObj.isError);
		System.assertEquals(null, resultObj.saveOnContinueResult);
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
    
    public static testMethod void runTest3() {
        
        TestResult resultObj = testMethod1('email', 'ant.kumar@saasfocus.com', '8285035896', 'NEW - ENTERED');
        System.assertEquals(false, resultObj.isError);
		System.assertEquals(null, resultObj.saveOnContinueResult);
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
    public static testMethod void runTest4() {
        
        TestResult resultObj = testMethod1('mobile', 'ant.kumar@saasfocus.com', '8285035896', 'NEW - ENTERED');
        System.assertEquals(false, resultObj.isError);
		System.assertEquals(null, resultObj.saveOnContinueResult);
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
	public static testMethod void runTest5() {
        
        TestResult resultObj = testMethod3('email', 'ant.kumar@saasfocus.com', '8285035896');
        System.assertEquals(false, resultObj.isError);
		System.assertEquals(null, resultObj.saveOnContinueResult);
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
    public static testMethod void runTest6() {
        
        TestResult resultObj = testMethod3('mobile', '', '8285035896');
        System.assertEquals(false, resultObj.isError);
		System.assertEquals(null, resultObj.saveOnContinueResult);
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
    public static testMethod void runTest7() {
        
        TestResult resultObj = testMethod4('email', 'sushant.kumar@saasfocus.com', '8285035896');
        System.assertEquals(true, resultObj.isError);
		System.assertEquals('/TechnicalException', resultObj.saveOnContinueResult.getUrl());
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
	public static testMethod void runTest8() {
        
        TestResult resultObj = testMethod1('email', 'sushant.kumar@saasfocus.com', '8285035896', 'Closed');
        System.assertEquals(false, resultObj.isError);
		System.assertEquals(null, resultObj.saveOnContinueResult);
        System.assertEquals(null, resultObj.retrieveApplicationResult);
    }
    
    /**
     * @Created By : Sushant Kumar
     * @Description : This class is created for storing testResults
     **/
    public class TestResult {
        Boolean isError {get;set;}
        PageReference saveOnContinueResult {get;set;}
        PageReference retrieveApplicationResult {get;set;}
    }
}
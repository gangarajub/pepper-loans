// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_BatchUpdtContSettingHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestBatchUpdtContSettingHan
{  
    static  testMethod Void MyTest()
    {   
        Set<Id> sId = new Set<Id>();
        ScCollection_BatchUpdtContSettingHandler obj = new ScCollection_BatchUpdtContSettingHandler('ab','Collection',sId);
        ScCollection_BatchUpdtContSettingHandler obj1 = new ScCollection_BatchUpdtContSettingHandler('ab','NotColle',sId);              
    }   
    
    static testMethod Void MyTest1()
    {   
        //insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');

        //Insert Account
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
          
        //Insert Contact
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();
          
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.collect__Account__c = objAccount.id;
        update objContract;
          
        ScCollection_BatchUpdateContSetting ScCol = new ScCollection_BatchUpdateContSetting();
         
        Test.StartTest();
        Database.executeBatch(ScCol);
        Test.stopTest();  
    }   
    
    static testMethod void myUnitTest2()
    { 
        //insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');

        //Insert Account
        Account objAccount1 = ScCollection_CommonTrackerClass.createTestPersonAccount();
       
        loan__loan_account__c  objContract = pepCommonTrackerController.createLoanAccount();
        
        collect__Queue__c objQue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
                  
        collect__Contract_Status__c objCollectionStatus = new collect__Contract_Status__c();
        objCollectionStatus.ScCollection_Arrears__c = 'New Work';
        insert objCollectionStatus ;
        
        collect__Queue_Contract__c objQueueContract1 = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.id, objContract.Id, UserInfo.getUserId());
        objQueueContract1.collect__Status__c = 'Closed';
        update objQueueContract1;
        
        collect__Loan_Account__c objLoanAccount = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objLoanAccount.collect__Account__c = objAccount1.id;
        update objLoanAccount ;
          
        ScCollection_ContractSettings__c objContractSetting = new ScCollection_ContractSettings__c();
        objContractSetting.ScCollection_HoldDaysCount__c = 2313.23; 
        objContractSetting.ScCollection_CLContract__c = objContract.id;
        objContractSetting.ScCollection_UserLookup__c = UserInfo.getUserId();
        insert objContractSetting;
        
        ScCollection_BatchUpdateContSetting ScCol=new ScCollection_BatchUpdateContSetting();
           
        Test.StartTest();
        Database.executeBatch(ScCol);
        Test.stopTest();
    }
}
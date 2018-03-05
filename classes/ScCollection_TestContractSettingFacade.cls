// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ContractSettingFacade class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestContractSettingFacade 
{
    static testMethod void myUnitTest() 
    {
        List<ScCollection_ContractSettings__c> contractSettingslst = new List<ScCollection_ContractSettings__c>();
                
        Profile testProfile = [select Id from profile where Name = 'System Administrator' limit 1];
        
        User testUser = new User(LastName = 'test user 1', 
                                 Username = 'test.user.1@example.com', 
                                 Email = 'test.1@example.com', 
                                 Alias = 'testu1', 
                                 TimeZoneSidKey = 'GMT', 
                                 LocaleSidKey = 'en_GB', 
                                 EmailEncodingKey = 'ISO-8859-1', 
                                 ProfileId = testProfile.Id, 
                                 LanguageLocaleKey = 'en_US',
                                 ManagerId = UserInfo.getUserId());     
                
        Test.startTest();
        System.runAs(testUser)
        {
            //Insert Custom Settings
            ScCollection_Settings__c  objCollectSettings = new ScCollection_Settings__c();
            objCollectSettings.ScCollection_NoAnswerCount__c = 2 ;
            objCollectSettings.ScCollection_BrokenPromiseCount__c =5;
            objCollectSettings.ScCollection_NoCommitmentCount__c =2;
            objCollectSettings.ScCollection_HoldDaysCount__c = 4;
            insert objCollectSettings ; 
            
            //Insert object of collect__Queue__c
            collect__Queue__c objQue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
               
            collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
            
            //Insert Object of Contract
            collect__Loan_Account__c objContract = new collect__Loan_Account__c();
            objContract.Name = 'Contract-001';
            objContract.collect__Source_System__c = objSourceSystem.id ;
            objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
            objContract.collect__Delinquent_Amount__c = 80;
            insert objContract;
            
            // Insert Object of collect__Queue_Contract__c with Contract
            collect__Queue_Contract__c objQueueContract = new collect__Queue_Contract__c();
            objQueueContract.Name = 'sampleQueConttTest';
            objQueueContract.collect__Queue__c = objQue.id;
            objQueueContract.collect__Loan_Account_Id__c = objContract.id ;
            objQueueContract.collect__Status__c ='Open';
            objQueueContract.ScCollection_Dev_Contract__c =  objContract.id ;
            objQueueContract.collect__User__c = testUser.id ;
            insert objQueueContract;
            
            //Insert Contract Settings
            ScCollection_ContractSettings__c  objContractSettings = new ScCollection_ContractSettings__c();
            objContractSettings.ScCollection_NoAnswerCount__c = 4 ;
            objContractSettings.ScCollection_BrokenPromiseCount__c =8 ;
            objContractSettings.ScCollection_NoCommitmentCount__c =9;
            objContractSettings.ScCollection_HoldDaysCount__c = 8;
            objContractSettings.ScCollection_DevContract__c = objContract.id;
            insert objContractSettings ;
        
            Map<Id,id> mapContractToOwner = new Map<Id,id>();
            mapContractToOwner.put(objContract.id,testUser.id);
                
            contractSettingslst.add(objContractSettings);
            ScCollection_ContractSettingFacade.updateQueueContract(contractSettingslst);
            ScCollection_ContractSettingFacade.updateContractOwners(mapContractToOwner);
        }
        Test.stopTest();
    }    
}
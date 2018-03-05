// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ConUserAssignController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestUserAssignController 
{
    static testMethod void myUniTest() 
    {  
        // Setup test data
        Profile p = [select Id from Profile where Name = 'Standard User']; 
        
        User u = new User(Alias = 'stat', 
                          Email='standuser@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='UserPep Test', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='standPepeuser@testorg.com',
                          ManagerId = UserInfo.getUserId());

        System.runAs(u) 
        {
            //Insert object of collect__Queue__c
            collect__Queue__c objQueearlyStage = ScCollection_CommonTrackerClass.createTestQueue('Early Stage Collectors Queue');
            objQueearlyStage.collect__Permanent__c = true;
            update objQueearlyStage;
            //Insert Queue User
            collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQueearlyStage.Id, UserInfo.getUserId());
            
            //Insert Queue User
            collect__Queue_User__c objUser1 = ScCollection_CommonTrackerClass.createTestQueueUser(objQueearlyStage.Id, UserInfo.getUserId());
                      
            //Insert Object of Contract
            collect__Loan_Account__c objContract = new collect__Loan_Account__c();
            objContract.Name ='Contract-001';
            objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
            objContract.collect__Delinquent_Amount__c =80;
            insert objContract ;
            
            
            loan__Loan_Account__c objLoan = pepCommonTrackerController.createLoanAccount();
            
            //Insert Object of collect__Queue_Contract__c with Contract
            collect__Queue_Contract__c objQueueContract = new collect__Queue_Contract__c();
            objQueueContract.Name = 'sampleQueConttTest';
            objQueueContract.collect__Queue__c = objQueearlyStage.id;
            objQueueContract.collect__Loan_Account_Id__c = objContract.id ;
            objQueueContract.ScCollection_Dev_Contract__c = objContract.id ;
            objQueueContract.ScCollection_FirstlevelEscalations__c = true;
            objQueueContract.ScCollection_SecondLevelEscalations__c = true;
            objQueueContract.collect__Status__c ='Open';
            objQueueContract.collect__User__c = UserInfo.getUserId();
            insert objQueueContract;

            ScCollection_Settings__c  objCollectSettings = new ScCollection_Settings__c();
            objCollectSettings.ScCollection_DailyReferCap__c = 4 ;
            insert objCollectSettings ;
                    
            ScCollection_ConUserAssignController.referToSupervisior(objContract.id);
            
           string abc = ScCollection_ConUserAssignController.referToSupervisior(objLoan.id);
            system.debug(abc);
            objQueearlyStage.collect__Permanent__c = false;
            update objQueearlyStage;
             ScCollection_ConUserAssignController.referToSupervisior(objLoan.id);
        }
    }
    
    
    // code added on nov 11 by deepak
    // with no manager id
    static testMethod void noManager() 
    {  
        // Setup test data
        Profile p = [select Id from Profile where Name = 'Standard User']; 
        
        User u = new User(Alias = 'stat', 
                          Email='standuser@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='UserPep Test', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='standPepeuser@testorg.com'
                          );

        System.runAs(u) 
        {
            //Insert object of collect__Queue__c
            collect__Queue__c objQueearlyStage = ScCollection_CommonTrackerClass.createTestQueue('Early Stage Collectors Queue');
            objQueearlyStage.collect__Permanent__c = true;
            update objQueearlyStage;
            //Insert Queue User
            collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQueearlyStage.Id, UserInfo.getUserId());
            
            //Insert Queue User
            collect__Queue_User__c objUser1 = ScCollection_CommonTrackerClass.createTestQueueUser(objQueearlyStage.Id, UserInfo.getUserId());
                      
            //Insert Object of Contract
            collect__Loan_Account__c objContract = new collect__Loan_Account__c();
            objContract.Name ='Contract-001';
            objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
            objContract.collect__Delinquent_Amount__c =80;
            insert objContract ;
                            
            //Insert Object of collect__Queue_Contract__c with Contract
            collect__Queue_Contract__c objQueueContract = new collect__Queue_Contract__c();
            objQueueContract.Name = 'sampleQueConttTest';
            objQueueContract.collect__Queue__c = objQueearlyStage.id;
            objQueueContract.collect__Loan_Account_Id__c = objContract.id ;
            objQueueContract.ScCollection_Dev_Contract__c = objContract.id ;
            objQueueContract.ScCollection_FirstlevelEscalations__c = true;
            objQueueContract.ScCollection_SecondLevelEscalations__c = true;
            objQueueContract.collect__Status__c ='Open';
            objQueueContract.collect__User__c = UserInfo.getUserId();
            insert objQueueContract;

            ScCollection_Settings__c  objCollectSettings = new ScCollection_Settings__c();
            objCollectSettings.ScCollection_DailyReferCap__c = 4 ;
            insert objCollectSettings ;
                    
            ScCollection_ConUserAssignController.referToSupervisior(objContract.id);
        }
    }
    
    // code added on nov 11 by deepak
    // with no manager id
    static testMethod void norefercap() 
    {  
        // Setup test data
        Profile p = [select Id from Profile where Name = 'Standard User']; 
        
        User u = new User(Alias = 'stat', 
                          Email='standuser@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='UserPep Test', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='standPepeuser@testorg.com',
                          ManagerId = UserInfo.getUserId()
                          );

        System.runAs(u) 
        {
        
            //Insert object of collect__Queue__c
            collect__Queue__c objQueearlyStage = ScCollection_CommonTrackerClass.createTestQueue('Early Stage Collectors Queue');
            objQueearlyStage.collect__Permanent__c = true;
            update objQueearlyStage;
            //Insert Queue User
            collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQueearlyStage.Id, UserInfo.getUserId());
            
            //Insert Queue User
            collect__Queue_User__c objUser1 = ScCollection_CommonTrackerClass.createTestQueueUser(objQueearlyStage.Id, UserInfo.getUserId());
                      
            //Insert Object of Contract
            collect__Loan_Account__c objContract = new collect__Loan_Account__c();
            objContract.Name ='Contract-001';
            objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
            objContract.collect__Delinquent_Amount__c =80;
            insert objContract ;
                            
            //Insert Object of collect__Queue_Contract__c with Contract
            collect__Queue_Contract__c objQueueContract = new collect__Queue_Contract__c();
            objQueueContract.Name = 'sampleQueConttTest';
            objQueueContract.collect__Queue__c = objQueearlyStage.id;
            objQueueContract.collect__Loan_Account_Id__c = objContract.id ;
            objQueueContract.ScCollection_Dev_Contract__c = objContract.id ;
            objQueueContract.ScCollection_FirstlevelEscalations__c = true;
            objQueueContract.ScCollection_SecondLevelEscalations__c = true;
            objQueueContract.collect__Status__c ='Open';
            objQueueContract.collect__User__c = UserInfo.getUserId();
            insert objQueueContract;

            ScCollection_Settings__c  objCollectSettings = new ScCollection_Settings__c();
           // objCollectSettings.ScCollection_DailyReferCap__c = 4 ;
            insert objCollectSettings ;
                    
            ScCollection_ConUserAssignController.referToSupervisior(objContract.id);
        }
    }
}
// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ContractStatusHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestContractStatusHandler 
{
    static testMethod void myUnitTest() 
    {
        //insert trigger setting
        ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
        
        //Inserting Object Of Collection  Status
        collect__Contract_Status__c objStatus = new collect__Contract_Status__c();
        objStatus.ScCollection_Hardship__c = 'Hardship Declined';
        objStatus.ScCollection_DayssinceHardshipRequested__c = decimal.valueOf(Label.ScCollection_MarkAsPriorityDaysHardship) ;
        objStatus.ScCollection_HardshipAllDocumentReceived__c = false ;
        objStatus.ScCollection_Remarketing__c =  'Form 14 Issued';
        insert objStatus;
        
        collect__Source_System__c objSourceSystem = new collect__Source_System__c();
        objSourceSystem.Name = 'PAF' ;
        insert objSourceSystem;
     
        //Insert Object of Contract
        collect__Loan_Account__c objContract = new collect__Loan_Account__c();
        objContract.Name ='Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c =80;
        insert objContract ;
        
        loan__Loan_Account__c objPlLoan = pepCommonTrackerController.createLoanAccount();
        objPlLoan.ScCollection_Collection_Status__c = objStatus.Id;
        update objPlLoan;
        
        objContract.collect__Collection_Status__c = objStatus.id;
        update objContract ;
        
        collect__Contract_Status__c objStatusupdate = new collect__Contract_Status__c(Id = objStatus.id );
        objStatusupdate.ScCollection_Hardship__c = 'Hardship natural disaster - Property';
        objStatusupdate.ScCollection_Remarketing__c = 'Out with Agent';
        update objStatusupdate ;
        
        objStatusupdate.ScCollection_Remarketing__c = 'Repossessed';
        update objStatusupdate ;
        
        objStatusupdate.ScCollection_Remarketing__c = 'Form 14 Issued';
        update objStatusupdate ;
        
        objStatusupdate.ScCollection_HardshipAllDocumentReceived__c = true ;
        objStatusupdate.ScCollection_Hardship__c = 'Hardship Requested'; 
        objStatusupdate.ScCollection_Arrears__c = 'New Work';
        objStatusupdate.ScCollection_Complaint__c = 'IDR Active';   
        update objStatusupdate ;
        
        collect__Contract_Status__c objstatusupdated = [Select id,ScCollection_DayssinceHardshipRequested__c from collect__Contract_Status__c 
                                                    where id = : objStatusupdate.Id];
       
        system.assert(objstatusupdated.ScCollection_DayssinceHardshipRequested__c == 0,'woked');
        
        ScCollection_ContractStatusHandler  objCollectionContractHanler = new ScCollection_ContractStatusHandler();
    }
        
    static testMethod void myUnitTest1() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'mangusr', Email='manageruser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='manageruser@testorg.com');
        insert u;
        System.runAs(u) {
            User u1 = new User(Alias = 'empoyeee', Email='empoyeeeuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='empoyeeeuser@testorg.com',managerId = u.Id);
            insert u1;
            System.runAs(u1) {
                //insert trigger setting
                ScCollection_TriggerExecutionSettings__c objtriggersetting = ScCollection_CommonTrackerClass.createTestTriggerSettings();
                
                collect__Queue__c objQueue = new collect__Queue__c();
                objQueue.Name = 'strqueuename';
                objQueue.collect__Permanent__c = true;
                objQueue.collect__Enabled__c = true;
                insert objQueue;
                
                //Inserting Object Of Collection  Status
                collect__Contract_Status__c objStatus = new collect__Contract_Status__c();
                objStatus.ScCollection_Hardship__c = 'Hardship Declined';
                objStatus.ScCollection_DayssinceHardshipRequested__c = 6;
                objStatus.ScCollection_HardshipAllDocumentReceived__c = false ;
                objStatus.ScCollection_Remarketing__c =  'Form 14 Issued';
                insert objStatus;
                
                collect__Source_System__c objSourceSystem = new collect__Source_System__c();
                objSourceSystem.Name = 'PAF' ;
                insert objSourceSystem;
             
                //Insert Object of Contract
                collect__Loan_Account__c objContract = new collect__Loan_Account__c();
                objContract.Name ='Contract-001';
                objContract.collect__Source_System__c = objSourceSystem.id ;
                objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
                objContract.collect__Delinquent_Amount__c =80;
                insert objContract ;
                
                loan__Loan_Account__c objPlLoan = pepCommonTrackerController.createLoanAccount();
                objPlLoan.ScCollection_Collection_Status__c = objStatus.Id;
                update objPlLoan;
                
                // queue contract inserted by deepak dhingra
                collect__Queue__c objQueue1 = new collect__Queue__c();
                objQueue1.Name = 'queuename';
                insert objQueue1;
                collect__Queue_Contract__c QueueContract = new collect__Queue_Contract__c(collect__Loan_Account_Id__c = objContract.id,collect__Queue__c = objQueue.id,collect__User__c = u1.Id);
                insert QueueContract;
                objContract.collect__Collection_Status__c = objStatus.id;
                update objContract ;
                collect__Contract_Status__c objStatusupdate = new collect__Contract_Status__c(Id = objStatus.id );
                objStatusupdate.ScCollection_Hardship__c = 'Hardship natural disaster - Property';
                objStatusupdate.ScCollection_Remarketing__c = 'Out with Agent';
                update objStatusupdate ;
                
                objStatusupdate.ScCollection_Remarketing__c = 'Repossessed';
                update objStatusupdate ;
                
                objStatusupdate.ScCollection_Remarketing__c = 'Form 14 Issued';
                objStatusupdate.ScCollection_Hardship__c = 'Hardship Declined';
                update objStatusupdate ;
                
                ScCollection_ContractStatusHandler  objCollectionContractHanler = new ScCollection_ContractStatusHandler();
                update objStatus;
                
                objStatus.ScCollection_DayssinceHardshipRequested__c = decimal.valueOf(Label.ScCollection_EscalationToSupervisorDaysHardship);
                update objStatus;
                collect__Contract_Status__c objstatusupdated = [Select id,ScCollection_DaysSince_Hardship_Declined__c from collect__Contract_Status__c 
                                                    where id = : objStatusupdate.Id];
       
                system.assert(objstatusupdated.ScCollection_DaysSince_Hardship_Declined__c == 0,'woked');
            }
            
        }
    }
}
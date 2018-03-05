// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CollectorReportHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 20-Nov-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestCollectorReportHandler
{
    @istest 
    static void test1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        user testUser = ScCollection_CommonTrackerClass.createTestUser('sandip.bij@saas.com',p.id);
        collect__Queue__c objCollectQueue = ScCollection_CommonTrackerClass.createTestQueue('Name');
        
        collect__Queue_User__c objQueueUser = ScCollection_CommonTrackerClass.createTestQueueUser(objCollectQueue.id,testUser.id);
        
        loan__Loan_Account__c objLoanAccount =  pepCommonTrackerController.createLoanAccount();  
        
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('System Name');
        collect__Loan_Account__c objDEVContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.id);
        
        collect__Queue_Contract__c objqueueContract = ScCollection_CommonTrackerClass.createTestQueueContract(objCollectQueue.id,objLoanAccount.id,testUser.id);
        
        ScCollection_User_Assignment__c objUserAssignment = new ScCollection_User_Assignment__c();
        objUserAssignment.ScCollection_Review_Date__c = Date.newInstance(2016,12,12);
        objUserAssignment.ScCollection_Contract_Ids__c = objDEVContract.Id;
        objUserAssignment.ScCollection_User__c =testUser.id ;
        insert objUserAssignment;
        
        ScCollection_User_Assignment__c objUserAssignment1 = new ScCollection_User_Assignment__c();
        objUserAssignment1.ScCollection_Review_Date__c = Date.newInstance(2016,12,12);
        objUserAssignment.ScCollection_Contract_Ids__c = objLoanAccount.Id;
        objUserAssignment1.ScCollection_User__c =testUser.id ;
        insert objUserAssignment1;
        
        
        collect__Action_Code__c objActionCode = new collect__Action_Code__c();
        objActionCode.ScCollection_Is_Inbound_Action__c = true;
        objActionCode.ScCollection_Considered_Contact__c = 'Yes';
        insert objActionCode;
                        
        system.runas(testUser)
        {
            collect__Payment_Arrangement__c objPaymentArrang = new collect__Payment_Arrangement__c();
            objPaymentArrang.collect__Contract__c = objDEVContract.id;
            objPaymentArrang.collect__Arrangement_Amount__c = 200;
            insert objPaymentArrang;
            Test.setCreatedDate(objPaymentArrang.Id, DateTime.newInstance(2016,12,12));
            
            collect__Payment_Arrangement__c objPaymentArrang1 = new collect__Payment_Arrangement__c();
            objPaymentArrang1.ScCollection_CL_Contract__c = objLoanAccount.id;
            objPaymentArrang1.collect__Arrangement_Amount__c = 200;
            insert objPaymentArrang1;
            Test.setCreatedDate(objPaymentArrang1.Id, DateTime.newInstance(2016,12,12));
                       
            collect__Interaction_Log__c objInteraction = new collect__Interaction_Log__c();
            objInteraction.collect__Loan_Account_Id__c = objDEVContract.id ;
            objInteraction.collect__Follow_Up_Date_Time__c = System.Now();
            objInteraction.collect__Description__c = 'Test Log Comments';
            objInteraction.collect__Dev_Contract__c = objDEVContract.id;
            objInteraction.ScCollection_CL_Contract__c = null;
            objInteraction.collect__Action__c = objActionCode.id;
            insert objInteraction;
            Test.setCreatedDate(objInteraction.Id, DateTime.newInstance(2016,12,12));
            
            collect__Interaction_Log__c objInteraction1 = new collect__Interaction_Log__c();
            objInteraction1.collect__Loan_Account_Id__c = objLoanAccount.id ;
            objInteraction1.collect__Follow_Up_Date_Time__c = System.Now();
            objInteraction1.collect__Description__c = 'Test Log Comments';
            objInteraction1.collect__Action__c = objActionCode.id;
            objInteraction1.collect__Dev_Contract__c = null;
            objInteraction1.ScCollection_CL_Contract__c = objLoanAccount.id;
            insert objInteraction1;
            Test.setCreatedDate(objInteraction1.Id, DateTime.newInstance(2016,12,12));
            
            collect__Promise_To_Pay__c objPromisetoPay = new collect__Promise_To_Pay__c();
            objPromisetoPay.collect__Dev_Contract__c = objDEVContract.id;
            objPromisetoPay.collect__Promise_To_Pay_Amount__c = 1000;
            objPromisetoPay.collect__Promise_To_Pay_Date__c = Date.newInstance(2016,12,12);
            insert objPromisetoPay;
            Test.setCreatedDate(objPromisetoPay.Id, DateTime.newInstance(2016,12,12));
            
            Test.startTest();
             
                ScCollection_CollectorReportHandler objController = new ScCollection_CollectorReportHandler();
                String usrId = '\''+String.valueof(testUser.id) + '\'';
                ScCollection_CollectorReportHandler.getSearchResults(usrId,'30/10/2016','14/12/2016' );
                ScCollection_CollectorReportHandler.getPtpSearchResults(usrId,'30/10/2016','14/12/2016','30/10/2016','14/12/2016' );
                ScCollection_CollectorReportHandler.getSearchResults(usrId,'30/10/2016','14/12/2017');
                ScCollection_CollectorReportHandler.getPtpSearchResults(usrId,'30/10/2016','14/12/2017','30/10/2016','14/12/2017' );
                
                ScCollection_CollectorReportHandler.getPtpDetailResults(objPromisetoPay.Id);
               
                objActionCode.ScCollection_Is_Inbound_Action__c = false;
                update objActionCode;
                
                delete objUserAssignment;
                delete objUserAssignment1;
                ScCollection_CollectorReportHandler.getSearchResults(usrId,'30/10/2016','12/12/2017');
                String stringID = objDEVContract.id;
                stringID = stringID + ',' + objLoanAccount.id;
                ScCollection_CollectorReportHandler.getDetailResults(stringID);
                
                objDEVContract.collect__External_ID__c = 'abc_pqr';
                objDEVContract.ScCollection_Current_Principal__c = 2000;
                update objDEVContract;
                ScCollection_CollectorReportHandler.getSearchResults(usrId,'30/10/2016','14/12/2016' );
                
                ScCollection_CollectorReportHandler.wrapperForContractDetail objWrap = new ScCollection_CollectorReportHandler.wrapperForContractDetail();
                ScCollection_CollectorReportHandler.wrapperForPTPList objWrap1 = new  ScCollection_CollectorReportHandler.wrapperForPTPList();
                ScCollection_CollectorReportHandler.wrapperForPTPDetail objWrap2 = new ScCollection_CollectorReportHandler.wrapperForPTPDetail();
            Test.stopTest();
        }   
    }
}
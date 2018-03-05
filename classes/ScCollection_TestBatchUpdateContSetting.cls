// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_BatchUpdateContSetting class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestBatchUpdateContSetting 
{
    static testMethod void myUnitTest() 
    { 
        Account objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
                  
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
                  
        //Insert Contact
        Contact objContact = ScCollection_CommonTrackerClass.createTestContact();
          
        //Insert Object of Contract
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
         
        //Insert Collection Activity
        collect__Collection_Activity__c objCollectionActivity = ScCollection_CommonTrackerClass.createTestActivity(objContract.Id);
        
        // Insert Interaction Log
        collect__Interaction_Log__c objInteractionLog = ScCollection_CommonTrackerClass.createTestLog(objContract.Id);
        
        Test.setCreatedDate(objInteractionLog.id, Date.today());
        ScCollection_BatchUpdateContSetting objBatch = new ScCollection_BatchUpdateContSetting();
        Database.executeBatch(objBatch);
    }        
}
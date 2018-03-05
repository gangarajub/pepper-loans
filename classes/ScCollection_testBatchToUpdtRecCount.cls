/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_testBatchToUpdtRecCount 
Company:       Saasfocus
Description:   This class is use to test the batch class 
History
Date    :  13/11/2017     
------------------------------------------------------------*/
@isTest(seeAllData=false)
public class ScCollection_testBatchToUpdtRecCount{
    
    public static collect__Source_System__c objsourcesystem;
    public static collect__Loan_Account__c objcontract;
    public static Account objAccount;
    public static clcommon__Party_Type__c objptype;
    public static clcommon__Party__c objparty;
    public static ScCollection_Record_Count__c objCustomRecord;
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testingBatch
    Company:       Saasfocus
    Description:   This is the method is use to test the batch class.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void testingBatch(){
         
        createrecord();
        Test.startTest();
            ScCollection_ScheduleBatchToUpdtRecCnt objSchedule = new ScCollection_ScheduleBatchToUpdtRecCnt ();
            objSchedule.execute(null);
        Test.stopTest();
        
        ESB_Batch_Load_Stat__c objStat = [Select Id,LOB__c,Total_Records__c From ESB_Batch_Load_Stat__c where Entity__c = 'clcommon__Party__c' and LOB__c = 'Mortgage'  limit 1];
        system.assert(objStat.Total_Records__c == 1,'worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testingBatchException
    Company:       Saasfocus
    Description:   This is the method is use to test the batch class exception.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void testingBatchException(){
         
        createrecord();
        objCustomRecord.ScCollection_Query__c = 'Select';
        update objCustomRecord;
        
        Test.startTest();
            ScCollection_ScheduleBatchToUpdtRecCnt objSchedule = new ScCollection_ScheduleBatchToUpdtRecCnt ();
            objSchedule.execute(null);
        Test.stopTest();
        
        ESB_Batch_Load_Stat__c objStat = [Select Id,Input_Phase_Exception__c  From ESB_Batch_Load_Stat__c where Entity__c = 'clcommon__Party__c' limit 1];
        //system.debug(objStat.Input_Phase_Exception__c);
        system.assert(objStat.Input_Phase_Exception__c == 'unexpected token: \'<EOF>\'','worked');
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createrecord
    Company:       Saasfocus
    Description:   This is the method is use to ceeate test records.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static void createrecord(){
        objsourcesystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        
        objcontract = ScCollection_CommonTrackerClass.createTestContract(objsourcesystem.Id);
        
        objAccount = ScCollection_CommonTrackerClass.createTestPersonAccount();
        
        objptype = new clcommon__Party_Type__c();
        objptype.Name = 'Primary Borrower';
        insert objptype;
        
        objparty = new clcommon__Party__c();
        objparty.clcommon__Account__c = objAccount.Id;
        objparty.collect__CL_Contract__c = objContract.Id;
        objparty.clcommon__Type__c = objptype.Id;
        objparty.ScCollection_Active__c = true;
        objparty.clcommon__isPrimary__c = true;
        insert objparty;
        
        objCustomRecord = new ScCollection_Record_Count__c();
        objCustomRecord.ScCollection_Query__c = 'Select collect__CL_Contract__r.collect__Source_System__r.Name lob,Count(Id) cnt From clcommon__Party__c where collect__CL_Contract__c != null Group By collect__CL_Contract__r.collect__Source_System__r.Name';
        objCustomRecord.Name = 'clcommon__Party__c';
        insert objCustomRecord;
    }
}
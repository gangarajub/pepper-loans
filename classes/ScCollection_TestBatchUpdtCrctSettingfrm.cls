// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_BatchUpdtCrctSettingfrmStat class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData=false)
public class ScCollection_TestBatchUpdtCrctSettingfrm 
{
    static testMethod void myUnitTest() 
    { 
        //Insert Collection Status Object
        collect__Contract_Status__c objCollectionStatus = new collect__Contract_Status__c();
        objCollectionStatus.ScCollection_Arrears__c = 'New Work';
        objCollectionStatus.ScCollection_Remarketing__c = 'Repossessed';
        objCollectionStatus.ScCollection_Hardship__c = 'Hardship Requested';
        objCollectionStatus.ScCollection_HardshipAllDocumentReceived__c = true;
        objCollectionStatus.ScCollection_Complaint__c ='IDR Lodged';
        insert objCollectionStatus ;
        test.StartTest();
        ScCollection_BatchUpdtCrctSettingfrmStat objBatch = new ScCollection_BatchUpdtCrctSettingfrmStat();
        Database.executeBatch(objBatch);
        test.StopTest();
        collect__Contract_Status__c objstatus = [Select id,ScCollection_DayssinceHardshipRequested__c from collect__Contract_Status__c 
                                                    where id = : objCollectionStatus.Id];
       
        system.assert(objstatus.ScCollection_DayssinceHardshipRequested__c == 1,'woked');
    }  
    
    static testMethod void myUnitTest1() 
    { 
        //Insert Collection Status Object
        collect__Contract_Status__c objCollectionStatus = new collect__Contract_Status__c();
        objCollectionStatus.ScCollection_Arrears__c = 'New Work';
        objCollectionStatus.ScCollection_Remarketing__c = 'Out with Agent';
        objCollectionStatus.ScCollection_Hardship__c = 'Hardship Declined';
        objCollectionStatus.ScCollection_HardshipAllDocumentReceived__c = true;
        objCollectionStatus.ScCollection_Daysincealldocumentreceived__c = 5;
        objCollectionStatus.ScCollection_HardshipDays__c = 5;
        objCollectionStatus.ScCollection_Complaint__c ='IDR Lodged';
        objCollectionStatus.ScCollection_ComplaintDays__c = 5;
        objCollectionStatus.scCollection_ArrearsDaysCount__c = 5;
        insert objCollectionStatus ;
        test.StartTest();
        ScCollection_BatchUpdtCrctSettingfrmStat objBatch = new ScCollection_BatchUpdtCrctSettingfrmStat();
        Database.executeBatch(objBatch);
        test.StopTest();
        collect__Contract_Status__c objstatus = [Select id,ScCollection_DaysSince_Hardship_Declined__c from collect__Contract_Status__c 
                                                    where id = : objCollectionStatus.Id];
        system.assert(objstatus.ScCollection_DaysSince_Hardship_Declined__c == 1,'woked');
    } 
    
    static testMethod void myUnitTest2() 
    { 
        //Insert Collection Status Object
        collect__Contract_Status__c objCollectionStatus = new collect__Contract_Status__c();
        objCollectionStatus.ScCollection_Arrears__c = 'New Work';
        objCollectionStatus.ScCollection_Remarketing__c = 'Form-14 Issued';
        objCollectionStatus.ScCollection_Hardship__c = 'Hardship Declined';
        objCollectionStatus.ScCollection_HardshipAllDocumentReceived__c = true;
        objCollectionStatus.ScCollection_Daysincealldocumentreceived__c = 5;
        objCollectionStatus.ScCollection_DaysSince_Hardship_Declined__c = 5;
        objCollectionStatus.ScCollection_HardshipDays__c = 5;
        objCollectionStatus.ScCollection_Complaint__c ='IDR Lodged';
        objCollectionStatus.ScCollection_ComplaintDays__c = 5;
        objCollectionStatus.scCollection_ArrearsDaysCount__c = 5;
        insert objCollectionStatus ;
        test.StartTest();
        ScCollection_BatchUpdtCrctSettingfrmStat objBatch = new ScCollection_BatchUpdtCrctSettingfrmStat();
        Database.executeBatch(objBatch);
        test.StopTest();
        collect__Contract_Status__c objstatus = [Select id,ScCollection_Daysincealldocumentreceived__c from collect__Contract_Status__c 
                                                    where id = : objCollectionStatus.Id];
        system.assert(objstatus.ScCollection_Daysincealldocumentreceived__c == 6,'woked');
    }  
    
}
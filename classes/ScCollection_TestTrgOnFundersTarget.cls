@isTest(SeeAllData = False) Public Class ScCollection_TestTrgOnFundersTarget{


     @isTest static void test0(){
     
         collect__Source_System__c objSource  = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
         
         ScCollection_Bucket_Configuration__c  cs = ScCollection_CommonTrackerClass.createTestBucketConfig();
         
         ScCollection_Funders_Target__c objFundTransfer = new ScCollection_Funders_Target__c();
         objFundTransfer.ScCollection_Source_System__c=objSource.id;
         objFundTransfer.ScCollection_Bank_Name__c = 'Hdfc';
         objFundTransfer.ScCollection_Target__c = 20;
         insert objFundTransfer;
     }
}
@isTest(SeeAllData=False) public class ScCollection_TestDeliveryDetailTrigger{

    
    @isTest static void test0(){
        
        collect__Source_System__c  obSource = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Loan_Account__c  objClContract =  ScCollection_CommonTrackerClass.createTestContract(obSource.id);
        
        loan__Loan_Account__c objPlContract = pepCommonTrackerController.createLoanAccount();
        
        cnotify__Delivery_Detail__c objDelivery = new cnotify__Delivery_Detail__c();
        objDelivery.Name = 'abc';
        objDelivery.cnotify__Contract_Id__c = null;
        insert objDelivery;
        
        objDelivery.cnotify__Contract_Id__c = objClContract.id;
        update objDelivery;
        
        objDelivery.cnotify__Contract_Id__c = objPlContract.id;
        update objDelivery;
        
        objDelivery.cnotify__Contract_Id__c = 'test';
        update objDelivery;
    
    }



}
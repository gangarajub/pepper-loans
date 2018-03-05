@isTest
public class TestCallSyncJob2 {

    
    public testmethod static void invokeSyncJob2(){
        
        Test.startTest();
    	List<String> ins = new List<String>();
        List<String> outs = new List<String>();
        
        ins.add('staging__Interface_Party__c');
        outs = CallSyncJob2.invokeSyncJob2(ins);
        
        Test.stopTest();
        
        Id jobId = Id.valueOf(outs[0]);
        
        AsyncApexJob job = [select Id from AsyncApexJob where Id = : jobId];
        
        System.assertNotEquals(null, job);
        
    }
    
}
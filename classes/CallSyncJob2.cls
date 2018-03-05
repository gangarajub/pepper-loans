/*
    Alex Humby: 2017-12-01
    
    This invocable class allows collect.SyncJob2 to be called from a Flow (and hence from an Action on the UI).
    Parameters for SyncJob2 are as follows and should be passed into this method in the correct order in a List of Strings.
    
    1) String table: the staging table to be Sync'd eg staging__Interface_Contract__c
    2) String query: the soql statement of records to be processed eg SELECT Id, staging__External_Id__c , staging__source_name__c FROM staging__interface_Contract__c WHERE staging__Sync_Processed__c = False
    3) Boolean submitNextJob: pass "True" or "False", should the SyncJob2 invoke other staging Tables after completing this table.
    4) Boolean createActivity: pass "True" or "False", should the SyncJob2 invoke the CreateCollectionsActivity processes after completing staging tables syncs
    5) Integer batchSize: pass an Integer as a String, the batch size of the job.
    
    This method will cast these params from Strings to the correct type and pass them into SyncJob2 in this exact order. Any subsequent params will be ignored.
*/

public class CallSyncJob2 {
  @InvocableMethod(label='Call CL SyncJob2' description='Pass a list of 5 strings with values for: (String)table, (String)query, (Boolean)submitNextJob, (Boolean)createActivity, (Integer)BatchSize ')
 
  public static List<String> invokeSyncJob2(List<String> params) {
      List<String> returnString = new List<String>();
  
      if(params.size() > 0 && params != null){
          String tableName = params[0];
          System.debug('tableName : ' + tableName);
          try{
              String table = tableName;
              String query = 'select Id, staging__External_Id__c, staging__Source_Name__c from ' + tableName + ' where staging__Sync_Processed__c = false';
              Boolean submitNextJob = False;
              Boolean createActivity = False;
              Integer batchSize = 500;
          
              collect.SyncJob2 job = new collect.SyncJob2((String) null,
                query,
                table,
                submitNextJob,
                createActivity,                                         
                batchSize);
        
            Id jobId = Database.ExecuteBatch(job, batchSize);
              
              System.debug('jobId: ' + jobId);
              returnString.add(String.valueOf(jobId));
              return(returnString);  
            
          }catch (Exception e){
              
              returnString.add(e.getMessage());
              return(returnString);  
              
          }
      }
    return(returnString);  
  }
}
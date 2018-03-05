//  -------------------------------------------------------------------------------------------------------
//  This class would look for contracts that do not have any activity performed today and update/create the 
//  contract setting against them
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 01-AUG-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestBatchUpdateContSetting
//  -------------------------------------------------------------------------------------------------------
Global  class ScCollection_BatchUpdateContSetting implements Database.Batchable<sObject>,Database.Stateful 
{
    // string query that will be set from the scheduler
    String QUERY;
    // set for containing the already processed sets
    global set<id> setContractswithActivitiesCollection = new set<id>();
    // collection contracts with logs
    global set<id> setContractswithActivitiesPersonal = new set<id>();
 
    // constructor to set the the query string
    public ScCollection_BatchUpdateContSetting()
    {
        this.QUERY = 'Select id,collect__Dev_Contract__c,collect__Loan_Account_Id__c,collect__Action__c from collect__Interaction_Log__c where createddate = today';
    }
 
    // ----------------------------------------------------------------------------------------------------
    // This method will query the sobject as per string passed by the constructor
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 10-June-2015   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would be used to query the sobject           
    // ----------------------------------------------------------------------------------------------------
    Global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);   
    }

    // ----------------------------------------------------------------------------------------------------
    // This method will process the contract records in batches
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 10-June-2015   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would just look fot the interaction logs that have tagged activity for the day
    // ----------------------------------------------------------------------------------------------------
    global void execute(Database.BatchableContext info, List<Sobject> scope)
    {
        // type casting the scope
        List<collect__Interaction_Log__c> lstLogsWithActivity = (List<collect__Interaction_Log__c>)scope;
    
        // populate the contracts
        for(collect__Interaction_Log__c tempLog : lstLogsWithActivity)
        {
            if(tempLog.collect__Dev_Contract__c != Null && tempLog.collect__Action__c != Null)
            {
                setContractswithActivitiesCollection.add(tempLog.collect__Dev_Contract__c );
            }
            else if(tempLog.collect__Loan_Account_Id__c != Null && tempLog.collect__Action__c != Null)
            {
                setContractswithActivitiesPersonal.add(tempLog.collect__Loan_Account_Id__c);
            } 
        }    
    }
 
    // ----------------------------------------------------------------------------------------------------
    // This method will call another batch to process the reocords
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 10-June-2015   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would just look fot the interaction logs that have tagged activity for the day
    // ----------------------------------------------------------------------------------------------------
    global void finish(Database.BatchableContext BC)
    {
        // create queries
        String QueryCollectionLoan = 'Select id from collect__Loan_Account__c where id not in:setContractswithActivitiesCollection';
        String QueryPersonalLoan = 'Select id,name from loan__Loan_Account__c where id not in:setContractswithActivitiesPersonal';
        Set<string> setQueries = new Set<string>();
        setQueries.add(QueryCollectionLoan);
        setQueries.add(QueryPersonalLoan);
        
        // create batch instanes for each query
        for(String Query:setQueries)
        {
            System.debug('++++++'+Query);
            ScCollection_BatchUpdtContSettingHandler batchReference;
            
            if(QueryCollectionLoan.contains('collect__Loan_Account__c'))
            {
                batchReference = new ScCollection_BatchUpdtContSettingHandler(Query,'Collection',setContractswithActivitiesCollection);
            }
            else
            {
                batchReference = new ScCollection_BatchUpdtContSettingHandler(Query,'Personal',setContractswithActivitiesPersonal);    
            }
            database.executebatch(batchReference); 
        }
    }
}
public class DeleteLogsBatch implements DataBase.Batchable<sobject>{
    
    String query;
    
    Public DataBase.querylocator start(DataBase.BatchableContext context){
        
        DateTime endOfLastMonth =  System.today().toStartOfMonth().addDays(-1);
        if(test.isRunningTest())
        {
            endOfLastMonth = system.now();
        }
        query = 'Select Id from mfiflexUtil__Log__c where createdDate <= :endOfLastMonth';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        delete scope;
        DataBase.emptyRecycleBin(scope);    
    }

    public void finish(Database.BatchableContext BC) {
    
    }
    
    
}
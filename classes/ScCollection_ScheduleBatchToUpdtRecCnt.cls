/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_ScheduleBatchToUpdateRecordCount 
Company:       Saasfocus
Description:   This schedular is to schedule ScCollection_BatchToUpdateRecordCount.
History
Date    :  13/11/2017     
------------------------------------------------------------*/
global class ScCollection_ScheduleBatchToUpdtRecCnt implements Schedulable {
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          execute
    Company:       Saasfocus
    Description:   This method is used to schedule batch class which further updates the record count.
    Inputs:        SchedulableContext
    Returns:       void
    -----------------------------------------------------------------------------------*/
    global void execute(SchedulableContext sc) {
        ScCollection_BatchToUpdateRecordCount objBatch = new ScCollection_BatchToUpdateRecordCount();
        Database.executeBatch(objBatch,1);
    }
}
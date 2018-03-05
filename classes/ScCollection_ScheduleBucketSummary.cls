global class ScCollection_ScheduleBucketSummary implements Schedulable {
   
   global void execute(SchedulableContext sc) {
      
      ScCollection_BatchToFillBucketSummary objBatch = new ScCollection_BatchToFillBucketSummary(); 
      database.executebatch(objBatch,1);
   
   }
}
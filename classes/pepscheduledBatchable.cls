global class pepscheduledBatchable implements Schedulable {
  
   global void execute(SchedulableContext sc) {
      
      pepTimeBusinessHour objTimeBusinessHourBatch = new pepTimeBusinessHour();
      Id BatchTimeBusinessHour = Database.executeBatch(objTimeBusinessHourBatch,50);

    
     
   }
}
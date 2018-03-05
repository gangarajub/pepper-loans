//-----------------------------------------------------------------------------------------------------
// Date        : 19/12/2016
// Description : Schedular to schedule batch CRMBatchToUpdateAccLookupOnApplication 
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan              sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
global class CRMScheduleApplicationBatch implements Schedulable {
   
   global void execute(SchedulableContext sc) {
      
      CRMBatchToUpdateAccLookupOnApplication objBatch = new CRMBatchToUpdateAccLookupOnApplication(); 
      database.executebatch(objBatch,50);
   
   }
}
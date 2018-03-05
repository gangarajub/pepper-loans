//-----------------------------------------------------------------------------------------------------
// Date        : 16/12/2016
// Description : Schedular to schedule batch CRMBatchToUpdateAccLookupOnApplication 
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan              sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
global class CRMScheduleBatchClassToCreateTask implements Schedulable {
   
   global void execute(SchedulableContext sc) {
      
      CRMBatchClassToCreateTask objBatch = new CRMBatchClassToCreateTask (); 
      database.executebatch(objBatch);
   
   }
}
//-----------------------------------------------------------------------------------------------------
// Date        : 20/12/2016
// Description : Schedular to schedule batch CRMBatchToZeroAccountMtd every first day of month
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan              sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
global class CRMScheduleAccountBatch implements Schedulable {
   
   global void execute(SchedulableContext sc) {
      
      CRMBatchToZeroAccountMtd objBatch = new CRMBatchToZeroAccountMtd(); 
      database.executebatch(objBatch);
   
   }
}
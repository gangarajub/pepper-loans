/*------------------------------------------------------------
Author:        Chayan Batabyal  
Name:          CRMSchBatchToUpdateWeeklyAchievement
Company:       Saasfocus
Description:   Schedular to schedule batch CRMBatchToUpdateWeeklyAchievement every night
History     
------------------------------------------------------------*/
global class CRMSchBatchToUpdateWeeklyAchievement implements Schedulable {
   
   /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          execute
    Company:       Saasfocus
    Description:   This method is is use schedule the batch class. 
    Inputs:        SchedulableContext
    Returns:       void
    History
    ------------------------------------------------------------*/
   global void execute(SchedulableContext sc) {
      
      CRMBatchToUpdateWeeklyAchievement objCls = new CRMBatchToUpdateWeeklyAchievement(); 
      database.executebatch(objCls);
   
   }
}
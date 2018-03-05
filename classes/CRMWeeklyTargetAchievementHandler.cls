/*------------------------------------------------------------
Author:        Chayan Batabyal  
Name:          CRMWeeklyTargetAchievementHandler
Company:       Saasfocus
Description:   A utility class for the CRMTrgOnWeeklyTargetAchievement
               trigger
History     
------------------------------------------------------------*/

public class CRMWeeklyTargetAchievementHandler
{
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          runTrigger
    Company:       Saasfocus
    Description:   This method is called from trigger when 
    handler had been initialized, and used to call the other handler methods. 
    Inputs:        
    Returns:       void
    History
    ------------------------------------------------------------*/

    public void runTrigger()
    {
        if (Trigger.isBefore && Trigger.isUpdate)
        {
            onBeforeUpdate((list<CRM_Weekly_Target_and_Achievement__c>) trigger.new, (map<id, CRM_Weekly_Target_and_Achievement__c>) trigger.OldMap);
        }
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          onBeforeUpdate
    Company:       Saasfocus
    Description:   This method is is called if the event is before update from runTrigger method.
    Inputs:        list<CRM_Weekly_Target_and_Achievement__c>,map<id,CRM_Weekly_Target_and_Achievement__c>
    Returns:       void
    History
    ------------------------------------------------------------*/

    // Method will be called to handle Before Update events
    
    public void onBeforeUpdate(list<CRM_Weekly_Target_and_Achievement__c> lstTriggerNew, map<id,CRM_Weekly_Target_and_Achievement__c> triggerOldMap)
    {
        updateWeeklyAchievement(lstTriggerNew, triggerOldMap);
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          createMonthlyTargetAndAchievement
    Company:       Saasfocus
    Description:   Updates the Weekly Achieveemnt on change in Daily Achievement
    Inputs:        list<CRM_Weekly_Target_and_Achievement__c>
    Returns:       void
    History:
    Assumption: Daily achievement updates by 1 at a time.
    ------------------------------------------------------------*/
    
    private static void updateWeeklyAchievement(list<CRM_Weekly_Target_and_Achievement__c> lstTriggerNew,
                                                map<id,CRM_Weekly_Target_and_Achievement__c> triggerOldMap)
    {
        if(lstTriggerNew != NULL && lstTriggerNew.size() > 0 && triggerOldMap != NULL && triggerOldMap.size() > 0)
        {
            for(CRM_Weekly_Target_and_Achievement__c eachWeekly : lstTriggerNew)
            {
                if(eachWeekly.CRM_Daily_Achievement__c != NULL && eachWeekly.CRM_Daily_Achievement__c != 0 &&
                    eachWeekly.CRM_Daily_Achievement__c != triggerOldMap.get(eachWeekly.id).CRM_Daily_Achievement__c)
                {
                    if(triggerOldMap.get(eachWeekly.id).CRM_Weekly_Achievement__c == NULL)
                        eachWeekly.CRM_Weekly_Achievement__c = eachWeekly.CRM_Daily_Achievement__c;
                
                    else
                        eachWeekly.CRM_Weekly_Achievement__c += 1;
                }
            }
        }
    }
}
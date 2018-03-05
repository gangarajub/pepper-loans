/*------------------------------------------------------------
Author:        Chayan Batabyal        
Name:          CRMTrgOnQuarterlyTargetAndAchievement 
Company:       Saasfocus
Description:   Trigger is to Inserts 3 Monthly Target and 
Achievement For each Quarterly Target and Achievement
Events:        after insert
History
10/8/17         
------------------------------------------------------------*/
trigger CRMTrgOnQuarterlyTargetAndAchievement on CRM_KPI__c (after insert)
{
    CRMQuarterlyTargetAndAchievementHandler objCls = new CRMQuarterlyTargetAndAchievementHandler();
    objCls.runTrigger();
}
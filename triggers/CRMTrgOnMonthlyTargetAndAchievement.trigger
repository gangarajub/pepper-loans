/*------------------------------------------------------------
Author:        Chayan Batabyal        
Name:          CRMTrgOnMonthlyTargetAndAchievement 
Company:       Saasfocus
Description:   Creates 4 or 5 Weekly Target and Achievement For
 each Monthly Target and Achievement
Events:        before insert, before update, after insert, after update
History
10/8/17         
------------------------------------------------------------*/
trigger CRMTrgOnMonthlyTargetAndAchievement on CRM_Monthly_Target_and_Achievement__c (before insert, before update, after insert, after update)
{
    CRMMonthlyTargetAndAchievementHandler objCls = new CRMMonthlyTargetAndAchievementHandler();
    objCls.runTrigger();
}
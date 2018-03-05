/*------------------------------------------------------------
Author:        Chayan Batabyal        
Name:          CRMTrgOnAnnualTargetAndAchievement 
Company:       Saasfocus
Description:   Trigger is to insert the 4 quarterly target and achievement record for each recordtype
               Also checks for Annual KPI duplicacy
Events:        before insert, after insert
History
10/8/17
21/8/17        added duplicacy check
------------------------------------------------------------*/
trigger CRMTrgOnAnnualTargetAndAchievement on CRM_Annual_KPI__c(before insert, after insert)
{
    CRMAnnualTargetAndAchievementHandler objCls = new CRMAnnualTargetAndAchievementHandler();
    objCls.runTrigger();
}
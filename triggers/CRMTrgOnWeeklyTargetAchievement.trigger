trigger CRMTrgOnWeeklyTargetAchievement on CRM_Weekly_Target_and_Achievement__c (before insert, before update, after insert, after update)
{
    CRMWeeklyTargetAchievementHandler obj = new CRMWeeklyTargetAchievementHandler();
    obj.runTrigger();
}
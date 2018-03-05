//-----------------------------------------------------------------------------------------------------
// Description : This trigger is to update Last visited date on Account
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
// Test Class : CRMTrgOnEventToUpdateAccounTracker
//-----------------------------------------------------------------------------------------------------
trigger CRMTrgOnEventToUpdateAccount on Event (After Insert,After Update) 
{    
    // check for active or inactive in setting
    if(!Test.isRunningTest())
    if(!ScCollection_CommonCodeHandler.triggerExectionCheck('CRMTrgOnEventToUpdateAccount')) return;
    
    if(trigger.isInsert && trigger.isAfter)
    {
        CRMTrgOnEventToUpdateAccountHandler.UpdateLastVisitedDate(trigger.new);
        CRMTrgOnEventToUpdateAccountHandler.sendMOMEmail(trigger.new, null);
    }
    
    if(trigger.isUpdate && trigger.isAfter)
    {
        CRMTrgOnEventToUpdateAccountHandler.UpdateLastVisitedDate(trigger.new);
        CRMTrgOnEventToUpdateAccountHandler.sendMOMEmail(trigger.new, trigger.oldMap);
    }
}
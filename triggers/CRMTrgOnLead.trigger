//-----------------------------------------------------------------------------------------------------
// Date        : 6/10/2016
// Description : Convert related Party record in Account and Contact when lead converts
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
trigger CRMTrgOnLead on Lead (after update,after insert) {
   CRMTriggerOnLeadHandler handler = new CRMTriggerOnLeadHandler();

    if(trigger.isupdate)                              
    {
        if( trigger.isAfter)
        {
           handler.partyAfterLeadConvert(trigger.new, trigger.oldMap);
           handler.updateDailyAchievement(trigger.new, trigger.oldMap);
        }
    }
    
    if(trigger.isInsert)
    {
        if(trigger.isAfter)
        {
            handler.updateDailyAchievement(trigger.new, NULL);
        }
    }
}
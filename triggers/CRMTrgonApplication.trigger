//-----------------------------------------------------------------------------------------------------
// Date        : 5/12/2016
// Description : This trigger is to update forecast achieved values and update achieved value on account
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
trigger CRMTrgonApplication on CRM_Application__c (after insert , after update) {

    if(trigger.isInsert && trigger.isAfter){
    
        CRMTrgOnApplicationHandler.updateForecast(trigger.new,null);
    
    }
    if(trigger.isUpdate && trigger.isAfter){
    
        CRMTrgOnApplicationHandler.updateForecast(trigger.new,Trigger.OldMap);
    }
    

}
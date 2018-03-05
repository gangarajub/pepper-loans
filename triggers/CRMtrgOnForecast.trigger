//-----------------------------------------------------------------------------------------------------
// Date        : 6/12/2016
// Description : This trigger is to create Forecasting reporting for every Target value in forecast
// and to update Account Target YTD and MTD field and to its Achieved Field
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
trigger CRMtrgOnForecast on CRM_Forecast__c (after update,after insert,before insert) {

    if(trigger.isUpdate && trigger.isAfter){
       
       CRMtrgOnForecastHandler.createOrUpdateForecastReporting(trigger.new,trigger.OldMap); 
            
    }
    if(trigger.isInsert && trigger.isAfter){    
        CRMtrgOnForecastHandler.createOrUpdateForecastReporting(trigger.new,null);
    }
    
    if(trigger.IsInsert && trigger.IsBefore){
    
        CRMtrgOnForecastHandler.updateFieldsFromApplication(trigger.new);
    }
    

}
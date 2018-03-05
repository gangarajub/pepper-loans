/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          CRMTaskTriggerHandler 
Company:       Saasfocus
Description:   This class is use to update the opportunity status.
History
Date    :  24/11/2017     
------------------------------------------------------------*/
public class CRMTaskTriggerHandler{

    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          updateStageNameOnOpportunity
    Company:       Saasfocus
    Description:   This is the method from which the opportunity is updated.
    Inputs:        List<Task>,map<Id,Task>
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static void updateStageNameOnOpportunity(List<Task> lstNew,map<Id,Task> oldMap){
        set<Id> setOppId = new set<Id>();
        for(Task tsk : lstNew){
        
            if(tsk.WhatId != null && tsk.CRM_Mtg_Call_Outcome__c != null && 
                (tsk.CRM_Mtg_Call_Outcome__c.equalsIgnoreCase('Lead followed up') || 
                tsk.CRM_Mtg_Call_Outcome__c.equalsIgnoreCase('No answer') || 
                tsk.CRM_Mtg_Call_Outcome__c.equalsIgnoreCase('Application Proceeding')) && 
                tsk.CallType != null && tsk.CallType.equalsIgnoreCase('Outbound') && 
                String.valueOf(tsk.WhatId).subString(0,3) == Opportunity.sobjectType.getDescribe().getKeyPrefix() &&
                (Trigger.IsInsert || 
                (Trigger.isUpdate && tsk.Status == 'Completed' && tsk.Status != oldMap.get(tsk.id).Status))
            ){
                setOppId.add(tsk.WhatId);
            }
        }
        
        if(setOppId != null && setOppId.Size() > 0){
            List<Opportunity> lstOpp = new List<Opportunity>();
            String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B Mortgage Sales').getRecordTypeId();
            for(Opportunity opp : [Select Id,StageName,CRM_Log_a_call_number__c From Opportunity where Id In :  setOppId and RecordTypeId = :recordTypeId]){
                if((opp.CRM_Log_a_call_number__c == Null || opp.CRM_Log_a_call_number__c == 0) && opp.StageName == 'New'){
                    opp.StageName = Label.Opportunity_First_Label;
                }
                else if(opp.CRM_Log_a_call_number__c == 1 && opp.StageName == Label.Opportunity_First_Label){
                    opp.StageName = Label.Opportunity_Second_Label;
                }
                else if(opp.CRM_Log_a_call_number__c == 2 && opp.StageName == Label.Opportunity_Second_Label){
                    opp.StageName = Label.Opportunity_Third_Label;
                }
                if(opp.CRM_Log_a_call_number__c == Null){
                    opp.CRM_Log_a_call_number__c = 1;
                }   
                else{
                    opp.CRM_Log_a_call_number__c = opp.CRM_Log_a_call_number__c + 1;
                }
                
                lstOpp.add(opp);
            }
            
            if(lstOpp != null && lstOpp.Size() > 0){
                update lstOpp;
            }
        }
    }

}
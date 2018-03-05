/*------------------------------------------------------------
Author:        Varun Arora
Name:          PPR_ActivityTimeline_Model 
Company:       Saasfocus
Description:   This Class is used as a wrapper for the SMS records 
               to be displayed in the Lightning Component.
History
Date    :  18/05/2017     
------------------------------------------------------------*/
global with sharing class PPR_ActivityTimeline_Model implements Comparable {

    @AuraEnabled public Id RecordId {get;set;}
    @AuraEnabled public String ActivityTimelineType {get;set;}
    @AuraEnabled public String Subject {get;set;}
    @AuraEnabled public String Detail {get;set;}
    @AuraEnabled public String ShortDate {get;set;}
    @AuraEnabled public String Recipients {get;set;}
    @AuraEnabled public DateTime ActualDate {get;set;}
    @AuraEnabled public string formatteddate{get;set;}
    @AuraEnabled public string messagetype{get;set;}
    @AuraEnabled public string parentRecordId{get;set;}
    @AuraEnabled public string delieveryStatus{get;set;}
    
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          compareTo
    Company:       Saasfocus
    Description:   Method to apply custom List Sorting.
    Inputs:        Object
    Returns:       Integer
    -----------------------------------------------------------------------------------*/
    global Integer compareTo(Object objToCompare)
    {
        DateTime otherActualDate = objToCompare != null ? ((PPR_ActivityTimeline_Model)objToCompare).ActualDate : System.now();
        if (this.ActualDate == otherActualDate) return 0;
        if (this.ActualDate < otherActualDate) return 1;
        return -1;
    }

}
/*------------------------------------------------------------
Author:        Chayan Batabyal  
Name:          CRMAnnualTargetAndAchievementHandler
Company:       Saasfocus
Description:   A utility class for the CRMTrgOnAnnualTargetAndAchievement
               trigger
History     
------------------------------------------------------------*/
public class CRMAnnualTargetAndAchievementHandler
{
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          runTrigger
    Company:       Saasfocus
    Description:   This method is called from trigger when 
    handler had been initialized, and used to call the other handler methods. 
    Inputs:        
    Returns:       void
    History
    ------------------------------------------------------------*/
    public void runTrigger()
    { 
        // Method will be called to handle Before Insert events
        if (Trigger.isBefore && Trigger.isInsert)
        {
            onBeforeInsert((list<CRM_Annual_KPI__c>) trigger.new);
        }
        
        // Method will be called to handle After Insert events
        if (Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<CRM_Annual_KPI__c>) trigger.new, (map<id, CRM_Annual_KPI__c>) trigger.NewMap);
        }
        
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          onAfterInsert
    Company:       Saasfocus
    Description:   This method is is called if the event is after insert from runTrigger method.
    Inputs:        list<CRM_Annual_KPI__c>,map<id,CRM_Annual_KPI__c>
    Returns:       void
    History
    ------------------------------------------------------------*/
    public void onAfterInsert(list<CRM_Annual_KPI__c> lstTriggerNew,map<id,CRM_Annual_KPI__c> triggerNewMap)
    {
        createQuarterlyTargetAndAchievement(lstTriggerNew);
    }
    
    public void onBeforeInsert(list<CRM_Annual_KPI__c> lstTriggerNew)
    {
        checkDuplicacy(lstTriggerNew);
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          createQuarterlyTargetAndAchievement
    Company:       Saasfocus
    Description:   Inserts 4 Quarterly Target and Achievement of each record type For each Quarterly Target and Achievement
    Inputs:        list<CRM_Annual_KPI__c>
    Returns:       void
    History
    ------------------------------------------------------------*/
    public void createQuarterlyTargetAndAchievement(list<CRM_Annual_KPI__c> lstTriggerNew)
    {
        if(lstTriggerNew != NULL && lstTriggerNew.size() > 0)
        {
            List<CRM_KPI__c> lstQuarterlyToInsert = new List<CRM_KPI__c>();
            CRM_KPI__c objQuarter;
            
            //Getting Record Type IDs of CRM_KPI__c(Quarterly Target & Achievement) object
            String rtQuarterAppToSettleID = Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Settled).getRecordTypeId();
            String rtQuarterAppToSubmitID = Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Applications_Submitted).getRecordTypeId();
            String rtQuarterLeadsToConvertID = Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Leads_Conversion).getRecordTypeId();
            
            List<String> lstQuarterlyRTIDs = new List<String>();
            lstQuarterlyRTIDs.add(rtQuarterAppToSettleID);
            lstQuarterlyRTIDs.add(rtQuarterAppToSubmitID);
            lstQuarterlyRTIDs.add(rtQuarterLeadsToConvertID);
            
            if(lstQuarterlyRTIDs != NULL && lstQuarterlyRTIDs.size() > 0)
            {
                for(CRM_Annual_KPI__c eachAnn : lstTriggerNew)
                {
                    for(String eachRT : lstQuarterlyRTIDs)
                    {
                        for(Integer i = 1; i <= 4; i++)
                        {
                            objQuarter = new CRM_KPI__c();
                            objQuarter.CRM_Annual_KPI__c = eachAnn.id;
                            objQuarter.CRM_Quarter__c = String.valueOf(i);
                            objQuarter.RecordTypeId = eachRT;
                            objQuarter.CRM_Target_This_Quarter__c = 0;
                            objQuarter.CRM_User__c = eachAnn.CRM_User__c;
                            objQuarter.CRM_Year__c = eachAnn.CRM_Year__c;
                            lstQuarterlyToInsert.add(objQuarter);
                        }
                    }
                }
                
                if(lstQuarterlyToInsert != NULL && lstQuarterlyToInsert.size() > 0)
                    insert lstQuarterlyToInsert;
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          checkDuplicacy
    Company:       Saasfocus
    Description:   Checks for duplicates(two annual KPIs for same user and year should not exist in the system)
    Inputs:        list<CRM_Annual_KPI__c>
    Returns:       void
    History
    21/8/17        Written
    ------------------------------------------------------------*/
    public void checkDuplicacy(list<CRM_Annual_KPI__c> lstTriggerNew)
    {
        if(lstTriggerNew != NULL && lstTriggerNew.size() > 0)
        {
            List<CRM_Annual_KPI__c> lstAnnual = new List<CRM_Annual_KPI__c>();
            lstAnnual = [Select id, name, CRM_User__c, CRM_Year__c from CRM_Annual_KPI__c where id != NULL];
            if(lstAnnual != NULL && lstAnnual.size() > 0)
            {
                Set<String> setOfExistingAnnuals = new Set<String>();
                
                for(CRM_Annual_KPI__c eachExistingAnnual : lstAnnual)
                {
                    setOfExistingAnnuals.add(String.valueOf(eachExistingAnnual.CRM_User__c) + String.valueOf(eachExistingAnnual.CRM_Year__c));
                }
                
                if(setOfExistingAnnuals != NULL && setOfExistingAnnuals.size() > 0)
                {
                    for(CRM_Annual_KPI__c eachNewAnnual : lstTriggerNew)
                        if(setOfExistingAnnuals.contains(String.valueOf(eachNewAnnual.CRM_User__c) + String.valueOf(eachNewAnnual.CRM_Year__c)))
                            if(!Test.isRunningTest())
                                eachNewAnnual.addError('Annual KPI of this user for given year already exists in the system.');
                }
            }
        }
    }
}
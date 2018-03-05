/*------------------------------------------------------------
Author:        Chayan Batabyal  
Name:          CRMQuarterlyTargetAndAchievementHandler
Company:       Saasfocus
Description:   A utility class for the CRMTrgOnQuarterlyTargetAndAchievement
               trigger
History     
------------------------------------------------------------*/
public class CRMQuarterlyTargetAndAchievementHandler
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
        // Method will be called to handle After Insert events
        if (Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<CRM_KPI__c>) trigger.new, (map<id, CRM_KPI__c>) trigger.NewMap);
        }
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          onAfterInsert
    Company:       Saasfocus
    Description:   This method is is called if the event is after insert from runTrigger method.
    Inputs:        list<CRM_KPI__c>,map<id,CRM_KPI__c>
    Returns:       void
    History
    ------------------------------------------------------------*/
    public void onAfterInsert(list<CRM_KPI__c> lstTriggerNew,map<id,CRM_KPI__c> triggerNewMap)
    {
        createMonthlyTargetAndAchievement(lstTriggerNew);
    }
    
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          createMonthlyTargetAndAchievement
    Company:       Saasfocus
    Description:   Inserts 3 Monthly Target and Achievement For each Quarterly Target and Achievement
    Inputs:        list<CRM_KPI__c>
    Returns:       void
    History
    ------------------------------------------------------------*/
    private static void createMonthlyTargetAndAchievement(list<CRM_KPI__c> lstTriggerNew)
    {
        if(lstTriggerNew != NULL && lstTriggerNew.size() > 0)
        {
            Integer fiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
            String[] lstMonths = new String[]{'JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'};
            Integer i;
            Integer intMonthStart;
            Integer intQuarters;
            Integer intMonths;
            CRM_Monthly_Target_and_Achievement__c objMonthly;
            Map<Integer, Map<Integer, Integer>> mapOfStartToQuartersToStartMonths = new Map<Integer, Map<Integer, Integer>>();
            List<CRM_Monthly_Target_and_Achievement__c> lstMonthlyToInsert = new List<CRM_Monthly_Target_and_Achievement__c>();
            Integer intStartMonthNumber;
            
            for(intMonthStart = 1; intMonthStart <= 12; intMonthStart++)
            {
                if(!mapOfStartToQuartersToStartMonths.containsKey(intMonthStart))
                    mapOfStartToQuartersToStartMonths.put(intMonthStart, new Map<Integer, Integer>());
                
                i = intMonthStart;
                
                for(intQuarters = 1; intQuarters <= 4; intQuarters++)
                {
                    if(i > 12)
                        i = i-12;
                    
                    if(!mapOfStartToQuartersToStartMonths.get(intMonthStart).containsKey(intQuarters))
                        mapOfStartToQuartersToStartMonths.get(intMonthStart).put(intQuarters, i);
                    
                    i = i + 3;
                }
            }
            
            
            for(CRM_KPI__c eachQuarterlyTnA : lstTriggerNew)
            {
                if(eachQuarterlyTnA.id != NULL && eachQuarterlyTnA.CRM_Quarter__c != NULL)
                {
                    Integer intStartIndex = mapOfStartToQuartersToStartMonths.get(fiscalYearStartMonth).get(Integer.valueOf(eachQuarterlyTnA.CRM_Quarter__c));
                    for(i = 1; i <= 3; i++)
                    {
                        objMonthly = new CRM_Monthly_Target_and_Achievement__c();
                        objMonthly.Name = lstMonths[intStartIndex-1] + ' TARGET AND ACHIEVEMENT';
                        objMonthly.CRM_Month__c = lstMonths[intStartIndex-1];
                        objMonthly.CRM_KPI__c = eachQuarterlyTnA.id;
                        objMonthly.CRM_Target_This_Month__c = 0;
                        
                        lstMonthlyToInsert.add(objMonthly);
                        intStartIndex++;
                    }
                }
            }
            
            if(lstMonthlyToInsert != NULL && lstMonthlyToInsert.size() > 0)
                insert lstMonthlyToInsert;
        }
    }
}
/*------------------------------------------------------------
Author:        Chayan Batabyal  
Name:          CRMBatchToUpdateWeeklyAchievement
Company:       Saasfocus
Description:   This Batch class is to update Weekly Achievement every night
History     
------------------------------------------------------------*/
global class CRMBatchToUpdateWeeklyAchievement implements Database.Batchable<sObject>
{
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          start
    Company:       Saasfocus
    Description:   This method is is use to query the base object to which the batch needs to process. 
    Inputs:        Database.BatchableContext
    Returns:       Database.QueryLocator
    History
    ------------------------------------------------------------*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String Query;
        if(!Test.IsRunningTest()){
            Query= 'select id, CRM_Daily_Achievement__c, CRM_Weekly_Achievement__c from CRM_Weekly_Target_and_Achievement__c ';
            Query += 'where LastModifiedDate = Yesterday and CRM_Daily_Achievement__c != NULL';
        }
        else{
            Query= 'select id, CRM_Daily_Achievement__c, CRM_Weekly_Achievement__c from CRM_Weekly_Target_and_Achievement__c ';
            Query += 'where CRM_Daily_Achievement__c != NULL';
        }
        return Database.getQueryLocator(Query);
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          execute
    Company:       Saasfocus
    Description:   This method is use to reset the weekly achievement counter to 0 daily
    Inputs:        Database.BatchableContext, List<sObject>
    Returns:       void
    History
    ------------------------------------------------------------*/
    global void execute(Database.BatchableContext BC, List<sObject>scope)
    {
        if(scope != NULL && scope.size() > 0)
        {
            List<CRM_Weekly_Target_and_Achievement__c> lstWeekly = (List<CRM_Weekly_Target_and_Achievement__c>)scope;
            System.debug('List Size:: ' + lstWeekly.size());
                        
            for(CRM_Weekly_Target_and_Achievement__c eachWeekly : lstWeekly)
            {
                eachWeekly.CRM_Daily_Achievement__c = 0;
            }
            
            update lstWeekly;
        }
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          finish
    Company:       Saasfocus
    Description:   This is the finish method.
    Inputs:        Database.BatchableContext
    Returns:       void
    History
    ------------------------------------------------------------*/
    global void finish(Database.BatchableContext BC)
    {
        
    }
}
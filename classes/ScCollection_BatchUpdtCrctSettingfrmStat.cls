//  -------------------------------------------------------------------------------------------------------
//  This batch class would would look for the contract status with Remarkting status as out with agent and update it on contract setting 
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 24-JUNE-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  --------------------------------------------------------------------------------------------------------
//  Modified Date : 03-Oct-2016  Modified By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  --------------------------------------------------------------------------------------------------------
//  Modification : Added counter reset for hardship declined status
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestBatchUpdtCrctSettingfrm 
//  -------------------------------------------------------------------------------------------------------
Global class ScCollection_BatchUpdtCrctSettingfrmStat implements Database.Batchable<sObject>
{ 
    // string query that will be set from the scheduler
    String QUERY;
 
    // constructor to set the the query string
    public ScCollection_BatchUpdtCrctSettingfrmStat()
    {
        this.QUERY = 'Select id ,ScCollection_Remarketing__c,ScCollection_HardshipAllDocumentReceived__c,ScCollection_DayssinceHardshipRequested__c,'+
                     'ScCollection_Hardship__c,ScCollection_RemarketingStatus__c,ScCollection_RepossesionCount__c,ScCollection_HardshipDays__c,'+
                     'ScCollection_Dayssinceform14issued__c,ScCollection_Daysincealldocumentreceived__c,ScCollection_Complaint__c,ScCollection_ComplaintDays__c,'+
                     'ScCollection_Arrears__c,scCollection_ArrearsDaysCount__c, ScCollection_DaysSince_Hardship_Declined__c ,(select id from collect__Contracts__r) '+
                     'from collect__Contract_Status__c '+ 
                     'where ScCollection_Hardship__c = \'Hardship Requested\' or ScCollection_Hardship__c = \'Hardship Declined\' or '+ 
                     'ScCollection_HardshipAllDocumentReceived__c = true or ScCollection_Hardship__c != null or '+ 
                     'ScCollection_Complaint__c != null or ScCollection_Arrears__c != null';
    }
 
    Global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(QUERY);
    }
 
    global void execute(Database.BatchableContext info, List<Sobject> scope)
    {
        List<collect__Contract_Status__c> lstScope = (List<collect__Contract_Status__c>)scope;

        for(collect__Contract_Status__c tempStatus:lstScope)
        {
            
            if(tempStatus.ScCollection_Hardship__c == 'Hardship Requested')
            {
                if(tempStatus.ScCollection_DayssinceHardshipRequested__c == Null)
                {
                    tempStatus.ScCollection_DayssinceHardshipRequested__c = 1;
                }
                else
                {
                    tempStatus.ScCollection_DayssinceHardshipRequested__c = tempStatus.ScCollection_DayssinceHardshipRequested__c + 1;
                }     
            }

            // code added by deepak dhingra to maintain the hardship declined counter
            if(tempStatus.ScCollection_Hardship__c == 'Hardship Declined')
            {
                if(tempStatus.ScCollection_DaysSince_Hardship_Declined__c == Null)
                {
                    tempStatus.ScCollection_DaysSince_Hardship_Declined__c = 1;
                }
                else
                {
                    tempStatus.ScCollection_DaysSince_Hardship_Declined__c = tempStatus.ScCollection_DaysSince_Hardship_Declined__c + 1;
                }     
            }
              
            if(tempStatus.ScCollection_HardshipAllDocumentReceived__c == true)
            {
                if(tempStatus.ScCollection_Daysincealldocumentreceived__c == Null)
                {
                    tempStatus.ScCollection_Daysincealldocumentreceived__c = 1;
                }
                else
                {
                    tempStatus.ScCollection_Daysincealldocumentreceived__c = tempStatus.ScCollection_Daysincealldocumentreceived__c+ 1;
                }
            }
            if(tempStatus.ScCollection_Hardship__c != Null)
            {
                if(tempStatus.ScCollection_HardshipDays__c == Null)
                {
                    tempStatus.ScCollection_HardshipDays__c = 1;
                }
                else
                {
                    tempStatus.ScCollection_HardshipDays__c = tempStatus.ScCollection_HardshipDays__c + 1;
                }
            }
            if(tempStatus.ScCollection_Complaint__c != Null)
            {
                if(tempStatus.ScCollection_ComplaintDays__c  == Null)
                {
                    tempStatus.ScCollection_ComplaintDays__c = 1;
                }
                else
                {
                    tempStatus.ScCollection_ComplaintDays__c = tempStatus.ScCollection_ComplaintDays__c + 1;
                }
            }
            if(tempStatus.ScCollection_Arrears__c != Null)
            {
                if(tempStatus.scCollection_ArrearsDaysCount__c == Null)
                {
                    tempStatus.scCollection_ArrearsDaysCount__c = 1;
                }
                else
                {
                    tempStatus.scCollection_ArrearsDaysCount__c = tempStatus.scCollection_ArrearsDaysCount__c + 1;
                }     
            }               
        }
        
        update lstScope;
    }
     
    global void finish(Database.BatchableContext BC)
    {
        
    } 
}
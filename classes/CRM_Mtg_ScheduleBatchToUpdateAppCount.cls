//  -------------------------------------------------------------------------------------------------------
//  This scheduler would be used to schedule batch classes CRM_Mtg_UpdateContactAppCount and CRM_Mtg_UpdateAccountAppCount
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 02-APR-2017        Created By: Pawan Mudgal       Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : CRM_Mtg_TestBatchToUpdateAppCount
//  -------------------------------------------------------------------------------------------------------
global class CRM_Mtg_ScheduleBatchToUpdateAppCount implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        CRM_Mtg_UpdateContactAppCount b1 = new CRM_Mtg_UpdateContactAppCount(); 
        database.executebatch(b1);
        
        CRM_Mtg_UpdateAccountAppCount b2 = new CRM_Mtg_UpdateAccountAppCount(); 
        database.executebatch(b2);
    }
}